# Effort Level Profiles

Reference for configuring Claude Code effort levels.

## What Is Effort Level?

Effort level controls how much thinking Claude does before responding. Higher effort = more thorough analysis, more tokens used, slower responses.

## Configuration Methods

### 1. Interactive — `/effort`

```bash
# In a Claude Code session:
/effort xhigh     # Claude Code default on Fable 5 / Opus 5 (Denis's effortLevel)
/effort high      # solid default for routine work — noticeably cheaper, same 1M context
/effort medium    # cheap subagents / lookups; low/medium punch above their weight on Claude 5
/effort max       # correctness-over-cost only; prone to overthinking on simple tasks
```

CLI equivalent for one session: `claude --effort high`.

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
| **high** | Thorough analysis, deep reasoning | 1x | Slower |
| **xhigh** (default) | Deepest practical reasoning for coding/agentic work | ~1.3–1.5x | Slower |
| **max** | Ceiling — correctness over cost | 2x+ | Slowest |

> **Note (Claude 5, Aug 2026):** Claude Code defaults to `xhigh` on Fable 5 / Opus 5 (Denis's `~/.claude/settings.json` pins `effortLevel: "xhigh"`). All five levels are available in-session and via `--effort`. On Fable 5 thinking is always on — effort is the only depth control. `low`/`medium` on Claude 5 often match `xhigh` on prior generations, so step down for routine work before reaching for a cheaper model.

---

## Hard cost ceiling — `--max-budget-usd`

Claude Code has a **dollar cap for headless runs**: `claude -p "<task>" --max-budget-usd 5`. When the cap is reached the session stops and no new background subagents are spawned. It works **only with `--print`/`-p`** (headless, cron, background agents, CI) — there is no interactive equivalent; for interactive sessions the levers are effort level + `/cost`.

Use it for anything unattended:

```bash
# overnight refactor / migration / research run — cap the damage if it loops
claude -p "Run the app-store-review audit on App/ and write the report to docs/audit.md" --max-budget-usd 10

# scheduled agents / cron: always cap
claude -p "$(cat prompts/nightly-triage.md)" --max-budget-usd 3 --effort high
```

Rules of thumb (after the May 2026 Gemini Pro leak, $130): every unattended `claude -p` gets a cap; start at `$3–10` and raise only after seeing the real spend in `/cost`. Interactive sessions: watch `/cost`, use `/effort medium` for grunt work, and keep the fallback model on Opus 5 (`fallbackModel` in `config/settings.json`) so an overload never silently downgrades to a weaker tier.

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

## Adaptive Thinking (Claude 5 family)

Fable 5 and Opus 5 use **adaptive thinking** — the model itself decides how long to reason based on task difficulty. On Fable 5 thinking is **always on** and cannot be disabled; on Opus 5 it is on by default. No `alwaysThinkingEnabled` flag, no `ultrathink` keyword, no `budget_tokens`, no manual budget tuning.

- Simple edits: fast, low thinking
- Architecture / security / debugging: deep thinking auto-engages
- Cost is the same whether thinking engages or not — you don't pay for unused thinking

For cases where you want to force extra thinking budget:
```bash
export MAX_THINKING_TOKENS=63999
```

> **Deprecated:** the `ultrathink` keyword (January 2026) and `alwaysThinkingEnabled: true` setting (April 2026) have no effect on Claude 5 models. Remove them from configs. `MAX_THINKING_TOKENS` is likewise ignored on Fable 5 (thinking is always on) — use `/effort` instead.

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

| xhigh | ~1.3–1.5x base (Claude Code default) |
| max | 2x+ base |

Combine with Agent Teams for significant cost control:
- Lead agent: xhigh (Fable 5) or high
- Routine teammates: medium effort, `claude-sonnet-5` for cheap fan-out
- Unattended runs: `--max-budget-usd` (see above)

---

## Related Files

- `skills/mcp-usage/agent-teams.md` - Agent Teams cost control
