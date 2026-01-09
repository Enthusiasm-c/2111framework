---
name: accessibility-basics
description: Essential guide for WCAG 2.1/2.2 compliance
category: code-quality
updated: 2026-01-09
model: sonnet
forked_context: false
---

# Web Accessibility (a11y) Basics

Essential guide for WCAG 2.1/2.2 compliance.

## WCAG Principles

1. **Perceivable** - Users can perceive content
2. **Operable** - Users can navigate and use interface
3. **Understandable** - Users can understand content
4. **Robust** - Works with assistive technologies

### Compliance Levels
- **A** - Minimum (must have)
- **AA** - Standard (recommended)
- **AAA** - Enhanced (ideal)

## Semantic HTML

### Heading Hierarchy
```html
<!-- ✅ Correct hierarchy -->
<h1>Page Title</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>
  <h2>Another Section</h2>

<!-- ❌ Skipping levels -->
<h1>Page Title</h1>
  <h3>Subsection</h3> <!-- Missing h2 -->
```

### Landmark Regions
```html
<header>Site header</header>
<nav>Navigation</nav>
<main>
  <article>Main content</article>
  <aside>Sidebar</aside>
</main>
<footer>Site footer</footer>
```

### Button vs Link
```html
<!-- Button: Actions -->
<button onClick={handleSubmit}>Submit Form</button>

<!-- Link: Navigation -->
<a href="/dashboard">Go to Dashboard</a>

<!-- ❌ Don't use div/span for interactive elements -->
<div onClick={handleClick}>Click me</div>
```

## Keyboard Navigation

### Focus Management
```typescript
// Focus visible styles (don't remove!)
// globals.css
:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}

// ❌ Never do this
*:focus { outline: none; }
```

### Tab Order
```html
<!-- Natural order follows DOM -->
<input tabindex="0" /> <!-- Normal -->
<button tabindex="-1">Skip</button> <!-- Removed from tab order -->

<!-- ❌ Avoid positive tabindex -->
<input tabindex="3" /> <!-- Creates confusing order -->
```

### Skip Links
```html
<a href="#main-content" className="sr-only focus:not-sr-only">
  Skip to main content
</a>

<main id="main-content">
  ...
</main>
```

### Modal Focus Trapping
```typescript
// shadcn/ui Dialog handles this automatically
// For custom modals:
import { FocusTrap } from '@radix-ui/react-focus-trap';

<FocusTrap>
  <div role="dialog" aria-modal="true">
    {/* Focus stays inside */}
  </div>
</FocusTrap>
```

## ARIA Attributes

### When to Use ARIA
```html
<!-- ✅ Use when HTML semantics aren't enough -->
<button aria-expanded="false" aria-controls="menu">
  Menu
</button>

<!-- ✅ Live regions for dynamic content -->
<div aria-live="polite">
  {notification}
</div>

<!-- ❌ Don't use ARIA when HTML works -->
<div role="button">Click</div> <!-- Just use <button> -->
```

### Common ARIA Patterns
```html
<!-- Label association -->
<label id="email-label">Email</label>
<input aria-labelledby="email-label" />

<!-- Described by -->
<input aria-describedby="email-hint" />
<span id="email-hint">We'll never share your email</span>

<!-- Error states -->
<input aria-invalid="true" aria-describedby="email-error" />
<span id="email-error" role="alert">Invalid email</span>

<!-- Hidden content -->
<span aria-hidden="true">🔒</span> <!-- Decorative -->
```

## Form Accessibility

### Label Association
```html
<!-- ✅ Explicit association -->
<label htmlFor="email">Email</label>
<input id="email" type="email" />

<!-- ✅ Implicit association -->
<label>
  Email
  <input type="email" />
</label>
```

### Required Fields
```html
<label htmlFor="name">
  Name <span aria-hidden="true">*</span>
  <span className="sr-only">(required)</span>
</label>
<input id="name" required aria-required="true" />
```

### Error Messages
```typescript
<FormField
  name="email"
  render={({ field, fieldState }) => (
    <FormItem>
      <FormLabel>Email</FormLabel>
      <FormControl>
        <Input
          {...field}
          aria-invalid={!!fieldState.error}
          aria-describedby={fieldState.error ? "email-error" : undefined}
        />
      </FormControl>
      {fieldState.error && (
        <FormMessage id="email-error" role="alert">
          {fieldState.error.message}
        </FormMessage>
      )}
    </FormItem>
  )}
/>
```

## Color & Contrast

### Contrast Ratios (WCAG AA)
- **Normal text**: 4.5:1 minimum
- **Large text** (18px+): 3:1 minimum
- **UI components**: 3:1 minimum

### Not Relying on Color Alone
```html
<!-- ✅ Color + icon/text -->
<span className="text-red-500">
  <ErrorIcon /> Error: Invalid input
</span>

<!-- ❌ Color only -->
<span className="text-red-500">Invalid</span>
```

### Focus Indicators
```css
/* Ensure visible focus */
button:focus-visible {
  outline: 2px solid #2563eb;
  outline-offset: 2px;
}
```

## Images & Media

### Alt Text
```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 25% in Q4 2024" />

<!-- Decorative image -->
<img src="decoration.png" alt="" aria-hidden="true" />

<!-- Complex image -->
<figure>
  <img src="diagram.png" alt="System architecture" aria-describedby="diagram-desc" />
  <figcaption id="diagram-desc">
    Detailed description of the architecture...
  </figcaption>
</figure>
```

### Icon Buttons
```typescript
// ✅ With accessible label
<Button variant="ghost" size="icon" aria-label="Close dialog">
  <X className="h-4 w-4" />
</Button>

// ❌ Missing label
<Button variant="ghost" size="icon">
  <X className="h-4 w-4" />
</Button>
```

## Testing

### Automated Tools
- **axe DevTools** - Browser extension
- **Lighthouse** - Built into Chrome
- **eslint-plugin-jsx-a11y** - Linting

### Manual Testing
1. **Keyboard only**: Navigate without mouse
2. **Screen reader**: Test with NVDA/VoiceOver
3. **Zoom**: Test at 200% zoom
4. **Color**: Check with color blindness simulators

### Screen Reader Testing
```bash
# macOS
# Enable: System Preferences → Accessibility → VoiceOver

# Windows  
# NVDA: Free download from nvaccess.org

# Testing commands
# Tab: Next focusable element
# Shift+Tab: Previous focusable element
# Enter/Space: Activate button
# Escape: Close modal
```

## Quick Checklist

### Must Have (Level A)
- [ ] All images have alt text
- [ ] Page has title
- [ ] Form inputs have labels
- [ ] No keyboard traps
- [ ] Link purpose is clear

### Should Have (Level AA)
- [ ] 4.5:1 contrast ratio
- [ ] Text resizable to 200%
- [ ] Focus visible
- [ ] Skip links available
- [ ] Error suggestions provided

### Nice to Have (Level AAA)
- [ ] 7:1 contrast ratio
- [ ] Sign language for video
- [ ] Extended audio description
