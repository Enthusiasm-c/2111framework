---
name: sentry-mcp-guide
description: Use Sentry MCP to pull production errors, stack traces, and triage issues without leaving Claude Code. Critical for non-coder founders who rely on AI to interpret prod incidents.
---

# Sentry MCP Guide

Remote HTTP MCP at `https://mcp.sentry.dev/mcp`. Installed via `claude-plugins-official/sentry` plugin or directly in `mcp.json`.

## When to Use

| Situation | Action |
|-----------|--------|
| Prod error report from user | "Pull the latest Sentry issue for menuai, show stack trace + affected users" |
| After deploy to production | "List Sentry issues created in the last 30 minutes" |
| Security agent audit | Cross-reference audit findings with real Sentry exceptions (are they actually hit in prod?) |
| QA pre-release checklist | Verify error rate is stable — not spiking after last deploy |
| Bug fix verification | Resolve the Sentry issue directly, add to release notes |

## Typical Prompts

```
# Triage
"What's the top unresolved Sentry issue for notaapp by user count?"

# Fix workflow
"Pull Sentry issue ABC-123, read the stack trace, identify the file and line, propose a fix"

# Post-deploy check
"Any new Sentry issues for menuai in the last hour? Show severity and affected endpoints"

# Alert setup
"Create a Sentry alert: notify when error rate in /api/invoices exceeds 5% over 10 minutes"
```

## Integration with Framework Agents

- **security.md**: when auditing an endpoint, ask Sentry MCP for past exceptions from that file — real exploit attempts often show up as 500s
- **qa.md**: include in Pre-Release Checklist → "Sentry error rate stable in last 24h"
- **developer.md**: after `dev` completes a bug fix, mark the Sentry issue resolved with a commit reference

## Gotchas

- First use triggers OAuth — Denis must approve once per machine
- MCP respects Sentry project scopes — pick the right project name in prompts (menuai vs notaapp vs sensei-admin)
- Stack traces are source-mapped only if sourcemaps uploaded on deploy — verify Vercel build uploads sourcemaps
- Do not paste Sentry user PII into commit messages or public docs
