---
name: pull-request-review
description: Use when preparing, reviewing, or responding to pull requests.
required: false
roles:
  - reviewer
  - implementer
when_to_use:
  - PR creation
  - PR review
  - addressing feedback
source_inspired_by:
  - GitHub review workflows
checks:
  - PR describes behavior and risk
  - tests or verification are listed
  - review feedback is addressed directly
---

# Pull Request Review

Make PRs easy to review.

PR content:

- What changed and why.
- User-visible behavior.
- Risk areas.
- Tests and manual verification.
- Screenshots or logs when relevant.

When addressing feedback, resolve the underlying issue and mention the verification.
