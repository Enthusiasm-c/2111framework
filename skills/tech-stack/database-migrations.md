---
name: database-migrations
description: Safe schema changes with Drizzle ORM for NeonDB + Next.js
model: sonnet
---

# Database Migrations (Drizzle ORM)

Safe schema changes for NeonDB + Next.js serverless.

## Workflow

### 1. Edit Schema
```typescript
// src/db/schema.ts
import { pgTable, serial, varchar, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  name: varchar('name', { length: 255 }),
  createdAt: timestamp('created_at').defaultNow(),
});
```

### 2. Generate Migration
```bash
npx drizzle-kit generate
# Creates: drizzle/0001_add_users_table.sql
```

### 3. Apply Migration
```bash
# Dev/Preview
npx drizzle-kit migrate

# Production (via CI/CD)
npx drizzle-kit migrate --config=drizzle.config.prod.ts
```

### 4. Verify
Check Neon Console → Tables or run:
```sql
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'users';
```

## Safe Migration Patterns

### Adding a Column (Safe)
```typescript
// Step 1: Add as nullable
name: varchar('name', { length: 255 }), // nullable first

// Step 2: Backfill data
await db.update(users).set({ name: 'Unknown' }).where(isNull(users.name));

// Step 3: Make NOT NULL in next migration
name: varchar('name', { length: 255 }).notNull(),
```

### Renaming a Column (Safe)
```sql
-- DON'T: ALTER TABLE users RENAME COLUMN name TO full_name;
-- DO: Three-step process

-- Migration 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(255);

-- Migration 2: Copy data + update app code
UPDATE users SET full_name = name;

-- Migration 3: Drop old column (after deploy)
ALTER TABLE users DROP COLUMN name;
```

### Adding an Index (Safe)
```sql
-- Use CONCURRENTLY to avoid table locks
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
```

## Rollback Strategy

### Manual Rollback SQL
```sql
-- drizzle/0001_add_users_table.rollback.sql
DROP TABLE IF EXISTS users;
```

### Using Neon Branching
```bash
# Before migration: create backup branch
neon branches create --name "backup-$(date +%Y%m%d)"

# After failed migration: restore
neon branches reset main --parent backup-20241229
```

### Drizzle Kit Push (Dev Only)
```bash
# Quick sync without migration files (dev only!)
npx drizzle-kit push
```

## Danger Zone

### Never Do in Production
- `DROP COLUMN` without deprecation period (2+ deploys)
- `ALTER COLUMN ... NOT NULL` without backfilling data
- `TRUNCATE TABLE` or `DROP TABLE` on tables with data
- Renaming columns directly (breaks running code)

### Migration Checklist
- [ ] Test on Neon branch first
- [ ] Backup branch created
- [ ] Rollback SQL prepared
- [ ] App code handles both old/new schema during deploy
- [ ] No `DROP` or `RENAME` without deprecation

## Drizzle Config

```typescript
// drizzle.config.ts
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: './src/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    // Use DIRECT URL for migrations (not pooled)
    url: process.env.DATABASE_URL_DIRECT!,
  },
});
```

## Common Issues

### "Connection terminated unexpectedly"
Use direct URL, not pooled, for migrations:
```env
DATABASE_URL=postgresql://...@host-pooler.neon.tech/db  # app
DATABASE_URL_DIRECT=postgresql://...@host.neon.tech/db  # migrations
```

### "Relation already exists"
Check migration state:
```bash
npx drizzle-kit check
```

### "Permission denied"
Ensure Neon role has DDL permissions.

## Quick Reference

| Operation | Safety | Notes |
|-----------|--------|-------|
| ADD COLUMN (nullable) | Safe | Default NULL |
| ADD COLUMN (NOT NULL) | Unsafe | Needs default or backfill |
| DROP COLUMN | Unsafe | 2-deploy deprecation |
| RENAME COLUMN | Unsafe | Use add+copy+drop |
| ADD INDEX | Safe* | Use CONCURRENTLY |
| DROP INDEX | Safe | Verify not used |
| ADD TABLE | Safe | - |
| DROP TABLE | Unsafe | Backup first |
