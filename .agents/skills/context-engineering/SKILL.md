---
name: context-engineering
description: Use when preparing the right instructions, project files, docs, memory, and tools before an agent starts or resumes work.
required: false
roles:
  - orchestrator
  - researcher
  - implementer
when_to_use:
  - starting an agent session
  - switching tasks
  - output quality is dropping
source_inspired_by:
  - addyosmani/agent-skills/context-engineering
checks:
  - relevant project files are selected
  - installed skills and memory are checked
  - stale or noisy context is excluded
---

# Context Engineering

Give the agent the right context at the right time.

Context checklist:

- Read bootstrap files, skill lock files, and relevant installed skills.
- Search AgentMemory for durable decisions and project conventions when available.
- Select only the source files, docs, examples, plans, and issue context needed for the task.
- Exclude generated output, vendored code, unrelated logs, secrets, and stale notes.
- State what context is being used and what is intentionally left out.

If context is too large, summarize structure first and load details only when needed.

