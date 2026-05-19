---
name: verification-before-completion
description: Use before claiming a task is complete, especially after code, config, docs, or generated artifacts changed.
required: false
roles:
  - implementer
  - tester
  - reviewer
when_to_use:
  - finishing tasks
  - reporting completion
  - validating generated work
source_inspired_by:
  - obra/superpowers
checks:
  - relevant checks were run
  - skipped checks are explained
  - final answer reports residual risk
---

# Verification Before Completion

Do not say done until the result is checked.

Before final response:

- Run the relevant tests, builds, linters, or doctor checks.
- Inspect generated files or UI artifacts when applicable.
- State what passed.
- State what could not run and why.
- Mention remaining risk briefly.
