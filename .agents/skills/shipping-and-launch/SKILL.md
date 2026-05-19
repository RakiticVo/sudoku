---
name: shipping-and-launch
description: Use when preparing a feature, app, package, or release for launch with final checks, rollout notes, monitoring, and rollback.
required: false
roles:
  - devops
  - reviewer
  - implementer
when_to_use:
  - launching features
  - release preparation
  - production rollout
source_inspired_by:
  - addyosmani/agent-skills/shipping-and-launch
checks:
  - launch checklist is complete
  - smoke tests are defined
  - rollback and monitoring are ready
---

# Shipping And Launch

Ship with evidence, not hope.

Launch checklist:

- Confirm scope, version, owner, and release notes.
- Run required tests, build, lint, doctor, or smoke checks.
- Verify configuration, secrets, environment variables, and feature flags.
- Define rollout steps, monitoring signals, and rollback criteria.
- Record known risks and post-launch follow-up.

If rollback is unclear, treat the launch as blocked or ask for explicit approval.

