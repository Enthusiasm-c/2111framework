#!/bin/bash
# Stop hook: remind about uncommitted changes — once per distinct dirty state,
# not on every turn end. State is keyed by repo path in /tmp, so a new file or
# a commit changes the hash and re-arms the reminder.

INPUT=$(cat 2>/dev/null)

# Never re-fire inside a stop-hook continuation loop
ACTIVE=$(printf %s "$INPUT" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('stop_hook_active', False))
except Exception: print(False)" 2>/dev/null)
[ "$ACTIVE" = "True" ] && exit 0

CHANGES=$(git status --short 2>/dev/null)
[ -z "$CHANGES" ] && exit 0

REPO_KEY=$(pwd | shasum | cut -c1-12)
STATE_FILE="${TMPDIR:-/tmp}/claude-uncommitted-reminder-$REPO_KEY"
HASH=$(printf %s "$CHANGES" | shasum | cut -c1-40)

[ "$(cat "$STATE_FILE" 2>/dev/null)" = "$HASH" ] && exit 0
printf %s "$HASH" > "$STATE_FILE"

printf %s "$CHANGES" | python3 -c "import json,sys; c=sys.stdin.read(); print(json.dumps({'systemMessage':'REMINDER: You have uncommitted changes:\n'+c+'\nConsider committing before leaving.'}))"
