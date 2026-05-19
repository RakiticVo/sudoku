---
name: solid-principles
description: Use when reviewing object/module design for responsibility, coupling, substitutability, interface size, or dependency direction.
required: false
roles:
  - architect
  - reviewer
when_to_use:
  - code review
  - refactoring
  - API design
source_inspired_by:
  - general SOLID practice
checks:
  - responsibilities are cohesive
  - abstractions reduce concrete coupling
  - interfaces are not bloated
---

# SOLID Principles

Use SOLID as a review lens, not dogma.

Check:

- Single responsibility: one reason to change.
- Open/closed: extension should not require risky edits to stable code.
- Liskov substitution: consumers should not need type-specific surprises.
- Interface segregation: clients should not depend on methods they do not use.
- Dependency inversion: high-level policy should depend on stable abstractions.

Prefer simpler code over artificial abstractions.
