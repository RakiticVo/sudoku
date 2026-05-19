---
name: reasoning-before-action
description: Use when a task has ambiguity, multiple interpretations, hidden assumptions, tradeoffs, or non-trivial implementation risk.
required: false
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - starting non-trivial work
  - resolving ambiguous requests
  - choosing between approaches
source_inspired_by:
  - multica-ai/andrej-karpathy-skills
checks:
  - assumptions are stated before action
  - success criteria are explicit
  - confusion or tradeoffs are surfaced
---

# Reasoning Before Action

Before acting, identify what is known, what is assumed, and what would make the result successful.

Use this pattern:

- Restate the goal in one sentence.
- Name assumptions and risks.
- Surface tradeoffs when there are multiple valid approaches.
- Ask only for information that cannot be discovered.
- Define verification before implementation.

Do not silently choose an interpretation when the cost of being wrong is high.
