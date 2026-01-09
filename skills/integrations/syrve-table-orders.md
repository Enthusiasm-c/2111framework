---
name: syrve-table-orders
description: Syrve Cloud API table orders - QR menu, in-restaurant ordering, tables
category: integrations
updated: 2026-01-09
model: sonnet
forked_context: false
---

# Syrve Table Orders API

Complete reference for table orders (in-restaurant ordering, QR menu).

## When to Use
- QR menu for restaurants
- Self-ordering kiosks
- Digital menu with ordering
- Waiter mobile apps
- In-restaurant order management

---

## Table Orders vs Delivery

| Feature | Table Order | Delivery Order |
|---------|-------------|----------------|
| Endpoint | `/orders/create` | `/deliveries/create` |
| Location | Restaurant table | Customer address |
| Courier | Not needed | Required |
| Use case | QR menu, kiosk | Food delivery app |

---

## Get Restaurant Sections

`POST /reserve/available_restaurant_sections`

Get tables and sections for ordering.

```json
{
  "terminalGroupIds": ["terminal-uuid"],
  "returnSchema": true,
  "revision": 0
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "restaurantSections": [
    {
      "terminalGroupId": "terminal-uuid",
      "items": [
        {
          "id": "section-uuid",
          "name": "Main Hall",
          "tables": [
            {
              "id": "table-uuid",
              "number": 1,
              "name": "Table 1",
              "seatingCapacity": 4,
              "revision": 123
            },
            {
              "id": "table-uuid-2",
              "number": 2,
              "name": "Table 2",
              "seatingCapacity": 2,
              "revision": 124
            }
          ]
        }
      ]
    }
  ]
}
```

### TypeScript Types

```typescript
interface RestaurantSection {
  id: string;
  name: string;
  tables: Table[];
}

interface Table {
  id: string;
  number: number;
  name: string;
  seatingCapacity: number;
  revision: number;
}
```

---

## Create Table Order

`POST /orders/create`

### Minimal Request

```json
{
  "organizationId": "org-uuid",
  "terminalGroupId": "terminal-uuid",
  "order": {
    "tableIds": ["table-uuid"],
    "items": [
      {
        "productId": "product-uuid",
        "type": "Product",
        "amount": 1
      }
    ]
  }
}
```

### Full Request Structure

```typescript
interface CreateTableOrderRequest {
  organizationId: string;
  terminalGroupId: string;
  createOrderSettings?: {
    transportToFrontTimeout?: number;
  };
  order: TableOrder;
}

interface TableOrder {
  // Required
  tableIds: string[];       // One or more tables
  items: OrderItem[];

  // Optional - Customer
  phone?: string;
  customer?: {
    id?: string;
    name?: string;
    surname?: string;
  };
  guests?: {
    count: number;
  };

  // Optional - Order Details
  comment?: string;
  externalNumber?: string;  // Your order ID

  // Optional - Payments
  payments?: Payment[];

  // Optional - Discounts
  discountsInfo?: {
    discounts: Array<{
      discountTypeId: string;
      sum?: number;
    }>;
  };

  // Optional - Tips
  tipsTypeId?: string;
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
  price?: number;           // Override price
  comment?: string;         // Item comment
  positionId?: string;      // For updates
}

interface Payment {
  paymentTypeId: string;
  paymentTypeKind: 'Cash' | 'Card' | 'External';
  sum: number;
  isProcessedExternally: boolean;
}
```

### Response

```json
{
  "correlationId": "uuid",
  "orderInfo": {
    "id": "order-uuid",
    "posId": "pos-uuid",
    "externalNumber": "QR-001",
    "organizationId": "org-uuid",
    "timestamp": 1704067200,
    "creationStatus": "Success",
    "errorInfo": null
  }
}
```

---

## Retrieve Orders

### By Order ID
`POST /orders/by_id`

```json
{
  "organizationIds": ["org-uuid"],
  "orderIds": ["order-uuid"]
}
```

### By Table
`POST /orders/by_table`

Get current orders on specific tables.

```json
{
  "organizationIds": ["org-uuid"],
  "tableIds": ["table-uuid"],
  "statuses": ["New", "Bill", "Closed"],
  "dateFrom": "2024-01-01",
  "dateTo": "2024-01-31"
}
```

### Order Response

```typescript
interface TableOrderInfo {
  id: string;
  posId: string;
  externalNumber: string;
  organizationId: string;
  terminalGroupId: string;

  // Tables
  tableIds: string[];

  // Status
  status: TableOrderStatus;

  // Customer
  customer?: {
    id: string;
    name: string;
    phone: string;
  };
  guests: {
    count: number;
  };

  // Items
  items: OrderItem[];

  // Payments
  payments: Payment[];

  // Financials
  sum: number;
  discount: number;

  // Timestamps
  createdAt: string;
  closedAt: string | null;
}

type TableOrderStatus =
  | 'New'           // Order created
  | 'Bill'          // Bill printed
  | 'Closed'        // Paid and closed
  | 'Deleted';      // Cancelled
```

---

## Add Items to Order

`POST /orders/add_items`

