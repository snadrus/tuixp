#!/usr/bin/env bash
set -euo pipefail
# Draw a minimal top bar and random dark background color, then exec shell
colors=( "40" "41" "42" "43" "44" "45" "46" )
rand=${RANDOM}
idx=$(( rand % ${#colors[@]} ))
bg=${colors[$idx]}
clear
# top bar with title
printf "\033[1;37;${bg}m  Floating Shell  \033[0m\n"
# fill rest of screen with background color (approx)
rows=$(tput lines || echo 24)
for ((i=2;i<=rows;i++)); do printf "\033[${bg}m \033[0m\n"; done
# move cursor to second line to show shell input area
printf "\033[2;1H"
exec ${SHELL:-bash}
