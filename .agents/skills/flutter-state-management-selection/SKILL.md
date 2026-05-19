---
name: State Management Selection
description: Choose Provider, Riverpod, Bloc, or Cubit using project complexity rules.
required: true
roles:
  - architect
  - implementer
when_to_use:
  - selecting state management
  - creating a feature
  - refactoring presentation logic
checks:
  - exactly one primary state management pattern is selected per feature
  - Cubit is used when uncertainty remains
---

# State Management Selection

Allowed options:

- `Provider`
- `Riverpod`
- `Bloc`
- `Cubit`

Selection rules:

- Small app with simple local state: use `Provider`.
- Medium or large app with clear state transitions: use `Cubit`.
- Event-heavy flow with many user/system events: use `Bloc`.
- Complex async provider graph or composition-heavy state: use `Riverpod`.
- If there is not enough context, default to `Cubit`.

Do not mix state management libraries inside a single feature unless the existing project already requires it.
