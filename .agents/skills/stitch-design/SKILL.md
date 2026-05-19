---
name: stitch-design
description: Use when working with Google Stitch, prompt enhancement, design generation, or design-to-implementation workflows.
required: false
roles:
  - designer
  - implementer
when_to_use:
  - using Stitch
  - generating UI concepts
  - translating visual design into app structure
source_inspired_by:
  - google-labs-code/stitch-skills
checks:
  - prompt includes product context and target screen
  - design system constraints are provided
  - generated output is reviewed before implementation
---

# Stitch Design

Use Stitch as a design collaborator, not a replacement for design judgment.

Workflow:

- Define product context, target user, screen purpose, and platform.
- Provide constraints: brand, density, components, responsiveness.
- Ask for alternatives when the direction is not clear.
- Review hierarchy, spacing, contrast, and component states.
- Convert approved output into implementation tasks.

Keep generated visuals aligned with the app's design system.
