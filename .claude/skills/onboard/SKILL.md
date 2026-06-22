---
name: onboard
description: Use on the FIRST session of this AI OS — automatically, before responding to any other request — and whenever someone says "set me up", "onboard me", "install my OS", or opens this folder for the first time. The full installer: FIRST does the strict setup in a fixed order with no skipping — install the plugins (Superpowers, claude-mem, context-mode), open this folder as an Obsidian vault, and connect Google Workspace via Claude's built-in browser connector (no terminal, no Node, no Google Cloud) — THEN learns about the user via optional questions OR a file they drop in to be ingested, and scaffolds the Day-1 files. Setup is strict; the intake is optional. Resumable across restarts and idempotent.
---

## What this skill does

This is the **installer for the whole OS**, and it runs in two phases — **in this exact order**:

1. **Phase 0 — Setup first (strict).** Install the plugins (Superpowers, claude-mem, context-mode; + skill-creator), make sure this folder is open as an **Obsidian vault**, and **connect Google** (Gmail / Calendar / Drive) via Claude's built-in connector — **before anything else**, in a fixed order, no skipping, no asking which to do first. On the first session this runs automatically, before any other request.
2. **Phase 1+ — Then learn.** Only once setup passes: an optional interview (or ingest a file the user drops in), then scaffold the Day-1 file set.

**The order is deliberate and non-negotiable: setup BEFORE questions.** A half-set-up OS that starts interviewing feels broken and fragmented ("rantakan"). A fully-wired one feels fluent from the first minute. Never reverse this.

**Almost no terminal.** The only things the user installs by hand are Claude Code and Node.js (see `INSTALL-FIRST.md`). Everything in this skill happens inside the chat: plugin installs are slash commands the user types, Google is a browser click, Obsidian is opening a folder. You guide and verify — you don't make the user run shell commands.

**Resumable.** Plugin installs need a Claude Code restart, so this skill is built to be re-run. After a restart the user just runs `/onboard` again (or says "continue onboarding") — each run re-checks state and continues from the first unmet step.

## When NOT to run this

- Already fully set up and wants to refresh context only: still run, but Phase 0 detects everything is ✓ and jumps to the interview/scaffold.
- Wants to add ONE thing later: they can re-run `/onboard` (it resumes at the missing step) or just ask.

---

## Phase 0 — Setup first (BEFORE any interview question)

**Goal of this phase:** plugins installed (**Superpowers, claude-mem, context-mode**; + skill-creator) · this folder open as an **Obsidian vault** · **Google connected** (Gmail / Calendar / Drive). Work them in this fixed order, automatically — **do not ask which to set up first, do not offer to skip to the questions.** Do not enter Phase 1 until setup passes.

### 0.1 — Detect current state (read-only, silent)

Run these checks first — they exist only so re-runs resume cleanly, never to ask the user what to do. Show a short ✓/▢ status, then immediately work each ▢ item in order:

- **Node.js present?** `command -v node`. If missing, the memory plugin can't run — point the user to `INSTALL-FIRST.md` step 2 (nodejs.org → LTS) and pause until it's installed.
- **Plugins:** read `~/.claude/plugins/installed_plugins.json` → look for keys containing `superpowers`, `claude-mem`, `context-mode` (and `skill-creator`).
- **Google:** are Claude's Google connector tools available this session (Gmail / Google Calendar / Google Drive)? If yes, Google is connected. If those tools aren't present, it isn't yet.
- **Obsidian:** can't be verified programmatically — confirm with the user in 0.3.

```
Setup status:
  [✓] Plugins installed
  [▢] Obsidian vault open   ← doing this now
  [▢] Google connected      ← then this
```

### 0.2 — Install the plugins (user types the commands; you verify)

You **cannot** run `/plugin ...` yourself — those are user-typed slash commands and need a restart to load. Guide, then verify:

1. Ask the user to paste these into Claude Code, one block at a time:
   ```
   /plugin install superpowers@claude-plugins-official
   /plugin install skill-creator@claude-plugins-official
   /plugin marketplace add thedotmack/claude-mem
   /plugin install claude-mem@thedotmack
   /plugin marketplace add mksglu/context-mode
   /plugin install context-mode@context-mode
   ```
2. Tell them to **restart Claude Code**, then run `/onboard` again to continue.
3. On the next run, re-read `installed_plugins.json`. If the three required — **superpowers, claude-mem, context-mode** — are present → mark Plugins ✓ (skill-creator is recommended too; install it but don't block on it). If a required one is missing → name exactly which and the matching command; don't move on.

### 0.3 — Open this folder as an Obsidian vault (no MCP, no key)

The OS reads and writes your notes **directly as files** — there's no connector to install. Obsidian is just the nice graph view on top.

1. Ask the user to open Obsidian → **"Open folder as vault"** → pick **this folder**. (Skip if they already did.)
2. Confirm they've done it (you can't verify it from here — a yes/no is fine). Mark Obsidian ✓.
3. Note: whether or not Obsidian is open, you still keep the graph alive by writing `[[wikilinks]]` + `tags:` into the notes (see Phase 2).

