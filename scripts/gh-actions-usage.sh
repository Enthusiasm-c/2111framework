#!/usr/bin/env bash
# Расход GitHub Actions за месяц по всем репозиториям аккаунта.
#
#   gh-actions-usage.sh                 # текущий месяц
#   gh-actions-usage.sh 2026-08         # конкретный месяц
#   gh-actions-usage.sh 2026-08 --exact # минуты как в счёте: по джобам, каждый вверх до минуты (1 запрос на прогон, медленно)
#
# Без --exact минуты = стена прогона (start→end); для воркфлоу с параллельными
# джобами это НИЖЕ того, что биллит GitHub (он суммирует джобы и округляет
# каждый вверх до минуты). --exact считает именно так, по /runs/{id}/jobs.
#
# Нужен gh (авторизованный). Итог тарифа (included/used) — только со scope `user`:
#   gh auth refresh -h github.com -s user
set -euo pipefail

MONTH="${1:-$(date +%Y-%m)}"
EXACT=0; [ "${2:-}" = "--exact" ] && EXACT=1
OWNER="$(gh api user --jq .login)"

echo "GitHub Actions — $OWNER — $MONTH"
echo

# 1. Итог тарифа, если есть scope.
if BILL=$(gh api "users/$OWNER/settings/billing/actions" 2>/dev/null); then
  echo "$BILL" | jq -r '"Тариф: использовано \(.total_minutes_used) из \(.included_minutes) включённых минут, сверх лимита \(.total_paid_minutes_used) (UBUNTU \(.minutes_used_breakdown.UBUNTU // 0), MACOS \(.minutes_used_breakdown.MACOS // 0), WINDOWS \(.minutes_used_breakdown.WINDOWS // 0))"'
else
  echo "Тариф: нет scope user — github.com/settings/billing или: gh auth refresh -h github.com -s user"
fi
echo

# 2. По репозиториям: прогоны, красные, минуты.
NEXT_MONTH=$(date -j -v+1m -f %Y-%m-%d "$MONTH-01" +%Y-%m-%d 2>/dev/null || date -d "$MONTH-01 +1 month" +%Y-%m-%d)
case "$NEXT_MONTH" in [0-9][0-9][0-9][0-9]-[0-9][0-9]-01) ;; *) echo "bad month: $MONTH" >&2; exit 1;; esac
RANGE="$MONTH-01..$NEXT_MONTH"
TOTAL_MIN=0; TOTAL_RUNS=0; TOTAL_RED=0
printf '%-22s %-32s %-16s %5s %5s %8s\n' "repo" "workflow" "event" "runs" "red" "minutes"

for REPO in $(gh repo list "$OWNER" --limit 200 --no-archived --json name --jq '.[].name' | sort); do
  RUNS=$(gh api --paginate "repos/$OWNER/$REPO/actions/runs?created=$RANGE&per_page=100" \
    --jq '.workflow_runs[] | [.id, .name, .event, .conclusion, .run_started_at, .updated_at] | @tsv' 2>/dev/null || true)
  [ -n "$RUNS" ] || continue

  if [ "$EXACT" = 1 ]; then
    RUNS=$(printf '%s\n' "$RUNS" | while IFS=$'\t' read -r id name ev con s e; do
      # /timing с 2025 отдаёт billable=0 (новая биллинг-платформа), поэтому
      # считаем по джобам: каждый джоб GitHub округляет ВВЕРХ до минуты.
      ms=$(gh api --paginate "repos/$OWNER/$REPO/actions/runs/$id/jobs?per_page=100" \
        --jq '[.jobs[] | select(.started_at != null and .completed_at != null)
               | (((.completed_at | fromdateiso8601) - (.started_at | fromdateiso8601)) / 60 | ceil) * 60000] | add // 0' \
        2>/dev/null | awk '{s+=$1} END {print s+0}')
      printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$ev" "${con:-running}" "$ms" "exact"
    done)
  else
    RUNS=$(printf '%s\n' "$RUNS" | while IFS=$'\t' read -r id name ev con s e; do
      # Прогон в очереди / ещё бежит — дат нет, считаем нулём.
      ss=$(date -j -f %Y-%m-%dT%H:%M:%SZ "$s" +%s 2>/dev/null || date -d "$s" +%s 2>/dev/null || echo 0)
      ee=$(date -j -f %Y-%m-%dT%H:%M:%SZ "$e" +%s 2>/dev/null || date -d "$e" +%s 2>/dev/null || echo 0)
      ms=0; [ "$ss" -gt 0 ] && [ "$ee" -ge "$ss" ] && ms=$(( (ee - ss) * 1000 ))
      printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$ev" "${con:-running}" "$ms" "wall"
    done)
  fi

  printf '%s\n' "$RUNS" | awk -F'\t' -v repo="$REPO" '
    { k=$1 FS $2; n[k]++; if ($3!="success") red[k]++; ms[k]+=$4 }
    END { for (k in n) { split(k, p, FS);
      printf "%-22s %-32s %-16s %5d %5d %8.0f\n", repo, substr(p[1],1,32), p[2], n[k], red[k]+0, ms[k]/60000 } }' | sort
  R=$(printf '%s\n' "$RUNS" | awk -F'\t' '{n++; if ($3!="success") r++; m+=$4} END {printf "%d %d %.0f", n, r+0, m/60000}')
  set -- $R; TOTAL_RUNS=$((TOTAL_RUNS+$1)); TOTAL_RED=$((TOTAL_RED+$2)); TOTAL_MIN=$((TOTAL_MIN+$3))
done

echo
[ "$EXACT" = 1 ] && KIND="биллинг-минут" || KIND="минут по стене прогона (биллинг выше: джобы суммируются)"
echo "Итого за $MONTH: $TOTAL_RUNS прогонов, $TOTAL_RED красных, $TOTAL_MIN $KIND"
echo "Красный воркфлоу ≥3 прогона подряд — чинить или gh workflow disable (rules/github-actions.md §6)."
