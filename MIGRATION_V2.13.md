# Migration Guide: v2.14 to v2.15

## What Changed

### Frontmatter Syntax

| Old (v2.12) | New (v2.13) | Action |
|-------------|-------------|--------|
| `forked_context: true` | `context: fork` | Auto-migrated |
| `forked_context: false` | (removed) | `false` is default, line removed |
| `category: xxx` | (removed) | Not supported by Claude Code |
| `updated: xxx` | (removed) | Not supported by Claude Code |
| `trigger: xxx` | Keywords in `description:` | Moved to description field |
| `requires_plugin: xxx` | (removed) | Not supported by Claude Code |
| `plugin: xxx` | (removed) | Not supported by Claude Code |
| `models: xxx` | (removed) | Not supported (use `model:`) |

### Hooks Format

**Old (v2.12):**
```yaml
hooks:
  pre_invoke:
    - command: "echo 'Starting...'"
  post_invoke:
    - command: "echo 'Done.'"
```

**New (v2.13):**
```yaml
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: "echo 'Starting...'"
          once: true
  Stop:
    - hooks:
        - type: command
          command: "echo 'Done.'"
          once: true
```

### Model Updates

| Old | New |
|-----|-----|
| Claude Opus 4.5 | Claude Opus 4.6 |
| gpt-5.1-codex-max | gpt-5.3-codex |

---

## Migration Checklist

### Automatic (done in v2.13)

- [x] `forked_context: true` replaced with `context: fork` in 4 files
- [x] `forked_context: false` removed from 24 files
- [x] `category:` removed from all skill/agent files
- [x] `updated:` removed from all skill/agent files
- [x] `trigger:` removed, keywords moved to `description:`
- [x] `requires_plugin:`, `plugin:`, `models:` removed
- [x] Hooks format updated in 6 files
- [x] Codex model updated to gpt-5.3-codex in all files
- [x] setup-ai-aliases.sh updated

### Manual Steps (if you customized)

- [ ] Update `~/.zshrc` aliases if you have custom AI debug aliases
  ```bash
  # Re-run setup script
  ~/.claude/2111framework/scripts/setup-ai-aliases.sh
  source ~/.zshrc
  ```

- [ ] Update any custom skills with old frontmatter format
  - Replace `forked_context: true` with `context: fork`
  - Remove `category:`, `updated:`, `trigger:`
  - Update hooks to new format

- [ ] Enable Agent Teams (optional)
  ```bash
  export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true
  ```

- [ ] Review effort level settings
  ```bash
  # Check current setting
  claude config get effortLevel
  ```

---

## New Files in v2.13

| File | Type | Description |
|------|------|-------------|
| `skills/mcp-usage/agent-teams.md` | Skill | Parallel agent coordination |
| `skills/mcp-usage/mcp-tool-search.md` | Skill | MCP lazy loading reference |
| `skills/mcp-usage/async-hooks.md` | Skill | Background hooks + Setup hook |
| `skills/mcp-usage/background-tasks.md` | Skill | Dev server in background + --from-pr |
| `config/effort-profiles.md` | Config | Effort level reference |

---

## Updated Files in v2.13

| File | Changes |
|------|---------|
| `agents/review.md` | Frontmatter fix, Agent Teams pattern, ultrathink |
| `agents/security.md` | model: opus, context: fork, ultrathink, zero-day patterns |
| `skills/business/consilium.md` | Frontmatter fix, Agent Teams parallel mode, ultrathink |
| `skills/mcp-usage/ralph-wiggum.md` | Frontmatter fix, Agent Teams + Background Tasks sections |
| `skills/mcp-usage/ai-agents.md` | Frontmatter fix, gpt-5.3-codex |
| `skills/mcp-usage/multi-ai-debug.md` | Frontmatter fix, gpt-5.3-codex |
| `scripts/setup-ai-aliases.sh` | gpt-5.3-codex model |
| `mcp.json` | context7 restored with serverInstructions |
| `README.md` | v2.13, Opus 4.6, new features |
| All 24 reference skills | Cleaned unsupported frontmatter fields |

---

## Requires

- **Claude Code 2.1.7+** (`claude update`)
- Agent Teams: experimental flag enabled
- Codex: updated CLI with gpt-5.3-codex support
