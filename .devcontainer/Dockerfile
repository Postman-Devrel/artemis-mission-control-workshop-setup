FROM mcr.microsoft.com/devcontainers/javascript-node:1-22-bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Postman CLI, installed system-wide (/usr/local/bin) while still root
RUN curl -fsSL https://dl-cli.pstmn.io/install/unix.sh | sh \
    && postman --version

USER node

ENV PATH="/home/node/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash -s stable \
    && claude --version

# Postman plugin for Claude Code, from Postman's own marketplace. Installed at
# build time (into /home/node/.claude) so codespace creation has nothing to
# download. Fails the build if it does not install.
RUN claude plugin marketplace add postmanlabs/postman-plugin \
    && claude plugin install postman@postman \
    && claude plugin list | grep -q postman
