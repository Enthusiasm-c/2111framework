---
name: syrve-menu
description: Syrve Cloud API menu - nomenclature, products, modifiers, stop-lists, combos
model: sonnet
---

# Syrve Menu API

Complete reference for menu and product operations in Syrve Cloud API.

## When to Use
- Sync product catalog
- Get menu with prices
- Track out-of-stock items
- Handle combo products

---

## Nomenclature (Full Catalog)

`POST /nomenclature`

Returns complete product catalog with groups, modifiers, and sizes.

### Request

```json
{
  "organizationId": "org-uuid"
}
```

### Response Structure

```typescript
interface NomenclatureResponse {
  correlationId: string;
  groups: ProductGroup[];
  productCategories: ProductCategory[];
  products: Product[];
  sizes: Size[];
  revision: number;
}

interface ProductGroup {
  id: string;
  code: string;
  name: string;
  description: string;
  parentGroup: string | null;
  order: number;
  isIncludedInMenu: boolean;
  isGroupModifier: boolean;
  imageLinks: string[];
}

interface Product {
  id: string;
  code: string;
  name: string;
  description: string;
  parentGroup: string;

  // Type
  type: 'Dish' | 'Good' | 'Modifier' | 'Service';
  orderItemType: 'Product' | 'Compound';

  // Pricing
  sizePrices: Array<{
    sizeId: string | null;
    price: {
      currentPrice: number;
      isIncludedInMenu: boolean;
    };
  }>;

  // Modifiers
  modifierSchemaId: string | null;
  groupModifiers: GroupModifier[];
  modifiers: SimpleModifier[];

  // Nutrition
  energyAmount: number;
  energyFullAmount: number;
  fatAmount: number;
  fatFullAmount: number;
  fiberAmount: number;
  fiberFullAmount: number;
  proteinsAmount: number;
  proteinsFullAmount: number;
  carbohydratesAmount: number;
  carbohydratesFullAmount: number;
  weight: number;

  // Portions
  portionControlType: 'Portion' | 'Grams' | 'Both';
  defaultSizeId: string | null;

  // Media
  imageLinks: string[];

  // Flags
  isDeleted: boolean;
  isIncludedInMenu: boolean;
}

interface GroupModifier {
  id: string;
  minAmount: number;
  maxAmount: number;
  required: boolean;
  childModifiers: Array<{
    id: string;
    defaultAmount: number;
    minAmount: number;
    maxAmount: number;
  }>;
}

interface SimpleModifier {
  id: string;
  defaultAmount: number;
  minAmount: number;
  maxAmount: number;
  required: boolean;
}
```

### Example Response

```json
{
  "correlationId": "uuid",
  "revision": 12345,
  "groups": [
    {
      "id": "pizza-group-uuid",
      "name": "Pizza",
      "parentGroup": null,
      "order": 1,
      "isIncludedInMenu": true,
      "imageLinks": ["https://..."]
    }
  ],
  "products": [
    {
      "id": "margherita-uuid",
      "code": "PIZZA001",
      "name": "Margherita",
      "description": "Classic tomato and mozzarella",
      "parentGroup": "pizza-group-uuid",
      "type": "Dish",
      "orderItemType": "Product",
      "sizePrices": [
        {
          "sizeId": "small-uuid",
          "price": { "currentPrice": 450, "isIncludedInMenu": true }
        },
        {
          "sizeId": "large-uuid",
          "price": { "currentPrice": 650, "isIncludedInMenu": true }
        }
      ],
      "groupModifiers": [
        {
          "id": "toppings-group-uuid",
          "minAmount": 0,
          "maxAmount": 5,
          "required": false,
          "childModifiers": [
            { "id": "cheese-uuid", "defaultAmount": 0, "minAmount": 0, "maxAmount": 2 }
          ]
        }
      ],
      "weight": 350,
      "imageLinks": ["https://..."],
      "isIncludedInMenu": true
    }
  ],
  "sizes": [
    { "id": "small-uuid", "name": "Small", "priority": 1 },
    { "id": "large-uuid", "name": "Large", "priority": 2 }
  ]
}
```

---

## External Menu - API v2 (Recommended)

**Base URL**: `https://api-eu.syrve.live/api/2/`

**OpenAPI Spec**: https://api-eu.syrve.live/api-docs/docs

Use API v2 for external menus - works on all license tiers (Basic, Pro, Enterprise).

### Get Available Menus

`POST https://api-eu.syrve.live/api/2/menu`

Returns list of available external menus.

**Request:**
```json
{
  "organizationIds": ["org-uuid"]
}
```

