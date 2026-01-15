---
name: syrve-delivery
description: Syrve Cloud API delivery orders - create, update, track, couriers
category: integrations
updated: 2026-01-15
model: sonnet
forked_context: false
---

# Syrve Delivery API

Complete reference for delivery order operations in Syrve Cloud API.

**OpenAPI Spec**: https://api-eu.syrve.live/api-docs/docs

**License Required**: Enterprise (€99/mo) for `/deliveries/create`

## When to Use
- Create delivery orders from external platform
- Track order status
- Manage couriers
- Handle delivery zones

---

## Create Delivery Order

`POST /deliveries/create`

### Minimal Request

```json
{
  "organizationId": "org-uuid",
  "terminalGroupId": "terminal-uuid",
  "order": {
    "phone": "+79001234567",
    "orderTypeId": "delivery-type-uuid",
    "deliveryPoint": {
      "address": {
        "street": {
          "city": "Moscow",
          "name": "Tverskaya"
        },
        "house": "1"
      }
    },
    "items": [
      {
        "productId": "product-uuid",
        "type": "Product",
        "amount": 1
      }
    ],
    "payments": [
      {
        "paymentTypeId": "cash-uuid",
        "paymentTypeKind": "Cash",
        "sum": 500,
        "isProcessedExternally": false
      }
    ]
  }
}
```

### Full Request Structure

```typescript
interface CreateDeliveryRequest {
  organizationId: string;
  terminalGroupId: string;
  createOrderSettings?: {
    transportToFrontTimeout?: number; // seconds
  };
  order: DeliveryOrder;
}

interface DeliveryOrder {
  // Required
  phone: string;
  orderTypeId: string;
  items: OrderItem[];
  payments: Payment[];

  // Delivery Address
  deliveryPoint?: {
    coordinates?: { latitude: number; longitude: number };
    address?: DeliveryAddress;
    externalCartographyId?: string;
    comment?: string;
  };

  // Customer
  customer?: {
    id?: string;
    name?: string;
    surname?: string;
    email?: string;
    shouldReceiveOrderStatusNotifications?: boolean;
    shouldReceivePromoActionsInfo?: boolean;
  };
  guests?: { count: number };

  // Timing
  completeBefore?: string; // ISO 8601

  // Order Details
  comment?: string;
  externalNumber?: string;
  sourceKey?: string;

  // Discounts
  discountsInfo?: {
    discounts: Array<{
      discountTypeId: string;
      sum?: number;
      selectivePositions?: string[];
    }>;
  };

  // Tips
  tipsTypeId?: string;
  tips?: { sum: number };
}

interface OrderItem {
  productId: string;
  type: 'Product' | 'Compound';
  amount: number;
  modifiers?: Array<{
    productId: string;
    amount: number;
    productGroupId?: string;
  }>;
  price?: number;
  comment?: string;
  positionId?: string;
}

interface Payment {
  paymentTypeId: string;
  paymentTypeKind: 'Cash' | 'Card' | 'External';
  sum: number;
  isProcessedExternally: boolean;
  number?: string;
}

interface DeliveryAddress {
  street: {
    classifierId?: string;
    city?: string;
    name: string;
  };
  house: string;
  building?: string;
  flat?: string;
  entrance?: string;
  floor?: string;
  doorphone?: string;
}
```

### Response

```json
{
  "correlationId": "uuid",
  "orderInfo": {
    "id": "order-uuid",
    "posId": "pos-uuid",
    "externalNumber": "EXT-001",
    "organizationId": "org-uuid",
    "timestamp": 1704067200,
    "creationStatus": "Success",
    "errorInfo": null
  }
}
```

### Creation Status Values
- `Success` - Order created
- `InProgress` - Processing
- `Error` - Failed (check errorInfo)

---

## Retrieve Orders

### By IDs
`POST /deliveries/by_id`

```json
{
  "organizationIds": ["org-uuid"],
  "orderIds": ["order-uuid-1", "order-uuid-2"]
}
```

### By Date and Status
`POST /deliveries/by_delivery_date_and_status`

```json
{
  "organizationIds": ["org-uuid"],
  "deliveryDateFrom": "2024-01-01",
  "deliveryDateTo": "2024-01-31",
  "statuses": ["Unconfirmed", "WaitCooking", "ReadyForCooking", "CookingStarted", "CookingCompleted", "Waiting", "OnWay", "Delivered", "Closed", "Cancelled"]
}
```

### By Phone Number
`POST /deliveries/by_delivery_date_and_phone`

```json
{
  "organizationIds": ["org-uuid"],
  "phone": "+79001234567",
  "deliveryDateFrom": "2024-01-01",
  "deliveryDateTo": "2024-01-31"
}
```

