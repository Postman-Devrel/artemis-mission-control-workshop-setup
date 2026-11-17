# Agent Workshop Codespace

A ready-to-use GitHub Codespace with the Postman CLI, Claude Code and the Postman plugin preinstalled. Claude Code is connected to the workshop AI gateway by one command (`./start`).

This page only covers launching and configuring your environment. After that, follow the LiftOff module "Artemis Mission Control: Agent Edition".

## 1. Create your codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup?quickstart=1)

Open https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup?quickstart=1 and sign in with your GitHub account. You do not need an invitation. A 2-core machine is enough.

The first build takes a few minutes. Wait until the terminal is ready.

## 2. Register on the workshop page

1. Open the workshop page on LiftOff (your instructor shares the link).
2. Connect your Postman API key (postman.com > avatar > **Settings** > **API keys** > **Generate API Key**; a free account works).
3. Click **Join the workshop**.

## 3. Run the start command

The workshop page shows a command that looks like this. Copy it from the page (the button copies your real key), paste it into the codespace terminal and press Enter:

```bash
./start <workshop> <your-postman-api-key>
```

It connects Claude Code to the workshop AI gateway, checks it works, and signs the Postman CLI in. If you run `./start` with no arguments, it asks for the two values; the key is hidden while you type.

Your Postman key is not stored by the workshop server. It only goes to Postman (to verify it) and to the Postman CLI in this codespace.

> The AI gateway access is shared for the workshop and has a spending cap. It is readable from inside your codespace, so do not reuse it elsewhere. It stops working after the workshop.

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

Two tips for working in a codespace.

**Artemis API key.** When the module asks where to keep your key, choose **Option B (Env var)**. Quit Claude with `/exit` first, then run:

```bash
read -s ARTEMIS_API_KEY && export ARTEMIS_API_KEY
claude --continue
```

**Dashboard.** To view `mission-dashboard.html`, right-click it in the Explorer and choose **Show Preview**. It opens in a new browser tab: if your browser blocks it, allow pop-ups for this page. A codespace has no local browser, so `open` does not work.

## 6. If your codespace stopped

Codespaces stop after a period of inactivity. Reopen yours from https://github.com/codespaces, then:

```bash
read -s ARTEMIS_API_KEY && export ARTEMIS_API_KEY
claude --continue
```

Your Claude and Postman setup is kept. If you deleted the codespace and created a new one, run the `./start` command from the workshop page again.

## 7. After the workshop

The shared AI gateway access is disabled. To continue on your own machine, follow the "Before you start" section of the module (local install).

Delete your codespace at https://github.com/codespaces.

## Troubleshooting

- **`./start` says you are not registered:** do step 2 first, with the same Postman API key, then run the command again.
- **`./start` says the key was not accepted:** generate a new Postman API key and run the command with it.
- **Claude hangs, then fails with 401:** run `./start` again. Do not type the gateway settings by hand: a single wrong character makes Claude retry silently before failing.
- **Postman says "not logged in":** run `./start` again.
- **Validation says no workspace found:** you started `claude` from the wrong folder. Go back to the folder where you started the module and try again.
