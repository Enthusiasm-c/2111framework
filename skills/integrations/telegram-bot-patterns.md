---
name: telegram-bot-patterns
description: Complete patterns for Telegram Mini Apps in Next.js
category: integrations
updated: 2026-01-09
model: sonnet
forked_context: false
---

# Telegram Bot & Mini Apps Development

Complete patterns for Telegram Mini Apps in Next.js.

## Bot Setup
1. Create via @BotFather
2. Get API token
3. Enable Mini Apps: /newapp
4. Set webhook URL

## Mini Apps SDK

### Initialization
```typescript
// src/lib/telegram.ts
export function getTelegram() {
  if (typeof window === 'undefined') return null;
  return window.Telegram?.WebApp;
}

export function useTelegram() {
  const [tg, setTg] = useState<TelegramWebApp | null>(null);

  useEffect(() => {
    const telegram = getTelegram();
    if (telegram) {
      telegram.ready();
      telegram.expand(); // Full screen
      setTg(telegram);
    }
  }, []);

  return tg;
}
```

### User Data
```typescript
const tg = getTelegram();
const user = tg?.initDataUnsafe?.user;
// { id, first_name, last_name?, username?, language_code }
```

---

## Authentication Flow

### 1. Client: Send initData
```typescript
// Include in all API requests
const headers = {
  'X-Telegram-Init-Data': window.Telegram.WebApp.initData,
};

const res = await fetch('/api/user', { headers });
```

### 2. Server: Validate Hash
```typescript
// src/lib/telegram-auth.ts
import crypto from 'crypto';

export function validateInitData(initData: string, botToken: string): boolean {
  const params = new URLSearchParams(initData);
  const hash = params.get('hash');
  params.delete('hash');

  // Sort alphabetically
  const dataCheckString = [...params.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([k, v]) => `${k}=${v}`)
    .join('\n');

  const secretKey = crypto
    .createHmac('sha256', 'WebAppData')
    .update(botToken)
    .digest();

  const calculatedHash = crypto
    .createHmac('sha256', secretKey)
    .update(dataCheckString)
    .digest('hex');

  return hash === calculatedHash;
}
```

### 3. Server: Create Session
```typescript
// API route
export async function POST(req: Request) {
  const initData = req.headers.get('X-Telegram-Init-Data');

  if (!validateInitData(initData!, process.env.BOT_TOKEN!)) {
    return Response.json({ error: 'Invalid auth' }, { status: 401 });
  }

  const params = new URLSearchParams(initData!);
  const user = JSON.parse(params.get('user')!);

  // Create or update user in DB
  const dbUser = await upsertUser(user);

  // Return JWT for subsequent requests
  const token = await createJWT({ userId: dbUser.id });
  return Response.json({ token });
}
```

---

## CloudStorage

### Limits
- Max 1024 keys
- Max 4096 bytes per value
- Data persists across sessions

### CRUD Operations
```typescript
const tg = getTelegram();

// Save
await new Promise<void>((resolve, reject) => {
  tg?.CloudStorage.setItem('user_prefs', JSON.stringify(prefs), (err) => {
    err ? reject(err) : resolve();
  });
});

// Load
const data = await new Promise<string | null>((resolve) => {
  tg?.CloudStorage.getItem('user_prefs', (err, value) => {
    resolve(err ? null : value);
  });
});

// Delete
await new Promise<void>((resolve) => {
  tg?.CloudStorage.removeItem('user_prefs', () => resolve());
});

// List keys
const keys = await new Promise<string[]>((resolve) => {
  tg?.CloudStorage.getKeys((err, keys) => {
    resolve(err ? [] : keys);
  });
});
```

### React Hook
```typescript
export function useCloudStorage<T>(key: string, defaultValue: T) {
  const tg = useTelegram();
  const [value, setValue] = useState<T>(defaultValue);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!tg) return;

    tg.CloudStorage.getItem(key, (err, data) => {
      if (!err && data) {
        setValue(JSON.parse(data));
      }
      setLoading(false);
    });
  }, [tg, key]);

  const save = useCallback((newValue: T) => {
    setValue(newValue);
    tg?.CloudStorage.setItem(key, JSON.stringify(newValue), () => {});
  }, [tg, key]);

  return { value, save, loading };
}
```

---

## MainButton

### Basic Usage
```typescript
const tg = useTelegram();

useEffect(() => {
  if (!tg) return;

  tg.MainButton.text = 'Submit';
  tg.MainButton.color = '#007AFF';
  tg.MainButton.show();

  const handleClick = () => {
    tg.MainButton.showProgress();
    submitForm().finally(() => {
      tg.MainButton.hideProgress();
    });
  };

  tg.MainButton.onClick(handleClick);

  return () => {
    tg.MainButton.offClick(handleClick);
    tg.MainButton.hide();
  };
}, [tg]);
```

### States
```typescript
tg.MainButton.show();          // Display
tg.MainButton.hide();          // Hide
tg.MainButton.enable();        // Clickable
tg.MainButton.disable();       // Grayed out
tg.MainButton.showProgress();  // Spinner
tg.MainButton.hideProgress();  // Remove spinner
```

---

## BackButton

```typescript
const tg = useTelegram();
const router = useRouter();

useEffect(() => {
  if (!tg) return;

  const handleBack = () => {
    router.back();
  };

  tg.BackButton.onClick(handleBack);
  tg.BackButton.show();

  return () => {
    tg.BackButton.offClick(handleBack);
    tg.BackButton.hide();
  };
}, [tg, router]);
```

