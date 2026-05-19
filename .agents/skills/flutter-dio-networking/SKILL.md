---
name: Networking With Dio
description: Standardize API communication through Dio and repository boundaries.
required: true
roles:
  - implementer
  - reviewer
when_to_use:
  - adding API calls
  - handling tokens
  - mapping remote data
checks:
  - network calls are isolated in data sources
  - repositories map Dio failures into app/domain failures
---

# Networking With Dio

Use `dio` for HTTP.

Rules:

- Network calls belong in data-layer remote data sources.
- Repositories convert raw Dio responses and errors into app-level results or failures.
- UI code must not catch Dio exceptions directly.
- Token storage should use `flutter_secure_storage`.
- Keep request/response DTOs separate from domain entities when the API shape is unstable or external.
