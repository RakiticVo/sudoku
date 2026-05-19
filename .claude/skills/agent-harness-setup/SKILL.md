---
name: agent-harness-setup
description: Use when configuring Codex, Claude, Gemini, Antigravity, or other agent harnesses for project work.
required: false
roles:
  - orchestrator
  - implementer
when_to_use:
  - configuring agent tools
  - installing skills
  - setting bootstrap files
source_inspired_by:
  - hesreallyhim/awesome-claude-code
  - affaan-m/everything-claude-code
  - mattpocock/skills/setup-matt-pocock-skills
checks:
  - bootstrap files are present
  - tool availability is confirmed
  - fallback path is documented
  - repo-specific config locations are recorded
---

# Agent Harness Setup

Make agent behavior repeatable.

Check:

- Which harness is being used.
- Which bootstrap files it reads.
- Which MCP/tools are available.
- Whether it can edit config or needs manual setup.
- What fallback exists if a tool is missing.
- Where project docs, domain language, issue templates, labels, plans, and ADRs live.
- Which commands verify the harness setup.

Do not assume every model reads the same project files.
