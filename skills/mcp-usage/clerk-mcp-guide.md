---
name: clerk-mcp-guide
description: Clerk MCP server for managing users, organizations, invitations from Claude Code
model: sonnet
---

# Clerk MCP Server

Manage Clerk users, organizations, and invitations directly from Claude Code.

## Installation

```bash
claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp
```

### With Secret Key

```bash
claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp --secret-key sk_live_xxxx
```

### Claude Config (JSON)

```json
{
  "mcpServers": {
    "clerk": {
      "command": "npx",
      "args": ["-y", "@clerk/agent-toolkit", "-p=local-mcp"],
      "env": {
        "CLERK_SECRET_KEY": "sk_live_xxxx"
      }
    }
  }
}
```

### Get Secret Key

1. Go to [Clerk Dashboard](https://dashboard.clerk.com)
2. Select your application
3. Settings → API Keys
4. Copy **Secret Key** (starts with `sk_live_` or `sk_test_`)

---

## Available Tools

### Users

| Tool | Description |
|------|-------------|
| `users.getUser` | Get user by ID |
| `users.getUserList` | List all users with filters |
| `users.getUserCount` | Count users |
| `users.updateUserMetadata` | Update user public/private metadata |

### Organizations

| Tool | Description |
|------|-------------|
| `organizations.getOrganization` | Get org by ID |
| `organizations.getOrganizationList` | List all organizations |
| `organizations.createOrganizationInvitation` | Invite user to org |

### Invitations

| Tool | Description |
|------|-------------|
| `invitations.getInvitationList` | List pending invitations |
| `invitations.revokeInvitation` | Cancel an invitation |

---

## Limiting Tools

Only enable specific tools:

```bash
# Only user tools
claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp --tools users

# Multiple categories
claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp --tools "users organizations"

# Specific tools only
claude mcp add clerk -- npx -y @clerk/agent-toolkit -p local-mcp --tools "users.getUserCount organizations.getOrganization"
```

---

## Usage Examples

### User Management

**Get user info:**
```
"Get Clerk user with ID user_2abc123"
```

**List users:**
```
"Show all Clerk users created in the last 7 days"
```

**Count users:**
```
"How many users are registered in my Clerk app?"
```

**Update metadata:**
```
"Update user user_2abc123 metadata: set plan to 'premium'"
```

### Organizations

**List orgs:**
```
"Show all organizations in Clerk"
```

**Get org details:**
```
"Get organization org_xyz details"
```

**Invite to org:**
```
"Invite user@example.com to organization org_xyz with admin role"
```

### Invitations

**List pending:**
```
"Show all pending Clerk invitations"
```

**Revoke:**
```
"Revoke invitation inv_abc123"
```

---

## Common Workflows

### Onboarding Check

```
1. "Count total Clerk users"
2. "List users who signed up today"
3. "Show users without organizations"
```

### Organization Setup

```
1. "List all organizations"
2. "Get members of organization org_xyz"
3. "Invite team@company.com to org_xyz as member"
```

### User Audit

```
1. "List all users with their metadata"
2. "Find users with plan='free' in metadata"
3. "Update user user_123 metadata: set trial_ends to '2025-02-01'"
```

---

## Integration with Supabase

Clerk + Supabase RLS workflow:

```typescript
// Get Clerk user ID
const user = await clerk.users.getUser(userId);

// Use in Supabase RLS
// Policy: user_id = (auth.jwt() ->> 'sub')
```

**From Claude Code:**
```
1. "Get Clerk user user_2abc123"
2. "Check their subscription in Supabase"
3. "Update Clerk metadata with subscription status"
```

---

## Integration with Other MCPs

### With GitHub MCP

```
"Check Clerk user count, then create a GitHub issue
with metrics report for the week"
```

### With Neon MCP

```
"Get all Clerk users with premium plan,
then query their orders from Neon database"
```

---

## Code Integration

### Vercel AI SDK

```typescript
import { createClerkToolkit } from '@clerk/agent-toolkit/ai-sdk';
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

const toolkit = await createClerkToolkit();

const result = await streamText({
  model: openai('gpt-4o'),
  tools: {
    ...toolkit.users(),
    ...toolkit.organizations(),
  },
  messages: [{ role: 'user', content: 'List all users' }],
});
```

### LangChain

```typescript
import { createClerkToolkit } from '@clerk/agent-toolkit/langchain';
import { ChatOpenAI } from '@langchain/openai';

const toolkit = await createClerkToolkit();
const model = new ChatOpenAI({ model: 'gpt-4o' });
const modelWithTools = model.bindTools(toolkit.allTools());
```

### Custom MCP Server

```typescript
import { createClerkMcpServer } from '@clerk/agent-toolkit/modelcontextprotocol';

const server = createClerkMcpServer({
  secretKey: process.env.CLERK_SECRET_KEY,
  tools: ['users', 'organizations'],
});
```

---

## Security Best Practices

### DO

- Use `sk_test_` keys for development
- Limit tools to what you need (`--tools users`)
- Store secret key in env vars
- Use for admin/internal tools only

### DON'T

- Expose secret key in client code
- Use in production AI chatbots without guardrails
- Allow unrestricted user updates
- Share keys across environments

---

## Troubleshooting

### "Invalid API Key"

1. Check key starts with `sk_live_` or `sk_test_`
2. Verify key in Clerk Dashboard → API Keys
3. Regenerate if compromised

### "User not found"

1. Check user ID format: `user_xxxxx`
2. Verify user exists in Dashboard → Users
3. Check you're using correct environment (test vs live)

### "Permission denied"

1. Secret key has full access by default
2. Check if using restricted key
3. Verify organization membership

---

## Quick Reference

| Command Pattern | Example |
|----------------|---------|
| Get user | "Get Clerk user user_abc123" |
| List users | "List all Clerk users" |
| Count users | "How many Clerk users?" |
| Update metadata | "Update user metadata: plan=premium" |
| List orgs | "Show all organizations" |
| Invite to org | "Invite email@example.com to org_xyz" |
| List invitations | "Show pending invitations" |
| Revoke invite | "Revoke invitation inv_123" |

---

## Related Skills

- `neondb-best-practices.md` - Database with Clerk user_id
- `nextjs-app-router.md` - Clerk auth in Next.js
- `github-mcp-guide.md` - Combine with GitHub automation

---

## Resources

- [Clerk Agent Toolkit](https://www.npmjs.com/package/@clerk/agent-toolkit)
- [Clerk MCP Docs](https://clerk.com/docs/guides/development/mcp/overview)
- [GitHub Repository](https://github.com/clerk/javascript/tree/main/packages/agent-toolkit)
