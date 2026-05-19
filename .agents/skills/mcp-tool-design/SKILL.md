---
name: mcp-tool-design
description: Use when designing MCP tools, schemas, tool names, idempotency, errors, or permission boundaries.
required: false
roles:
  - architect
  - implementer
when_to_use:
  - MCP server design
  - tool schema design
  - agent tool integration
source_inspired_by:
  - Model Context Protocol practice
checks:
  - tool names are action-oriented
  - inputs are structured and validated
  - tools are idempotent where practical
---

# MCP Tool Design

Design tools for predictable agent use.

Guidelines:

- Use clear verb-noun names.
- Prefer structured inputs over free-form strings.
- Return machine-readable results plus concise text when useful.
- Make repeated calls safe where possible.
- Use explicit errors with recovery guidance.
- Avoid tools that silently perform broad or destructive actions.
