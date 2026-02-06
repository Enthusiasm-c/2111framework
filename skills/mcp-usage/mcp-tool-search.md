---
name: mcp-tool-search
description: MCP lazy loading reference. How serverInstructions work and how to optimize MCP server configuration for minimal context usage.
---

# MCP Tool Search & Lazy Loading

Optimize MCP server configuration to minimize context window usage.

## The Problem

Each MCP server adds tool definitions to the system prompt. With many servers, your 200k context can shrink to 70k before you even start working.

| MCP Server | Approx. Tools | Approx. Tokens |
|------------|---------------|----------------|
| shadcn | 7 | ~1,750 |
| context7 | 2 | ~800 |
| clerk | 17 | ~6,000 |
| magic (21st) | 4 | ~1,600 |
| playwright | 10 | ~3,000 |

---

## Tool Search (Lazy Loading)

Claude Code supports `ToolSearch` -- a mechanism that loads MCP tool definitions on-demand rather than all at once.

### How It Works

1. MCP server provides `serverInstructions` -- a short text describing what the server does
2. Only `serverInstructions` are loaded into context (not full tool schemas)
3. When Claude needs a tool, it searches available servers and loads the relevant tool

### Configuration

In `mcp.json`:

```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"],
      "serverInstructions": "Use for shadcn/ui component installation and registry browsing"
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "serverInstructions": "Use for fetching up-to-date library documentation and code examples"
    }
  }
}
```

### Savings

| Without serverInstructions | With serverInstructions |
|---------------------------|------------------------|
| All tool schemas loaded upfront | Only short descriptions loaded |
| ~10k+ tokens per server | ~100-200 tokens per server |
| Scales poorly | Scales well |

---

## Recommended mcp.json

```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"],
      "serverInstructions": "Use for shadcn/ui component installation and registry browsing"
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "serverInstructions": "Use for fetching up-to-date library documentation and code examples"
    }
  }
}
```

### Per-Project Overrides

Add project-specific MCP servers in `~/.claude.json`:

```json
{
  "projects": {
    "/path/to/project": {
      "mcpServers": {
        "clerk": {
          "command": "npx",
          "args": ["-y", "@clerk/agent-toolkit", "-p", "local-mcp"],
          "serverInstructions": "Use for Clerk user management, organizations, invitations"
        }
      }
    }
  }
}
```

### Disabling MCP for a Project

```json
{
  "projects": {
    "/path/to/project": {
      "disabledMcpServers": ["shadcn"]
    }
  }
}
```

---

## Best Practices

1. **Keep global MCP servers minimal** -- only servers used across all projects
2. **Use serverInstructions** on every MCP server for lazy loading
3. **Move project-specific servers** to per-project config
4. **Disable unused servers** per project to save context
5. **Monitor context usage** -- if you're hitting limits, check MCP token overhead

---

## Related Skills

- `context7-best-practices.md` - Context7 documentation lookup
- `shadcn-mcp-guide.md` - shadcn component installation
- `clerk-mcp-guide.md` - Clerk user management
