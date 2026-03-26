---
name: auto-memory
description: Persistent memory system for Claude Code sessions — native + framework hybrid
---

# Auto-Memory System

Claude Code now has a **native memory system** built in. The 2111framework complements it with project-specific hooks for context that native memory doesn't cover.

## Architecture: Native + Framework Hybrid

```
Native Memory (built-in)              Framework Hooks (2111framework)
─────────────────────────              ────────────────────────────────
.claude/projects/*/memory/             PROJECT_MEMORY.md
├── MEMORY.md (index)                  ├── Architecture decisions
├── user_*.md (user prefs)             ├── Resolved bugs
├── feedback_*.md (corrections)        ├── API limitations
├── project_*.md (project state)       └── Anti-patterns
└── reference_*.md (external refs)
                                       SessionStart/compact hook
Auto-loaded every session              ├── Re-injects PROJECT_MEMORY.md
Claude manages read/write              ├── Git branch + last 5 commits
Survives compact automatically         └── Fills gaps native memory misses
```

---

## Native Memory System (Built-in)

Claude Code automatically maintains memory in `.claude/projects/<project-path>/memory/`. No setup required.

### Memory Types

| Type | What to store | Example |
|------|--------------|---------|
| `user` | Your role, preferences, knowledge | "Senior dev, prefers terse responses" |
| `feedback` | Corrections and confirmed approaches | "Don't mock DB in integration tests" |
| `project` | Ongoing work, goals, deadlines | "Merge freeze starts 2026-03-05" |
| `reference` | Pointers to external systems | "Bugs tracked in Linear project INGEST" |

### How It Works

- **MEMORY.md** index is loaded into every conversation automatically
- Claude decides when to save/read memories based on conversation context
- Memories have frontmatter with `name`, `description`, `type`
- Survives `/compact` without any hooks — it's always in context

### What Native Memory Handles Well

- User preferences and working style
- Feedback corrections ("don't do X, do Y instead")
- External resource pointers
- Cross-session context

### What Native Memory Does NOT Handle

- **Architecture decisions** tied to specific codebases (too detailed for memory files)
- **Git context** after compact (branch, recent commits)
- **TODO list** persistence across prompts
- **Resolved bugs** with technical details

This is where framework hooks fill the gap.

---

## Framework Hooks (PROJECT_MEMORY.md)

### The Compact Re-injection Cycle

```
/compact fires → context lost → SessionStart/compact hook fires
→ re-injects PROJECT_MEMORY.md + git branch + last 5 commits
→ Claude recovers project context
```

### PROJECT_MEMORY.md

Located in your project root. This is the **high-value** file for technical context:

```markdown
# Project Memory

## Architecture Decisions
- We chose X over Y because Z
- Tech stack versions centralized in config/tech-stack.md

## Resolved Bugs
- Bug: X happened because Y — fix: Z

## API Limitations
- API X doesn't support Y, use Z instead

## Anti-patterns
- Never do X in this project because Y
```

### What Goes Where

| Information | Where to store | Why |
|-------------|---------------|-----|
| "I prefer short responses" | Native memory (feedback) | Personal preference, cross-project |
| "We use Drizzle ORM with Neon" | PROJECT_MEMORY.md | Architecture decision, project-specific |
| "Bugs tracked in Linear" | Native memory (reference) | External system pointer |
| "API X rate-limits at 100/min" | PROJECT_MEMORY.md | Technical limitation, code-relevant |
| "Don't mock DB in tests" | Native memory (feedback) | Workflow preference, cross-project |
| "Auth rewrite driven by compliance" | PROJECT_MEMORY.md | Project-specific context |

---

## Legacy: auto-memory.sh

The Stop hook (`config/hooks/auto-memory.sh`) still logs session timestamps to `~/.claude/memory/sessions.md`. This is mostly **superseded by native memory** but kept for backward compatibility and session auditing.

You can safely remove it if you don't need session logs:

```json
// In settings.json, remove the first Stop hook entry
```

---

## Setup

### Native Memory
No setup needed. Works out of the box with Claude Code.

### Framework Hooks
Installed automatically with `bash install.sh`:
- SessionStart/compact hook — re-injects PROJECT_MEMORY.md
- Stop hook — session logging (legacy)

### Verify Setup

```bash
# Native memory directory (auto-created by Claude Code)
ls -la ~/.claude/projects/

# Framework hooks
cat ~/.claude/settings.json | jq '.hooks.SessionStart'
cat ~/.claude/settings.json | jq '.hooks.Stop'

# PROJECT_MEMORY.md in project root
cat PROJECT_MEMORY.md
```

---

## Best Practices

### Keep PROJECT_MEMORY.md Focused

- Only technical decisions, bugs, and limitations
- Reference file paths, don't paste code
- Update after important discoveries
- Keep under 100 lines — it's re-injected on every compact

### Let Native Memory Handle the Rest

- Don't duplicate user preferences in PROJECT_MEMORY.md
- Don't store TODO items (use `.claude/TODO.md`)
- Don't store temporary debugging notes
- Trust Claude to manage its own memory files

### Migration from v2.17

If you have a large PROJECT_MEMORY.md with user preferences mixed in:
1. Move personal preferences → let Claude save them as native `feedback` memories
2. Move external references → let Claude save them as native `reference` memories
3. Keep only architecture decisions, bugs, API limitations in PROJECT_MEMORY.md
