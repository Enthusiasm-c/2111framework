# Telegram Bot Development

## Bot Setup
1. Create via @BotFather
2. Get API token
3. Set webhook or use polling

## Mini Apps (Web Apps)
```typescript
// Check Telegram SDK
if (window.Telegram?.WebApp) {
  const initData = window.Telegram.WebApp.initData;
  // Use for auth
}
```

## Webhook Setup
```typescript
// Next.js API route
export async function POST(req: Request) {
  const update = await req.json();
  // Handle message
  return Response.json({ ok: true });
}
```

## Common Patterns
- Inline keyboards for navigation
- CloudStorage for user data
- MainButton for primary actions
- Theme integration with themeParams

See official Telegram Bot API docs for complete reference.
