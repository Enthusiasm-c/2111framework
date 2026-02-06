---
name: syrve-api
description: Syrve Cloud API (iikoTransport) integration - authentication, organizations, dictionaries
model: sonnet
---

# Syrve Cloud API Integration

Complete reference for Syrve Cloud API (formerly iiko Cloud API / iikoTransport).

## When to Use
- Delivery platform integration
- Restaurant POS connectivity
- Menu synchronization
- Order management
- Customer loyalty programs

## Base URLs

### API v1 (Legacy)
| Region | URL |
|--------|-----|
| Russia | `https://api-ru.iiko.services/api/1/` |
| Europe | `https://api-eu.iiko.services/api/1/` |

### API v2 (Current - External Menus)
| Region | URL |
|--------|-----|
| Europe | `https://api-eu.syrve.live/api/2/` |

**Important**: Use API v2 for External Menus. API v1 `/external_menus` requires Enterprise license.

---

## License Tiers (Europe Pricing)

| Tier | Price | API Access |
|------|-------|------------|
| **Basic** | €49/mo | Limited (menu read only) |
| **Pro** | €69/mo | + Inventory API |
| **Enterprise** | €99/mo | + Full API (Order injection, Loyalty, Reporting) |

### API Access by Endpoint

| Endpoint | Basic | Pro | Enterprise |
|----------|-------|-----|------------|
| `/nomenclature` | ✅ | ✅ | ✅ |
| API v2 `/menu` | ✅ | ✅ | ✅ |
| API v2 `/menu/by_id` | ✅ | ✅ | ✅ |
| API v1 `/external_menus` | ❌ | ❌ | ✅ |
| `/deliveries/create` | ❌ | ❌ | ✅ |
| Inventory API | ❌ | ✅ | ✅ |
| Order injection API | ❌ | ❌ | ✅ |

**Recommendation**: Always use API v2 (`api-eu.syrve.live`) for menu access on all tiers.

---

## Authentication

### Get Access Token
`POST /access_token`

```bash
curl -X POST "https://api-ru.iiko.services/api/1/access_token" \
  -H "Content-Type: application/json" \
  -d '{"apiLogin": "YOUR_API_KEY"}'
```

**Response:**
```json
{
  "correlationId": "uuid",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Token Management
- Token expires in **~60 minutes**
- Store token, refresh before expiry
- Pass token in `Authorization: Bearer TOKEN` header

```typescript
interface AuthResponse {
  correlationId: string;
  token: string;
}

// Token refresh strategy
const TOKEN_REFRESH_INTERVAL = 50 * 60 * 1000; // 50 minutes

async function getToken(apiLogin: string): Promise<string> {
  const res = await fetch(`${BASE_URL}/access_token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ apiLogin })
  });
  const data: AuthResponse = await res.json();
  return data.token;
}
```

---

## Organizations & Terminals

### Get Organizations
`POST /organizations`

Returns all organizations available for the API key.

```bash
curl -X POST "https://api-ru.iiko.services/api/1/organizations" \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Response:**
```json
{
  "correlationId": "uuid",
  "organizations": [
    {
      "id": "org-uuid",
      "name": "Restaurant Name",
      "country": "Russia",
      "restaurantAddress": "Address",
      "latitude": 55.7558,
      "longitude": 37.6173,
      "useUaeAddressingSystem": false,
      "version": "8.5.1",
      "currencyIsoName": "RUB",
      "currencyMinimumDenomination": 0.01
    }
  ]
}
```

### Get Terminal Groups
`POST /terminal_groups`

```json
{
  "organizationIds": ["org-uuid"],
  "includeDisabled": false
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "terminalGroups": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "terminal-group-uuid",
          "name": "Delivery Terminal",
          "address": "Address"
        }
      ]
    }
  ]
}
```

### Check Terminal Availability
`POST /terminal_groups/is_alive`

```json
{
  "organizationIds": ["org-uuid"],
  "terminalGroupIds": ["terminal-group-uuid"]
}
```

---

## Dictionaries

### Order Types
`POST /deliveries/order_types`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "orderTypes": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "order-type-uuid",
          "name": "Delivery",
          "orderServiceType": "DeliveryByCourier"
        }
      ]
    }
  ]
}
```

**Service Types:**
- `Common` - Regular order
- `DeliveryByCourier` - Courier delivery
- `DeliveryPickUp` - Customer pickup

