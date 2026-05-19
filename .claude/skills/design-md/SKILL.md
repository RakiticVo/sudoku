---
name: design-md
description: Use when creating or maintaining DESIGN.md as a source of truth for product design, tokens, rationale, and implementation guidance.
required: false
roles:
  - designer
  - implementer
when_to_use:
  - documenting design systems
  - translating designs into code
  - preserving design rationale
source_inspired_by:
  - google-labs-code/design.md
checks:
  - design rationale is captured
  - tokens and components are documented
  - implementation constraints are explicit
---

# DESIGN.md

Use `DESIGN.md` to preserve design decisions across agents and sessions.

Include:

- Product/design goals.
- Visual principles and constraints.
- Tokens: color, type, spacing, radius, elevation.
- Component behavior and states.
- Responsive rules.
- Implementation notes and non-goals.

Keep it practical enough for an implementation agent to follow.
