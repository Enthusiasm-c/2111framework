#!/bin/bash
echo "🗑️  Uninstalling..."
rm -rf ~/.claude/agents ~/.claude/skills
for cfg in ~/.zshrc ~/.bashrc; do
    [ -f "$cfg" ] && sed -i.bak '/Claude Agents Framework/,+5d' "$cfg"
done
echo "✅ Uninstalled"
