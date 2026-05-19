---
name: to-prd
description: Use when converting a conversation, rough idea, or clarified requirement into a product requirements document.
required: false
roles:
  - planner
  - product
  - architect
when_to_use:
  - writing PRDs
  - turning conversation into requirements
  - preparing feature scope
source_inspired_by:
  - mattpocock/skills/to-prd
checks:
  - problem and users are clear
  - acceptance criteria are testable
  - non-goals and open questions are listed
---

# To PRD

Turn working context into a product requirements document.

Recommended sections:

- Problem and target users.
- Goals and non-goals.
- User stories or core workflows.
- Functional requirements.
- UX, API, data, security, and migration notes when relevant.
- Acceptance criteria.
- Open questions and risks.

Save the PRD as `.agent-plans/active/<plan-id>/PRD.md` when a planning workspace exists. Otherwise, create a local markdown artifact or provide the PRD in the response.

