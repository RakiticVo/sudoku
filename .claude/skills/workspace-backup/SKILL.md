---
name: workspace-backup
description: Use before risky migrations, bulk edits, skill updates, config rewrites, or agent-driven project setup changes.
required: false
roles:
  - orchestrator
  - implementer
when_to_use:
  - before migrations
  - before skill updates
  - before destructive or broad changes
source_inspired_by:
  - datacamp.com/blog/top-agent-skills
checks:
  - current state is recorded
  - backup or restore path is known
  - uncommitted changes are handled
---

# Workspace Backup

Know how to recover before changing a lot.

Before risky work:

- Check git status.
- Commit, stash, or document uncommitted changes as appropriate.
- Back up config files that will be rewritten.
- Record current version/tag/tool state.
- Confirm restore steps.

Do not overwrite user changes without explicit permission.
