#!/bin/bash

gum style "Installing tools..."

tools=(
  rofi
  cliphist
  playerctl
  swayosd-hid
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
)

run_with_helper "$aur_helper" "${tools[@]}"
