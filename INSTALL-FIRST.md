---
title: Install First
type: guide
tags: [onboarding, setup]
---

# 📦 Install First — only 2 things, ~10 minutes

> You install **two** things by hand. After that, open the folder and your AI does the rest
> *inside the chat* — you just click **Allow** when it asks. Powered by OTIUM AI Consultant.

---

## 1) Claude Code — the app your AI lives in

**Easiest (no terminal): the Desktop app.**
- Go to **claude.com/download** → download for **Mac** or **Windows** → install like any app.

**Or the one-line installer** (copy → paste → Enter):
- **Mac / Linux** — open the **Terminal** app and paste:
  ```
  curl -fsSL https://claude.ai/install.sh | bash
  ```
- **Windows** — open **PowerShell** and paste:
  ```
  irm https://claude.ai/install.ps1 | iex
  ```

Sign in when it opens (use your Claude account — a paid plan is recommended so the Google
connector works in step 3 of onboarding).

---

## 2) Node.js — a small helper a couple of the plugins need

1. Go to **nodejs.org**
2. Click the big green **LTS** button to download.
3. Open the downloaded file → **Next → Next → Finish** (just accept the defaults).

That's the technical part done. ✅

---

## 3) Open your AI OS and say hi

1. Get this folder onto your computer:
   - In **VS Code**: *Clone Git Repository* → paste the repo link, **or**
   - Download the **ZIP** from the repo and unzip it.
2. Open the folder in **Claude Code** (Desktop app: *Open folder*; or `cd` into it and run `claude`).
3. Type anything — even **"hi"**.

Your AI takes over from here: it installs its own skills, helps you connect Google in your
browser, and organizes your vault. When it asks to do something, just click **Allow**.

> The hard part is over. Everything past this point happens inside the chat.
> Stuck on steps 1–2? Reply to OTIUM and we'll do them with you on a quick screen-share.

## Connected
- [[README]]
- [[CLAUDE]]
- [[SETUP-PLAYBOOK]]
