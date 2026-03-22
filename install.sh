#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/share/dotfiles"

if [[ "$SCRIPT_DIR" == "$TARGET_DIR" ]]; then
  exec bash "$SCRIPT_DIR/install/install.sh"
fi

echo "Installing dotfiles to $TARGET_DIR..."

if [[ -d "$TARGET_DIR" ]]; then
  read -p "Directory exists. Remove and reinstall? [y/N] " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
  fi
  rm -rf "$TARGET_DIR"
fi

mkdir -p "$(dirname "$TARGET_DIR")"
cp -r "$SCRIPT_DIR" "$TARGET_DIR"

exec bash "$TARGET_DIR/install/install.sh"
