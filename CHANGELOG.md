# Changelog

## [2.22.0] - 2026-08-15

### Model & Runtime → Claude 5
- `config/settings.json`: `model` `opus` → **`claude-fable-5[1m]`** (Denis's live setting — `install.sh` merges `model` into `~/.claude/settings.json`, so the old value silently downgraded the session to Opus on every reinstall); `fallbackModel` `claude-sonnet-4-6` → **`claude-opus-5`**
- `config/tech-stack.md` — Claude Code Runtime block rewritten: Fable 5 primary, Opus 5 as Claude Code default (2.1.219, Jul 24 2026) and agent model (`model: opus`), Sonnet 5 for cheap subagents, effort ladder incl. `xhigh` default, fast mode = Opus 5/4.8 only, min Claude Code 2.1.233+, exact model IDs (no date suffixes)
- `config/effort-profiles.md` — 5-level ladder, `xhigh` default, Claude 5 thinking notes, `MAX_THINKING_TOKENS` deprecated on Fable 5, Agent Teams cost split updated
- `agents/{architect,developer,qa,security,review}.md` — Opus 4.8 wording → Claude 5 (Opus 5 via `model: opus`, Fable 5 in the main session); `developer` gets a scope-discipline line (Opus 5 expands scope on its own); `security` gets the refusal-fallback note; `review` notes literal severity filtering → report-everything-then-score
- README: version, requirements, model comparison table

### New: `--max-budget-usd`
- `config/effort-profiles.md` § "Hard cost ceiling" — `claude -p "…" --max-budget-usd <amount>` for every unattended run (`--print` only; also stops subagent spawning at the cap); rule of thumb $3–10 to start, raise after `/cost`

### Hooks — framework now mirrors the live global config
- `config/hooks/uncommitted-reminder.sh` (upstreamed from `~/.claude/hooks/`, Aug 13): Stop reminder fires once per distinct dirty state and never inside a stop-hook continuation loop; `config/settings.json` Stop hook now calls `bash ~/.claude/hooks/uncommitted-reminder.sh` instead of the inline one-liner
- `install.sh` step 3b — symlinks `config/hooks/*.sh` into `~/.claude/hooks/` (backs up non-symlink files), so hook scripts propagate with `git pull` like agents/skills

### New: SkillSpector (skill security scanner)
- Installed `NVIDIA/SkillSpector` v2.9.4 via `uv tool install git+https://github.com/NVIDIA/skillspector.git`
- Static scan (`--no-llm`, free) of all 15 global skills + impeccable plugin, reports in `~/.claude/skillspector-reports/`. Verdict after manual inspection of every HIGH: no malicious skill; false positives on quoted "ignore previous instructions" (improve-animations), "never judge…" (prototype), `npx …@latest` and `dangerouslySetInnerHTML` code examples (taste, react-best-practices). impeccable = CRITICAL by static score (40+ JS scripts) but the only external egress is opt-in `generate-image.mjs` → `api.openai.com` (paid gpt-image-2 via `OPENAI_API_KEY`); PostToolUse/Stop hooks make no network calls
- `scripts/install-external-skills.sh` — post-install SkillSpector scan (advisory; skips if `skillspector` missing); `PLUGINS_SETUP.md` § "Scan before you install"

## [2.21.0] - 2026-08-15

### New: Design stack (external skills)
- Installed globally and documented three design/motion skill sets (verified stars 2026-08-15):
  - **Leonxlnx/taste-skill** (~76k★) — `design-taste-frontend` (v2 experimental, 3 dials) + `redesign-existing-projects` via `npx skills add … -g -a claude-code`
  - **emilkowalski/skills** (~29k★, "Skills for Designers and Engineers") — all 10 skills: `animate`, `review-animations`, `improve-animations`, `find-animation-opportunities`, `animation-vocabulary`, `apple-design`, `emil-design-eng`, `pick-ui-library`, `prototype`, `ask-sonner`
  - **pbakaus/impeccable** (~59k★) — installed as **plugin** `impeccable@impeccable` (marketplace `pbakaus/impeccable`) rather than `npx impeccable install`, so its PostToolUse/Stop detector hooks live inside the plugin (`${CLAUDE_PLUGIN_ROOT}`) and are toggled with `claude plugin disable`, never merged into `settings.json` hooks that `install.sh` overwrites. ~527 tok always-on (`claude plugin details`)
- `skills/design/design-stack.md` — routing guide (taste = landing pages, impeccable = product UI + audits, emil = motion, `frontend-design` = baseline), per-project defaults, cost/hygiene, update commands
- `PLUGINS_SETUP.md` — "Third-Party Skills" section + checklist item

### New: App Store release workflow
- `app-store-review` skill from **dpearson2699/swift-ios-skills** (~1k★, 86 iOS 26 skills) installed globally — submission-readiness audit (PrivacyInfo.xcprivacy / required-reason APIs, usage strings, ATT, StoreKit, metadata, entitlements), blockers vs cleanup
- `skills/workflow/app-store-release.md` — audit → fix blockers → `xcodebuild archive` + Organizer Validate → TestFlight → review → rejection handling; documents optional `rorkai/app-store-connect-cli-skills` (`asc`) and `safaiyeh/app-store-review-skill` without installing them; lists first-audit findings for Tutorino/asana-coach

### Installer
- `scripts/install-external-skills.sh` — idempotent installer for all of the above (`SKILLS_NO_TELEMETRY=1`, global scope, `claude-code` agent); `install.sh` prints a hint to run it
- Global skills now: 13 external `~/.claude/skills/*` dirs + `react-best-practices` (v2.20) alongside the symlinked framework categories

### Notes
- Overlap accepted on purpose: `frontend-design` plugin stays enabled as always-on baseline; taste-skill leads only on landing/marketing pages. Re-A/B when taste v2 goes stable.
- Skills CLI `--help` on a non-TTY runs the default action for `npx impeccable install` (it installed into the cwd project once during this release; reverted). Always pass `--scope`/`--providers` or use the plugin route.

## [2.20.1] - 2026-06-09

### Fixed
- `/optimize` and `/spec` shipped as flat files under `skills/workflow/` — a layout Claude Code does not load as invokable skills, so neither command ever appeared. Moved to `commands/optimize.md` and `commands/spec.md` (renamed from `spec-driven.md` so the slash name resolves to `/spec`).
- `install.sh` now symlinks `commands/*.md` into `~/.claude/commands/` (new section 2b). Previously framework commands — including `speckit.*` — were never installed globally, only per-project. `git pull` now auto-propagates command updates the same way it already does for agents and skills.

## [2.20.0] - 2026-06-09

### Model & Runtime
- Default model → **Claude Opus 4.8** (`claude-opus-4-8`); `high` effort default, `/effort xhigh` for hardest tasks, fast mode ~2.5×
- Updated `config/tech-stack.md`, `config/effort-profiles.md`, and all `agents/*.md` from Opus 4.7 → 4.8
- `config/settings.json` — added `fallbackModel` and a doc-hygiene startup hook (warns when project root accumulates >25 markdown files)
- Fixed `gpt-5.3` → `gpt-5.5` in README model comparison table
- Min Claude Code version 2.1.7 → 2.1.160

### New Skills
- `skills/workflow/optimize.md` (`/optimize`) — performance audit/refactor loop against the Vercel react-best-practices skill, with before/after measurement
- `skills/workflow/spec-driven.md` (`/spec`) + `commands/speckit.*` — Spec → Plan → Tasks → Implement (GitHub Spec Kit), distributable to projects
- `skills/code-quality/secret-rotation.md` — secret-leak triage and rotation checklist

### Changed
- `skills/tech-stack/react-optimization.md` — slimmed to project-specific patterns (Syrve/Telegram webhook parallelization) + pointer to the official Vercel `react-best-practices` skill; removed deprecated frontmatter fields

## [2.19.0] - 2026-04-17

### Model & Context
- **Default model → Claude Opus 4.7** with adaptive thinking and 1M token context
- Removed `alwaysThinkingEnabled: true` from `config/settings.json` — adaptive thinking in 4.7 makes it a no-op that wastes tokens
- Updated `config/tech-stack.md` with Claude Code runtime section (model, context window, thinking mode) and re-verified date
- Updated `config/effort-profiles.md` — deprecated `ultrathink` and `alwaysThinkingEnabled` notes

### Agent Rewrites for Opus 4.7
- `agents/architect.md` — new step 0 "Full Dependency Scan" (use 1M context to read whole feature area before planning), maxTurns 30 → 50, explicit Opus 4.7 workflow rules, plain-language trade-off output for non-coder founder
- `agents/developer.md` — replaced linear 5-checkpoint system with **Task DAG** pattern (via harness TaskCreate/TaskUpdate), Verification-Before-Done section, Opus 4.7 tips, removed obsolete linear checkpoint output block
- `agents/security.md` — Opus 4.7 workflow (split by attack surface, not by file), 1M context note, adversarial exploit-construction step before reporting Critical findings
- `agents/qa.md` — Opus 4.7 workflow, reads full feature + tests + git diff in one pass, failing-test-first handoff to dev agent, Chrome Extension retained (working again)
- `agents/review.md` — updated extended analysis note for 4.7 self-correction + 1M context (one pass covers whole module)

### Ralph Wiggum Removed
- Deleted `skills/mcp-usage/ralph-wiggum.md`
- Cleaned references in: `README.md`, `PLUGINS_SETUP.md`, `skills/mcp-usage/agent-teams.md`, `skills/mcp-usage/background-tasks.md`, `skills/business/consilium.md`, `config/effort-profiles.md`, `agents/review.md`
- Superseded by Agent Teams with worktree isolation and `run_in_background: true`

### Hooks — Noise Reduction
- Removed `Notification` hook (macOS "Claude is waiting for input" osascript)
- Removed `SubagentStop` hook (macOS "A subagent has completed" osascript)
- Hook count: 15 → 13
- Updated `skills/workflow/hooks-catalog.md` table and added deprecation note

### Plugins
- `PLUGINS_SETUP.md` — added `semgrep` plugin recommendation (real SAST/secrets scan), removed ralph-wiggum from checklist

### New MCP Integrations (Phase 5)
- **Sentry MCP** (remote HTTP, `https://mcp.sentry.dev/mcp`) added to `mcp.json` — prod error stack traces, issue triage, alerts
- **Neon MCP** (remote HTTP, `https://mcp.neon.tech/mcp`) added to `mcp.json` — SQL queries, branching for risky migrations
- **Vercel plugin** documented (provides slash commands + agents, not an MCP server)
- 3 new skill guides: `skills/mcp-usage/sentry-mcp-guide.md`, `neon-mcp-guide.md`, `vercel-mcp-guide.md`
- `agents/security.md` — cross-reference findings with real Sentry exceptions (confidence boost +20)
- `agents/qa.md` — Pre-Release Checklist extended with Vercel `/status`, Sentry error-rate, Neon migration checks
- `agents/developer.md` — mandatory Neon branch-first workflow for destructive migrations (load-bearing for non-coder founder)

---

## [2.18.1] - 2026-03-26

### Added — Plugin-Inspired Improvements

Patterns extracted from superpowers, code-review, semgrep, and sentry plugins:

- **TDD Anti-Rationalization** (`skills/workflow/tdd-workflow.md`) — complete rewrite:
  - Iron Law: "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"
  - Anti-rationalization table: 8 specific excuses Claude generates, with pre-approved counters
  - Verification before completion: bans "should work now" without running tests
  - Escalation rule: if 3+ fixes fail, stop and question architecture

- **Review Agent Upgrade** (`agents/review.md`) — finding/scoring separation:
  - Phase 2 (Finding): cast wide net, report everything
  - Phase 3 (Scoring): confidence 0-100, threshold 80, drop everything below
  - False positive catalog: 8 explicit patterns to never report
  - Adversarial verification: assume your analysis is wrong before reporting
  - Verification before completion: must list what was checked

- **Security Context Injection Hook** — UserPromptSubmit hook (from semgrep pattern):
  - Injects 7 security rules on every prompt in projects with package.json
  - Covers: SQL injection, XSS, secrets, PII logging, Zod validation, auth checks, eval()
  - Keeps security awareness alive even after context drift

- **Playwright MCP** (`mcp.json`) — browser automation for E2E testing:
  - Replaces broken Chrome Extension
  - 59 MCP tools: navigate, click, fill, screenshot, console, network, Lighthouse
  - serverInstructions for lazy loading

---

## [2.18.0] - 2026-03-26

### Added
- **Native Memory Integration** — hybrid memory system combining Claude Code's built-in memory (`.claude/projects/*/memory/`) with framework hooks
  - Native memory handles user preferences, feedback corrections, external references
  - PROJECT_MEMORY.md handles architecture decisions, resolved bugs, API limitations
  - Clear separation: "what goes where" guide in auto-memory.md
  - Compact hook now also re-injects TODO.md alongside PROJECT_MEMORY.md

- **New Hook Types Documentation** — `skills/workflow/hooks-catalog.md` expanded with 4 hook types:
  - `type: "prompt"` — Claude model evaluates hooks (semantic validation, cheaper than agent)
  - `type: "agent"` — subagent with tool access for deep verification (e.g., auto-test after edit)
  - `type: "http"` — POST JSON to URLs (Slack/Telegram notifications, remote validation, audit logging)
  - Practical examples for each type including Telegram notification and smart safety check

- **Parallel Security Audit** pattern in `agents/security.md` — spawn named subagents for auth, input, and data audits
- **Parallel Execution** section in `agents/developer.md` — worktree isolation for parallel dev agents

- **3 New Safety Hooks** — expanded from 12 to 15 hooks in `config/settings.json`:
  - **TypeScript checker** (PostToolUse) — runs `tsc --noEmit` async after `.ts/.tsx` edits, reports type errors immediately
  - **Test coverage checker** (PostToolUse) — warns when edited file has no corresponding test file (checks co-located, __tests__/, spec patterns)
  - **PROJECT_MEMORY size auditor** (UserPromptSubmit) — warns when PROJECT_MEMORY.md exceeds 50KB, suggests archiving

- **Browser Testing Guide** (`skills/mcp-usage/browser-testing-guide.md`) — Chrome DevTools MCP as replacement for broken Chrome Extension
  - Setup instructions for Chrome DevTools MCP
  - Common workflows: responsive testing, form testing, API debugging, Lighthouse audits
  - Telegram Mini App testing strategies
  - Decision table: when to use DevTools MCP vs Chrome Extension

### Changed
- **Agent Teams — Stable** (`skills/mcp-usage/agent-teams.md`) — complete rewrite:
  - Removed `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true` flag (no longer needed)
  - Added `isolation: "worktree"` documentation — each agent gets isolated git worktree
  - Added `run_in_background: true` — non-blocking parallel execution
  - Added `SendMessage` — communicate with named running agents
  - Added `subagent_type` — typed agent specialization
  - New patterns: parallel feature dev with worktree merge, research fan-out
  - Worktree merge workflow documentation

- **Review Agent** (`agents/review.md`) — updated Agent Teams code review pattern to use Agent tool syntax with named agents and `run_in_background`

- **Security Agent** (`agents/security.md`) — replaced generic Agent Teams pattern with concrete parallel audit using named subagents

- **Compact Hook** (`config/settings.json`) — now re-injects TODO.md in addition to PROJECT_MEMORY.md and git context

- **Auto-Memory Skill** (`skills/workflow/auto-memory.md`) — rewritten for hybrid approach:
  - Documents native memory types (user, feedback, project, reference)
  - Clear "what goes where" decision table
  - Marked auto-memory.sh as legacy (superseded by native memory)
  - Migration guide from v2.17

- **README.md** — updated to v2.18.0 with all new features
- **Quick Start** — removed experimental Agent Teams flag

---

## [2.17.0] - 2026-02-20

### Added
- **12 Battle-Tested Hooks** (`config/settings.json`) — expanded from 2 to 12 hooks
  - **SessionStart/compact** — Re-injects PROJECT_MEMORY.md + git context after /compact (context persistence)
  - **SessionStart/startup** — Shows project, branch, git status on session start (once)
  - **PreToolUse/Edit|Write** — Blocks editing protected files (.env, lock files) with exit 2
  - **PreToolUse/Bash** — Blocks destructive commands (rm -rf /, reset --hard, push --force, DROP TABLE)
  - **PostToolUse/Edit|Write** — Auto-format with Prettier (async, non-blocking)
  - **Notification** — macOS desktop notification when Claude waits for input
  - **Stop/auto-memory** — Saves session info to ~/.claude/memory/sessions.md
  - **Stop/uncommitted** — Reminds about uncommitted changes when session ends
  - **UserPromptSubmit** — Injects .claude/TODO.md into context with every prompt
  - **SubagentStop** — Desktop notification when subagent completes
  - Existing hooks preserved: console.log detector (#5) and ESLint checker (#6)

- **Auto-Memory System** — Persistent memory across sessions and compact
  - `config/hooks/auto-memory.sh` — Stop hook script for session logging
  - `skills/workflow/auto-memory.md` — Documentation and best practices
  - Memory cycle: Stop saves → SessionStart reads → /compact re-injects
  - Auto-creates PROJECT_MEMORY.md template if missing

- **Hooks Catalog** (`skills/workflow/hooks-catalog.md`) — Complete reference
  - Table of all 12 hooks with event, matcher, sync/async
  - Exit code semantics (0 = ok, 2 = block)
  - Lifecycle events reference
  - Matcher syntax guide
  - Custom hook examples: TypeScript checker, test runner, security scanner

### Changed
- **install.sh** — Added hooks and memory directory creation, hook script installation
- **README.md** — Updated to v2.17.0 with hooks and auto-memory documentation

---

## [2.16.0] - 2026-02-20

### Added
- **Agent Auto-Routing** — All 6 agents now have `<example>` blocks in descriptions for proactive auto-triggering
  - Claude automatically suggests architect for complex features, review after implementation, security after auth changes, etc.
  - No more manual `/command` required — agents launch when context matches
- **Rules Templates** (`rules/`) — Path-scoped instruction templates using native Claude Code rules format
  - `rules/README.md` — How to create and use rules
  - `rules/examples/react-components.md` — React/TSX conventions (`globs: "**/*.tsx"`)
  - `rules/examples/api-routes.md` — API endpoint patterns (`globs: "**/api/**"`)
  - `rules/examples/database.md` — Database conventions (`globs: "**/db/**"`)
  - `rules/examples/testing.md` — Test conventions (`alwaysApply: true`)
  - `rules/examples/git-workflow.md` — Git commit/branch rules (`alwaysApply: true`)
- **Workflow Skills** (`skills/workflow/`) — New skill category
  - `tdd-workflow.md` — RED-GREEN-REFACTOR pattern for Next.js + Vitest
  - `context-engineering.md` — Context window management strategies
  - `systematic-debugging.md` — 4-phase debugging: REPRODUCE → ISOLATE → ROOT CAUSE → FIX
  - `init-rules.md` — Generate rules from PROJECT_MEMORY.md
- **Agent Routing Reference** (`config/agent-routing.md`) — Routing table and agent chain patterns

### Changed
- **agents/architect.md** — Added 3 auto-routing examples (complex features, refactoring, DB schema)
- **agents/review.md** — Added 3 auto-routing examples (after implementation, before commit, explicit review)
- **agents/developer.md** — Added 3 auto-routing examples (implementation task, implicit need, after plan)
- **agents/qa.md** — Added 3 auto-routing examples (bug report, before deploy, after dev)
- **agents/docs.md** — Added 2 auto-routing examples (documentation request, onboarding)
- **agents/security.md** — Added 3 auto-routing examples (auth changes, explicit audit, payment code)
- **install.sh** — Added `workflow` skills directory, `rules/` directory copying
- **README.md** — Updated to v2.16.0 with new features

---

## [2.15.0] - 2026-02-06

### Added
- **Agent Teams skill** (`agent-teams.md`) - Parallel agent coordination
  - Lead + Teammates architecture
  - Patterns: parallel code review, feature dev, consilium
  - Cost control guidelines
- **MCP Tool Search skill** (`mcp-tool-search.md`) - MCP lazy loading reference
  - serverInstructions for minimal context usage
  - Recommended mcp.json configuration
- **Async Hooks skill** (`async-hooks.md`) - Background hooks + Setup hook
  - `async: true` for non-blocking hooks
  - Setup hook via `claude --init`
  - Hook lifecycle reference
- **Background Tasks skill** (`background-tasks.md`) - Dev server in background
  - Ctrl+B for background commands
  - `--from-pr` for PR-linked sessions
- **Effort Profiles** (`config/effort-profiles.md`) - Effort level reference
  - low/medium/high levels and recommendations
  - Extended thinking reference (default 31,999 tokens)
- **Migration Guide** (`MIGRATION_V2.13.md`) - migration checklist

### Changed
- **README.md** - Updated to v2.15, Opus 4.6, new features section
- **mcp.json** - Restored context7 with serverInstructions, added to shadcn
- **agents/review.md** - Agent Teams code review pattern, Opus 4.6 self-correction
- **agents/security.md** - model: opus, context: fork, zero-day patterns
- **skills/business/consilium.md** - Agent Teams parallel mode
- **skills/mcp-usage/ralph-wiggum.md** - Agent Teams + Background Tasks sections
- **scripts/setup-ai-aliases.sh** - gpt-5.3-codex model

### Fixed
- `forked_context: true` replaced with `context: fork` (correct Claude Code syntax)
- Removed unsupported frontmatter fields: `category`, `updated`, `trigger`, `plugin`, `requires_plugin`, `models`
- Fixed hooks format: `pre_invoke`/`post_invoke` replaced with `SessionStart`/`Stop`
- Codex model updated: `gpt-5.1-codex-max` replaced with `gpt-5.3-codex`
- Cleaned frontmatter in all 25 reference skills

---

## [2.14.0] - 2026-01-20

### Added
- **Auto-Check Hooks** (`config/settings.json`) - Automatic code quality checks
  - console.log detector: warns when console.log found in .ts/.tsx files
  - ESLint checker: shows ESLint errors after file edits (if ESLint configured)
  - Based on [Anthropic hackathon winner](https://github.com/affaan-m/everything-claude-code) best practices

- **MCP Optimization** - Context window management
  - Removed rarely-used MCPs from global config (clerk, magic)
  - Removed duplicate context7 MCP
  - Saved ~10,500 tokens (~5% context window)
  - Documentation for project-specific MCP configuration

### Changed
- Updated global CLAUDE.md with hooks documentation
- Added MCP optimization guide

---

## [2.13.0] - 2026-01-16

### Added
- **React Optimization Skill** (`skills/tech-stack/react-optimization.md`)
  - Based on official Vercel React Best Practices blog post
  - Async waterfall elimination with `Promise.all()`
  - Early return patterns (check conditions before fetch)
  - Minimal fetch strategies (`select` vs `include`)
  - React.memo and useCallback patterns for re-render prevention
  - Server Actions vs client-side fetch patterns
  - Dynamic imports for bundle size reduction
  - Grep commands for finding anti-patterns
  - Impact examples with timing benchmarks

### Changed
- **Review Agent** (`agents/review.md`) - Expanded performance checklist
  - Split into 3 sections: Async Patterns, React Rendering, Data Fetching
  - Added link to react-optimization.md skill
  - More specific checklist items for common issues

---

## [2.12.0] - 2026-01-09

### Added
- **Code Simplifier Integration** in review agent
  - Two-phase workflow: Simplify then Review
  - Flags: `--no-simplify`, `--simplify-only`

### Changed
- Review agent uses official `code-simplifier` plugin
- Workflow: Ralph Wiggum -> Review -> Commit

---

## [2.11.0] - 2026-01-09

### Changed
- **All skills updated** with Claude Code 2.1.0 frontmatter
  - `model:` per skill (opus/sonnet/haiku)
  - `forked_context:` for isolated context
  - `hooks:` pre/post invoke commands
- Skill invocation via `/skill-name`
- Wildcard permissions documentation

---

## [2.10.0] - 2026-01-09

### Added
- **Consilium - Product Analysis Board** (`consilium.md`)
  - 7 AI agents including Research Agent
  - Specialized for B2B SaaS in Indonesian restaurant industry

---

## [2.9.0] - 2026-01-08

### Added
- **Ralph Wiggum Plugin Guide** (`ralph-wiggum.md`) - Autonomous loops for Claude Code
  - Run tasks for hours without intervention
  - Auto-retry until success criteria met
  - Examples: CRUD generation, lint fixes, test fixes, migrations
  - Integration with review/QA agents post-completion
  - Safety guidelines and cost management tips

### Changed
- **PLUGINS_SETUP.md** - Added Ralph Wiggum to recommended plugins
  - Installation instructions
  - Usage examples for restaurant platform
  - When to use Ralph vs manual mode

---

## [2.8.0] - 2026-01-07

### Added
- **AI Agents Natural Language** (`ai-agents.md`) - Natural language commands for external AI agents
  - Say: "Ask Gemini review for broken layout"
  - Say: "Ask Codex to find race condition"
  - Say: "Need a second opinion on this bug"
  - Auto-detects problem type -> selects best agent
  - Instructions added to CLAUDE.md for automatic recognition

### Changed
- **Multi-AI Debug updated** - Correct model names and syntax
  - Gemini: `gemini-3.1-pro-preview` (requires paid tier)
  - Codex: `gpt-5.1-codex-max` with `model_reasoning_effort="high"`
  - Codex CLI updated to v0.79.0
  - Removed `--preview-features` flag (doesn't exist)

### Fixed
- Removed hardcoded API keys from repository
- Added `.claude/settings.local.json` to `.gitignore`

---

## [2.7.0] - 2025-01-06

### Added
- **Multi-AI Debug** (`multi-ai-debug.md`) - Use Codex/Gemini as second-opinion debuggers
  - Bash aliases: `cr`, `gr`, `bug`, `sec`, `perf`, `arch`
  - Setup script: `scripts/setup-ai-aliases.sh`
  - Workflow: Claude + Codex/Gemini collaboration
  - Read-only mode for safety

---

## [2.6.0] - 2025-01-06

### Added
- **Clerk MCP guide** (`clerk-mcp-guide.md`) - User management from Claude Code
  - Users: getUser, getUserList, getUserCount, updateUserMetadata
  - Organizations: getOrganization, getOrganizationList, createInvitation
  - Invitations: getInvitationList, revokeInvitation
  - Integration examples with Supabase, Neon, GitHub MCP
  - Code examples for Vercel AI SDK, LangChain

---

## [2.5.0] - 2025-01-05

### Added
- **Syrve Cloud API extended** - Table orders, reports, marketing
  - `syrve-table-orders.md` - QR menu, in-restaurant ordering, tables (~400 lines)
  - `syrve-reports.md` - OLAP analytics, sales dashboards, performance reports (~350 lines)
  - `syrve-marketing.md` - Loyalty programs, discounts, coupons, promotions (~350 lines)

### Changed
- README updated with new Syrve skills
- Total Syrve skills: 8 files, 2500+ lines

---

## [2.4.0] - 2025-01-05

### Added
- **Syrve Cloud API skills suite** - Complete delivery platform integration
  - `syrve-api.md` - Expanded from 61 to 355 lines (auth, orgs, dictionaries, addresses)
  - `syrve-delivery.md` - Delivery orders, couriers, zones, status updates
  - `syrve-menu.md` - Nomenclature, stop-lists, combos, sync strategy
  - `syrve-customers.md` - Loyalty programs, wallets, coupons
  - `syrve-webhooks.md` - Event subscriptions, Next.js handlers

### Changed
- README updated with Syrve skills documentation

---

## [2.3.0] - 2025-01-03

### Added
- **Code Reviewer & Simplifier agent** (`review.md`) - Dual-role agent for code review and refactoring
  - Review checklist (bugs, TypeScript, security, performance)
  - 5 Simplification Principles with before/after examples
  - 3 Common Refactoring Patterns
  - When NOT to Simplify guidelines

### Changed
- **Architect agent extended** (90 -> 309 lines)
  - 5-step Analysis Framework
  - Risk Assessment matrix
  - Tech Stack Specifics section
  - Better example (Syrve Product Sync)
  - Critical Guidelines

---

## [2.2.0] - 2025-01-03

### Added
- **Chrome Extension guide** (`chrome-extension-guide.md`) - Complete browser testing guide
- **YAML frontmatter** to all 16 skill files

### Changed
- All documentation translated to English
- QA agent updated to use Chrome Extension
- Framework standardized

### Removed
- Playwright MCP guide (deprecated)
- Backup folder

---

## [2.1.0] - 2024-12-29

### Added
- **GitHub MCP guide** - Issues, PRs, CI/CD from terminal
- **Database Migrations skill** - Drizzle ORM workflow, safe schema changes
- **Monitoring skill** - Sentry setup, structured logging, alerts
- **QA Agent extension** - Telegram Mini App specific tests, pre-release checklist
- **Telegram Bot skill extension** - CloudStorage, Auth flow, Haptic feedback, Performance
- **Docs Agent extension** - Troubleshooting guides, ADR, Runbooks, Mermaid diagrams

### Changed
- README updated with v2.1 features
- Skills reorganized with new additions

---

## [2.0.0] - 2024-12-29

### Added
- 21st.dev Magic MCP - AI UI generation
- Claude Chrome Extension support

### Removed
- Playwright MCP (deprecated)

### Changed
- Updated all documentation
- Simplified MCP config

---

## [1.0.0] - 2024-11

- Initial release
