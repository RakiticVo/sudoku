---
name: gitflow
description: Use when planning branches, commits, feature flow, hotfixes, or release branching.
required: false
roles:
  - implementer
  - reviewer
when_to_use:
  - branch planning
  - feature development
  - release or hotfix work
source_inspired_by:
  - GitFlow practice
checks:
  - branch purpose is clear
  - commits are scoped
  - merge/release path is explicit
---

# GitFlow

Keep Git history useful and recoverable.

Guidelines:

- Name branches by purpose.
- Keep commits focused and explain why.
- Avoid mixing unrelated work.
- Use release/hotfix branches only when the project workflow requires them.
- Confirm target branch and merge strategy before publishing.
