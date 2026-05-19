---
name: ui-prompt-enhancement
description: Use when turning vague UI requests into precise prompts for Stitch, Figma workflows, or implementation agents.
required: false
roles:
  - designer
  - prompt-engineer
when_to_use:
  - enhancing UI prompts
  - generating design concepts
  - preparing design tasks
source_inspired_by:
  - google-labs-code/stitch-skills
checks:
  - prompt names platform and screen
  - audience and workflow are included
  - visual constraints are explicit
---

# UI Prompt Enhancement

Make UI prompts specific enough to produce usable designs.

Include:

- Product/domain and target user.
- Screen or flow being designed.
- Primary actions and information hierarchy.
- Platform and viewport constraints.
- Design system, tone, and accessibility requirements.
- States that must be represented.

Avoid purely aesthetic prompts without workflow context.