### Payment Types
`POST /payment_types`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response includes:**
- `id` - Payment type UUID
- `code` - Payment code
- `name` - Display name
- `paymentTypeKind` - Cash, Card, External, etc.

### Cancel Causes
`POST /deliveries/cancel_causes`

Returns reasons for order cancellation.

### Discounts
`POST /discounts`

Returns available discounts and surcharges.

---

## Addresses

### Get Regions
`POST /regions`

```json
{
  "organizationIds": ["org-uuid"]
}
```

### Get Cities
`POST /cities`

```json
{
  "organizationIds": ["org-uuid"]
}
```

### Get Streets
`POST /streets/by_city`

```json
{
  "organizationId": "org-uuid",
  "cityId": "city-uuid"
}
```

---

## Error Handling

### HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process response |
| 400 | Bad Request | Check request format |
| 401 | Unauthorized | Refresh token |
| 403 | Forbidden | Check API permissions |
| 404 | Not Found | Check endpoint/IDs |
| 429 | Rate Limited | Backoff and retry |
| 500 | Server Error | Retry with backoff |

### Error Response Format
```json
{
  "correlationId": "uuid",
  "errorDescription": "Error message",
  "error": "ErrorCode"
}
```

### Retry Strategy
```typescript
async function fetchWithRetry<T>(
  url: string,
  options: RequestInit,
  retries = 3
): Promise<T> {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url, options);
      if (res.status === 401) {
        // Refresh token and retry
        options.headers = {
          ...options.headers,
          Authorization: `Bearer ${await getToken(API_LOGIN)}`
        };
        continue;
      }
      if (res.status === 429) {
        // Rate limited - exponential backoff
        await sleep(Math.pow(2, i) * 1000);
        continue;
      }
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return res.json();
    } catch (e) {
      if (i === retries - 1) throw e;
      await sleep(Math.pow(2, i) * 1000);
    }
  }
  throw new Error('Max retries exceeded');
}
```

---

## Rate Limiting

- Default: **60 requests per minute** per API key
- Bulk operations may have stricter limits
- Use `correlationId` for request tracking
- Implement exponential backoff

---

## Best Practices

1. **Cache Reference Data**
   - Organizations, terminals, dictionaries change rarely
   - Cache for 1+ hours, refresh on demand

2. **Batch Requests**
   - Use array parameters where supported
   - Minimize API calls

3. **Handle Token Expiry**
   - Refresh proactively (50 min)
   - Retry on 401 with new token

4. **Log correlationId**
   - Every response includes it
   - Essential for debugging with Syrve support

---

## Related Skills

For domain-specific operations:
- `syrve-delivery.md` - Delivery orders, couriers, zones
- `syrve-menu.md` - Nomenclature, stop-lists, combos
- `syrve-customers.md` - Loyalty, wallets, coupons
- `syrve-webhooks.md` - Event subscriptions

---

## Complete Endpoint Reference

**OpenAPI Spec**: https://api-eu.syrve.live/api-docs/docs

### Authorization
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/access_token` | Retrieve session key for API user |

### Organizations & Terminals
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/organizations` | Returns organizations available to api-login |
| `POST /api/1/organizations/settings` | Returns organization settings |
| `POST /api/1/terminal_groups` | Terminal groups info |
| `POST /api/1/terminal_groups/is_alive` | Check terminal availability |
| `POST /api/1/terminal_groups/awake` | Awake terminals from sleep mode |

### Menu (API v2 Recommended)
| Endpoint | Description |
|----------|-------------|
| `POST /api/2/menu` | External menus with price categories |
| `POST /api/2/menu/by_id` | Retrieve external menu by ID |
| `POST /api/1/nomenclature` | Full product catalog (legacy) |
| `POST /api/1/stop_lists` | Out-of-stock items |
| `POST /api/1/stop_lists/check` | Check items in stop-list |
| `POST /api/1/stop_lists/add` | Add items to stop-list |
| `POST /api/1/stop_lists/remove` | Remove from stop-list |
| `POST /api/1/combo` | Get combos info |
| `POST /api/1/combo/calculate` | Calculate combo price |

