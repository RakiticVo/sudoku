---
name: agent-memory
description: Use when deciding what project knowledge, preferences, decisions, or summaries should be stored for future agent sessions.
required: false
roles:
  - orchestrator
  - reviewer
when_to_use:
  - preserving project memory
  - summarizing decisions
  - avoiding repeated context loss
source_inspired_by:
  - thedotmack/claude-mem
checks:
  - only durable decisions are stored
  - sensitive data is not stored
  - memory is concise and retrievable
---

# Agent Memory

Store durable knowledge, not conversation noise.

Record:

- Project conventions.
- Architectural decisions.
- User preferences that affect future work.
- Known constraints and recurring commands.

Do not store secrets, temporary guesses, or stale debugging notes. Keep memory short enough to be useful.
