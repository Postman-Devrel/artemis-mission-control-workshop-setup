# Agent Workshop Codespace

A ready-to-use GitHub Codespace with the Postman CLI, Claude Code and the Postman plugin preinstalled. Claude runs through the workshop gateway, so you don't need an Anthropic account.

This page only covers launching your environment. After that, follow the LiftOff module "Artemis Mission Control: Agent Edition".

## What you need

- A GitHub account (free).
- A Postman account (free) and an API key. Generate one at **https://go.postman.co/settings/me/api-keys**, then copy it. It starts with `PMAK-` and is shown only once.
- The **workshop key**. Your instructor shares it at the start of the session.

## 1. Create your codespace

Open **https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup**

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup)

At the bottom of the page, fill in the two fields:

| Field | Value |
| --- | --- |
| `WORKSHOP_KEY` | The workshop key from your instructor |
| `POSTMAN_API_KEY` | Your Postman API key (`PMAK-...`) |

Then click **Create codespace**. Leave the other options as they are.

GitHub saves both values as secrets in your own account, only for this repo. Nobody else sees them.

## 2. Wait for "All set"

The codespace opens in your browser. The setup runs on its own and ends with `All set` in the terminal.

If you see `Not finished yet`, or if you skipped a field, run this in the terminal and paste what it asks for:

```bash
./start
```

Nothing appears while you paste: input is hidden. Press Enter when done. The first time you paste, your browser may ask for clipboard permission. Allow it.

## 3. Check Claude

```bash
claude
```

Claude asks whether you trust the folder. Choose yes. Send a quick prompt such as "Say hello" to confirm it answers. Then quit:

```text
/exit
```

The Postman plugin is already installed. If the module tells you to run `npx @postman/postman-plugin@latest install`, skip it.

## 4. Start the module

Open the LiftOff module in your own browser, next to the codespace: [LiftOff module link]

Three tips for working in a codespace.

**Folder.** Run the module's commands from the codespace terminal. The module creates an `artemis-mission-control-agent` folder inside this repo. That is expected. Always go into it before you start Claude, especially in a new terminal:

```bash
cd artemis-mission-control-agent
claude
```

**Artemis API key.** When the module asks where to keep your key, choose **Option B (Env var)**. Quit Claude with `/exit` first, then run:

```bash
read -s ARTEMIS_API_KEY && export ARTEMIS_API_KEY
claude --continue
```

**Dashboard.** To view `mission-dashboard.html`, right-click it in the Explorer and choose **Show Preview**. It opens in a new browser tab: if your browser blocks it, allow pop-ups for this page. A codespace has no local browser, so `open` does not work.

## 5. If your codespace stopped

Codespaces stop after a period of inactivity. Reopen yours from https://github.com/codespaces, then:

```bash
cd artemis-mission-control-agent
read -s ARTEMIS_API_KEY && export ARTEMIS_API_KEY
claude --continue
```

Your Claude and Postman setup is kept.

## 6. After the workshop

The workshop key stops working after the session. To continue on your own machine, follow the "Before you start" section of the module (local install).

Clean up:

- Delete your codespace at https://github.com/codespaces.
- Delete the `WORKSHOP_KEY` and `POSTMAN_API_KEY` secrets at https://github.com/settings/codespaces.

## Troubleshooting

- **The two fields are not on the creation page:** create the codespace anyway, then run `./start`.
- **"The workshop key was rejected":** the key was mistyped, or the session is over. Run `./start` and paste it again. If it still fails, ask your instructor.
- **"usage limit is reached":** tell your instructor.
- **Claude asks you to log in:** run `./start`.
- **Postman says "not logged in":** run `./start` and paste your Postman API key. You can generate a new one at https://go.postman.co/settings/me/api-keys.
- **Validation says no workspace found:** you started `claude` from the wrong folder. Run `cd artemis-mission-control-agent` and try again.

## For instructors

The setup is in [.devcontainer](.devcontainer):

- `Dockerfile` and `on-create.sh` install the tools. They hold no personal data, so a prebuild can cache them.
- `configure.sh` (run by `postCreateCommand` and by `./start`) checks the workshop key with one small call to the gateway, writes the gateway settings in `~/.claude/settings.json`, and signs in to Postman. It never prints a secret.
- The gateway URL is `WORKSHOP_GATEWAY_URL` in `devcontainer.json`. The header name defaults to `fg-api-key` (override with `WORKSHOP_GATEWAY_HEADER`).
