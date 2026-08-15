---
name: design-stack
description: Routing guide for the four design/motion skill sets installed globally — Anthropic frontend-design (plugin), Leonxlnx taste-skill, emilkowalski/skills (design engineering + animations), pbakaus/impeccable (23 design commands + detector hooks). Says which one to use for landing pages vs product UI vs motion vs audits, how to install/update them, and per-project defaults.
---

# Design Stack (v2.21)

Four third-party design layers now sit on top of the framework. They overlap on purpose — each wins a different job. **Do not load all of them on one task**; pick by the table below.

> Verified 2026-08-15. Star counts and versions drift — re-check with `gh api repos/<owner>/<repo> --jq .stargazers_count` before quoting them.

| Layer | Source | Stars | Install path | What it is |
|-------|--------|-------|--------------|-----------|
| **frontend-design** | Anthropic plugin (`claude-code-plugins`) | — | `/plugin install frontend-design` | Baseline anti-slop skill, auto-activates on any UI work. Already installed (see `PROJECT_MEMORY.md` A/B result). |
| **taste-skill** | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | ~76k | `~/.claude/skills/design-taste-frontend`, `redesign-existing-projects` (via `npx skills`) | Anti-slop for **landing pages, portfolios, redesigns**. Reads the brief, sets 3 dials (`DESIGN_VARIANCE` / `MOTION_INTENSITY` / `VISUAL_DENSITY`), strict pre-flight. **v2 experimental**, 87 KB SKILL.md (~22k tokens on invoke). |
| **emilkowalski/skills** | [emilkowalski/skills](https://github.com/emilkowalski/skills) | ~29k | 10 skills in `~/.claude/skills/` (via `npx skills`) | "Skills for Designers and Engineers" — Emil Kowalski (Vercel/Linear, animations.dev). Motion decisions, easing/duration, Apple-style physics, library picks, Sonner. |
| **impeccable** | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | ~59k | plugin `impeccable@impeccable` (marketplace `pbakaus/impeccable`) | 1 skill + **23 commands** (`/impeccable audit|polish|critique|animate|overdrive|…`), 4 agents, 59 deterministic detector rules via PostToolUse/Stop hooks (~527 tok always-on). |

Also installed for the iOS project: `app-store-review` — see `skills/workflow/app-store-release.md`.

---

## Which one when

| Situation | Use | Why |
|-----------|-----|-----|
| New **landing page / marketing site / portfolio** | `design-taste-frontend` (auto) — declare the "Design Read" line, then build | Its whole rulebook is tuned for landing/portfolio; it explicitly says *not* dashboards or multi-step product UI |
| Existing site "looks like AI slop", make it premium | `redesign-existing-projects` (taste) **or** `/impeccable polish` / `/impeccable bolder` | Both audit-first; taste = broad restyle, impeccable = surgical, command-scoped |
| **Product UI** — dashboard, settings, Telegram Mini App screens, forms | `frontend-design` (auto) + `/impeccable init` once per project (product lane), then `/impeccable audit|critique|harden` | impeccable's `init` writes `PRODUCT.md`/`DESIGN.md` so later commands know audience/brand; taste v2 is the wrong tool here |
| **Add motion** to a component / transition / sheet / drag | `animate` (emil) — decides *whether*, purpose, tool, properties, curve, duration, interrupt, exit | Domain expert on easing/springs; beats `/impeccable animate` for anything non-trivial |
| "What could be animated here?" | `find-animation-opportunities` (emil) — read-only proposal | Also lists what **not** to animate |
| Audit / roadmap of all animations in a codebase | `improve-animations` (emil) — prioritized plans another agent can execute | Read-only planner; pair with `dev` agent to apply |
| Review a motion diff strictly | `review-animations` (emil) | "Default to flagging; approval is earned" — plug into `/review` for UI PRs |
| Gesture-driven / iOS-feel web UI (sheets, rubber-band, momentum) | `apple-design` (emil) | WWDC principles translated for web — also the right vocabulary for the native SwiftUI app |
| Need a toast/command menu/OTP/chart/DnD lib | `pick-ui-library` (emil) — explicit invoke only | Curated list; stops hand-rolled toasts and abandoned packages. shadcn's toast **is** Sonner → `ask-sonner` for setup/bugs |
| Compare 3–4 variants of one UI piece live | `prototype` (emil) — explicit invoke only | Renders variants behind a switcher |
| Describe a motion you can't name | `animation-vocabulary` (emil) | Turns "the bouncy popover thing" into the exact term for the next prompt |
| Design QA before shipping a UI PR | `/impeccable audit` (a11y/perf/responsive) + `/impeccable harden` (errors, i18n, overflow) | Deterministic detector rules + LLM critique; the hooks already flag anti-patterns after each Edit/Write |
| Bland → bolder, loud → quieter, add "wow" | `/impeccable bolder|quieter|delight|overdrive` | Named dials instead of vague prompts |

**Rule of thumb:** taste = *landing pages*, impeccable = *product UI + audits*, emil = *motion + design-engineering decisions*, frontend-design = *always-on baseline*. If two fire on the same task, state which one leads in the "Design Read" line and ignore the other's conflicting rules.

---

## Per-project defaults

| Project | Surface | Lead skill | Notes |
|---------|---------|-----------|-------|
| **FIGHTSTARS** (gaming, neon, celebratory wins) | Product UI, Telegram | `frontend-design` + `animate` / `find-animation-opportunities` | Motion budget high; run `review-animations` on every UI PR; `prefers-reduced-motion` non-negotiable |
| **NotaApp** (invoice OCR, field use, non-technical) | Product UI, mobile-only Mini App | `frontend-design` + `/impeccable harden` + `/impeccable clarify` | Large touch targets, error states, empty states beat visual flair; `MOTION_INTENSITY` ≤ 3 |
| **Ave AI** (restaurant analytics) | Dashboards, dark, dense | `frontend-design` + `/impeccable audit` | Density is a feature; taste-skill's anti-card rules do not apply to data tables — skip it |
| **Tutorino / asana-coach** (native SwiftUI) | iOS app | `apple-design` (vocabulary) + `swiftui-*` skills (see app-store-release) | Web skills don't apply directly; use them for principles, not code |
| Marketing / landing pages for any product | Marketing | `design-taste-frontend` → `/impeccable critique` at the end | Declare the Design Read + dials before code |

---

## Install / update (already done on Denis's machine 2026-08-15)

```bash
# Reproducible installer (idempotent) — same commands the framework used
bash ~/2111framework/scripts/install-external-skills.sh

# Manually:
export SKILLS_NO_TELEMETRY=1
npx skills@latest add emilkowalski/skills -a claude-code -g --skill '*' -y
npx skills@latest add https://github.com/Leonxlnx/taste-skill -a claude-code -g \
  --skill design-taste-frontend --skill redesign-existing-projects -y
claude plugin marketplace add pbakaus/impeccable
claude plugin install impeccable@impeccable

# Update later
npx skills update -g -y            # taste + emil + app-store-review
claude plugin marketplace update impeccable && claude plugin install impeccable@impeccable
```

Not installed on purpose (install per-project if the direction is fixed): taste variants `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `gpt-taste`, `image-to-code`, `imagegen-*`, `brandkit`; taste v1 (`design-taste-frontend-v1`) if v2 misbehaves.

## Cost & hygiene

- Every global skill adds its description to **every** session's system prompt: 13 new skills ≈ 1.5–2k tokens; impeccable ≈ 527 tok always-on (`claude plugin details impeccable@impeccable`).
- impeccable hooks run `node …/hook.mjs` after each Edit/Write (5 s cap) and on Stop (30 s cap). They exit 0 always and stay silent on non-UI files. If they get noisy in backend-only repos: `claude plugin disable impeccable@impeccable` (re-enable per project when needed).
- Skills run with full agent permissions — they are prompts, not sandboxes. Re-read `SKILL.md` after `npx skills update` if behaviour changes. Scan with `skillspector scan ~/.claude/skills --recursive --no-llm` after every update (baseline + how to read the scores: `PLUGINS_SETUP.md` → "Scan before you install").
- **impeccable can spend money:** `/impeccable craft` / `visualize` flows may generate comps with `scripts/generate-image.mjs`, which calls **`api.openai.com` (gpt-image-2) with your `OPENAI_API_KEY`** — the only external egress in the plugin (SkillSpector-verified 2026-08-15). It prefers the harness's native image tool when available; if you never want paid image generation from a skill, unset `OPENAI_API_KEY` for those sessions or decline the "generate comps" step. `/impeccable live` spawns a local `claude` subprocess (forwards `CLAUDE_CODE_OAUTH_TOKEN`) — local, not egress.
- `frontend-design` and taste-skill overlap on greenfield marketing UI. Current decision: keep both; taste leads on landing pages, frontend-design everywhere else. Re-A/B when taste v2 goes stable and record the result in `PROJECT_MEMORY.md`.
