---
name: agent-routing
description: Reference table for when Claude Code should auto-launch each agent
---

# Agent Auto-Routing Reference

Claude Code uses `<example>` blocks in agent descriptions to decide when to proactively launch agents. This document summarizes the routing logic.

## Routing Table

| Trigger | Agent | Priority |
|---------|-------|----------|
| Complex feature request | **architect** | High |
| Major refactoring | **architect** | High |
| Database schema changes | **architect** | High |
| Direct implementation task | **dev** | High |
| "Add/build/create [feature]" | **dev** | High |
| After architect plan approved | **dev** | Medium |
| After feature completed | **review** | Medium |
| Before commit/deploy | **review** | Medium |
| Explicit review request | **review** | High |
| Bug report | **qa** | High |
| Before production deploy | **qa** | Medium |
| After dev completes work | **qa** | Medium |
| Auth/payment code changed | **security** | High |
| Explicit security audit | **security** | High |
| After dev modifies auth files | **security** | Medium |
| Documentation request | **docs** | High |
| New developer onboarding | **docs** | Medium |

## Routing Flow

```
User Message
    │
    ├─ "Design/plan/architect..." ──────→ architect
    ├─ "Build/add/implement..." ────────→ dev
    ├─ "Review/check/simplify..." ──────→ review
    ├─ "Test/bug/broken..." ────────────→ qa
    ├─ "Document/README/API docs..." ───→ docs
    ├─ "Security/audit/vulnerability..."→ security
    │
    └─ Implicit triggers:
       ├─ Complex feature ──────────────→ architect → dev
       ├─ After implementation ─────────→ review → qa
       ├─ Auth/payment changes ─────────→ security
       └─ New team member ─────────────→ docs
```

## Agent Chain Patterns

Common sequences where one agent triggers the next:

### Feature Development
```
architect → (plan approved) → dev → review → qa → security (if auth-related)
```

### Bug Fix
```
qa (reproduce) → dev (fix) → review → qa (verify)
```

### Security Audit
```
security → dev (fix vulnerabilities) → security (verify fixes)
```

### Documentation
```
docs → (review for accuracy) → docs (final version)
```

## How Auto-Routing Works

Each agent's `description` in frontmatter contains `<example>` blocks:

```yaml
description: |
  Agent description. Use proactively when...

  <example>
  Context: situation description
  user: "user message"
  <commentary>Why this agent should be launched</commentary>
  assistant: Uses Task tool to launch agent
  </example>
```

Claude Code matches user messages against these examples to decide when to proactively suggest or launch an agent without explicit `/command` invocation.

## Manual Override

Users can always invoke agents directly:
- `/architect` — force architect
- `/review` — force review
- `/dev` — force dev
- `/qa` — force QA
- `/docs` — force docs
- `/security` — force security
