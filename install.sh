#!/bin/bash
set -e

echo "🚀 Installing Claude Agents & Skills Framework..."

mkdir -p ~/.claude/agents
mkdir -p ~/.claude/skills/{integrations,tech-stack,code-quality,mcp-usage,project-contexts}

echo "🤖 Installing agents..."
cp -r agents/* ~/.claude/agents/

echo "📚 Installing skills..."
cp -r skills/* ~/.claude/skills/

# Add aliases
SHELL_CONFIG=""
[ -f ~/.zshrc ] && SHELL_CONFIG=~/.zshrc
[ -f ~/.bashrc ] && SHELL_CONFIG=~/.bashrc

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "Claude Agents Framework" "$SHELL_CONFIG"; then
        cat >> "$SHELL_CONFIG" << 'ALIASEOF'

# Claude Agents Framework
alias carch='cat ~/.claude/agents/architect.md'
alias cdev='cat ~/.claude/agents/developer.md'
alias cqa='cat ~/.claude/agents/qa.md'
alias csec='cat ~/.claude/agents/security.md'
alias cdocs='cat ~/.claude/agents/docs.md'
ALIASEOF
        echo "✓ Aliases added to $SHELL_CONFIG"
    fi
fi

echo ""
echo "✅ Installation complete!"
echo "🔄 Run: source $SHELL_CONFIG"
echo "📖 Usage: cdev \"your task\""
