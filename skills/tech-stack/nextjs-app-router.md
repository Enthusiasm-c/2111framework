---
name: nextjs-app-router
description: Next.js App Router conventions and project structure
category: tech-stack
---

# Next.js App Router Conventions

## Project Structure
```
/app
  layout.tsx
  page.tsx
  /api
    /auth/route.ts
  /(dashboard)
    layout.tsx
    page.tsx
```

## Server vs Client

### Server Component (default)
```typescript
async function Page() {
  const data = await fetch(url);
  return <div>{data}</div>;
}
```

### Client Component
```typescript
'use client';
import { useState } from 'react';

function Interactive() {
  const [state, setState] = useState();
  return <button onClick={() => setState(x)}>Click</button>;
}
```

## Data Fetching
```typescript
// With caching
const data = await fetch(url, {
  next: { revalidate: 3600, tags: ['users'] }
});

// Force dynamic
export const dynamic = 'force-dynamic';
```

## API Routes
```typescript
// app/api/users/route.ts
import { NextResponse } from 'next/server';

export async function GET() {
  const users = await db.getUsers();
  return NextResponse.json(users);
}
```

## Best Practices
1. Server Components by default
2. Client Components for interactivity only
3. Colocate routes and components
4. Use loading.tsx and error.tsx
5. Validate with Zod

See official Next.js docs for complete patterns.
