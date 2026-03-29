#!/bin/bash
set -euo pipefail

info "Installing tools..."

tools=(
  rofi
  cliphist
  playerctl
  swayosd
  uwsm
  jq
  libnotify
  fcitx5
  fcitx5-mozc
  polkit-gnome
  kvantum
  grim
  slurp
  wl-clipboard
  iwd
  alacritty
  xdg-utils
  neovim
  gh
  pamixer
  wf-recorder
  wayfreeze
  brightnessctl
  pipewire-pulse
  xdg-terminal-exec
  gnome-calculator
  tmux
  networkmanager
  bluez
  blueman
  gvfs
  ttf-jetbrains-mono-nerd
)

run_with_helper "$aur_helper" "${tools[@]}"
