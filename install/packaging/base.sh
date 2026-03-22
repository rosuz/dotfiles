#!/bin/bash

gum style "Installing Hyprland extras..."

hyprland_extras=(
  hypridle
  hyprlock
  hyprpaper
  hyprsunset
  hyprpicker
)

run_with_helper "$aur_helper" "${hyprland_extras[@]}"
