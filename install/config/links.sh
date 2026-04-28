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

info "Creating theme symlinks..."

mkdir -p ~/.config/btop/themes
ln -sf "$DOTFILES_PATH/themes/current/btop.theme" ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -sf "$DOTFILES_PATH/themes/current/mako.ini" ~/.config/mako/config

if [[ -d "$DOTFILES_PATH/themes/current/backgrounds" ]]; then
  first_bg=$(ls "$DOTFILES_PATH/themes/current/backgrounds"/* 2>/dev/null | head -1)
  if [[ -n "$first_bg" ]]; then
    ln -nsf "backgrounds/$(basename "$first_bg")" "$DOTFILES_PATH/themes/current/background"
  fi
fi

success "Config files copied!"
success "Theme symlinks created!"
