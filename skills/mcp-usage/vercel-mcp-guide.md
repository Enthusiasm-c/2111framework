---
name: vercel-mcp-guide
description: Use the official Vercel plugin (slash commands + specialized agents) for deploys, env vars, runtime logs. No MCP server — this plugin ships agents and commands.
---

# Vercel Plugin Guide

Installed via `/plugin install vercel@claude-plugins-official`. **Not an MCP server** — it provides slash commands and specialized agents instead.

## Slash Commands

| Command | What it does |
|---------|--------------|
| `/deploy` | Trigger production or preview deploy, watch build log, surface errors |
| `/env` | Read/write environment variables per environment (production/preview/development) |
| `/status` | Show deployment status, current domain aliases, build health |
| `/bootstrap` | Scaffold a Vercel-ready Next.js project (not useful for existing projects) |
| `/marketplace` | Browse Vercel integrations |

## Plugin Agents

| Agent | When to use |
|-------|-------------|
| `ai-architect` | Designing AI SDK features (streaming, tool calls) — overlaps with framework's `architect`, prefer framework one |
| `deployment-expert` | Debugging failed builds, runtime errors, edge vs node runtime issues |
| `performance-optimizer` | Vercel-specific perf (ISR, streaming, edge caching) — complements framework's `skills/tech-stack/react-optimization.md` |

## When to Use What

| Situation | Use |
|-----------|-----|
| Deploy failed, don't know why | `/deploy` or `deployment-expert` agent |
| Need to add a new env var across environments | `/env` command |
| Runtime 500 error in prod | `deployment-expert` agent (pulls Vercel runtime logs) |
| Architecture decision on AI SDK streaming | Framework `architect` agent (knows your whole stack), not Vercel's `ai-architect` |
| Checking if last deploy is live | `/status` |

## Typical Prompts

```
# Debug failed deploy
/deploy
# or
"Use deployment-expert: last production build failed, find the error"

# Env var management
/env
# or
"Add SENTRY_AUTH_TOKEN to production and preview, keep development empty"

# Post-deploy sanity
/status
```

## Integration with Framework

- **qa.md Pre-Release Checklist**: add "Run `/status`, confirm last deploy is Ready, not Building/Errored"
- **developer.md**: after shipping, run `/deploy` and wait for Ready before marking task done
- **security.md**: use `/env` to audit which env vars are exposed in production vs dev

## Gotchas

- Plugin agents live in their own scope — they don't see framework agents or `CLAUDE.md` project context. Keep framework agents for cross-cutting decisions.
- `/deploy` runs against the Git repo Vercel is linked to — make sure you're on the right branch before invoking
- Env var writes via `/env` are immediate — no staging. Double-check before writing production secrets.
