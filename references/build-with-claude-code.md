---
title: Build with Claude Code
tags: [reference, coding]
---

# Build apps with Claude Code — a starter guide

> For non-technical owners. You don't need to know how to code. You need to know how to
> *describe what you want* and *let Claude Code build it.* This guide + the `frontend-design`
> skill are your two tools: this is the **workflow**, the skill is the **design engine**.

This OS already runs inside Claude Code. The same tool that manages your notes and calendar
can build you real, working web apps — a landing page, an internal dashboard, a small tool,
a quote calculator, a booking form. Here's how to do it without getting lost.

---

## 1. What you can realistically build

Start with things that are **one screen and do one job**:

- A landing page for an offer or event
- A simple internal dashboard (numbers your team checks daily)
- A small calculator or form (quote, ROI, intake)
- A one-page profile / portfolio / menu
- A static site with a few pages

Leave for later (these need a backend + accounts + payments — doable, just not your first build):
multi-user apps, logins, anything that charges money, anything storing lots of customer data.

---

## 2. The loop (this is the whole method)

```
Describe  →  Claude builds  →  You look at it  →  You say what's wrong  →  repeat
```

1. **Describe the goal, not the code.** Say *what it's for and who sees it*, not *how to build it*.
   Good: "A landing page for my AI training class. Calm, premium, dark. One headline, three
   benefits, a sign-up button. Mobile-first." Let the `frontend-design` skill pick the craft.
2. **Let it build.** Claude Code writes the files and can run the app so you can see it.
3. **React to what you see.** "Make the headline bigger." "The button color is off." "Add a
   testimonials section." Small, specific changes beat big vague ones.
4. **Repeat** until it's right. This is normal — even pros iterate. You're directing, not coding.

> Tip: ask Claude to **"run it and show me"** after each round so you're always looking at the
> real thing, not a description of it.

---

## 3. How to give a good brief

The more of these you answer up front, the closer the first version lands:

- **Purpose** — what is this for? (sell, inform, collect, calculate)
- **Audience** — who opens it? (a customer, your team, a partner)
- **The one action** — what should they DO? (book, buy, sign up, read)
- **Tone** — calm/premium · bold/loud · playful · minimal · corporate (pick one)
- **Content** — paste your real text, even rough. Real words beat "lorem ipsum".
- **Reference** — "like Apple's product pages" / "like Notion's landing page" helps a lot.

You don't need a spec document. A short paragraph hitting these points is plenty.

---

## 4. Seeing it and putting it online

- **See it locally:** ask Claude Code to run the project — it'll start it and give you a link
  (usually `localhost:...`) you open in your browser. This is private, only on your machine.
- **Put it online (deploy):** the easiest path is **Vercel** — free for small sites, connects to
  your project, and gives you a public link in a couple of minutes. Just say *"deploy this to
  Vercel"* and Claude Code walks you through it (you'll sign in once with your browser).
- **If it needs data or accounts:** **Supabase** is the usual companion (free tier) — it stores
  data and handles logins. You only need this once a project goes past "one static screen".
  Say *"add Supabase for [the data you need]"* and let it scaffold the setup.

> Rule of thumb: **static site → Vercel alone.** **Needs to remember things or sign users in →
> Vercel + Supabase.**

---

## 5. Do / Don't

**Do**
- Start tiny. Ship one screen, then grow it. Momentum beats master plans.
- Keep your real content in a note and paste it in — the build is only as good as the words.
- Ask "run it and show me" constantly. Decide with your eyes.
- Save your work with git when you're happy ("commit this") so you can always go back.
- Use the `frontend-design` skill for anything visual — it's what keeps it from looking generic.

**Don't**
- Don't describe code ("use a flexbox with..."). Describe the outcome. Claude knows the code.
- Don't try to build the whole platform on day one. Vertical slice first.
- Don't paste secrets/passwords/API keys into chat carelessly — let Claude set up `.env` files.
- Don't deploy customer-data or payment features without someone reviewing security first.
- Don't keep "almost right" in your head — say the specific thing that's off. It'll fix it.

---

## 6. Phrases that work

- "Build me a one-page site for **[offer]**. Tone: **[calm/premium]**. The one action is **[sign up]**. Here's the copy: **[paste]**. Use the frontend-design skill."
- "Run it and show me."
- "Make **[element]** **[bigger / a different color / move up]**."
- "Add a **[testimonials / pricing / FAQ]** section."
- "Deploy this to Vercel and give me the link."
- "Add Supabase so the form saves submissions."
- "Commit this so we have a save point."

---

*That's it. You direct, Claude Code builds. The `frontend-design` skill makes it beautiful;
this guide keeps the workflow simple. — OTIUM AI Consultant*
