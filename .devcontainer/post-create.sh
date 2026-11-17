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

cat <<'BANNER'

========================================
 Next step: run the command from your workshop page in this terminal.
 It looks like:
      ./start <workshop> <your-postman-api-key>
 It connects Claude Code and the Postman CLI. No other setup is needed.
========================================
BANNER

exit 0
