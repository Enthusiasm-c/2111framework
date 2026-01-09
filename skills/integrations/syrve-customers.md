---
name: syrve-customers
description: Syrve Cloud API customers - loyalty, wallets, coupons
category: integrations
updated: 2026-01-09
model: sonnet
forked_context: false
---

# Syrve Customers API

Complete reference for customer and loyalty operations in Syrve Cloud API.

## When to Use
- Customer management (CRM)
- Loyalty program integration
- Wallet/balance operations
- Coupon validation

---

## Customer Information

### Get Customer by Phone
`POST /loyalty/iiko/customer/info`

```json
{
  "organizationId": "org-uuid",
  "type": "phone",
  "phone": "+79001234567"
}
```

### Get Customer by ID
`POST /loyalty/iiko/customer/info`

```json
{
  "organizationId": "org-uuid",
  "type": "id",
  "id": "customer-uuid"
}
```

### Get Customer by Card
`POST /loyalty/iiko/customer/info`

```json
{
  "organizationId": "org-uuid",
  "type": "card",
  "cardTrack": "1234567890",
  "cardNumber": "1234567890"
}
```

### Response

```typescript
interface CustomerInfo {
  id: string;
  referrerId: string | null;
  name: string;
  surname: string;
  middleName: string;
  phone: string;
  email: string;
  birthday: string | null; // YYYY-MM-DD
  sex: 'Male' | 'Female' | 'NotSpecified';

  // Loyalty
  walletBalances: WalletBalance[];
  cards: Card[];
  categories: Category[];

  // Programs
  programId: string;
  programName: string;

  // Marketing
  shouldReceiveOrderStatusNotifications: boolean;
  shouldReceivePromoActionsInfo: boolean;

  // Consent
  personalDataProcessingConsentFrom: string | null;
  personalDataProcessingConsentTo: string | null;
}

interface WalletBalance {
  id: string;
  name: string;
  type: number;
  balance: number;
}

interface Card {
  id: string;
  track: string;
  number: string;
  validToDate: string | null;
}

interface Category {
  id: string;
  name: string;
  isActive: boolean;
  isDefaultForNewGuests: boolean;
}
```

---

## Create or Update Customer

`POST /loyalty/iiko/customer/create_or_update`

### Create New Customer

```json
{
  "organizationId": "org-uuid",
  "phone": "+79001234567",
  "name": "Ivan",
  "surname": "Petrov",
  "birthday": "1990-05-15",
  "email": "ivan@example.com",
  "sex": "Male",
  "shouldReceiveOrderStatusNotifications": true,
  "shouldReceivePromoActionsInfo": false
}
```

### Update Existing Customer

```json
{
  "organizationId": "org-uuid",
  "id": "customer-uuid",
  "name": "Ivan",
  "surname": "Petrov",
  "email": "new-email@example.com"
}
```

### Response

```json
{
  "correlationId": "uuid",
  "id": "customer-uuid"
}
```

---

## Loyalty Programs

### Add Customer to Program
`POST /loyalty/iiko/customer/program/add`

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "programId": "program-uuid"
}
```

### Add Loyalty Card
`POST /loyalty/iiko/customer/card/add`

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "cardTrack": "1234567890",
  "cardNumber": "1234567890"
}
```

### Remove Loyalty Card
`POST /loyalty/iiko/customer/card/remove`

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "cardTrack": "1234567890"
}
```

### Add to Category
`POST /loyalty/iiko/customer/category/add`

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "categoryId": "vip-category-uuid"
}
```

---

## Wallet Operations

### Hold Funds (Reserve)
`POST /loyalty/iiko/customer/wallet/hold`

Reserve funds for order payment.

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "walletId": "wallet-uuid",
  "sum": 500,
  "comment": "Order #12345"
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "transactionId": "transaction-uuid"
}
```

### Cancel Hold
`POST /loyalty/iiko/customer/wallet/cancel_hold`

```json
{
  "organizationId": "org-uuid",
  "transactionId": "transaction-uuid"
}
```

### Top Up Balance
`POST /loyalty/iiko/customer/wallet/topup`

Add funds to customer wallet.

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "walletId": "wallet-uuid",
  "sum": 1000,
  "comment": "Bonus points"
}
```

