---
title: Setup Playbook
type: playbook
tags: [onboarding, setup]
---

# Build Your Own AI OS — Setup Playbook

> Powered by **OTIUM AI Consultant** — *"Get Your Time Back."*
> This playbook turns Claude Code into your personal **AI Operating System**: a single brain that knows your business, remembers your decisions, lives inside your Obsidian notes, and can act in your Google Workspace.

**What you'll have at the end**
- Claude Code supercharged with plugins (skills, memory, context-efficiency).
- Your AI connected to **Obsidian** (your knowledge vault).
- Your AI connected to **Google Workspace** (Gmail, Calendar, Drive, Docs, Sheets).
- A personalized OS built by the AI itself when you run the **`onboard`** skill.

**Time required:** ~45–60 minutes. Only **Part C (Google)** is genuinely technical — OTIUM can do that part with you on a screen-share if you prefer.

> **🚀 Fastest path — just run `/onboard`.** This folder ships with an `onboard` skill that
> walks you through everything below **in the right order**: it connects your tools first
> (plugins + Obsidian, optionally Google), restarting as needed, **then** interviews you and
> builds your OS. Open this folder in Claude Code, type `/onboard`, and follow along.
>
> **This playbook is the manual `onboard` follows** — read it for the background, to do the
> steps by hand, or if you get stuck. (It also ships `grill-me` and `session-handoff` skills.)

---

## Before you start (Prerequisites)

Install these once. If you already have them, skip.

| Need | What it is | Get it |
|---|---|---|
| **Claude Code** | The AI agent you'll run everything in | claude.com/claude-code |
| **Obsidian** | Your notes app / knowledge vault | obsidian.md |
| **Node.js 18+** | Runs the Obsidian + Google connectors (`npx`, `gws`) | nodejs.org (LTS) |
| **A Google account** | Gmail / Workspace — free accounts work | — |

> **Tip:** This folder should be BOTH your AI OS **and** your Obsidian vault. In Obsidian, choose *"Open folder as vault"* and point it at **this folder**.

---

## Part A — Install the Claude Code plugins (10 min)

Open Claude Code **in this folder**, then run these commands **one block at a time**. Two of them (claude-mem, context-mode) live in their own marketplace, so you add the marketplace first, then install.

```text
# Superpowers — disciplined AI workflows (one-liner, official marketplace)
/plugin install superpowers@claude-plugins-official

# Skill Creator — lets your AI build its own custom skills for your business
/plugin install skill-creator@claude-plugins-official

# Claude Mem — long-term cross-session memory
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack

# Context Mode — context efficiency on big reads (own marketplace)
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
```

Then **restart Claude Code** and run `/plugin` to confirm all are listed and enabled.

**What each one does:**
- **Superpowers** — gives your AI a library of disciplined workflows (planning, debugging, code review, brainstorming). Your AI gets *better habits*, not just answers.
- **Skill Creator** — your AI can package any repeatable workflow you have into a reusable "skill" it runs on command. This is how your OS grows over time.
- **claude-mem** — long-term memory. Your AI remembers past sessions, decisions, and work across days/weeks instead of forgetting every time you close it.
- **context-mode** — context efficiency. Heavy files, web pages, and command output are processed in a sandbox so your AI stays fast and only keeps what matters. (~90% fewer tokens on big reads.)

### Bonus power-ups (optional — add when you need them)

```text
# Frontend Design — polished, non-AI-looking UI (only if you build web pages/apps)
/plugin install frontend-design@claude-plugins-official

# GSD (Get Shit Done) — structured project workflow: plan → execute → verify
# NOTE: separate installer, not a plugin. Heavier — add only for multi-step build projects.
npx get-shit-done-cc --claude --global
```

- **`/review` and `/ultra-review`** are **built into** Claude Code (v2.1.86+) — **no install needed**. Run `/review` to have your AI hunt for real bugs in code changes before you ship.

---

## Part B — Connect Obsidian (10 min)

**Step 1 — Get your Obsidian key.**
In Obsidian: **Settings → Community plugins → Browse →** install **"Local REST API" →** enable it → open its settings → **copy the API Key**.

**Step 2 — Add the connector.** In your terminal, run (replace the path and key):

```bash
claude mcp add obsidian -s user \
  -e OBSIDIAN_API_KEY=<YOUR_OBSIDIAN_API_KEY> \
  -- npx -y mcp-obsidian "/ABSOLUTE/PATH/TO/THIS/FOLDER"
```

> Prefer editing config by hand? Add this block under `mcpServers` in `~/.claude.json` instead:
> ```json
> "obsidian": {
>   "type": "stdio",
>   "command": "npx",
>   "args": ["-y", "mcp-obsidian", "/ABSOLUTE/PATH/TO/THIS/FOLDER"],
>   "env": { "OBSIDIAN_API_KEY": "<YOUR_OBSIDIAN_API_KEY>" }
> }
> ```

**Step 3 — Verify.** Restart Claude Code and ask: *"List the files in my Obsidian vault."* If it lists your notes, you're connected.

---

## Part C — Connect Google Workspace via the `gws` CLI (15–20 min) — the one technical part

