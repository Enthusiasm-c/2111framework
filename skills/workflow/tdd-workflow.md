---
name: tdd-workflow
description: Test-Driven Development workflow for Next.js + Vitest
---

# TDD Workflow — RED-GREEN-REFACTOR

A pattern for building reliable features with test-first development.

## When to Use

- Building new API endpoints or server actions
- Implementing business logic with clear input/output
- Fixing bugs (write failing test first, then fix)
- Refactoring (ensure tests pass before and after)

## Setup

```bash
# Install Vitest (if not already)
npm install -D vitest @testing-library/react @testing-library/jest-dom
```

```json
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
  },
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') },
  },
})
```

## The Cycle

### Phase 1: RED — Write a Failing Test

Write a test that describes the expected behavior. Run it — it should fail.

```typescript
// src/lib/pricing.test.ts
import { calculateDiscount } from './pricing'

describe('calculateDiscount', () => {
  it('should return 20% off for premium users over $100', () => {
    const result = calculateDiscount({ isPremium: true, total: 150 })
    expect(result).toBe(30) // 20% of 150
  })

  it('should return 0 for non-premium users under $200', () => {
    const result = calculateDiscount({ isPremium: false, total: 50 })
    expect(result).toBe(0)
  })

  it('should return 5% for non-premium users over $200', () => {
    const result = calculateDiscount({ isPremium: false, total: 300 })
    expect(result).toBe(15) // 5% of 300
  })
})
```

```bash
npx vitest run src/lib/pricing.test.ts
# FAIL — function doesn't exist yet
```

### Phase 2: GREEN — Make It Pass

Write the minimum code to make all tests pass. Don't optimize yet.

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
# PASS — all 3 tests pass
```

### Phase 3: REFACTOR — Clean Up

Now improve the code while keeping tests green.

```typescript
// Extracted constants, improved readability
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
# PASS — still passing after refactor
```

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

## Tips

- Run tests in watch mode during development: `npx vitest --watch`
- Write the simplest test first, add complexity gradually
- One assertion per test when possible
- Test behavior, not implementation details
- Use `describe` blocks to group related tests
