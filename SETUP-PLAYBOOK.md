---
title: Setup Playbook
type: playbook
tags: [onboarding, setup]
---

# Build Your Own AI OS — Setup Playbook

> Powered by **OTIUM AI Consultant** — *"Get Your Time Back."*
> This playbook turns Claude Code into your personal **AI Operating System**: a single brain that knows your business, remembers your decisions, lives inside your Obsidian notes, and can act in your Google Workspace.

> **🚀 Fastest path — you barely touch this file.**
> 1. Do the two installs in **`INSTALL-FIRST.md`** (Claude Code + Node.js).
> 2. Open this folder in Claude Code and type anything — the **`onboard`** skill runs the rest
>    *for* you: it installs its plugins, has you open the vault, and connects Google in your browser.
>
> This playbook is the manual `onboard` follows — read it for the background, to do a step by
> hand, or if you get stuck. Almost nothing here needs a terminal.

---

## Before you start (Prerequisites)

Just two, both covered step-by-step in **`INSTALL-FIRST.md`**:

| Need | What it is | Get it |
|---|---|---|
| **Claude Code** | The app your AI runs in (Desktop app = no terminal) | claude.com/download |
| **Node.js 18+** | A helper a couple of plugins need | nodejs.org → **LTS** |

You'll also want **Obsidian** (obsidian.md) for the graph view, and a **Google account** on a
Claude plan that includes connectors (e.g. Pro / Max / Team) for the Google step.

> **Tip:** this folder is both your AI OS **and** your Obsidian vault. In Obsidian choose
> *"Open folder as vault"* and point it at **this folder**.

---

## Part A — Install the Claude Code plugins (10 min)

Open Claude Code **in this folder**, then paste these into the chat **one block at a time**. (These are slash commands you type — not terminal commands.) Two live in their own marketplace, so you add the marketplace first, then install.

```text
# Superpowers — disciplined AI workflows
/plugin install superpowers@claude-plugins-official

# Skill Creator — lets your AI build its own custom skills for your business
/plugin install skill-creator@claude-plugins-official

# Claude Mem — long-term cross-session memory
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack

# Context Mode — context efficiency on big reads
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
```

Then **restart Claude Code** and run `/plugin` to confirm they're enabled.

**What each one does:**
- **Superpowers** — a library of disciplined workflows (planning, debugging, review). Better habits, not just answers.
- **Skill Creator** — package any repeatable workflow of yours into a reusable skill. This is how your OS grows.
- **claude-mem** — long-term memory. Remembers past sessions, decisions, and work across days/weeks.
- **context-mode** — context efficiency: big files, web pages, and command output processed in a sandbox (~90% fewer tokens on big reads).

### Bonus power-up (optional)
```text
# Frontend Design — polished, non-AI-looking UI (only if you build web pages/apps)
/plugin install frontend-design@claude-plugins-official
```
`/review` is **built into** Claude Code (v2.1.86+) — no install. Run it to have your AI hunt bugs in code changes.

---

## Part B — Open this folder as an Obsidian vault (2 min)

There's **nothing to connect** — your AI reads and writes your notes directly as files. Obsidian
just gives you the nice graph view on top.

1. Open **Obsidian** → **"Open folder as vault"** → choose **this folder**.
2. Open **Graph view** to watch your notes link up as the OS fills in.

That's it — no plugin, no API key, no terminal. (Your AI keeps the graph alive by writing
`[[wikilinks]]` and tags into the notes, whether Obsidian is open or not.)

---

## Part C — Connect Google via Claude's built-in connector (5 min) — all in the browser

We use **Claude's own Google connectors** — Gmail, Google Calendar, Google Drive — authorized
in your browser. **No terminal, no Node, no Google Cloud project.**

1. In Claude Code, run **`/mcp`** and connect the **Google** tools (Gmail, Calendar, Drive) —
   or enable them under your Claude **Connectors** settings.
2. A browser window opens → **sign in to Google** → **Allow**. Done — remembered after.
3. **Verify:** ask your AI *"What's on my Google Calendar this week?"* If it answers, you're connected.

