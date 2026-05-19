---
name: prompt-engineering
description: Use when designing prompts, agent instructions, eval prompts, or reusable task templates.
required: false
roles:
  - prompt-engineer
  - architect
when_to_use:
  - writing prompts
  - improving agent reliability
  - creating reusable instructions
source_inspired_by:
  - dair-ai/Prompt-Engineering-Guide
checks:
  - task and constraints are explicit
  - examples are relevant
  - output format is specified when needed
---

# Prompt Engineering

Reliable prompts make intent, constraints, and evaluation visible.

Prompt structure:

- Task: what the agent must accomplish.
- Context: facts and files it should use.
- Constraints: what not to do and what must be preserved.
- Output: expected format and level of detail.
- Evaluation: how success is judged.

Use examples for ambiguous formats, not as decoration.
