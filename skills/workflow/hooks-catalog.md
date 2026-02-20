---
name: hooks-catalog
description: Complete reference for all 12 battle-tested hooks in 2111framework
---

# Hooks Catalog

Complete reference for all hooks configured in `config/settings.json`.

## All Hooks Overview

| # | Event | Matcher | Async | Description |
|---|-------|---------|-------|-------------|
| 1 | SessionStart | `compact` | no | Re-injects PROJECT_MEMORY.md + git context after /compact |
| 2 | SessionStart | `startup` | no | Shows project, branch, git status (once per session) |
| 3 | PreToolUse | `Edit\|Write` | no | Blocks editing protected files (.env, lock files) |
| 4 | PreToolUse | `Bash` | no | Blocks destructive commands (rm -rf /, reset --hard, etc.) |
| 5 | PostToolUse | `Edit\|Write` | no | Warns about console.log in .ts/.tsx files |
| 6 | PostToolUse | `Edit\|Write` | no | Runs ESLint check on edited .ts/.tsx files |
| 7 | PostToolUse | `Edit\|Write` | yes | Auto-formats with Prettier (.ts/.tsx/.css/.json) |
| 8 | Notification | (any) | no | macOS desktop notification when Claude waits for input |
| 9 | Stop | (any) | no | Saves session info to ~/.claude/memory/sessions.md |
| 10 | Stop | (any) | no | Reminds about uncommitted changes |
| 11 | UserPromptSubmit | (any) | no | Injects .claude/TODO.md into context |
| 12 | SubagentStop | (any) | no | Desktop notification when subagent completes |

## Exit Code Semantics

| Code | Meaning | Effect |
|------|---------|--------|
| 0 | Success | Hook output passed to Claude as context |
| 2 | Block | **Prevents the tool from executing** (PreToolUse only) |
| Other | Error | Silently ignored — does not block Claude |

**Important:** Exit code 2 only blocks in `PreToolUse` hooks. In other events, it's treated as an error.

## Hook Lifecycle Events

Claude Code supports 14 hook event types:

| Event | When | stdin | Can Block |
|-------|------|-------|-----------|
| `SessionStart` | Session begins or after /compact | Session info JSON | No |
| `Stop` | Session ends | Session info JSON | No |
| `PreToolUse` | Before any tool executes | Tool input JSON | **Yes (exit 2)** |
| `PostToolUse` | After any tool executes | Tool input + output JSON | No |
| `Notification` | Claude sends notification (waiting for input) | Notification JSON | No |
| `UserPromptSubmit` | User submits a prompt | Prompt JSON | No |
| `SubagentStop` | Subagent completes execution | Subagent info JSON | No |

Additional events (not used in this framework but available):
- `PreToolUse` with specific tool matchers (e.g., `Read`, `Glob`, `Grep`)
- Custom event hooks via Claude Code API

## Matcher Syntax

Matchers filter which invocations trigger a hook.

### By Event Type

| Event | Matcher matches against | Example |
|-------|------------------------|---------|
| SessionStart | Session event type (`startup`, `compact`) | `"compact"` |
| PreToolUse | Tool name | `"Edit\|Write"`, `"Bash"` |
| PostToolUse | Tool name | `"Edit\|Write"` |
| Notification | (empty = all) | `""` |
| Stop | (empty = all) | `""` |
| UserPromptSubmit | (empty = all) | `""` |
| SubagentStop | (empty = all) | `""` |

### Matcher Patterns

- **Exact match:** `"Bash"` — matches only the Bash tool
- **OR match:** `"Edit|Write"` — matches Edit or Write
- **Empty string:** `""` — matches everything (catch-all)

## Hook Configuration

Each hook entry in `settings.json`:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash -c '...'",
      "timeout": 5,
      "async": false,
      "once": false
    }
  ]
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `type` | string | required | Always `"command"` |
| `command` | string | required | Shell command to execute |
| `timeout` | number | 10 | Max execution time in seconds |
| `async` | boolean | false | Run in background (non-blocking) |
| `once` | boolean | false | Run only once per session |

