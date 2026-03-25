#!/bin/bash

detect_aur_helper() {
  if command -v yay &>/dev/null; then
    echo "yay"
  elif command -v paru &>/dev/null; then
    echo "paru"
  else
    echo "none"
  fi
}

aur_helper=$(detect_aur_helper)

if [[ "$aur_helper" == "none" ]]; then
  gum style "No AUR helper found. Skipping package installation."
  gum style "Please install yay or paru manually if needed."
else
  gum style "Using AUR helper: $aur_helper"

  run_with_helper() {
    local helper="$1"
    shift
    local packages=("$@")

    if ((${#packages[@]} == 0)); then
      return
    fi

    gum style "Installing: ${packages[*]}"
    "$helper" -S --needed --noconfirm \
      --answerclean All \
      --answerdiff None \
      --removemake \
      --cleanafter \
      "${packages[@]}"
  }

  clear_logo
  if gum confirm "Install packages?"; then
    source "$DOTFILES_INSTALL/packaging/base.sh"
    source "$DOTFILES_INSTALL/packaging/tools.sh"
    source "$DOTFILES_INSTALL/packaging/status.sh"
    source "$DOTFILES_INSTALL/packaging/tui.sh"
    source "$DOTFILES_INSTALL/packaging/apps.sh"
    
    gum style --foreground 2 "Package installation complete!"
  else
    gum style "Skipping package installation."
  fi
fi
