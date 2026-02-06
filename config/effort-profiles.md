# Effort Level Profiles

Reference for configuring Claude Code effort levels.

## What Is Effort Level?

Effort level controls how much thinking Claude does before responding. Higher effort = more thorough analysis, more tokens used, slower responses.

## Configuration Methods

### 1. Interactive Slider

```bash
# In Claude Code session, use /model command
/model
# Adjust the effort slider
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

> **Note:** `max` effort level is only available via API (not in Claude Code CLI).

---

## Recommendations by Task Type

| Task | Recommended Effort | Why |
|------|-------------------|-----|
| Security audit | high | Need thorough vulnerability analysis |
| Code review | high | Need to catch subtle bugs |
| Architecture planning | high | Complex decision making |
| Feature development | high | Default, good balance |
| Ralph Wiggum loops | medium | Many iterations, save tokens |
| Reference docs lookup | low | Simple retrieval |
| Lint/format fixes | low | Mechanical, no deep thinking needed |
| File navigation | low | Quick lookups |

---

## Extended Thinking

Extended thinking is **enabled by default** in Claude Code with a budget of 31,999 tokens. No keywords or special configuration needed — every prompt gets maximum thinking automatically.

> **Note:** The `ultrathink` keyword was deprecated in January 2026. It no longer has any effect.

For even more thinking tokens on newer models, set:
```bash
export MAX_THINKING_TOKENS=63999
```

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
- `skills/mcp-usage/ralph-wiggum.md` - Ralph loops with effort tuning
