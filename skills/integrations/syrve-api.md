---
name: syrve-api
description: Syrve Cloud API (iikoTransport) integration - authentication, organizations, dictionaries
category: integrations
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

| Region | URL |
|--------|-----|
| Russia | `https://api-ru.iiko.services/api/1/` |
| Europe | `https://api-eu.iiko.services/api/1/` |

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

## Quick Reference

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Get Token | `/access_token` | POST |
| Organizations | `/organizations` | POST |
| Terminal Groups | `/terminal_groups` | POST |
| Terminal Status | `/terminal_groups/is_alive` | POST |
| Order Types | `/deliveries/order_types` | POST |
| Payment Types | `/payment_types` | POST |
| Cancel Causes | `/deliveries/cancel_causes` | POST |
| Discounts | `/discounts` | POST |
| Regions | `/regions` | POST |
| Cities | `/cities` | POST |
| Streets | `/streets/by_city` | POST |