**Response:**
```json
{
  "correlationId": "uuid",
  "externalMenus": [
    { "id": "8235", "name": "Menu" }
  ],
  "priceCategories": [
    { "id": "price-cat-uuid", "name": "Delivery Prices" }
  ]
}
```

### Get Menu Items by ID

`POST https://api-eu.syrve.live/api/2/menu/by_id`

Returns full menu content with categories, items, prices, and modifiers.

**Request Schema (MenuRequest):**
```typescript
interface MenuRequest {
  // Required
  externalMenuId: string;      // From /api/2/menu response
  organizationIds: string[];   // Array of org UUIDs

  // Optional
  priceCategoryId?: string;    // Filter by price category
  version?: number;            // Data model version (default: 2)
  language?: string;           // Menu language
  startRevision?: number;      // For incremental updates
}
```

**Example Request:**
```json
{
  "externalMenuId": "8235",
  "organizationIds": ["ff53e2af-dc35-4f4e-9cdb-6e7a5bd381fb"],
  "version": 2
}
```

**Response Schema:**
```typescript
interface ExternalMenuResponse {
  correlationId: string;
  id: number;
  name: string;
  description: string;
  revision: number;
  itemCategories: ExternalMenuCategory[];
}

interface ExternalMenuCategory {
  id: string;
  name: string;
  description: string;
  buttonImageUrl?: string;
  items: ExternalMenuItem[];
}

interface ExternalMenuItem {
  sku: string;              // Product code
  name: string;
  description: string;
  itemId: string;           // Product UUID
  allergens: string[];
  tags: string[];
  itemSizes: ItemSize[];
  modifierSchemaId?: string;
  type?: string;            // Dish, Good, Modifier
}

interface ItemSize {
  sku: string;
  sizeName: string;
  isDefault: boolean;
  portionWeightGrams: number;
  itemModifierGroups: ModifierGroup[];
  prices: Price[];
}

interface ModifierGroup {
  name: string;
  description: string;
  restrictions: {
    minQuantity: number;
    maxQuantity: number;
    freeQuantity: number;
    byDefault: number;
  };
  items: ModifierItem[];
}

interface Price {
  organizationId: string;
  price: number;           // In minor currency units
}
```

