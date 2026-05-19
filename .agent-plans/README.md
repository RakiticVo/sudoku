# Agent Plans

Persistent planning workspace for AI-assisted work.

## Structure

```text
.agent-plans/
  INDEX.md
  active/
  archived/
  decisions/
  templates/
```

Use this folder to preserve specs, plans, task breakdowns, decisions, checkpoints, and handoff notes across sessions.

Rules:

- Update `INDEX.md` whenever a plan is created, completed, paused, or superseded.
- Store active work in `active/<plan-id>/`.
- Store decision records in `decisions/`.
- Move completed or obsolete plans to `archived/`.
- Do not delete historical plans that explain why direction changed.
