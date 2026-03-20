#!/bin/bash

# ============================================
# Claude Code Statusline - Alex.Dots
# ============================================
# Receives JSON via stdin from Claude Code
# Renders: model | dir | lines | context bar + cache details
# ============================================

# Colors (ANSI 256)
ACCENT='\033[38;5;179m'       # dorado/ámbar
SECONDARY='\033[38;5;146m'    # azul gris
MUTED='\033[38;5;242m'        # gris
SUCCESS='\033[38;5;150m'      # verde
ERROR='\033[38;5;174m'        # rosa/rojo
COBALT='\033[38;5;75m'        # azul cobalto claro (Blade Liger)
WHITE='\033[38;5;252m'        # blanco/gris claro
BOLD='\033[1m'
NC='\033[0m'

# Read JSON and parse all fields in a single jq call
input=$(cat)
eval "$(echo "$input" | jq -r '
  @sh "MODEL=\(.model.display_name // "Claude")",
  @sh "DIR=\(.workspace.current_dir // "~")",
  @sh "ADDED=\(.cost.total_lines_added // 0)",
  @sh "REMOVED=\(.cost.total_lines_removed // 0)",
  @sh "CTX_SIZE=\(.context_window.context_window_size // 200000)",
  @sh "INPUT_TOKENS=\(.context_window.current_usage.input_tokens // 0)",
  @sh "CACHE_CREATE=\(.context_window.current_usage.cache_creation_input_tokens // 0)",
  @sh "CACHE_READ=\(.context_window.current_usage.cache_read_input_tokens // 0)"
')"

# Context percentage
TOTAL_USED=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
if [ "$CTX_SIZE" -gt 0 ] 2>/dev/null; then
  CTX_PERCENT=$((TOTAL_USED * 100 / CTX_SIZE))
else
  CTX_PERCENT=0
fi
[ "$CTX_PERCENT" -gt 100 ] && CTX_PERCENT=100
[ "$CTX_PERCENT" -lt 0 ] && CTX_PERCENT=0

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
CACHE_READ_FMT=$(fmt_tokens "$CACHE_READ")
CACHE_CREATE_FMT=$(fmt_tokens "$CACHE_CREATE")

# Clean model name (remove context info like "1M context")
MODEL=$(echo "$MODEL" | sed 's/ *([^)]*context)//g')

# Progress bar with color based on usage
BAR_WIDTH=8
FILLED=$((CTX_PERCENT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

if [ "$CTX_PERCENT" -ge 80 ]; then
  BAR_COLOR="$ERROR"
elif [ "$CTX_PERCENT" -ge 50 ]; then
  BAR_COLOR="$ACCENT"
else
  BAR_COLOR="$ACCENT"
fi

BAR="${BAR_COLOR}["
for ((i=0; i<FILLED; i++)); do BAR+="="; done
for ((i=0; i<EMPTY; i++)); do BAR+="."; done
BAR+="]${NC}"

# Directory name (basename only)
DIR_NAME=$(basename "$DIR")

# Separator
SEP="${MUTED}  ${NC}"

# Build status line
LINE="${BOLD}${WHITE}[${MODEL}]${NC}"
LINE+="${SEP}"
LINE+="${COBALT}󰉋 ${DIR_NAME}${NC}"
LINE+="${SEP}"
LINE+="${SUCCESS}+${ADDED}${NC} ${ERROR}-${REMOVED}${NC}"
LINE+="${SEP}"
LINE+="${MUTED}ctx${NC} ${BAR} ${MUTED}${CTX_PERCENT}%${NC}"
LINE+=" ${MUTED}(${USED_FMT}/${SIZE_FMT}${NC}"
LINE+=" ${MUTED}|${NC} ${SECONDARY}cache: ${CACHE_READ_FMT}↓ ${CACHE_CREATE_FMT}↑${NC}${MUTED})${NC}"

echo -e "${LINE}\033[K"
