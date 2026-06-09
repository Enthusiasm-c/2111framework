---
name: react-optimization
description: Project-specific performance patterns (webhook/Syrve/Telegram parallelization, Prisma minimal-fetch). For generic React/Next rules, defer to the official Vercel react-best-practices skill.
---

# React / Backend Optimization

> **Generic React/Next.js performance is now owned by the official Vercel skill.**
> Install once, it auto-activates on React work:
> ```bash
> npx skills add vercel-labs/agent-skills --skill react-best-practices
> ```
> It carries 70 rules (waterfalls, bundle, RSC serialization, re-renders) maintained by Vercel — more complete than this file ever was. This file keeps only **project-specific** patterns the generic skill does not cover.

## Webhook / external-call parallelization (Syrve · Telegram · Xero)

Our backends chain many external calls per request (OCR → Syrve → Xero → notify). Parallelize independent ones.

```typescript
// BAD: sequential — ~650ms
const syrve = await sendToSyrve(orderId)
await db.order.update({ syrveId: syrve.id })
const shipment = await createShipment(orderId)
await sendWhatsApp(orderId)
await sendTelegram(orderId)

// GOOD: independent calls in parallel — ~300ms
const [syrve, shipment] = await Promise.all([
  sendToSyrve(orderId),
  createShipment(orderId),
])
await Promise.all([
  db.order.update({ syrveId: syrve.id, shipmentId: shipment.id }),
  sendWhatsApp(orderId),
  sendTelegram(orderId),
])
```

## Prisma: minimal fetch for validation

Don't `include` a full graph just to read a flag.

```typescript
// BAD: full fetch to check one field
const order = await db.order.findUnique({ where: { id }, include: { items: true, customer: true } })
if (order.status === 'PAID') return { already: true }

// GOOD: select only what the check needs, full fetch only when proceeding
const check = await db.order.findUnique({ where: { id }, select: { id: true, status: true } })
if (!check || check.status === 'PAID') return { already: true }
const order = await db.order.findUnique({ where: { id }, include: { items: true } })
```

## Check limits / cheap conditions BEFORE awaiting

```typescript
// GOOD: early return before any DB work
if (skipProcessing) return { skipped: true }
const count = await db.address.count({ where: { customerId } })
if (count >= 10) return { error: 'Max 10 addresses' }
```

## How to run an optimization pass

Use `/optimize <path>` — it audits against the Vercel skill, reports by priority, applies only the high-impact fixes, and measures bundle before/after. See `commands/optimize.md`.
