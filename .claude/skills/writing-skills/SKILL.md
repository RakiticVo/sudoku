---
name: Writing Skills
description: Use when creating or revising an agent skill.
required: false
roles:
  - skill-author
  - reviewer
when_to_use:
  - adding a new skill
  - revising skill triggers
  - checking whether a skill is actionable
checks:
  - description describes when to use the skill
  - skill includes concrete checks
  - mandatory rules are backed by doctor/test checks when possible
source_inspired_by:
  - mattpocock/skills/write-a-skill
---

# Writing Skills

Skills are operational instructions, not essays.

Rules:

- The description should explain when to use the skill.
- Keep instructions direct and testable.
- Put mandatory behavior in checks when possible.
- Include examples only when they prevent common mistakes.
- Avoid domain claims that are broader than the skill can enforce.

Before finishing a skill, test it against likely user tasks and failure modes.

Skill quality checklist:

- Trigger is specific enough that an agent knows when to use it.
- Instructions are operational, not motivational.
- Required checks are observable.
- Extra references are loaded only when needed.
- The skill does not hide side effects, broad permissions, or unrelated automation.
