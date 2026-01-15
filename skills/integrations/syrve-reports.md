---
name: syrve-reports
description: Syrve Cloud API reports - OLAP, analytics, sales data, dashboards
category: integrations
updated: 2026-01-15
model: sonnet
forked_context: false
---

# Syrve Reports API

Complete reference for reports and analytics in Syrve Cloud API.

## When to Use
- Sales dashboards
- Revenue analytics
- Product performance
- Employee reports
- Business intelligence

---

## OLAP Reports

`POST /resto/api/v2/reports/olap`

**Note:** OLAP uses the older Syrve API format (`/resto/api/`).

### Authentication

```bash
# Get session key
curl -X POST "https://host/resto/api/auth" \
  --data "login=USER&pass=SHA1_PASSWORD"

# Response: session key (36-char string)
```

### Request Structure

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["Department", "Waiter"],
  "groupByColFields": ["PayTypes"],
  "aggregateFields": ["DishDiscountSumInt", "ProductCostBase.OneItem"],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-31"
    },
    "Department": {
      "filterType": "IncludeValues",
      "values": ["Main Hall", "Terrace"]
    }
  }
}
```

### Report Types

| Report Type | Description |
|-------------|-------------|
| `SALES` | Sales by products, categories |
| `TRANSACTIONS` | Payment transactions |
| `DELIVERIES` | Delivery orders |
| `GUESTS` | Guest statistics |
| `EMPLOYEES` | Employee performance |

### Available Fields

#### Row/Column Fields
```
Department        - Restaurant section
Waiter            - Employee name
OrderType         - Dine-in, Delivery, etc.
PayTypes          - Cash, Card, etc.
DishGroup         - Product category
DishName          - Product name
OpenDate.Typed    - Order date
CloseTime         - Close time
Hour              - Hour of day
DayOfWeek         - Day of week
```

#### Aggregate Fields
```
DishSumInt              - Revenue
DishDiscountSumInt      - Discounts
ProductCostBase.OneItem - Cost price
DishAmountInt           - Quantity sold
OrderNum                - Number of orders
GuestsCount             - Guest count
AvgCheque               - Average check
UniqOrderId.OrdersCount - Unique orders
```

### Filter Types

```typescript
interface Filters {
  [fieldName: string]: FilterConfig;
}

type FilterConfig =
  | { filterType: 'DateRange'; from: string; to: string }
  | { filterType: 'IncludeValues'; values: string[] }
  | { filterType: 'ExcludeValues'; values: string[] }
  | { filterType: 'TopItems'; count: number };
```

---

## Example: Sales by Category

### Request

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["DishGroup"],
  "groupByColFields": [],
  "aggregateFields": [
    "DishSumInt",
    "DishAmountInt",
    "UniqOrderId.OrdersCount"
  ],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-31"
    }
  }
}
```

### Response

```json
{
  "data": [
    {
      "DishGroup": "Pizza",
      "DishSumInt": 125000,
      "DishAmountInt": 250,
      "UniqOrderId.OrdersCount": 180
    },
    {
      "DishGroup": "Drinks",
      "DishSumInt": 45000,
      "DishAmountInt": 500,
      "UniqOrderId.OrdersCount": 320
    }
  ],
  "summary": {
    "DishSumInt": 170000,
    "DishAmountInt": 750,
    "UniqOrderId.OrdersCount": 500
  }
}
```

---

## Example: Daily Sales

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["OpenDate.Typed"],
  "groupByColFields": [],
  "aggregateFields": [
    "DishSumInt",
    "UniqOrderId.OrdersCount",
    "GuestsCount"
  ],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-07"
    }
  }
}
```

---

## Example: Waiter Performance

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["Waiter"],
  "groupByColFields": [],
  "aggregateFields": [
    "DishSumInt",
    "UniqOrderId.OrdersCount",
    "AvgCheque"
  ],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-31"
    }
  }
}
```

---

## Example: Hourly Sales (Peak Hours)

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["Hour"],
  "groupByColFields": ["DayOfWeek"],
  "aggregateFields": ["DishSumInt", "UniqOrderId.OrdersCount"],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-31"
    }
  }
}
```

---

## Example: Top Products

```json
{
  "reportType": "SALES",
  "groupByRowFields": ["DishName"],
  "groupByColFields": [],
  "aggregateFields": [
    "DishSumInt",
    "DishAmountInt"
  ],
  "filters": {
    "OpenDate.Typed": {
      "filterType": "DateRange",
      "from": "2024-01-01",
      "to": "2024-01-31"
    },
    "DishName": {
      "filterType": "TopItems",
      "count": 10
    }
  }
}
```

---

## TypeScript Client

```typescript
class SyrveReportsClient {
  private baseUrl: string;
  private sessionKey: string;

  constructor(host: string) {
    this.baseUrl = `https://${host}/resto/api`;
  }

  async authenticate(login: string, passwordSha1: string): Promise<void> {
    const res = await fetch(`${this.baseUrl}/auth`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: `login=${login}&pass=${passwordSha1}`
    });

