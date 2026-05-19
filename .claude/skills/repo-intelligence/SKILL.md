---
name: repo-intelligence
description: Use when quickly understanding an unfamiliar repository, library, framework, or tool before implementation or adoption.
required: false
roles:
  - researcher
  - architect
when_to_use:
  - repository analysis
  - dependency evaluation
  - onboarding to a codebase
source_inspired_by:
  - datacamp.com/blog/top-agent-skills
checks:
  - README and docs are inspected
  - structure, tests, CI, and examples are summarized
  - adoption risks are identified
---

# Repo Intelligence

Build a reliable map before acting.

Inspect:

- README, install docs, examples, and changelog.
- Folder structure and key entrypoints.
- Tests, CI, release process, and package manifests.
- Architecture boundaries and extension points.
- Open risks: stale code, missing docs, weak tests, unusual permissions.

Output a concise repo profile with recommended next actions.
