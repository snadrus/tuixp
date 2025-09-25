#!/usr/bin/env bash
set -euo pipefail
# Simple taskbar: list floating panes as [1] [2] [3] from zellij ls
while true; do
  panes=$( /workspace/bin/zellij list-panes --floating 2>/dev/null || true )
  ids=$( echo "$panes" | awk /^s*[0-9]+/
