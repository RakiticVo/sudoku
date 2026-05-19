---
name: grill-with-docs
description: Use when clarifying requirements by cross-checking the request against existing docs, code, plans, ADRs, and domain language.
required: false
roles:
  - planner
  - researcher
  - architect
when_to_use:
  - requirements need clarification
  - existing docs may contradict the request
  - domain terminology matters
source_inspired_by:
  - mattpocock/skills/grill-with-docs
checks:
  - relevant docs and plans are inspected
  - terminology conflicts are surfaced
  - open questions and doc updates are listed
---

# Grill With Docs

Clarify the request against project reality before planning.

Process:

- Read relevant docs such as `README.md`, `CONTEXT.md`, `.agent-plans/`, ADRs, issue notes, and nearby code.
- Identify terminology, constraints, existing decisions, and contradictions.
- Ask focused questions that reference the docs or code that created the ambiguity.
- Summarize clarified requirements, updated terminology, open questions, and suggested doc or ADR updates.

Use this when a normal interview is not enough because the project already has language, decisions, or history that must shape the answer.

