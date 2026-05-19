---
name: test-driven-development
description: Use when implementing behavior where tests can define the desired outcome before or during coding.
required: false
roles:
  - implementer
  - tester
when_to_use:
  - feature implementation
  - bug fixes
  - refactoring behavior
source_inspired_by:
  - obra/superpowers
  - addyosmani/agent-skills/test-driven-development
  - mattpocock/skills/tdd
checks:
  - failing test is created or identified first
  - implementation is minimal
  - tests pass after change
  - regression risk is covered at the right test level
---

# Test-Driven Development

Use red-green-refactor where practical.

Cycle:

- Write or identify a test that captures the desired behavior.
- Run it and confirm it fails for the expected reason.
- Implement the smallest change that passes.
- Refactor only with tests green.
- Keep regression tests for bugs.

If TDD is not practical, explain why and add the closest useful verification.

Test selection:

- Prefer fast unit tests for domain logic and edge cases.
- Add integration tests for boundaries, persistence, networking, or framework behavior.
- Use UI/browser tests only for behavior that cannot be proven lower in the stack.
- Write tests that describe behavior clearly, even if that means some repetition.
- For bug fixes, keep the reproduction as a regression test whenever possible.

Test quality:

- Prefer tests that fail for one meaningful reason.
- Avoid tests that only restate implementation details.
- For UI or integration work, test the vertical slice that proves user-visible behavior.
- If a test is brittle, simplify the design or test the behavior at a better boundary.
