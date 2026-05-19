---
name: mcp-security-review
description: Use when reviewing MCP servers, local commands, permissions, secrets, filesystem access, or destructive tool risks.
required: false
roles:
  - reviewer
  - security
when_to_use:
  - MCP security review
  - local command tools
  - tool permission design
source_inspired_by:
  - Model Context Protocol security practice
checks:
  - secrets are not exposed
  - destructive actions require explicit approval
  - filesystem and network scope are bounded
---

# MCP Security Review

MCP tools extend agent capability, so review them as execution surfaces.

Check:

- What commands can run.
- What files can be read or written.
- What network and credentials are accessible.
- Whether destructive actions require confirmation.
- Whether logs expose secrets.
- Whether tool outputs can cause prompt injection.

Prefer narrow permissions and explicit user approval for risky operations.
