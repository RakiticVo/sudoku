---
name: secrets-and-env-safety
description: Use when adding, reading, rotating, documenting, or deploying secrets, tokens, API keys, certificates, or environment variables.
required: false
roles:
  - security
  - implementer
  - devops
when_to_use:
  - env config changes
  - secret handling
  - deployment setup
source_inspired_by:
  - datacamp.com/blog/top-agent-skills
checks:
  - secrets are never committed
  - examples use placeholders
  - rotation and storage are documented
---

# Secrets And Env Safety

Handle secrets as production assets.

Rules:

- Never commit real credentials, tokens, private keys, or certificates.
- Use placeholders in examples and docs.
- Store secrets in platform secret managers or local ignored files.
- Validate `.gitignore` before adding env examples.
- Avoid printing secrets in logs, tests, errors, or CI output.
- Document required variables without exposing values.

If a secret may have leaked, recommend rotation immediately.
