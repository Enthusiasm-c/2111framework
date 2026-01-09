---
name: syrve-marketing
description: Syrve Cloud API marketing - loyalty programs, promotions, discounts, coupons
category: integrations
updated: 2026-01-09
model: sonnet
forked_context: false
---

# Syrve Marketing API

Complete reference for loyalty programs, promotions, and marketing features.

## When to Use
- Loyalty program integration
- Discount calculations
- Coupon validation
- Promotional campaigns
- Customer rewards

---

## Loyalty Programs

### Get Programs
`POST /loyalty/iiko/program`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "programs": [
    {
      "id": "program-uuid",
      "name": "Gold Rewards",
      "description": "Earn points on every purchase",
      "isActive": true,
      "marketingCampaigns": [
        {
          "id": "campaign-uuid",
          "name": "Double Points Weekend",
          "isActive": true
        }
      ],
      "wallets": [
        {
          "id": "wallet-uuid",
          "name": "Bonus Points",
          "type": 1
        }
      ]
    }
  ]
}
```

### TypeScript Types

```typescript
interface LoyaltyProgram {
  id: string;
  name: string;
  description: string;
  isActive: boolean;
  marketingCampaigns: MarketingCampaign[];
  wallets: Wallet[];
}

interface MarketingCampaign {
  id: string;
  name: string;
  description: string;
  isActive: boolean;
  periodFrom: string | null;
  periodTo: string | null;
}

interface Wallet {
  id: string;
  name: string;
  type: WalletType;
}

enum WalletType {
  Bonus = 1,
  Cashback = 2,
  Discount = 3
}
```

---

## Discounts

### Get Available Discounts
`POST /discounts`

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "discounts": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "discount-uuid",
          "name": "Happy Hour 20%",
          "percent": 20,
          "isCategorisedDiscount": false,
          "productCategoryDiscounts": [],
          "comment": "Valid 4-6 PM",
          "canBeAppliedSelectively": true,
          "minOrderSum": 0,
          "mode": "Percent",
          "sum": 0,
          "canApplyByCardNumber": false,
          "isManual": true,
          "isCard": false,
          "isAutomatic": false
        }
      ]
    }
  ]
}
```

### Discount Types

```typescript
interface Discount {
  id: string;
  name: string;
  comment: string;

  // Discount value
  mode: 'Percent' | 'FixedSum';
  percent: number;        // If mode = Percent
  sum: number;            // If mode = FixedSum

  // Application rules
  minOrderSum: number;
  canBeAppliedSelectively: boolean;  // Per item
  isCategorisedDiscount: boolean;
  productCategoryDiscounts: CategoryDiscount[];

  // Trigger type
  isManual: boolean;      // Staff applies
  isAutomatic: boolean;   // System applies
  isCard: boolean;        // Loyalty card
  canApplyByCardNumber: boolean;
}

interface CategoryDiscount {
  categoryId: string;
  categoryName: string;
  percent: number;
}
```

---

## Calculate Order Discounts

`POST /loyalty/iiko/calculate`

Calculate discounts and loyalty for an order before submission.

### Request

```json
{
  "organizationId": "org-uuid",
  "order": {
    "id": "temp-order-uuid",
    "items": [
      {
        "productId": "pizza-uuid",
        "amount": 2,
        "price": 500
      }
    ],
    "payments": [],
    "customer": {
      "id": "customer-uuid"
    },
    "coupon": "PROMO2024"
  }
}
```

### Response

```json
{
  "correlationId": "uuid",
  "loyaltyInfo": {
    "appliedPromotions": [
      {
        "id": "promo-uuid",
        "name": "10% for loyalty members",
        "discountSum": 100
      }
    ],
    "appliedCoupon": {
      "id": "coupon-uuid",
      "code": "PROMO2024",
      "discountSum": 50
    },
    "availableWalletBalance": 500,
    "suggestedWalletPayment": 150,
    "totalDiscount": 150,
    "finalSum": 850
  }
}
```

---

## Manual Conditions

### Get Manual Conditions
`POST /loyalty/iiko/manual_condition`

Get conditions that staff can manually apply.

```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "manualConditions": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "condition-uuid",
          "name": "Birthday Discount",
          "description": "15% off on customer birthday",
          "canBeAppliedAutomatically": false,
          "canBeAppliedByCardNumber": false
        }
      ]
    }
  ]
}
```

