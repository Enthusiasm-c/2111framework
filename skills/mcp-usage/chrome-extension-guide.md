---
name: chrome-extension-guide
description: Browser automation via native Chrome extension for frontend testing
model: sonnet
---

# Claude Chrome Extension - Complete Usage Guide

Browser automation via native Chrome extension for frontend testing.

## When to Use

**ALWAYS use Chrome Extension for:**
- Full frontend testing
- UI verification after changes
- Debugging user scenarios
- Testing forms and interactive elements
- Responsive design verification
- Telegram Mini App testing

## What Chrome Extension CAN Do

- ✅ Page navigation
- ✅ Clicks, text input, form submission
- ✅ Real-time console.log reading
- ✅ JavaScript execution on page
- ✅ Screenshots and GIF recording
- ✅ Tab management
- ✅ Using existing sessions (authentication)
- ✅ Viewport resizing

## What It CANNOT Do

- ❌ Headless mode (requires visible browser)
- ❌ WSL support
- ❌ Brave, Arc and other Chromium browsers
- ❌ Automatic CAPTCHA solving
- ❌ Interaction with modal JS dialogs (alert/confirm)

---

## Installation

### Requirements
- Google Chrome (not Brave, not Arc)
- Claude Code v2.0.73+
- Paid Claude plan (Pro/Team/Enterprise)

### Installation Steps

```bash
# 1. Update Claude Code
claude update

# 2. Install extension from Chrome Web Store
# https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn

# 3. Sign in to Claude account in extension

# 4. Pin extension (puzzle icon → pin)

# 5. Launch Claude with Chrome
claude --chrome

# 6. Verify connection
/chrome
```

### Enable by Default
```bash
/chrome
# Select "Enable by default"
```

---

## Commands

### Navigation
```
"Open localhost:3000"
"Navigate to https://example.com/login"
"Go back to previous page"
```

### Interaction
```
"Click the Submit button"
"Fill the email field with test@example.com"
"Type 'hello world' in the search input"
"Select 'Option 2' from the dropdown"
```

### Forms
```
"Fill the login form: email test@test.com, password secret123"
"Submit the form"
"Clear all form fields"
```

### Screenshots and Recording
```
"Take a screenshot"
"Screenshot the modal dialog"
"Record a GIF of the checkout flow"
```

### Debugging
```
"Check the console for errors"
"What JavaScript errors are on this page?"
"Show me the network requests"
```

### Data Extraction
```
"Extract all product names and prices"
"Save the table data as CSV"
"Get the text content of the error message"
```

### Viewport
```
"Resize to mobile view (375x667)"
"Switch to tablet size"
"Set viewport to 1920x1080"
```

### Tabs
```
"Open a new tab with google.com"
"Switch to the first tab"
"Close current tab"
```

---

## Common Testing Scenarios

### 1. Basic Page Verification
```
1. "Open localhost:3000"
2. "Take a screenshot"
3. "Check the console for errors"
4. "What text is visible on the page?"
```

### 2. Authentication Testing
```
1. "Open localhost:3000/login"
2. "Fill email with test@example.com"
3. "Fill password with password123"
4. "Take a screenshot"
5. "Click Login button"
6. "Wait 2 seconds"
7. "Take a screenshot"
8. "Check console for errors"
9. "What page are we on now?"
```

### 3. Form Testing
```
1. "Open localhost:3000/contact"
2. "Fill the form: name John Doe, email john@test.com, message Hello"
3. "Screenshot before submit"
4. "Click Submit"
5. "Wait for success message"
6. "Screenshot after submit"
7. "Any console errors?"
```

### 4. Modal Testing
```
1. "Open localhost:3000/dashboard"
2. "Click Settings button"
3. "Wait for modal to appear"
4. "Screenshot the modal"
5. "Click Close button"
6. "Verify modal is closed"
7. "Screenshot"
```

