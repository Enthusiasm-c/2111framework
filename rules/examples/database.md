---
globs: "**/db/**"
description: Database and ORM conventions
---

# Database Rules

- Use Drizzle ORM for all queries — avoid raw SQL unless necessary
- Always add indexes for columns used in WHERE and ORDER BY
- Use transactions for multi-table writes
- Prefer pooled connections (NeonDB serverless)
- Add `createdAt` and `updatedAt` timestamps to all tables
- Use UUID for primary keys in public-facing tables
- Write migrations incrementally — never modify existing migration files
