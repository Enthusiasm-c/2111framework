# NeonDB Serverless PostgreSQL

Best practices for Next.js + Vercel serverless.

## Connection Management

### Pooled Connection (Recommended)
```typescript
DATABASE_URL="postgresql://user:pass@host-pooler.neon.tech/db?sslmode=require&connect_timeout=10&connection_limit=10"
```

### Serverless Driver
```typescript
import { neon } from '@neondatabase/serverless';

export const sql = neon(process.env.DATABASE_URL!);

// Usage
const rows = await sql`SELECT * FROM users WHERE id = ${id}`;
```

## Database Branching

Create branch per preview:
```bash
neon branches create --name "preview-$PR_NUMBER"
```

Use branch URL in Vercel preview environment.

## Optimization
1. Use pooled URLs for serverless
2. Enable `fetchConnectionCache` for edge
3. Set `connect_timeout=10` for cold starts
4. Cache hot queries in Redis/Data Cache

## Prisma Integration
```typescript
import { PrismaClient } from '@prisma/client';
import { PrismaNeon } from '@prisma/adapter-neon';
import { neonConfig } from '@neondatabase/serverless';

const adapter = new PrismaNeon({ connectionString: process.env.DATABASE_URL! });
export const prisma = new PrismaClient({ adapter });
```

## Common Pitfalls
- Connection leaks: Use singleton pattern
- Timeout issues: Increase `connect_timeout`
- Pooled migrations: Use Prisma 5.10+ or direct URL

See full documentation for detailed patterns.
