#!/bin/bash
# Setup Multi-AI Debug Aliases for Claude Code
# Part of 2111framework
# Updated: 2025-01-06
# Models: gpt-5.3-codex (high), gemini-3-pro-preview

echo "🔧 Setting up Multi-AI Debug aliases..."

# Detect shell config file
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "❌ No .zshrc or .bashrc found"
    exit 1
fi

# Remove old aliases if exist
if grep -q "# Multi-AI Debug Aliases" "$SHELL_RC"; then
    echo "⚠️  Removing old aliases..."
    sed -i '' '/# Multi-AI Debug Aliases/,/# End Multi-AI Debug Aliases/d' "$SHELL_RC"
fi

# Add updated aliases with best models
cat >> "$SHELL_RC" << 'EOF'

# Multi-AI Debug Aliases (2111framework)
# Using strongest models: gpt-5.3-codex + gemini-3-pro-preview

# Codex (OpenAI) - gpt-5.3-codex with high reasoning
alias cr='codex exec -m gpt-5.3-codex -c model_reasoning_effort=\"high\" -s read-only "You are a senior code reviewer. Analyze for bugs, race conditions, edge cases, type errors, security issues. Be specific with line numbers. Do NOT modify files:"'

# Gemini (Google) - gemini-3-pro-preview
alias gr='gemini -m gemini-3-pro-preview -p "You are a senior code reviewer. Analyze for bugs, race conditions, edge cases, type errors, security issues. Be specific with line numbers:"'

# Quick bug finder (Codex gpt-5.3-codex)
alias bug='codex exec -m gpt-5.3-codex -c model_reasoning_effort=\"high\" -s read-only "Find the bug in this code. Explain root cause and suggest fix:"'

# Security audit (Codex gpt-5.3-codex)
alias sec='codex exec -m gpt-5.3-codex -c model_reasoning_effort=\"high\" -s read-only "Security audit: Find vulnerabilities, injection risks, auth issues, exposed secrets. OWASP Top 10 check:"'

# Performance review (Codex gpt-5.3-codex)
alias perf='codex exec -m gpt-5.3-codex -c model_reasoning_effort=\"high\" -s read-only "Performance review: Find slow code, memory leaks, unnecessary renders, N+1 queries, async issues:"'

# Architecture review (Gemini 3 Pro Preview - good for high-level)
alias arch='gemini -m gemini-3-pro-preview -p "Architecture review: Analyze code structure, coupling, SOLID principles, suggest improvements:"'
# End Multi-AI Debug Aliases
EOF

echo "✅ Aliases added to $SHELL_RC"
echo ""
echo "📋 Available commands (strongest models):"
echo "   cr <file>   - Code review (gpt-5.3-codex, high reasoning)"
echo "   gr <file>   - Code review (gemini-3-pro-preview)"
echo "   bug <file>  - Bug finder (gpt-5.3-codex)"
echo "   sec <file>  - Security audit (gpt-5.3-codex)"
echo "   perf <file> - Performance review (gpt-5.3-codex)"
echo "   arch <file> - Architecture review (gemini-3-pro-preview)"
echo ""
echo "🔄 Run 'source $SHELL_RC' to apply"
