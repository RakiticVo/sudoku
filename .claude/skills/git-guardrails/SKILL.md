---
name: git-guardrails
description: Use before running git commands that can rewrite history, discard work, publish changes, or affect shared branches.
required: false
roles:
  - implementer
  - reviewer
  - orchestrator
when_to_use:
  - git operations
  - before destructive commands
  - publishing changes
source_inspired_by:
  - mattpocock/skills/git-guardrails-claude-code
checks:
  - working tree state is inspected
  - destructive commands require explicit approval
  - push targets are verified
---

# Git Guardrails

Protect user work and shared history.

Rules:

- Inspect `git status` before staging, committing, switching branches, or publishing.
- Never discard, reset, clean, overwrite, or force-push without explicit user approval.
- Do not stage unrelated user changes unless the user asked for that scope.
- Verify branch and remote before pushing.
- Prefer small commits with clear intent.
- Explain skipped git actions when the worktree is dirty or ambiguous.

Treat unrecognized changes as user work.

