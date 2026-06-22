# projects/

An index of your clients / projects / deals — one card per project. Cards, not code.

When you mention a new client or project, your AI creates a card here proactively with
what's known (name, type, date, value, status) and links the client. Leave unknowns blank;
never invent values.

Suggested card shape (`projects/{client-or-project}.md`):
```
---
tags: [project]
---
# {Project name}
- Client: [[{client}]]
- Type: {what it is}
- Date: {when}
- Value: {amount, if known}
- Status: {lead / active / done}

## Notes
...
```
