---
name: github-mcp-guide
description: GitHub MCP server for managing repos, issues, PRs from Claude Code
model: sonnet
---

# GitHub MCP Server

Manage GitHub repos, issues, PRs directly from Claude Code.

## Installation

```bash
claude mcp add github npx -y @modelcontextprotocol/server-github
```

### Authentication
Set GitHub token in environment:
```bash
export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxx
```

Or add to Claude config:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxx"
      }
    }
  }
}
```

### Required Scopes
- `repo` — Full control of private repositories
- `read:org` — Read org membership (for org repos)

---

## Capabilities

| Feature | What it does |
|---------|-------------|
| Issues | Create, read, update, close |
| Pull Requests | Create, review, merge, list |
| Commits | View history, diff |
| Branches | List, create |
| Files | Read, create, update |
| Search | Code, issues, repos |

---

## Usage Examples

### Issues

**List open issues:**
```
"Show me open issues in Enthusiasm-c/notaapp"
```

**Create issue:**
```
"Create a GitHub issue in notaapp:
Title: OCR accuracy drops on blurry photos
Body: When photos are blurry, OCR extracts incorrect item names.
Steps to reproduce:
1. Take a blurry photo
2. Upload to app
3. Check extracted items
Labels: bug, ocr"
```

**Close issue:**
```
"Close issue #42 in notaapp with comment: Fixed in commit abc123"
```

### Pull Requests

**List PRs:**
```
"Show open pull requests in Enthusiasm-c/ave-ai"
```

**Create PR:**
```
"Create a PR in ave-ai:
Base: main
Head: feature/dark-mode
Title: Add dark mode support
Body: Implements dark mode following Telegram theme"
```

**Review PR:**
```
"Review PR #15 in notaapp for security issues"
```

**Merge PR:**
```
"Merge PR #15 in notaapp using squash merge"
```

### Code & Commits

**View recent commits:**
```
"Show last 5 commits on main branch in notaapp"
```

**View file:**
```
"Show contents of src/lib/ocr.ts in notaapp"
```

**Search code:**
```
"Search for 'validateInitData' in Enthusiasm-c repos"
```

### CI/CD Status

**Check workflow runs:**
```
"Show CI status for latest commit in notaapp"
```

**View failed runs:**
```
"Show failed GitHub Actions runs in ave-ai"
```

---

## Common Workflows

### Bug Triage
```
1. "List open issues labeled 'bug' in notaapp"
2. "Show details of issue #42"
3. "Add label 'priority-high' to issue #42"
4. "Assign issue #42 to me"
```

### PR Review Flow
```
1. "List PRs waiting for review in ave-ai"
2. "Show diff for PR #15"
3. "Check CI status for PR #15"
4. "Add review comment: LGTM, merging"
5. "Merge PR #15"
```

### Release Prep
```
1. "Show all merged PRs since last release in notaapp"
2. "Create release notes from merged PRs"
3. "Create tag v1.2.0 with release notes"
```

---

## Integration with Other MCPs

### With Context7
```
"Using Context7, find how to implement GitHub webhooks in Next.js,
then create an issue in notaapp to track this task"
```

### With Sentry
```
"Check Sentry for recent errors,
then create GitHub issues for top 3 bugs"
```

---

## Best Practices

### DO
- Use for quick operations (check status, create issue)
- Combine with code exploration
- Automate repetitive tasks
- Review PRs with security agent

### DON'T
- Use for complex git operations (rebase, conflict resolution)
- Replace GitHub web for large code reviews
- Store tokens in code

---

## Troubleshooting

### "Authentication failed"
1. Check token is set: `echo $GITHUB_PERSONAL_ACCESS_TOKEN`
2. Verify token has correct scopes
3. Regenerate if expired

### "Repository not found"
1. Check spelling: `owner/repo`
2. Verify token has access to private repos
3. Check org membership

### "Rate limit exceeded"
GitHub API limits: 5000 requests/hour
- Wait or use different token
- Cache repeated queries

---

## Quick Reference

| Command Pattern | Example |
|----------------|---------|
| List issues | "Show open issues in owner/repo" |
| Create issue | "Create issue: [title] in owner/repo" |
| View PR | "Show PR #123 in owner/repo" |
| Create PR | "Create PR from branch-a to main" |
| Merge PR | "Merge PR #123" |
| Check CI | "Show CI status for owner/repo" |
| Search | "Search for 'function' in owner/repo" |
