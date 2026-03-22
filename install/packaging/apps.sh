#!/bin/bash

gum style "Installing desktop applications..."

apps=(
  nautilus
  obsidian
  signal-desktop
)

run_with_helper "$aur_helper" "${apps[@]}"