---

## Coupons (Extended)

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
          "name": "New Year 2024",
          "isActivated": true,
          "couponCount": 1000,
          "usedCouponCount": 450,
          "discountType": "Percent",
          "discountPercent": 15,
          "discountSum": 0,
          "validFrom": "2024-01-01",
          "validTo": "2024-01-31"
        }
      ]
    }
  ]
}
```

### Validate Coupon
`POST /loyalty/iiko/coupons/info`

```json
{
  "organizationId": "org-uuid",
  "number": "NY2024-ABC123"
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "couponInfo": {
    "id": "coupon-uuid",
    "number": "NY2024-ABC123",
    "seriesId": "series-uuid",
    "seriesName": "New Year 2024",
    "isUsed": false,
    "whenActivated": null,
    "notAfterDateBecomesApplied": "2024-01-31T23:59:59"
  }
}
```

### TypeScript Types

```typescript
interface CouponSeries {
  id: string;
  name: string;
  isActivated: boolean;
  couponCount: number;
  usedCouponCount: number;

  // Discount
  discountType: 'Percent' | 'FixedSum';
  discountPercent: number;
  discountSum: number;

  // Validity
  validFrom: string;
  validTo: string;
}

interface Coupon {
  id: string;
  number: string;
  seriesId: string;
  seriesName: string;
  isUsed: boolean;
  whenActivated: string | null;
  notAfterDateBecomesApplied: string;
}

interface CouponValidation {
  isValid: boolean;
  errorCode?: 'EXPIRED' | 'USED' | 'NOT_FOUND' | 'INACTIVE';
  discount?: {
    type: 'Percent' | 'FixedSum';
    value: number;
  };
}
```

---

## Apply Discounts to Order

### With Coupon

```json
{
  "organizationId": "org-uuid",
  "terminalGroupId": "terminal-uuid",
  "order": {
    "items": [...],
    "discountsInfo": {
      "discounts": [],
      "coupon": "PROMO2024"
    }
  }
}
```

### With Manual Discount

```json
{
  "organizationId": "org-uuid",
  "terminalGroupId": "terminal-uuid",
  "order": {
    "items": [...],
    "discountsInfo": {
      "discounts": [
        {
          "discountTypeId": "discount-uuid",
          "sum": 100
        }
      ]
    }
  }
}
```

### With Selective Discount (Per Item)

```json
{
  "organizationId": "org-uuid",
  "terminalGroupId": "terminal-uuid",
  "order": {
    "items": [
      {
        "productId": "pizza-uuid",
        "type": "Product",
        "amount": 1,
        "positionId": "pos-1"
      },
      {
        "productId": "drink-uuid",
        "type": "Product",
        "amount": 1,
        "positionId": "pos-2"
      }
    ],
    "discountsInfo": {
      "discounts": [
        {
          "discountTypeId": "discount-uuid",
          "selectivePositions": ["pos-1"]
        }
      ]
    }
  }
}
```

---

## Loyalty Client

```typescript
class SyrveLoyaltyClient {
  private baseUrl = 'https://api-ru.iiko.services/api/1';
  private token: string;

  async getPrograms(organizationId: string): Promise<LoyaltyProgram[]> {
    const res = await this.post('/loyalty/iiko/program', {
      organizationIds: [organizationId]
    });
    return res.programs;
  }

  async getDiscounts(organizationId: string): Promise<Discount[]> {
    const res = await this.post('/discounts', {
      organizationIds: [organizationId]
    });
    return res.discounts[0]?.items ?? [];
  }

  async validateCoupon(
    organizationId: string,
    code: string
  ): Promise<CouponValidation> {
    try {
      const res = await this.post('/loyalty/iiko/coupons/info', {
        organizationId,
        number: code
      });

      const coupon = res.couponInfo;

      if (coupon.isUsed) {
        return { isValid: false, errorCode: 'USED' };
      }

      if (new Date(coupon.notAfterDateBecomesApplied) < new Date()) {
        return { isValid: false, errorCode: 'EXPIRED' };
      }

      // Get series for discount info
      const series = await this.getCouponSeries(organizationId, coupon.seriesId);

      return {
        isValid: true,
        discount: {
          type: series.discountType,
          value: series.discountType === 'Percent'
            ? series.discountPercent
            : series.discountSum
        }
      };
    } catch (e) {
      return { isValid: false, errorCode: 'NOT_FOUND' };
    }
  }

