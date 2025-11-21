# Project Context Template

Copy this to `.claude/context.md` in your project root.

```markdown
# Project: My App

Type: Next.js web application
Stack: Next.js 14, TypeScript, NeonDB, Vercel

## Key Info:
- 2 roles: admin, user
- Features: auth, dashboard, reports
- Database: users, data tables

## Current Focus:
- Building core features
- Setting up authentication

## Special Notes:
- Mobile-first design
- Real-time updates required
```

Then reference in Claude Code:
```
Read .claude/context.md for project context.
Act as Developer Agent.
Task: [your task]
```
