---
name: multi-agent-orchestration
description: Use when splitting work across multiple agents, subagents, roles, or parallel tasks.
required: false
roles:
  - orchestrator
  - architect
when_to_use:
  - multi-agent work
  - parallel implementation
  - task delegation
source_inspired_by:
  - obra/superpowers
  - shanraisshan/claude-code-best-practice
checks:
  - each agent has clear ownership
  - write scopes do not conflict
  - integration and verification are planned
---

# Multi-Agent Orchestration

Delegate only when it reduces risk or time.

Rules:

- Split work by independent ownership.
- Give each agent a concrete output and write scope.
- Avoid duplicate investigation.
- Keep urgent blocking work local.
- Integrate results deliberately and verify the combined behavior.

Do not spawn agents just to appear thorough.
