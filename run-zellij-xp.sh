#!/usr/bin/env bash
set -euo pipefail

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export PATH="$SCRIPT_DIR/bin:$PATH"
export ZELLIJ_CONFIG_DIR="$SCRIPT_DIR/zellij-config"

# Use absolute path for the layout
LAYOUT_PATH="$SCRIPT_DIR/zellij-config/layouts/windows_xp.kdl"

exec "$SCRIPT_DIR/bin/zellij" --layout "$LAYOUT_PATH" "$@"
