#!/bin/bash

clear_logo
show_cursor

gum style --foreground 3 "Pre-flight checks..."

if [[ $EUID -eq 0 ]]; then
  gum style --foreground 1 "Error: Do not run as root"
  exit 1
fi

if ! command -v git &>/dev/null; then
  gum style --foreground 1 "Error: git is required but not installed"
  exit 1
fi

if ! command -v gum &>/dev/null; then
  if command -v yay &>/dev/null; then
    gum style "Installing gum via yay..."
    yay -S --noconfirm gum
  elif command -v paru &>/dev/null; then
    gum style "Installing gum via paru..."
    paru -S --noconfirm gum
  else
    gum style --foreground 1 "Error: No AUR helper found. Please install yay or paru."
    exit 1
  fi
fi

if [[ ! -d "$DOTFILES_PATH" ]]; then
  gum style --foreground 1 "Error: Dotfiles not found at $DOTFILES_PATH"
  exit 1
fi

gum style --foreground 2 "Pre-flight checks passed!"
