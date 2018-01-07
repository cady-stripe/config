#!/bin/bash
export XAUTHORITY=/home/tgeng/.Xauthority
export DISPLAY=':0.0'

while true
do
monitors=$(xrandr --query | grep " connected" 2> /dev/null)
if echo $monitors | grep 'DVI-D-1 connected' > /dev/null && echo $monitors | grep 'DP-1 connected' > /dev/null; then
  xrandr --output DP-1 --primary --mode 3440x1440 --pos 0x0 --rotate normal --output DVI-D-1 --mode 1920x1200 --pos 3440x0 --rotate left
  feh --bg-fill /home/tgeng/Pictures/wallpaper.jpg
  exit
fi
sleep 1
done
