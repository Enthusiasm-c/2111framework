---
name: auto-memory
description: Persistent memory system for Claude Code sessions
---

# Auto-Memory System

Claude Code is stateless between sessions and loses context after `/compact`. The auto-memory system solves this by creating a persistence loop:

```
Stop hook saves → SessionStart hook reads → /compact re-injects
```

## How It Works

### The Memory Cycle

1. **Session ends** (Stop hook) — `auto-memory.sh` writes timestamp + project info to `~/.claude/memory/sessions.md`
2. **Session starts** (SessionStart hook) — displays `PROJECT_MEMORY.md` + git context
3. **After /compact** (SessionStart hook) — re-injects `PROJECT_MEMORY.md` into context so Claude remembers key decisions

### What Gets Saved Automatically

The Stop hook (`config/hooks/auto-memory.sh`) saves:
- Timestamp of session end
- Project name (from current directory)
- Git branch name

### What You Maintain Manually

`PROJECT_MEMORY.md` in your project root — this is the **high-value** file:
- Architecture decisions
- Resolved bugs (so Claude doesn't re-introduce them)
- API limitations discovered during development
- Anti-patterns specific to the project

## File Structure

```
~/.claude/memory/
  sessions.md          # Auto-generated session log

<project-root>/
  PROJECT_MEMORY.md    # Manual — key decisions and context
```

## SESSION_MEMORY vs PROJECT_MEMORY

| File | Location | Updated by | Purpose |
|------|----------|------------|---------|
| `sessions.md` | `~/.claude/memory/` | Hook (auto) | Session log across all projects |
| `PROJECT_MEMORY.md` | Project root | You (manual) | Project-specific decisions and context |

## Integration with /compact

When you run `/compact`, Claude loses all conversation context. The SessionStart hook detects the compact event and re-injects:

1. Full contents of `PROJECT_MEMORY.md`
2. Current git branch
3. Last 5 commits

This means **anything in PROJECT_MEMORY.md survives compact**.

## Best Practices

### What to Record in PROJECT_MEMORY.md

- "We chose X over Y because Z" (architecture decisions)
- "Bug: X happened because Y — fix: Z" (resolved bugs)
- "API X doesn't support Y, use Z instead" (limitations)
- "Never do X in this project because Y" (anti-patterns)
- Key file paths and their purposes

### What NOT to Record

- Temporary debugging notes
- TODO items (use `.claude/TODO.md` instead)
- Full code snippets (reference file paths instead)
- Information that changes frequently

### When to Update

After Claude suggests updating PROJECT_MEMORY.md (or when you discover something important):

```
"Add to PROJECT_MEMORY.md: We use Drizzle ORM with Neon serverless driver.
Connection pooling is handled by Neon, not by our code."
```

## Setup

Auto-memory is installed automatically with `bash install.sh`. To verify:

```bash
# Check hook script exists
ls -la ~/.claude/hooks/auto-memory.sh

# Check memory directory exists
ls -la ~/.claude/memory/

# Check settings.json has Stop hook
cat ~/.claude/settings.json | jq '.hooks.Stop'
```

## Customization

### Disable auto-memory

Remove the first Stop hook entry from `~/.claude/settings.json`:
```json
"Stop": [
  // Remove the auto-memory entry
]
```

### Change memory location

Edit `config/hooks/auto-memory.sh` and change `MEMORY_DIR`.

### Add more context to compact re-injection

Edit the SessionStart compact hook in `settings.json` to include additional files or commands.