We use **Google's own Google Workspace CLI** — [`@googleworkspace/cli`](https://github.com/googleworkspace/cli), the `gws` command. It covers Gmail, Calendar, Drive, Docs, Sheets, Chat and more, and returns structured JSON the AI reads directly. (Requires **Node.js 18+** and a **Google account**.)

**Step 1 — Install the CLI:**
```bash
npm install -g @googleworkspace/cli
```
Optional — add Google's ready-made agent skills so your AI has a recipe for every Workspace API:
```bash
npx skills add https://github.com/googleworkspace/cli
```

**Step 2 — Set up + authenticate:**
```bash
gws auth setup     # walks you through the Google Cloud project + OAuth config
gws auth login     # opens a URL — sign in, approve the scopes
```
`gws auth setup` handles the Google Cloud project and OAuth credentials for you — no manual "create an OAuth client" dance. If your account isn't allowed yet, open the [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent) → **Test users** → add your Google email, then retry `gws auth login`.

> Tip: your AI can run these for you and even drive the sign-in — it opens the URL, you pick your account and approve, and it takes back over once the browser hands control back.

**Step 3 — Verify:**
```bash
gws drive files list --params '{"pageSize": 5}'
```
If it lists files (or returns an empty list with no error), you're connected. From now on the AI calls `gws` to read and write your Gmail, Calendar, and Drive.

> ⚠️ This is the only step that can trip people up (Google Cloud is fiddly). If you get stuck, stop here and book the OTIUM setup call — we'll finish it with you.

---

## Part D — Build your AI OS (run `onboard`) (15 min)

Everything's installed. Now the AI builds your operating system **for** you.

1. In Claude Code (open in this folder), start a **fresh chat**.
2. Run the onboarding skill — type **`/onboard`** or just say **"onboard me"**.
3. Answer its 7 questions. When it finishes, it has written your `CLAUDE.md`, your `context/`
   files, your voice profile, and linked everything into your Obsidian graph.
4. Then ask it: **"What should I focus on this week?"** — that's the moment it clicks.

> No `onboard` skill showing up? Make sure you opened Claude Code **in this folder** (the
> skill lives in `.claude/skills/onboard/`). As a fallback, use the manual prompt in the
> Appendix below.

---

## Part E — Verify everything works (5 min)

- [ ] `/plugin` shows **superpowers**, **skill-creator**, **claude-mem**, **context-mode** enabled.
- [ ] *"List my Obsidian files"* → returns your notes.
- [ ] *"What's on my Google Calendar this week?"* → returns events.
- [ ] After `onboard`: `CLAUDE.md` has your real name/business (no more `{{...}}` placeholders), and `context/` is filled.
- [ ] Open Obsidian → **Graph view** → your notes are connected (not scattered dots).
- [ ] Start a **brand-new chat** → the AI greets you as your AI OS and references your business. ✅

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `/plugin install` can't find the plugin | Re-run the matching `marketplace add` line first (for claude-mem / context-mode), then restart Claude Code. |
| `onboard` skill not available | Confirm you opened Claude Code **in this folder**; the skill is at `.claude/skills/onboard/SKILL.md`. |
| Obsidian connector returns nothing | Confirm the **Local REST API** plugin is **enabled**, the **API key matches**, and the **vault path is absolute** (no `~`). |
| Google sign-in "access blocked" | Add your email as a **Test user** on the [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent), then retry `gws auth login`. |
| `gws` / `npx` "command not found" | Install **Node.js 18+** (Prerequisites), then `npm install -g @googleworkspace/cli`, then restart your terminal. |
| AI forgets context next session | Confirm **claude-mem** is enabled, and that **CLAUDE.md** exists in the folder you opened. |

---

## What's next (OTIUM follow-ups)

Once the OS is alive, the real value is **automations**. Bring OTIUM your most repetitive
weekly task and we'll turn it into a one-command skill inside your OS (built with Skill Creator).

> Need a hand with any step? Reply to OTIUM and we'll jump on a screen-share.

---

## Appendix — Manual bootstrap prompt (fallback if `onboard` won't load)

If the `onboard` skill isn't available, paste this into a fresh chat instead:

```text
You are about to become my personal AI Operating System. We are in a folder that is also my
Obsidian vault. Interview me with these 7 questions (one at a time, in my language):
1) Who I am, what I sell, who I sell to. 2) Paste 1-2 things I've written recently (raw, don't
let me retype). 3) My top 2-3 priorities for the next 90 days. 4) Where revenue lands and is
tracked. 5) Where I talk to customers/team/world. 6) Where notes & docs live. 7) The task that
eats my week + where I track work.
Then scaffold: CLAUDE.md (operating rules + my answers), context/about-me.md,
context/about-business.md, context/priorities.md, references/voice.md (my pasted samples),
connections.md, tasks/todo.md, decisions/log.md, and OS-INDEX.md. Connect notes with
[[wikilinks]] + tags so Obsidian builds a graph. Add a standing rule: every session, read
CLAUDE.md and tasks/todo.md and surface reminders/deadlines first. Finish with a 3-line
summary and tell me to ask "what should I focus on this week?". Begin question 1 now.
```

## Connected
- [[CLAUDE]]
- [[README]]
- [[connections]]
- [[OS-INDEX]]
