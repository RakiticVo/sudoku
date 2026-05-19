---
name: Writing Plans
description: Use when converting an approved idea or task into a precise implementation plan.
required: false
roles:
  - architect
  - planner
when_to_use:
  - preparing implementation
  - decomposing multi-step work
  - handing work to another agent
checks:
  - plan identifies behavior changes
  - plan includes verification
  - plan leaves no major implementation decision open
---

# Writing Plans

A good plan is decision complete.

Include:

- Desired behavior.
- Main files or subsystems affected.
- Interfaces, commands, or data shapes that change.
- Tests and acceptance checks.
- Assumptions and explicit defaults.

Keep plans compact, but concrete enough that another agent can implement without guessing.
