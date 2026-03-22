#!/bin/bash

set -eEo pipefail

export DOTFILES_PATH="$HOME/.local/share/dotfiles"
export DOTFILES_INSTALL="$DOTFILES_PATH/install"
export DOTFILES_INSTALL_LOG_FILE="/var/log/dotfiles-install.log"

source "$DOTFILES_INSTALL/helpers/all.sh"

start_install_log
show_logo
gum style --foreground 3 "Installing dotfiles..."

pause_log_output

source "$DOTFILES_INSTALL/preflight/all.sh"

clear_logo
gum style --foreground 3 "Installing packages..."
source "$DOTFILES_INSTALL/packaging/all.sh"

clear_logo
gum style --foreground 3 "Configuring dotfiles..."
source "$DOTFILES_INSTALL/config/all.sh"

resume_log_output

clear_logo
gum style --foreground 3 "Applying theme..."
"$DOTFILES_PATH/bin/apply-theme" 2>/dev/null || true

stop_install_log

clear_logo
gum style --foreground 2 "Installation Complete!"
echo ""
gum style "Your dotfiles have been installed to:"
gum style --foreground 6 "  $DOTFILES_PATH"
echo ""
gum style "Config files are in:"
gum style --foreground 6 "  ~/.config/"
echo ""
gum style "Theme files are in:"
gum style --foreground 6 "  ~/.config/dotfiles/"
echo ""
gum style "To apply changes:"
gum style --foreground 6 "  Restart Hyprland (Super + Alt + R)"

show_cursor