### 5. Responsive Testing
```
1. "Open localhost:3000"
2. "Screenshot at desktop (1920x1080)"
3. "Resize to tablet (768x1024)"
4. "Screenshot"
5. "Resize to mobile (375x667)"
6. "Screenshot"
7. "Check for horizontal scroll"
```

### 6. E2E Flow (Checkout)
```
1. "Open localhost:3000"
2. "Click on first product"
3. "Click Add to Cart"
4. "Go to cart page"
5. "Screenshot cart"
6. "Click Checkout"
7. "Fill shipping form with test data"
8. "Screenshot"
9. "Click Place Order"
10. "Wait for confirmation"
11. "Screenshot final state"
12. "Record GIF of the whole flow"
```

---

## Telegram Mini App Testing

### SDK Verification
```
1. "Open https://t.me/yourbot/app"
2. "Check if Telegram.WebApp is loaded"
3. "Get initData value"
4. "Screenshot the app"
5. "Check console for errors"
```

### MainButton Testing
```
1. "Open the mini app"
2. "Verify MainButton is visible"
3. "Click MainButton"
4. "Check what happened"
5. "Screenshot"
```

### Theme Testing
```
1. "Open mini app"
2. "Get current theme (light/dark)"
3. "Screenshot"
4. "Check CSS variables from themeParams"
```

---

## Best Practices

### General Rules
- ✅ Always start with navigation to target page
- ✅ Take screenshots BEFORE and AFTER important actions
- ✅ Check console.log after each action
- ✅ Wait for loading before next action
- ✅ Use specific selectors (data-testid > text > CSS)

### Form Testing
- ✅ Test validation (empty fields, invalid format)
- ✅ Check error messages
- ✅ Test successful submission
- ✅ Verify post-submission state

### Debugging
- ✅ First check console for errors
- ✅ Check network requests for API issues
- ✅ Use screenshots for visual verification
- ✅ Check localStorage/sessionStorage via JS

---

## Handling Blockers

### Modal Dialogs (alert/confirm/prompt)
```
# Chrome Extension cannot automatically close JS dialogs
# Close manually and say:
"Continue, I dismissed the dialog"
```

### CAPTCHA
```
# Solve CAPTCHA manually and say:
"Continue, I solved the captcha"
```

### Authentication
```
# Option 1: Use existing session
# (Log in to Chrome before running claude --chrome)

# Option 2: Ask to fill form
"Fill login form and submit"
```

### Unresponsive Page
```
"Open a new tab"
# or restart extension
```

---

## QA Agent Integration

When running QA agent with frontend testing:

```markdown
## QA with Chrome Extension

### Required Checklist:
1. [ ] Run `claude --chrome`
2. [ ] Verify connection `/chrome`
3. [ ] Open target page
4. [ ] Screenshot initial state
5. [ ] Execute test cases
6. [ ] Screenshot each step
7. [ ] Check console for errors
8. [ ] Final screenshot
9. [ ] Record GIF of critical flow (optional)
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Extension not detected | Check versions: Code v2.0.73+, Extension v1.0.36+ |
| Browser not responding | Check for modal dialogs, request new tab |
| First run not working | Restart Chrome to install native messaging host |
| No connection | Run `/chrome` and select "Reconnect" |
| Actions not executing | Wait for page load, use explicit waits |

---

## Quick Reference

| Task | Command |
|------|---------|
| Open page | "Open localhost:3000" |
| Screenshot | "Take a screenshot" |
| Click | "Click the Submit button" |
| Type text | "Type 'hello' in the search field" |
| Fill form | "Fill email with test@test.com" |
| Check errors | "Check console for errors" |
| Resize | "Resize to mobile (375x667)" |
| Record GIF | "Record a GIF of this flow" |
| New tab | "Open new tab" |

---

## Summary

Chrome Extension is the primary tool for frontend testing in Claude Code:

- ✅ Testing with real sessions
- ✅ Visual verification (screenshots, GIF)
- ✅ Console.log debugging
- ✅ Responsive design testing
- ✅ E2E scenarios
- ✅ Telegram Mini App testing

**Use for every frontend testing session!**
