#!/usr/bin/env bash
set -euo pipefail
# XP-like taskbar with Start and >_ buttons plus floating-pane counters
state_dir=/workspace/zellij-config/state
mkdir -p "$state_dir"
counter_file="$state_dir/float_counter"
list_file="$state_dir/floats.list"
[ -f "$counter_file" ] || echo 0 > "$counter_file"
[ -f "$list_file" ] || : > "$list_file"

print_bar() {
  out=""
  i=1
  if [ -s "$list_file" ]; then
    while IFS= read -r name; do
      [ -z "$name" ] && continue
      out+=" [$i]"
      i=$((i+1))
    done < "$list_file"
  fi
  printf "\r\033[44;97m  Start  \033[0m  \033[42;30m >_ \033[0m%s\033[K" "$out"
}

launch_float() {
  id=$(($(cat "$counter_file") + 1))
  echo "$id" > "$counter_file"
  name="float-$id"
  grep -qxF "$name" "$list_file" || echo "$name" >> "$list_file"
  /workspace/bin/zellij run --floating --pinned --name "$name" -- /workspace/zellij-config/float_shell.sh || true
}

launch_term() {
  id=$(($(cat "$counter_file") + 1))
  echo "$id" > "$counter_file"
  name="term-$id"
  grep -qxF "$name" "$list_file" || echo "$name" >> "$list_file"
  /workspace/bin/zellij run --floating --pinned --name "$name" -- ${SHELL:-bash} || true
}

clear
print_bar
# controls: Enter launches Start (float), t or > launches terminal, q quits
while true; do
  print_bar
  IFS= read -rsn1 k || break
  case "$k" in
    $'\n'|$'\r'|'') launch_float ;;
    t|T|">") launch_term ;;
    q|Q) exit 0 ;;
  esac
done
