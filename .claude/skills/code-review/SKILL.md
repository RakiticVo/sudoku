---
name: code-review
description: Use when reviewing code changes for correctness, regressions, missing tests, maintainability, or security risk.
required: false
roles:
  - reviewer
when_to_use:
  - reviewing diffs
  - checking implementation quality
  - preparing PR feedback
source_inspired_by:
  - obra/superpowers
  - addyosmani/agent-skills/code-review-and-quality
checks:
  - findings are ordered by severity
  - issues cite concrete files or behavior
  - missing tests are noted
  - change size and reviewability are assessed
---

# Code Review

Prioritize defects over style.

Review order:

- Behavioral correctness and regressions.
- Data loss, security, concurrency, and error handling risks.
- Missing or weak tests.
- API compatibility and migration risk.
- Maintainability only when it affects the change.

Lead with findings. If no issues are found, state residual risk and test gaps.

Quality gates:

- Ask whether the change is small enough to review reliably.
- Prefer splitting unrelated behavior, formatting, and refactors.
- Treat unclear ownership, hidden coupling, and missing rollback paths as risks.
- Label feedback by severity: blocking defect, risk, optional improvement, or nit.
- Verify that evidence in the PR or final response matches the actual checks run.