  async calculateOrder(
    organizationId: string,
    items: OrderItem[],
    customerId?: string,
    couponCode?: string
  ): Promise<LoyaltyCalculation> {
    const res = await this.post('/loyalty/iiko/calculate', {
      organizationId,
      order: {
        id: `calc-${Date.now()}`,
        items: items.map(item => ({
          productId: item.productId,
          amount: item.amount,
          price: item.price
        })),
        payments: [],
        customer: customerId ? { id: customerId } : undefined,
        coupon: couponCode
      }
    });

    return res.loyaltyInfo;
  }

  private async getCouponSeries(
    organizationId: string,
    seriesId: string
  ): Promise<CouponSeries> {
    const res = await this.post('/loyalty/iiko/coupons/series', {
      organizationIds: [organizationId]
    });

    const series = res.couponSeries[0]?.items.find(s => s.id === seriesId);
    if (!series) throw new Error('Series not found');
    return series;
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

## Checkout with Loyalty

```typescript
async function checkout(
  cart: CartItem[],
  customerId: string | null,
  couponCode: string | null,
  useWalletBalance: boolean
): Promise<CheckoutResult> {
  const loyaltyClient = new SyrveLoyaltyClient();

  // 1. Validate coupon if provided
  if (couponCode) {
    const validation = await loyaltyClient.validateCoupon(
      organizationId,
      couponCode
    );

    if (!validation.isValid) {
      return {
        success: false,
        error: `Coupon error: ${validation.errorCode}`
      };
    }
  }

  // 2. Calculate discounts
  const calculation = await loyaltyClient.calculateOrder(
    organizationId,
    cart,
    customerId,
    couponCode
  );

  // 3. Prepare payments
  const payments: Payment[] = [];

  // Wallet payment
  if (useWalletBalance && calculation.suggestedWalletPayment > 0) {
    payments.push({
      paymentTypeId: 'wallet-payment-uuid',
      paymentTypeKind: 'External',
      sum: calculation.suggestedWalletPayment,
      isProcessedExternally: true
    });
  }

  // Remaining amount
  const remaining = calculation.finalSum - (payments[0]?.sum ?? 0);
  if (remaining > 0) {
    payments.push({
      paymentTypeId: 'card-uuid',
      paymentTypeKind: 'Card',
      sum: remaining,
      isProcessedExternally: true
    });
  }

  // 4. Create order with discounts
  const order = await syrveClient.createOrder({
    organizationId,
    terminalGroupId,
    order: {
      items: cart,
      payments,
      customer: customerId ? { id: customerId } : undefined,
      discountsInfo: {
        discounts: calculation.appliedPromotions.map(p => ({
          discountTypeId: p.id
        })),
        coupon: couponCode
      }
    }
  });

  return {
    success: true,
    orderId: order.id,
    totalPaid: calculation.finalSum,
    discountApplied: calculation.totalDiscount
  };
}
```

---

## Promotional Banners

### Integration Pattern

```typescript
interface PromoBanner {
  id: string;
  title: string;
  description: string;
  imageUrl: string;
  actionType: 'coupon' | 'category' | 'product' | 'url';
  actionValue: string;  // coupon code, category ID, product ID, or URL
  validFrom: string;
  validTo: string;
}

// Store banners in your CMS/database
// Link to Syrve campaigns by ID

async function handleBannerClick(banner: PromoBanner) {
  switch (banner.actionType) {
    case 'coupon':
      // Apply coupon to cart
      await applyCoupon(banner.actionValue);
      break;

    case 'category':
      // Navigate to category
      router.push(`/menu/${banner.actionValue}`);
      break;

    case 'product':
      // Add product to cart
      await addToCart(banner.actionValue);
      break;

    case 'url':
      window.open(banner.actionValue, '_blank');
      break;
  }
}
```

---

## Best Practices

1. **Calculate before order** - Show final price to customer
2. **Validate coupons** - Before applying to order
3. **Cache programs** - Loyalty config changes rarely
4. **Handle expiry** - Check coupon/promo dates
5. **Show savings** - Display discount amount to customer

---

## Related Skills

- `syrve-api.md` - Authentication
- `syrve-customers.md` - Customer loyalty (wallets, cards)
- `syrve-delivery.md` - Apply discounts to delivery
- `syrve-table-orders.md` - Apply discounts to table orders
