---
name: syrve-api
description: Syrve POS API integration reference
category: integrations
---

# Syrve POS API Integration

Complete reference based on validated implementation.

## Authentication
- Method: Session via `/resto/api/auth`
- Credentials: login + SHA-1 hashed password
- Token: 36-char string, pass as `?key=TOKEN`

```bash
# Auth
curl -X POST "https://host/resto/api/auth" \
  --data "login=USER&pass=SHA1_HEX"
```

## Key Endpoints

### Suppliers Catalog
`GET /resto/api/suppliers?key=TOKEN`

### Products Catalog  
`GET /resto/api/products?key=TOKEN`

### Stores/Warehouses
`GET /resto/api/corporation/stores?key=TOKEN`

### Import Invoice
`POST /resto/api/documents/import/incomingInvoice?key=TOKEN`

```xml
<?xml version="1.0"?>
<document>
  <items>
    <item>
      <product>GUID</product>
      <amount>1.00</amount>
      <price>1000.00</price>
    </item>
  </items>
  <supplier>GUID</supplier>
  <defaultStore>GUID</defaultStore>
</document>
```

### OLAP Analytics
`POST /resto/api/v2/reports/olap?key=TOKEN`

## Best Practices
1. Cache GUIDs locally
2. Use exponential backoff (rate limits)
3. Validate before import
4. Handle 401 (re-auth), 409 (conflicts), 500 (bad GUIDs)

See full documentation for complete implementation details.
