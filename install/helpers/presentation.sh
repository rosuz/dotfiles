#!/bin/bash
set -euo pipefail

if [[ -e /dev/tty ]]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)
  if [[ -n $TERM_SIZE ]]; then
    export TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
    export TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
  else
    export TERM_WIDTH=80
    export TERM_HEIGHT=24
  fi
else
  export TERM_WIDTH=80
  export TERM_HEIGHT=24
fi

export RED='\033[31m'
export GREEN='\033[32m'
export YELLOW='\033[33m'
export BLUE='\033[34m'
export CYAN='\033[36m'
export NC='\033[0m'

msg() { echo -e "${2:-$NC}$1${NC}"; }
info() { msg "$1" "$YELLOW"; }
success() { msg "$1" "$GREEN"; }
error() { msg "$1" "$RED"; }
question() { msg "$1" "$CYAN"; }

export LOGO_PATH="$DOTFILES_PATH/logo.txt"
export LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 40)
export LOGO_HEIGHT=$(wc -l <"$LOGO_PATH" 2>/dev/null || echo 8)

clear_logo() {
  printf "\033[H\033[2J"
  if [[ -f "$LOGO_PATH" ]]; then
    msg "$(<$LOGO_PATH)" "$GREEN"
  fi
}

show_logo() {
  clear_logo
}

confirm() {
  local prompt="$1"
  local default="${2:-N}"
  local yn

  if [[ "$default" == "Y" ]]; then
    yn="[Y/n]"
  else
    yn="[y/N]"
  fi

  read -p "$prompt $yn: " reply
  [[ "$default" == "Y" ]] && [[ -z "$reply" ]] && return 0
  [[ "$reply" =~ ^[Yy]$ ]]
}

choose() {
  local prompt="$1"
  shift
  local options=("$@")

  echo "$prompt"
  select opt in "${options[@]}"; do
    [[ -n "$opt" ]] && echo "$opt" && return 0
  done
}
