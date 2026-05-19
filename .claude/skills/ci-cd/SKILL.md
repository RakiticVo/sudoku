---
name: ci-cd
description: Use when designing or reviewing CI/CD pipelines, build checks, test gates, deployments, or environment safety.
required: false
roles:
  - devops
  - reviewer
when_to_use:
  - CI setup
  - deployment flow
  - release checks
source_inspired_by:
  - CI/CD practice
checks:
  - build/test/lint gates are clear
  - secrets are protected
  - rollback or recovery path exists
---

# CI/CD

Pipelines should catch risk before production.

Check:

- Build, lint, and test gates.
- Dependency/cache behavior.
- Secrets and environment variables.
- Artifact/version traceability.
- Deployment approvals and rollback path.
- Notifications for failures.

Keep pipelines deterministic and fast enough for regular use.
