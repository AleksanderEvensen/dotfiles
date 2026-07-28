#!/usr/bin/env bash
# Claude Code status line — mirrors Starship prompt style

input=$(cat)

user=$(whoami)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')
cwd=$(echo "$input" | jq -r '.cwd // ""')

# Shorten home directory to ~
home="$HOME"
current_dir="${current_dir/#$home/~}"
project_dir="${project_dir/#$home/~}"
cwd="${cwd/#$home/~}"

# Primary dir for git lookup (prefer current_dir, fall back to cwd)
dir="${current_dir:-$cwd}"

model=$(echo "$input" | jq -r '.model.display_name // ""')

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // empty')
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')

effort=$(echo "$input" | jq -r '.effort.level // empty')

five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Format seconds remaining as HH:mm
fmt_hhmm() {
  local secs="$1"
  if [ -z "$secs" ] || [ "$secs" -lt 0 ] 2>/dev/null; then secs=0; fi
  local h=$((secs / 3600))
  local m=$(((secs % 3600) / 60))
  printf '%02d:%02d' "$h" "$m"
}

# Format seconds remaining as dd:HH:mm
fmt_ddhhmm() {
  local secs="$1"
  if [ -z "$secs" ] || [ "$secs" -lt 0 ] 2>/dev/null; then secs=0; fi
  local d=$((secs / 86400))
  local h=$(((secs % 86400) / 3600))
  local m=$(((secs % 3600) / 60))
  printf '%02d:%02d:%02d' "$d" "$h" "$m"
}

now_epoch=$(date +%s)

# Human-readable formatter: 1234 -> 1.2k, 1000000 -> 1.0M
human_tokens() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "null" ]; then
    return
  fi
  awk -v n="$n" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n/1000000;
    else if (n >= 1000) printf "%.1fk", n/1000;
    else printf "%d", n;
  }'
}

# Git branch + status (skip optional locks)
git_branch=""
git_dirty=""
git_ahead=""
git_behind=""
git_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
if git -C "$git_dir" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$git_dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  # Dirty: any porcelain output means uncommitted changes
  if [ -n "$(git -C "$git_dir" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
    git_dirty="*"
  fi
  # Ahead/behind vs upstream (fails silently if no upstream)
  ab=$(git -C "$git_dir" --no-optional-locks rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
  if [ -n "$ab" ]; then
    git_ahead=$(echo "$ab" | awk '{print $1}')
    git_behind=$(echo "$ab" | awk '{print $2}')
  fi
fi

# Build output with ANSI colors matching Starship palette
# macOS  username(bold blue)  at  dir  [branch]  model  ctx%
out=""

# macOS symbol + current_dir
out="${out}\033[0m "
if [ -n "$current_dir" ]; then
  out="${out}\033[0m${current_dir}\033[0m"
fi

# project_dir (dimmed) if different from current_dir
if [ -n "$project_dir" ] && [ "$project_dir" != "$current_dir" ]; then
  out="${out} \033[2mproj:${project_dir}\033[0m"
fi

# cwd (dimmed) if different from current_dir
if [ -n "$cwd" ] && [ "$cwd" != "$current_dir" ]; then
  out="${out} \033[2mcwd:${cwd}\033[0m"
fi

# git branch + dirty + ahead/behind
if [ -n "$git_branch" ]; then
  out="${out} \033[38;5;214m ${git_branch}"
  if [ -n "$git_dirty" ]; then
    out="${out}\033[38;5;203m${git_dirty}\033[38;5;214m"
  fi
  if [ -n "$git_ahead" ] && [ "$git_ahead" -gt 0 ] 2>/dev/null; then
    out="${out} ↑${git_ahead}"
  fi
  if [ -n "$git_behind" ] && [ "$git_behind" -gt 0 ] 2>/dev/null; then
    out="${out} ↓${git_behind}"
  fi
  out="${out}\033[0m"
fi

# model display_name dimmed, with effort level
if [ -n "$model" ]; then
  out="${out}  \033[2m${model}"
  if [ -n "$effort" ]; then
    out="${out} [${effort}]"
  fi
  out="${out}\033[0m"
fi

# Context section
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  if [ "$used_int" -ge 80 ]; then
    color="\033[38;5;203m"  # red when high
  elif [ "$used_int" -ge 50 ]; then
    color="\033[38;5;214m"  # orange at mid
  else
    color="\033[38;5;83m"   # green when low
  fi
  out="${out} ${color}Context: ${used_int}%"
  if [ -n "$used_tokens" ] && [ -n "$max_tokens" ]; then
    used_h=$(human_tokens "$used_tokens")
    max_h=$(human_tokens "$max_tokens")
    out="${out} ${used_h}/${max_h}"
  fi
  out="${out}\033[0m"
  if [ "$exceeds_200k" = "true" ]; then
    out="${out} \033[38;5;203m⚠ >200k\033[0m"
  fi
fi

# Cache section
if [ -n "$cache_read" ] || [ -n "$cache_creation" ]; then
  cr_h=$(human_tokens "${cache_read:-0}")
  cc_h=$(human_tokens "${cache_creation:-0}")
  out="${out} \033[38;5;111mCache: ${cr_h}↓/${cc_h}↑\033[0m"
fi

# Rate limits — 5h (HH:mm remaining) | 7d (dd:HH:mm remaining)
rl_parts=""
if [ -n "$five_hour_pct" ]; then
  fh_int=$(printf '%.0f' "$five_hour_pct")
  if [ "$fh_int" -ge 80 ]; then fh_color="\033[38;5;203m"
  elif [ "$fh_int" -ge 50 ]; then fh_color="\033[38;5;214m"
  else fh_color="\033[38;5;83m"
  fi
  fh_remain=""
  if [ -n "$five_hour_reset" ]; then
    fh_remain=$(fmt_hhmm $((five_hour_reset - now_epoch)))
  fi
  rl_parts="${fh_color}5h: ${fh_int}%"
  if [ -n "$fh_remain" ]; then
    rl_parts="${rl_parts} (${fh_remain})"
  fi
  rl_parts="${rl_parts}\033[0m"
fi

if [ -n "$seven_day_pct" ]; then
  sd_int=$(printf '%.0f' "$seven_day_pct")
  if [ "$sd_int" -ge 80 ]; then sd_color="\033[38;5;203m"
  elif [ "$sd_int" -ge 50 ]; then sd_color="\033[38;5;214m"
  else sd_color="\033[38;5;83m"
  fi
  sd_remain=""
  if [ -n "$seven_day_reset" ]; then
    sd_remain=$(fmt_ddhhmm $((seven_day_reset - now_epoch)))
  fi
  if [ -n "$rl_parts" ]; then
    rl_parts="${rl_parts} \033[2m|\033[0m "
  fi
  rl_parts="${rl_parts}${sd_color}7d: ${sd_int}%"
  if [ -n "$sd_remain" ]; then
    rl_parts="${rl_parts} (${sd_remain})"
  fi
  rl_parts="${rl_parts}\033[0m"
fi

if [ -n "$rl_parts" ]; then
  out="${out} ${rl_parts}"
fi

printf '%b' "$out"
