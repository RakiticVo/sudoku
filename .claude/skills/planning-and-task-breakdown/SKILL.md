---
name: planning-and-task-breakdown
description: Use when breaking a validated spec or clear goal into ordered, verifiable implementation tasks.
required: false
roles:
  - planner
  - architect
when_to_use:
  - task decomposition
  - estimating scope
  - parallelizing work
source_inspired_by:
  - addyosmani/agent-skills/planning-and-task-breakdown
checks:
  - tasks have acceptance criteria
  - tasks have verification steps
  - dependencies and checkpoints are identified
  - tasks are small enough to implement and verify independently
---

# Planning And Task Breakdown

Break work into small, verifiable tasks.

Task template:

```markdown
## Task N: Short title

Status: pending | in-progress | blocked | done
Description: One paragraph.
Acceptance criteria:
- [ ] Specific testable condition
Verification:
- [ ] Test/build/manual command or check
Dependencies: None or task IDs
Files likely touched:
- path/to/file
Estimated scope: XS | S | M | L
```

Planning rules:

- Build dependency foundations first.
- Prefer vertical feature slices over horizontal layer-only tasks.
- Add checkpoints after every 2-3 tasks.
- Mark high-risk work early so it fails fast.
- Break down any task that touches unrelated subsystems or cannot fit in one focused session.
- Order tasks so each completed step leaves the project in a coherent state.
- Include explicit handoff notes when a task can be delegated to another agent.
- Split tasks that require different verification methods, such as unit tests, browser checks, or deployment smoke tests.
