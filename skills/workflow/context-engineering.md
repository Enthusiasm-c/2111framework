---
name: context-engineering
description: Techniques for managing Claude Code's context window effectively
---

# Context Engineering

Strategies for keeping Claude Code's context window focused and productive.

## Why It Matters

Claude Code has a finite context window. As conversations grow, earlier context gets compressed or lost. Managing context deliberately leads to better code quality and fewer mistakes.

## Strategies

### 1. Compact Early, Compact Often

Use `/compact` when context reaches ~70% capacity. Signs you need to compact:
- Claude starts forgetting earlier decisions
- Responses reference wrong file names
- You notice repeated questions about things already discussed

```
/compact
```

### 2. Use PROJECT_MEMORY.md

Store critical decisions outside the context window:

```markdown
# PROJECT_MEMORY.md

## Architecture Decisions
- Auth: Clerk + JWT, not custom auth
- DB: NeonDB with Drizzle ORM, pooled connections
- State: Server Components default, Zustand for client state

## Known Issues
- NeonDB cold starts: Use keep-alive connection
- Telegram WebApp.close() crashes on iOS 16 — use setTimeout wrapper

## API Limitations
- Syrve API: 100 requests/minute rate limit
- OpenAI Vision: Max 20MB images
```

### 3. Scope Your Requests

Bad: "Fix everything in the auth module"
Good: "Fix the JWT expiry check in src/lib/auth/verify.ts"

Specific requests use less context and produce better results.

### 4. One Task Per Session

For complex work, prefer separate sessions per task:
- Session 1: Architect designs the plan
- Session 2: Dev implements Phase 1
- Session 3: Dev implements Phase 2
- Session 4: Review + QA

Each session starts fresh with full context budget.

### 5. Leverage Agents for Isolation

Agents with `context: fork` run in isolated context:
- Security agent audits without polluting your main session
- Review agent analyzes code in separate context
- QA agent tests independently

### 6. Reference Skills Instead of Explaining

Instead of explaining patterns in chat, reference skills:

Bad: "Use the pattern where you validate with Zod, then..."
Good: "Follow the patterns in /skills/tech-stack/nextjs-app-router.md"

Skills are loaded on-demand and don't consume context until invoked.

### 7. Use Rules for Recurring Instructions

If you repeat the same instructions across sessions, create a rule:

```markdown
---
globs: "**/*.tsx"
---
Use shadcn/ui components. Never install Material UI or Chakra.
```

Rules are loaded automatically for matching files — no need to repeat in chat.

### 8. Clean Git State

Start sessions with clean git state. Uncommitted changes add noise:

```bash
git stash        # Before starting new task
git stash pop    # After session, if needed
```

## Context Budget Guidelines

| Task Type | Recommended Approach |
|-----------|---------------------|
| Quick fix (1-2 files) | Single session, direct request |
| Feature (3-5 files) | Single session with /compact midway |
| Large feature (5+ files) | Multiple sessions, architect first |
| Refactoring | Architect session -> Dev sessions per phase |
| Full audit | Agent Teams (parallel, forked contexts) |

## Anti-Patterns

- Dumping entire files into chat ("here's my 500-line component...")
- Asking Claude to "remember" things (use PROJECT_MEMORY.md instead)
- Running multiple unrelated tasks in one session
- Not compacting before context gets critical
