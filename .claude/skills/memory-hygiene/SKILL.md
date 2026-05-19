---
name: memory-hygiene
description: Use when reviewing, cleaning, compressing, or updating durable agent memory to reduce stale, noisy, or unsafe context.
required: false
roles:
  - orchestrator
  - reviewer
when_to_use:
  - maintaining agent memory
  - reducing context drift
  - cleaning stale preferences
source_inspired_by:
  - datacamp.com/blog/top-agent-skills
checks:
  - stale entries are removed or marked
  - secrets are not retained
  - memory stays concise and actionable
---

# Memory Hygiene

Memory should help future work, not bias it with stale context.

Review:

- Is this fact durable?
- Is it still true?
- Does it affect future decisions?
- Could it expose secrets or private data?
- Can it be shortened without losing value?

Prefer small verified memory entries over long conversation summaries.
