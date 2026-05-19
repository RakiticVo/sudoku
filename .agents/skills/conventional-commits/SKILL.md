---
name: conventional-commits
description: Use when writing commit messages, squash commit titles, changelog inputs, or release notes from commit history.
required: false
roles:
  - implementer
  - release-manager
when_to_use:
  - committing changes
  - preparing release notes
  - cleaning git history
source_inspired_by:
  - conventionalcommits.org
checks:
  - type reflects the change
  - scope is useful when present
  - breaking changes are explicit
---

# Conventional Commits

Use commit messages that support readable history and release notes.

Format:

```text
type(scope): summary
```

Common types:

- `feat`
- `fix`
- `docs`
- `refactor`
- `test`
- `chore`
- `ci`

Use `BREAKING CHANGE:` in the body when compatibility changes.
