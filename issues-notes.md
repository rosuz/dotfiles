# Issues & Improvements

## Critical Issues

### 1. Missing User Config Files in ~/.config/hypr/conf/
**Location**: `config/hypr/hyprland.conf` (lines 8-12)

`config/hypr/hyprland.conf` sources user config files from `~/.config/hypr/conf/`:
- `monitors.conf`
- `input.conf`
- `looknfeel.conf`
- `autostart.conf`
- `keybindings.conf`

**Problem**: After fresh install, these files don't exist. The loop in `links.sh` only copies what's in `config/hypr/conf/` which is empty or missing entirely.

**Fix**: Either:
- Create placeholder files in `config/hypr/conf/`
- OR remove these `source` lines if they're meant to be optional

---

### 2. hypridle Config Not Installed
**Location**: `install/packaging/base.sh`

`hypridle` is installed but `hypridle.conf` is never copied to `~/.config/hypr/`.

**Fix**: Add to `install/config/links.sh` or create `config/hypr/hypridle.conf`

---

### 3. apply-theme: hyprpaper Not Started via uwsm-app
**Location**: `bin/apply-theme` (lines 24-26)

```bash
pkill -x hyprpaper 2>/dev/null || true
sleep 0.3
hyprpaper &
```

**Problem**: Should use `uwsm-app -- hyprpaper &` for proper session integration.

**Fix**: Change to `uwsm-app -- hyprpaper &`

---

## Medium Issues

### 4. uwsm/default Copied Twice
**Location**: `install/config/shell.sh` (lines 20-21) + `install/config/links.sh`

In `shell.sh`:
```bash
cp "$DOTFILES_PATH/config/uwsm/default" "$HOME/.config/uwsm/default"
```

In `links.sh`, the loop also copies `config/uwsm/default`.

**Fix**: Remove one of the copies, or check if file exists before copying.

---

### 5. theme-switch: No Hyprland Session Check
**Location**: `bin/theme-switch`

Runs regardless of session type. If run from tty, may leave inconsistent state or fail silently.

**Fix**: Add check at beginning:
```bash
if [[ "$XDG_SESSION_TYPE" == "tty" ]]; then
  echo "Cannot switch theme outside Hyprland session"
  exit 1
fi
```

---

### 6. Generate-theme: All-or-Nothing Template Processing
**Location**: `bin/generate-theme`

If a theme lacks a template (e.g., `ghostty.conf.tpl` exists but theme has no `ghostty.conf`), it creates an empty file instead of skipping.

**Fix**: Check if template produces non-empty output before copying.

---

### 7. clipboard Manager Not Configured
**Location**: `install/packaging/tools.sh` + `default/hypr/conf/autostart.conf`

`cliphist` is installed and stores clipboard, but no visual clipboard manager (like `wofi` or `rofi` script) is configured to view/retrieve history.

**Fix**: Either:
- Create a clipboard menu script
- OR add a clipboard viewer like `clipmenu`

---

## Low Issues

### 8. Some Theme Templates May Be Missing
Looking at `themes/templates/`:
- `ghostty.conf.tpl` exists
- `kitty.conf.tpl` exists
- `alacritty.toml.tpl` exists

If a user switches themes and the template expects certain keys, missing values will result in empty placeholders.

---

### 9. PATH Export Redundancy
**Location**: `default/hypr/conf/envs.conf` (line 18) + `config/uwsm/env`

PATH is set in both:
- `envs.conf`: `env = PATH,$HOME/.local/share/dotfiles/bin:$PATH`
- `uwsm/env`: `export PATH=$DOTFILES_PATH/bin:$PATH:$HOME/.local/bin`

**Fix**: Remove from one location to avoid duplication.

---

### 10. fastfetch config uses .jsonc but may not be parsed
**Location**: `config/fastfech/config.jsonc`

fastfetch reads JSONC (JSON with comments), but need to verify the file is valid or the tool supports it.

---

## Questions for Future Work

1. Should user config files (`monitors.conf`, etc.) be created as templates in `config/hypr/conf/` with comments explaining they are optional?

2. Want to add more themes? Current: Nord, Matte Black

3. Should we add Tmux configuration (Omarchy v3.4.0 added it by default)?

4. Plan to add gaming tools (Steam, Retroarch) configs?

---

## Omarchy Sync Opportunities

Based on Omarchy v3.4.0 release (Feb 2026):
- Tmux with tailored config (alias `t`)
- Single screenshot flow with PrintScr
- Hibernation support
- Idle-lock and notification-silencing icons in Waybar
- NVIDIA GeForce NOW installer
- Tmux refresh in config refresh menu

Your dotfiles have some of these (tmux in tools.sh, screenshot, indicator icons), but could sync:
- Better screenshot flow (hyprshot integration)
- Hibernation configuration
- Idle-lock indicator in waybar
