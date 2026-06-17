#!/usr/bin/env bash
# Claude Code status line. Receives session JSON on stdin, prints one line.
# Layout:  Opus high · main* · +156/-23 · ctx 42% · 5h 23% (14:30) 7d 41% · $0.34
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
  limit="$(c "$MUTED" '5h ')$(c "$(pct_color "$(round "$five")")" "$(round "$five")%")"
  # append the local clock time the 5h window resets at
  if [ -n "$five_reset" ]; then
    rt=$(date -r "${five_reset%.*}" +%H:%M 2>/dev/null)
    [ -n "$rt" ] && limit="$limit$(c "$MUTED" " ($rt)")"
  fi
fi
if [ -n "$seven" ]; then
  [ -n "$limit" ] && limit="$limit "
  limit="${limit}$(c "$MUTED" '7d ')$(c "$(pct_color "$(round "$seven")")" "$(round "$seven")%")"
fi
[ -n "$limit" ] && segments+=("$limit")

# 5) Session cost
segments+=("$(c "$MUTED" "\$$(printf '%.2f' "$cost")")")

# Join with dim separators.
out=""
for i in "${!segments[@]}"; do
  [ "$i" -gt 0 ] && out="$out$(sep)"
  out="$out${segments[$i]}"
done
printf '%s' "$out"
