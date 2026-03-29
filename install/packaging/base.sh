#!/bin/bash
set -euo pipefail

info "Installing Hyprland and extras..."

hyprland_packages=(
  hyprland
  hypridle
  hyprlock
  hyprpaper
  hyprsunset
  hyprpicker
)

run_with_helper "$aur_helper" "${hyprland_packages[@]}"
