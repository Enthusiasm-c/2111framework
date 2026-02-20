---
globs: "**/*.tsx"
description: React component conventions for TSX files
---

# React Component Rules

- Use functional components with TypeScript interfaces for props
- Server Components by default; add 'use client' only for interactivity
- Keep components under 100 lines; extract sub-components if larger
- Use named exports, not default exports
- Place hooks at the top of the component, before any conditionals
- Colocate styles with Tailwind — avoid separate CSS files
- Use shadcn/ui components before building custom UI
