---
name: project-plan-ledger
description: Use when starting a project, feature, migration, or multi-session effort that needs persistent planning history.
required: false
roles:
  - planner
  - architect
  - orchestrator
when_to_use:
  - starting a project
  - creating a long-running feature plan
  - resuming work across sessions
source_inspired_by:
  - addyosmani/agent-skills/planning-and-task-breakdown
  - addyosmani/agent-skills/spec-driven-development
checks:
  - .agent-plans/INDEX.md is updated
  - active plan has status and next action
  - superseded plans link to the replacing plan
---

# Project Plan Ledger

Store project plans in `.agent-plans/` so work survives session changes, context compaction, and agent handoffs.

Recommended structure:

```text
.agent-plans/
  INDEX.md
  active/
  archived/
  decisions/
  templates/
```

Rules:

- Create one plan per project, feature, migration, or substantial investigation.
- Keep `INDEX.md` as the current map of active, paused, completed, and superseded plans.
- Update the plan before implementation when scope or decisions change.
- Never delete old plans that explain why work changed direction; move them to `archived/` or mark them superseded.
- Every active plan must include status, owner/agent role, next action, risks, and verification.

Use this skill before writing code when a task will take multiple sessions or produce multiple tasks.
