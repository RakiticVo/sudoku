---
name: planning
description: Use when converting an approved goal or spec into implementation steps before changing files.
required: false
roles:
  - planner
  - architect
when_to_use:
  - preparing multi-step implementation
  - handing off work to another agent
  - defining verification steps
source_inspired_by:
  - obra/superpowers
checks:
  - plan is decision-complete
  - verification is included
  - tasks are independently understandable
---

# Planning

Plans should remove implementation guesswork.

Include:

- Goal and success criteria.
- Main subsystems or files affected.
- Interfaces, data shapes, or commands that change.
- Step order with verification.
- Explicit assumptions and defaults.

Keep plans practical. Avoid placeholders such as "handle edge cases" without saying which cases.
