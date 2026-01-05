---
name: syrve-webhooks
description: Syrve Cloud API webhooks - order events, subscriptions, handling
category: integrations
---

# Syrve Webhooks API

Complete reference for webhook subscriptions and event handling.

## When to Use
- Real-time order status updates
- Order creation notifications
- Error handling for failed orders
- Integration with external systems

---

## Available Events

| Event | Description |
|-------|-------------|
| `DeliveryOrderUpdate` | Order status changed |
| `DeliveryOrderError` | Order creation/update failed |
| `StopListUpdate` | Stop list changed |
| `ReserveUpdate` | Reservation changed |

---

## Webhook Payload Structure

### DeliveryOrderUpdate

Sent when order status changes.

```typescript
interface DeliveryOrderUpdateEvent {
  eventType: 'DeliveryOrderUpdate';
  eventTime: string; // ISO 8601
  organizationId: string;
  correlationId: string;

  eventInfo: {
    id: string;
    posId: string;
    externalNumber: string;
    organizationId: string;

    // Status
    status: DeliveryStatus;
    cancelInfo?: {
      cancelCauseId: string;
      comment: string;
      cancelTime: string;
    };

    // Order Details
    order: {
      id: string;
      items: OrderItem[];
      payments: Payment[];
      sum: number;
      discount: number;
    };

    // Delivery
    customer: {
      id: string;
      name: string;
      phone: string;
    };
    deliveryPoint: {
      address: DeliveryAddress;
    };

    // Courier
    courier?: {
      id: string;
      name: string;
      phone: string;
    };

    // Timestamps
    createdAt: string;
    completedAt: string | null;
  };
}

type DeliveryStatus =
  | 'Unconfirmed'
  | 'WaitCooking'
  | 'ReadyForCooking'
  | 'CookingStarted'
  | 'CookingCompleted'
  | 'Waiting'
  | 'OnWay'
  | 'Delivered'
  | 'Closed'
  | 'Cancelled';
```

### DeliveryOrderError

Sent when order creation fails.

```typescript
interface DeliveryOrderErrorEvent {
  eventType: 'DeliveryOrderError';
  eventTime: string;
  organizationId: string;
  correlationId: string;

  eventInfo: {
    id: string;
    externalNumber: string;
    errorInfo: {
      code: string;
      message: string;
      description: string;
    };
  };
}
```

### StopListUpdate

Sent when product availability changes.

```typescript
interface StopListUpdateEvent {
  eventType: 'StopListUpdate';
  eventTime: string;
  organizationId: string;
  correlationId: string;

  eventInfo: {
    terminalGroupId: string;
    items: Array<{
      productId: string;
      balance: number;
    }>;
  };
}
```

---

## Webhook Handler (Next.js)

### API Route

```typescript
// app/api/webhooks/syrve/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

const WebhookEventSchema = z.object({
  eventType: z.enum([
    'DeliveryOrderUpdate',
    'DeliveryOrderError',
    'StopListUpdate',
    'ReserveUpdate'
  ]),
  eventTime: z.string(),
  organizationId: z.string(),
  correlationId: z.string(),
  eventInfo: z.record(z.unknown())
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Validate payload
    const event = WebhookEventSchema.parse(body);

    // Log for debugging
    console.log(`Syrve webhook: ${event.eventType}`, {
      correlationId: event.correlationId,
      orgId: event.organizationId
    });

    // Handle by event type
    switch (event.eventType) {
      case 'DeliveryOrderUpdate':
        await handleOrderUpdate(event);
        break;

      case 'DeliveryOrderError':
        await handleOrderError(event);
        break;

      case 'StopListUpdate':
        await handleStopListUpdate(event);
        break;

      default:
        console.log(`Unhandled event type: ${event.eventType}`);
    }

    // Always return 200 quickly
    return NextResponse.json({ success: true });

  } catch (error) {
    console.error('Webhook error:', error);
    // Still return 200 to prevent retries for invalid payloads
    return NextResponse.json({ success: false, error: 'Invalid payload' });
  }
}

async function handleOrderUpdate(event: WebhookEvent) {
  const { eventInfo } = event;

  // Update order status in database
  await db.update(orders)
    .set({
      status: eventInfo.status,
      courierName: eventInfo.courier?.name,
      courierPhone: eventInfo.courier?.phone,
      updatedAt: new Date()
    })
    .where(eq(orders.syrveOrderId, eventInfo.id));

  // Notify customer
  if (['OnWay', 'Delivered', 'Cancelled'].includes(eventInfo.status)) {
    await sendStatusNotification(eventInfo);
  }
}

async function handleOrderError(event: WebhookEvent) {
  const { eventInfo } = event;

  // Mark order as failed
  await db.update(orders)
    .set({
      status: 'Failed',
      errorMessage: eventInfo.errorInfo.message,
      updatedAt: new Date()
    })
    .where(eq(orders.externalNumber, eventInfo.externalNumber));

  // Alert admin
  await sendAdminAlert({
    type: 'OrderCreationFailed',
    orderId: eventInfo.externalNumber,
    error: eventInfo.errorInfo.message
  });
}

async function handleStopListUpdate(event: WebhookEvent) {
  const { eventInfo } = event;

  // Update product availability
  for (const item of eventInfo.items) {
    await db.update(products)
      .set({ inStock: item.balance > 0 })
      .where(eq(products.syrveProductId, item.productId));
  }
}
```

