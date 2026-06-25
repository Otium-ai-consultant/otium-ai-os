---
name: raw-ingest
description: Use when you want raw web-clipped or long-form material turned into knowledge — or say "ingest RAW", "raw ingest", "process this clip", "ingest knowledge", or when files appear in Transition/RAW/. Reads each raw clip (Obsidian Web Clipper output or pasted long-form), distills the signal (never dumps), routes the distilled note to its right knowledge home (references/ai-knowledge/, references/{topic}.md, or context/), keeps source provenance, wikilinks + tags it into the Obsidian graph, archives the raw original, and leaves Transition/RAW/ empty.
---

## What this skill does

The **knowledge-bank ingester** for long-form raw material. `Transition/RAW/` is the staging zone the **Obsidian Web Clipper** writes into (and where you can paste long `.md` source). This skill reads each raw clip, **distills it into signal**, files a clean interpreted note into the right knowledge home, keeps the **source URL** so provenance is never lost, links it into the Obsidian graph, archives the raw original, and empties `Transition/RAW/`.

The goal is **consistent ingest.** Every clip comes out as the same shape of note — same frontmatter, same sections, same provenance line, same graph links — so the knowledge bank stays uniform no matter what gets clipped.

## Boundary vs `/capture`

- **`/capture`** = short input, simple routing, interpreted *fact* (a sentence, a contact, a decision, a dropped file in `Transition/`). No distillation needed.
- **`/raw-ingest`** (this) = **long-form raw source** (web article, thread, transcript, doc) that must be **distilled** before it can enter the KB. Operates specifically on `Transition/RAW/`.

If a RAW item is actually a short fact / a person / a decision / a project → hand it to `/capture` instead of forcing a knowledge note.

## Today's context

- **Date:** !`date +%Y-%m-%d`
- **Source folder:** `Transition/RAW/`
- **OS root:** the current working directory

## Reading clips without flooding context (IMPORTANT)

Web clips are long (full HTML→Markdown). **Do not read whole clips into the conversation.** Use the context-mode tools to read + distill in the sandbox and pull back only the signal:
- `ctx_execute_file(path, language, code)` to parse a clip's frontmatter + extract the meaningful body.
- `ctx_batch_execute` to scan all clips at once (titles, sources, lengths) before triage.

Only the distilled bullets should ever enter your context — never the raw clip body.

## The ingest routing map

Decide the distilled note's home by **what the clip is about**, not by keyword:

| Clip is about… | Distilled note → | Tag |
|---|---|---|
| AI tools / models / techniques / prompts | `references/ai-knowledge/{slug}.md` | `ai-knowledge` |
| How a specific tool / API / MCP works | `references/{tool}-api.md` (merge if it exists) | `reference` |
| A business / marketing / creative framework or method | `references/{topic}.md` | `business` / `creative` |
| A fact about you / the business / a person / a decision | hand to **`/capture`** (→ `context/*` or `decisions/log.md`) | — |
| Pure timely news, no lasting value | discard (or hand to a news pipeline if you run one) | — |
| Junk / mis-clip / paywalled stub / duplicate | **DISCARD** — archive raw only, write nothing to KB | — |

**Area tag** (always add one): a simple top-level area you use consistently — e.g. `area/work` · `area/personal`. Pick the taxonomy that fits your business and keep it stable.

When a clip genuinely fits two homes, file it in the **primary** home and cross-reference the other with a `[[wikilink]]` — never duplicate the content.

## The distilled note template (use this every time — consistency is the point)

```
---
tags: [area/{area}, {type-tag}]
source: {url from clip frontmatter}
author: {author or omit}
clipped: {clipped/created date from clip}
ingested: {today}
status: {to-read | worth-trying | reference | archived}
---
# {Clean title}

> Source: [{domain}]({url}) · clipped {clipped} · ingested {today}

## Core
- {3–6 bullets that distill the actual signal — what's true / new / useful}

## Relevance
- {1–3 bullets: why this matters — for client work, content, ops, training}

## Key details
- {data, quotes, steps worth keeping — only real signal, skip filler}

## Connected
[[related-note]] · [[another]]
```

