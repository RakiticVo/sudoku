---
name: api-and-interface-design
description: Use when designing APIs, module boundaries, public contracts, validation, errors, compatibility, or integration surfaces.
required: false
roles:
  - architect
  - implementer
  - reviewer
when_to_use:
  - API design
  - module boundary design
  - public interface changes
source_inspired_by:
  - addyosmani/agent-skills/api-and-interface-design
checks:
  - contract is explicit
  - errors and validation are defined
  - compatibility risk is reviewed
---

# API And Interface Design

Design contracts before implementation details.

Checklist:

- Define inputs, outputs, errors, and validation rules.
- Keep public contracts smaller and more stable than internal implementation.
- Treat undocumented behavior as likely to become depended on.
- Version or migrate breaking changes intentionally.
- Include examples for important success and failure cases.
- Test boundary behavior, not only happy paths.

Use this for HTTP APIs, package APIs, module boundaries, repository interfaces, service contracts, and plugin schemas.

