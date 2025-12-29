# 🔄 Migration to v2.0

## Changes

### ❌ Removed
- Playwright MCP

### ✅ Added
- 21st.dev Magic MCP
- Claude Chrome Extension

---

## Steps

\`\`\`bash
# 1. Remove Playwright
# Edit ~/.claude/mcp.json
# Delete "playwright" entry

# 2. Add 21st.dev Magic
claude mcp add 21st-magic npx -y @21st-dev/magic@latest
# Get API key: https://21st.dev/magic

# 3. Install Chrome Extension
# https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn

# 4. Enable Chrome
claude --chrome
\`\`\`

---

**Time:** ~5 minutes
