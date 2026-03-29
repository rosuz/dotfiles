#!/bin/bash
set -euo pipefail

info "Installing desktop applications..."

apps=(
  nautilus
  signal-desktop
)

run_with_helper "$aur_helper" "${apps[@]}"
