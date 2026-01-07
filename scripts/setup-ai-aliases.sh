#!/bin/bash
# Setup Multi-AI Debug Aliases for Claude Code
# Part of 2111framework

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

# Check if aliases already exist
if grep -q "# Multi-AI Debug Aliases" "$SHELL_RC"; then
    echo "⚠️  Aliases already configured in $SHELL_RC"
    echo "   Remove existing block and re-run to update"
    exit 0
fi

# Add aliases
cat >> "$SHELL_RC" << 'EOF'

# Multi-AI Debug Aliases (2111framework)
# Codex read-only code review
alias cr='CODEX_SANDBOX_TYPE=read-only codex -q "You are a senior code reviewer. Analyze for bugs, race conditions, edge cases, type errors, security issues. Be specific with line numbers. Do NOT modify files:"'

# Gemini code review
alias gr='gemini -q "Analyze this code for bugs and issues. Be specific with line numbers:"'

# Quick bug finder
alias bug='CODEX_SANDBOX_TYPE=read-only codex -q "Find the bug in this code. Explain root cause and suggest fix:"'

# Security review
alias sec='CODEX_SANDBOX_TYPE=read-only codex -q "Security audit: Find vulnerabilities, injection risks, auth issues, exposed secrets:"'

# Performance review
alias perf='CODEX_SANDBOX_TYPE=read-only codex -q "Performance review: Find slow code, memory leaks, unnecessary renders, N+1 queries:"'
# End Multi-AI Debug Aliases
EOF

echo "✅ Aliases added to $SHELL_RC"
echo ""
echo "📋 Available commands:"
echo "   cr <file>   - Codex code review"
echo "   gr <file>   - Gemini code review"
echo "   bug <file>  - Quick bug finder"
echo "   sec <file>  - Security audit"
echo "   perf <file> - Performance review"
echo ""
echo "🔄 Run 'source $SHELL_RC' or restart terminal to apply"
echo ""
echo "⚠️  Make sure you have installed:"
echo "   npm install -g @openai/codex"
echo "   export OPENAI_API_KEY='sk-...'"