### Charge Off (Deduct)
`POST /loyalty/iiko/customer/wallet/chargeoff`

Deduct funds from wallet.

```json
{
  "organizationId": "org-uuid",
  "customerId": "customer-uuid",
  "walletId": "wallet-uuid",
  "sum": 200,
  "comment": "Order payment"
}
```

---

## Coupons

### Get Coupon Info
`POST /loyalty/iiko/coupons/info`

```json
{
  "organizationId": "org-uuid",
  "number": "PROMO2024"
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "couponInfo": {
    "id": "coupon-uuid",
    "number": "PROMO2024",
    "seriesId": "series-uuid",
    "seriesName": "New Year Promo",
    "isUsed": false,
    "whenActivated": null,
    "activatedBy": null,
    "notAfterDateBecomesApplied": "2024-12-31T23:59:59"
  }
}
```

### Get Coupon Series
`POST /loyalty/iiko/coupons/series`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "couponSeries": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "series-uuid",
          "name": "New Year Promo",
          "isActivated": true,
          "discountType": "Percent",
          "discountValue": 10
        }
      ]
    }
  ]
}
```

---

## TypeScript Client

```typescript
class SyrveCustomerClient {
  private baseUrl = 'https://api-ru.iiko.services/api/1';
  private token: string;

  async getCustomer(
    organizationId: string,
    phone: string
  ): Promise<CustomerInfo | null> {
    const res = await fetch(`${this.baseUrl}/loyalty/iiko/customer/info`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        organizationId,
        type: 'phone',
        phone
      })
    });

    if (!res.ok) return null;
    return res.json();
  }

  async createOrUpdateCustomer(
    organizationId: string,
    data: Partial<CustomerInfo>
  ): Promise<string> {
    const res = await fetch(
      `${this.baseUrl}/loyalty/iiko/customer/create_or_update`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ organizationId, ...data })
      }
    );

    const result = await res.json();
    return result.id;
  }

  async topUpWallet(
    organizationId: string,
    customerId: string,
    walletId: string,
    sum: number,
    comment?: string
  ): Promise<void> {
    await fetch(`${this.baseUrl}/loyalty/iiko/customer/wallet/topup`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        organizationId,
        customerId,
        walletId,
        sum,
        comment
      })
    });
  }

  async validateCoupon(
    organizationId: string,
    couponCode: string
  ): Promise<CouponInfo | null> {
    const res = await fetch(`${this.baseUrl}/loyalty/iiko/coupons/info`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        organizationId,
        number: couponCode
      })
    });

    if (!res.ok) return null;
    const data = await res.json();
    return data.couponInfo;
  }
}
```

---

## Integration Patterns

### Customer Sync on Order

```typescript
async function ensureCustomer(
  organizationId: string,
  phone: string,
  name?: string
): Promise<string> {
  // Try to find existing customer
  let customer = await syrveClient.getCustomer(organizationId, phone);

  if (!customer) {
    // Create new customer
    const customerId = await syrveClient.createOrUpdateCustomer(
      organizationId,
      { phone, name }
    );
    return customerId;
  }

  return customer.id;
}
```

### Wallet Payment Flow

```typescript
async function payWithWallet(
  organizationId: string,
  customerId: string,
  walletId: string,
  amount: number,
  orderId: string
): Promise<string> {
  // 1. Hold funds
  const { transactionId } = await syrveClient.holdWallet(
    organizationId,
    customerId,
    walletId,
    amount,
    `Order ${orderId}`
  );

  try {
    // 2. Process order...
    await processOrder(orderId);

    // 3. Charge off held funds
    await syrveClient.chargeOffWallet(
      organizationId,
      customerId,
      walletId,
      amount,
      `Order ${orderId} completed`
    );

    return transactionId;
  } catch (error) {
    // Cancel hold if order fails
    await syrveClient.cancelHold(organizationId, transactionId);
    throw error;
  }
}
```

---

## Best Practices

1. **Normalize phone numbers** - Use E.164 format
2. **Handle customer not found** - Create on first order
3. **Use hold for payments** - Cancel if order fails
4. **Validate coupons** - Check isUsed and expiry
5. **Sync customer data** - Update on each interaction

---

## Related Skills

- `syrve-api.md` - Authentication, organizations
- `syrve-delivery.md` - Link customer to orders
