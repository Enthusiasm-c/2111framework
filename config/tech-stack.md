---
name: tech-stack
description: Current tech stack versions and patterns. All agents reference this file — update here to keep everything in sync.
alwaysApply: false
---

# Tech Stack Reference

> **Last verified:** 2026-08-15
> Update this file when upgrading dependencies. All agents read it automatically.

## Claude Code Runtime

| Item | Value |
|------|-------|
| Primary model | **Claude Fable 5** (`claude-fable-5[1m]`) — Denis's `~/.claude/settings.json`; Mythos-class tier above Opus, $10/$50 per MTok |
| Claude Code default | **Claude Opus 5** (`claude-opus-5`) since Claude Code 2.1.219 (Jul 24, 2026) — same feature set as Opus 4.8 at $5/$25; drop-in for agents that don't need Fable |
| Fallback (`fallbackModel`) | `claude-opus-5` — used when the primary is overloaded (was `claude-sonnet-4-6`) |
| Sonnet tier | Claude Sonnet 5 (`claude-sonnet-5`) — for cheap subagents; Haiku 4.5 for trivial routing |
| Context window | 1M tokens (default and max on Fable 5 / Opus 5) |
| Thinking | Fable 5: **always on** (adaptive, cannot be disabled). Opus 5: on by default. No `ultrathink`, no `alwaysThinkingEnabled`, no `budget_tokens` |
| Effort | `xhigh` (Denis's `effortLevel`; also the Claude Code default). Ladder: `low` / `medium` / `high` / `xhigh` / `max` — `/effort <level>` in-session, `--effort <level>` on the CLI |
| Cost ceiling | `claude -p ... --max-budget-usd <amount>` — hard USD cap for headless/background runs (also stops subagent spawning at the cap). See `config/effort-profiles.md` |
| Fast mode | `/fast` — Opus 5 / Opus 4.8 only (~2.5× output speed, $10/$50). Not available on Fable 5 |
| Claude Code min version | 2.1.233+ (subagent forking by default, cross-session `@` messaging, background `/code-review`, plugin install from zip) |

Model IDs are exact strings — no date suffixes (`claude-opus-5`, never `claude-opus-5-2026…`). Retired/deprecated: Opus 4.1 (retired 2026-08-05), Sonnet 4 / Opus 4 (deprecated). Opus 4.8 / 4.7 / 4.6 and Sonnet 4.6 stay available but are one generation behind.

## Core Stack

| Technology | Version | Notes |
|-----------|---------|-------|
| Next.js | 16+ (LTS 16.1) | App Router, Turbopack default |
| React | 19 | `use()`, Actions, `useActionState`, `useOptimistic` |
| TypeScript | 5.x strict | Zod for runtime validation |
| Tailwind CSS | v4 | CSS-first config, `@import "tailwindcss"` |
| shadcn/ui | 3.8+ | Unified `radix-ui` package, Base UI support |
| NeonDB | Serverless PostgreSQL | Pooled connections |
| Drizzle ORM | Latest | SQL-like, serverless-first |
| Vercel | Deployment | Auto-deploy from main |

## Key Patterns (Next.js 16+ / React 19)

- Server Components by default, `'use client'` only for interactivity
- Server Actions for mutations (not API routes + fetch)
- `useActionState` instead of manual useState + fetch for forms
- `use()` for reading promises and context in render
- `useOptimistic` for optimistic UI updates
- Turbopack as default bundler (no webpack config needed)

## Tailwind v4

- `@import "tailwindcss"` instead of `@tailwind base/components/utilities`
- CSS theme variables instead of `tailwind.config.js`
- Zero-config for most projects

## shadcn/ui 3.8+

- Single `radix-ui` package (not individual `@radix-ui/react-*`)
- Base UI as alternative primitive library
- React 19 fully compatible

## External AI Models

| Tool | Model | Command |
|------|-------|---------|
| Codex | gpt-5.5 | `codex-ask` |
| Gemini | gemini-pro-latest | `gemini -m gemini-pro-latest -p` |

### Routing

| Problem type | Agent |
|-------------|-------|
| UI, layout, CSS, visual | **Gemini** |
| Logic, async, TypeScript, bugs | **Codex** |
| Security, auth, OWASP | **Codex** |
| Architecture | **Gemini** |
| Unknown / need validation | **Both** |
