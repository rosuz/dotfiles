#!/bin/bash
set -euo pipefail

clear_logo

info "Shell Configuration"

info "Creating ~/.bashrc.d/ for overrides..."
mkdir -p "$HOME/.bashrc.d"

info "Copying ~/.bashrc from dotfiles..."
cp "$DOTFILES_PATH/default/bash/bashrc" "$HOME/.bashrc"

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
