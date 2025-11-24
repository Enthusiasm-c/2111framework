# Playwright MCP - Complete Usage Guide

Interactive browser automation for manual testing and debugging within Claude Code.

## What Playwright MCP IS

- ✅ Real-time browser automation for manual testing
- ✅ Visual debugging with screenshots
- ✅ Interactive page exploration
- ✅ Console log monitoring (critical for Telegram Mini Apps!)
- ✅ JavaScript execution in live browser

## What It's NOT

- ❌ Test file generator (.spec.ts files)
- ❌ Test runner (Jest/Vitest/Playwright Test)
- ❌ Code coverage tool
- ❌ CI/CD testing infrastructure

## Available Commands

### browser_navigate
```javascript
browser_navigate({ url: "http://localhost:3000" })
browser_navigate({ url: "https://myapp.vercel.app" })
```

### browser_screenshot
```javascript
browser_screenshot()
browser_screenshot({ selector: "#invoice-modal" })
```

### browser_click
```javascript
browser_click({ selector: "text=Submit" })
browser_click({ selector: "#submit-button" })
browser_click({ selector: "[data-testid='close']" })
browser_click({ selector: "role=button[name='Submit']" })
```

### browser_fill (for inputs)
```javascript
browser_fill({ selector: "#email", value: "test@example.com" })
browser_fill({ selector: "input[type='password']", value: "pass123" })
```

### browser_get_visible_text
```javascript
browser_get_visible_text()
browser_get_visible_text({ selector: ".error-message" })
```

### browser_get_visible_html
```javascript
browser_get_visible_html()
browser_get_visible_html({ selector: "#modal" })
```

### browser_evaluate (run JS)
```javascript
browser_evaluate("() => localStorage.getItem('authToken')")
browser_evaluate("() => window.Telegram?.WebApp?.initData")
browser_evaluate("() => ({ width: window.innerWidth })")
```

### browser_console_logs
```javascript
browser_console_logs()
// Returns all console messages - CRITICAL for Telegram Mini Apps!
```

### browser_close
```javascript
browser_close()
```

## Common Testing Workflows

### 1. Basic Page Verification
```
1. browser_navigate("http://localhost:3000")
2. browser_screenshot()
3. browser_get_visible_text()
4. browser_close()
```

### 2. Form Testing
```
1. browser_navigate("http://localhost:3000/login")
2. browser_fill({ selector: "#email", value: "test@example.com" })
3. browser_fill({ selector: "#password", value: "password123" })
4. browser_screenshot()  // Before submit
5. browser_click({ selector: "button[type='submit']" })
6. browser_screenshot()  // After submit
7. browser_console_logs()  // Check for errors
8. browser_close()
```

### 3. Modal/Dialog Testing
```
1. browser_navigate("http://localhost:3000/dashboard")
2. browser_click({ selector: "text=Settings" })
3. browser_screenshot()  // Modal open
4. browser_get_visible_html({ selector: "#modal" })
5. browser_click({ selector: "[aria-label='Close']" })
6. browser_screenshot()  // Modal closed
7. browser_close()
```

### 4. Telegram Mini App Debugging (CRITICAL!)
```
1. browser_navigate("https://t.me/yourbot/app")

2. browser_evaluate("() => ({
     sdkLoaded: !!window.Telegram,
     webAppReady: !!window.Telegram?.WebApp,
     initData: window.Telegram?.WebApp?.initData,
     platform: window.Telegram?.WebApp?.platform
   })")

3. browser_console_logs()  // ONLY WAY TO SEE LOGS!

4. browser_screenshot()

5. browser_get_visible_text({ selector: "#error-message" })

6. browser_close()
```

## Telegram Mini App Specific Patterns

### Verify SDK Integration
```javascript
browser_evaluate("() => ({
  telegram: !!window.Telegram,
  webApp: !!window.Telegram?.WebApp,
  initData: window.Telegram?.WebApp?.initData,
  version: window.Telegram?.WebApp?.version,
  platform: window.Telegram?.WebApp?.platform,
  colorScheme: window.Telegram?.WebApp?.colorScheme
})")
```

### Debug Cloud Storage
```javascript
browser_evaluate("() => new Promise(resolve => {
  const WebApp = window.Telegram?.WebApp
  if (!WebApp) return resolve({ error: 'SDK not loaded' })
  WebApp.CloudStorage.getKeys((error, keys) => {
    resolve({ error, keys })
  })
})")
```

## Best Practices

### General
- ✅ Always start with navigate
- ✅ Screenshot before AND after interactions
- ✅ Check console_logs regularly
- ✅ Close browser when done
- ✅ Use specific selectors (test-id > text > CSS)

### Telegram Mini Apps (CRITICAL!)
- 🚨 console_logs is MANDATORY - only debugging method
- 🚨 Screenshots replace DevTools visual inspection
- 🚨 evaluate replaces Console tab
- 🚨 get_visible_text replaces Elements inspector
- 🚨 Always verify Telegram.WebApp SDK loaded

### Debugging
- Use get_visible_html when text isn't enough
- Use evaluate to access app state/localStorage
- Take screenshots at each step
- Check console_logs for hidden errors

## Limitations & Workarounds

**Cannot Do:**
- ❌ Generate test files → Manual creation
- ❌ Run test suites → Use `npm test`
- ❌ Mock APIs → Setup MSW in codebase
- ❌ Upload files → No direct support

**Workarounds:**

```javascript
// Set auth token
browser_evaluate("() => { localStorage.setItem('authToken', 'test'); return 'Set'; }")

// Trigger file input
browser_evaluate("() => { document.querySelector('#file-input').click() }")
```

## Quick Reference

| Task         | Command          | Example                                    |
|--------------|------------------|--------------------------------------------|
| Open page    | navigate         | `navigate("http://localhost:3000")`        |
| See page     | screenshot       | `screenshot()`                             |
| Click        | click            | `click({ selector: "text=Submit" })`       |
| Fill input   | fill             | `fill({ selector: "#email", value: "x" })` |
| Read text    | get_visible_text | `get_visible_text({ selector: ".err" })`   |
| Inspect HTML | get_visible_html | `get_visible_html({ selector: "#modal" })` |
| Run JS       | evaluate         | `evaluate("() => localStorage")`           |
| Get logs     | console_logs     | `console_logs()`                           |
| Clean up     | close            | `close()`                                  |

## Conclusion

Playwright MCP tools are for interactive browser automation - perfect for:

- ✅ Quick verification during development
- ✅ Bug investigation and debugging
- ✅ Telegram Mini App debugging (ESSENTIAL!)
- ✅ Visual regression checking
- ✅ Form testing without writing test files

NOT a replacement for automated testing - write proper .spec.ts files for CI/CD.
