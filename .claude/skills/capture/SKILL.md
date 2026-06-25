---
name: capture
description: Use when you drop a thought, fact, file, link, or decision and it needs to land in the right place — or when you say "capture this", "file this", "where does this go", "sort my Transition folder", "empty the drop-zone", or drop files into Transition/. Classifies the input and routes it to the correct home (context/, references/, decisions/log.md, projects/, templates/, archives/, or your connected tools), then confirms. Keeps Transition/ empty.
---

## What this skill does

The **inbox router** for your AI OS. Takes one raw input — a sentence, a fact, a file in `Transition/`, a URL, a decision — figures out where it belongs in the OS, turns it into an interpreted note (not a raw dump), writes it to the right place, and leaves `Transition/` empty.

This is the skill that enforces the CLAUDE.md rule *"sort whatever I drop into the right home."* It exists so that rule actually runs instead of being a good intention.

**Scope is routing — "where does this one thing go, and put it there."** It is NOT a librarian sweep (that's `/os-map`, which detects what needs filing) and NOT a knowledge generator. capture handles one input (or one drop-zone clear-out) at a time and writes interpreted facts.

## Today's context

- **Date:** today's date (already in your session context — no shell call needed; works on any OS)
- **OS root:** the current working directory

## The routing map

Decide the destination by what the input *is*, not by keyword:

| If the input is… | Route to | As |
|---|---|---|
| A fact about you / your life / preferences | `context/about-me.md` (append a line under the right heading) | interpreted fact |
| A fact about the business | `context/about-business.md` | interpreted fact |
| A person (client, prospect, partner, vendor) | `context/contacts.md` | structured contact row |
| A team fact | `context/team.md` | interpreted fact |
| A priority / goal shift | `context/priorities.md` | updated entry |
| A reusable framework, methodology, or domain knowledge | `references/{topic}.md` | interpreted reference |
| How an API / tool / MCP works | `references/{tool}-api.md` | researched-once guide |
| A repeatable process | `references/sops/{process}.md` | SOP |
| A decision + why it was made | `decisions/log.md` (append-only) | dated decision entry |
| A reusable doc/prompt scaffold | `templates/` | template |
| A new **project / client / deal / session** | `projects/{name}.md` (a card — and your task/CRM tool if connected) | project card |
| A task or knowledge meant for a connected tool (Notion, ClickUp, Airtable, a CRM…) | that tool, via its connector | row / page |
| Old / done / superseded | `archives/` | moved, never deleted |
| A whole app / codebase / sub-project | its own folder at OS root (e.g. moved out of `Transition/`) | relocated project |

When unsure between two homes, **ask one short question** before writing. Never guess silently on ambiguous routing.

> Some OS instances grow extra homes (e.g. `brand-assets/`, `Training Materials/`). If a folder exists and clearly fits, route there; don't invent folders that aren't there (see `EXPANSIONS.md`).

## Execution

### Mode A — A thought / fact / link handed to you directly

1. **Classify** using the routing map. Identify the single best destination.
2. **Interpret, don't dump.** Convert the raw input into a clean, contextual line/entry in the OS's voice. (EXPANSIONS.md: "Interpreted facts only" — the wiki is not a doc dump.)
3. **If ambiguous**, ask one clarifying question. Otherwise proceed.
4. **Write** — append to the target file (Edit/Write). For `decisions/log.md`, always append with the date and the *why*. For a connected tool, use its connector to create/update the right row.
5. **Link it into the graph (do not skip).** This vault is an Obsidian knowledge graph. Whenever the entry lands in a `context/`, `references/`, or `decisions/` note:
   - Add `[[wikilinks]]` (note basename, no `.md`) to every note the entry relates to — a new contact → `[[team]]`; a project/priority → its client in `[[contacts]]` + `[[priorities]]`; a decision → the notes it affects.
   - If the target note has a `## Connected` section, add the new relation there too.
   - If the note has no `tags:` frontmatter yet, add lightweight ones (e.g. `area/work`, `area/personal` + a type tag). Never leave a routed note orphaned (no inbound/outbound links).
6. **Confirm** in one line: `Filed → {path or tool}: "{the interpreted entry}" · linked → [[...]]`.

### Mode B — Clear the Transition/ drop-zone

1. **List** everything in `Transition/`.
2. **For each item**, classify by the routing map:
   - A loose doc/note → interpret + file into the right `context/` or `references/` target, then remove from `Transition/`.
   - A whole sub-project / app folder → relocate to its own home at OS root (or `archives/` if dead). Confirm the destination name first — these are big moves.
   - Genuinely unclear → ask, one item at a time.
3. **Move with `mv`** (don't copy-then-delete; don't lose data). For interpreted notes where the original was raw, file the interpreted version then archive the raw original to `archives/` rather than deleting.
4. **Verify `Transition/` is empty** at the end (a `.gitkeep` is fine).
5. **Report** what moved where:
   ```
   Drop-zone cleared. {n} items routed:
   - {item} → {destination} ({how})
   - ...
   Transition/ is now empty.
   ```

### After any capture

- If the input was a **decision**, remind the user it's logged (per CLAUDE.md, decisions go to `decisions/log.md`).
- If you wrote to `connections.md` or added a new tool, suggest running `/os-map` to refresh `OS-INDEX.md`.

## Hard rules

1. **Interpreted facts only — never raw dumps.** Convert email/chat/notes into clean contextual entries. No pasting walls of raw text into `references/` or `context/`.
2. **Never delete data.** Old things move to `archives/`. `mv`, not `rm`. The only thing that should end up truly empty is `Transition/`.
3. **One destination per input.** If something genuinely belongs in two places, file the fact in its primary home and **cross-reference with a `[[wikilink]]`** — don't duplicate the content. Cross-referencing is what keeps the Obsidian graph connected.
4. **Respect EXPANSIONS.md.** Don't create `notes/`, `tmp/`, `inbox/`, `misc/`. Don't pre-create folders. Don't fork `CLAUDE.md`. Read its "What NOT to add" before creating any new folder.
5. **Ask before big moves.** Relocating a whole project out of `Transition/` or archiving something gets one confirmation first. Small interpreted notes don't need to ask.
6. **decisions/log.md is append-only.** Never rewrite history. New entry, dated, with the why.
7. **Confirm every write** with the path and the entry, so the user can audit what landed where.
8. **No emojis, no hype.** Terse confirmations.
