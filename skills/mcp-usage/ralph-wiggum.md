---
name: ralph-wiggum
description: Autonomous loops for Claude Code - run tasks for hours without intervention
category: mcp-usage
updated: 2026-01-08
plugin: ralph-wiggum@claude-plugins-official
---

# Ralph Wiggum - Autonomous Loops

Run Claude Code autonomously for hours. Named after The Simpsons character.

## Why Use Ralph Wiggum?

| Without Ralph | With Ralph |
|---------------|------------|
| You supervise every step | Set goal and walk away |
| Fix errors manually | Auto-retry until success |
| 30 min sessions | 2-3 hour autonomous runs |
| You = dispatcher | Claude = autopilot |

---

## Installation

```bash
/plugin install ralph-wiggum@claude-plugins-official
```

Verify:
```bash
/plugin
# Should show: ralph-wiggum (installed)
```

---

## Basic Usage

```bash
/ralph-loop "<task description>" --max-iterations <N>
```

### Simple Example

```bash
/ralph-loop "Run npm run lint, fix all errors" --max-iterations 10
```

### With Completion Promise

```bash
/ralph-loop "Run npm test, make all tests pass" \
  --completion-promise "All tests passed" \
  --max-iterations 20
```

---

## How It Works

```
You: /ralph-loop "Fix all TypeScript errors" --max-iterations 15
    |
    v
Claude: Works on task
    |
    v
Claude: Thinks it's done -> tries to exit
    |
    v
[Stop Hook intercepts] -> Checks: are there still errors?
    |
    v
YES errors remain -> Re-inject prompt -> Continue
    |
    v
NO errors -> Exit successfully
```

**Key insight:** The prompt stays the same, but the codebase changes. Claude learns from its own previous output.

---

## Task Formula

```
WHAT to do + HOW to verify success + CONSTRAINTS
```

### Bad vs Good Tasks

| Bad (vague) | Good (measurable) |
|-------------|-------------------|
| "Fix the bugs" | "Run npm test, fix all failing tests" |
| "Make it better" | "Run npm run lint, fix all errors" |
| "Test the frontend" | "Run playwright test, all tests must pass" |
| "Refactor this" | "Extract functions > 50 lines into separate files" |

---

## Practical Examples

### 1. Lint & Build

```bash
/ralph-loop "
1. Run npm run lint
2. Fix all lint errors
3. Run npm run build
4. Build must succeed
" --completion-promise "Successfully compiled" --max-iterations 15
```

### 2. TypeScript Errors

```bash
/ralph-loop "Run npx tsc --noEmit, fix all TypeScript errors" \
  --completion-promise "Successfully compiled" \
  --max-iterations 20
```

### 3. Unit Tests

```bash
/ralph-loop "Run npm test, fix all failing tests" \
  --completion-promise "All tests passed" \
  --max-iterations 25
```

### 4. CRUD Generation

```bash
/ralph-loop "
Generate complete CRUD API for entities:
- Restaurants (name, address, cuisine, rating)
- MenuItems (name, price, category, availability)
- Orders (items, status, payment, delivery)

Use NestJS + Prisma + PostgreSQL.
Include validation, error handling, Swagger docs.
Run: npm run build && npm test
" --completion-promise "All tests passed" --max-iterations 30
```

### 5. Payment Integration

```bash
/ralph-loop "
Integrate payment gateway:
- Add Xendit SDK
- Create PaymentService with webhooks
- Handle: GoPay, OVO, Dana, BCA
- Add retry logic for failed payments
- Unit tests for all payment flows

Run: npm test -- --grep Payment
" --completion-promise "passing" --max-iterations 25
```

### 6. UI Audit (Chrome Extension)

```bash
/ralph-loop "
Create Chrome Extension for UI audit:
1. content.js scans current page
2. Find: broken images, empty links, undefined text
3. popup.html shows report
4. Highlight button marks problem elements

Test: load extension in Chrome, verify popup works
" --max-iterations 15
```

### 7. Database Migrations

