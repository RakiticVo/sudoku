---
name: surgical-changes
description: Use when editing an existing codebase where unrelated changes, cleanup, or broad refactors could create risk.
required: false
roles:
  - implementer
  - reviewer
when_to_use:
  - fixing bugs
  - making scoped changes
  - working in unfamiliar code
source_inspired_by:
  - multica-ai/andrej-karpathy-skills
checks:
  - every changed line supports the task
  - unrelated formatting/refactors are avoided
  - existing style is matched
---

# Surgical Changes

Change the minimum code necessary to meet the goal.

Rules:

- Do not improve adjacent code unless it blocks the task.
- Match local style and patterns.
- Remove only dead code created by your own change.
- Mention unrelated issues instead of fixing them silently.
- Keep diffs easy to review.

If the task requires broader cleanup, make that scope explicit first.
