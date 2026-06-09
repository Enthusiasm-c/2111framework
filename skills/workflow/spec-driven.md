---
name: spec
description: Spec-driven development — turn a feature idea into a written spec, then a plan, then tasks, then implementation, instead of vibe-coding straight into code. Use for any non-trivial feature, especially on an existing codebase. Built on GitHub Spec Kit.
---

# /spec — Spec-Driven Development

The 2026 consensus for building with agents: **don't chat code into existence — write the contract first.** Flow:

```
Spec  →  Plan  →  Tasks  →  Implement
 │        │        │           │
 what    how    steps      execution
```

The spec is the cheapest place to be wrong — a wrong spec costs keystrokes, wrong code costs refactors. Keep it lean and living, not a waterfall document.

## Why it matters here

For a solo non-coder founder this is the highest-leverage habit: it forces clarity about how a new feature interacts with the existing system **before** the agent writes anything you can't review. It also makes agents interchangeable — the spec is the contract, any agent implements against it.

## The commands (GitHub Spec Kit)

Distributed in `commands/speckit.*` of this framework. They map to the flow:

| Command | Stage | Does |
|---------|-------|------|
| `/speckit.constitution` | (once per project) | Establish project principles the spec/plan must respect |
| `/speckit.specify` | Spec | Natural-language feature description → structured spec |
| `/speckit.clarify` | Spec | Interrogate ambiguities before planning |
| `/speckit.plan` | Plan | Spec → technical plan honoring architecture constraints |
| `/speckit.tasks` | Tasks | Plan → ordered, reviewable task list |
| `/speckit.analyze` | Tasks | Cross-check spec ↔ plan ↔ tasks for gaps |
| `/speckit.checklist` | Tasks | Acceptance checklist |
| `/speckit.implement` | Implement | Execute tasks against the spec |

## Install into a project

```bash
mkdir -p .claude/commands
cp ~/.claude/2111framework/commands/speckit.*.md .claude/commands/
```
Then in that project: `/speckit.specify add restaurant payout dashboard ...`

`notaapp` already has these. Run the copy above in `menuai` and new projects to standardize.

## When to use vs skip
- **Use** for new features, anything touching multiple files, or work on a complex existing codebase (forces the new code to feel native, not bolted-on).
- **Skip** for one-line fixes and mechanical edits — a spec there is overhead. (Anti-over-engineering applies.)

## Relation to other skills
- Pairs with the **Grill Me** philosophy: `/speckit.clarify` is the interrogation step.
- Hands off to `/optimize` and `/review` after `implement`.
- Implementation should still follow `tdd-workflow.md` (failing test first).
