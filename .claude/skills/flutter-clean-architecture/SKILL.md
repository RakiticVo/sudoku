---
name: Flutter Clean Architecture
description: Enforce feature-first Clean Architecture structure for Flutter apps.
required: true
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - creating a Flutter project
  - adding a feature
  - reviewing project structure
checks:
  - lib/core exists
  - lib/features exists
  - feature code separates data, domain, and presentation concerns
---

# Flutter Clean Architecture

Use feature-first Clean Architecture.

Required top-level structure:

```text
lib/
  core/
  features/
  shared/
test/
```

Each substantial feature should use:

```text
lib/features/<feature>/
  data/
  domain/
  presentation/
```

Rules:

- UI code depends on state/application interfaces, not raw network clients.
- Domain code must not import Flutter widgets or Dio.
- Data code owns DTOs, repositories implementations, and remote/local data sources.
- Shared utilities go in `lib/shared` only when reused by more than one feature.