Drop a section only if it would be empty. Keep bullets terse and in the OS voice (calm, substantive, no hype). Match the clip's language to the user's usual language.

## Execution

### Mode A — Ingest the whole RAW folder (default)

1. **List** every clip in `Transition/RAW/`, **ignoring** `.gitkeep`, `.DS_Store`, `_README.md`.
   - If empty → tell the user "Transition/RAW is empty, nothing to ingest" and stop.
2. **Scan + distill** each clip with context-mode tools: pull title, `source` URL, clipped date, and the meaningful body. Classify via the routing map.
3. **Dedup check.** Before creating a note, search `references/ai-knowledge/` (and the rest of `references/`) for an existing note on the same topic. If one exists → plan to **merge** the new signal in (update `updated:`, keep both sources) rather than create a duplicate.
4. **Present the ingest plan** (one line per clip) and let the user confirm/adjust before writing:
   ```
   RAW ingest plan ({n} clips):
   1. {title} → references/ai-knowledge/{slug}.md (NEW) — {1-line signal}
   2. {title} → merge into [[existing-note]] — {what's new}
   3. {title} → DISCARD (news, no lasting value)
   ...
   ```
   - If a clip is clearly junk/dup, propose DISCARD — don't ask permission to skip noise, just show it.
   - If routing is genuinely ambiguous between two KB homes, ask one short question.
5. **On confirm, write** each kept clip as a distilled note using the template — interpreted, not dumped. Always keep the `source:` URL. Add `[[wikilinks]]` + `tags:` (graph rule — never orphan a note). Merge where the plan said merge.
6. **Archive the raw originals.** `mv` every processed clip (kept *and* discarded) to `archives/raw-ingest/{today}/`. Never `rm` — provenance is preserved even for discards.
7. **Verify `Transition/RAW/` is empty** (only `.gitkeep` + `_README.md` remain).
8. **Report:**
   ```
   Ingested {n} clips:
   - {title} → {path} ({NEW|merged}) · linked [[...]]
   - {title} → DISCARD → archives/raw-ingest/{today}/
   Transition/RAW empty. Raw archived → archives/raw-ingest/{today}/
   ```
9. If any note landed in `references/` → suggest running `/os-map` to refresh `OS-INDEX.md`.

### Mode B — Ingest one clip / one pasted source

Same pipeline for a single input (one file the user points at, or long text they paste). Distill → route → write → archive (if it was a file) → confirm one line.

## Hard rules

1. **Distill, never dump.** A clip is raw source; the KB gets the *signal*. No walls of clipped HTML→MD in `references/`. (EXPANSIONS.md: interpreted facts only.)
2. **Always keep provenance.** Every distilled note carries `source:` URL + `clipped` date in frontmatter and the `> Source:` line. Web knowledge without its source is unverifiable.
3. **Never delete raw.** Processed clips — kept or discarded — move to `archives/raw-ingest/{date}/` with `mv`. The only thing that ends empty is `Transition/RAW/`.
4. **Dedup before create.** Merge into the existing note on a topic instead of spawning a second one. One topic = one note.
5. **Link + tag every note (graph rule).** `[[wikilinks]]` to related notes + a `## Connected` line + `tags:` frontmatter. Never leave an ingested note orphaned.
6. **Consistent shape.** Use the distilled-note template every time — same frontmatter keys, same sections. Consistency is the whole reason this skill exists.
7. **Confirm the plan before writing** in batch mode; show DISCARDs but don't beg permission to skip obvious noise. Ask one question only when a KB home is genuinely ambiguous.
8. **Respect EXPANSIONS.md.** Route into existing homes; don't invent `notes/`/`misc/`/`tmp/`. `archives/raw-ingest/` is the only new folder this skill creates (a dated archive bucket, not a graveyard).
9. **No emoji in note bodies, no hype.** Terse, substantive, in the user's voice and language.
