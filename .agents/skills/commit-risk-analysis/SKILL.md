---
name: commit-risk-analysis
description: Use when reviewing commits, diffs, or branches for behavioral risk, breaking changes, missing tests, or release impact.
required: false
roles:
  - reviewer
  - release-manager
when_to_use:
  - reviewing commits
  - release preparation
  - assessing change risk
source_inspired_by:
  - datacamp.com/blog/top-agent-skills
checks:
  - risky files and behaviors are identified
  - test gaps are listed
  - release impact is stated
---

# Commit Risk Analysis

Review commits by blast radius.

Check:

- User-visible behavior changes.
- Data model, migration, auth, billing, or permission changes.
- Public API or contract compatibility.
- Tests added or missing.
- Config/deployment changes.
- Rollback difficulty.

Summarize risk as low/medium/high with concrete reasons.
