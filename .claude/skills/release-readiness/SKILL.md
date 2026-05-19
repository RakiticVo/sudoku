---
name: release-readiness
description: Use when preparing a release, version bump, changelog, deployment, or rollback note.
required: false
roles:
  - release-manager
  - reviewer
when_to_use:
  - release preparation
  - versioning
  - deployment approval
source_inspired_by:
  - release management practice
checks:
  - version and changelog are updated
  - smoke tests are defined
  - rollback path is known
---

# Release Readiness

Release only when risk is visible.

Checklist:

- Version/tag strategy is clear.
- Changelog or release notes are updated.
- Required CI checks pass.
- Smoke tests cover critical flows.
- Migration and compatibility notes are documented.
- Rollback/recovery path is known.
