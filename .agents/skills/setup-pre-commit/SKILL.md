---
name: setup-pre-commit
description: Use when adding or reviewing pre-commit hooks for formatting, linting, typechecking, tests, or safety checks.
required: false
roles:
  - devops
  - implementer
  - reviewer
when_to_use:
  - setting up hooks
  - improving local quality gates
  - preventing repeat mistakes
source_inspired_by:
  - mattpocock/skills/setup-pre-commit
checks:
  - project stack is inspected first
  - hooks are fast and relevant
  - bypass and CI relationship are documented
---

# Setup Pre-Commit

Add local quality gates that match the project.

Process:

- Inspect the project stack, package manager, existing scripts, formatter, linter, typechecker, and tests.
- Choose fast checks that catch common mistakes without making commits painful.
- Keep expensive checks in CI unless the project explicitly wants strict local gates.
- Document how to install hooks, run them manually, and bypass them responsibly.
- Ensure CI still enforces important checks; hooks are convenience, not the only guard.

Do not introduce a hook framework that conflicts with the existing toolchain.

