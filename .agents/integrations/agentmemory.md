# AgentMemory Integration

AgentMemory is mandatory for projects installed with Agent Skill Vault. It gives agents a shared project memory layer across sessions.

## Default setup

Start the local memory server:

```bash
npx @agentmemory/agentmemory
```

Register the MCP bridge in your agent host:

```bash
npx -y @agentmemory/mcp
```

Use `agentmemory` as the MCP server name.

## Antigravity

If Antigravity allows MCP config edits and reloads, add the JSON from `agentmemory.mcp.example.json` and reload MCP servers.

If Antigravity does not allow the agent to reload MCP servers, paste the JSON into Antigravity's MCP config manually, then restart or reload the host.

## Advanced self-host mode

Clone and self-host `rohitg00/agentmemory` only when you need to pin a commit, audit source, or change server behavior. Keep the selected mode recorded in project planning notes when `.agent-plans` exists.

## Required checks

- AgentMemory server is started with `npx @agentmemory/agentmemory`.
- MCP config contains a server named `agentmemory`.
- The MCP bridge uses `npx -y @agentmemory/mcp`.
- Health is verified when possible at `http://localhost:3111/agentmemory/health`.
- Major setup decisions are recorded in `.agent-plans/decisions/` when the planning workspace exists.
