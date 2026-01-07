---
name: multi-ai-debug
description: Use Codex and Gemini CLI as second-opinion debuggers from Claude Code
category: mcp-usage
updated: 2025-01-07
models: gpt-5.1-codex-max (OpenAI), gemini-3-pro (Google)
---

# Multi-AI Debugging

Get a "second opinion" from Codex (OpenAI gpt-5.1-codex-max) or Gemini (Google gemini-3-pro) when debugging.

## Why Use Multiple AIs?

| Situation | Solution |
|-----------|----------|
| Stuck on bug > 30 min | Fresh perspective from different model |
| Race conditions | Different models catch different patterns |
| Need validation | Confirm Claude's fix is correct |
| Complex async issues | Multiple analyses help |

---

## Installation

### 1. Codex CLI (OpenAI)

```bash
# Install
npm install -g @openai/codex

# Set API key
export OPENAI_API_KEY="sk-..."

# Add to ~/.zshrc for persistence
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.zshrc
```

### 2. Gemini CLI (Google)

```bash
# Install
npm install -g @anthropic-ai/gemini-cli
# OR
brew install gemini-cli

# Authenticate
gemini auth

# Or set API key manually
export GEMINI_API_KEY="..."
```

---

## Quick Aliases

Add to `~/.zshrc` (or run `./scripts/setup-ai-aliases.sh`):

```bash
# Codex (gpt-5.1-codex-max with high reasoning) - read-only review
alias cr='codex exec -m gpt-5.1-codex-max -c model_reasoning_effort=\"high\" -s read-only "You are a senior code reviewer. Analyze for bugs, race conditions, edge cases, type errors, security issues. Be specific with line numbers. Do NOT modify files:"'

# Gemini (gemini-3-pro) - code review
alias gr='gemini -m gemini-3-pro --preview-features -p "You are a senior code reviewer. Analyze for bugs, race conditions, edge cases, type errors, security issues. Be specific with line numbers:"'

# Quick bug analysis (gpt-5.1-codex-max)
alias bug='codex exec -m gpt-5.1-codex-max -c model_reasoning_effort=\"high\" -s read-only "Find the bug in this code. Explain root cause and suggest fix:"'

# Security audit (gpt-5.1-codex-max)
alias sec='codex exec -m gpt-5.1-codex-max -c model_reasoning_effort=\"high\" -s read-only "Security audit: Find vulnerabilities, injection risks, auth issues, exposed secrets. OWASP Top 10 check:"'

# Performance review (gpt-5.1-codex-max)
alias perf='codex exec -m gpt-5.1-codex-max -c model_reasoning_effort=\"high\" -s read-only "Performance review: Find slow code, memory leaks, unnecessary renders, N+1 queries, async issues:"'

# Architecture review (gemini-3-pro)
alias arch='gemini -m gemini-3-pro --preview-features -p "Architecture review: Analyze code structure, coupling, SOLID principles, suggest improvements:"'
```

Apply:
```bash
source ~/.zshrc
```

---

## Usage Patterns

### Pattern 1: Direct File Review

```bash
# Review single file
cr src/components/Button.tsx

# Review multiple files
cr src/auth/*.ts

# Gemini review
gr src/api/orders.ts
```

### Pattern 2: Pipe Code

```bash
# Review specific function
grep -A 50 "function handleSubmit" src/form.ts | cr

# Review recent changes
git diff HEAD~1 | cr
```

### Pattern 3: From Claude Code Session

When stuck, tell Claude:
```
Run `cr src/problematic-file.ts` and show me the output
```

Claude will:
1. Execute the command
2. Show you Codex's analysis
3. Use the insights to fix the bug

---

## Workflow: Claude + Codex/Gemini

### Step 1: You Describe Symptom
```
"Login button doesn't work after second click"
```

### Step 2: Claude Identifies Files
```
Related files:
- src/components/LoginButton.tsx
- src/hooks/useAuth.ts
- src/api/auth.ts
```

### Step 3: Get Second Opinion
```bash
cr src/components/LoginButton.tsx src/hooks/useAuth.ts
```

### Step 4: Codex Analyzes
```
Found issues:
1. Line 45: Race condition - setState called after unmount
2. Line 62: Missing await before async call
3. Line 78: Event handler not debounced
```

### Step 5: Claude Fixes
```
Based on Codex analysis, I'll fix the race condition at line 45...
```

---

## Advanced: Slash Command

Create `/review-bug` skill for Claude Code:

### File: `skills/commands/review-bug.md`

```markdown
---
name: review-bug
description: Get Codex/Gemini analysis of a bug
trigger: /review-bug
---

When user runs `/review-bug "description"`:

1. Identify related files based on description
2. Run: `cr <files>` or `gr <files>`
3. Parse the output
4. Suggest fix based on analysis
```

### Usage:
```
/review-bug "form validation fails silently"
```

---

## Comparison: When to Use Which

| Model | Best For |
|-------|----------|
| **Claude (Opus 4.5)** | Full context, implementing fixes, refactoring |
| **Codex (gpt-5.1-codex-max)** | Deep bug analysis, security review, high reasoning |
| **Gemini (gemini-3-pro)** | Architecture review, alternative perspective |

### Decision Tree:

```
Bug found?
├── Know the file? → cr file.ts (quick Codex scan)
├── Don't know where? → Ask Claude to find files, then cr
└── Need implementation? → Claude handles it
```

---

## Best Practices

### DO:
- Use read-only mode for safety
- Pass related files together for context
- Combine multiple AI opinions
- Let Claude do the actual fix

### DON'T:
- Let Codex/Gemini modify files (use Claude for that)
- Blindly trust any single AI
- Overuse (API costs add up)
- Use for trivial bugs

---

## Troubleshooting

### "codex: command not found"
```bash
npm install -g @openai/codex
# Or check PATH
echo $PATH | grep node
```

### "API key invalid"
```bash
# Check key is set
echo $OPENAI_API_KEY

# Re-export
export OPENAI_API_KEY="sk-..."
```

### "Rate limit exceeded"
- Wait 1 minute
- Use Gemini as fallback
- Check OpenAI usage dashboard

---

## Cost Comparison

| Model | Cost | Notes |
|-------|------|-------|
| Codex (gpt-5.1-codex-max) | Premium tier | High reasoning, best for complex bugs |
| Gemini (gemini-3-pro) | Mid tier | Good for architecture, preview features |
| Claude (Opus 4.5) | Via subscription | With Claude Code |

**Tip:** Use Codex for deep dives with high reasoning, Gemini for architecture review.

---

## Integration with Framework

This skill is part of 2111framework multi-AI debugging setup:

```
2111framework/
├── skills/
│   └── mcp-usage/
│       └── multi-ai-debug.md  ← This file
└── scripts/
    └── setup-ai-aliases.sh    ← Alias installer
```

### Quick Setup:
```bash
# Run from framework root
./scripts/setup-ai-aliases.sh
```

---

## Related Skills

- `github-mcp-guide.md` - Use with PR reviews
- `clerk-mcp-guide.md` - Debug auth issues
- `chrome-extension-guide.md` - Visual bug verification