### Order Response Structure

```typescript
interface DeliveryOrderInfo {
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

  // Customer
  customer: {
    id: string;
    name: string;
    phone: string;
  };

  // Delivery
  deliveryPoint: {
    address: DeliveryAddress;
    comment: string;
  };
  completeBefore: string;

  // Items & Payments
  items: OrderItem[];
  payments: Payment[];

  // Courier
  courier?: {
    id: string;
    name: string;
    phone: string;
  };

  // Financial
  sum: number;
  discount: number;
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

---

## Update Order

### Update Status
`POST /deliveries/update_order_delivery_status`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "deliveryStatus": "OnWay",
  "deliveryDate": "2024-01-15 14:30:00"
}
```

### Assign Courier
`POST /deliveries/update_order_courier`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "employeeId": "courier-uuid"
}
```

### Mark Problem
`POST /deliveries/update_order_problem`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "hasProblem": true,
  "problem": "Customer not responding"
}
```

### Add Items
`POST /deliveries/add_items`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "items": [
    {
      "productId": "product-uuid",
      "type": "Product",
      "amount": 1
    }
  ]
}
```

---

## Confirm / Cancel

### Confirm Order
`POST /deliveries/confirm`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid"
}
```

### Cancel Confirmation
`POST /deliveries/cancel_confirmation`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid"
}
```

### Cancel Delivery
`POST /deliveries/cancel`

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "cancelCauseId": "cancel-cause-uuid",
  "cancelComment": "Customer request"
}
```

---

## Couriers

### List Couriers
`POST /employees/couriers`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "employees": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "courier-uuid",
          "name": "Ivan Petrov",
          "phone": "+79001234567",
          "isDriver": true
        }
      ]
    }
  ]
}
```

### Courier Coordinates History
`POST /employees/couriers/locations/by_time_offset`

```json
{
  "organizationId": "org-uuid",
  "couriersIds": ["courier-uuid"],
  "startFromUtcOffsetInMinutes": -60
}
```

---

## Delivery Zones

### Get Restrictions
`POST /delivery_restrictions`

```json
{
  "organizationIds": ["org-uuid"]
}
```

### Check Delivery Availability
`POST /delivery_restrictions/allowed`

```json
{
  "organizationIds": ["org-uuid"],
  "deliveryAddress": {
    "street": {
      "city": "Moscow",
      "name": "Tverskaya"
    },
    "house": "1"
  },
  "orderSum": 500
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "isAllowed": true,
  "rejectionCause": null,
  "allowedItems": [
    {
      "terminalGroupId": "terminal-uuid",
      "deliveryDurationInMinutes": 45,
      "zone": {
        "name": "Zone 1"
      }
    }
  ]
}
```

---

## Order Workflow

```
1. Create Order (Unconfirmed)
        ↓
2. Confirm Order (WaitCooking)
        ↓
3. Start Cooking (CookingStarted)
        ↓
4. Complete Cooking (CookingCompleted)
        ↓
5. Assign Courier (Waiting)
        ↓
6. Courier Picked Up (OnWay)
        ↓
7. Delivered (Delivered)
        ↓
8. Close Order (Closed)
```

---

## TypeScript Client Example

```typescript
class SyrveDeliveryClient {
  private baseUrl = 'https://api-ru.iiko.services/api/1';
  private token: string;

  async createDelivery(order: CreateDeliveryRequest): Promise<OrderInfo> {
    const res = await fetch(`${this.baseUrl}/deliveries/create`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(order)
    });

    const data = await res.json();

    if (data.orderInfo.creationStatus === 'Error') {
      throw new Error(data.orderInfo.errorInfo?.message);
    }

    return data.orderInfo;
  }

  async getOrderById(
    organizationId: string,
    orderId: string
  ): Promise<DeliveryOrderInfo> {
    const res = await fetch(`${this.baseUrl}/deliveries/by_id`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        organizationIds: [organizationId],
        orderIds: [orderId]
      })
    });

    const data = await res.json();
    return data.orders[0];
  }

  async updateStatus(
    organizationId: string,
    orderId: string,
    status: DeliveryStatus
  ): Promise<void> {
    await fetch(`${this.baseUrl}/deliveries/update_order_delivery_status`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        organizationId,
        orderId,
        deliveryStatus: status
      })
    });
  }
}
```

---

## Best Practices

1. **Use externalNumber** - Track orders in your system
2. **Check terminal availability** before creating order
3. **Validate address** with delivery restrictions
4. **Handle creation status** - may be InProgress
5. **Store correlationId** for debugging

---

## Related Skills

- `syrve-api.md` - Authentication, organizations
- `syrve-menu.md` - Get product IDs for items
- `syrve-webhooks.md` - Real-time order updates
