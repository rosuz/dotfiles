#!/bin/bash
set -euo pipefail

clear_logo

info "Git Configuration"

CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [[ -n "$CURRENT_NAME" ]]; then
  info "Current git name: $CURRENT_NAME"
else
  info "No git name configured"
fi

if [[ -n "$CURRENT_EMAIL" ]]; then
  info "Current git email: $CURRENT_EMAIL"
else
  info "No git email configured"
fi

if confirm "Configure git identity?"; then
  read -p "Your name [$CURRENT_NAME]: " NEW_NAME
  NEW_NAME="${NEW_NAME:-$CURRENT_NAME}"
  
  if [[ -n "$NEW_NAME" ]]; then
    git config --global user.name "$NEW_NAME"
    success "Git name set to: $NEW_NAME"
  fi
  
  read -p "Your email [$CURRENT_EMAIL]: " NEW_EMAIL
  NEW_EMAIL="${NEW_EMAIL:-$CURRENT_EMAIL}"
  
  if [[ -n "$NEW_EMAIL" ]]; then
    git config --global user.email "$NEW_EMAIL"
    success "Git email set to: $NEW_EMAIL"
  fi
else
  info "Git configuration skipped."
fi
