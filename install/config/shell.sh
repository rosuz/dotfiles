#!/bin/bash
set -euo pipefail

clear_logo

info "Shell Configuration"

BASHRC_SOURCE_LINE='source "$HOME/.local/share/dotfiles/default/bash/bashrc"'

info "Adding dotfiles bin to PATH..."
DOTFILES_BIN_LINE='export PATH="$HOME/.local/share/dotfiles/bin:$HOME/.local/bin:$PATH"'

if [ -f "$HOME/.bashrc" ]; then
  if grep -q "DOTFILES_PATH" "$HOME/.bashrc" 2>/dev/null; then
    info "Found existing dotfiles configuration in ~/.bashrc"
  else
    info "Backing up existing ~/.bashrc"
    mkdir -p "$HOME/Backups/bashrc"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    tar -czf "$HOME/Backups/bashrc/bashrc.backup_${TIMESTAMP}.tar.gz" -C "$HOME" .bashrc
    
    info "Appending dotfiles configuration to ~/.bashrc"
    echo "" >> "$HOME/.bashrc"
    echo "# Dotfiles" >> "$HOME/.bashrc"
    echo "$DOTFILES_BIN_LINE" >> "$HOME/.bashrc"
    echo "$BASHRC_SOURCE_LINE" >> "$HOME/.bashrc"
  fi
else
  info "Creating new ~/.bashrc from template"
  cp "$DOTFILES_PATH/default/bash/bashrc" "$HOME/.bashrc"
fi

success "Shell configuration complete!"

echo ""
info "Setting up UWSM environment..."

mkdir -p "$HOME/.config/uwsm"
cp "$DOTFILES_PATH/config/uwsm/env" "$HOME/.config/uwsm/env"
cp "$DOTFILES_PATH/config/uwsm/default" "$HOME/.config/uwsm/default"

success "UWSM environment configured!"

echo ""
info "IMPORTANT: Log out and log back in to apply PATH changes!"
info "Your dotfiles PATH is set in ~/.config/uwsm/env, which is read at login."
info "Simply restarting Hyprland will NOT apply the new PATH."
