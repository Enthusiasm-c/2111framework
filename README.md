# 2111framework v2.14

**Denis's Claude Code Development Framework**

**Repository:** https://github.com/Enthusiasm-c/2111framework
**Version:** 2.14.0
**Updated:** January 20, 2026
**Requires:** Claude Code 2.1.0+

---

## Quick Start

```bash
# Clone framework
git clone https://github.com/Enthusiasm-c/2111framework.git ~/.claude/2111framework

# Install MCP servers (optimized - only essentials)
claude mcp add context7 npx @context7/mcp-server
claude mcp add shadcn npx @modelcontextprotocol/server-shadcn

# Copy hooks config
cp ~/.claude/2111framework/config/settings.json ~/.claude/settings.json

# Setup Multi-AI Debug (Codex + Gemini)
~/.claude/2111framework/scripts/setup-ai-aliases.sh
source ~/.zshrc

# Add API keys to ~/.zshrc
export OPENAI_API_KEY="your-openai-key"      # https://platform.openai.com/api-keys
export GEMINI_API_KEY="your-gemini-key"      # https://aistudio.google.com/apikey
```

---

## What's New in v2.14

### Auto-Check Hooks (NEW):
Based on [Anthropic hackathon winner](https://github.com/affaan-m/everything-claude-code) best practices:
- **console.log detector**: Warns when console.log found in .ts/.tsx files
- **ESLint checker**: Shows errors after file edits (if ESLint configured)

```
Edit file.ts → [HOOK] "WARNING: console.log detected..."
            → [HOOK] "ESLint issues: ..."
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

## What's New in v2.12

### Code Simplifier Integration:
- **Review agent** now uses official `code-simplifier` plugin
- **Two-phase workflow**: Simplify → Review
- **Flags**: `--no-simplify`, `--simplify-only`
- Workflow: Ralph Wiggum → Review → Commit

### Setup:
```bash
claude plugin install code-simplifier
```

### v2.11 - Claude Code 2.1.0 Integration:
- **All skills updated** with new frontmatter:
  - `model:` - opus/sonnet/haiku per skill
  - `forked_context:` - isolated context for complex tasks
  - `hooks:` - pre/post invoke commands
- **Skill invocation** via `/skill-name` (e.g., `/consilium`)
- **Wildcard permissions** support in documentation

### Model Assignment:
| Skill Type | Model | Reason |
|------------|-------|--------|
| `consilium`, `security-checklist`, `review` | opus | Deep analysis |
| `ralph-wiggum` | sonnet | Balanced loops |
| `ai-agents`, `multi-ai-debug` | haiku | Fast routing |
| Reference docs | sonnet | Standard tasks |

### v2.10:
- **Consilium - Product Analysis Board** (`consilium.md`)
  - 7 AI agents (including Research Agent)
  - `/consilium [product brief]` - full product analysis
  - Auto-scans codebase when run inside project
  - Specialized for B2B SaaS in Indonesian restaurant industry

### v2.9:
- **Ralph Wiggum Plugin** (`ralph-wiggum.md`)
  - Autonomous loops - run tasks for hours without intervention
  - `/ralph-loop "task" --max-iterations 20`
  - Auto-retry until success criteria met
  - Examples: CRUD generation, lint/test fixes, migrations

### v2.8:
- **AI Agents Natural Language** (`ai-agents.md`)
  - Say: "Запусти агента Gemini review для broken layout в аналитике"
  - Say: "Попроси Codex найти race condition в auth"
  - Say: "Нужно второе мнение по этому багу"
  - Auto-detects problem type → selects best AI agent

### v2.7:
- **Multi-AI Debug** (`multi-ai-debug.md`)
  - Models: `gpt-5.1-codex-max` (high reasoning), `gemini-3-pro-preview`
  - Bash aliases: `cr`, `gr`, `bug`, `sec`, `perf`, `arch`
  - Codex v0.79.0 syntax support

---

## Multi-AI Agents

### Natural Language Commands

| Say this | Claude does |
|----------|-------------|
| "Запусти агента Gemini review для broken layout" | Finds files → runs Gemini analysis |
| "Попроси Codex найти race condition" | Finds files → runs Codex analysis |
| "Нужно второе мнение" | Runs both Codex + Gemini |

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
cr file.tsx    # Codex code review (gpt-5.1-codex-max)
gr file.tsx    # Gemini code review (gemini-3-pro-preview)
bug file.tsx   # Codex bug finder
sec file.tsx   # Codex security audit
perf file.tsx  # Codex performance review
arch file.tsx  # Gemini architecture review
```

---

## MCP Servers

| Server | Purpose | Command |
|--------|---------|---------|
| Context7 | Library documentation | `claude mcp add context7 npx @context7/mcp-server` |
| shadcn | UI components | `claude mcp add shadcn npx @modelcontextprotocol/server-shadcn` |
| 21st.dev Magic | AI UI generation | `claude mcp add 21st-magic npx -y @21st-dev/magic@latest` |
| Clerk | User management | `claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp` |

---

## Agents

| Agent | File | Description |
|-------|------|-------------|
| Architect | `agents/architect.md` | System design, tech stack, implementation phases |
| Review | `agents/review.md` | Code review + simplification |
| QA | `agents/qa.md` | Testing, bug finding, Chrome Extension |
| Docs | `agents/docs.md` | Documentation, READMEs, ADRs |
| Dev | `agents/dev.md` | Feature implementation |
| Security | `agents/security.md` | Vulnerability audits |

---

## Skills

### Business
| Skill | Description |
|-------|-------------|
| `consilium.md` | 6-agent product analysis board for startups |

### MCP Usage
| Skill | Description |
|-------|-------------|
| `ralph-wiggum.md` | Autonomous loops - run tasks for hours |
| `ai-agents.md` | Natural language commands for Gemini/Codex agents |
| `multi-ai-debug.md` | Codex/Gemini as second-opinion debuggers |
| `chrome-extension-guide.md` | Browser automation for frontend testing |
| `github-mcp-guide.md` | Issues, PRs, CI/CD from terminal |
| `clerk-mcp-guide.md` | Users, organizations, invitations management |
| `context7-patterns.md` | Library documentation lookup |
| `21st-magic-patterns.md` | AI UI component generation |

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
| `code-review-checklist.md` | Review guidelines |
| `typescript-best-practices.md` | Clean TypeScript |

---

## Usage Examples

### Consilium (Product Analysis)
```bash
/consilium

Product: Invoice OCR for restaurants
Problem: Manual entry takes 2 hours daily
Solution: Photo → OCR → POS integration
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

### Multi-AI Debug
```
"Запусти агента Gemini review для broken layout в Dashboard"
"Попроси Codex найти почему форма отправляется дважды"
"Нужно второе мнение по этому багу"
```

### Architecture Planning
```
Read agents/architect.md
Plan a Syrve product sync feature
```

### Code Review
```
Read agents/review.md
Review and simplify src/components/Dashboard.tsx
```

### Frontend Testing
```
Read skills/mcp-usage/chrome-extension-guide.md
Test the login flow on localhost:3000
```

---

## Model Comparison

| Capability | Claude Opus 4.5 | Codex (gpt-5.1) | Gemini 3 Pro |
|------------|-----------------|-----------------|--------------|
| Backend/Architecture | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Frontend UI/UX | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Bug Detection | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Security Audit | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Multimodal | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Long Tasks (7h+) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## Claude Code 2.1.0 Features

This framework requires Claude Code 2.1.0+. Key features used:

### Skill Frontmatter
```yaml
---
name: my-skill
model: opus              # opus/sonnet/haiku
forked_context: true     # isolated context
hooks:
  pre_invoke:
    - command: "echo 'Starting...'"
  post_invoke:
    - command: "echo 'Done!'"
---
```

### Invoke Skills
```bash
/consilium          # Product analysis
/ralph-wiggum       # Autonomous loops
/security           # Security audit
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

### Other 2.1.0 Features
- `Shift+Enter` for newlines (no setup)
- `/teleport` to claude.ai/code
- `claude config set language "Russian"`
- Deny tool → agent continues (doesn't stop)

---

## Resources

- **CHANGELOG:** [`CHANGELOG.md`](./CHANGELOG.md)
- **Migration:** [`MIGRATION_V2.md`](./MIGRATION_V2.md)
- **Plugins:** [`PLUGINS_SETUP.md`](./PLUGINS_SETUP.md)
- **21st.dev:** https://21st.dev/magic
- **Chrome Extension:** https://chromewebstore.google.com/detail/claude

---

**Version:** 2.13.0
