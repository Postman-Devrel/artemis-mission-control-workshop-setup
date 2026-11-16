# Agent Workshop Codespace

A ready-to-use GitHub Codespace with the Postman CLI, Claude Code and the Postman plugin preinstalled. Claude is already authenticated for the workshop.

This page only covers launching and configuring your environment. After that, follow the LiftOff module "Artemis Mission Control: Agent Edition".

## 1. Get access

Do these three steps in order.

1. Fill in the registration form: [[registration form link](https://docs.google.com/forms/d/e/1FAIpQLSeixKe-IDm92o8VK8xXAoDkpw1fqsZPA15qyUBtybzR-ivYvg/viewform)]. Your instructor shares it.
2. Accept the GitHub invitation at https://github.com/postman-devrel-workshops/artemis-mission-control-workshop-setup/invitations. It also arrives by email.
3. Then create your codespace (next section).

> Accept the invitation **before** you create the codespace. A codespace created earlier will not have Claude configured. If that happened, delete it and create a new one.

## 2. Create your codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup)

Or on the repo page: **Code** > **Codespaces** > **Create codespace on main**. A 2-core machine is enough.

The first build takes a few minutes. Wait until the terminal is ready.

## 3. Sign in to Postman with your API key

Use your own Postman account. A free account works.

1. Go to postman.com, click your avatar, then **Settings** > **API keys** > **Generate API Key**.
2. Copy the key. It is shown only once.
3. In the codespace terminal, run:

```bash
read -s POSTMAN_API_KEY && postman login --with-api-key "$POSTMAN_API_KEY" && unset POSTMAN_API_KEY
```

`read -s` hides what you type. Nothing appears while you paste. Press Enter when done. The key never lands in your shell history or in a file.

The first time you paste, your browser may ask for clipboard permission. Allow it.

## 4. Check your setup

```bash
postman --version
claude --version
claude
```

Claude asks whether you trust the folder. Choose yes. Send a quick prompt such as "Say hello" to confirm it answers. Then quit:

```text
/exit
```

The Postman plugin is already installed. If the module tells you to run `npx @postman/postman-plugin@latest install`, skip it.

## 5. Start the module

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

## 6. If your codespace stopped

Codespaces stop after a period of inactivity. Reopen yours from https://github.com/codespaces, then:

```bash
cd artemis-mission-control-agent
read -s ARTEMIS_API_KEY && export ARTEMIS_API_KEY
claude --continue
```

Your Postman login is kept.

## 7. After the workshop

Your access to this repo is removed and the shared Claude key is disabled. To continue on your own machine, follow the "Before you start" section of the module (local install).

Delete your codespace at https://github.com/codespaces.

## Troubleshooting

- **Claude asks you to log in:** you created the codespace before accepting the invitation. Delete it and create a new one.
- **Postman says "not logged in":** redo step 3.
- **Validation says no workspace found:** you started `claude` from the wrong folder. Run `cd artemis-mission-control-agent` and try again.
