#!/bin/bash
set -euo pipefail

info "Installing TUI applications..."

tui_apps=(
  btop
  lazydocker
  lazygit
  impala
  wiremix
  bluetui
)

remove_if_installed() {
  for pkg in "$@"; do
    if pacman -Q "$pkg" &>/dev/null; then
      info "Removing conflicting package: $pkg"
      sudo pacman -Rns --noconfirm "$pkg"
    fi
  done
}

remove_if_installed lazydocker-bin

run_with_helper "$aur_helper" "${tui_apps[@]}"
