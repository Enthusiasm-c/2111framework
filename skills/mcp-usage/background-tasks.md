---
name: background-tasks
description: Running dev servers and processes in background with Ctrl+B. Also covers --from-pr for resuming PR-linked sessions.
---

# Background Tasks

Run dev servers and long processes in the background while continuing to work.

## Background Commands (Ctrl+B)

While typing a bash command in Claude Code, press `Ctrl+B` to run it in the background instead of foreground.

### How It Works

1. Type a command (e.g., `npm run dev`)
2. Press `Ctrl+B` instead of Enter
3. Command starts in background
4. You continue working -- no blocked terminal

### Common Use Cases

```bash
# Start dev server in background
npm run dev          # Ctrl+B

# Run tests in background
npm test             # Ctrl+B

# Start database
docker compose up    # Ctrl+B

# Watch mode
npm run build:watch  # Ctrl+B
```

### Monitoring Background Tasks

```bash
# List running background tasks
# Use /tasks command in Claude Code

# Check output of a background task
# Claude can read task output and report status
```

---

## --from-pr (Resume PR Sessions)

Start a Claude Code session linked to a specific pull request:

```bash
claude --from-pr 123
```

### What It Does

1. Checks out the PR branch
2. Loads PR description as context
3. Shows PR diff summary
4. Ready to work on the PR

### Use Cases

```bash
# Review a PR
claude --from-pr 123
# "Review this PR for security issues"

# Continue work on a PR
claude --from-pr 456
# "Fix the failing tests"

# Address PR feedback
claude --from-pr 789
# "Address the review comments"
```

---

## Combining Background Tasks with Work

### Pattern: Dev Server + Feature Work

```bash
# 1. Start dev server in background
npm run dev          # Ctrl+B

# 2. Work on feature
# Claude edits files, server auto-reloads

# 3. Test in browser
# Use chrome-extension or playwright to verify
```

### Pattern: Tests + Fix Loop

```bash
# 1. Run tests in watch mode (background)
npm test -- --watch  # Ctrl+B

# 2. Fix code
# Claude edits, tests re-run automatically

# 3. Check test output
# "Show me the test output"
```

### Pattern: Build + Deploy Check

```bash
# 1. Start build in background
npm run build        # Ctrl+B

# 2. Continue with other tasks
# Work on documentation, config, etc.

# 3. Check build result when ready
# "Did the build succeed?"
```

---

## Tips

- Background tasks persist for the session duration
- Use `Ctrl+C` in the background task output to stop it
- Dev servers in background + live reload = efficient workflow
- Combine with Ralph Wiggum for fully autonomous background work

---

## Related Skills

- `ralph-wiggum.md` - Autonomous loops (runs in foreground)
- `async-hooks.md` - Background hooks
- `agent-teams.md` - Parallel agents
