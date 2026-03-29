#!/bin/bash
set -euo pipefail

clear_logo

info "Theme Selection"

AVAILABLE_THEMES=()
while IFS= read -r theme; do
  theme_name=$(basename "$theme")
  [[ "$theme_name" == "current" || "$theme_name" == "templates" || "$theme_name" == "templates-user" ]] && continue
  AVAILABLE_THEMES+=("$theme_name")
done < <(find "$DOTFILES_PATH/themes" -mindepth 1 -maxdepth 1 -type d | sort)

if [[ ${#AVAILABLE_THEMES[@]} -eq 0 ]]; then
  error "No themes found!"
  exit 1
fi

echo "Available themes:"
select opt in "${AVAILABLE_THEMES[@]}"; do
  SELECTED_THEME="$opt"
  break
done

if [[ -z "$SELECTED_THEME" ]]; then
  info "No theme selected, using default (nord)"
  SELECTED_THEME="nord"
fi

info "Setting up theme: $SELECTED_THEME"

rm -rf "$DOTFILES_PATH/themes/current"
mkdir -p "$DOTFILES_PATH/themes/current"
cp -r "$DOTFILES_PATH/themes/$SELECTED_THEME/"* "$DOTFILES_PATH/themes/current/"

"$DOTFILES_PATH/bin/generate-theme"

mkdir -p ~/.config/btop/themes
rm -f ~/.config/btop/themes/current.theme
cp "$DOTFILES_PATH/themes/current/btop.theme" ~/.config/btop/themes/current.theme

success "Theme '$SELECTED_THEME' installed!"
