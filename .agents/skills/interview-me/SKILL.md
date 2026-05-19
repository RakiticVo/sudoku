---
name: interview-me
description: Use when a request is underspecified and the agent must ask focused questions before planning or implementation.
required: false
roles:
  - planner
  - architect
when_to_use:
  - unclear requirements
  - vague project ideas
  - high-impact assumptions
source_inspired_by:
  - addyosmani/agent-skills/interview-me
  - mattpocock/skills/grill-me
checks:
  - one question is asked at a time
  - assumptions are confirmed before planning
  - final understanding is summarized
  - strict interview mode is used for very vague requests
---

# Interview Me

Use a focused interview before planning when the request is too vague to implement safely.

Process:

- Explore available repo or project context first.
- Ask one high-impact question at a time.
- Prefer questions that change scope, constraints, data model, UX, architecture, or verification.
- Stop when the goal, success criteria, non-goals, constraints, and acceptance checks are clear.
- Summarize the agreed understanding before creating a plan or editing files.

Do not ask questions that the repository, existing docs, or installed skills can answer.

Strict interview mode:

- Use when the user has an idea but no clear user, outcome, scope, or acceptance signal.
- Ask one concise question at a time.
- Do not propose a plan until the answer changes the task from vague to implementable.
- Reflect contradictions and unresolved tradeoffs back to the user.
- End with a short confirmed brief before planning.
