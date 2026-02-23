---
name: tech-stack
description: Current tech stack versions and patterns. All agents reference this file — update here to keep everything in sync.
alwaysApply: false
---

# Tech Stack Reference

> **Last verified:** 2026-02-23
> Update this file when upgrading dependencies. All agents read it automatically.

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
| Codex | gpt-5.3-codex | `codex exec -m gpt-5.3-codex -c model_reasoning_effort=\"high\" -s read-only` |
| Gemini | gemini-3.1-pro-preview | `gemini -m gemini-3.1-pro-preview -p` |

### Routing

| Problem type | Agent |
|-------------|-------|
| UI, layout, CSS, visual | **Gemini** |
| Logic, async, TypeScript, bugs | **Codex** |
| Security, auth, OWASP | **Codex** |
| Architecture | **Gemini** |
| Unknown / need validation | **Both** |
