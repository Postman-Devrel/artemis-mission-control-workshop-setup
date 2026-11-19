#!/usr/bin/env bash
# Configures Claude Code (through the workshop LLM gateway) and the Postman CLI.
#
#   --auto   Non-interactive, used by postCreateCommand. Reads WORKSHOP_KEY and
#            POSTMAN_API_KEY from the Codespaces secrets, never prompts, never
#            fails: a failure here must never abort codespace creation.
#   (none)   Interactive, used by ./start. Prompts for anything missing, with
#            hidden input. Safe to run again at any time.
#
# Secrets are never printed, never written to shell history, and never passed
# to curl on the command line.
set -u

AUTO=0
[ "${1:-}" = "--auto" ] && AUTO=1

GATEWAY_URL="${WORKSHOP_GATEWAY_URL:-https://postman-devrel-s-fabric-team.dp.fabricgateway.ai/anthropic}"
GATEWAY_URL="${GATEWAY_URL%/}"
GATEWAY_HEADER="${WORKSHOP_GATEWAY_HEADER:-fg-api-key}"
TEST_MODEL="${WORKSHOP_TEST_MODEL:-claude-haiku-5-5}"
# Default model of Claude Code. The workshop key only allows Sonnet and Haiku,
# so Claude Code must not start on Opus (its default on some plans).
DEFAULT_MODEL="${WORKSHOP_DEFAULT_MODEL:-sonnet}"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

CLAUDE_OK=0
POSTMAN_OK=0

ok()   { printf '  [ok]   %s\n' "$*"; }
warn() { printf '  [!]    %s\n' "$*"; }
info() { printf '         %s\n' "$*"; }

# Removes spaces, line breaks and quotes picked up by copy-paste, and a pasted
# "fg-api-key:" prefix.
normalize_key() {
  local k
  k="$(printf '%s' "$1" | tr -d '\r\n\t "'"'")"
  k="${k#"$GATEWAY_HEADER":}"
  printf '%s' "$k"
}

ask_secret() { # $1 = prompt; prints the answer on stdout
  local answer=""
  printf '%s' "$1" >&2
  IFS= read -rs answer || true
  printf '\n' >&2
  printf '%s' "$answer"
}

# Prints the HTTP status of one tiny call to the gateway (000 = unreachable).
# The key goes through curl's stdin config, not argv, so `ps` never shows it.
gateway_status() {
  printf 'header = "%s: %s"\n' "$GATEWAY_HEADER" "$1" \
    | curl -sS -o /dev/null -w '%{http_code}' --max-time 20 --config - \
        -X POST "$GATEWAY_URL/v1/messages" \
        -H 'anthropic-version: 2023-06-01' \
        -H 'content-type: application/json' \
        -d "{\"model\":\"$TEST_MODEL\",\"max_tokens\":1,\"messages\":[{\"role\":\"user\",\"content\":\"ping\"}]}" \
        2>/dev/null || true
}

# Writes the gateway settings in the `env` block of ~/.claude/settings.json
# (it wins over shell exports) and skips the Claude Code onboarding.
write_claude_settings() {
  WS_KEY="$1" WS_URL="$GATEWAY_URL" WS_HEADER="$GATEWAY_HEADER" WS_MODEL="$DEFAULT_MODEL" node -e '
    const fs = require("fs");
    const home = process.env.HOME;
    const readJson = (p) => { try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return {}; } };

    fs.mkdirSync(home + "/.claude", { recursive: true });
    const settingsPath = home + "/.claude/settings.json";
    const s = readJson(settingsPath);
    s.model = process.env.WS_MODEL;
    s.env = Object.assign({}, s.env, {
      ANTHROPIC_BASE_URL: process.env.WS_URL,
      // Any value works: the gateway ignores it, Claude Code then skips its login screen.
      ANTHROPIC_AUTH_TOKEN: "workshop-gateway",
      ANTHROPIC_CUSTOM_HEADERS: process.env.WS_HEADER + ": " + process.env.WS_KEY,
    });
    fs.writeFileSync(settingsPath, JSON.stringify(s, null, 2) + "\n", { mode: 0o600 });
    fs.chmodSync(settingsPath, 0o600);

    const statePath = home + "/.claude.json";
    const c = readJson(statePath);
    c.hasCompletedOnboarding = true;
    fs.writeFileSync(statePath, JSON.stringify(c, null, 2) + "\n");
  '
}

