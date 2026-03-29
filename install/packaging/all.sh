#!/bin/bash
set -euo pipefail

aur_helper="${AUR_HELPER:-yay}"

info "Using AUR helper: $aur_helper"

run_with_helper() {
  local helper="$1"
  shift
  local packages=("$@")

  if ((${#packages[@]} == 0)); then
    return
  fi

  info "Installing: ${packages[*]}"
  "$helper" -S --needed --noconfirm \
    --answerclean All \
    --answerdiff None \
    --removemake \
    --cleanafter \
    "${packages[@]}"
}

clear_logo
if confirm "Install packages?"; then
  source "$DOTFILES_INSTALL/packaging/base.sh"
  source "$DOTFILES_INSTALL/packaging/tools.sh"
  source "$DOTFILES_INSTALL/packaging/status.sh"
  source "$DOTFILES_INSTALL/packaging/tui.sh"
  source "$DOTFILES_INSTALL/packaging/apps.sh"
  
  success "Package installation complete!"
else
  info "Skipping package installation."
fi
