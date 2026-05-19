---
name: Dependency Injection With get_it
description: Standardize dependency registration and access through get_it.
required: true
roles:
  - implementer
  - reviewer
when_to_use:
  - adding services
  - adding repositories
  - wiring feature dependencies
checks:
  - get_it is used for service/repository registration
  - widgets do not instantiate network clients directly
---

# Dependency Injection With get_it

Use `get_it` for app-level dependencies.

Rules:

- Register Dio clients, data sources, repositories, use cases, and Cubits/Blocs in one predictable injection entrypoint.
- Do not create Dio, repositories, or data sources inside widgets.
- Prefer constructor injection for classes that need dependencies.
- Keep test code able to replace dependencies with mocks or fakes.
