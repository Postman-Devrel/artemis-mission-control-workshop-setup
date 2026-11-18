# Agent Workshop Codespace

A ready-to-use GitHub Codespace with the Postman CLI, Claude Code and the Postman plugin preinstalled. Claude Code is connected to the workshop AI gateway by one command (`./start`).

This page only covers launching and configuring your environment. After that, follow the LiftOff module "Artemis Mission Control: Agent Edition".

## 1. Create your codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup?quickstart=1)

Open https://codespaces.new/postman-devrel-workshops/artemis-mission-control-workshop-setup?quickstart=1 and sign in with your GitHub account. You do not need an invitation. A 2-core machine is enough.

The codespace starts from a prebuilt image, so it is ready in about a minute. Wait until the terminal is ready.

## 2. Register on the workshop page

1. Open the workshop page on LiftOff (your instructor shares the link).
2. Connect your Postman API key (postman.com > avatar > **Settings** > **API keys** > **Generate API Key**; a free account works).
3. Click **Join the workshop**.

## 3. Run the start command

The workshop page shows two blocks, each with a copy button: a command, then your Postman API key (masked on screen, the button copies the real value). In the codespace terminal, paste the command and press Enter:

```bash
./start <workshop>
```

It asks for your Postman API key with hidden input: nothing appears while you paste. Paste the key from the second block and press Enter. The script connects Claude Code to the workshop AI gateway, checks it works, and signs the Postman CLI in. The key never appears in the terminal or in your shell history.

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

Open the LiftOff module in your own browser, next to the codespace: the **Open the module** button on the workshop page (or https://www.postman.com/liftoff/modules/artemis-mission-control-agent)

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
- **`./start` says the key was not accepted:** generate a new Postman API key, join the workshop again with it on the workshop page, and run the command with it.
- **Claude hangs, then fails with 401:** run `./start` again. Do not type the gateway settings by hand: a single wrong character makes Claude retry silently before failing.
- **Postman says "not logged in":** run `./start` again.
- **Validation says no workspace found:** you started `claude` from the wrong folder. Go back to the folder where you started the module and try again.

## Maintainers: the prebuilt image

Codespaces prebuilds are not available on this organization's plan, so `.devcontainer/devcontainer.json` pulls a prebuilt image instead of building the Dockerfile for every participant:

`ghcr.io/postman-devrel-workshops/artemis-mission-control-workshop-image:latest`

The image contains the Postman CLI, Claude Code and the Postman plugin for Claude Code (installed as the `node` user, in `/home/node/.claude`). `post-create.sh` only installs the plugin if it is missing, then prints the next-step banner.

**Rebuilds.** The `Build workshop image` workflow (`.github/workflows/build-image.yml`) builds `.devcontainer/Dockerfile` and pushes two tags: `latest` and the 7-character commit SHA. It runs on pushes to `main` that touch `.devcontainer/**`, every Monday at 05:00 UTC, and on demand (Actions > Build workshop image > Run workflow). `latest` is a moving tag and the Postman CLI and Claude Code are installed from their latest/stable channels, so rebuilding the same commit can give a different image. To roll back, retag a previous SHA tag as `latest`, or point `devcontainer.json` at a SHA tag.

**One-time setup.** After the first successful run, make the package public, otherwise participants without access to this repo cannot pull it: https://github.com/orgs/postman-devrel-workshops/packages/container/artemis-mission-control-workshop-image/settings > Danger Zone > Change visibility > Public. Also check that the package is linked to this repository.

**Testing a change.** Change the Dockerfile on a branch, then:

```bash
docker build -t artemis-test .devcontainer
docker run --rm -it -u node artemis-test bash -lc 'postman --version; claude --version; claude plugin list'
```

To try it in a real codespace before merging, run the workflow manually on the branch (the `latest` tag is overwritten, so do this only when no workshop is running), or temporarily point `image` in `devcontainer.json` at your own test tag.