```bash
/ralph-loop "
Create Drizzle migrations for schema changes:
1. Add 'rating' column to restaurants
2. Add 'delivery_zone' table
3. Add foreign key orders -> restaurants
4. Run: npm run db:push
5. Verify: npm run db:studio (no errors)
" --completion-promise "Changes applied" --max-iterations 10
```

---

## Safety Guidelines

### Always Use `--max-iterations`

```bash
# Safe
/ralph-loop "task" --max-iterations 20

# Dangerous (could run forever)
/ralph-loop "task"
```

### Recommended Limits

| Task Type | Max Iterations |
|-----------|----------------|
| Lint fixes | 10-15 |
| TypeScript errors | 15-20 |
| Unit tests | 20-25 |
| Feature implementation | 25-35 |
| Complex refactoring | 30-40 |

### Watch Your Costs

Long runs = more API calls. Monitor usage.

---

## When to Use Ralph vs Manual

### Use Ralph

- Clear success criteria ("tests pass", "build succeeds")
- Mechanical tasks (CRUD, migrations, lint)
- Overnight/background tasks
- High volume repetitive work

### Use Manual (Plan + Agents)

- Need decisions at each step
- Creative work (UI design, architecture)
- Critical code (payments, auth)
- Unclear requirements

---

## Combining with Other Tools

### Ralph + Parallel Agents

```bash
# Morning: Start Ralph in background
/ralph-loop "Generate CRUD for 5 entities" --max-iterations 30

# Parallel: You work on critical features with Plan mode
"Read architect agent, plan payment integration"
```

### Ralph + Review Agent

```bash
# Step 1: Ralph implements
/ralph-loop "Implement user authentication" --max-iterations 25

# Step 2: Review result
"Read review agent, review the auth implementation"
```

### Ralph + QA Agent

```bash
# Step 1: Ralph fixes tests
/ralph-loop "Fix all failing tests" --max-iterations 20

# Step 2: QA verifies
"Read qa agent, verify auth flow works end-to-end"
```

---

## Troubleshooting

### Loop Runs Forever

1. Check if `--completion-promise` matches exactly
2. Add `--max-iterations` as safety net
3. Verify the success condition is achievable

### Loop Exits Too Early

- Make task description more specific
- Add explicit "do not stop until X" instruction

### High API Costs

- Reduce `--max-iterations`
- Break large tasks into smaller ones
- Use for overnight/background only

### Claude Keeps Making Same Mistake

- Add explicit "avoid X approach" in prompt
- Provide more context in task description
- Consider manual intervention for this specific case

---

## Advanced: Custom Completion Conditions

```bash
# Multiple conditions (implicit)
/ralph-loop "
Run these commands in order:
1. npm run lint (0 errors)
2. npm run build (success)
3. npm test (all pass)

Do not stop until ALL three succeed.
" --max-iterations 30
```

---

## Real Results

| User | Task | Duration | Cost | Result |
|------|------|----------|------|--------|
| Geoffrey Huntley | Built programming language | 3 months | - | Complete language |
| YC Hackathon teams | 6+ repos overnight | 1 night | $297 | Shipped products |
| Typical use | CRUD + tests | 2-3 hours | $10-30 | Working feature |

---

## Integration with 2111framework

```
2111framework/
├── skills/
│   └── mcp-usage/
│       ├── ralph-wiggum.md      <- This file
│       ├── multi-ai-debug.md    <- Second opinion
│       └── ai-agents.md         <- Natural language agents
└── agents/
    ├── review.md                <- Post-Ralph review
    └── qa.md                    <- Post-Ralph QA
```

### Workflow

```bash
# 1. Ralph implements (autonomous)
/ralph-loop "Implement feature X with tests" --max-iterations 25

# 2. Review (manual check)
"Read review agent, review the implementation"

# 3. Security (if needed)
"Read security agent, audit for vulnerabilities"

# 4. Ship
git add . && git commit -m "Feature X"
```

---

## Related Skills

- `multi-ai-debug.md` - Get second opinion from Codex/Gemini
- `ai-agents.md` - Natural language agent commands
- `chrome-extension-guide.md` - UI testing for Ralph-generated code
