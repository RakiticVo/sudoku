---
name: handoff
description: Use when summarizing a session so another agent or future session can continue without losing decisions, context, or next actions.
required: false
roles:
  - orchestrator
  - implementer
  - reviewer
when_to_use:
  - ending a work session
  - pausing long-running work
  - transferring work to another agent
source_inspired_by:
  - mattpocock/skills/handoff
checks:
  - current state is summarized
  - next actions are explicit
  - decisions and verification are recorded
---

# Handoff

Leave the next agent with enough context to continue safely.

Include:

- Goal and current status.
- Files, commands, docs, plans, and memory used.
- Decisions made and why.
- Work completed and verification evidence.
- Known risks, blockers, and skipped checks.
- Exact next actions.

Save to `.agent-plans/active/<plan-id>/HANDOFF.md` when available. For short tasks, include the handoff in the final response or AgentMemory.

