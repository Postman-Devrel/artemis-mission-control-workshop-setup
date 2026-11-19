#!/usr/bin/env bash
# Runs when the container is created. With a prebuild, this runs once in the
# prebuild, not in each attendee codespace. Keep it free of personal data:
# no secret, no login, nothing tied to the attendee.
# Every step is non-fatal: a failure here must never abort codespace creation.
set -u

if claude plugin marketplace add postmanlabs/postman-plugin \
  && claude plugin install postman@postman; then
  echo "Postman plugin installed"
else
  echo "Postman plugin install failed; run: claude plugin marketplace add postmanlabs/postman-plugin && claude plugin install postman@postman"
fi

exit 0
