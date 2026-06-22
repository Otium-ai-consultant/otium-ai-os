---
name: onboard
description: Use on Day 1 of this AI OS, when someone says "set me up", "onboard me", "let's get started", "install my OS", or has just opened this folder for the first time. The full installer — FIRST connects the crucial tools (plugins + Obsidian, optionally Google Workspace), THEN runs the 7-question intake and scaffolds the Day-1 files. Resumable across restarts and idempotent.
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
- **Google:** check `~/.claude.json` for a `"workspace"` entry.

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

### 0.4 — Connect Google Workspace (attempt now; skippable)

1. Offer to wire Gmail/Calendar/Drive now. If they're ready, walk them through creating Google OAuth credentials (full steps in `SETUP-PLAYBOOK.md` Part C: new Cloud project → enable APIs → OAuth consent screen with their email as a Test user → create OAuth client ID → copy Client ID + Secret).
2. When they paste Client ID + Secret, **YOU run** (Bash):
   ```
   claude mcp add workspace -s user -e GOOGLE_OAUTH_CLIENT_ID=<id> -e GOOGLE_OAUTH_CLIENT_SECRET=<secret> -- uvx workspace-mcp --tool-tier core
   ```
   Then have them restart and verify with *"what's on my calendar this week?"* (a browser sign-in opens the first time).
3. **If they're short on time or hit a wall:** offer to **defer**. Google is valuable but not required to start. Note it as "not yet connected" and tell them they can run `/onboard` again later, or just ask the OS to connect Google any time. Do not let a stuck OAuth block the whole onboarding.

### 0.5 — The gate

Do **NOT** start Phase 1 until **plugins are installed AND Obsidian is connected** (Google may be deferred). If the user tries to jump straight to the questions, hold the line gently: explain that connecting the crucial tools first is exactly what makes the OS fluent instead of fragmented, and it's a one-time ~10-minute step. Then continue Phase 0.

---

## Phase 1 — The interview (7 questions, hard cap)

Ask one at a time. Write each answer into `aios-intake.md` as you go (so the user can resume if interrupted). Match the user's language.

**Q1 — Who are you, what do you sell, who do you sell it to?** Identity, offer, ideal customer.

**Q2 — Paste 1-2 things you've written recently. Don't edit them.**
*The only question with a hard rule.* Voice samples MUST be pasted, not typed mid-conversation. If the user starts typing fresh prose, refuse:
> *"Stop — paste it raw. If you type it here while we're talking, the sample is already shaped by our conversation. Open your last email or social post in another tab and paste the unedited text. This is the one rule I can't bend."*
Ask for two samples. One email, one post. Or two of either.

**Q3 — Your 2-3 biggest priorities for the next 90 days?** Push back if they say "grow my business" — make them name a number, a deadline, or a deliverable.

**Q4 — Where does revenue actually land, and where is it tracked?** Multiple answers OK.

**Q5 — Where do you talk to customers, your team, and the outside world day-to-day?** Email, WhatsApp, Slack/Teams/Discord, DMs.

**Q6 — Where do meeting recordings, notes, and important docs live?**

**Q7 — What's the one task that eats your week, and where do you track work?** Capture the top pain (feeds future automation) plus where tasks live.

Calendar is auto-inferred from Q5 (Gmail → Google Calendar; Outlook → Outlook Calendar). Confirm in Phase 2.

---

## Phase 2 — Scaffold the Day-1 file set

Once the interview is complete, generate these (or update if re-running). Back up originals to `archives/intake-{YYYY-MM-DD-HHMM}/` if any exist.

1. **`context/about-me.md`** — from Q1 (identity, role) + Q7 (top pain).
2. **`context/about-business.md`** — from Q1 (offer, ideal customer) + Q4 (revenue model).
3. **`context/priorities.md`** — from Q3. Numbered list, one line per priority.
4. **`references/voice.md`** — from Q2. Paste samples verbatim with a short header ("Match this register when drafting; don't fake voice on external content without showing me first").
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
6. **7-question cap is non-negotiable.** Voice paste cannot be skipped. One-shot scaffold after the interview. Idempotent. Closing screen is three lines.
7. **Build more skills later** with Skill Creator — don't pre-generate extra skills here.
8. **No `.env` writes.** Keys go into the MCP config via `claude mcp add -e ...`, never into committed files.

## Verification (for the implementer)

- Cold-test: fresh clone, run `/onboard`. Expected: it checks state, walks plugin install → restart → resume, connects Obsidian, and **refuses to start the interview** until plugins + Obsidian are ✓.
- Resume test: install plugins, restart, re-run `/onboard`. Expected: it marks Plugins ✓ from `installed_plugins.json` and proceeds to Obsidian without re-asking.
- Order test: ask to "just answer the questions" before connecting. Expected: it gently holds the line and finishes Phase 0 first.
- Secret test: paste an Obsidian key. Expected: it runs `claude mcp add` and never prints the key back.
