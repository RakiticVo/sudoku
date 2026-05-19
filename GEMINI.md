# Agent Skill Vault Bootstrap

This project uses pinned agent skills. These instructions are mandatory for every coding agent session.

## Mandatory Startup

1. Read `.agents/skills.lock.json`.
2. Check whether the `agentmemory` MCP server is available. If available, search memory for relevant project decisions before planning.
3. Read the relevant `SKILL.md` files before planning or editing.
4. State which skills are being applied in the implementation plan.
5. Follow mandatory Clean Architecture, dependency injection, networking, model, and testing checks.
6. Before finishing meaningful work, save durable decisions or verified project knowledge to AgentMemory when available.
7. Run `agent-skills doctor --project .` before finishing when the tool is available.

If a user asks for implementation without mentioning skills, still perform this startup flow. Do not wait for the user to remind you.

If AgentMemory is required by `.agents/skills.lock.json` but not running, report that memory is unavailable and use `.agents/integrations/agentmemory.mcp.example.json` to configure the host. Start the local memory server with `npx @agentmemory/agentmemory`.

For Claude Code, also inspect `.claude/skills` when present.
For Gemini, treat this file and `.agents/skills` as the project skill source.

Current bootstrap file: `GEMINI.md`.
