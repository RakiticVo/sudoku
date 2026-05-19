---
name: Using Agent Skills
description: Use when starting work in a repository that has installed agent skills.
required: true
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - starting any task
  - selecting relevant skills
  - checking installed project rules
checks:
  - skills lock file is read before planning
  - relevant skills are named in the plan
---

# Using Agent Skills

Before planning or editing:

- Read `.agents/skills.lock.json`.
- Read the relevant installed `SKILL.md` files.
- State which skills apply to the task.
- Treat required skills as mandatory project rules.
- Run the available doctor/check tools before finishing.

If the user does not mention skills, still follow this startup flow.
