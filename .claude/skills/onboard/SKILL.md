---
name: onboard
description: Use on Day 1 of this AI OS, when someone says "set me up", "onboard me", "let's get started", "fill in my OS", or has just opened this folder for the first time. Combined wizard — runs the 7-question intake AND scaffolds the Day-1 file set at the end. Idempotent — re-run any time after editing aios-intake.md.
---

## What this skill does

Single combined wizard. Reads or writes `aios-intake.md` (the canonical intake), conducts the 7-question interview if the file isn't filled, then scaffolds the Day-1 file set inline at the end of the run. This is the installer for the whole OS — one flow.

**The wow moment:** at the end, suggest the closing prompt *"Try this — ask me: what should I focus on this week?"* The user runs it once. That's the wow — the OS answers using the context it just learned about them.

## When NOT to run this

- If the user has already onboarded and wants to refresh: still run, but skip questions already answered (idempotent).
- If the user wants to add a new tool connection: that's not onboarding — point them at `connections.md` to edit directly, or at `SETUP-PLAYBOOK.md` Part B/C to wire Obsidian or Google Workspace.

## Execution

### Step 1: Read the intake

Read `aios-intake.md`. Check which Q1-Q7 sections have content vs. `[Your answer here]` placeholders.

- **All filled** → skip Step 2, jump to Step 3 (scaffold).
- **Some filled** → ask the user: "I see Q1, Q3, Q4 are answered. Want to fill the rest now, or scaffold from what's there?" Their call.
- **None filled (fresh kit)** → run Step 2 conversationally.

### Step 2: The interview (7 questions, hard cap)

Ask one at a time. Write each answer into `aios-intake.md` as you go (so the user can resume if interrupted). Match the user's language.

**Q1 — Who are you, what do you sell, who do you sell it to?**
Identity, offer, ideal customer. One paragraph each is fine.

**Q2 — Paste 1-2 things you've written recently. Don't edit them.**
*This is the only question with a hard rule.* Voice samples MUST be pasted, not typed mid-conversation. If the user starts typing fresh prose, refuse:

> *"Stop — paste it raw. If you type it here while we're talking, the sample is already shaped by our conversation. Open your last email or social post in another tab and paste the unedited text. This is the one rule I can't bend."*

Ask for two samples. One email, one post. Or two of either.

**Q3 — What are your 2-3 biggest priorities for the next 90 days?**
Quarterly priorities. Push back if they say "grow my business" — make them name a number, a deadline, or a deliverable.

**Q4 — Where does revenue actually land, and where is it tracked?**
Multiple answers OK. (Revenue / financials.)

**Q5 — Where do you talk to customers, your team, and the outside world day-to-day?**
Email (Gmail/Outlook), WhatsApp, Slack/Teams/Discord, DMs. (Communications.)

**Q6 — Where do meeting recordings, notes, and important docs live?**
(Knowledge / documents.)

**Q7 — What's the one task that eats your week, and where do you currently track work?**
Capture the top pain (this feeds future automation) plus where tasks live.

Calendar is auto-inferred from Q5: Gmail → Google Calendar; Outlook → Outlook Calendar. Confirm in Step 3.

### Step 3: Scaffold the Day-1 file set

Once the intake is complete, generate these files (or update if re-running). Back up originals to `archives/intake-{YYYY-MM-DD-HHMM}/` if any exist.

1. **`context/about-me.md`** — from Q1 (identity, role) + Q7 (top pain). One short paragraph each.
2. **`context/about-business.md`** — from Q1 (offer, ideal customer) + Q4 (revenue model). One paragraph.
3. **`context/priorities.md`** — from Q3. Numbered list, one line per priority.
4. **`references/voice.md`** — from Q2. Paste samples verbatim with a short header explaining their use ("Match this register when drafting; don't fake voice on external content without showing me first").
5. **`connections.md`** — populate the table from Q4-Q7 answers. Each row gets `mechanism: not yet connected`, `auth: —`, `last checked: —`. The user wires connections via `SETUP-PLAYBOOK.md`.
6. **`CLAUDE.md`** — fill every `{{...}}` placeholder. Substitute the user's name/business, stated priorities, voice-register summary, timezone, language, and a brief connections summary. Remove the "SETUP NOT COMPLETE" banner at the top once done.
7. **`OS-INDEX.md`** — link the new notes with `[[wikilinks]]` so the Obsidian graph connects.

Keep the Obsidian graph alive: every note you write gets `tags:` in frontmatter and a `## Connected` section of related `[[wikilinks]]`.

### Step 4: The closing screen

Print one screen. Three lines max:

```
Day 1 done. Your AI OS now knows who you are, what you sell, what matters this quarter, and how you sound.

Today: ask me — "what should I focus on this week?"
Tomorrow: open SETUP-PLAYBOOK.md and wire one connection (Obsidian or Google Workspace).
Day 7: run the audit / review your priorities.
```

When the user runs the closing prompt ("what should I focus on this week?"), respond using only the new context files. Hit:
- 3-bullet priority list, in their voice register from Q2
- Each bullet ties back to a stated 90-day priority from Q3
- Final line: *"If I had to pick one thing for Monday, it'd be [X], because [reason from priorities]. Want me to draft the first step? And — to what extent could AI be leveraged on this task?"*

## Critical implementation rules

1. **The 7-question cap is non-negotiable.** Don't add Q8 in conversation.
2. **Voice paste cannot be skipped.** If the user types samples mid-chat, refuse and tell them to paste from real writing.
3. **One-shot scaffold.** After Step 2 ends, write Step 3 files in a single batch. No multi-turn confirmation. The user iterates by editing `aios-intake.md` and re-running.
4. **Idempotent.** Re-running with an edited intake refreshes context files; backs up originals to `archives/intake-{ts}/`. Skips questions already answered unless the user wants to revise.
5. **Closing screen is three lines.** Not a menu.
6. **Build more skills later.** This kit ships 3 skills (onboard, grill-me, session-handoff). The user authors more with Skill Creator — don't pre-generate extra skills here.
7. **No `.env` / API-key writes on Day 1.** Connections come after onboarding, via the playbook.

## Verification (for the implementer)

- Cold-test: open a fresh kit, run onboard, fill 7 answers, scaffold runs, ask the wow prompt, response cites Q1 + Q3 + Q7 specifically. Generic = fail.
- Idempotency: re-run onboard with one Q3 priority changed. Expected: only `context/priorities.md` and `CLAUDE.md`'s priority section update; backup created in `archives/intake-{ts}/`.
- Voice rejection: type a sample mid-chat. Expected: skill refuses, asks for paste.
