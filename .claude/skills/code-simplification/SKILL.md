---
name: code-simplification
description: Use when working code is harder to understand, maintain, test, or change than it needs to be.
required: false
roles:
  - implementer
  - reviewer
when_to_use:
  - simplifying code
  - reducing complexity
  - preparing refactors
source_inspired_by:
  - addyosmani/agent-skills/code-simplification
checks:
  - behavior is preserved
  - reason for existing code is understood
  - tests or verification cover the simplification
---

# Code Simplification

Simplify only after understanding why the current code exists.

Rules:

- Preserve behavior unless the task explicitly changes it.
- Check history, tests, docs, or surrounding code before removing logic.
- Prefer fewer branches, clearer names, smaller functions, and less hidden coupling.
- Delete dead code only when it is proven unused or intentionally deprecated.
- Run focused tests before and after simplification.

If the simplification changes behavior, treat it as a feature or bug fix with its own acceptance criteria.

