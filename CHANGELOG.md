# Changelog

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
  - ultrathink for extended analysis
- **Migration Guide** (`MIGRATION_V2.13.md`) - migration checklist

### Changed
- **README.md** - Updated to v2.15, Opus 4.6, new features section
- **mcp.json** - Restored context7 with serverInstructions, added to shadcn
- **agents/review.md** - Agent Teams code review pattern, ultrathink, Opus 4.6 self-correction
- **agents/security.md** - model: opus, context: fork, ultrathink, zero-day patterns
- **skills/business/consilium.md** - Agent Teams parallel mode, ultrathink
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
  - Gemini: `gemini-3-pro-preview` (requires paid tier)
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
