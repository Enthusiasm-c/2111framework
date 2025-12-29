# 🚀 2111framework v2.1

**Denis's Claude Code Development Framework**

**Repository:** https://github.com/Enthusiasm-c/2111framework
**Version:** 2.1.0
**Updated:** December 29, 2024

---

## 📦 MCP Servers

### Core Stack:

1. **Context7** - Up-to-date library docs
2. **shadcn** - UI components
3. **21st.dev Magic** - AI UI generation
4. **GitHub** - Issues, PRs, CI/CD ⭐ NEW

### Built-in:

5. **Claude Chrome Extension** - Browser automation

---

## 🎯 Quick Start

```bash
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

## 🆕 What's New in v2.1

### Added:
- ✅ **GitHub MCP** - Issues, PRs, CI/CD from terminal
- ✅ **Database Migrations skill** - Safe schema changes with Drizzle
- ✅ **Monitoring skill** - Sentry error tracking patterns
- ✅ **Telegram Mini App testing** - Extended QA Agent
- ✅ **Advanced Telegram patterns** - CloudStorage, Auth, Haptic
- ✅ **Extended Docs Agent** - ADR, Runbooks, Mermaid diagrams

### v2.0 (Previous):
- 21st.dev Magic MCP - AI UI generation
- Claude Chrome Extension - Browser automation

### Migration:
See [`MIGRATION_V2.md`](./MIGRATION_V2.md)

---

## 🔧 MCP Servers

### Context7 ⭐⭐⭐⭐⭐
Latest documentation for libraries

```bash
"Using Context7, show Next.js 14 syntax"
```

### shadcn ⭐⭐⭐⭐⭐
Generate UI components

```bash
"Add shadcn data table"
```

### 21st.dev Magic ⭐⭐⭐⭐⭐ NEW!
AI UI component generation

```bash
"Generate a modern login form with social auth buttons"
"Create a pricing table with 3 tiers"
```

**Setup:** Get API key from https://21st.dev/magic

### GitHub MCP ⭐⭐⭐⭐⭐ NEW!
Issues, PRs, CI/CD from terminal

```bash
# Install
claude mcp add github npx -y @modelcontextprotocol/server-github

# Usage
"Create issue: OCR accuracy drops on blurry photos"
"Show open PRs in Enthusiasm-c/notaapp"
"Check CI status for latest commit"
```

### Claude Chrome Extension ⭐⭐⭐⭐⭐
Browser testing & automation

```bash
claude --chrome
"Open localhost:3000 and test login"
```

---

## 📂 New Skills in v2.1

| Skill | Path | Description |
|-------|------|-------------|
| Database Migrations | `skills/tech-stack/database-migrations.md` | Drizzle ORM workflow |
| Monitoring | `skills/integrations/monitoring-sentry.md` | Sentry + logging |
| GitHub MCP | `skills/mcp-usage/github-mcp-guide.md` | GitHub from terminal |
| Telegram Advanced | `skills/integrations/telegram-bot-patterns.md` | CloudStorage, Auth |

## 👥 Extended Agents

| Agent | What's New |
|-------|-----------|
| QA | Telegram Mini App testing, pre-release checklist |
| Docs | Troubleshooting, ADR, Runbooks, Mermaid diagrams |

---

## 📚 Resources

- **GitHub:** https://github.com/Enthusiasm-c/2111framework
- **21st.dev:** https://21st.dev/magic
- **Chrome Extension:** https://code.claude.com/docs/en/chrome

---

**Built with ❤️ by Denis**
**Version:** 2.1.0