save_claude_settings() {
  if write_claude_settings "$1"; then
    CLAUDE_OK=1
  else
    warn "Could not write $CLAUDE_SETTINGS. Run ./start again, or tell your instructor."
    return 1
  fi
}

claude_already_configured() {
  [ -f "$CLAUDE_SETTINGS" ] && grep -q '"ANTHROPIC_CUSTOM_HEADERS"' "$CLAUDE_SETTINGS"
}

setup_claude() {
  echo "Claude Code"
  local key="${WORKSHOP_KEY:-}" tries=0 status
  key="$(normalize_key "$key")"

  while :; do
    if [ -z "$key" ]; then
      if [ "$AUTO" = 1 ]; then
        if claude_already_configured; then
          ok "Already configured."
          CLAUDE_OK=1
        else
          warn "No workshop key found. Run ./start and paste the key your instructor shares."
        fi
        return 0
      fi
      key="$(normalize_key "$(ask_secret '  Paste the workshop key (hidden), then press Enter: ')")"
      [ -z "$key" ] && { warn "Skipped. Run ./start again when you have the key."; return 0; }
    fi

    status="$(gateway_status "$key")"
    case "$status" in
      200)
        save_claude_settings "$key" && ok "Connected to the workshop gateway."
        return 0 ;;
      401|403)
        warn "The workshop key was rejected (HTTP $status): mistyped, expired or revoked."
        if [ "$AUTO" = 1 ]; then
          info "Run ./start and paste the key again."
          return 0
        fi
        tries=$((tries + 1))
        if [ "$tries" -ge 3 ]; then
          info "Ask your instructor for the current key."
          return 0
        fi
        key="" ;;
      429)
        save_claude_settings "$key" || return 0
        warn "Key saved, but its usage limit is reached right now (HTTP 429). Tell your instructor."
        return 0 ;;
      *)
        # Could not verify (network, gateway or model policy). Save anyway:
        # Claude Code shows the real error if it persists.
        save_claude_settings "$key" || return 0
        warn "Key saved but not verified (HTTP $status). If Claude does not answer, tell your instructor."
        return 0 ;;
    esac
  done
}

setup_postman() {
  echo "Postman CLI"
  local key="${POSTMAN_API_KEY:-}"
  key="$(printf '%s' "$key" | tr -d '\r\n\t "'"'")"

  if [ -z "$key" ]; then
    if [ "$AUTO" = 1 ]; then
      warn "No Postman API key found. Run ./start to sign in."
      return 0
    fi
    info "Generate a key at https://go.postman.co/settings/me/api-keys"
    key="$(ask_secret '  Paste your Postman API key (hidden, Enter to skip): ')"
    key="$(printf '%s' "$key" | tr -d '\r\n\t "'"'")"
    [ -z "$key" ] && { warn "Skipped."; return 0; }
  fi

  case "$key" in
    PMAK-*) ;;
    *) warn "This does not look like a Postman API key (they start with PMAK-). Trying anyway." ;;
  esac

  if postman login --with-api-key "$key" >/dev/null 2>&1; then
    ok "Signed in to Postman."
    POSTMAN_OK=1
  else
    warn "Postman sign-in failed. Check the key, or generate a new one, then run ./start again."
  fi
}

echo
echo "Workshop setup"
setup_claude
setup_postman

echo
if [ "$CLAUDE_OK" = 1 ] && [ "$POSTMAN_OK" = 1 ]; then
  echo "All set. Open the LiftOff module and follow it from this terminal."
else
  echo "Not finished yet: run ./start in the terminal to complete the setup."
fi
echo

exit 0
