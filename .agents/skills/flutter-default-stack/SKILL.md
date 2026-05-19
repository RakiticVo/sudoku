---
name: Default Flutter Stack
description: Default package and tooling choices for personal Flutter AI-assisted projects.
required: true
roles:
  - architect
  - implementer
when_to_use:
  - creating a Flutter project
  - adding dependencies
  - choosing app foundation packages
checks:
  - get_it is present
  - dio is present
  - freezed/json_serializable are present when immutable API models are added
---

# Default Flutter Stack

Use latest stable packages during project creation, then pin with `pubspec.lock`.

Default packages:

- Routing: `go_router`
- Dependency injection: `get_it`
- Network: `dio`
- Immutable models: `freezed_annotation`, `json_annotation`
- Code generation: `build_runner`, `freezed`, `json_serializable`
- Local settings: `shared_preferences`
- Secrets/tokens: `flutter_secure_storage`
- Logging: `logger`
- Tests/mocks: `flutter_test`, `mocktail`

Use `flutter pub outdated` only during controlled dependency update work.
