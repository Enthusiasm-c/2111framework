---
name: optimize
description: Scoped performance refactoring of an existing page/folder against the Vercel react-best-practices skill — audit, report by priority, apply only high-impact fixes, then measure bundle and behavior before/after. Use when asked to optimize, speed up, or refactor for performance.
---

# /optimize — performance refactoring loop

Refactor existing code for performance **safely and measurably**. Never "optimize everything" — scope to one page/folder, prove the win, move on.

**Prerequisite:** the official Vercel skill must be installed (`npx skills add vercel-labs/agent-skills --skill react-best-practices`). It carries the 70 rules this command audits against.

## Inputs

`/optimize <path>` — e.g. `/optimize app/(tg)/menu`. If no path given, ask which page/folder; refuse to run on the whole repo at once (too costly, invites over-refactoring).

## Workflow (do not skip steps)

### 1. Branch
```bash
git checkout -b perf/<area>
```
Performance refactors (Suspense, dynamic imports, fetch restructuring) can introduce regressions — isolate them.

### 2. Measure BEFORE
```bash
npm run build      # record First Load JS for the affected route(s)
```
Note the route bundle size. If a Lighthouse path exists (Chrome DevTools MCP / Playwright), record LCP/TBT too.

### 3. Audit — report only, NO code changes yet
Read the files under `<path>` and audit against the react-best-practices rules. Produce a table, **highest impact first**:

| Rule | File:line | Problem | Fix | Impact |
|------|-----------|---------|-----|--------|

Priorities, per the skill: CRITICAL = `async-*` (waterfalls) + `bundle-*` (bundle size); HIGH = `server-*`; then `rerender-*`, `rendering-*`, `js-*`. Stop and show the user the list. Do not touch code.

### 4. Apply — high-impact only
Apply **only CRITICAL and HIGH** findings unless the user asks for more. Skip micro-optimizations (`js-*`, most `rerender-*`) unless they're cheap and obviously right. Honor the anti-over-engineering rule: smallest change that captures the win.

After **each** fix:
```bash
npm run test:run   # or the project's test command
```
Don't batch ten changes then test once — change, test, repeat.

### 5. Measure AFTER + verify behavior
```bash
npm run build      # compare First Load JS to step 2 — show the delta
```
Then **open the page** (`/verify` or `/run`, or Chrome DevTools MCP) — tests don't catch visual/UX regressions from Suspense boundaries or `ssr:false`. Confirm it still looks and behaves the same.

### 6. Report
Show: before/after bundle delta, which rules were applied, what was skipped and why. If a "fix" didn't move the bundle or broke behavior, revert it and say so — don't claim a win you didn't measure.

## Honesty rules
- State the measured before/after numbers, not estimates. Banned: "should be faster" without a build delta.
- If you couldn't run the build or open the page, say so — don't assert the optimization works.
- A perf change that can't be measured isn't done.

## Good first targets
- **menuai (Dishi):** the TG Mini App menu/order page — runs on mid-tier phones, max payoff from bundle + streaming.
- **notaapp:** invoice list / dashboard — many sequential external calls (OCR · Syrve · Xero), classic waterfalls.