## Hook Details

### #1 — Context Re-injection (SessionStart/compact)

**The most valuable hook.** After `/compact`, Claude loses all conversation context. This hook re-injects:
- Full contents of `PROJECT_MEMORY.md`
- Current git branch
- Last 5 commits

### #2 — Session Info (SessionStart/startup)

Shows project name, branch, and git status once when starting a new session. Runs with `once: true` so it doesn't repeat.

### #3 — Protected Files Guard (PreToolUse/Edit|Write)

Blocks editing of:
- `.env`, `.env.local`, `.env.production`, `.env.staging` — secrets
- `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` — lock files

Uses `exit 2` to prevent the tool from executing.

### #4 — Destructive Command Guard (PreToolUse/Bash)

Blocks execution of:
- `rm -rf /` — filesystem destruction
- `git reset --hard` — discard all changes
- `git push --force` / `git push -f` — force push
- `DROP TABLE` — database destruction
- `git clean -fd` — delete untracked files

### #5 — Console.log Detector (PostToolUse/Edit|Write)

Existing hook. Warns when `console.log` found in edited `.ts/.tsx` files.

### #6 — ESLint Checker (PostToolUse/Edit|Write)

Existing hook. Shows ESLint errors after editing `.ts/.tsx` files (if ESLint configured in project).

### #7 — Auto-format with Prettier (PostToolUse/Edit|Write)

Runs `prettier --write` on edited `.ts/.tsx/.css/.json` files. Uses `async: true` so Claude continues working while formatting happens in background. Only runs if `prettier` is installed.

### #8 — Desktop Notification (Notification)

Sends macOS notification via `osascript` when Claude is waiting for input. Useful when you've switched to another window.

### #9 — Auto-memory Save (Stop)

Runs `auto-memory.sh` to save session info. See `skills/workflow/auto-memory.md` for details.

### #10 — Uncommitted Changes Reminder (Stop)

Shows `git status --short` when session ends if there are uncommitted changes.

### #11 — TODO Auto-inject (UserPromptSubmit)

Reads `.claude/TODO.md` and injects it into context with every prompt. Helps Claude remember current tasks.

### #12 — Subagent Completion Notification (SubagentStop)

Sends macOS desktop notification when a subagent finishes. Useful with Agent Teams where agents work in background.

## Adding a Custom Hook

Add to the appropriate event array in `~/.claude/settings.json`:

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "bash -c 'CMD=$(cat - | jq -r \".tool_input.command\"); echo \"Running: $CMD\"'",
      "timeout": 5
    }
  ]
}
```

## Disabling a Hook

Remove the specific hook entry from the event array in `~/.claude/settings.json`. You can also comment it out by renaming the event key (e.g., `"_PostToolUse"` won't match).

## Example: Custom Hooks

### TypeScript Type Checker (PostToolUse)

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash -c 'FILE=$(cat - | jq -r \".tool_input.file_path\"); if [[ \"$FILE\" =~ \\.(ts|tsx)$ ]] && [ -f tsconfig.json ]; then npx tsc --noEmit 2>&1 | head -10; fi'",
      "timeout": 30
    }
  ]
}
```

### Test Runner (PostToolUse)

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash -c 'FILE=$(cat - | jq -r \".tool_input.file_path\"); TEST=\"${FILE%.ts}.test.ts\"; if [ -f \"$TEST\" ]; then npx vitest run \"$TEST\" --reporter=verbose 2>&1 | tail -20; fi'",
      "timeout": 60,
      "async": true
    }
  ]
}
```

### Security Scanner (PreToolUse)

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "bash -c 'CMD=$(cat - | jq -r \".tool_input.command\"); if echo \"$CMD\" | grep -qiE \"curl.*-k|wget.*no-check\"; then echo \"BLOCKED: Insecure download detected\" >&2; exit 2; fi'",
      "timeout": 3
    }
  ]
}
```