> Needs a Claude plan that includes connectors (e.g. Pro / Max / Team). On a plan without them,
> skip this for now — the OS still works, and you can connect Google later.
>
> ⚠️ If the Google tools don't appear, finish connecting in `/mcp` / Connectors, then retry. Stuck?
> Book the OTIUM setup call — we'll finish it with you.

---

## Part D — Build your AI OS (run `onboard`) (15 min)

Setup's done. Now the AI builds your operating system **for** you.

1. In Claude Code (open in this folder), start a **fresh chat**.
2. Run the onboarding skill — type **`/onboard`** or just say **"onboard me"** (on a fresh OS it
   starts on its own). It first double-checks setup, then learns about you — **two ways, both
   optional:** answer a few questions (skip any), or just **drop a file** (company profile, bio,
   deck, past emails) into the chat and it'll read it.
3. Then ask it: **"What should I focus on this week?"** — that's the moment it clicks.

---

## Part E — Verify everything works (5 min)

- [ ] `/plugin` shows **superpowers**, **skill-creator**, **claude-mem**, **context-mode** enabled.
- [ ] Obsidian → **Graph view** → your notes are connected (not scattered dots).
- [ ] *"What's on my Google Calendar this week?"* → returns events.
- [ ] After `onboard`: `CLAUDE.md` has your real name/business (no more `{{...}}` placeholders), and `context/` is filled.
- [ ] Start a **brand-new chat** → the AI greets you as your AI OS and references your business. ✅

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `/plugin install` can't find the plugin | Re-run the matching `marketplace add` line first (for claude-mem / context-mode), then restart Claude Code. |
| `onboard` skill not available | Confirm you opened Claude Code **in this folder**; the skill is at `.claude/skills/onboard/SKILL.md`. |
| Plugin install errors / memory not working | Make sure **Node.js 18+** is installed (`INSTALL-FIRST.md` step 2), then restart Claude Code. |
| Google tools don't appear | Connect them via **`/mcp`** or Claude **Connectors**, and make sure your Claude plan includes connectors. Then retry the calendar question. |
| Notes don't show in Obsidian | Make sure you did **"Open folder as vault"** on **this** folder. The AI still edits the files even if Obsidian is closed. |
| AI forgets context next session | Confirm **claude-mem** is enabled and **CLAUDE.md** exists in the folder you opened. |

---

## What's next (OTIUM follow-ups)

Once the OS is alive, the real value is **automations**. Bring OTIUM your most repetitive weekly
task and we'll turn it into a one-command skill inside your OS (built with Skill Creator).

> Need a hand with any step? Reply to OTIUM and we'll jump on a screen-share.

---

## Appendix — Manual bootstrap prompt (fallback if `onboard` won't load)

If the `onboard` skill isn't available, paste this into a fresh chat instead:

```text
You are about to become my personal AI Operating System. We are in a folder that is also my
Obsidian vault. First confirm setup: the plugins (Superpowers, claude-mem, context-mode) are
installed, this folder is open as an Obsidian vault, and Google is connected via Claude's
connector. Then interview me with these 7 questions (one at a time, in my language; I can skip
any, or instead paste/attach a file about my business for you to read): 1) Who I am, what I
sell, who I sell to. 2) 1-2 things I've written recently (raw). 3) My top 2-3 priorities for
the next 90 days. 4) Where revenue lands and is tracked. 5) Where I talk to customers/team/world.
6) Where notes & docs live. 7) The task that eats my week + where I track work.
Then scaffold: CLAUDE.md, context/about-me.md, context/about-business.md, context/priorities.md,
references/voice.md, connections.md, tasks/todo.md, decisions/log.md, OS-INDEX.md. Connect notes
with [[wikilinks]] + tags. Add a standing rule: every session, read CLAUDE.md and tasks/todo.md
and surface reminders/deadlines first. Finish with a 3-line summary and tell me to ask
"what should I focus on this week?". Begin now.
```

## Connected
- [[INSTALL-FIRST]]
- [[CLAUDE]]
- [[README]]
- [[connections]]
- [[OS-INDEX]]
