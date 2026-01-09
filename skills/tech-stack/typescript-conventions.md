---
name: typescript-conventions
description: TypeScript strict mode and type conventions
category: tech-stack
updated: 2026-01-09
model: sonnet
forked_context: false
---

# TypeScript Conventions

## Strict Mode (Always)
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true
  }
}
```

## Types vs Interfaces
```typescript
// Types (prefer for unions/primitives)
type Status = 'active' | 'inactive';
type UserID = string;

// Interfaces (prefer for objects)
interface User {
  id: UserID;
  email: string;
  status: Status;
}
```

## Avoid `any`
```typescript
// ❌ Bad
function process(data: any) {}

// ✅ Good
function process(data: unknown) {
  if (typeof data === 'string') {
    // TypeScript knows it's string here
  }
}
```

## Utility Types
```typescript
type Partial<User>    // All optional
type Required<User>   // All required
type Pick<User, 'id'> // Subset
type Omit<User, 'password'> // Exclude
```
