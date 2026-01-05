# 2111framework v2.5

**Denis's Claude Code Development Framework**

**Repository:** https://github.com/Enthusiasm-c/2111framework
**Version:** 2.5.0
**Updated:** January 5, 2025

---

## Quick Start

```bash
# Clone framework
git clone https://github.com/Enthusiasm-c/2111framework.git ~/.claude/2111framework

# Install MCP servers
claude mcp add context7 npx @context7/mcp-server
claude mcp add shadcn npx @modelcontextprotocol/server-shadcn
claude mcp add 21st-magic npx -y @21st-dev/magic@latest

# Install Chrome Extension
# https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn

# Enable Chrome
claude --chrome
```

---

## What's New in v2.5

### Added:
- **Syrve Cloud API extended** (3 new files, 1100+ lines)
  - `syrve-table-orders.md` - QR menu, in-restaurant ordering
  - `syrve-reports.md` - OLAP analytics, sales dashboards
  - `syrve-marketing.md` - Loyalty, discounts, coupons

### v2.4:
- **Syrve Cloud API skills suite** (5 files, 1400+ lines)
  - `syrve-api.md`, `syrve-delivery.md`, `syrve-menu.md`
  - `syrve-customers.md`, `syrve-webhooks.md`

### v2.3:
- Code Reviewer & Simplifier agent
- Architect agent extended (309 lines)

### v2.2:
- Chrome Extension guide
- YAML frontmatter to all skills
- All docs in English
- Playwright removed

### v2.1:
- GitHub MCP guide
- Database Migrations skill
- Monitoring skill (Sentry)
- Extended QA & Docs agents

---

## MCP Servers

| Server | Purpose | Command |
|--------|---------|---------|
| Context7 | Library documentation | `claude mcp add context7 npx @context7/mcp-server` |
| shadcn | UI components | `claude mcp add shadcn npx @modelcontextprotocol/server-shadcn` |
| 21st.dev Magic | AI UI generation | `claude mcp add 21st-magic npx -y @21st-dev/magic@latest` |
| Chrome Extension | Browser testing | Built-in, install from Chrome Web Store |

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
| `chrome-extension-guide.md` | Browser automation for frontend testing |
| `github-mcp-guide.md` | Issues, PRs, CI/CD from terminal |
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

### Architecture Planning
```
Read agents/architect.md
Plan a Syrve product sync feature for Ave AI
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

### UI Generation
```
Using 21st.dev Magic, create a restaurant dashboard with sales charts
```

---

## Resources

- **CHANGELOG:** [`CHANGELOG.md`](./CHANGELOG.md)
- **Migration:** [`MIGRATION_V2.md`](./MIGRATION_V2.md)
- **Plugins:** [`PLUGINS_SETUP.md`](./PLUGINS_SETUP.md)
- **21st.dev:** https://21st.dev/magic
- **Chrome Extension:** https://chromewebstore.google.com/detail/claude

---

**Version:** 2.5.0
