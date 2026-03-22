#!/bin/bash

clear_logo

gum style --foreground 3 "Shell Configuration"

BASHRC_SOURCE_LINE='source "$HOME/.local/share/dotfiles/default/bash/bashrc"'

if [ -f "$HOME/.bashrc" ]; then
  if grep -q "DOTFILES_PATH" "$HOME/.bashrc" 2>/dev/null; then
    gum style "Found existing dotfiles configuration in ~/.bashrc"
  else
    gum style "Backing up existing ~/.bashrc"
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"
    
    gum style "Appending dotfiles configuration to ~/.bashrc"
    echo "" >> "$HOME/.bashrc"
    echo "# Dotfiles" >> "$HOME/.bashrc"
    echo "$BASHRC_SOURCE_LINE" >> "$HOME/.bashrc"
  fi
else
  gum style "Creating new ~/.bashrc from template"
  cp "$DOTFILES_PATH/default/bash/bashrc" "$HOME/.bashrc"
fi

gum style --foreground 2 "Shell configuration complete!"

echo ""
gum style "Setting up UWSM environment..."

mkdir -p "$HOME/.config/uwsm"
cp "$DOTFILES_PATH/default/uwsm/env" "$HOME/.config/uwsm/env"
cp "$DOTFILES_PATH/default/uwsm/default" "$HOME/.config/uwsm/default"

gum style --foreground 2 "UWSM environment configured!"

echo ""
gum style --foreground 3 "IMPORTANT: Log out and log back in to apply PATH changes!"
gum style "Your dotfiles PATH is set in ~/.config/uwsm/env, which is read at login."
gum style "Simply restarting Hyprland will NOT apply the new PATH."
