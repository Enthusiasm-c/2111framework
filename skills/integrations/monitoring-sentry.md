---
name: monitoring-sentry
description: Sentry error tracking setup for Next.js 14+ with Vercel
category: integrations
---

# Monitoring & Error Tracking

Sentry setup for Next.js 14+ with Vercel deployment.

## Sentry Setup

### Installation
```bash
npx @sentry/wizard@latest -i nextjs
```

This creates:
- `sentry.client.config.ts`
- `sentry.server.config.ts`
- `sentry.edge.config.ts`
- `instrumentation.ts`

### Environment Variables
```env
SENTRY_DSN=https://xxx@xxx.ingest.sentry.io/xxx
SENTRY_AUTH_TOKEN=sntrys_xxx  # For source maps
NEXT_PUBLIC_SENTRY_DSN=https://xxx@xxx.ingest.sentry.io/xxx
```

### Basic Config
```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,

  // Performance
  tracesSampleRate: 0.1, // 10% of transactions

  // Session Replay (debug user issues)
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,

  integrations: [
    Sentry.replayIntegration(),
  ],
});
```

## Capturing Errors

### Automatic (Unhandled)
Sentry auto-captures unhandled exceptions. No code needed.

### Manual Capture
```typescript
import * as Sentry from '@sentry/nextjs';

// Capture exception with context
try {
  await processInvoice(data);
} catch (error) {
  Sentry.captureException(error, {
    tags: {
      feature: 'invoice_processing',
      userId: user.id,
    },
    extra: {
      invoiceId: data.id,
      ocrResult: data.ocrRaw,
    },
  });
  throw error; // Re-throw if needed
}

// Capture message (non-error event)
Sentry.captureMessage('OCR accuracy below threshold', {
  level: 'warning',
  extra: { accuracy: 0.65 },
});
```

### User Context
```typescript
// After login
Sentry.setUser({
  id: user.id,
  email: user.email,
  username: user.name,
});

// After logout
Sentry.setUser(null);
```

## Structured Logging

### Log Levels
```typescript
type LogLevel = 'debug' | 'info' | 'warn' | 'error';

interface LogEntry {
  level: LogLevel;
  message: string;
  userId?: string;
  action: string;
  status: 'start' | 'success' | 'error';
  duration?: number;
  meta?: Record<string, unknown>;
}

function log(entry: LogEntry) {
  const payload = {
    timestamp: new Date().toISOString(),
    ...entry,
  };

  // Console (dev)
  console.log(JSON.stringify(payload));

  // Sentry breadcrumb (production)
  Sentry.addBreadcrumb({
    category: entry.action,
    message: entry.message,
    level: entry.level === 'error' ? 'error' : 'info',
    data: entry.meta,
  });
}
```

### Usage Examples
```typescript
// Invoice processing flow
log({ level: 'info', action: 'invoice_upload', status: 'start', userId: user.id });

const start = Date.now();
const result = await processOCR(image);

log({
  level: result.accuracy > 0.8 ? 'info' : 'warn',
  action: 'ocr_processing',
  status: 'success',
  duration: Date.now() - start,
  meta: { accuracy: result.accuracy, itemCount: result.items.length },
});
```

## Alerts Configuration

### Sentry Alert Rules

**Error Spike Alert:**
- Condition: Error count > 10 in 5 minutes
- Action: Telegram notification

**Performance Alert:**
- Condition: P95 response time > 3s
- Action: Slack warning

**Custom Alert (OCR Accuracy):**
```typescript
// Track as metric
Sentry.setMeasurement('ocr_accuracy', accuracy, 'ratio');

// Alert when: ocr_accuracy < 0.7 for 10+ events
```

### Telegram Integration
```typescript
// Sentry Webhook → Telegram Bot
// Set in Sentry: Settings → Integrations → Webhooks

// Your webhook handler
export async function POST(req: Request) {
  const event = await req.json();

  if (event.level === 'error') {
    await sendTelegramMessage(
      ADMIN_CHAT_ID,
      `🚨 Error: ${event.title}\n${event.culprit}\n${event.url}`
    );
  }
}
```

## Performance Monitoring

### Custom Transactions
```typescript
const transaction = Sentry.startTransaction({
  name: 'invoice_processing',
  op: 'task',
});

const span1 = transaction.startChild({ op: 'ocr', description: 'Extract text' });
await extractText(image);
span1.finish();

const span2 = transaction.startChild({ op: 'match', description: 'Match products' });
await matchProducts(items);
span2.finish();

transaction.finish();
```

### Web Vitals (Automatic)
Next.js + Sentry tracks automatically:
- LCP (Largest Contentful Paint)
- FID (First Input Delay)
- CLS (Cumulative Layout Shift)

## Vercel Integration

### Source Maps
```typescript
// next.config.js
const { withSentryConfig } = require('@sentry/nextjs');

module.exports = withSentryConfig(nextConfig, {
  silent: true,
  org: 'your-org',
  project: 'your-project',
  authToken: process.env.SENTRY_AUTH_TOKEN,
});
```

### Environment Detection
```typescript
Sentry.init({
  environment: process.env.VERCEL_ENV || 'development',
  // 'production' | 'preview' | 'development'
});
```

## Quick Checklist

- [ ] Sentry SDK installed and configured
- [ ] DSN set in environment variables
- [ ] Source maps uploaded (readable stack traces)
- [ ] User context set after login
- [ ] Critical flows have manual error capture
- [ ] Alert rules configured (error spike, performance)
- [ ] Session Replay enabled (debug user issues)

## Common Issues

### "Source maps not found"
Ensure `SENTRY_AUTH_TOKEN` is set in Vercel.

### "Too many events"
Reduce sample rates:
```typescript
tracesSampleRate: 0.01, // 1% in production
```

### "Missing user context"
Set user after auth, clear on logout.

## Cost Optimization

| Plan | Events/month | Best for |
|------|-------------|----------|
| Free | 5,000 | Side projects |
| Team | 50,000 | Production apps |
| Business | 100,000+ | Scale |

Reduce costs:
- Lower `tracesSampleRate` (0.01-0.1)
- Filter noisy errors (bot traffic, etc.)
- Use `beforeSend` to drop unwanted events
