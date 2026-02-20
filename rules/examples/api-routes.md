---
globs: "**/api/**"
description: API route conventions for Next.js App Router
---

# API Route Rules

- Export named HTTP method handlers: GET, POST, PUT, DELETE
- Validate all input with Zod schemas at the top of each handler
- Return consistent response shape: `{ success: boolean, data?, error? }`
- Use parameterized queries — never interpolate user input into SQL
- Add rate limiting for public endpoints
- Return appropriate HTTP status codes (400 for validation, 401 for auth, 500 for server)
- Log errors server-side but return safe messages to clients
