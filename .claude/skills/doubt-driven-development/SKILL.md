---
name: doubt-driven-development
description: Use for high-stakes work where confident assumptions should be challenged before implementation or completion.
required: false
roles:
  - security
  - reviewer
  - architect
when_to_use:
  - production risk
  - security-sensitive changes
  - irreversible or high-cost decisions
source_inspired_by:
  - addyosmani/agent-skills/doubt-driven-development
checks:
  - key claims are extracted
  - assumptions are challenged
  - reconciled decisions are recorded
---

# Doubt-Driven Development

Use structured skepticism when being wrong is expensive.

Process:

- Extract the key claims, assumptions, and proposed decisions.
- For each claim, ask what evidence would disprove it.
- Check the riskiest assumptions against source, tests, or project reality.
- Reconcile what changed after the doubt pass.
- Stop or ask for human approval if uncertainty remains high.

Apply this to auth, payments, data deletion, migrations, security boundaries, production releases, and unfamiliar systems.

