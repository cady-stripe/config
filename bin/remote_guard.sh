#!/usr/bin/env bash
export QT_SCALE_FACTOR=1
function execute_once() {
  ps -e | grep "$1" || nohup "$1" > /dev/null 2>&1 &
}
while read -r line
do
  WINDOW_ID="$(echo  $line | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')"
  NAME=$(xprop -id $WINDOW_ID | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
  # CURRENT_KEYBOARD="$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')"
  if [[ $NAME == "Windows 10 - Google Chrome" || $NAME == "gLinux - Google Chrome" || $NAME == "Cloudtop 16 core - Google Chrome" ]]; then
    killall autokey-gtk
  else
    execute_once autokey-gtk
    kbd
    set_up_wallpaper.sh
  fi
done < <(xprop -spy -root _NET_ACTIVE_WINDOW)
