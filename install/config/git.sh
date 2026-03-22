#!/bin/bash

clear_logo

gum style --foreground 3 "Git Configuration"

CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [[ -n "$CURRENT_NAME" ]]; then
  gum style "Current git name: $CURRENT_NAME"
else
  gum style "No git name configured"
fi

if [[ -n "$CURRENT_EMAIL" ]]; then
  gum style "Current git email: $CURRENT_EMAIL"
else
  gum style "No git email configured"
fi

if gum confirm "Configure git identity?"; then
  NEW_NAME=$(gum input --prompt "Your name: " --value "$CURRENT_NAME" --placeholder "Enter your name")
  
  if [[ -n "$NEW_NAME" ]]; then
    git config --global user.name "$NEW_NAME"
    gum style --foreground 2 "Git name set to: $NEW_NAME"
  fi
  
  NEW_EMAIL=$(gum input --prompt "Your email: " --value "$CURRENT_EMAIL" --placeholder "Enter your email")
  
  if [[ -n "$NEW_EMAIL" ]]; then
    git config --global user.email "$NEW_EMAIL"
    gum style --foreground 2 "Git email set to: $NEW_EMAIL"
  fi
else
  gum style "Git configuration skipped."
fi
