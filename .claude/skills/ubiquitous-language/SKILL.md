---
name: ubiquitous-language
description: Use when a project needs consistent domain terminology across docs, code, issues, plans, and agent memory.
required: false
roles:
  - planner
  - architect
  - writer
when_to_use:
  - defining domain language
  - reducing terminology drift
  - onboarding agents to a project
source_inspired_by:
  - mattpocock/skills
checks:
  - canonical terms are recorded
  - synonyms and forbidden terms are listed
  - docs and code naming conflicts are flagged
---

# Ubiquitous Language

Keep agents and humans using the same domain words.

Store terminology in `CONTEXT.md` by default. If the project uses `.agent-plans/`, also link or mirror the terms in `.agent-plans/domain-language.md`.

Track:

- Canonical terms and short definitions.
- Synonyms, aliases, and terms to avoid.
- Domain entities and relationships.
- Naming mismatches in code, docs, issues, or UI copy.
- Decisions that changed terminology.

Use this before writing PRDs, issues, docs, or architecture plans for domain-heavy projects.

