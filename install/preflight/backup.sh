#!/bin/bash

clear_logo

gum style --foreground 3 "Backing up existing configuration..."

BACKUP_ROOT="$HOME/dotfiles-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/backup_$TIMESTAMP"

if [[ -d "$HOME/.config" ]]; then
  CONFIG_COUNT=$(find "$HOME/.config" -maxdepth 1 -type d | wc -l)
  
  if (( CONFIG_COUNT > 1 )); then
    gum style "Found existing ~/.config with $((CONFIG_COUNT - 1)) items"
    
    if gum confirm "Create backup before installing?"; then
      mkdir -p "$BACKUP_DIR"
      
      for item in "$HOME/.config"/*; do
        if [ -e "$item" ]; then
          item_name=$(basename "$item")
          backup_path="$BACKUP_DIR/$item_name"
          mkdir -p "$(dirname "$backup_path")"
          cp -rP "$item" "$backup_path" 2>/dev/null || true
        fi
      done
      
      tarball="$BACKUP_ROOT/backup-$TIMESTAMP.tar.gz"
      tar czf "$tarball" -C "$HOME" .config 2>/dev/null || true
      
      gum style --foreground 2 "Backup created at: $BACKUP_DIR"
      gum style "Tarball: $tarball"
    fi
  fi
fi

if [[ -d "$HOME/.config" ]]; then
  gum style "Removing old ~/.config to prepare for installation..."
  rm -rf "$HOME/.config.old" 2>/dev/null || true
  mv "$HOME/.config" "$HOME/.config.old" 2>/dev/null || true
fi

mkdir -p "$HOME/.config"

gum style --foreground 2 "Backup complete!"
