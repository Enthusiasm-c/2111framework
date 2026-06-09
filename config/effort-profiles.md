# Effort Level Profiles

Reference for configuring Claude Code effort levels.

## What Is Effort Level?

Effort level controls how much thinking Claude does before responding. Higher effort = more thorough analysis, more tokens used, slower responses.

## Configuration Methods

### 1. Interactive — `/effort`

```bash
# In a Claude Code session:
/effort high      # default on Opus 4.8
/effort xhigh     # hardest tasks (deeper reasoning, more tokens)
```

### 2. Environment Variable

```bash
export CLAUDE_CODE_EFFORT_LEVEL=high
```

### 3. Settings File

In `~/.claude/settings.json`:

```json
{
  "effortLevel": "high"
}
```

---

## Effort Levels

| Level | Behavior | Token Usage | Speed |
|-------|----------|-------------|-------|
| **low** | Quick responses, less analysis | ~0.5x | Fast |
| **medium** | Balanced analysis | ~0.75x | Moderate |
| **high** (default) | Thorough analysis, deep reasoning | 1x | Slower |

> **Note:** Opus 4.8 defaults to `high` effort. Use `/effort xhigh` in-session for the hardest tasks (a tier above `high`); the `max` budget remains API-only.

---

## Recommendations by Task Type

| Task | Recommended Effort | Why |
|------|-------------------|-----|
| Security audit | high | Need thorough vulnerability analysis |
| Code review | high | Need to catch subtle bugs |
| Architecture planning | high | Complex decision making |
| Feature development | high | Default, good balance |
| Reference docs lookup | low | Simple retrieval |
| Lint/format fixes | low | Mechanical, no deep thinking needed |
| File navigation | low | Quick lookups |

---

## Adaptive Thinking (Opus 4.8)

Opus 4.8 uses **adaptive thinking** — the model itself decides how long to reason based on task difficulty. No `alwaysThinkingEnabled` flag, no `ultrathink` keyword, no manual budget tuning needed in most cases.

- Simple edits: fast, low thinking
- Architecture / security / debugging: deep thinking auto-engages
- Cost is the same whether thinking engages or not — you don't pay for unused thinking

For cases where you want to force extra thinking budget:
```bash
export MAX_THINKING_TOKENS=63999
```

> **Deprecated:** the `ultrathink` keyword (January 2026) and `alwaysThinkingEnabled: true` setting (April 2026) have no effect on Opus 4.8. Remove them from configs.

---

## Per-Session Override

You can change effort mid-session:

```bash
# Switch to low effort for quick tasks
/model  # adjust slider

# Switch back to high for complex work
/model  # adjust slider
```

---

## Cost Impact

| Effort | Approximate Cost Multiplier |
|--------|-----------------------------|
| low | ~0.5x base |
| medium | ~0.75x base |
| high | 1x base (default) |

Combine with Agent Teams for significant cost control:
- Lead agent: high effort
- Routine teammates: medium effort

---

## Related Files

- `skills/mcp-usage/agent-teams.md` - Agent Teams cost control
