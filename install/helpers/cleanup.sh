#!/bin/bash

cleanup_directory() {
  local dir="$1"
  local keep="$2"

  [[ ! -d "$dir" ]] && return

  local total
  total=$(find "$dir" -name "*.tar.gz" 2>/dev/null | wc -l)

  (( total <= keep )) && return

  gum style "Found $total backup(s) in $(basename "$dir"), keeping $keep, cleaning old..."

  local count=0
  while IFS= read -r backup; do
    rm -f "$backup"
    ((count++)) || true
    gum style --foreground 3 "  Removed: $(basename "$backup")"
  done < <(find "$dir" -name "*.tar.gz" -printf '%T+ %p\n' 2>/dev/null | sort | head -n -"$keep" | cut -d' ' -f2-)

  gum style --foreground 2 "Cleaned $count backup(s) from $(basename "$dir")"
}

cleanup_old_backups() {
  local backup_dir="$HOME/Backups"

  [[ ! -d "$backup_dir" ]] && return

  cleanup_directory "$backup_dir/config" 3
  cleanup_directory "$backup_dir/dotfiles" 3
  cleanup_directory "$backup_dir/bashrc" 3
}
