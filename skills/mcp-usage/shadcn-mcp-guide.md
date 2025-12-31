---
name: shadcn-mcp-guide
description: Official shadcn MCP server for component installation
category: mcp-usage
---

# shadcn MCP - Usage Guide

Official shadcn MCP server bridges your AI assistant with the shadcn registry + CLI.

## What shadcn MCP Does

### Capabilities
- **Browse components** - list all available components, blocks, templates from any registry
- **Search registries** - find components by name or purpose
- **Install items** - run real shadcn CLI to add components
- **Multiple registries** - shadcn/ui, private company registries, community registries

### Tool Surface

**Discovery tools:**
- `list-components` - list all components in registry
- `list-blocks` - list higher-level blocks/templates
- `list-registries` - enumerate configured registries

**Lookup tools:**
- `get-component-docs` - fetch props, usage snippets
- `get-block-docs` - same for blocks

**Install tools:**
- `install-component` - equivalent to `npx shadcn@latest add button`
- `install-blocks` - install full blocks/flows

### What It Cannot Do
- Does not invent new components outside registries
- Does not replace build tools or framework
- Cannot run dev server, build, or deploy
- Cannot bypass registry rules

## Installation

```bash
# Initialize MCP for Claude
pnpm dlx shadcn@latest mcp init --client claude
# or
npx shadcn@latest mcp init --client claude
```

This writes/updates MCP config:
```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

## Dependency Handling

Yes - MCP delegates to registry + CLI:
- Registry items expose `dependencies` (npm packages) and `registryDependencies` (other items)
- CLI installs npm deps (e.g. @radix-ui/react-tooltip, zod, lucide-react)
- CLI installs required registry items (button, input, utilities)

## Workflow Example

**Prompt:**
"Add button, dialog, and card components to my Next.js project and create a contact form page"

**Under the hood:**
1. Call discovery tool to confirm components exist
2. Call install tool (equivalent to `shadcn add button dialog card`)
3. Write `app/contact/page.tsx` composing those components
4. Show diff or open files in IDE

**Result structure:**
```
components/
  ui/
    button.tsx
    dialog.tsx
    card.tsx
lib/
  utils.ts
app/
  contact/
    page.tsx
```

## Best Practices

### When to Use MCP
- AI-assisted UI assembly ("Build a Kanban board...")
- Want up-to-date props/patterns from live registries
- Multiple registries (shadcn/ui + private @acme)

### When to Use Manual CLI
- You know exactly what you need
- Scripting in CI
- Debugging registry issues

### Common Workflows

**1. Greenfield product UI**
- Init project + shadcn
- Use MCP for layout skeletons, navigation, auth flows
- Hand-tune typography and business logic

**2. Refactors/upgrades**
- "Show me latest API for DataTable and update my usage"
- MCP fetches new docs; refactor accordingly

**3. Multi-registry design systems**
- Configure @acme + @internal registries in components.json
- "Build pricing page using blocks from @acme and shadcn base"

## Troubleshooting

**MCP server not responding:**
- Check .mcp.json config
- Restart client (Claude Code, Cursor)
- Run /mcp and confirm server is "Connected"
- Ensure shadcn installed and components.json exists

**Registry access problems:**
- Validate registry URLs in components.json
- Check env vars (tokens) for private registries
- Make sure registry is online

**Installation failures:**
- Confirm directories exist with write permission
- Check components.json is valid JSON
- Look at MCP logs for detailed errors

**No tools visible:**
- Clear npx cache: `npx clear-npx-cache`
- Disable & re-enable MCP server
- Inspect MCP logs in client output
