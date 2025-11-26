# NotaApp

## What
Invoice processing app for restaurants.
Photo → OCR → Syrve import. Saves 2-3 hours daily.

## Stack
- Next.js 14 App Router
- TypeScript strict
- NeonDB (PostgreSQL)
- Vercel deployment
- Telegram Mini App
- OpenAI GPT-4 Vision for OCR
- Syrve API for import

## Users
- Restaurant manager (primary)
- Takes 5-15 invoice photos daily
- Mobile only (in the field)
- Non-technical

## Core Flow
1. Open Mini App
2. Take photo of invoice
3. AI extracts: supplier, items, quantities, prices
4. Review/edit extracted data
5. Match to Syrve products
6. Send to Syrve POS
7. Done!

## Database
```sql
users (telegram_id, role, restaurant_id)
restaurants (name, syrve_org_id, syrve_store_id)
invoices (photo_url, ocr_raw, supplier_id, items, status)
suppliers (syrve_id, name) -- cached from Syrve
products (syrve_id, name, unit) -- cached from Syrve
```

## Integrations
- GPT-4 Vision: OCR invoice photos
- Syrve API: suppliers, products, invoice import
- Telegram: Mini App, success/error notifications

## UI Requirements
- Mobile-only design
- Large touch targets
- Camera integration
- Quick review/edit flow
- Clear success/error states

## OCR Prompt (GPT-4 Vision)
Extract from invoice photo:
- Supplier name
- Invoice number
- Date
- Line items: product, quantity, unit, price
- Total amount

## Current Focus
[Update when switching tasks]

## Known Issues
- Blurry photos = bad OCR
- Product matching accuracy ~80%
- Need manual fallback for unmatched items
