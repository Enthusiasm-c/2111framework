---
name: browser-testing-guide
description: Frontend testing via Chrome DevTools MCP and Chrome Extension. Use when testing UI, debugging frontend, or verifying visual changes.
model: sonnet
---

# Browser Testing Guide

Frontend testing via browser automation. Two options available:

## Option 1: Chrome DevTools MCP (Recommended)

Direct connection to Chrome DevTools Protocol. More reliable than Chrome Extension, doesn't require browser extension installation.

### Setup

Add to your project's `.claude/mcp.json` or global `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-chrome-devtools@latest"]
    }
  }
}
```

### Capabilities

| Feature | Tool | Description |
|---------|------|-------------|
| Navigate | `navigate_page` | Open URL in browser |
| Click | `click` | Click element by selector/text |
| Type | `fill` | Fill input fields |
| Screenshot | `take_screenshot` | Capture page/element |
| Console | `list_console_messages` | Read console output |
| Network | `list_network_requests` | Monitor API calls |
| JavaScript | `evaluate_script` | Run JS on page |
| Forms | `fill_form` | Fill multiple fields at once |
| Dialog | `handle_dialog` | Accept/dismiss alerts |
| Emulate | `emulate` | Mobile device emulation |
| Performance | `lighthouse_audit` | Run Lighthouse audit |
| Resize | `resize_page` | Change viewport size |

### Common Workflows

**Test responsive design:**
```
1. navigate_page → your URL
2. resize_page → 375x667 (iPhone SE)
3. take_screenshot → verify mobile layout
4. resize_page → 1440x900 (desktop)
5. take_screenshot → verify desktop layout
```

**Test form submission:**
```
1. navigate_page → form URL
2. fill_form → all fields
3. click → submit button
4. list_network_requests → verify API call
5. take_screenshot → verify success state
```

**Debug API errors:**
```
1. navigate_page → your URL
2. list_network_requests → filter by pattern
3. read_console_messages → check errors
4. evaluate_script → inspect DOM state
```

**Lighthouse performance audit:**
```
1. navigate_page → your URL
2. lighthouse_audit → get scores (performance, accessibility, SEO)
```

---

## Option 2: Claude in Chrome Extension

Browser extension for Claude Code. Requires Chrome extension installed and running.

### Status: May be unstable

If the extension stops working:
1. Try reinstalling from Chrome Web Store
2. Check extension permissions in chrome://extensions
3. Fall back to Chrome DevTools MCP (Option 1)

### Capabilities

Same as DevTools MCP plus:
- GIF recording (`gif_creator`)
- Tab context awareness (`tabs_context_mcp`)
- Computer use (experimental)

---

## Testing Telegram Mini Apps

Telegram Mini Apps can't be tested with browser DevTools directly (they run inside Telegram). Options:

### 1. Test the web version

If your app has a web fallback (most do), test it in browser:
```
navigate_page → https://your-app.vercel.app
emulate → mobile device
```

### 2. Test with Telegram Web

```
navigate_page → https://web.telegram.org
# Login, open bot, launch Mini App
# Use DevTools to interact
```

### 3. Create debug UI

For Telegram-specific features (CloudStorage, HapticFeedback), create an in-app debug panel:

```typescript
// components/DebugPanel.tsx — only visible in development
'use client';
export function DebugPanel() {
  if (process.env.NODE_ENV !== 'development') return null;
  return (
    <div className="fixed bottom-0 left-0 p-2 bg-black/80 text-white text-xs">
      <pre>{JSON.stringify(window.Telegram?.WebApp, null, 2)}</pre>
    </div>
  );
}
```

---

## When to Use What

| Scenario | Tool |
|----------|------|
| Quick screenshot verification | Chrome DevTools MCP |
| Form testing | Chrome DevTools MCP |
| API debugging (network tab) | Chrome DevTools MCP |
| Lighthouse audit | Chrome DevTools MCP |
| Mobile emulation | Chrome DevTools MCP |
| GIF recording for demos | Chrome Extension (if working) |
| Telegram Mini App testing | Web version + DevTools MCP |
| Complex multi-step flows | Chrome DevTools MCP |

---

## Related Skills

- `qa.md` — QA agent uses browser testing for verification
- `chrome-extension-guide.md` — Legacy Chrome Extension reference (kept for compatibility)
