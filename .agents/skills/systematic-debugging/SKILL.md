---
name: systematic-debugging
description: Use when diagnosing bugs, flaky behavior, regressions, crashes, or unexpected outputs.
required: false
roles:
  - debugger
  - implementer
when_to_use:
  - debugging failures
  - investigating flaky tests
  - fixing regressions
source_inspired_by:
  - obra/superpowers
  - addyosmani/agent-skills/debugging-and-error-recovery
  - mattpocock/skills/diagnose
checks:
  - bug is reproduced
  - root cause is identified
  - fix is verified against the reproduction
  - recovery or guardrail is added when appropriate
---

# Systematic Debugging

Debug from evidence.

Process:

- Reproduce the issue or isolate the failing signal.
- Minimize the reproduction until the failing path is understandable.
- Define expected vs actual behavior.
- Trace the smallest path from input to failure.
- Test hypotheses one at a time.
- Instrument with logs, assertions, or probes only where they answer a specific question.
- Fix the root cause, not just the symptom.
- Verify with the original reproduction and a regression test when possible.

Recovery rules:

- Stop broad changes when the failure signal is unclear.
- Reduce the failing case until it is small enough to reason about.
- Add logging, assertions, or guards only when they improve future diagnosis.
- Prefer safe fallbacks for user-facing failures, but still fix the root cause.
- Record the verified fix path if future agents are likely to hit the same issue.
