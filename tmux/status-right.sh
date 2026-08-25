#!/usr/bin/env bash
# tmux status-right segment: CPU and memory gauges, Solarized severity colors.
# Both are scaled so 100% marks where performance starts to degrade.

GRN='#859900'; YEL='#b58900'; RED='#dc322f'; MUTED='#586e75'

pct_color() {
  local p=${1%%.*}
  if   [ "${p:-0}" -ge 90 ]; then printf '%s' "$RED"
  elif [ "${p:-0}" -ge 70 ]; then printf '%s' "$YEL"
  else printf '%s' "$GRN"; fi
}

# 1-minute load average over core count; past 100% threads are queuing.
cpu_saturation_pct() {
  sysctl -n vm.loadavg | awk -v cores="$(sysctl -n hw.ncpu)" \
    '{ if (cores > 0) printf "%.0f", 100 * $2 / cores }'
}

# Pressure, not occupancy: at 100% the reclaimable pool is gone, swap begins.
memory_pressure_pct() {
  memory_pressure 2>/dev/null | awk -F': *' \
    '/free percentage/ { gsub("%", "", $2); printf "%.0f", 100 - $2 }'
}

cpu=$(cpu_saturation_pct)
mem=$(memory_pressure_pct)

out=""
[ -n "$cpu" ] && out="#[fg=$MUTED]cpu #[fg=$(pct_color "$cpu")]${cpu}%"
[ -n "$mem" ] && out="$out #[fg=$MUTED]mem #[fg=$(pct_color "$mem")]${mem}%"
printf '%s' "$out"
