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
| `pr-review` | Automatic code review |
| `feature-dev` | Structured feature development |
| `semgrep` | Static security analysis (SAST/secrets) |

## Third-Party Skills (v2.21)

Installed globally by `scripts/install-external-skills.sh` (idempotent — re-run to update). Full routing guide: `skills/design/design-stack.md`.

| Source | Stars (2026-08) | Installs as | Use for |
|--------|-----------------|-------------|---------|
| [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | ~76k | `~/.claude/skills/design-taste-frontend`, `redesign-existing-projects` | Landing pages, portfolios, redesigns — anti-slop with 3 dials (variance / motion / density) |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) | ~29k | 10 skills: `animate`, `review-animations`, `improve-animations`, `find-animation-opportunities`, `animation-vocabulary`, `apple-design`, `emil-design-eng`, `pick-ui-library`, `prototype`, `ask-sonner` | Motion decisions (easing, duration, springs), design-engineering polish, library picks |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | ~59k | plugin `impeccable@impeccable` (marketplace `pbakaus/impeccable`) | `/impeccable init|audit|critique|polish|harden|animate|bolder|quieter|overdrive|…` — 23 commands + detector hooks for product UI |
| [dpearson2699/swift-ios-skills](https://github.com/dpearson2699/swift-ios-skills) | ~1k | `~/.claude/skills/app-store-review` | iOS App Store submission audit — privacy manifest, usage strings, StoreKit, metadata; blockers vs cleanup. Workflow: `skills/workflow/app-store-release.md` |

```bash
bash ~/2111framework/scripts/install-external-skills.sh
# then, once per UI project:
/impeccable init
```

Cost: ~13 skill descriptions (~1.5–2k tokens) + impeccable ~527 tokens always-on per session. Disable impeccable in backend-only repos with `claude plugin disable impeccable@impeccable`.

Overlap note: `frontend-design` (Anthropic) stays the always-on baseline; taste-skill leads only on landing/marketing pages; impeccable leads on product UI + audits; emil leads on motion.

### Scan before you install — SkillSpector (v2.22)

Skills run with full agent permissions. [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) scans a repo/dir/zip for prompt injection, exfiltration, privilege escalation, MCP tool poisoning (69 patterns, 17 categories). Installed via `uv tool install "git+https://github.com/NVIDIA/skillspector.git"`; `install-external-skills.sh` runs it after every install (advisory).

```bash
# before installing anything new
skillspector scan https://github.com/<owner>/<repo> --no-llm
# everything already installed
skillspector scan ~/.claude/skills --recursive --no-llm
```

Read the score correctly: `--no-llm` is static heuristics — cheap, no API cost, **high false-positive rate on code-heavy skills**. Baseline from 2026-08-15: 10 of 15 global skills score 0; `improve-animations` (40, quotes "ignore previous instructions" as an example of what to refuse), `prototype` (21, "never judge UI at postage-stamp size"), `react-best-practices` (23, `dangerouslySetInnerHTML` in Vercel's own hydration example), `design-taste-frontend` (15, `npx shadcn@latest`) are all benign on inspection; **impeccable = 100 / CRITICAL** because it ships 40+ JS scripts — manual review found no hidden egress except the opt-in `generate-image.mjs` → `api.openai.com` (**paid** gpt-image-2 via `OPENAI_API_KEY`), and its hooks make no network calls. Rule: a HIGH finding is a reason to open the file, not a verdict. Reports live in `~/.claude/skillspector-reports/`.

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
- [ ] `/plugin install semgrep` (static security analysis)
- [ ] `uv tool install "git+https://github.com/NVIDIA/skillspector.git"` (skill security scanner)
- [ ] `bash scripts/install-external-skills.sh` (taste-skill, emilkowalski/skills, impeccable, app-store-review + SkillSpector scan)
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