### Deliveries: Create & Update
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/deliveries/create` | Create delivery |
| `POST /api/1/deliveries/add_items` | Add order items |
| `POST /api/1/deliveries/close` | Close order |
| `POST /api/1/deliveries/cancel` | Cancel delivery |
| `POST /api/1/deliveries/confirm` | Confirm delivery |
| `POST /api/1/deliveries/update_order_courier` | Update courier |
| `POST /api/1/deliveries/update_order_delivery_status` | Update status |
| `POST /api/1/deliveries/change_complete_before` | Change delivery time |
| `POST /api/1/deliveries/change_delivery_point` | Change address |
| `POST /api/1/deliveries/change_payments` | Change payments |
| `POST /api/1/deliveries/add_payments` | Add payments |
| `POST /api/1/deliveries/print_delivery_bill` | Print bill |

### Deliveries: Retrieve
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/deliveries/by_id` | Retrieve by IDs |
| `POST /api/1/deliveries/by_delivery_date_and_status` | By status and date |
| `POST /api/1/deliveries/by_revision` | By revision |
| `POST /api/1/deliveries/by_delivery_date_and_phone` | By phone and date |

### Table Orders
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/order/create` | Create table order |
| `POST /api/1/order/by_id` | Retrieve by IDs |
| `POST /api/1/order/by_table` | Retrieve by tables |
| `POST /api/1/order/add_items` | Add items |
| `POST /api/1/order/close` | Close order |
| `POST /api/1/order/cancel` | Cancel order |
| `POST /api/1/order/add_customer` | Add customer |
| `POST /api/1/order/add_payments` | Add payments |

### Banquets & Reserves
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/reserve/create` | Create banquet/reserve |
| `POST /api/1/reserve/status_by_id` | Get status |
| `POST /api/1/reserve/cancel` | Cancel reservation |
| `POST /api/1/reserve/available_organizations` | Available orgs |
| `POST /api/1/reserve/available_terminal_groups` | Available terminals |
| `POST /api/1/reserve/restaurant_sections_workload` | Sections workload |

### Customers & Loyalty
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/loyalty/syrve/customer/info` | Get customer info |
| `POST /api/1/loyalty/syrve/customer/create_or_update` | Create/update customer |
| `POST /api/1/loyalty/syrve/customer/program/add` | Add to program |
| `POST /api/1/loyalty/syrve/customer/card/add` | Add card |
| `POST /api/1/loyalty/syrve/customer/wallet/topup` | Refill balance |
| `POST /api/1/loyalty/syrve/customer/wallet/chargeoff` | Withdraw balance |
| `POST /api/1/loyalty/syrve/calculate` | Calculate checkin |
| `POST /api/1/loyalty/syrve/coupons/info` | Get coupon info |

### Employees & Couriers
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/employees/couriers` | List couriers |
| `POST /api/1/employees/couriers/active_location` | Active locations |
| `POST /api/1/employees/info` | Employee info |
| `POST /api/1/employees/shift/clockin` | Open session |
| `POST /api/1/employees/shift/clockout` | Close session |

### Dictionaries
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/deliveries/order_types` | Order types |
| `POST /api/1/payment_types` | Payment types |
| `POST /api/1/cancel_causes` | Cancel causes |
| `POST /api/1/discounts` | Discounts/surcharges |
| `POST /api/1/removal_types` | Removal types |
| `POST /api/1/marketing_sources` | Marketing sources |

### Addresses
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/regions` | Regions |
| `POST /api/1/cities` | Cities |
| `POST /api/1/streets/by_city` | Streets by city |

### Webhooks
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/webhooks/settings` | Get webhook settings |
| `POST /api/1/webhooks/update_settings` | Update webhook settings |

### Operations
| Endpoint | Description |
|----------|-------------|
| `POST /api/1/commands/status` | Get command status |
| `POST /api/1/notifications/send` | Send notification |

---

## Quick Reference

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Get Token | `/access_token` | POST |
| Organizations | `/organizations` | POST |
| Terminal Groups | `/terminal_groups` | POST |
| Terminal Status | `/terminal_groups/is_alive` | POST |
| **Menu List (v2)** | `/api/2/menu` | POST |
| **Menu by ID (v2)** | `/api/2/menu/by_id` | POST |
| Nomenclature (v1) | `/nomenclature` | POST |
| Stop Lists | `/stop_lists` | POST |
| Create Delivery | `/deliveries/create` | POST |
| Create Table Order | `/order/create` | POST |
| Customer Info | `/loyalty/syrve/customer/info` | POST |
