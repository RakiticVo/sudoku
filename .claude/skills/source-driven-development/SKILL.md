---
name: source-driven-development
description: Use when framework, API, package, or platform decisions must be grounded in official or primary sources.
required: false
roles:
  - researcher
  - architect
  - implementer
when_to_use:
  - choosing libraries or APIs
  - using unfamiliar frameworks
  - implementation depends on current docs
source_inspired_by:
  - addyosmani/agent-skills/source-driven-development
checks:
  - official or primary sources are consulted
  - source dates or versions are considered
  - unverified claims are flagged
---

# Source-Driven Development

Ground framework and package decisions in authoritative sources.

Rules:

- Prefer official docs, source repositories, changelogs, specs, and package registries.
- Check version compatibility before recommending APIs or packages.
- Cite or record the source used when the decision may affect implementation.
- Separate confirmed facts from inference.
- If source quality is weak, say what remains uncertain.

Use this before adding dependencies, using unfamiliar APIs, or changing framework-specific architecture.

