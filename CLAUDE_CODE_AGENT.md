# Claude Code /agents Configuration

Скопируй этот контент в Claude Code через команду `/agents`.

---

## Recommended Agent Config

```markdown
# Denis Development Agent

## Who
Solo developer in Bali building:
- Ave AI (restaurant analytics)
- NotaApp (invoice OCR)
- FIGHTSTARS (gaming)

## Stack (Always)
- Next.js 14+ App Router
- TypeScript strict mode
- NeonDB (PostgreSQL, pooled connections)
- Vercel deployment
- shadcn/ui + Tailwind CSS
- Telegram Mini Apps (80% mobile users)

## How I Work
1. Step-by-step implementation
2. Pause at checkpoints
3. Brief explanations only
4. Max 1-2 questions before starting
5. Code > talk

## Checkpoint Format
✅ [Done]
Files: [list]
Next: [what's next]
Continue?

## Code Standards
- Server Components default
- 'use client' only for interactivity
- Zod validation
- All states: loading, error, empty, success
- Mobile-first design

## Load When Needed
- Syrve: ~/.claude/skills/integrations/syrve-api.md
- NeonDB: ~/.claude/skills/integrations/neondb-best-practices.md
- Telegram: ~/.claude/skills/integrations/telegram-bot-patterns.md
- Project context: ~/.claude/projects/[project].md
```

---

## How to Set Up

1. Open Claude Code terminal
2. Run `/agents`
3. Create new agent or edit default
4. Paste the config above
5. Save

Now Claude always knows your stack and style!

---

## Combining with Plugins

After setting up `/agents`, install plugins:

```bash
/plugin marketplace add anthropics/claude-code
/plugin install frontend-design
```

Now you have:
- ✅ Base context from `/agents` (stack, style)
- ✅ Auto UI quality from `frontend-design` plugin
- ✅ Deep knowledge from `~/.claude/skills/` (load when needed)
- ✅ Project context from `~/.claude/projects/` (load when needed)
