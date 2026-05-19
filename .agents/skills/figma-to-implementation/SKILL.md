---
name: figma-to-implementation
description: Use when implementing UI from Figma files, design specs, components, or tokens.
required: false
roles:
  - designer
  - implementer
when_to_use:
  - reading Figma designs
  - mapping components
  - implementing UI
source_inspired_by:
  - Figma implementation workflows
checks:
  - tokens are mapped before styling
  - reusable components are identified
  - responsive and interaction states are handled
---

# Figma To Implementation

Translate design intent, not only pixels.

Steps:

- Identify screen purpose and primary user flow.
- Extract tokens and component variants.
- Map Figma components to existing code components.
- Note missing states: hover, loading, disabled, empty, error.
- Implement responsively and verify against the design.

Ask for clarification when design states are missing and behavior matters.