---

## Haptic Feedback

```typescript
const tg = getTelegram();

// Light tap (buttons, toggles)
tg?.HapticFeedback.impactOccurred('light');

// Medium tap (selections)
tg?.HapticFeedback.impactOccurred('medium');

// Heavy tap (destructive actions)
tg?.HapticFeedback.impactOccurred('heavy');

// Success notification
tg?.HapticFeedback.notificationOccurred('success');

// Error notification
tg?.HapticFeedback.notificationOccurred('error');

// Warning notification
tg?.HapticFeedback.notificationOccurred('warning');

// Selection change (picker, scroll)
tg?.HapticFeedback.selectionChanged();
```

### Usage Examples
```typescript
// On button click
<button onClick={() => {
  tg?.HapticFeedback.impactOccurred('light');
  handleClick();
}}>

// On form submit success
tg?.HapticFeedback.notificationOccurred('success');

// On validation error
tg?.HapticFeedback.notificationOccurred('error');
```

---

## Theme Integration

### CSS Variables (Auto-applied)
```css
:root {
  --tg-theme-bg-color: #ffffff;
  --tg-theme-text-color: #000000;
  --tg-theme-hint-color: #999999;
  --tg-theme-link-color: #007AFF;
  --tg-theme-button-color: #007AFF;
  --tg-theme-button-text-color: #ffffff;
  --tg-theme-secondary-bg-color: #f0f0f0;
}
```

### Usage in Tailwind
```typescript
// tailwind.config.ts
theme: {
  extend: {
    colors: {
      tg: {
        bg: 'var(--tg-theme-bg-color)',
        text: 'var(--tg-theme-text-color)',
        hint: 'var(--tg-theme-hint-color)',
        link: 'var(--tg-theme-link-color)',
        button: 'var(--tg-theme-button-color)',
        'button-text': 'var(--tg-theme-button-text-color)',
        'secondary-bg': 'var(--tg-theme-secondary-bg-color)',
      },
    },
  },
}

// Usage
<div className="bg-tg-bg text-tg-text">
```

### Color Scheme Detection
```typescript
const tg = getTelegram();
const isDark = tg?.colorScheme === 'dark';
```

---

## Debugging

### Telegram Desktop
Right-click → Inspect Element → DevTools available

### Mobile (No DevTools!)
```typescript
// In-app debug panel
export function DebugPanel() {
  const tg = useTelegram();

  if (process.env.NODE_ENV === 'production') return null;

  return (
    <div className="fixed bottom-20 left-2 right-2 bg-black/80 text-white p-2 text-xs rounded max-h-40 overflow-auto">
      <div>User: {JSON.stringify(tg?.initDataUnsafe?.user)}</div>
      <div>Platform: {tg?.platform}</div>
      <div>Version: {tg?.version}</div>
      <div>ColorScheme: {tg?.colorScheme}</div>
    </div>
  );
}
```

### Toast Notifications
```typescript
// Use sonner or custom toast for debug messages
import { toast } from 'sonner';

// Debug API response
const res = await fetch('/api/data');
toast.info(`API: ${res.status}`);
```

---

## Performance

### Preload Data
```typescript
// Start fetching before render
const dataPromise = fetch('/api/data').then(r => r.json());

export default function Page() {
  const [data, setData] = useState(null);

  useEffect(() => {
    dataPromise.then(setData);
  }, []);
}
```

### Skeleton Screens
```typescript
if (loading) {
  return <Skeleton className="h-20 w-full" />;
}
```

### Optimistic Updates
```typescript
const [items, setItems] = useState(initialItems);

const addItem = async (item) => {
  // Optimistic: show immediately
  setItems(prev => [...prev, item]);

  try {
    await fetch('/api/items', { method: 'POST', body: JSON.stringify(item) });
  } catch {
    // Rollback on error
    setItems(initialItems);
    tg?.HapticFeedback.notificationOccurred('error');
  }
};
```

### Image Optimization
```typescript
// Use next/image with proper sizes
<Image
  src={url}
  width={300}
  height={200}
  loading="lazy"
  placeholder="blur"
  blurDataURL={placeholder}
/>
```

---

## Webhook Setup

```typescript
// app/api/telegram/webhook/route.ts
import { Bot } from 'grammy';

const bot = new Bot(process.env.BOT_TOKEN!);

bot.command('start', (ctx) => {
  ctx.reply('Welcome!', {
    reply_markup: {
      inline_keyboard: [[
        { text: 'Open App', web_app: { url: process.env.MINI_APP_URL! } }
      ]]
    }
  });
});

export async function POST(req: Request) {
  const update = await req.json();
  await bot.handleUpdate(update);
  return Response.json({ ok: true });
}

// Set webhook (run once)
// curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook?url=<URL>/api/telegram/webhook"
```

---

## Quick Reference

| Feature | Method |
|---------|--------|
| Get user | `tg.initDataUnsafe.user` |
| Show main button | `tg.MainButton.show()` |
| Hide main button | `tg.MainButton.hide()` |
| Show back button | `tg.BackButton.show()` |
| Haptic tap | `tg.HapticFeedback.impactOccurred('light')` |
| Save data | `tg.CloudStorage.setItem(key, value, cb)` |
| Load data | `tg.CloudStorage.getItem(key, cb)` |
| Close app | `tg.close()` |
| Expand | `tg.expand()` |
| Theme | `tg.colorScheme` |
| Platform | `tg.platform` |
