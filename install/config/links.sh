#!/bin/bash
set -euo pipefail

clear_logo

info "Copying Config Files"

info "Copying configuration files to ~/.config/..."

mkdir -p "$HOME/.config"

for item in "$DOTFILES_PATH/config"/*; do
  if [ -e "$item" ]; then
    item_name=$(basename "$item")
    rm -rf "$HOME/.config/$item_name"
    cp -r "$DOTFILES_PATH/config/$item_name" "$HOME/.config/$item_name"
    info "  ~/.config/$item_name"
  fi
done

success "Config files copied!"
