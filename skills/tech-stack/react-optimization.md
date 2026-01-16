---
name: react-optimization
description: React performance patterns from Vercel best practices (waterfalls, memoization, bundle size)
category: tech-stack
updated: 2026-01-16
model: sonnet
forked_context: false
source: https://vercel.com/blog/introducing-react-best-practices
---

# React Optimization Patterns

Performance patterns from official Vercel best practices. Focus on eliminating waterfalls, reducing bundle size, and preventing unnecessary re-renders.

## Critical: Async Waterfalls

### Sequential Awaits (Anti-pattern)

```typescript
// BAD: Sequential - ~400ms total
async function loadDashboard(userId: string) {
  const user = await getUser(userId)        // 100ms
  const orders = await getOrders(userId)    // 150ms
  const stats = await getStats(userId)      // 150ms
  return { user, orders, stats }
}

// GOOD: Parallel - ~150ms total
async function loadDashboard(userId: string) {
  const [user, orders, stats] = await Promise.all([
    getUser(userId),
    getOrders(userId),
    getStats(userId),
  ])
  return { user, orders, stats }
}
```

### Webhook Parallelization

```typescript
// BAD: Sequential webhook processing
async function handlePaymentWebhook(orderId: string) {
  const syrve = await sendToSyrve(orderId)      // 200ms
  await db.order.update({ syrveId: syrve.id })  // 50ms
  const shipment = await createShipment(orderId) // 150ms
  await db.order.update({ shipmentId: ... })    // 50ms
  await sendWhatsApp(orderId)                   // 100ms
  await sendTelegram(orderId)                   // 100ms
  // Total: ~650ms
}

// GOOD: Parallel where possible
async function handlePaymentWebhook(orderId: string) {
  // Step 1: Independent external calls
  const [syrve, shipment] = await Promise.all([
    sendToSyrve(orderId),
    createShipment(orderId),
  ])

  // Step 2: DB updates + notifications
  await Promise.all([
    db.order.update({ syrveId: syrve.id, shipmentId: shipment.id }),
    sendWhatsApp(orderId),
    sendTelegram(orderId),
  ])
  // Total: ~300ms (2x faster)
}
```

## Critical: Late Condition Checks

### Check Conditions BEFORE Fetch

```typescript
// BAD: Fetch before condition check
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId)  // 80ms wasted if skipped
  if (skipProcessing) return { skipped: true }
  return processUserData(userData)
}

// GOOD: Early return
async function handleRequest(userId: string, skipProcessing: boolean) {
  if (skipProcessing) return { skipped: true }
  const userData = await fetchUserData(userId)
  return processUserData(userData)
}
```

### Minimal Fetch for Validation

```typescript
// BAD: Full fetch just to check status
const order = await db.order.findUnique({
  where: { id },
  include: {
    items: true,
    customer: true,
    restaurant: { select: { /* 15 fields */ } }
  }
})
if (order.status === 'PAID') return { already: true }

// GOOD: Minimal fetch first
const check = await db.order.findUnique({
  where: { id },
  select: { id: true, status: true }
})
if (!check || check.status === 'PAID') {
  return { already: true }
}
// Full fetch only when needed
const order = await db.order.findUnique({ where: { id }, include: {...} })
```

### Validate Limits Before Operations

```typescript
// BAD: Update before checking limit
async function addAddress(customerId: string, data: AddressData) {
  if (data.isDefault) {
    await db.address.updateMany({  // Wasted if limit exceeded
      where: { customerId },
      data: { isDefault: false }
    })
  }

  const count = await db.address.count({ where: { customerId } })
  if (count >= 10) {
    return { error: "Max 10 addresses" }  // Too late!
  }
  // ...
}

// GOOD: Check limit first
async function addAddress(customerId: string, data: AddressData) {
  const count = await db.address.count({ where: { customerId } })
  if (count >= 10) {
    return { error: "Max 10 addresses" }
  }

  if (data.isDefault) {
    await db.address.updateMany({
      where: { customerId },
      data: { isDefault: false }
    })
  }
  // ...
}
```

## Client: React.memo for Lists

```typescript
// BAD: All items re-render on any change
function OrderList({ orders, onSelect }) {
  return (
    <div>
      {orders.map(order => (
        <div key={order.id} onClick={() => onSelect(order)}>
          <img src={order.image} />
          <span>{order.name}</span>
          <span>{order.price}</span>
        </div>
      ))}
    </div>
  )
}

// GOOD: Memoized item component
const OrderItem = React.memo(({ order, onSelect }) => (
  <div onClick={() => onSelect(order)}>
    <img src={order.image} />
    <span>{order.name}</span>
    <span>{order.price}</span>
  </div>
))

function OrderList({ orders, onSelect }) {
  return (
    <div>
      {orders.map(order => (
        <OrderItem key={order.id} order={order} onSelect={onSelect} />
      ))}
    </div>
  )
}
```

