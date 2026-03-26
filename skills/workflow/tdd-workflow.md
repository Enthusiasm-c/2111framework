---
name: tdd-workflow
description: Test-Driven Development workflow with strict enforcement. Anti-rationalization patterns prevent skipping tests.
---

# TDD Workflow — RED-GREEN-REFACTOR

## The Iron Law

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

Write code before the test? Delete it. Start over. No keeping as "reference", no "adapting" it. Violating the letter of this rule IS violating its spirit.

---

## Anti-Rationalization Table

Claude will generate excuses to skip TDD. Here are the pre-approved responses:

| Excuse | Response |
|--------|----------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. Write it. |
| "I'll test after implementation" | Tests that pass immediately prove nothing. RED phase must fail first. |
| "Deleting hours of work is wasteful" | Sunk cost fallacy. Code without tests is liability, not asset. |
| "Just this one time" | There is no "just this one time". Every exception becomes the norm. |
| "TDD is dogmatic" | TDD is pragmatic. Bugs in production cost 100x more than tests. |
| "The test is obvious" | If it's obvious, writing it takes 30 seconds. Do it. |
| "I'll add tests in the refactor phase" | REFACTOR means cleaning GREEN code, not adding missing tests. |
| "This is prototype/throwaway code" | Prototypes become production. Test now or pay later. |

---

## Verification Before Completion

**Never claim work is complete without running the test command and reading its output.**

Banned phrases without proof:
- "Should work now" — RUN THE TEST
- "I'm confident this is correct" — RUN THE TEST
- "Looks good to me" — RUN THE TEST
- "This follows the pattern" — RUN THE TEST

Claiming work is complete without verification is dishonesty, not efficiency.

---

## When to Use

- Building new API endpoints or server actions
- Implementing business logic with clear input/output
- Fixing bugs (write failing test first, then fix)
- Refactoring (ensure tests pass before and after)
- **ANY code change** in a project with existing tests

## Setup

```bash
# Vitest (Next.js projects)
npm install -D vitest @testing-library/react @testing-library/jest-dom

# Jest (if project already uses Jest)
# Use existing jest.config.js
```

---

## The Cycle

### Phase 1: RED — Write a Failing Test

1. Write a test that describes the expected behavior
2. **Run it** — confirm it FAILS (not errors, FAILS)
3. If it errors instead of failing — fix the test first
4. If it passes — you're not testing new behavior, rewrite

```typescript
// src/lib/pricing.test.ts
import { calculateDiscount } from './pricing'

describe('calculateDiscount', () => {
  it('should return 20% off for premium users over $100', () => {
    const result = calculateDiscount({ isPremium: true, total: 150 })
    expect(result).toBe(30)
  })

  it('should return 0 for non-premium users under $200', () => {
    const result = calculateDiscount({ isPremium: false, total: 50 })
    expect(result).toBe(0)
  })
})
```

```bash
npx vitest run src/lib/pricing.test.ts
# FAIL — function doesn't exist yet ← CORRECT, proceed to GREEN
```

### Phase 2: GREEN — Make It Pass

Write the **minimum** code to make all tests pass. No optimization. No extra features.

```typescript
// src/lib/pricing.ts
interface DiscountInput {
  isPremium: boolean
  total: number
}

export function calculateDiscount({ isPremium, total }: DiscountInput): number {
  if (isPremium) return total > 100 ? total * 0.2 : total * 0.1
  return total > 200 ? total * 0.05 : 0
}
```

```bash
npx vitest run src/lib/pricing.test.ts
# PASS — all tests pass ← CORRECT, proceed to REFACTOR
```

### Phase 3: REFACTOR — Clean Up

Improve code while keeping tests green. Run tests after every change.

```typescript
const PREMIUM_THRESHOLD = 100
const PREMIUM_HIGH_DISCOUNT = 0.2
const PREMIUM_LOW_DISCOUNT = 0.1
const STANDARD_THRESHOLD = 200
const STANDARD_DISCOUNT = 0.05

export function calculateDiscount({ isPremium, total }: DiscountInput): number {
  if (!isPremium) return total > STANDARD_THRESHOLD ? total * STANDARD_DISCOUNT : 0
  return total > PREMIUM_THRESHOLD ? total * PREMIUM_HIGH_DISCOUNT : total * PREMIUM_LOW_DISCOUNT
}
```

```bash
npx vitest run src/lib/pricing.test.ts
# PASS — still passing after refactor ← CORRECT
```

---

## TDD for API Routes

```typescript
// src/app/api/orders/route.test.ts
import { POST } from './route'
import { NextRequest } from 'next/server'

describe('POST /api/orders', () => {
  it('should create order with valid data', async () => {
    const req = new NextRequest('http://localhost/api/orders', {
      method: 'POST',
      body: JSON.stringify({ items: [{ id: '1', qty: 2 }], userId: 'user-1' }),
    })
    const res = await POST(req)
    const data = await res.json()
    expect(res.status).toBe(201)
    expect(data.success).toBe(true)
  })

  it('should return 400 for empty items', async () => {
    const req = new NextRequest('http://localhost/api/orders', {
      method: 'POST',
      body: JSON.stringify({ items: [], userId: 'user-1' }),
    })
    const res = await POST(req)
    expect(res.status).toBe(400)
  })
})
```

## TDD for Bug Fixes

1. Reproduce the bug in a test (RED)
2. Fix the code (GREEN)
3. The test prevents regression forever

```typescript
// Bug: negative quantities accepted
it('should reject negative quantities', () => {
  const result = validateOrderItems([{ id: '1', qty: -1 }])
  expect(result.valid).toBe(false)
  expect(result.error).toContain('quantity')
})
```

---

## Escalation Rule

If 3+ attempts to fix a test fail: **STOP**. Question the architecture. The test may be revealing a design problem, not a code problem. Escalate to the architect agent.

---

## Tips

- Run tests in watch mode: `npx vitest --watch`
- Write the simplest test first, add complexity gradually
- One assertion per test when possible
- Test behavior, not implementation details
- Use `describe` blocks to group related tests
- **Always check test output** — never assume a test passed