**Example Response (truncated):**
```json
{
  "correlationId": "uuid",
  "id": 8235,
  "name": "Menu",
  "revision": 1764748199,
  "itemCategories": [
    {
      "id": "40c735b1-290d-468e-855d-7ca1c2012a64",
      "name": "Breakfast platters",
      "items": [
        {
          "sku": "01554",
          "name": "Pacific breakfast",
          "description": "Salmon rillette, spinach, avocado...",
          "itemSizes": [
            {
              "sku": "01554",
              "isDefault": true,
              "portionWeightGrams": 388.0,
              "prices": [
                { "organizationId": "ff53e2af-...", "price": 95000 }
              ],
              "itemModifierGroups": [
                {
                  "name": "Add on",
                  "restrictions": { "minQuantity": 0, "maxQuantity": 91 },
                  "items": [
                    { "sku": "00310", "name": "Boiled egg", "prices": [{ "price": 5000 }] }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

### Documentation Links

- [Get menu list](https://api-eu.syrve.live/docs#tag/Menu/paths/~1api~12~1menu/post)
- [Get menu by ID](https://api-eu.syrve.live/docs#tag/Menu/paths/~1api~12~1menu~1by_id/post)
- [OpenAPI Spec](https://api-eu.syrve.live/api-docs/docs)

### API v1 External Menus (Enterprise Only)

API v1 `/external_menus` requires Enterprise license (€99/mo). Use API v2 instead.

---

## Stop Lists (Out of Stock)

`POST /stop_lists`

Returns items currently unavailable.

### Request

```json
{
  "organizationIds": ["org-uuid"]
}
```

### Response

```json
{
  "correlationId": "uuid",
  "terminalGroupStopLists": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "terminalGroupId": "terminal-uuid",
          "items": [
            {
              "productId": "product-uuid",
              "balance": 0
            }
          ]
        }
      ]
    }
  ]
}
```

### TypeScript Interface

```typescript
interface StopListResponse {
  correlationId: string;
  terminalGroupStopLists: Array<{
    organizationId: string;
    items: Array<{
      terminalGroupId: string;
      items: Array<{
        productId: string;
        balance: number; // 0 = out of stock
      }>;
    }>;
  }>;
}
```

---

## Combos

### Get Combo Information
`POST /combo`

```json
{
  "organizationIds": ["org-uuid"]
}
```

### Response

```json
{
  "correlationId": "uuid",
  "comboSpecifications": [
    {
      "organizationId": "org-uuid",
      "items": [
        {
          "id": "combo-uuid",
          "name": "Lunch Deal",
          "productId": "combo-product-uuid",
          "groups": [
            {
              "id": "main-group-uuid",
              "name": "Main Dish",
              "products": ["burger-uuid", "wrap-uuid"],
              "productPrices": {
                "burger-uuid": 0,
                "wrap-uuid": 50
              }
            },
            {
              "id": "side-group-uuid",
              "name": "Side",
              "products": ["fries-uuid", "salad-uuid"],
              "productPrices": {
                "fries-uuid": 0,
                "salad-uuid": 0
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Calculate Combo Price
`POST /combo/calculate`

```json
{
  "organizationId": "org-uuid",
  "comboInfo": {
    "comboId": "combo-uuid",
    "comboSourceId": "combo-product-uuid",
    "comboGroupId": "main-group-uuid",
    "selectedProducts": [
      { "productId": "burger-uuid", "groupId": "main-group-uuid" },
      { "productId": "fries-uuid", "groupId": "side-group-uuid" }
    ]
  }
}
```

---

## Sync Strategy

### Initial Sync

```typescript
async function initialMenuSync(organizationId: string) {
  // 1. Get full nomenclature
  const nomenclature = await fetchNomenclature(organizationId);

  // 2. Store in database
  await db.transaction(async (tx) => {
    // Clear and repopulate
    await tx.delete(products).where(eq(products.orgId, organizationId));

    for (const product of nomenclature.products) {
      if (!product.isDeleted && product.isIncludedInMenu) {
        await tx.insert(products).values({
          id: product.id,
          orgId: organizationId,
          name: product.name,
          code: product.code,
          price: product.sizePrices[0]?.price.currentPrice ?? 0,
          groupId: product.parentGroup,
          data: product
        });
      }
    }
  });

  // 3. Store revision for incremental updates
  await db.update(orgs)
    .set({ menuRevision: nomenclature.revision })
    .where(eq(orgs.id, organizationId));
}
```

### Incremental Updates

```typescript
async function checkMenuUpdates(organizationId: string) {
  const org = await db.query.orgs.findFirst({
    where: eq(orgs.id, organizationId)
  });

  const current = await fetchNomenclature(organizationId);

  if (current.revision > org.menuRevision) {
    await initialMenuSync(organizationId); // Full resync
  }
}
```

### Stop List Polling

```typescript
// Poll every 5 minutes
setInterval(async () => {
  const stopLists = await fetchStopLists(organizationId);

  for (const item of stopLists.terminalGroupStopLists[0].items[0].items) {
    await db.update(products)
      .set({ inStock: item.balance > 0 })
      .where(eq(products.id, item.productId));
  }
}, 5 * 60 * 1000);
```

---

## Building Menu for Frontend

```typescript
interface MenuItem {
  id: string;
  name: string;
  description: string;
  price: number;
  image: string;
  category: string;
  modifiers: ModifierGroup[];
  sizes: SizeOption[];
  inStock: boolean;
}

function buildMenu(nomenclature: NomenclatureResponse): MenuItem[] {
  return nomenclature.products
    .filter(p => p.isIncludedInMenu && !p.isDeleted && p.type === 'Dish')
    .map(product => ({
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.sizePrices[0]?.price.currentPrice ?? 0,
      image: product.imageLinks[0] ?? '',
      category: nomenclature.groups.find(g => g.id === product.parentGroup)?.name ?? '',
      modifiers: product.groupModifiers.map(gm => ({
        id: gm.id,
        name: nomenclature.groups.find(g => g.id === gm.id)?.name ?? '',
        required: gm.required,
        min: gm.minAmount,
        max: gm.maxAmount,
        options: gm.childModifiers.map(cm => {
          const mod = nomenclature.products.find(p => p.id === cm.id);
          return {
            id: cm.id,
            name: mod?.name ?? '',
            price: mod?.sizePrices[0]?.price.currentPrice ?? 0
          };
        })
      })),
      sizes: product.sizePrices.map(sp => ({
        id: sp.sizeId,
        name: nomenclature.sizes.find(s => s.id === sp.sizeId)?.name ?? 'Standard',
        price: sp.price.currentPrice
      })),
      inStock: true
    }));
}
```

---

## Best Practices

1. **Cache nomenclature** - Changes rarely, heavy payload
2. **Track revision** - Skip sync if unchanged
3. **Poll stop-lists frequently** - Every 5-10 minutes
4. **Filter isIncludedInMenu** - Not all products are for sale
5. **Handle sizes** - Products may have multiple prices

---

## Related Skills

- `syrve-api.md` - Authentication, organizations
- `syrve-delivery.md` - Use product IDs in orders
