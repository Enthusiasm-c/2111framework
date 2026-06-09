---
name: secret-rotation
description: Triage and rotate leaked secrets — when an API key, token, or credential was committed to git, hardcoded, or pasted into a tracked file. Covers Neon, OpenAI/Anthropic, AWS, Telegram, and the general drill.
---

# Secret Rotation Drill

A secret that ever touched git history is compromised — `git rm`, `.gitignore`, or "untrack" does **not** remove it from history. The only safe fix is **rotate the key**, then prevent recurrence.

## The drill

1. **Find it.**
   ```bash
   # Is the file tracked now?
   git ls-files --error-unmatch path/to/file
   # Did it ever live in history?
   git log --oneline -- path/to/file
   git log -p -S 'napi_' -- . | head   # search history for a key prefix
   ```
2. **Rotate at the source** (revoke old, issue new) — see provider table below. This is the only step that actually closes the hole. **You (the human) must do this** — the agent cannot revoke keys.
3. **Update the live secret** in env/secret manager (Vercel env vars, `.env.local`, Neon connection string). Never commit the new one.
4. **Stop the leak recurring:** ensure the file is in `.gitignore`; move the value to env. For `.mcp.json` with inline keys, untrack and gitignore it.
5. **(Optional) Purge history** if the repo is shared/public: `git filter-repo` or BFG, then force-push — coordinate, it rewrites history. For a private solo repo, rotation alone is usually enough.
6. **Delete the breadcrumb file** (e.g. `API_KEYS_TO_ROTATE_NOW.md`) — and never store live keys in a tracked doc.

## Where to rotate

| Provider | Rotate at |
|----------|-----------|
| Neon (`napi_…`) | Neon Console → Account → API Keys → revoke + create |
| OpenAI (`sk-…`) | platform.openai.com/api-keys |
| Anthropic | console.anthropic.com → API Keys |
| AWS | IAM → access keys → deactivate + create; rotate in env |
| Telegram bot | @BotFather → /revoke → new token |
| Xero / Resend / Upstash | provider dashboard → API keys |

## Prevent (already in this framework)
- `config/settings.json` **protected-files hook** blocks editing `.env*` and lockfiles.
- Add `.mcp.json` to `.gitignore` if it holds inline credentials (prefer env/OAuth MCP servers).
- Never paste live keys into `*.md` or commit messages.

## Known open items (audit June 2026)
- **menuai:** Neon key `napi_…` lived in `.mcp.json` in git history (now untracked). **Rotate it.**
- **notaapp:** `API_KEYS_TO_ROTATE_NOW.md` is tracked — verify keys rotated, then remove the file.
