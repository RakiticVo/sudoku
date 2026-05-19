---
name: to-issues
description: Use when converting a PRD, spec, or plan into small implementation issues with acceptance criteria and verification.
required: false
roles:
  - planner
  - orchestrator
when_to_use:
  - creating implementation issues
  - breaking down PRDs
  - preparing team or agent handoff
source_inspired_by:
  - mattpocock/skills/to-issues
checks:
  - each issue is independently understandable
  - acceptance criteria and verification are included
  - dependencies are explicit
---

# To Issues

Convert requirements into implementable issues.

Issue template:

```markdown
# Short issue title

Type: feature | bug | chore | docs | test | refactor
Status: ready | needs-info | blocked
Context:
Acceptance criteria:
- [ ] Specific observable result
Verification:
- [ ] Test, command, review, or manual check
Dependencies:
Files or areas likely touched:
```

If there is no issue tracker integration, write local markdown files under `.agent-plans/active/<plan-id>/issues/`.

