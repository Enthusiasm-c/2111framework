---
name: security-checklist
description: Complete security audit checklist for web applications
model: opus
context: fork
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: "echo 'Security: Starting security audit...'"
          once: true
  Stop:
    - hooks:
        - type: command
          command: "echo 'Security: Audit complete. Review findings above.'"
          once: true
---

# Security Checklist

Complete security audit checklist for web applications.

## Authentication

### Password Storage
```typescript
// ✅ Secure: bcrypt
import bcrypt from 'bcryptjs';
const hash = await bcrypt.hash(password, 10);
const valid = await bcrypt.compare(input, hash);

// ❌ Never: MD5, SHA1, plain text
const hash = md5(password); // NEVER
```

### JWT Security
```typescript
// ✅ Secrets in env only
const secret = process.env.JWT_SECRET;

// ✅ Short expiration
const token = jwt.sign(payload, secret, { expiresIn: '1h' });

// ✅ Verify on every request
try {
  const decoded = jwt.verify(token, secret);
} catch (e) {
  return unauthorized();
}
```

### Session Management
- Use httpOnly cookies
- Set secure flag (HTTPS only)
- Implement SameSite
- Rotate session IDs after login

```typescript
// Secure cookie settings
cookies().set('session', token, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'lax',
  maxAge: 60 * 60 * 24, // 1 day
});
```

## Input Validation

### SQL Injection Prevention
```typescript
// ✅ Parameterized queries
const users = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [userInput]
);

// ❌ String concatenation - VULNERABLE
const query = `SELECT * FROM users WHERE email = '${userInput}'`;
```

### XSS Prevention
```typescript
// ✅ React escapes by default
<div>{userContent}</div>

// ⚠️ Dangerous - sanitize first
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ 
  __html: DOMPurify.sanitize(userContent) 
}} />

// ❌ Never without sanitization
<div dangerouslySetInnerHTML={{ __html: userContent }} />
```

### Zod Validation
```typescript
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(100),
  age: z.number().int().positive().optional(),
});

// Validate all input
const validated = userSchema.parse(input);
```

### File Upload Restrictions
```typescript
// Validate file type
const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
if (!allowedTypes.includes(file.type)) {
  throw new Error('Invalid file type');
}

// Validate file size
const maxSize = 5 * 1024 * 1024; // 5MB
if (file.size > maxSize) {
  throw new Error('File too large');
}

// Generate safe filename
const safeFilename = `${crypto.randomUUID()}.${ext}`;
```

## API Security

### Authorization Checks
```typescript
// ✅ Always check permissions
export async function GET(request: Request) {
  const session = await getSession(request);
  
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  
  if (session.user.role !== 'admin') {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }
  
  // Now safe to return data
  const data = await getAdminData();
  return NextResponse.json(data);
}
```

### Rate Limiting
```typescript
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

export async function POST(request: Request) {
  const ip = request.headers.get('x-forwarded-for') ?? 'anonymous';
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return NextResponse.json({ error: 'Too many requests' }, { status: 429 });
  }
  
  // Process request...
}
```

### CORS Configuration
```typescript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: 'https://yourdomain.com' },
          { key: 'Access-Control-Allow-Methods', value: 'GET, POST, OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
        ],
      },
    ];
  },
};
```

## Data Protection

### Environment Variables
```typescript
// ✅ Server-side only
const apiKey = process.env.API_KEY;

// ⚠️ Exposed to client (only for public values)
const publicUrl = process.env.NEXT_PUBLIC_URL;

// ❌ Never commit secrets
// .env.local (gitignored)
API_KEY=secret_key
```

### Error Messages
```typescript
// ✅ Safe: Generic error to client
return NextResponse.json(
  { error: 'An error occurred' },
  { status: 500 }
);

// ❌ Dangerous: Exposes internals
return NextResponse.json(
  { error: error.stack, query: sqlQuery },
  { status: 500 }
);
```

### Sensitive Data in Logs
```typescript
// ✅ Redact sensitive data
console.log('User login:', { email: user.email, id: user.id });

// ❌ Never log passwords, tokens, etc.
console.log('User:', { ...user, password: user.password });
```

## Security Headers

```typescript
// middleware.ts
import { NextResponse } from 'next/server';

export function middleware(request: Request) {
  const response = NextResponse.next();
  
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline';"
  );
  
  return response;
}
```

## Checklist Summary

### Authentication & Authorization
- [ ] Passwords hashed with bcrypt/argon2
- [ ] JWT secrets in environment variables
- [ ] Token expiration implemented
- [ ] Session management secure
- [ ] RBAC working correctly
- [ ] All routes protected

### Input Validation
- [ ] All input validated (client + server)
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] File uploads restricted
- [ ] Zod/similar validation used

### Data Protection
- [ ] Secrets in env vars only
- [ ] No secrets in logs/errors
- [ ] HTTPS enforced
- [ ] Secure cookies configured
- [ ] CORS properly set

### API Security
- [ ] Rate limiting implemented
- [ ] Auth required on protected routes
- [ ] Error messages don't leak info
- [ ] Security headers set

### Dependencies
- [ ] No known vulnerabilities (npm audit)
- [ ] Dependencies up to date
- [ ] Minimal dependencies used
