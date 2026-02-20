---
alwaysApply: true
description: Testing conventions applied to all files
---

# Testing Rules

- Write tests alongside the code they test (`*.test.ts` next to source)
- Use descriptive test names: `it('should return 401 when token is expired')`
- Follow Arrange-Act-Assert pattern
- Mock external services (APIs, databases) — never hit real services in tests
- Test edge cases: empty input, null values, boundary conditions
- Keep tests independent — no shared mutable state between tests
- Prefer Vitest for unit tests, Playwright for E2E
