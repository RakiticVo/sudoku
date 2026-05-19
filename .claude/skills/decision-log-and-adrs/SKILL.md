---
name: decision-log-and-adrs
description: Use when recording architectural decisions, plan pivots, tradeoffs, or choices that future agents should not re-litigate.
required: false
roles:
  - architect
  - planner
  - reviewer
when_to_use:
  - architectural decisions
  - major scope changes
  - choosing between approaches
source_inspired_by:
  - addyosmani/agent-skills/documentation-and-adrs
checks:
  - decision records include context and alternatives
  - superseded decisions are not deleted
  - plans link to relevant decisions
  - public API and architecture changes explain why
---

# Decision Log And ADRs

Capture why a decision was made, not only what changed.

Store project planning decisions under:

```text
.agent-plans/decisions/
```

Decision record template:

```markdown
# ADR-0001: Title

Status: proposed | accepted | superseded | deprecated
Date: YYYY-MM-DD
Context:
Decision:
Alternatives considered:
Consequences:
Linked plans:
```

When a decision changes, write a new record and mark the old one superseded.

Document:

- The reason behind the decision, not only the chosen option.
- Rejected alternatives and the tradeoffs that made them weaker.
- API, migration, testing, security, and rollout consequences when relevant.
- Follow-up review dates for decisions that may expire.

Do not rewrite history by deleting older decisions; link to the newer record instead.
