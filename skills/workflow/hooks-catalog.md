---
name: hooks-catalog
description: Complete reference for all hooks in 2111framework — command, prompt, agent, and HTTP types
---

# Hooks Catalog

Complete reference for hooks in Claude Code and 2111framework (`config/settings.json`).

## Hook Types

Claude Code supports **4 hook types** (2111framework uses command hooks; others available for custom setups):

| Type | Handler | Use Case |
|------|---------|----------|
| `command` | Shell command (stdin JSON) | Formatting, linting, file guards, notifications |
| `prompt` | Claude model evaluates a prompt | Semantic validation ("is this commit message good?") |
| `agent` | Spawns a subagent with tools | Deep verification (run tests, check types, analyze) |
| `http` | POST JSON to URL, receive JSON back | Remote validation, Slack/Telegram notifications, logging |

### Command Hook (what we use)

```json
{
  "type": "command",
  "command": "bash -c '...'",
  "timeout": 5
}
```

Receives tool input as JSON on stdin. Exit code 0 = success, 2 = block (PreToolUse only).

### Prompt Hook

```json
{
  "type": "prompt",
  "prompt": "Review this command for safety: {{input}}",
  "model": "haiku"
}
```

Claude model evaluates the prompt. Cheaper alternative to agent hooks — good for classification tasks. Returns model response as hook output.

**Example: Semantic command safety check**
```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Is this bash command destructive or dangerous? Answer YES or NO with one line explanation: {{tool_input.command}}",
      "model": "haiku",
      "timeout": 10
    }
  ]
}
```

### Agent Hook

```json
{
  "type": "agent",
  "prompt": "Run the test suite and report failures",
  "tools": ["Bash", "Read"],
  "model": "sonnet"
}
```

Spawns a subagent with tool access. Most powerful but most expensive. Good for deep verification that needs to read files and run commands.

**Example: Auto-test after edit**
```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "agent",
      "prompt": "Find and run the test file for {{tool_input.file_path}}. Report pass/fail.",
      "tools": ["Bash", "Read", "Glob"],
      "model": "haiku",
      "timeout": 60,
      "async": true
    }
  ]
}
```

### HTTP Hook

```json
{
  "type": "http",
  "url": "https://your-server.com/hooks/validate",
  "method": "POST",
  "timeout": 10
}
```

Sends tool input JSON as POST body. Response JSON becomes hook output. Good for:
- Slack/Telegram notifications on session events
- Remote validation against external systems
- Centralized audit logging

**Example: Telegram notification on session end**
```json
{
  "matcher": "",
  "hooks": [
    {
      "type": "http",
      "url": "https://api.telegram.org/bot<TOKEN>/sendMessage",
      "method": "POST",
      "body": {
        "chat_id": "<CHAT_ID>",
        "text": "Claude Code session ended"
      },
      "timeout": 5,
      "async": true
    }
  ]
}
```

---

## Framework Hooks (15 configured)

| # | Event | Matcher | Type | Async | Description |
|---|-------|---------|------|-------|-------------|
| 1 | SessionStart | `compact` | command | no | Re-injects PROJECT_MEMORY.md + TODO.md + git context after /compact |
| 2 | SessionStart | `startup` | command | no | Shows project, branch, git status (once per session) |
| 3 | PreToolUse | `Edit\|Write` | command | no | Blocks editing protected files (.env, lock files) |
| 4 | PreToolUse | `Bash` | command | no | Blocks destructive commands (rm -rf /, reset --hard, etc.) |
| 5 | PostToolUse | `Edit\|Write` | command | no | Warns about console.log in .ts/.tsx files |
| 6 | PostToolUse | `Edit\|Write` | command | no | Runs ESLint check on edited .ts/.tsx files |
| 7 | PostToolUse | `Edit\|Write` | command | yes | Auto-formats with Prettier (.ts/.tsx/.css/.json) |
| 8 | PostToolUse | `Edit\|Write` | command | yes | **TypeScript checker** — runs `tsc --noEmit`, shows type errors |
| 9 | PostToolUse | `Edit\|Write` | command | no | **Test coverage checker** — warns if no test file exists for edited file |
| 10 | Notification | (any) | command | no | macOS desktop notification when Claude waits for input |
| 11 | Stop | (any) | command | no | Saves session info (legacy — native memory preferred) |
| 12 | Stop | (any) | command | no | Reminds about uncommitted changes |
| 13 | UserPromptSubmit | (any) | command | no | Injects .claude/TODO.md into context |
| 14 | UserPromptSubmit | (any) | command | no | **PROJECT_MEMORY.md size auditor** — warns when > 50KB |
| 15 | SubagentStop | (any) | command | no | Desktop notification when subagent completes |

---

## Exit Code Semantics

| Code | Meaning | Effect |
|------|---------|--------|
| 0 | Success | Hook output passed to Claude as context |
| 2 | Block | **Prevents the tool from executing** (PreToolUse only) |
| Other | Error | Silently ignored — does not block Claude |

**Important:** Exit code 2 only blocks in `PreToolUse` hooks. In other events, it's treated as an error.

---

## Hook Lifecycle Events

| Event | When | stdin | Can Block |
|-------|------|-------|-----------|
| `SessionStart` | Session begins or after /compact | Session info JSON | No |
| `Stop` | Session ends | Session info JSON | No |
| `PreToolUse` | Before any tool executes | Tool input JSON | **Yes (exit 2)** |
| `PostToolUse` | After any tool executes | Tool input + output JSON | No |
| `Notification` | Claude sends notification | Notification JSON | No |
| `UserPromptSubmit` | User submits a prompt | Prompt JSON | No |
| `SubagentStop` | Subagent completes execution | Subagent info JSON | No |

---

## Matcher Syntax

