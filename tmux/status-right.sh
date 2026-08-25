#!/usr/bin/env bash
# tmux status-right segment: host CPU and memory usage, colored with the same
# Solarized severity thresholds as the Claude Code status line.

GRN='#859900'; YEL='#b58900'; RED='#dc322f'; MUTED='#586e75'

pct_color() {
  local p=${1%%.*}
  if   [ "${p:-0}" -ge 90 ]; then printf '%s' "$RED"
  elif [ "${p:-0}" -ge 70 ]; then printf '%s' "$YEL"
  else printf '%s' "$GRN"; fi
}

cpu=$(ps -A -o %cpu= | awk -v cores="$(sysctl -n hw.ncpu)" \
  '{sum += $1} END { if (cores > 0) printf "%.0f", sum / cores }')
mem=$(memory_pressure 2>/dev/null | awk -F': *' \
  '/free percentage/ { gsub("%", "", $2); printf "%.0f", 100 - $2 }')

out=""
[ -n "$cpu" ] && out="#[fg=$MUTED]cpu #[fg=$(pct_color "$cpu")]${cpu}%"
[ -n "$mem" ] && out="$out #[fg=$MUTED]mem #[fg=$(pct_color "$mem")]${mem}%"
printf '%s' "$out"
