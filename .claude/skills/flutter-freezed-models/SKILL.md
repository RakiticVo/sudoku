---
name: Immutable Models
description: Use freezed and JSON serialization for stable app models and DTOs.
required: true
roles:
  - implementer
  - reviewer
when_to_use:
  - creating DTOs
  - creating immutable state
  - creating API response models
checks:
  - immutable classes use freezed when they need copyWith/equality
  - JSON DTOs use json_serializable
---

# Immutable Models

Use `freezed` for immutable state and models that need value equality, unions, or `copyWith`.

Use `json_serializable` for API DTO serialization.

Rules:

- Do not hand-write large JSON mapping code when generated serialization is practical.
- Keep generated files out of manual edits.
- Run build generation after adding or changing generated models.
