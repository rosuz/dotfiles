#!/bin/bash

BACKUP_ROOT="$HOME/dotfiles-backup"
SESSION_FILE="$HOME/.local/share/dotfiles/.backup-session"

init_backup_session() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_session="backup_$timestamp"
    BACKUP_DIR="$BACKUP_ROOT/$backup_session"
    RESTORE_FILE="$BACKUP_DIR/RESTORE.txt"

    mkdir -p "$BACKUP_DIR"

    cat > "$SESSION_FILE" <<EOF
BACKUP_SESSION="$backup_session"
BACKUP_DIR="$BACKUP_DIR"
RESTORE_FILE="$RESTORE_FILE"
EOF

    cat > "$RESTORE_FILE" <<EOF
Backup created: $(date '+%Y-%m-%d %H:%M:%S')
Source: dotfiles installation

Files backed up:
EOF

    echo "$backup_session"
}

backup_file() {
    local source_path="$1"

    if [ -z "$BACKUP_DIR" ]; then
        if [ ! -f "$SESSION_FILE" ]; then
            echo "ERROR: No backup session initialized" >&2
            return 1
        fi
        source "$SESSION_FILE"
    fi

    if [ ! -e "$source_path" ]; then
        return 0
    fi

    local rel_path="${source_path#$HOME/}"
    local backup_path="$BACKUP_DIR/$rel_path"
    local backup_parent="$(dirname "$backup_path")"

    mkdir -p "$backup_parent"

    cp -rP "$source_path" "$backup_path"

    local rm_cmd="rm -rf \"$source_path\""
    local cp_cmd="cp -rP \"$backup_path\" \"$(dirname "$source_path")/\""

    cat >> "$RESTORE_FILE" <<EOF

- $source_path
  Restore: $rm_cmd && $cp_cmd
EOF

    return 0
}
