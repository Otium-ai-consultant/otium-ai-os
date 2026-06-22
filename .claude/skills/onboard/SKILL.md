---
name: onboard
description: Use on Day 1 of this AI OS, when someone says "set me up", "onboard me", "let's get started", "install my OS", or has just opened this folder for the first time. The full installer — FIRST connects the crucial tools (plugins + Obsidian, optionally Google Workspace), THEN learns about the user via optional questions OR a file they drop in to be ingested, and scaffolds the Day-1 files. Nothing in the intake is mandatory. Resumable across restarts and idempotent.
---

## What this skill does

This is the **installer for the whole OS**, and it runs in two phases — **in this exact order**:

1. **Phase 0 — Connect first.** Install the Claude Code plugins (Superpowers, Skill Creator, claude-mem, context-mode) and wire up **Obsidian** (and Google Workspace if possible) **before anything else**, so the OS is fully *live* before it starts learning about the user.
2. **Phase 1+ — Then learn.** Only once the crucial connections are in place: run the 7-question interview, then scaffold the Day-1 file set.

**The order is deliberate and non-negotiable: connections BEFORE questions.** A half-connected OS that starts interviewing feels broken and fragmented ("rantakan"). A fully-wired one feels fluent from the first minute — the graph works, memory works, the calendar works, right as it starts learning who they are. Never reverse this.

**Resumable.** Plugins and MCP connections require restarting Claude Code to take effect, so this skill is built to be re-run. After any restart, the user just runs `/onboard` again (or says "continue onboarding") — each run re-checks the state files and continues from where it left off.

## When NOT to run this

- Already fully set up and wants to refresh context only: still run, but Phase 0 will detect everything is ✓ and jump straight to the interview/scaffold.
- Wants to add ONE new tool connection later: they can re-run `/onboard` (it resumes at the missing connection), or just ask the OS to connect it.

---

## Phase 0 — Connect first (BEFORE any interview question)

