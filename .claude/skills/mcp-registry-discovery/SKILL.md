---
name: mcp-registry-discovery
description: Use when finding existing MCP servers, agent skills, or tool ecosystems before building new automation.
required: false
roles:
  - researcher
  - architect
when_to_use:
  - choosing MCP servers
  - evaluating tool catalogs
  - avoiding duplicate automation
source_inspired_by:
  - mcpservers.org/agent-skills
checks:
  - existing tools are checked before building
  - security and maintenance are considered
  - chosen tool maps to the actual workflow
---

# MCP Registry Discovery

Search before building.

Evaluate:

- What problem the MCP server solves.
- Whether it is maintained and documented.
- Authentication and permission needs.
- Local vs remote execution model.
- Whether tool outputs fit the agent workflow.

Prefer a small reliable tool over a broad unclear integration.
