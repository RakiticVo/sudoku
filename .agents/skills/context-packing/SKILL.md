---
name: context-packing
description: Use when preparing repository or project context for AI analysis, handoff, review, or long-context prompts.
required: false
roles:
  - researcher
  - orchestrator
when_to_use:
  - packing repo context
  - preparing handoffs
  - summarizing large codebases
source_inspired_by:
  - yamadashy/repomix
checks:
  - irrelevant files are excluded
  - structure and key files are summarized
  - sensitive data is not included
---

# Context Packing

Pack enough context for the task, not the whole filesystem.

Include:

- Relevant file tree.
- Key files and interfaces.
- Commands/configs that affect the task.
- Known constraints and open questions.

Exclude generated files, dependencies, secrets, build output, and unrelated assets unless they matter.
