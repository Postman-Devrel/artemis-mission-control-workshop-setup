#!/usr/bin/env bash
# Runs once after the Codespace container is created.
# Every step is non-fatal: a failure here must never abort codespace creation.
set -u

# The Postman plugin for Claude Code is baked into the image (see Dockerfile).
# Fallback only: install it if it is missing (e.g. an older image).
if ! claude plugin list 2>/dev/null | grep -q postman; then
  if claude plugin marketplace add postmanlabs/postman-plugin \
    && claude plugin install postman@postman; then
    echo "Postman plugin installed"
  else
    echo "Postman plugin install failed; run: claude plugin marketplace add postmanlabs/postman-plugin && claude plugin install postman@postman"
  fi
fi

cat <<'BANNER'

========================================
 Next step: run the command from your workshop page in this terminal.
 It looks like:
      ./start <workshop> <your-postman-api-key>
 It connects Claude Code and the Postman CLI. No other setup is needed.
========================================
BANNER

exit 0
