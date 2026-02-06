# 2111framework v2.15

**Denis's Claude Code Development Framework**

**Repository:** https://github.com/Enthusiasm-c/2111framework
**Version:** 2.15.0
**Updated:** February 6, 2026
**Requires:** Claude Code 2.1.7+

---

## Quick Start

```bash
# Clone framework
git clone https://github.com/Enthusiasm-c/2111framework.git ~/.claude/2111framework

# Install MCP servers (mcp.json includes context7 + shadcn with serverInstructions)
cp ~/.claude/2111framework/mcp.json ~/.claude/mcp.json

# Copy hooks config
cp ~/.claude/2111framework/config/settings.json ~/.claude/settings.json

# Setup Multi-AI Debug (Codex + Gemini)
~/.claude/2111framework/scripts/setup-ai-aliases.sh
source ~/.zshrc

# Add API keys to ~/.zshrc
export OPENAI_API_KEY="your-openai-key"      # https://platform.openai.com/api-keys
export GEMINI_API_KEY="your-gemini-key"      # https://aistudio.google.com/apikey

# Optional: Enable Agent Teams (experimental)
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true
```

---

## What's New in v2.15

### Opus 4.6 Adaptation:
- **Claude Opus 4.6** -- improved self-correction, 500+ zero-day security findings
- **GPT-5.3 Codex** -- updated model in all aliases and skills
- **Frontmatter fixes** -- all skills use correct Claude Code syntax
- **Agent Teams** -- parallel agent coordination (experimental)
- **Background Tasks** -- Ctrl+B for dev servers, `--from-pr` for PRs
- **Effort Levels** -- low/medium/high configuration
- **MCP Tool Search** -- serverInstructions for lazy loading
- **Async Hooks** -- background hooks, Setup hook

### New Skills:
| Skill | Description |
|-------|-------------|
| `agent-teams.md` | Parallel agent coordination |
| `mcp-tool-search.md` | MCP lazy loading reference |
| `async-hooks.md` | Background hooks + Setup hook |
| `background-tasks.md` | Dev server in background + --from-pr |

### New Config:
| File | Description |
|------|-------------|
| `config/effort-profiles.md` | Effort level reference |

### Frontmatter Fixes:
- `forked_context: true` replaced with `context: fork`
- Removed unsupported fields: `category`, `updated`, `trigger`, `plugin`
- Fixed hooks format: `pre_invoke`/`post_invoke` replaced with `SessionStart`/`Stop`

### Model Assignment:
| Skill Type | Model | Reason |
|------------|-------|--------|
| `consilium`, `security-checklist`, `review`, `security` | opus | Deep analysis |
| `ralph-wiggum` | sonnet | Balanced loops |
| `ai-agents`, `multi-ai-debug` | haiku | Fast routing |
| Reference docs, new skills | (inherit) | Uses session default |

---

## What's New in v2.14

