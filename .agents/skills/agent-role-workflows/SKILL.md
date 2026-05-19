---
name: Agent Role Workflows
description: Guide single-agent and future multi-agent usage across architect, implementer, tester, and reviewer roles.
required: false
roles:
  - architect
  - implementer
  - tester
  - reviewer
when_to_use:
  - planning a feature
  - splitting multi-agent work
  - reviewing task handoff
checks:
  - selected role is named before work starts
  - mandatory skills are still applied regardless of role
---

# Agent Role Workflows

Single-agent default:

1. Act as architect before edits.
2. Act as implementer during code changes.
3. Act as tester before completion.
4. Act as reviewer before final response.

Future multi-agent roles:

- Architect: structure, package choices, state management choice.
- Implementer: scoped feature code.
- Tester: tests and doctor output.
- Reviewer: convention, risk, and missing checks.

Mandatory skills always apply even when a role-specific skill is selected.
