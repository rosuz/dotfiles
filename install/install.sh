#!/bin/bash
set -euo pipefail

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

info "Pre-flight checks..."

if [[ $EUID -eq 0 ]]; then
  error "Error: Do not run as root"
  exit 1
fi

if ! command -v git &>/dev/null; then
  error "Error: git is required but not installed"
  exit 1
fi

if [[ ! -d "$DOTFILES_PATH" ]]; then
  error "Error: Dotfiles not found at $DOTFILES_PATH"
  exit 1
fi

success "Pre-flight checks passed!"

show_logo
info "Installing dotfiles..."
echo "This may take a few minutes..."

source "$DOTFILES_INSTALL/packaging/all.sh"

clear_logo
source "$DOTFILES_INSTALL/config/all.sh"

clear_logo
info "Applying theme..."
"$DOTFILES_PATH/bin/apply-theme"

clear_logo
success "Installation Complete!"
echo ""
echo "Your dotfiles have been installed to:"
echo -e "  ${CYAN}$DOTFILES_PATH${NC}"
echo ""
echo "Config files are in:"
echo -e "  ${CYAN}~/.config/${NC}"
echo ""
echo "Theme files are in:"
echo -e "  ${CYAN}$DOTFILES_PATH/themes/${NC}"
echo ""
echo "To apply changes:"
echo -e "  ${CYAN}Restart Hyprland (Super + Alt + R)${NC}"
echo ""

if confirm "Clean old backups?"; then
  cleanup_old_backups
fi

show_cursor
