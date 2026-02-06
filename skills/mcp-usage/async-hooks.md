---
name: async-hooks
description: Background hooks and Setup hook patterns. Reference for async true, Setup hook via claude --init, and hook lifecycle events.
---

# Async Hooks & Setup Hook

Reference for background hooks and the Setup hook lifecycle.

## Hook Lifecycle Events

Claude Code supports hooks that run at specific lifecycle points:

| Event | When | Use Case |
|-------|------|----------|
| `SessionStart` | Session begins | Environment setup, welcome message |
| `Stop` | Agent stops | Cleanup, summary |
| `PreToolUse` | Before a tool runs | Validation, logging |
| `PostToolUse` | After a tool runs | Linting, verification |
| `Setup` | On `claude --init` | One-time project initialization |

---

## Async Hooks

By default, hooks run synchronously -- Claude waits for them to complete. Use `async: true` to run hooks in the background.

### Sync (Default)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix \"$FILE\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

Claude waits up to 10 seconds for ESLint to finish before continuing.

### Async (Background)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix \"$FILE\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ]
  }
}
```

Claude continues immediately; ESLint runs in background. Results appear when done.

### When to Use Async

| Hook Type | Sync or Async |
|-----------|---------------|
| Quick validation (<2s) | Sync |
| Linting, formatting | Sync (want results before next edit) |
| Slow tests, builds | Async |
| Notifications, logging | Async |
| File indexing | Async |

---

## Setup Hook

The Setup hook runs once when you initialize a project with `claude --init`. Use it for one-time setup tasks.

### Configuration

In `.claude/settings.json` (project-level):

```json
{
  "hooks": {
    "Setup": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "npm install && npx prisma generate",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Use Cases

- Install dependencies
- Generate Prisma client
- Run database migrations
- Set up environment files
- Initialize git hooks

---

## Hook Configuration Reference

### Location

Hooks can be configured at three levels:

| Level | File | Scope |
|-------|------|-------|
| Global | `~/.claude/settings.json` | All projects |
| Project | `.claude/settings.json` | This project |
| Skill | Frontmatter `hooks:` block | This skill only |

### Format

```json
{
  "hooks": {
    "<Event>": [
      {
        "matcher": "<regex>",
        "hooks": [
          {
            "type": "command",
            "command": "<shell command>",
            "timeout": 10,
            "async": false,
            "once": false
          }
        ]
      }
    ]
  }
}
```

### Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `type` | string | required | Always `"command"` |
| `command` | string | required | Shell command to run |
| `timeout` | number | 10 | Max seconds before kill |
| `async` | boolean | false | Run in background |
| `once` | boolean | false | Run only once per session |
| `matcher` | string | - | Regex to match tool names (PreToolUse/PostToolUse only) |

---

## Examples

### Console.log Detector

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=$(cat - | jq -r \".tool_input.file_path\"); if [[ \"$FILE\" == *.ts || \"$FILE\" == *.tsx ]]; then grep -n \"console.log\" \"$FILE\" 2>/dev/null | head -5 && echo \"WARNING: console.log detected\"; fi'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### TypeScript Check After Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=$(cat - | jq -r \".tool_input.file_path\"); npx tsc --noEmit \"$FILE\" 2>&1 | head -5'",
            "timeout": 15,
            "async": true
          }
        ]
      }
    ]
  }
}
```

### Welcome Message on Session Start

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Project: $(basename $(pwd)) | Branch: $(git branch --show-current)'",
            "once": true
          }
        ]
      }
    ]
  }
}
```

---

## Related Skills

- `background-tasks.md` - Running processes in background
- `agent-teams.md` - Parallel agent coordination
