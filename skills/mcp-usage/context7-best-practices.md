# Context7 MCP - Best Practices

Context7 is an MCP server from Upstash that pulls fresh documentation and code examples directly into LLM context during prompts.

## What Context7 Does

1. You write a prompt with `use context7` trigger
2. MCP client detects the trigger
3. Context7 MCP server fetches **latest version** of official documentation
4. Returns **relevant chunks and code examples**
5. Model responds using fresh docs, not outdated training data

## When to Use Context7

### Best Use Cases

- **Version-specific queries**: "How does Next.js 15 handle middleware?"
- **New API features**: "Show me the latest Prisma client API"
- **Breaking changes**: "What changed in React 19?"
- **Correct syntax**: "Proper way to use shadcn/ui Dialog"
- **Framework updates**: "Latest NeonDB serverless driver patterns"

### Less Useful For

- General programming concepts
- Stable, unchanging APIs
- Simple syntax questions you already know
- Non-framework specific code

## Usage Patterns

### Basic Usage
```
Implement authentication middleware in Next.js 15. use context7
```

### Specific Framework Version
```
Create a form with react-hook-form v7 and zod validation. use context7
```

### Multiple Technologies
```
Set up Drizzle ORM with NeonDB in Next.js 14 App Router. use context7
```

### Debugging/Migration
```
Migrate from Pages Router to App Router in Next.js 14. use context7
```

## Best Practices

### 1. Be Specific About Versions
```
# ✅ Good
"Configure Prisma 5.10 with NeonDB. use context7"

# ❌ Vague
"Set up Prisma. use context7"
```

### 2. Mention the Framework/Library
```
# ✅ Good
"shadcn/ui DataTable with sorting and filtering. use context7"

# ❌ Missing context
"Create a data table. use context7"
```

### 3. Combine with Project Context
```
# ✅ Excellent
"I'm using Next.js 14 App Router with TypeScript.
Add react-query for data fetching with proper typing. use context7"
```

### 4. Use for Latest Patterns
```
# ✅ Gets fresh patterns
"Server Actions in Next.js 14 for form submission. use context7"

# Claude's training might be outdated on this
```

## Integration with Other MCPs

### With shadcn MCP
```
"Using shadcn MCP, install the DataTable component.
Then use context7 to get the latest TanStack Table patterns for sorting."
```

### With Playwright MCP
```
"Use context7 to get latest Playwright test patterns for Next.js.
Then use Playwright MCP to run a test manually."
```

## Common Workflows

### 1. Starting New Project
```
"I'm starting a Next.js 14 project with:
- TypeScript
- NeonDB for database
- Drizzle ORM
- shadcn/ui for components

Give me the optimal setup with latest best practices. use context7"
```

### 2. Adding New Feature
```
"Add authentication to my Next.js 14 app using NextAuth.js v5.
Include GitHub and Google providers. use context7"
```

### 3. Fixing Deprecation Warnings
```
"My Next.js app shows deprecation warnings for getServerSideProps.
How to migrate to App Router patterns? use context7"
```

### 4. Performance Optimization
```
"Optimize my Next.js 14 app for Core Web Vitals.
Focus on LCP and INP. use context7"
```

## Troubleshooting

### Context7 Not Triggering
- Ensure "use context7" is in your prompt
- Check MCP server is connected
- Restart Claude Code/Cursor

### Getting Irrelevant Docs
- Be more specific about the library/version
- Include your tech stack context
- Break complex queries into focused questions

### Outdated Information Still Appearing
- Context7 caches docs; try rephrasing
- Specify exact version number
- Ask explicitly for "latest" patterns

## Tips & Tricks

1. **Combine triggers**: Can use with other MCP commands
2. **Chain queries**: Start broad, then narrow down
3. **Specify output format**: "Show TypeScript examples"
4. **Request comparisons**: "Compare old vs new API"
5. **Ask for migration paths**: "How to upgrade from v4 to v5"

## Supported Libraries

Context7 covers major frameworks and libraries:
- Next.js (all versions)
- React
- Prisma
- Drizzle
- NeonDB
- shadcn/ui
- TanStack (Query, Table, Router)
- Tailwind CSS
- And many more...

Check Upstash/Context7 documentation for full list.
