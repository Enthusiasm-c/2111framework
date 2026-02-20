---
name: systematic-debugging
description: Four-phase systematic approach to debugging
---

# Systematic Debugging

A structured 4-phase approach to finding and fixing bugs efficiently.

## The 4 Phases

```
REPRODUCE → ISOLATE → ROOT CAUSE → FIX
```

## Phase 1: REPRODUCE

Make the bug happen consistently. No guessing.

### Steps
1. Get exact reproduction steps from the user or bug report
2. Reproduce in your environment
3. Note: what input, what state, what output (expected vs actual)
4. If intermittent: identify conditions (timing, data, race condition)

### Tools
```bash
# Check recent changes that might have introduced the bug
git log --oneline -20
git diff HEAD~5

# Check error logs
npx vercel logs --follow
```

### Output
```markdown
## Reproduction
- **Steps:** Navigate to /settings, click "Save", observe 500 error
- **Frequency:** Every time with empty email field
- **Environment:** Production, Chrome 120, logged-in user
- **Error:** `TypeError: Cannot read properties of null (reading 'email')`
```

## Phase 2: ISOLATE

Narrow down to the exact code path causing the issue.

### Strategies

**Binary Search:** If you don't know where the bug is, cut the code path in half.

```typescript
// Add checkpoint logs to find where it breaks
console.log('[DEBUG] Step 1: Input received', input)     // works
console.log('[DEBUG] Step 2: Validated', validated)       // works
console.log('[DEBUG] Step 3: DB result', result)          // fails here
```

**Simplify:** Remove complexity until the bug disappears, then add back.

**Check Boundaries:** Bugs often live at:
- API boundaries (request/response shape mismatch)
- Type boundaries (runtime type != TypeScript type)
- State boundaries (stale state, race conditions)
- Environment boundaries (dev vs prod, missing env vars)

### Tools
```bash
# Search for the error message
grep -r "Cannot read properties" src/

# Find recent changes to the relevant file
git log --oneline -10 src/app/api/settings/route.ts

# Check if it works on a previous commit
git stash && git checkout HEAD~3
```

## Phase 3: ROOT CAUSE

Understand WHY it happens, not just WHERE.

### Common Root Causes

| Symptom | Likely Root Cause |
|---------|------------------|
| Works locally, fails in prod | Missing env var, different Node version, edge runtime |
| Intermittent failure | Race condition, cache issue, connection timeout |
| Works for some users | Auth state, permissions, data-dependent |
| Worked yesterday | Recent deploy, dependency update, config change |
| TypeError: null/undefined | Missing null check, async timing, wrong query |

### The "5 Whys"

```
Bug: Save button returns 500
1. Why? -> API throws TypeError
2. Why? -> `user.email` is null
3. Why? -> User query returns null
4. Why? -> Query uses wrong ID field
5. Why? -> Frontend sends `clerkId` but API queries by `id`
```

Root cause: **Field name mismatch between frontend and API**

## Phase 4: FIX

Apply the minimal, targeted fix. Then verify.

### Fix Checklist

1. **Minimal change** — fix only what's broken, don't refactor
2. **Test the fix** — reproduce the original bug, confirm it's gone
3. **Check side effects** — does the fix break anything else?
4. **Add regression test** — write a test that would catch this bug

```typescript
// Before (broken)
const user = await db.users.findFirst({ where: { id: clerkId } })

// After (fixed)
const user = await db.users.findFirst({ where: { clerkId } })
```

### Regression Test
```typescript
it('should find user by clerkId, not internal id', async () => {
  const user = await findUserByClerkId('clerk_123')
  expect(user).not.toBeNull()
  expect(user.clerkId).toBe('clerk_123')
})
```

### Verify
```bash
# Run the reproduction steps again — should be fixed
# Run related tests
npx vitest run src/lib/users.test.ts

# Check for unintended side effects
npx vitest run
npm run lint
npm run typecheck
```

## When to Escalate

Use Multi-AI agents when stuck:
- **Codex**: Race conditions, async bugs, complex logic errors
- **Gemini**: UI rendering bugs, CSS/layout issues, visual regressions

```bash
cat src/app/api/settings/route.ts | codex exec -s read-only "Find the bug causing 500 on save:"
```

## Anti-Patterns

- Guessing: "Maybe it's this?" -> changing code randomly
- Shotgun debugging: changing multiple things at once
- Ignoring logs: the error message usually tells you what's wrong
- Not reproducing first: fixing symptoms without understanding the cause
- Over-fixing: refactoring while debugging (fix first, clean up later)