---

## Idempotency

Webhooks may be delivered multiple times. Handle idempotently:

```typescript
async function handleOrderUpdate(event: WebhookEvent) {
  const { correlationId, eventInfo } = event;

  // Check if already processed
  const existing = await db.query.webhookEvents.findFirst({
    where: eq(webhookEvents.correlationId, correlationId)
  });

  if (existing) {
    console.log(`Duplicate webhook: ${correlationId}`);
    return;
  }

  // Store event
  await db.insert(webhookEvents).values({
    correlationId,
    eventType: event.eventType,
    payload: eventInfo,
    processedAt: new Date()
  });

  // Process...
}
```

---

## Webhook Registration

Webhooks are configured in Syrve admin panel, not via API.

### Setup Steps

1. Go to Syrve admin → Integrations
2. Add new webhook subscription
3. Enter your endpoint URL: `https://your-domain.com/api/webhooks/syrve`
4. Select events to subscribe
5. Save and test

### Security

- Use HTTPS only
- Validate organizationId matches your config
- Implement rate limiting
- Log all events for debugging

---

## Testing Webhooks

### Local Development

Use ngrok to expose local endpoint:

```bash
# Terminal 1
npm run dev

# Terminal 2
ngrok http 3000
# Use ngrok URL in Syrve admin
```

### Manual Testing

```typescript
// test/webhooks.test.ts
import { POST } from '@/app/api/webhooks/syrve/route';

const mockOrderUpdate = {
  eventType: 'DeliveryOrderUpdate',
  eventTime: new Date().toISOString(),
  organizationId: 'test-org-uuid',
  correlationId: 'test-correlation-uuid',
  eventInfo: {
    id: 'order-uuid',
    status: 'OnWay',
    externalNumber: 'EXT-001',
    courier: {
      id: 'courier-uuid',
      name: 'Test Courier',
      phone: '+79001234567'
    }
  }
};

describe('Syrve Webhooks', () => {
  it('handles DeliveryOrderUpdate', async () => {
    const request = new Request('http://localhost/api/webhooks/syrve', {
      method: 'POST',
      body: JSON.stringify(mockOrderUpdate)
    });

    const response = await POST(request);
    expect(response.status).toBe(200);
  });
});
```

---

## Error Handling

### Retry Logic (Syrve side)

- Syrve retries on non-2xx responses
- Exponential backoff
- Max retries: typically 5

### Your Handler

```typescript
export async function POST(request: NextRequest) {
  try {
    // Process webhook...
    return NextResponse.json({ success: true });

  } catch (error) {
    // Log error for debugging
    console.error('Webhook processing failed:', error);

    // Return 200 anyway to prevent infinite retries
    // for errors that won't be fixed by retry
    if (isUnrecoverableError(error)) {
      return NextResponse.json({
        success: false,
        error: 'Unrecoverable error, not retrying'
      });
    }

    // Return 500 to trigger retry for transient errors
    return NextResponse.json(
      { success: false, error: 'Temporary error' },
      { status: 500 }
    );
  }
}

function isUnrecoverableError(error: unknown): boolean {
  // Validation errors, missing data, etc.
  return error instanceof z.ZodError ||
    error instanceof TypeError;
}
```

---

## Best Practices

1. **Respond quickly** - Process async if needed
2. **Idempotency** - Handle duplicate deliveries
3. **Log everything** - correlationId is essential
4. **Alert on errors** - Monitor DeliveryOrderError
5. **Test locally** - Use ngrok for development

---

## Related Skills

- `syrve-api.md` - Authentication
- `syrve-delivery.md` - Order structure
