---
name: agentmemory-integration
description: Use when setting up or verifying the mandatory AgentMemory memory layer for an agent-enabled project.
required: true
roles:
  - orchestrator
  - implementer
  - reviewer
when_to_use:
  - bootstrapping an installed project
  - configuring persistent agent memory
  - checking MCP memory availability
source_inspired_by:
  - rohitg00/agentmemory
checks:
  - AgentMemory server setup is documented
  - agentmemory MCP config is present or explicitly handed to the user
  - health endpoint is checked when available
  - major memory setup decisions are recorded
---

# AgentMemory Integration

AgentMemory is mandatory for projects installed with Agent Skill Vault. Treat it as the shared memory layer that lets agents recover durable project context across sessions.

## Default Mode

Use the published packages first:

- Start the memory server with `npx @agentmemory/agentmemory`.
- Register the MCP bridge with `npx -y @agentmemory/mcp`.
- Name the MCP server `agentmemory`.
- Verify health at `http://localhost:3111/agentmemory/health` when the environment allows HTTP checks.

## Self-Hosted Mode

Clone and self-host `rohitg00/agentmemory` only when the project needs pinned source, local patches, or deeper audit control. Record the chosen commit/tag and reason in the project plan or decision log.

## Agent Workflow

At the start of a task:

- Check whether `agentmemory` MCP tools are available.
- Search memory for relevant project decisions, conventions, and prior failures before planning.
- If the server is not available, report that AgentMemory is not active and run the project doctor when possible.

At the end of a meaningful task:

- Save durable decisions, verified commands, architecture choices, and user preferences.
- Do not store secrets, raw tokens, temporary guesses, or noisy transcript fragments.

## Required Project Files

Installed projects must include:

- `.agents/integrations/agentmemory.md`
- `.agents/integrations/agentmemory.mcp.example.json`

If these files are missing, rerun the Agent Skill Vault installer.
