# 2111framework v2.8

**Denis's Claude Code Development Framework**

**Repository:** https://github.com/Enthusiasm-c/2111framework
**Version:** 2.8.0
**Updated:** January 7, 2026

---

## Quick Start

```bash
# Clone framework
git clone https://github.com/Enthusiasm-c/2111framework.git ~/.claude/2111framework

# Install MCP servers
claude mcp add context7 npx @context7/mcp-server
claude mcp add shadcn npx @modelcontextprotocol/server-shadcn
claude mcp add 21st-magic npx -y @21st-dev/magic@latest

# Setup Multi-AI Debug (Codex + Gemini)
~/.claude/2111framework/scripts/setup-ai-aliases.sh
source ~/.zshrc

# Add API keys to ~/.zshrc
export OPENAI_API_KEY="your-openai-key"      # https://platform.openai.com/api-keys
export GEMINI_API_KEY="your-gemini-key"      # https://aistudio.google.com/apikey
```

---

## What's New in v2.8

### Added:
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

### MCP Usage
| Skill | Description |
|-------|-------------|
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
| `typescript-conventions.md` | Type safety, Zod validation |
| `database-migrations.md` | Drizzle ORM workflow |

### Code Quality
| Skill | Description |
|-------|-------------|
| `code-review-checklist.md` | Review guidelines |
| `typescript-best-practices.md` | Clean TypeScript |

---

## Usage Examples

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

## Resources

- **CHANGELOG:** [`CHANGELOG.md`](./CHANGELOG.md)
- **Migration:** [`MIGRATION_V2.md`](./MIGRATION_V2.md)
- **Plugins:** [`PLUGINS_SETUP.md`](./PLUGINS_SETUP.md)
- **21st.dev:** https://21st.dev/magic
- **Chrome Extension:** https://chromewebstore.google.com/detail/claude

---

**Version:** 2.8.0
