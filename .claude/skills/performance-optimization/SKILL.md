---
name: performance-optimization
description: Use when improving latency, throughput, memory use, bundle size, rendering speed, or resource cost.
required: false
roles:
  - implementer
  - reviewer
  - architect
when_to_use:
  - performance requirements
  - suspected regressions
  - optimization work
source_inspired_by:
  - addyosmani/agent-skills/performance-optimization
checks:
  - baseline is measured first
  - bottleneck is identified
  - improvement is verified after change
---

# Performance Optimization

Measure before optimizing.

Process:

- Define the performance goal and user-visible impact.
- Capture a baseline with the most relevant metric.
- Identify the bottleneck before changing code.
- Make the smallest change that targets the bottleneck.
- Compare before and after results.
- Watch for readability, correctness, caching, and stale-data tradeoffs.

Do not optimize based only on intuition when measurement is available.