### 0.4 — Connect Google via Claude's built-in connector (required)

This uses **Claude's own Google connectors** — Gmail, Google Calendar, Google Drive — authorized in the browser. **No terminal, no Node, no Google Cloud project.**

1. Ask the user to connect Google in Claude Code: run **`/mcp`** and connect the Google tools (Gmail, Calendar, Drive), **or** enable them in their Claude **Connectors** settings. A browser window opens → they sign in → **Allow**.
   - This needs a Claude plan that includes connectors (e.g. Pro / Max / Team). If they're on a plan without connectors, record Google as `blocked: no connector on current plan` in `connections.md` and continue (see step 3).
2. **Verify:** once connected, list their next few calendar events (via the Google Calendar connector). If it returns → mark Google ✓. If the Google tools still aren't available, the connector isn't enabled yet — have them finish connecting.
3. **Google is required, not optional** — keep working it until it passes. Only if it's *genuinely* blocked right now (no connector on their plan, or they have no Google account on hand) do you record `blocked: <reason>` in `connections.md` and continue, saying you'll finish it the moment the blocker clears. A stuck step is the rare exception, never the default exit.

### 0.5 — The gate

Do **NOT** start Phase 1 until **setup passes — plugins (Superpowers, claude-mem, context-mode) + Obsidian vault open + Google connected** (the only exception: a genuinely-blocked Google, recorded as `blocked:` in `connections.md`). If the user tries to jump straight to the questions, hold the line firmly but kindly: setup runs first, in full, because that's what makes the OS fluent instead of fragmented — and it's now mostly clicks, not commands. Don't negotiate the order or skip items. Then continue Phase 0.

---

## Phase 1 — Learn about you (two ways — both optional)

Only after Phase 0's gate. This is how the OS learns the business — and **nothing here is mandatory.** Offer a choice and let the user give as much or as little as they want:

> "Now I'll get to know your business so I can actually be useful. Two easy ways — pick either, do both, or skip:
> **A) Answer a few quick questions** — 7 of them, and you can skip any.
> **B) Just drop a file** — a company profile, your bio, a pitch deck, an 'about me' doc, even a couple of past emails. Paste the text or attach the file right here in the chat and I'll read it and pull out what I need.
> Want to skip for now? Fine — I'll learn as we work, and you can run `/onboard` again or drop files anytime."

