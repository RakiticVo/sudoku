---
name: clean-architecture
description: Use when designing or reviewing application boundaries, layers, dependencies, or feature/module structure.
required: false
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - creating architecture
  - refactoring boundaries
  - reviewing dependency direction
source_inspired_by:
  - general clean architecture practice
checks:
  - dependencies point inward or toward stable abstractions
  - business logic is testable without UI or infrastructure
  - modules have clear responsibilities
---

# Clean Architecture

Separate policy from details.

Guidelines:

- Business rules should not depend on UI, database, network, or framework details.
- Infrastructure implements interfaces owned by inner layers.
- Feature boundaries should be understandable without scanning the whole app.
- Keep DTOs, persistence models, and domain objects separate when external shapes are unstable.

Use architecture to reduce coupling, not to add ceremony.
