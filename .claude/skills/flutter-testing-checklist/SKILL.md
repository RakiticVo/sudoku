---
name: Testing Checklist
description: Require targeted tests and final checks before completing Flutter work.
required: true
roles:
  - tester
  - reviewer
  - implementer
when_to_use:
  - completing any feature
  - reviewing changes
  - fixing regressions
checks:
  - tests exist for changed business logic
  - doctor passes or issues are reported
---

# Testing Checklist

Before finishing a task:

- Add or update tests for changed business logic.
- For Cubit/Bloc features, use `bloc_test` where state transitions matter.
- For repositories, mock remote/local data sources with `mocktail`.
- For widgets, use `flutter_test` and keep assertions behavior-focused.
- Run `flutter test` when Flutter is available.
- Run `agent-skills doctor --project .` when this tool is available.

If a check cannot run, report why and what risk remains.
