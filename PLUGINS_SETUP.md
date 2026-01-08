# Claude Code Plugins Setup

Integration of official Anthropic plugins with 2111framework.

## Quick Setup

Run in Claude Code terminal:

```bash
# 1. Add official Anthropic marketplace
/plugin marketplace add anthropics/claude-code

# 2. Install key plugins
/plugin install frontend-design
/plugin install skill-creator

# 3. Verify installation
/plugin
```

## Recommended Plugins

### Required

| Plugin | What It Does | Why Needed |
|--------|-------------|------------|
| `frontend-design` | Distinctive UI instead of generic | Your products are user-facing |
| `skill-creator` | Create custom skills | For framework customization |

### Optional

| Plugin | What It Does |
|--------|-------------|
| `ralph-wiggum` | Autonomous loops - run tasks for hours |
| `pr-review` | Automatic code review |
| `feature-dev` | Structured feature development |

## frontend-design Plugin

### Problem It Solves

**Problem:** Claude without instructions creates "AI slop":
- Inter/Roboto fonts
- Purple gradients
- Boring standard layouts

**Solution:** Skill automatically activates and makes Claude:
1. Choose BOLD aesthetic direction
2. Use unique fonts
3. Create memorable design
4. Write production-ready code

### How to Use

**Automatically** — just ask to create UI:

```
Create a dashboard for restaurant analytics.
Dark theme, mobile-first.
```

Claude will automatically apply frontend-design skill.

**Explicitly** — if you want to ensure:

```
Use the frontend design skill.
Create a settings page for Telegram Mini App.
```

### Example Prompts

```
# For Ave AI
Create an analytics dashboard for restaurant sales.
Show daily revenue chart, top products, inventory alerts.
Dark theme, modern aesthetic, mobile-first.

# For NotaApp
Design an invoice review screen for Telegram Mini App.
Show photo preview, extracted data form, submit button.
Clean, professional, touch-friendly.

# For FIGHTSTARS
Build a player profile card component.
Show avatar, stats, achievements, ranking.
Gaming aesthetic, bold colors, micro-animations.
```

## ralph-wiggum Plugin

### What It Does

Run Claude Code autonomously for hours without supervision. Claude works in a loop until task is complete.

### Installation

```bash
/plugin install ralph-wiggum@claude-plugins-official
```

### Basic Usage

```bash
# Simple task
/ralph-loop "Run npm run lint, fix all errors" --max-iterations 10

# With completion condition
/ralph-loop "Run npm test, make all tests pass" \
  --completion-promise "All tests passed" \
  --max-iterations 20
```

### When to Use

| Use Ralph | Use Manual |
|-----------|------------|
| Clear success criteria | Need decisions each step |
| Mechanical tasks (CRUD, lint) | Creative work (design) |
| Overnight tasks | Critical code (payments) |
| High volume work | Unclear requirements |

### Example Tasks

```bash
# Generate CRUD for restaurant platform
/ralph-loop "
Generate CRUD API for: Restaurants, MenuItems, Orders
Use NestJS + Prisma. Include validation, tests.
Run: npm run build && npm test
" --completion-promise "All tests passed" --max-iterations 30

# Fix all TypeScript errors
/ralph-loop "Run npx tsc --noEmit, fix all errors" \
  --completion-promise "Successfully compiled" --max-iterations 20
```

See full guide: `~/.claude/skills/mcp-usage/ralph-wiggum.md`

---

## Integration with 2111framework

### Structure After Installation

```
Claude Code
├── /plugins (built-in)
│   ├── frontend-design    ← UI quality
│   └── skill-creator      ← creating skills
│
└── ~/.claude/ (your framework)
    ├── agents/            ← workflow agents
    ├── skills/            ← technical references
    └── projects/          ← project contexts
```

### When to Use What

| Task | What Claude Uses |
|------|------------------|
| Create UI component | `frontend-design` plugin (auto) |
| Syrve integration | `~/.claude/skills/integrations/syrve-api.md` |
| Feature planning | `~/.claude/agents/architect.md` |
| Project context | `~/.claude/projects/ave-ai.md` |

### Example Full Workflow

```bash
# 1. Load project context
"Read ~/.claude/projects/ave-ai.md"

# 2. Plan feature (architect agent)
"Read ~/.claude/agents/architect.md
 Plan adding a daily sales chart"

# 3. Implement UI (frontend-design plugin activates automatically)
"Implement Phase 1: create SalesChart component"

# 4. Data integration (skill)
"Read ~/.claude/skills/integrations/syrve-api.md
 Connect real data from Syrve"
```

## Claude Code /agents Configuration

Add base context to Claude Code:

```bash
# In Claude Code
/agents
```

Create agent with your stack:

```markdown
# Denis Development Agent

## Stack
- Next.js 14+ App Router
- TypeScript strict
- NeonDB + Drizzle
- shadcn/ui + Tailwind
- Vercel deployment
- Telegram Mini Apps

## Style
- Step-by-step with checkpoints
- Brief explanations
- Mobile-first (80% users)
- Code > talk

## Auto-load skills from
~/.claude/skills/

## Projects
- Ave AI: restaurant analytics
- NotaApp: invoice OCR
- FIGHTSTARS: gaming app
```

## Synchronization

### Plugins (Anthropic)
- Update automatically
- Managed by Anthropic
- Not editable

### Framework (yours)
- Full control
- Edit as you like
- Store in GitHub

## Installation Checklist

- [ ] `/plugin marketplace add anthropics/claude-code`
- [ ] `/plugin install frontend-design`
- [ ] `/plugin install skill-creator`
- [ ] `/plugin install ralph-wiggum` (autonomous loops)
- [ ] Configure `/agents` with base context
- [ ] Clone 2111framework: `git clone https://github.com/Enthusiasm-c/2111framework.git`
- [ ] Run `./install.sh`
- [ ] Create `~/.claude/projects/` with project contexts

## Troubleshooting

### Plugin Not Activating
```bash
# Check installation
/plugin

# Reinstall
/plugin uninstall frontend-design
/plugin install frontend-design
```

### Skill Not Applied to UI
Add explicitly in prompt:
```
Use the frontend design skill.
[your request]
```

### Conflict with MD Skills
Plugins and MD skills work together. Plugins for general (UI quality), MD skills for specific (Syrve API).
