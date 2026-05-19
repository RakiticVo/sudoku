---
name: improve-codebase-architecture
description: Use when looking for architecture improvements in a codebase that is becoming hard to evolve, test, or understand.
required: false
roles:
  - architect
  - reviewer
when_to_use:
  - architecture review
  - boundary cleanup
  - reducing long-term codebase complexity
source_inspired_by:
  - mattpocock/skills/improve-codebase-architecture
checks:
  - domain language is checked
  - module boundaries are reviewed
  - recommendations are incremental
---

# Improve Codebase Architecture

Look for architectural improvements without turning the task into a rewrite.

Review:

- Domain language, module names, and concepts that no longer match the product.
- Dependency direction and hidden coupling.
- Files or modules with too many reasons to change.
- Tests that are hard to write because boundaries are unclear.
- ADRs or plans that no longer match implementation reality.

Output incremental recommendations with impact, risk, and verification. Prefer staged improvements over broad rewrites.

