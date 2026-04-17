---
name: neon-mcp-guide
description: Use Neon MCP to run SQL, create preview database branches for risky migrations, inspect schemas. Branch before touching production data.
---

# Neon MCP Guide

Remote HTTP MCP at `https://mcp.neon.tech/mcp`. Installed via `claude-plugins-official/neon` plugin or directly in `mcp.json`.

## When to Use

| Situation | Action |
|-----------|--------|
| Risky migration (drop column, type change, NOT NULL) | **Create a branch first**, test migration on branch, merge only if safe |
| Debugging data issues | Run read-only SQL against prod branch |
| Schema inspection | "Show schema for invoices table in menuai" |
| Seed data for feature dev | Create branch, seed, point dev env to branch |
| Rollback investigation | Compare branch states before/after deploy |

## Core Workflow: Branch Before Migration

For any migration touching production data:

```
1. "Create a Neon branch called 'migration-test-YYYYMMDD' from main for menuai"
2. Run migration against branch (update drizzle config to branch connection string)
3. Verify data integrity with SELECT queries
4. If safe, run migration on main
5. Delete branch when done
```

Neon branches are copy-on-write — free and instant, no data copy.

## Typical Prompts

```
# Inspect schema
"What columns does the orders table have in the main branch of menuai?"

# Create test branch
"Create a Neon branch 'test-invoice-migration' from main for notaapp. Return connection string."

# Run safe query
"In menuai main branch, count orders with status='pending' grouped by restaurant_id"

# Migration dry run
"On branch 'test-invoice-migration', apply the migration in drizzle/0042_*.sql. Report any errors."

# Cleanup
"List all Neon branches for menuai older than 7 days and delete them"
```

## Integration with Framework Agents

- **architect.md**: when designing a schema change, propose "Phase 0: Create Neon branch, run migration there first"
- **developer.md**: never run destructive migrations (`DROP COLUMN`, `ALTER TYPE`) on main without branch verification first
- **qa.md**: Pre-Release Checklist → "Last migration tested on branch, no data loss observed"
- **security.md**: use to audit grants/permissions, check RLS policies, verify no sensitive data in logs table

## Drizzle + Neon Branching Pattern

```bash
# 1. Create branch via MCP
# → returns connection string, e.g. postgresql://...@branch-xyz.neon.tech/...

# 2. Run Drizzle migration against branch
DATABASE_URL="<branch-connection-string>" npx drizzle-kit push

# 3. Verify
DATABASE_URL="<branch-connection-string>" npm run dev
# test locally

# 4. If good, apply to main
DATABASE_URL="<prod-connection-string>" npx drizzle-kit push
```

## Gotchas

- Branch connection strings include credentials — never commit, never paste into public channels
- Branches inherit parent's data at time of creation — stale after long-lived branches
- NeonDB serverless scales to zero — first query after idle has cold start (~1s)
- Free tier has branch limit (10 on free plan) — clean up old branches regularly
- MCP writes to prod branch are real writes — always double-check `branch: main` vs `branch: test-*` before running INSERT/UPDATE/DELETE
