#!/bin/sh
xrandr --output DP-7 --off --output DP-6 --off --output DP-0 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-2 --mode 2560x1440 --pos 2560x0 --rotate right --output DP-3 --off --output DP-2 --off --output DP-1 --off --output DP-0 --off
nohup compton > /dev/null 2>&1 &
feh --bg-fill ~/Pictures/wallpaper.jpg
kbd
sleep 1
nohup tilda > /dev/null 2>&1 &
