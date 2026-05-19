---
name: agent-role-routing
description: Use when selecting agent roles such as architect, implementer, tester, reviewer, designer, or researcher.
required: false
roles:
  - orchestrator
  - planner
when_to_use:
  - choosing agent roles
  - routing tasks
  - defining handoffs
source_inspired_by:
  - VoltAgent/awesome-claude-code-subagents
checks:
  - role matches task type
  - role output is defined
  - handoff criteria are clear
---

# Agent Role Routing

Match the role to the work.

Common roles:

- Architect: approach, boundaries, tradeoffs.
- Implementer: scoped code changes.
- Tester: verification and regressions.
- Reviewer: risk and quality findings.
- Designer: UI/UX direction and review.
- Researcher: source-grounded synthesis.

Define what each role must return before work starts.