### Path B — Ingest a file or pasted text
1. When the user attaches a file or pastes long text, **read and distill it** (use context-mode for anything large, so it stays efficient — don't dump the whole file into the conversation).
2. Extract into the same buckets the questions cover: who they are / offer / ideal customer · priorities · where revenue lands · where they communicate · where docs live · biggest time-sink — and their **writing voice** (infer it from how the document is written).
3. Write what you confidently extracted into the Phase 2 files. Mark anything uncertain as a `TODO:` rather than guessing.
4. Keep the original — save the raw file to `archives/sources/` so nothing is lost.
5. Recap briefly ("here's what I learned / here's what's still missing"), then offer to fill gaps with a couple of targeted questions — still optional.

### Path A — The questions (one at a time; any can be skipped)
Make it explicit that **"skip" / "pass" / "later" is a valid answer to any question.** Write answers into `aios-intake.md` as you go. Match the user's language.

- **Q1 — Who are you, what do you sell, who do you sell it to?**
- **Q2 — How do you sound? *(optional, recommended)*** The OS sounds like you only if it has real samples. Recommended: paste 1-2 things you've written recently (an email, a post), **raw and unedited** — pasted samples beat prose typed mid-chat, which is already shaped by our conversation. Rather not? Skip it — I just won't write in your voice until you give me samples (add them anytime).
- **Q3 — Your 2-3 biggest priorities for the next 90 days?** Nudge toward a number, deadline, or deliverable.
- **Q4 — Where does revenue land, and where is it tracked?**
- **Q5 — Where do you talk to customers, your team, and the outside world?**
- **Q6 — Where do meeting recordings, notes, and important docs live?**
- **Q7 — What's the one task that eats your week, and where do you track work?**

Calendar is auto-inferred from Q5. Don't add a Q8.

### Gaps are expected
Whatever isn't provided — a skipped question, something not in the file — gets a clear `TODO:` in the relevant file. The OS works fine with partial info and sharpens as the user shares more (re-run `/onboard`, drop files in `Transition/`, or just talk).

---

## Phase 2 — Scaffold the Day-1 file set

Once intake is done — questions answered and/or a file ingested, whatever the user gave (or nothing) — generate these (or update if re-running). Fill **only** from what was actually provided; where something is missing, write a clear `TODO:` line — never invent. Back up originals to `archives/intake-{YYYY-MM-DD-HHMM}/` if any exist.

1. **`context/about-me.md`** — from Q1 (identity, role) + Q7 (top pain).
2. **`context/about-business.md`** — from Q1 (offer, ideal customer) + Q4 (revenue model).
3. **`context/priorities.md`** — from Q3. Numbered list, one line per priority.
4. **`references/voice.md`** — if the user pasted writing samples, include them verbatim; if voice was only inferred from an ingested file, say so; if nothing was given, leave `TODO: add writing samples`. Header note: "Match this register when drafting; don't fake voice on external content without showing me first."
5. **`connections.md`** — populate from Q4-Q7. Mark **Obsidian and Google (if connected in Phase 0) as CONNECTED with today's date**; everything still unwired gets `not yet connected`.
6. **`CLAUDE.md`** — fill every `{{...}}` placeholder (name/business, priorities, voice summary, timezone, language, connections summary). **Remove the "SETUP NOT COMPLETE" banner** — setup is done.
7. **`OS-INDEX.md`** — link the new notes with `[[wikilinks]]`.

Keep the Obsidian graph alive: every note gets `tags:` in frontmatter and a `## Connected` section of related `[[wikilinks]]`.

---

## Phase 3 — Closing screen

Print one screen. Three lines max — and because setup is already done, point them at *using* the OS:

```
Done. Your AI OS is set up (plugins + Google) and now knows who you are, what you sell, what matters this quarter, and how you sound.

Today: ask me — "what should I focus on this week?"
Anytime: drop a thought in Transition/ and I'll file it; say "grill me" to think through a plan.
```

When the user runs the closing prompt ("what should I focus on this week?"), answer using only the new context files:
- 3-bullet priority list, in their voice register from Q2
- Each bullet ties back to a stated 90-day priority from Q3
- Final line: *"If I had to pick one thing for Monday, it'd be [X], because [reason]. Want me to draft the first step? And — to what extent could AI be leveraged on this task?"*

---

## Critical implementation rules

1. **Setup before questions. Never reverse the order, never ask which to do first.** On the first session this runs automatically before anything else (the CLAUDE.md setup gate + the SessionStart hook enforce it). Phase 0 gates Phase 1 — a fluent start, not a fragmented one.
2. **Resumable across restarts.** Every run re-checks `installed_plugins.json` and the available Google connector tools and continues from the first unmet step. Re-running never re-does completed work.
3. **Almost no terminal.** You can't run `/plugin` (user-typed + needs restart) or click the Google browser consent — guide and verify those. There are no shell commands the user must run for setup (Google is a connector, Obsidian is just opening a folder). The only by-hand installs are Claude Code + Node.js, covered in `INSTALL-FIRST.md`.
4. **Never echo secrets** (tokens, OAuth codes) back in plain text.
5. **Setup is strict and runs first, in fixed order — no choosing, no skipping.** Plugins (Superpowers, claude-mem, context-mode) + Obsidian vault + Google must pass before the interview. The *only* exception is a genuinely-blocked Google, recorded as `blocked:` in `connections.md`.
6. **Intake is optional; only the cap is firm.** Don't exceed 7 questions, but every answer can be skipped — and the user may instead drop a file to ingest, or skip intake entirely. Never force voice samples: recommend, accept "no." One-shot scaffold after intake. Idempotent. Closing screen is three lines.
7. **Build more skills later** with Skill Creator — don't pre-generate extra skills here.

## Verification (for the implementer)

- Cold-test: fresh clone, type "hi" on the first session. Expected: the OS does NOT answer "hi" — it starts Phase 0, walks plugin install → restart → resume, has them open the vault, connects Google in the browser, and refuses the interview until plugins + Google pass.
- Resume test: install plugins, restart, re-run `/onboard`. Expected: Plugins ✓ from `installed_plugins.json`; proceeds to Obsidian/Google without re-asking.
- No-terminal test: confirm Phase 0 asks for zero shell commands (only `/plugin` slash commands, a browser click for Google, and opening a folder in Obsidian).
- Skip test: decline every question and provide no file. Expected: scaffolds files with clear `TODO:` markers, forces nothing, finishes with the closing screen.
- Ingest test: drop a company-profile file instead of answering. Expected: distills it into the context files, saves the original to `archives/sources/`, asks only about genuine gaps.
