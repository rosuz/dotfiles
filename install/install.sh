#!/bin/bash

set -eEo pipefail

if [[ -z "$DOTFILES_INSTALL_RUNNING" ]]; then
  echo "Error: Run setup.sh instead of install/install.sh"
  echo "  ./setup.sh"
  exit 1
fi

export DOTFILES_PATH="$HOME/.local/share/dotfiles"
export DOTFILES_INSTALL="$DOTFILES_PATH/install"

source "$DOTFILES_INSTALL/helpers/presentation.sh"
source "$DOTFILES_INSTALL/helpers/errors.sh"
source "$DOTFILES_INSTALL/helpers/cleanup.sh"

clear_logo
show_cursor

gum style --foreground 3 "Pre-flight checks..."

if [[ $EUID -eq 0 ]]; then
  gum style --foreground 1 "Error: Do not run as root"
  exit 1
fi

if ! command -v git &>/dev/null; then
  gum style --foreground 1 "Error: git is required but not installed"
  exit 1
fi

if [[ ! -d "$DOTFILES_PATH" ]]; then
  gum style --foreground 1 "Error: Dotfiles not found at $DOTFILES_PATH"
  exit 1
fi

gum style --foreground 2 "Pre-flight checks passed!"

show_logo
gum style --foreground 3 "Installing dotfiles..."
gum style "This may take a few minutes..."

source "$DOTFILES_INSTALL/packaging/all.sh"

clear_logo
source "$DOTFILES_INSTALL/config/all.sh"

clear_logo
gum style --foreground 3 "Applying theme..."
"$DOTFILES_PATH/bin/apply-theme"

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
gum style --foreground 6 "  ~/.local/share/dotfiles/themes/"
echo ""
gum style "To apply changes:"
gum style --foreground 6 "  Restart Hyprland (Super + Alt + R)"
echo ""

if gum confirm "Clean old backups?"; then
  cleanup_old_backups
fi

show_cursor