**Goal of this phase:** Superpowers + Skill Creator + claude-mem + context-mode installed, **and Obsidian connected**. Google Workspace too if the user is ready (it's the only skippable one). Do not enter Phase 1 until this goal is met.

### 0.1 — Detect current state (read-only)

Run these checks so re-runs resume cleanly, then show a short ✓/▢ checklist and only work the ▢ items:

- **Plugins:** read `~/.claude/plugins/installed_plugins.json` → look for keys containing `superpowers`, `skill-creator`, `claude-mem`, `context-mode`.
- **Obsidian:** check `~/.claude.json` for an `"obsidian"` entry under `mcpServers` (global or this project). A quick grep is enough — do not dump the whole file.
- **Google:** check whether the `gws` CLI is installed (`command -v gws`). If present, a quick `gws drive files list --params '{"pageSize":1}'` confirms it's authenticated; "not found" or an auth error means Google isn't set up yet.

Present it like:
```
Setup status:
  [✓] Plugins installed
  [▢] Obsidian connected   ← next
  [▢] Google Workspace     (optional)
```

### 0.2 — Install the plugins (user runs the commands; you verify)

You **cannot** run `/plugin ...` yourself — those are user-typed slash commands and they need a restart to load. So guide, then verify:

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
3. On the next run, re-read `installed_plugins.json`. If all four are present → mark Plugins ✓. If any are missing → name exactly which one and the matching command; don't move on.

### 0.3 — Connect Obsidian (you can do this for them)

1. Ask the user to, in Obsidian: **Settings → Community plugins → Browse →** install + enable **"Local REST API" →** open its settings → **copy the API Key**. Have them paste the key to you, and confirm the **absolute path** to this folder (their vault).
2. With the key and path, **YOU run** (Bash):
   ```
   claude mcp add obsidian -s user -e OBSIDIAN_API_KEY=<key> -- npx -y mcp-obsidian "<absolute-vault-path>"
   ```
3. Tell them to **restart Claude Code**, then run `/onboard` again.
4. After the restart, verify by listing a couple of files from the vault via the Obsidian connection. If it works → mark Obsidian ✓.
5. **Never echo the API key back** in plain text in any summary or recap.

### 0.4 — Connect Google Workspace via the official `gws` CLI (attempt now; skippable)

Use Google's own Google Workspace CLI — `@googleworkspace/cli`, the `gws` command (Gmail, Calendar, Drive, Docs, Sheets; structured JSON the OS reads directly). It is **not** an MCP server — the OS drives it via the shell, so there's no `claude mcp add` here.

1. **Install** (you can run this — needs Node.js 18+):
   ```
   npm install -g @googleworkspace/cli
   ```
   Optionally add Google's ready-made agent skills so the OS has a recipe for every Workspace API:
   ```
   npx skills add https://github.com/googleworkspace/cli
   ```
2. **Set up + authenticate.** Run `gws auth setup` (walks through the Google Cloud project + OAuth config — no manual OAuth-client creation), then `gws auth login`. Use the **agent-assisted flow**: YOU open the printed URL, the user picks their Google account and approves the scopes, and control returns once the localhost callback succeeds. (Or they run `gws auth login` themselves and just approve in the browser.) If login is blocked, add their email as a Test user on the OAuth consent screen and retry.
3. **Verify:** run `gws drive files list --params '{"pageSize": 5}'`. If it returns without an auth error → mark Google ✓. From then on, use `gws ...` commands for anything in Gmail / Calendar / Drive.
4. **If they're short on time or hit a wall** (Google Cloud is fiddly): offer to **defer**. Google isn't required to start. Note it "not yet connected" and tell them they can run `/onboard` again later, or just ask the OS to connect Google any time. Do not let a stuck setup block the whole onboarding.

### 0.5 — The gate

Do **NOT** start Phase 1 until **plugins are installed AND Obsidian is connected** (Google may be deferred). If the user tries to jump straight to the questions, hold the line gently: explain that connecting the crucial tools first is exactly what makes the OS fluent instead of fragmented, and it's a one-time ~10-minute step. Then continue Phase 0.

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
5. **`connections.md`** — populate from Q4-Q7. Mark **Obsidian (and Google, if connected in Phase 0) as CONNECTED with today's date**; everything still unwired gets `not yet connected`.
6. **`CLAUDE.md`** — fill every `{{...}}` placeholder (name/business, priorities, voice summary, timezone, language, connections summary). **Remove the "SETUP NOT COMPLETE" banner** — setup is done.
7. **`OS-INDEX.md`** — link the new notes with `[[wikilinks]]`.

Keep the Obsidian graph alive: every note gets `tags:` in frontmatter and a `## Connected` section of related `[[wikilinks]]`.

---

## Phase 3 — Closing screen

Print one screen. Three lines max — and because the tools are already connected, point them at *using* the OS, not more setup:

```
Done. Your AI OS is connected (plugins + Obsidian) and now knows who you are, what you sell, what matters this quarter, and how you sound.

Today: ask me — "what should I focus on this week?"
Anytime: drop a thought in Transition/ and I'll file it; say "grill me" to think through a plan.
```

When the user runs the closing prompt ("what should I focus on this week?"), answer using only the new context files:
- 3-bullet priority list, in their voice register from Q2
- Each bullet ties back to a stated 90-day priority from Q3
- Final line: *"If I had to pick one thing for Monday, it'd be [X], because [reason]. Want me to draft the first step? And — to what extent could AI be leveraged on this task?"*

---

## Critical implementation rules

1. **Connections before questions. Never reverse the order.** This is the whole point — a fluent start, not a fragmented one. Phase 0 gates Phase 1.
2. **Resumable across restarts.** Every run re-checks `installed_plugins.json` and `~/.claude.json` and continues from the first unmet step. Re-running never re-does completed work.
3. **You can't run `/plugin` (user-typed + needs restart) — guide and verify.** You CAN run `claude mcp add ...` for Obsidian/Google once you have the user's keys.
4. **Never echo API keys or OAuth secrets** back in plain text — not in summaries, not in recaps.
5. **Google Workspace is the only skippable connection.** Plugins + Obsidian are required before the interview.
6. **Intake is optional; only the cap is firm.** Don't exceed 7 questions, but every answer can be skipped — and the user may instead drop a file to ingest, or skip intake entirely. Never force voice samples: recommend them, accept "no." One-shot scaffold after intake. Idempotent. Closing screen is three lines.
7. **Build more skills later** with Skill Creator — don't pre-generate extra skills here.
8. **No `.env` writes.** Keys go into the MCP config via `claude mcp add -e ...`, never into committed files.

## Verification (for the implementer)

- Cold-test: fresh clone, run `/onboard`. Expected: it checks state, walks plugin install → restart → resume, connects Obsidian, and **refuses to start the interview** until plugins + Obsidian are ✓.
- Resume test: install plugins, restart, re-run `/onboard`. Expected: it marks Plugins ✓ from `installed_plugins.json` and proceeds to Obsidian without re-asking.
- Order test: ask to "just answer the questions" before connecting. Expected: it gently holds the line and finishes Phase 0 first.
- Secret test: paste an Obsidian key. Expected: it runs `claude mcp add` and never prints the key back.
- Skip test: decline every question and provide no file. Expected: it scaffolds the files with clear `TODO:` markers, forces nothing, and still finishes with the closing screen.
- Ingest test: drop a company-profile file instead of answering. Expected: it distills the file into the context files, saves the original to `archives/sources/`, and asks only about genuine gaps.
