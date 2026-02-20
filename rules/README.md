# Rules Templates

Rules are path-scoped instructions that Claude Code automatically applies when working with matching files. They use Claude Code's native rules system.

## Format

Rules are `.md` files placed in `.claude/rules/` with YAML frontmatter:

```yaml
---
# Option 1: Apply to specific file patterns
globs: "**/*.tsx"
description: React component conventions

# Option 2: Apply to all files
alwaysApply: true
description: General coding conventions
---

Your rule content here in markdown.
```

## Frontmatter Options

| Field | Type | Description |
|-------|------|-------------|
| `globs` | string or string[] | File patterns this rule applies to |
| `description` | string | When the rule should be applied (for AI context) |
| `alwaysApply` | boolean | Apply to every file regardless of path |

## How It Works

1. When Claude Code opens or edits a file, it checks all rules in `.claude/rules/`
2. Rules with matching `globs` or `alwaysApply: true` are loaded into context
3. Claude follows these rules automatically — no manual invocation needed

## Creating Rules

### From scratch
Create `.md` files in `.claude/rules/` with appropriate frontmatter.

### From PROJECT_MEMORY.md
Use the `/init-rules` skill to auto-generate rules from your existing PROJECT_MEMORY.md.

## Examples

See `rules/examples/` for common templates:
- `react-components.md` — React/TSX conventions
- `api-routes.md` — API endpoint patterns
- `database.md` — Database query rules
- `testing.md` — Test conventions
- `git-workflow.md` — Git commit/branch rules

## Installation

```bash
# Copy templates to your project
cp -r ~/.claude/2111framework/rules/examples/ .claude/rules/

# Or selectively
cp ~/.claude/2111framework/rules/examples/react-components.md .claude/rules/
```

Then edit the rules to match your project's specific conventions.
