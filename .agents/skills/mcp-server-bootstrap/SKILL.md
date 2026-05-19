---
name: mcp-server-bootstrap
description: Use when bootstrapping an MCP server through GitHub MCP, install instructions, agent host config, or manual fallback.
required: false
roles:
  - orchestrator
  - implementer
when_to_use:
  - MCP setup
  - GitHub MCP bootstrap
  - Antigravity configuration
source_inspired_by:
  - mcpservers.org/agent-skills
checks:
  - GitHub MCP is treated as entrypoint only
  - MCP config path is clear
  - manual fallback is provided
---

# MCP Server Bootstrap

GitHub MCP can read instructions; it does not automatically create new MCP servers.

Bootstrap flow:

- Use GitHub MCP to read the target repo and install instructions.
- Register the MCP server config if the host permits it.
- If not, show the config to the user for manual paste.
- Reload or restart MCP servers.
- Confirm the expected tools are visible.

Keep the difference between source repo, MCP server, and installed project files explicit.
