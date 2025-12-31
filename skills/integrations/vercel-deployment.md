---
name: vercel-deployment
description: Complete guide for Next.js 14+ deployment on Vercel
category: integrations
---

# Vercel Deployment Guide

Complete guide for Next.js 14+ on Vercel.

## Project Configuration

### vercel.json
```json
{
  "framework": "nextjs",
  "functions": {
    "api/db-heavy/(.*)": {
      "runtime": "nodejs20.x",
      "maxDuration": 60
    },
    "api/edge/(.*)": {
      "runtime": "edge"
    }
  },
  "crons": [{
    "path": "/api/cron/sync",
    "schedule": "0 * * * *"
  }]
}
```

## Environment Variables
```bash
# Add via CLI
vercel env add DATABASE_URL production

# Pull locally
vercel env pull .env.local
```

## Performance
1. Use `next/image` for images
2. Use `next/font` for fonts  
3. Prefer Server Components
4. Cache with `revalidate`

## Edge vs Serverless
- **Edge:** Auth, feature flags, lightweight reads
- **Serverless:** DB queries, heavy processing

See full documentation for optimization details.
