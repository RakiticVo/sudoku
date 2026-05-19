---
name: zoom-out
description: Use when explaining or changing code that needs broader system context beyond the current file or function.
required: false
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - codebase onboarding
  - debugging complex flows
  - refactoring across boundaries
source_inspired_by:
  - mattpocock/skills/zoom-out
checks:
  - surrounding call flow is inspected
  - module role is explained
  - local change is tied to system impact
---

# Zoom Out

Avoid fixing the wrong local detail by understanding the wider system.

Process:

- Identify the local file, function, or module being inspected.
- Trace callers, dependencies, data flow, side effects, and ownership boundaries.
- Explain how the local behavior fits the feature, architecture, or runtime path.
- Surface upstream and downstream impacts before changing code.
- Recommend the smallest change that respects the broader design.

Use this when code looks confusing because the missing context lives outside the current file.

