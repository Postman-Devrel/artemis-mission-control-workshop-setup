#!/usr/bin/env bash
# Runs once after the Codespace container is created.
# Every step is non-fatal: a failure here must never abort codespace creation.
set -u

# Postman plugin for Claude Code, from Postman's own marketplace.
if claude plugin marketplace add postmanlabs/postman-plugin \
  && claude plugin install postman@postman; then
  echo "Postman plugin installed"
else
  echo "Postman plugin install failed; run: claude plugin marketplace add postmanlabs/postman-plugin && claude plugin install postman@postman"
fi

# Claude Code: if ANTHROPIC_API_KEY is set, pre-approve it and skip onboarding
# so users can open `claude` and start prompting without logging in.
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  if node -e '
    const fs = require("fs");
    const p = process.env.HOME + "/.claude.json";
    let c = {};
    try { c = JSON.parse(fs.readFileSync(p, "utf8")); } catch {}
    c.hasCompletedOnboarding = true;
    c.customApiKeyResponses = c.customApiKeyResponses || {};
    const approved = new Set(c.customApiKeyResponses.approved || []);
    approved.add(process.env.ANTHROPIC_API_KEY.slice(-20));
    c.customApiKeyResponses.approved = [...approved];
    c.customApiKeyResponses.rejected = c.customApiKeyResponses.rejected || [];
    fs.writeFileSync(p, JSON.stringify(c, null, 2));
  '; then
    echo "Claude Code configured to use ANTHROPIC_API_KEY"
  else
    echo "Claude Code key setup failed; run claude and log in manually"
  fi
else
  echo "ANTHROPIC_API_KEY is not set."
  echo "  The workshop key is only injected for collaborators who accepted the repo invitation."
  echo "  Accept it at https://github.com/${GITHUB_REPOSITORY:-<owner>/<repo>}/invitations, then create (or rebuild) this codespace."
  echo "  Otherwise, run: claude and log in manually."
fi

cat <<'BANNER'

========================================
 Next steps
 1. Sign in to Postman (your API key stays out of shell history):
      read -s POSTMAN_API_KEY && postman login --with-api-key "$POSTMAN_API_KEY" && unset POSTMAN_API_KEY
 2. Start Claude Code:
      claude
========================================
BANNER

exit 0