### Auto-Check Hooks (NEW):
Based on [Anthropic hackathon winner](https://github.com/affaan-m/everything-claude-code) best practices:
- **console.log detector**: Warns when console.log found in .ts/.tsx files
- **ESLint checker**: Shows errors after file edits (if ESLint configured)

```
Edit file.ts -> [HOOK] "WARNING: console.log detected..."
            -> [HOOK] "ESLint issues: ..."
```

### MCP Optimization (NEW):
- Removed rarely-used MCPs from global config
- Saved ~10,500 tokens (~5% context window)
- Only essential MCPs: `context7`, `shadcn`

### Install hooks:
```bash
cp ~/.claude/2111framework/config/settings.json ~/.claude/settings.json
```

---

## What's New in v2.13

### React Optimization Skill (Vercel Best Practices)
New skill based on official Vercel React best practices:
- **Async Waterfalls**: `Promise.all()` for parallel operations
- **Early Returns**: Check conditions before fetch
- **Minimal Fetch**: Use `select` for validation, `include` only when needed
- **React.memo**: Memoize list item components
- **Server Actions**: Replace `useEffect` + `fetch` patterns
- **Dynamic Imports**: Lazy load heavy libraries

**Usage:**
```bash
# Reference in code review
/review src/api/webhooks/xendit/route.ts

# Or read directly
Read skills/tech-stack/react-optimization.md
```

**Review Agent Updated:**
- Performance checklist expanded (Async, React, Data Fetching)
- Links to react-optimization.md skill

---

## Multi-AI Agents

### Natural Language Commands

| Say this | Claude does |
|----------|-------------|
| "Ask Gemini review for broken layout" | Finds files, runs Gemini analysis |
| "Ask Codex to find race condition" | Finds files, runs Codex analysis |
| "Need a second opinion" | Runs both Codex + Gemini |

### Agent Selection

| Problem Type | Best Agent |
|--------------|------------|
| UI, layout, CSS, visual bugs | **Gemini 3 Pro** |
| Logic, async, TypeScript, race conditions | **Codex** |
| Security, auth, OWASP | **Codex** |
| Architecture review | **Gemini** |
| Unknown / need validation | **Both** |

### Bash Aliases

```bash
cr file.tsx    # Codex code review (gpt-5.3-codex)
gr file.tsx    # Gemini code review (gemini-3-pro-preview)
bug file.tsx   # Codex bug finder
sec file.tsx   # Codex security audit
perf file.tsx  # Codex performance review
arch file.tsx  # Gemini architecture review
```

---

## MCP Servers

| Server | Purpose | Notes |
|--------|---------|-------|
| Context7 | Library documentation | Included in mcp.json with serverInstructions |
| shadcn | UI components | Included in mcp.json with serverInstructions |
| 21st.dev Magic | AI UI generation | Add per-project if needed |
| Clerk | User management | Add per-project if needed |

MCP Tool Search with `serverInstructions` enables lazy loading -- only tool descriptions loaded, not full schemas. See `skills/mcp-usage/mcp-tool-search.md`.

---

## Agents

| Agent | File | Description |
|-------|------|-------------|
| Architect | `agents/architect.md` | System design, tech stack, implementation phases |
| Review | `agents/review.md` | Code review + simplification (Opus) |
| QA | `agents/qa.md` | Testing, bug finding, Chrome Extension |
| Docs | `agents/docs.md` | Documentation, READMEs, ADRs |
| Dev | `agents/dev.md` | Feature implementation |
| Security | `agents/security.md` | Vulnerability audits (Opus, zero-day patterns) |

---

## Skills

### Business
| Skill | Description |
|-------|-------------|
| `consilium.md` | 6-agent product analysis board (Agent Teams compatible) |

### MCP Usage
| Skill | Description |
|-------|-------------|
| `ralph-wiggum.md` | Autonomous loops - run tasks for hours |
| `agent-teams.md` | Parallel agent coordination (NEW) |
| `mcp-tool-search.md` | MCP lazy loading reference (NEW) |
| `async-hooks.md` | Background hooks + Setup hook (NEW) |
| `background-tasks.md` | Dev server in background + --from-pr (NEW) |
| `ai-agents.md` | Natural language commands for Gemini/Codex agents |
| `multi-ai-debug.md` | Codex/Gemini as second-opinion debuggers |
| `chrome-extension-guide.md` | Browser automation for frontend testing |
| `github-mcp-guide.md` | Issues, PRs, CI/CD from terminal |
| `clerk-mcp-guide.md` | Users, organizations, invitations management |
| `context7-best-practices.md` | Library documentation lookup |
| `shadcn-mcp-guide.md` | shadcn component installation |

### Integrations
| Skill | Description |
|-------|-------------|
| `syrve-api.md` | Syrve Cloud API - auth, orgs, dictionaries |
| `syrve-delivery.md` | Syrve delivery orders, couriers, zones |
| `syrve-menu.md` | Syrve menu, stop-lists, combos |
| `syrve-customers.md` | Syrve loyalty, wallets, coupons |
| `syrve-webhooks.md` | Syrve event subscriptions |
| `syrve-table-orders.md` | Syrve QR menu, in-restaurant ordering |
| `syrve-reports.md` | Syrve OLAP analytics, dashboards |
| `syrve-marketing.md` | Syrve discounts, promotions, coupons |
| `neondb-best-practices.md` | PostgreSQL serverless patterns |
| `telegram-bot-patterns.md` | Mini Apps, CloudStorage, Auth |
| `monitoring-sentry.md` | Error tracking setup |

### Tech Stack
| Skill | Description |
|-------|-------------|
| `nextjs-app-router.md` | Next.js 14+ patterns |
| `react-optimization.md` | Vercel best practices: waterfalls, memo, Server Actions |
| `typescript-conventions.md` | Type safety, Zod validation |
| `database-migrations.md` | Drizzle ORM workflow |

### Code Quality
| Skill | Description |
|-------|-------------|
| `security-checklist.md` | Security audit checklist |
| `accessibility-basics.md` | WCAG compliance |
| `performance-optimization.md` | Next.js performance |

---

## Usage Examples

### Consilium (Product Analysis)
```bash
/consilium

Product: Invoice OCR for restaurants
Problem: Manual entry takes 2 hours daily
Solution: Photo -> OCR -> POS integration
Metrics: 50 users, $200 MRR, 15% growth
```

### Ralph Wiggum (Autonomous)
```bash
# Fix all lint errors autonomously
/ralph-loop "Run npm run lint, fix all errors" --max-iterations 15

# Generate CRUD and tests
/ralph-loop "Generate CRUD API for Orders entity with tests" \
  --completion-promise "All tests passed" --max-iterations 25
```

### Agent Teams (Parallel Review)
```
"Review src/features/auth/ with Agent Teams -- security, performance, and correctness in parallel"
```

### Multi-AI Debug
```
"Ask Gemini review for broken layout in Dashboard"
"Ask Codex why form submits twice"
"Need a second opinion on this bug"
```

### Background Dev Server
```bash
npm run dev          # Press Ctrl+B to run in background
# Continue working while dev server runs
```

---

## Model Comparison

| Capability | Claude Opus 4.6 | Codex (gpt-5.3) | Gemini 3 Pro |
|------------|-----------------|-----------------|--------------|
| Backend/Architecture | Best | Strong | Good |
| Frontend UI/UX | Good | Strong | Best |
| Bug Detection | Strong | Best | Strong |
| Security Audit | Best | Strong | Good |
| Multimodal | Good | Good | Best |
| Long Tasks (7h+) | Strong | Best | Good |
| Self-Correction | Best | Good | Good |

---

## Claude Code Features Used

This framework requires Claude Code 2.1.7+. Key features:

### Skill Frontmatter
```yaml
---
name: my-skill
model: opus              # opus/sonnet/haiku
context: fork            # isolated context
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: "echo 'Starting...'"
          once: true
---
```

### Invoke Skills
```bash
/consilium          # Product analysis
/ralph-wiggum       # Autonomous loops
/security           # Security audit
```

### Agent Teams (Experimental)
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true
```

### Effort Levels
```bash
export CLAUDE_CODE_EFFORT_LEVEL=high   # low/medium/high
```

### Background Tasks
```bash
npm run dev    # Press Ctrl+B for background
```

### MCP Tool Search
```json
{
  "serverInstructions": "Short description for lazy loading"
}
```

### Wildcard Permissions
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm run *)",
      "Read(/src/**)"
    ]
  }
}
```

---

## Resources

- **CHANGELOG:** [`CHANGELOG.md`](./CHANGELOG.md)
- **Migration v2.15:** [`MIGRATION_V2.13.md`](./MIGRATION_V2.13.md)
- **Migration v2.0:** [`MIGRATION_V2.md`](./MIGRATION_V2.md)
- **Plugins:** [`PLUGINS_SETUP.md`](./PLUGINS_SETUP.md)
- **Effort Profiles:** [`config/effort-profiles.md`](./config/effort-profiles.md)

---

**Version:** 2.15.0