| Event | Matcher matches against | Example |
|-------|------------------------|---------|
| SessionStart | Session event type | `"compact"`, `"startup"` |
| PreToolUse | Tool name | `"Edit\|Write"`, `"Bash"` |
| PostToolUse | Tool name | `"Edit\|Write"` |
| Notification | (empty = all) | `""` |
| Stop | (empty = all) | `""` |
| UserPromptSubmit | (empty = all) | `""` |
| SubagentStop | (empty = all) | `""` |

**Patterns:**
- **Exact:** `"Bash"` — matches only Bash
- **OR:** `"Edit|Write"` — matches Edit or Write
- **Catch-all:** `""` — matches everything

---

## Hook Configuration

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
| `type` | string | required | `"command"`, `"prompt"`, `"agent"`, or `"http"` |
| `command` | string | — | Shell command (for `type: "command"`) |
| `prompt` | string | — | Prompt text (for `type: "prompt"` or `"agent"`) |
| `url` | string | — | URL endpoint (for `type: "http"`) |
| `model` | string | — | Model for prompt/agent hooks (`"haiku"`, `"sonnet"`, `"opus"`) |
| `tools` | array | — | Available tools for agent hooks |
| `timeout` | number | 10 | Max execution time in seconds |
| `async` | boolean | false | Run in background (non-blocking) |
| `once` | boolean | false | Run only once per session |

---

## Hook Details

### #1 — Context Re-injection (SessionStart/compact)

**The most valuable hook.** After `/compact`, Claude loses conversation context. Native memory survives, but this hook adds:
- Full contents of `PROJECT_MEMORY.md` (architecture decisions, bugs, limitations)
- Current git branch
- Last 5 commits

### #2 — Session Info (SessionStart/startup)

Shows project name, branch, and git status once when starting. Runs with `once: true`.

### #3 — Protected Files Guard (PreToolUse/Edit|Write)

Blocks editing: `.env`, `.env.local`, `.env.production`, `.env.staging`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`. Uses `exit 2`.

### #4 — Destructive Command Guard (PreToolUse/Bash)

Blocks: `rm -rf /`, `git reset --hard`, `git push --force`, `DROP TABLE`, `git clean -fd`.

### #5 — Console.log Detector (PostToolUse/Edit|Write)

Warns when `console.log` found in edited `.ts/.tsx` files.

### #6 — ESLint Checker (PostToolUse/Edit|Write)

Shows ESLint errors after editing `.ts/.tsx` files (if ESLint configured).

### #7 — Auto-format with Prettier (PostToolUse/Edit|Write)

Runs `prettier --write` asynchronously on `.ts/.tsx/.css/.json` files.

### #8 — TypeScript Checker (PostToolUse/Edit|Write) — NEW

Runs `tsc --noEmit` asynchronously after editing `.ts/.tsx` files. Reports type error count and first 5 errors. Only runs if `tsconfig.json` exists in the project.

**Why this matters:** For non-coder workflows, TypeScript errors are invisible until build fails. This hook catches them immediately after each edit.

### #9 — Test Coverage Checker (PostToolUse/Edit|Write) — NEW

Checks if the edited `.ts/.tsx` file has a corresponding test file. Looks for:
- `filename.test.ts` / `filename.test.tsx` (co-located)
- `filename.spec.ts` (co-located)
- `__tests__/filename.test.ts` (directory-based)
- Any file in `__tests__/` referencing the edited filename

Skips: test files themselves, `.d.ts` type definitions, `__tests__/` directory files.

**Why this matters:** Ensures every code change has test coverage. Critical for AI-driven development where the human can't manually verify code correctness.

### #10 — Desktop Notification (Notification)

macOS notification when Claude waits for input.

### #11 — Session Log (Stop) — Legacy

Logs session to `~/.claude/memory/sessions.md`. Mostly superseded by native memory. Kept for audit trail.

### #12 — Uncommitted Changes Reminder (Stop)

Shows `git status --short` when session ends if uncommitted changes exist.

### #13 — TODO Auto-inject (UserPromptSubmit)

Reads `.claude/TODO.md` and injects into context with every prompt.

### #14 — PROJECT_MEMORY Size Auditor (UserPromptSubmit) — NEW

Checks `PROJECT_MEMORY.md` file size on every prompt. Warns when it exceeds 50KB with a suggestion to archive old entries to `PROJECT_MEMORY_ARCHIVE.md`.

**Why this matters:** Large PROJECT_MEMORY.md files (100KB+) slow down context re-injection after `/compact` and waste context window. The menuai project's PROJECT_MEMORY.md grew to 158KB — this hook prevents that.

### #15 — Subagent Notification (SubagentStop)

macOS notification when a subagent finishes.

---

## Custom Hook Examples

### TypeScript Type Checker (PostToolUse, command)

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

### Test Runner (PostToolUse, command, async)

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

### Security Scanner (PreToolUse, command, blocking)

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

### Smart Safety Check (PreToolUse, prompt)

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Evaluate this bash command for safety. Is it destructive, does it delete data, or modify production systems? Command: {{tool_input.command}}. Answer SAFE or DANGEROUS with one-line reason.",
      "model": "haiku",
      "timeout": 10
    }
  ]
}
```

### Slack Notification on Session End (Stop, http)

```json
{
  "matcher": "",
  "hooks": [
    {
      "type": "http",
      "url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
      "method": "POST",
      "body": {"text": "Claude Code session ended"},
      "timeout": 5,
      "async": true
    }
  ]
}
```

---

## Adding/Disabling Hooks

**Add:** Insert into the appropriate event array in `~/.claude/settings.json`.

**Disable:** Remove the hook entry. Or rename the event key (e.g., `"_PostToolUse"` won't match).

**Test:** Run `claude` and trigger the hook event to verify.