## Client: useCallback for Handlers

```typescript
// BAD: New function reference every render
function CourierSelector({ couriers, onSelect }) {
  return (
    <div>
      {couriers.map(c => (
        <button
          key={c.id}
          onClick={() => onSelect(c)}  // New fn each render
        >
          {c.name}
        </button>
      ))}
    </div>
  )
}

// GOOD: Stable function reference
function CourierSelector({ couriers, onSelect }) {
  const handleSelect = useCallback((courier) => {
    onSelect(courier)
  }, [onSelect])

  return (
    <div>
      {couriers.map(c => (
        <button
          key={c.id}
          onClick={() => handleSelect(c)}
        >
          {c.name}
        </button>
      ))}
    </div>
  )
}
```

## Client: Server Actions vs Client Fetch

```typescript
// BAD: API call from client component
// components/courier-selector.tsx
'use client'
function CourierSelector({ origin, destination }) {
  const [rates, setRates] = useState([])

  useEffect(() => {
    fetch('/api/delivery/rates', {
      method: 'POST',
      body: JSON.stringify({ origin, destination })
    })
      .then(r => r.json())
      .then(setRates)
  }, [origin, destination])
  // 2 HTTP round-trips: browser → server → external API → server → browser
}

// GOOD: Server Action
// lib/actions/delivery.ts
'use server'
export async function getDeliveryRates(origin: Coords, destination: Coords) {
  const response = await fetch('https://biteship.com/api/rates', {...})
  return response.json()
}

// components/courier-selector.tsx
// Can now be a Server Component or call action directly
const rates = await getDeliveryRates(origin, destination)
```

## Bundle: Dynamic Imports

```typescript
// BAD: Heavy library in main bundle
import { motion, AnimatePresence } from 'framer-motion'  // +36KB
import { Chart } from 'chart.js'  // +60KB

// GOOD: Lazy load heavy libraries
const MotionDiv = dynamic(
  () => import('framer-motion').then(mod => mod.motion.div),
  { ssr: false }
)

const Chart = dynamic(
  () => import('react-chartjs-2').then(mod => mod.Chart),
  { ssr: false, loading: () => <Skeleton /> }
)
```

## Bundle: Avoid Re-exporting Everything

```typescript
// BAD: Barrel exports pull entire library
// components/index.ts
export * from './Button'
export * from './Card'
export * from './Dialog'
// Import one, get all in bundle

// GOOD: Direct imports
import { Button } from '@/components/Button'
import { Card } from '@/components/Card'
```

## Review Checklist

| Pattern | What to Look For | Severity | Fix |
|---------|------------------|----------|-----|
| Sequential awaits | `await` → `await` → `await` | High | `Promise.all()` |
| Late condition | `await fetch` before `if (skip)` | High | Move condition up |
| Full fetch for check | `include: {...}` before early return | Medium | Use `select` |
| Missing memo | `.map()` renders items directly | Medium | `React.memo` |
| Inline handlers | `onClick={() => fn()}` in lists | Low | `useCallback` |
| Client API calls | `useEffect` + `fetch` | Medium | Server Action |
| Heavy imports | `framer-motion`, `chart.js` | Low | `dynamic()` |

## Grep Commands

```bash
# Find sequential awaits
rg "await.*\n.*await.*\n.*await" --type ts

# Find useEffect with fetch
rg "useEffect.*\{" -A 5 --type tsx | rg "fetch\("

# Find inline handlers in map
rg "\.map\(" -A 3 --type tsx | rg "onClick=\{\(\)"

# Find heavy library imports
rg "from ['\"]framer-motion['\"]" --type tsx
rg "from ['\"]chart\.js['\"]" --type tsx

# Find barrel imports
rg "from ['\"]@/components['\"]" --type tsx
```

## Quick Wins

1. **Promise.all()** - Parallelize independent awaits (saves 100-400ms)
2. **Early return** - Check conditions before fetch (saves wasted DB calls)
3. **select vs include** - Minimal data for validation (saves memory + time)
4. **React.memo** - For list item components (prevents re-renders)
5. **Server Actions** - Move API calls to server (saves round-trip)
6. **dynamic()** - Lazy load heavy libraries (smaller initial bundle)

## Impact Examples

| Optimization | Before | After | Savings |
|--------------|--------|-------|---------|
| Webhook parallelization | 650ms | 300ms | 350ms/order |
| Minimal fetch for check | 80ms | 5ms | 75ms/request |
| Cart memo | 5 re-renders | 1 re-render | 80% less work |
| Server Action | 2 round-trips | 1 round-trip | 100-200ms |