Add more items to existing order.

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "items": [
    {
      "productId": "dessert-uuid",
      "type": "Product",
      "amount": 2
    }
  ]
}
```

---

## Close Order

`POST /orders/close`

Close order after payment.

```json
{
  "organizationId": "org-uuid",
  "orderId": "order-uuid",
  "payments": [
    {
      "paymentTypeId": "card-uuid",
      "paymentTypeKind": "Card",
      "sum": 1500,
      "isProcessedExternally": true
    }
  ]
}
```

---

## QR Menu Workflow

### 1. Generate QR Code

```typescript
// QR contains table identifier
const qrData = {
  restaurantId: 'org-uuid',
  terminalId: 'terminal-uuid',
  tableId: 'table-uuid'
};

const qrUrl = `https://menu.example.com/order?${new URLSearchParams({
  r: qrData.restaurantId,
  t: qrData.terminalId,
  table: qrData.tableId
})}`;
```

### 2. Customer Scans QR

```typescript
// Parse QR parameters
const params = new URLSearchParams(window.location.search);
const tableId = params.get('table');
const terminalId = params.get('t');
const restaurantId = params.get('r');

// Load menu
const menu = await syrveClient.getNomenclature(restaurantId);
```

### 3. Customer Orders

```typescript
async function submitOrder(
  cart: CartItem[],
  tableId: string
): Promise<string> {
  const order = await syrveClient.createTableOrder({
    organizationId: restaurantId,
    terminalGroupId: terminalId,
    order: {
      tableIds: [tableId],
      externalNumber: `QR-${Date.now()}`,
      items: cart.map(item => ({
        productId: item.productId,
        type: 'Product',
        amount: item.quantity,
        modifiers: item.modifiers
      })),
      guests: { count: 1 }
    }
  });

  return order.orderInfo.id;
}
```

### 4. Track Order Status

```typescript
async function pollOrderStatus(orderId: string) {
  const interval = setInterval(async () => {
    const order = await syrveClient.getOrderById(
      restaurantId,
      orderId
    );

    updateUI(order.status);

    if (order.status === 'Closed') {
      clearInterval(interval);
    }
  }, 10000); // Poll every 10 seconds
}
```

### 5. Payment

```typescript
// Option 1: Pay at counter
// Just show order number to customer

// Option 2: Online payment
async function processPayment(orderId: string, amount: number) {
  // 1. Process payment via your payment provider
  const paymentResult = await stripePayment(amount);

  // 2. Close order in Syrve
  await syrveClient.closeOrder({
    organizationId: restaurantId,
    orderId: orderId,
    payments: [{
      paymentTypeId: 'external-payment-uuid',
      paymentTypeKind: 'External',
      sum: amount,
      isProcessedExternally: true
    }]
  });
}
```

---

## Complete QR Menu Client

```typescript
class SyrveTableOrderClient {
  private baseUrl = 'https://api-ru.iiko.services/api/1';
  private token: string;
  private organizationId: string;
  private terminalGroupId: string;

  async getTables(): Promise<Table[]> {
    const res = await this.post('/reserve/available_restaurant_sections', {
      terminalGroupIds: [this.terminalGroupId],
      returnSchema: true
    });

    return res.restaurantSections[0]?.items.flatMap(
      section => section.tables
    ) ?? [];
  }

  async createOrder(
    tableId: string,
    items: OrderItem[],
    externalNumber?: string
  ): Promise<OrderInfo> {
    const res = await this.post('/orders/create', {
      organizationId: this.organizationId,
      terminalGroupId: this.terminalGroupId,
      order: {
        tableIds: [tableId],
        items,
        externalNumber: externalNumber ?? `QR-${Date.now()}`
      }
    });

    if (res.orderInfo.creationStatus === 'Error') {
      throw new Error(res.orderInfo.errorInfo?.message);
    }

    return res.orderInfo;
  }

  async getOrder(orderId: string): Promise<TableOrderInfo> {
    const res = await this.post('/orders/by_id', {
      organizationIds: [this.organizationId],
      orderIds: [orderId]
    });

    return res.orders[0];
  }

  async addItems(orderId: string, items: OrderItem[]): Promise<void> {
    await this.post('/orders/add_items', {
      organizationId: this.organizationId,
      orderId,
      items
    });
  }

  async closeOrder(
    orderId: string,
    payments: Payment[]
  ): Promise<void> {
    await this.post('/orders/close', {
      organizationId: this.organizationId,
      orderId,
      payments
    });
  }

  private async post(endpoint: string, body: object): Promise<any> {
    const res = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    });

    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  }
}
```

---

## Webhooks for Table Orders

Subscribe to `TableOrderUpdate` events:

```typescript
interface TableOrderUpdateEvent {
  eventType: 'TableOrderUpdate';
  eventTime: string;
  organizationId: string;
  correlationId: string;
  eventInfo: TableOrderInfo;
}
```

Handle in webhook:

```typescript
if (event.eventType === 'TableOrderUpdate') {
  const { eventInfo } = event;

  // Notify kitchen display
  if (eventInfo.status === 'New') {
    await notifyKitchen(eventInfo);
  }

  // Notify customer
  await updateOrderStatus(eventInfo.id, eventInfo.status);
}
```

---

## Best Practices

1. **Cache tables** - Sections/tables change rarely
2. **Use externalNumber** - Track orders in your system
3. **Handle multiple tables** - Party can span tables
4. **Check stop-lists** - Before showing menu
5. **Poll status** - Or use webhooks for real-time

---

## Related Skills

- `syrve-api.md` - Authentication, organizations
- `syrve-menu.md` - Product catalog for QR menu
- `syrve-webhooks.md` - Real-time order updates
- `syrve-customers.md` - Link orders to loyalty
