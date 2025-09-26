#!/usr/bin/env bash
set -euo pipefail
# Simple taskbar: show floating pane slots [1][2][3] using state collected by launchers
state_dir=/workspace/zellij-config/state
mkdir -p "$state_dir"
touch "$state_dir/floats.list"
while true; do
  out=""
  i=1
  if [ -s "$state_dir/floats.list" ]; then
    while IFS= read -r name; do
      [ -z "$name" ] && continue
      out+=" [$i]"
      i=$((i+1))
    done < "$state_dir/floats.list"
  fi
  printf "\r\033[44;97m  Start  \033[0m  \033[42;30m >_ \033[0m%s\033[K" "$out"
  sleep 1
done
