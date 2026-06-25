---
name: gcal-manager
description: Use when you mention any dated event, meeting, training, shoot, client call, deadline, or payment due — or say "add to calendar", "put it on my calendar", "schedule this", "jadwal", "masukin ke calendar". Acts as your Google Calendar manager: detects events from natural conversation and writes them to Google Calendar in a clean, consistent format so nothing gets missed.
---

# Google Calendar Manager

People miss things that were only said out loud. This skill's job: **detect events from the conversation, then write them to Google Calendar in a clean, consistent format.** Be proactive — if the user mentions something with a date, offer to put it on the calendar.

## Connection prerequisite

Google Calendar runs through **Claude's built-in Google connector** (set up during `/onboard`). If the Google Calendar tools aren't available this session:
- Ask the user to run `/mcp` (or open Claude's **Connectors** settings) and connect **Google Calendar**. A browser window opens → sign in → **Allow**.
- Once connected, the create / list / update event tools appear automatically.
- Update the Calendar row in `connections.md` to `connected` + today's date.

## Defaults

- **Timezone:** the user's timezone — the `{{TIMEZONE}}` set in `CLAUDE.md` during onboarding. Always use it unless the user says otherwise. If it isn't set yet, **ask once** and don't guess.
- **Calendar:** the user's primary calendar, unless they ask for another.
- **Event language:** match the language set in `CLAUDE.md` (`{{LANGUAGE}}`) — keep titles + descriptions consistent in that one language.
- **No emoji in the event itself.** Clean, professional titles and descriptions. (Emoji are fine in chat, never inside the calendar event.)
- **Offline meeting → no video link.** Put the physical address in `location`; don't attach a conference. Note: if the user's account has "Automatically add Google Meet to events" ON, Google adds a Meet link the API can't remove — tell them to turn that setting off (Calendar Settings → Event settings), then delete + recreate the event so it's clean.
- **Online meeting → use the user's standing meeting link** if they have one (store it in `context/about-me.md` or `connections.md`). Put it in `location` (so it's clickable) and as the first line of `description` ("Join: <link>"). A clickable link is enough; you don't need a native conference object.
- **Default reminders:** 1 day before + 1 hour before. For high-stakes events (below), add 3-days-before and morning-of.
- **Color coding (colorId) — recommended.** Use Google Calendar `colorId`s to distinguish work streams at a glance (e.g. one color per business line, one for personal, one for networking). Let the user define their mapping during `/onboard` and record it in `context/about-me.md`; apply it consistently. Don't hardcode a scheme — it's the user's call.

## Event format (keep it consistent — one language, no emoji)

**Title:** `[Event] — [client/context]`. Examples: `Client Meeting — Acme`, `Private Class — Northwind`.
Multi-day: add `(Day 1/2)` etc.

**Location:** fill if known (venue / address / meeting link).

**Description template:**
```
[One line of context: what this is]

Attendees : ...
Value     : ... (if any)
Owner     : ... (who runs / prepares it)
Prep      : ... (what to prepare beforehand)
Agenda    : ...

Logged via OTIUM AI OS
```
Drop any line that doesn't apply. Don't force empty fields.

## Workflow

1. **Detect** an event from the conversation (a date/time appears, or the user asks to add it).
2. **Get the minimum:** date, start–end time, title, location. If the time wasn't given, **ask** (never guess a time). All-day events may skip the time.
3. **Confirm briefly** (title + date + time) before creating. Writing to the calendar is already authorized, so confirmation is one line, not an interrogation.
4. **Check for conflicts:** before creating, list events on that date. If there's an overlap, flag it.
5. **Create** via the Google Calendar connector, in the user's timezone.
6. **Report:** title, date/time, and the event link (htmlLink) if returned.

## High-stakes events (extra reminders)

A first-of-its-kind event, a new client, or anything the user flags as important → set reminders at 3-days-before, 1-day-before, and morning-of. If prep material isn't ready yet, offer to create a separate "Prep" event a few days earlier.

## Rules

- Never guess a date or time. In doubt, ask.
- Don't invite other people's emails unless asked (avoid default attendees).
- Always use the user's configured timezone.
- If the user hands you several events at once, process all of them and report back as a short list.
- After adding an important event, suggest logging it to `decisions/log.md` if it's a business commitment (e.g. a client booking).
