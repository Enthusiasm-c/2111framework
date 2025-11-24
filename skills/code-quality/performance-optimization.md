# Web Performance Optimization

Complete guide for Next.js 14+ applications.

## Core Web Vitals

### Metrics & Targets (2025)
- **LCP** (Largest Contentful Paint): ≤ 2.5s - main content visible
- **INP** (Interaction to Next Paint): ≤ 200ms - responsiveness
- **CLS** (Cumulative Layout Shift): ≤ 0.1 - visual stability

### LCP Optimization

```typescript
// Hero image with priority loading
import Image from 'next/image';

export default function Hero() {
  return (
    <Image
      src="/hero.avif"
      alt="Hero"
      fill
      priority  // Preload for LCP
      sizes="(min-width: 1024px) 60vw, 100vw"
      className="object-cover"
    />
  );
}
```

**Strategies:**
1. Optimize hero media (WebP/AVIF, correct sizes)
2. Reduce TTFB (Server Components, cached fetching)
3. Avoid render-blocking resources (next/font, next/script)

### INP Optimization

```typescript
// ❌ Bad: Heavy sync work in handler
<button onClick={() => doMassiveSyncWork()}>Compute</button>

// ✅ Better: Defer heavy work
function handleClick() {
  window.setTimeout(() => doMassiveSyncWorkInChunks(), 0);
}
```

**Strategies:**
- Break up long tasks (> 50ms)
- Minimize JS on critical path
- Debounce/throttle event handlers
- Use Server Components

### CLS Prevention
- Always give media dimensions (next/image does this)
- Reserve space for banners/toasts
- Use next/font (no FOIT/FOUT)
- Avoid inserting DOM above rendered content

## Next.js Optimizations

### Image Optimization
```typescript
<Image
  src="/photo.jpg"
  alt="Photo"
  width={800}
  height={600}
  placeholder="blur"  // Perceived performance
  sizes="(max-width: 768px) 100vw, 50vw"
/>
```

### Font Optimization
```typescript
// app/layout.tsx
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
});

export default function RootLayout({ children }) {
  return (
    <html className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```

### Script Optimization
```typescript
import Script from 'next/script';

// Analytics - load after interactive
<Script
  src="https://www.googletagmanager.com/gtag/js"
  strategy="afterInteractive"
/>
```

### Dynamic Imports
```typescript
import dynamic from 'next/dynamic';

const HeavyChart = dynamic(() => import('./HeavyChart'), {
  ssr: false,
  loading: () => <p>Loading...</p>,
});
```

## React Performance

### Preventing Re-renders
```typescript
// React.memo for pure components
const ProductRow = React.memo(function ProductRow({ name, price }) {
  return <li>{name} - {price}</li>;
});
```

### useMemo / useCallback
```typescript
// useMemo for expensive calculations
const total = useMemo(
  () => orders.reduce((sum, o) => sum + o.amount, 0),
  [orders]
);

// useCallback for stable handlers
const handleSelect = useCallback((id: string) => {
  // ...
}, []);
```

### Keys in Lists
```typescript
// ✅ Stable IDs
items.map(item => <Item key={item.id} {...item} />)

// ❌ Avoid index
items.map((item, idx) => <Item key={idx} {...item} />)
```

## Database Optimization

### Query Optimization
- Select only needed columns
- Limit result sets
- Use JOINs instead of multiple queries

### N+1 Prevention
```typescript
// ✅ Use includes/relations
const users = await prisma.user.findMany({
  include: { posts: true }
});

// ❌ Avoid N+1
const users = await prisma.user.findMany();
for (const user of users) {
  user.posts = await prisma.post.findMany({ where: { userId: user.id } });
}
```

### Connection Pooling (NeonDB)
```typescript
// Use pooled URL for serverless
DATABASE_URL="postgresql://user:pass@host-pooler.neon.tech/db?connection_limit=10"
```

## Caching Strategies

### Next.js Data Cache
```typescript
// Route-level caching
export const revalidate = 300; // 5 minutes

// Fetch-level caching
const data = await fetch(url, {
  next: { revalidate: 3600, tags: ['users'] }
});
```

### CDN Caching
```typescript
// app/api/data/route.ts
export async function GET() {
  const data = await fetchData();
  return NextResponse.json(data, {
    headers: {
      'Cache-Control': 'public, s-maxage=600, stale-while-revalidate=120'
    }
  });
}
```

## Monitoring

### Web Vitals Tracking
```typescript
// app/web-vitals.ts
'use client';
import { onCLS, onINP, onLCP } from 'web-vitals';

export function initWebVitals() {
  const send = (metric) => {
    navigator.sendBeacon('/api/vitals', JSON.stringify(metric));
  };
  onCLS(send);
  onINP(send);
  onLCP(send);
}
```

### Tools
- Chrome DevTools Performance panel
- Lighthouse CI
- Vercel Speed Insights
- Vercel Analytics

## Common Issues

1. **Large JS bundles** → Dynamic imports, move logic server-side
2. **Render-blocking resources** → next/font, next/script
3. **Unoptimized images** → next/image, modern formats
4. **Too many requests** → Consolidate APIs, cache responses
5. **Slow DB queries** → Add indexes, use joins, cache
6. **Memory leaks** → useEffect cleanup, remove listeners
