# Hyprland Dotfiles

A [Hyprland](https://hyprland.org/) dotfiles setup inspired by [Omarchy](https://github.com/basecamp/omarchy).
Built with simplicity, reproducibility, and learning in mind.

## Installation

```bash
git clone https://github.com/rosuz/hypr_dotfiles.git
cd hypr_dotfiles
./setup.sh
```

## How It Works

```
~/.local/share/dotfiles/   # Main dotfiles (git repo)
├── config/                # App configs → copied to ~/.config/
├── default/               # Default configs (Hyprland, shell, etc.)
├── themes/                # Theme files + generated configs
├── bin/                   # Scripts (accessible via PATH)
└── install/               # Installation system

~/.config/                 # Application configs
├── hypr/                  # Hyprland (sources ~/.local/share/dotfiles/default/hypr/)
├── waybar/                # Status bar
├── rofi/                  # Launcher
└── ...                    # Other app configs
```

## PATH Setup

The bin directory is automatically added to PATH via:
- `~/.bashrc` (for shell)
- `~/.config/uwsm/env` (for UWSM session)

No symlinks needed - scripts are accessible from anywhere.

## Keybindings

| Shortcut | Action |
|----------|--------|
| `Super + K` | Show all keybindings |
| `Super + Space` | App launcher |
| `Super + Escape` | System menu |
| `Super + Return` | Terminal |
| `Super + Shift + Return` | Browser |
| `Super + J` | Toggle window split |
| `Super + T` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + Q` | Close window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + Arrow` | Focus window |
| `Super + Shift + Arrow` | Swap window |
| `Super + S` | Toggle scratchpad |
| `Super + G` | Toggle grouping |
| `Super + C/V` | Copy/Paste |
| `Super + Ctrl + L` | Lock screen |
| `Print` | Screenshot |
| `Super + Print` | Color picker |

**Media keys**: Volume, brightness, playback control with OSD

## Customization

- **Keybindings**: Edit `~/.config/hypr/conf/keybindings.conf`
- **User overrides**: Add to `~/.config/hypr/conf/*.conf`
- **Themes**: Switch with `theme-switch` or `Super + Space → Style → Theme`
- **Menus**: `Super + Escape` for system, `Super + Alt + Space` for apps

## Features

- **Modular Hyprland config** with separate files for each concern
- **Theme system** with Nord and Matte Black (template-based)
- **Waybar** with workspaces, audio, network, battery, clock
- **Rofi** multi-level menu system
- **uwsm** session management
- **Grouped window management** with tab navigation
- **Scratchpad** support
- **Clipboard manager** integration

## Credits

**Hyprland config**: Inspired by [Omarchy](https://github.com/basecamp/omarchy) by [DHH](https://github.com/dhh) and [Basecamp](https://basecamp.com/). MIT License.

**Bash configuration**: Based on [ChrisTitusTech/mybash](https://github.com/ChrisTitusTech/mybash).