    this.sessionKey = await res.text();
  }

  async getOlapReport(config: OlapReportConfig): Promise<OlapResponse> {
    const res = await fetch(
      `${this.baseUrl}/v2/reports/olap?key=${this.sessionKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(config)
      }
    );

    return res.json();
  }

  // Convenience methods

  async getSalesByCategory(
    from: string,
    to: string
  ): Promise<CategorySales[]> {
    const result = await this.getOlapReport({
      reportType: 'SALES',
      groupByRowFields: ['DishGroup'],
      groupByColFields: [],
      aggregateFields: ['DishSumInt', 'DishAmountInt'],
      filters: {
        'OpenDate.Typed': { filterType: 'DateRange', from, to }
      }
    });

    return result.data;
  }

  async getDailySales(from: string, to: string): Promise<DailySales[]> {
    const result = await this.getOlapReport({
      reportType: 'SALES',
      groupByRowFields: ['OpenDate.Typed'],
      groupByColFields: [],
      aggregateFields: [
        'DishSumInt',
        'UniqOrderId.OrdersCount',
        'GuestsCount'
      ],
      filters: {
        'OpenDate.Typed': { filterType: 'DateRange', from, to }
      }
    });

    return result.data;
  }

  async getTopProducts(
    from: string,
    to: string,
    limit: number = 10
  ): Promise<ProductSales[]> {
    const result = await this.getOlapReport({
      reportType: 'SALES',
      groupByRowFields: ['DishName'],
      groupByColFields: [],
      aggregateFields: ['DishSumInt', 'DishAmountInt'],
      filters: {
        'OpenDate.Typed': { filterType: 'DateRange', from, to },
        'DishName': { filterType: 'TopItems', count: limit }
      }
    });

    return result.data;
  }
}

interface OlapReportConfig {
  reportType: 'SALES' | 'TRANSACTIONS' | 'DELIVERIES' | 'GUESTS';
  groupByRowFields: string[];
  groupByColFields: string[];
  aggregateFields: string[];
  filters: Record<string, FilterConfig>;
}

interface OlapResponse {
  data: Record<string, any>[];
  summary: Record<string, number>;
}
```

---

## Dashboard Integration

### Next.js API Route

```typescript
// app/api/reports/sales/route.ts
import { NextRequest, NextResponse } from 'next/server';

const reportsClient = new SyrveReportsClient(process.env.SYRVE_HOST!);

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const from = searchParams.get('from') ?? getLastWeek();
  const to = searchParams.get('to') ?? getToday();

  await reportsClient.authenticate(
    process.env.SYRVE_LOGIN!,
    process.env.SYRVE_PASSWORD_SHA1!
  );

  const [dailySales, topProducts, byCategory] = await Promise.all([
    reportsClient.getDailySales(from, to),
    reportsClient.getTopProducts(from, to, 10),
    reportsClient.getSalesByCategory(from, to)
  ]);

  return NextResponse.json({
    dailySales,
    topProducts,
    byCategory,
    period: { from, to }
  });
}
```

### React Dashboard Component

```typescript
'use client';

import { useQuery } from '@tanstack/react-query';
import { BarChart, LineChart } from 'recharts';

export function SalesDashboard() {
  const { data, isLoading } = useQuery({
    queryKey: ['sales-report'],
    queryFn: () => fetch('/api/reports/sales').then(r => r.json())
  });

  if (isLoading) return <Skeleton />;

  return (
    <div className="grid gap-4 md:grid-cols-2">
      <Card>
        <CardHeader>Daily Sales</CardHeader>
        <LineChart data={data.dailySales}>
          <XAxis dataKey="OpenDate.Typed" />
          <YAxis />
          <Line dataKey="DishSumInt" />
        </LineChart>
      </Card>

      <Card>
        <CardHeader>Top Products</CardHeader>
        <BarChart data={data.topProducts} layout="vertical">
          <XAxis type="number" />
          <YAxis dataKey="DishName" type="category" width={100} />
          <Bar dataKey="DishSumInt" />
        </BarChart>
      </Card>

      <Card>
        <CardHeader>Sales by Category</CardHeader>
        <PieChart>
          <Pie
            data={data.byCategory}
            dataKey="DishSumInt"
            nameKey="DishGroup"
          />
        </PieChart>
      </Card>
    </div>
  );
}
```

---

## Caching Strategy

```typescript
// Reports are expensive - cache aggressively
const CACHE_TTL = 15 * 60 * 1000; // 15 minutes

async function getCachedReport(
  key: string,
  fetcher: () => Promise<any>
): Promise<any> {
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  const data = await fetcher();
  await redis.setex(key, CACHE_TTL / 1000, JSON.stringify(data));
  return data;
}

// Usage
const dailySales = await getCachedReport(
  `sales:daily:${from}:${to}`,
  () => reportsClient.getDailySales(from, to)
);
```

---

## Best Practices

1. **Cache reports** - OLAP queries are heavy
2. **Use date ranges** - Always filter by date
3. **Aggregate server-side** - Don't fetch raw data
4. **Schedule reports** - Run overnight for dashboards
5. **Handle auth expiry** - Session key expires

---

## Common Report Queries

| Use Case | Row Fields | Aggregates |
|----------|------------|------------|
| Revenue by day | `OpenDate.Typed` | `DishSumInt` |
| Sales by category | `DishGroup` | `DishSumInt`, `DishAmountInt` |
| Waiter performance | `Waiter` | `DishSumInt`, `AvgCheque` |
| Peak hours | `Hour` | `UniqOrderId.OrdersCount` |
| Payment breakdown | `PayTypes` | `DishSumInt` |
| Delivery stats | `OrderType` | `UniqOrderId.OrdersCount` |

---

## Related Skills

- `syrve-api.md` - Authentication
- `syrve-delivery.md` - Delivery order data
- `syrve-table-orders.md` - Table order data
