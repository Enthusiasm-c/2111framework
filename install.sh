#!/bin/bash
set -e

# 2111framework installer (v2.19+)
# Uses symlinks so `git pull` in the framework auto-updates all projects.
# Safe: never overwrites user's permissions/env in ~/.claude/settings.json.

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/install-$(date +%Y%m%d-%H%M%S)"

echo "Installing 2111framework from: $FRAMEWORK_DIR"
echo "Target:                       $CLAUDE_DIR"
echo "Backups:                      $BACKUP_DIR"
echo

mkdir -p "$CLAUDE_DIR"/{agents,skills,rules,projects,hooks,memory,backups}
mkdir -p "$BACKUP_DIR"

# ---------------------------------------------------------------------------
# 1. Agents — symlink each file so git pull auto-propagates
# ---------------------------------------------------------------------------
echo "Linking agents..."
for f in "$FRAMEWORK_DIR"/agents/*.md; do
  name=$(basename "$f")
  target="$CLAUDE_DIR/agents/$name"
  # Backup existing non-symlink file
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$BACKUP_DIR/agent-$name"
  fi
  ln -sfn "$f" "$target"
done

# ---------------------------------------------------------------------------
# 2. Skills — symlink each category directory
# ---------------------------------------------------------------------------
echo "Linking skills..."
for d in "$FRAMEWORK_DIR"/skills/*/; do
  name=$(basename "$d")
  target="$CLAUDE_DIR/skills/$name"
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$BACKUP_DIR/skills-$name"
  fi
  ln -sfn "$d" "$target"
done

# ---------------------------------------------------------------------------
# 3. Rules templates — symlink
# ---------------------------------------------------------------------------
if [ -d "$FRAMEWORK_DIR/rules" ]; then
  echo "Linking rules..."
  for f in "$FRAMEWORK_DIR"/rules/*; do
    name=$(basename "$f")
    target="$CLAUDE_DIR/rules/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mv "$target" "$BACKUP_DIR/rules-$name"
    fi
    ln -sfn "$f" "$target"
  done
fi

# ---------------------------------------------------------------------------
# 4. MCP config — backup existing, then replace with framework version
# ---------------------------------------------------------------------------
if [ -f "$CLAUDE_DIR/mcp.json" ]; then
  cp "$CLAUDE_DIR/mcp.json" "$BACKUP_DIR/mcp.json"
fi
cp "$FRAMEWORK_DIR/mcp.json" "$CLAUDE_DIR/mcp.json"
echo "Installed mcp.json (backup at $BACKUP_DIR/mcp.json)"

# ---------------------------------------------------------------------------
# 5. settings.json — MERGE hooks from framework into user's global settings
#    Preserves: permissions, env, enabledPlugins, voiceEnabled, etc.
#    Overwrites: hooks, model (framework sets defaults)
# ---------------------------------------------------------------------------
GLOBAL_SETTINGS="$CLAUDE_DIR/settings.json"
FRAMEWORK_SETTINGS="$FRAMEWORK_DIR/config/settings.json"

if [ -f "$GLOBAL_SETTINGS" ]; then
  cp "$GLOBAL_SETTINGS" "$BACKUP_DIR/settings.json"
fi

python3 <<PYEOF
import json, os, sys

global_path = "$GLOBAL_SETTINGS"
fw_path = "$FRAMEWORK_SETTINGS"

global_data = {}
if os.path.exists(global_path):
    with open(global_path) as f:
        global_data = json.load(f)

with open(fw_path) as f:
    fw_data = json.load(f)

# Merge: overwrite hooks and model from framework; keep everything else
for key in ("hooks", "model"):
    if key in fw_data:
        global_data[key] = fw_data[key]

# Remove deprecated keys (no effect on Opus 4.7)
global_data.pop("alwaysThinkingEnabled", None)

with open(global_path, "w") as f:
    json.dump(global_data, f, indent=2)

print(f"  Merged hooks + model from framework into {global_path}")
print(f"  Preserved: {sorted(k for k in global_data if k not in ('hooks', 'model'))}")
PYEOF

# ---------------------------------------------------------------------------
# 6. Shell aliases
# ---------------------------------------------------------------------------
SHELL_CONFIG=""
[ -f ~/.zshrc ] && SHELL_CONFIG=~/.zshrc
[ -f ~/.bashrc ] && SHELL_CONFIG=~/.bashrc

if [ -n "$SHELL_CONFIG" ] && ! grep -q "2111framework aliases" "$SHELL_CONFIG"; then
  cat >> "$SHELL_CONFIG" <<'ALIASEOF'

# 2111framework aliases
alias carch='cat ~/.claude/agents/architect.md'
alias cdev='cat ~/.claude/agents/developer.md'
alias cqa='cat ~/.claude/agents/qa.md'
alias csec='cat ~/.claude/agents/security.md'
alias cdocs='cat ~/.claude/agents/docs.md'
alias framework-update='cd ~/2111framework && git pull && echo "Framework updated (symlinks pick up changes automatically)"'
ALIASEOF
  echo "Aliases added to $SHELL_CONFIG"
fi

echo
echo "Installation complete."
echo
echo "Sync model: agents/skills/rules are SYMLINKED to $FRAMEWORK_DIR"
echo "           → run 'git pull' in the framework dir; all projects update instantly"
echo
echo "To update later:   framework-update"
echo "To rollback:       restore from $BACKUP_DIR"
