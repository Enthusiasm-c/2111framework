# Ave AI

## What
Restaurant analytics platform with AI insights.
Connects to Syrve POS, shows dashboards, AI answers business questions.

## Stack
- Next.js 14 App Router
- TypeScript strict
- NeonDB (PostgreSQL)
- Vercel deployment
- Telegram Mini App
- OpenAI for chat
- Syrve API integration

## Users
- Restaurant owner (primary)
- Manager (secondary)
- Mobile-first (Telegram)

## Core Features
- Sales dashboards (daily, weekly, monthly)
- Inventory tracking
- AI chat for business questions
- Syrve data sync

## Database
```
restaurants, users, sales_data, inventory, 
products (cached from Syrve), suppliers (cached)
```

## Integrations
- Syrve API: sales, inventory, products, suppliers
- OpenAI: GPT-4 for business insights chat
- Telegram: Mini App, notifications

## UI Requirements
- Dark theme preferred
- Mobile-first
- Charts: recharts or chart.js
- Touch-friendly controls

## Current Focus
[Update this section when switching tasks]

## Known Issues
- Slow sync for restaurants with 10k+ products
- Need caching for dashboard charts
- Mobile keyboard covers input on some screens
