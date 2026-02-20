---
name: init-rules
description: Generate Claude Code rules from PROJECT_MEMORY.md
---

# Init Rules — Generate Rules from PROJECT_MEMORY.md

Automatically creates `.claude/rules/` files from your existing PROJECT_MEMORY.md.

## When to Use

- Starting a new project that has PROJECT_MEMORY.md but no rules
- Migrating from PROJECT_MEMORY.md-based workflow to rules-based workflow
- After significant PROJECT_MEMORY.md updates

## How It Works

1. Read the project's `PROJECT_MEMORY.md`
2. Parse sections into categories (architecture, conventions, known issues, API limits)
3. Generate scoped rule files in `.claude/rules/`
4. Each rule targets specific file patterns or applies globally

## Step-by-Step

### Step 1: Read PROJECT_MEMORY.md

```bash
# Find and read the project memory
cat PROJECT_MEMORY.md
```

### Step 2: Identify Rule Categories

Map PROJECT_MEMORY.md sections to rule files:

| Memory Section | Rule File | Scope |
|----------------|-----------|-------|
| Architecture decisions | `architecture.md` | `alwaysApply: true` |
| API limitations | `api-limits.md` | `globs: "**/api/**"` |
| Database conventions | `database.md` | `globs: "**/db/**"` |
| UI/Component rules | `components.md` | `globs: "**/*.tsx"` |
| Known issues/workarounds | `known-issues.md` | `alwaysApply: true` |
| Auth patterns | `auth.md` | `globs: "**/auth/**"` |

### Step 3: Generate Rule Files

For each category, create a rule file:

```markdown
---
globs: "**/api/**"
description: API conventions and limitations from PROJECT_MEMORY
---

# API Rules

[Extracted content from PROJECT_MEMORY.md API section]
```

### Step 4: Install Rules

```bash
# Create rules directory
mkdir -p .claude/rules

# Copy generated rules
cp generated-rules/*.md .claude/rules/
```

## Example

Given this PROJECT_MEMORY.md:

```markdown
## Architecture Decisions
- Auth: Clerk + JWT
- DB: NeonDB with Drizzle ORM
- State: Server Components default

## API Limitations
- Syrve API: 100 req/min rate limit
- OpenAI Vision: Max 20MB images

## Known Issues
- NeonDB cold starts: use keep-alive
- Telegram WebApp.close() crashes on iOS 16
```

Generates these rules:

**`.claude/rules/architecture.md`**
```markdown
---
alwaysApply: true
description: Core architecture decisions
---
- Auth: Clerk + JWT — do not use custom auth
- DB: NeonDB with Drizzle ORM — do not use Prisma or raw SQL
- State: Server Components by default — use 'use client' only for interactivity
```

**`.claude/rules/api-limits.md`**
```markdown
---
globs: "**/api/**"
description: API rate limits and constraints
---
- Syrve API: Max 100 requests/minute — add retry with backoff
- OpenAI Vision: Max 20MB per image — validate file size before upload
```

**`.claude/rules/known-issues.md`**
```markdown
---
alwaysApply: true
description: Known issues and required workarounds
---
- NeonDB cold starts: Use keep-alive connection pooling
- Telegram WebApp.close() crashes on iOS 16: Wrap in setTimeout(fn, 0)
```

## Tips

- Keep rules concise — 5-10 lines per rule file
- Use specific globs for targeted rules
- Use `alwaysApply: true` sparingly — only for universal conventions
- Review generated rules before installing — remove project-specific details that don't translate to rules
- Update rules when PROJECT_MEMORY.md changes significantly
