---
name: issue-triage
description: Use when classifying issues, task lists, bug reports, or feature requests before planning or implementation.
required: false
roles:
  - planner
  - reviewer
  - orchestrator
when_to_use:
  - issue triage
  - backlog cleanup
  - deciding readiness
source_inspired_by:
  - mattpocock/skills/triage
checks:
  - issue type is assigned
  - readiness state is clear
  - missing information is requested
---

# Issue Triage

Classify work before assigning it.

Use these labels or local equivalents:

- Type: `bug`, `feature`, `chore`, `docs`, `test`, `refactor`.
- State: `ready`, `needs-info`, `blocked`, `duplicate`, `wont-do`.
- Risk: `low`, `medium`, `high`.

For each issue:

- Restate the user-visible problem or requested outcome.
- Identify missing context, reproduction steps, source docs, or design decisions.
- Decide whether the issue is ready for implementation.
- Link related PRDs, specs, plans, ADRs, or memory notes.

