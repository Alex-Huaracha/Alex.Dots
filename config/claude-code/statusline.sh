#!/bin/bash

# ============================================
# Claude Code Statusline - Alex.Dots
# ============================================
# Receives JSON via stdin from Claude Code
# Renders: dir | lines | model | context bar + cache details
# ============================================

# Colors (ANSI 256)
ACCENT='\033[38;5;179m'    # dorado/ámbar
SECONDARY='\033[38;5;146m' # azul gris
MUTED='\033[38;5;242m'     # gris
SUCCESS='\033[38;5;150m'   # verde
ERROR='\033[38;5;174m'     # rosa/rojo
COBALT='\033[38;5;75m'     # azul cobalto claro (Blade Liger)
WHITE='\033[38;5;252m'     # blanco/gris claro
BOLD='\033[1m'
NC='\033[0m'

# Read JSON and parse all fields in a single jq call
input=$(cat)
eval "$(echo "$input" | jq -r '
  @sh "MODEL=\(.model.display_name // "Claude")",
  @sh "DIR=\(.workspace.current_dir // "~")",
  @sh "ADDED=\(.cost.total_lines_added // 0)",
  @sh "REMOVED=\(.cost.total_lines_removed // 0)",
  @sh "CTX_PERCENT=\(.context_window.used_percentage // 0 | floor)",
  @sh "CTX_SIZE=\(.context_window.context_window_size // 200000)",
  @sh "TOTAL_USED=\((.context_window.current_usage.input_tokens // 0) + (.context_window.current_usage.cache_creation_input_tokens // 0) + (.context_window.current_usage.cache_read_input_tokens // 0))",
  @sh "RATE_5H=\(.rate_limits.five_hour.used_percentage // 0 | floor)",
  @sh "RATE_5H_RESET=\(.rate_limits.five_hour.resets_at // 0)"
')"

# Clamp context percentage
[ "$CTX_PERCENT" -gt 100 ] 2>/dev/null && CTX_PERCENT=100
[ "$CTX_PERCENT" -lt 0 ] 2>/dev/null && CTX_PERCENT=0

# Format tokens to human readable (1000 -> 1k, 1000000 -> 1M)
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fM" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=1; $n/1000" | bc)"
  else
    echo "$n"
  fi
}

USED_FMT=$(fmt_tokens "$TOTAL_USED")
SIZE_FMT=$(fmt_tokens "$CTX_SIZE")

# Clean model name (remove context info like "1M context")
MODEL=$(echo "$MODEL" | sed 's/ *([^)]*context)//g')

# Progress bar with color based on usage
BAR_WIDTH=10
FILLED=$((CTX_PERCENT * BAR_WIDTH / 100))
[ "$CTX_PERCENT" -gt 0 ] && [ "$FILLED" -eq 0 ] && FILLED=1
EMPTY=$((BAR_WIDTH - FILLED))

if [ "$CTX_PERCENT" -ge 80 ]; then
  BAR_COLOR="$ERROR"
elif [ "$CTX_PERCENT" -ge 50 ]; then
  BAR_COLOR="$ACCENT"
else
  BAR_COLOR="$WHITE"
fi

BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${BAR_COLOR}${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR+="${MUTED}${PAD// /░}"
BAR+="${NC}"

# Directory name (basename only)
DIR_NAME=$(basename "$DIR")

# Git branch (if inside a repo)
GIT_BRANCH=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Separator
SEP=" ${SECONDARY}|${NC} "

# Build status line
LINE="${COBALT}  ${DIR_NAME}${NC}"
LINE+="${SEP}"
if [ -n "$GIT_BRANCH" ]; then
  LINE+="${ACCENT} ${GIT_BRANCH}${NC}"
  if [ "$ADDED" -gt 0 ] || [ "$REMOVED" -gt 0 ]; then
    LINE+=" ${SUCCESS}+${ADDED}${NC} ${ERROR}-${REMOVED}${NC}"
  fi
else
  if [ "$ADDED" -gt 0 ] || [ "$REMOVED" -gt 0 ]; then
    LINE+="${SUCCESS}+${ADDED}${NC} ${ERROR}-${REMOVED}${NC}"
  fi
fi
LINE+="${SEP}"
LINE+="${WHITE}󱚤  ${MODEL}${NC}"
LINE+="${SEP}"
LINE+="${BAR} ${WHITE}${CTX_PERCENT}%${NC}"
LINE+=" ${MUTED}(${USED_FMT}/${SIZE_FMT})${NC}"
# Rate limit with reset time
RATE_STR="${WHITE}  ${RATE_5H}%${NC}"
if [ "$RATE_5H_RESET" -gt 0 ] 2>/dev/null; then
  NOW=$(date +%s)
  REMAINING=$((RATE_5H_RESET - NOW))
  if [ "$REMAINING" -gt 0 ]; then
    HOURS=$((REMAINING / 3600))
    MINS=$(((REMAINING % 3600) / 60))
    if [ "$HOURS" -gt 0 ]; then
      RATE_STR+=" ${MUTED}(reset ${HOURS}h ${MINS}m)${NC}"
    else
      RATE_STR+=" ${MUTED}(reset ${MINS}m)${NC}"
    fi
  fi
fi
LINE+="${SEP}"
LINE+="${RATE_STR}"

echo -e "${LINE}\033[K"
