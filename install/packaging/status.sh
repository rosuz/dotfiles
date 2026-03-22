#!/bin/bash

gum style "Installing status bar and notifications..."

status_tools=(
  waybar
  mako
)

run_with_helper "$aur_helper" "${status_tools[@]}"
