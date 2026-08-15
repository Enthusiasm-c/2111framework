#!/bin/bash
set -euo pipefail

# 2111framework — third-party skills installer (v2.21+)
# Installs the design/motion/App Store skill sets documented in
#   skills/design/design-stack.md and skills/workflow/app-store-release.md
# Idempotent: re-running updates in place. Safe: only touches
#   ~/.claude/skills/<skill>/  (via `npx skills`)
#   ~/.claude/plugins + enabledPlugins/extraKnownMarketplaces in ~/.claude/settings.json (via `claude plugin`)
# It never edits hooks/permissions in settings.json (install.sh owns those).

export SKILLS_NO_TELEMETRY=1
AGENT="claude-code"

need() { command -v "$1" >/dev/null 2>&1 || { echo "missing: $1"; exit 1; }; }
need npx
need claude

echo "== Design engineering: emilkowalski/skills (10 skills) =="
npx -y skills@latest add emilkowalski/skills -a "$AGENT" -g --skill '*' -y

echo
echo "== Taste: Leonxlnx/taste-skill (main v2 + redesign) =="
npx -y skills@latest add https://github.com/Leonxlnx/taste-skill -a "$AGENT" -g \
  --skill design-taste-frontend --skill redesign-existing-projects -y

echo
echo "== iOS: app-store-review from dpearson2699/swift-ios-skills =="
npx -y skills@latest add dpearson2699/swift-ios-skills -a "$AGENT" -g --skill app-store-review -y

echo
echo "== Impeccable (plugin: skill + 23 commands + detector hooks) =="
if claude plugin marketplace list 2>/dev/null | grep -qE '❯ impeccable$|^\s*impeccable$'; then
  claude plugin marketplace update impeccable
else
  claude plugin marketplace add pbakaus/impeccable
fi
claude plugin install impeccable@impeccable

echo
echo "== Installed =="
ls -1 ~/.claude/skills | grep -E '^(animate|animation-vocabulary|apple-design|ask-sonner|emil-design-eng|find-animation-opportunities|improve-animations|pick-ui-library|prototype|review-animations|design-taste-frontend|redesign-existing-projects|app-store-review)$' | sed 's/^/  ~\/.claude\/skills\//'
claude plugin details impeccable@impeccable 2>/dev/null | sed -n '1,3p;/Always-on/p' | sed 's/^/  /'

# ---------------------------------------------------------------------------
# Security scan (advisory). SkillSpector = NVIDIA static scanner for agent skills.
# Install once:  uv tool install "git+https://github.com/NVIDIA/skillspector.git"
# Static tier only (--no-llm) — free, fast, high false-positive rate on code-heavy
# skills (impeccable scores CRITICAL on heuristics; see CHANGELOG 2.22.0). Read the
# HIGH findings before trusting the number; the report is saved for that.
# ---------------------------------------------------------------------------
echo
if command -v skillspector >/dev/null 2>&1; then
  REPORT_DIR="$HOME/.claude/skillspector-reports"
  mkdir -p "$REPORT_DIR"
  STAMP=$(date +%Y%m%d-%H%M%S)
  echo "== SkillSpector: static scan of ~/.claude/skills (report: $REPORT_DIR/skills-$STAMP.json) =="
  skillspector scan "$HOME/.claude/skills" --recursive --no-llm \
    --format json --output "$REPORT_DIR/skills-$STAMP.json" >/dev/null 2>&1 || true
  IMP_DIR=$(ls -d "$HOME"/.claude/plugins/cache/impeccable/impeccable/*/skills/impeccable 2>/dev/null | tail -1)
  if [ -n "$IMP_DIR" ]; then
    skillspector scan "$IMP_DIR" --no-llm --format json --output "$REPORT_DIR/impeccable-$STAMP.json" >/dev/null 2>&1 || true
  fi
  python3 - "$REPORT_DIR/skills-$STAMP.json" "$REPORT_DIR/impeccable-$STAMP.json" <<'PY'
import json, sys, os
def row(name, sk):
    ra = sk.get('risk_assessment') or {}
    print(f"  {name:32s} score={str(ra.get('score', sk.get('risk_score'))):>4s} {str(ra.get('severity', sk.get('risk_severity'))):8s} {ra.get('recommendation','')}")
for path in sys.argv[1:]:
    if not os.path.exists(path): continue
    d = json.load(open(path))
    if d.get('multi_skill'):
        for sk in d.get('skills', []): row(sk.get('name'), sk)
    else:
        row('impeccable (plugin)', d)
print("  Legend: SAFE = install, CAUTION = read the HIGH findings, DO_NOT_INSTALL = static heuristics; inspect before deciding")
PY
else
  echo "== SkillSpector not installed — skipping security scan =="
  echo "   uv tool install \"git+https://github.com/NVIDIA/skillspector.git\"   # then re-run this script"
fi

cat <<'EOF'

Done. Next:
  - Reload Claude Code (skills are picked up on session start).
  - In each UI project run once:  /impeccable init
  - Routing guide:  skills/design/design-stack.md
  - iOS release:    skills/workflow/app-store-release.md
  - Update later:   npx skills update -g -y && claude plugin marketplace update impeccable && claude plugin install impeccable@impeccable
  - Re-scan:        skillspector scan ~/.claude/skills --recursive --no-llm
EOF
