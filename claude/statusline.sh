#!/usr/bin/env bash
# Claude Code status line. Receives session JSON on stdin, prints one line.
# Layout:  Opus high · main* · +156/-23 · ctx 42% · all 5h (14:30) 23% 7d 41% · fable 7d (Tue) 21% · $0.34
set -o pipefail

input=$(cat)

# Pull everything we need in a single jq pass, one field per line so that
# empty/absent fields are preserved (tab-splitting collapses them). Uses a
# read loop rather than mapfile for macOS's stock bash 3.2.
F=()
while IFS= read -r line; do F+=("$line"); done < <(
  printf '%s' "$input" | jq -r '
    (.model.display_name // "?"),
    (.effort.level // ""),
    (.context_window.used_percentage // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.cost.total_cost_usd // 0),
    (.workspace.current_dir // .cwd // "")'
)
model=${F[0]}; effort=${F[1]}; ctx=${F[2]}; five=${F[3]}; five_reset=${F[4]}
seven=${F[5]}; cost=${F[6]}; cwd=${F[7]}

# --- Solarized truecolor palette (COLORTERM=truecolor) ---
GRN='133;153;0'; YEL='181;137;0'; RED='220;50;47'
CYAN='42;161;152'; BLUE='38;139;210'; MUTED='88;110;117'
RESET=$'\033[0m'
c() { printf '\033[38;2;%sm%s%s' "$1" "$2" "$RESET"; }      # color text
sep() { printf ' %s ' "$(c "$MUTED" '·')"; }                # dim separator

# Color a 0-100 percentage by severity.
pct_color() {
  local p=${1%%.*}; [ -z "$p" ] && p=0
  if   [ "$p" -ge 90 ]; then printf '%s' "$RED"
  elif [ "$p" -ge 70 ]; then printf '%s' "$YEL"
  else printf '%s' "$GRN"; fi
}
round() { printf '%.0f' "$1" 2>/dev/null || printf '0'; }

# Prints when a future reset epoch lands (clock within 24h, else weekday);
# prints nothing for a past epoch, which only ever means stale limit data.
upcoming_reset_label() {
  local reset=${1%%.*} now; now=$(date +%s)
  [ -n "$reset" ] && [ "$reset" -gt "$now" ] 2>/dev/null || return 0
  if [ $((reset - now)) -lt 86400 ]; then date -r "$reset" +%H:%M 2>/dev/null
  else date -r "$reset" +%a 2>/dev/null; fi
}

# The stdin payload only carries the all-model windows; the usage endpoint
# also reports model-scoped weekly limits. Prints "percent epoch" for Fable.
fable_weekly_limit() {
  local token
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null |
    jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  [ -n "$token" ] || return 0
  printf 'header = "Authorization: Bearer %s"\n' "$token" |
    curl -s --max-time 2 -K - -H 'anthropic-beta: oauth-2025-04-20' \
      https://api.anthropic.com/api/oauth/usage 2>/dev/null |
    jq -r '.limits[]?
      | select(.scope.model.display_name == "Fable" and .percent != null)
      | "\(.percent) \(.resets_at // "" | sub("\\.[0-9]+"; "")
                       | sub("\\+00:00$"; "Z") | try fromdateiso8601 catch "")"' \
      2>/dev/null | head -n1
}

# Local footprints, one ps pass: this session's claude process tree, and every
# process under any claude session on the machine (tool commands, MCP servers,
# background hosts). Prints "<cpu%> <rss-kb> <all-cpu%> <all-rss-kb>".
claude_process_usage() {
  local pid=$$ root=""
  while [ "$pid" -gt 1 ] 2>/dev/null; do
    case $(ps -o comm= -p "$pid" 2>/dev/null) in (*claude*|*node*) root=$pid;; esac
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -n "$pid" ] || break
  done
  ps -axo pid=,ppid=,rss=,%cpu=,comm= 2>/dev/null | awk -v root="${root:-0}" '
    { parent[$1] = $2; rss[$1] = $3; cpu[$1] = $4; is_claude[$1] = ($5 ~ /claude/) }
    END {
      for (p in parent) {
        in_session = in_fleet = 0
        q = p
        while (1) {
          if (q == root)      in_session = 1
          if (is_claude[q])   in_fleet = 1
          if (!(q in parent) || parent[q] == q) break
          q = parent[q]
        }
        if (in_session) { s_kb += rss[p]; s_cpu += cpu[p] }
        if (in_fleet)   { a_kb += rss[p]; a_cpu += cpu[p] }
      }
      if (a_kb > 0) printf "%.0f %d %.0f %d", s_cpu, s_kb, a_cpu, a_kb
    }'
}

fmt_kb() {
  if [ "$1" -ge 1048576 ] 2>/dev/null; then
    awk -v kb="$1" 'BEGIN { printf "%.1fG", kb / 1048576 }'
  else
    printf '%sM' "$(( $1 / 1024 ))"
  fi
}

share_of_total_ram() {
  sysctl -n hw.memsize 2>/dev/null | awk -v kb="$1" \
    '{ if ($1 > 0) printf " (%.0f%%)", 100 * kb * 1024 / $1 }'
}

# 60s cache; a failed fetch keeps the last known value rather than flickering.
fable_weekly_cached() {
  local cache="$HOME/.claude/cache/fable-weekly" now fetched_at value fresh
  now=$(date +%s); fetched_at=0; value=""
  [ -r "$cache" ] && read -r fetched_at value < "$cache" 2>/dev/null
  case $fetched_at in (*[!0-9]*|'') fetched_at=0;; esac
  if [ $((now - fetched_at)) -ge 60 ]; then
    fresh=$(fable_weekly_limit)
    [ -n "$fresh" ] && value=$fresh
    mkdir -p "${cache%/*}" 2>/dev/null
    printf '%s %s' "$now" "$value" 2>/dev/null > "$cache"
  fi
  printf '%s' "$value"
}

segments=()

# 1) Model + reasoning effort
m=$(c "$CYAN" "$model")
[ -n "$effort" ] && m="$m $(c "$MUTED" "$effort")"
segments+=("$m")

# 2) Git branch + dirty marker, then an MR-style diff stat
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=""
    [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && dirty='*'
    if [ -n "$dirty" ]; then
      segments+=("$(c "$YEL" "${branch}${dirty}")")
    else
      segments+=("$(c "$GRN" "$branch")")
    fi

    # Diff stat vs the default branch (committed branch changes + uncommitted
    # working-tree edits), like the diff shown when opening an MR.
    base=$(git -C "$cwd" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null)
    base=${base#refs/remotes/}
    if [ -z "$base" ]; then
      for b in origin/main origin/master main master; do
        git -C "$cwd" rev-parse --verify --quiet "$b" >/dev/null 2>&1 && { base=$b; break; }
      done
    fi
    mb=""
    [ -n "$base" ] && mb=$(git -C "$cwd" merge-base HEAD "$base" 2>/dev/null)
    [ -z "$mb" ] && mb=HEAD   # fallback: count uncommitted changes only
    stat=$(git -C "$cwd" diff --shortstat "$mb" 2>/dev/null)
    add=$(printf '%s' "$stat" | grep -oE '[0-9]+ insertion' | grep -oE '^[0-9]+'); add=${add:-0}
    rem=$(printf '%s' "$stat" | grep -oE '[0-9]+ deletion'  | grep -oE '^[0-9]+'); rem=${rem:-0}
    segments+=("$(c "$GRN" "+$add")$(c "$MUTED" '/')$(c "$RED" "-$rem")")
  fi
fi

# 3) Context window usage
if [ -n "$ctx" ]; then
  cp=$(round "$ctx")
  segments+=("$(c "$MUTED" 'ctx ')$(c "$(pct_color "$cp")" "${cp}%")")
fi

# 4) Usage limits (Pro/Max only; each window may be absent)
limit=""
if [ -n "$five" ]; then
  limit="$(c "$MUTED" 'all 5h')"
  rt=$(upcoming_reset_label "$five_reset")
  [ -n "$rt" ] && limit="$limit$(c "$MUTED" " ($rt)")"
  limit="$limit $(c "$(pct_color "$(round "$five")")" "$(round "$five")%")"
fi
if [ -n "$seven" ]; then
  [ -n "$limit" ] && limit="$limit "
  limit="${limit}$(c "$MUTED" '7d ')$(c "$(pct_color "$(round "$seven")")" "$(round "$seven")%")"
fi
[ -n "$limit" ] && segments+=("$limit")

# 4b) Fable's model-scoped weekly limit
fw=$(fable_weekly_cached)
fable=${fw%% *}; fable_reset=${fw#* }
if [ -n "$fable" ]; then
  fl="$(c "$MUTED" 'fable 7d')"
  rt=$(upcoming_reset_label "$fable_reset")
  [ -n "$rt" ] && fl="$fl$(c "$MUTED" " ($rt)")"
  segments+=("$fl $(c "$(pct_color "$fable")" "$(round "$fable")%")")
fi

# 5) Session cost
segments+=("$(c "$MUTED" "\$$(printf '%.2f' "$cost")")")

# 6) Claude footprints, muted: no severity color because sessions have no
# degradation point of their own (host health lives in the tmux bar).
usage=$(claude_process_usage)
if [ -n "$usage" ]; then
  set -- $usage
  scpu=$1; skb=$2; acpu=$3; akb=$4
  [ "${skb:-0}" -gt 0 ] 2>/dev/null &&
    segments+=("$(c "$MUTED" "cpu ${scpu}% mem $(fmt_kb "$skb")$(share_of_total_ram "$skb")")")
  [ "${akb:-0}" -gt 0 ] 2>/dev/null &&
    segments+=("$(c "$MUTED" "all cpu ${acpu}% mem $(fmt_kb "$akb")$(share_of_total_ram "$akb")")")
fi

# Join with dim separators.
out=""
for i in "${!segments[@]}"; do
  [ "$i" -gt 0 ] && out="$out$(sep)"
  out="$out${segments[$i]}"
done
printf '%s' "$out"
