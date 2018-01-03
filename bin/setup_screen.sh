#!/bin/sh
until [ xrandr ];
do sleep 1
done

while true
do
monitors=$(xrandr --query | grep " connected")
if echo $monitors | grep 'DVI-D-1 connected' && echo $monitors | grep 'DP-1 connected'; then
  echo 'both monitors are connected'
  xrandr --output DP-1 --primary --mode 3440x1440 --pos 0x0 --rotate normal --output DVI-D-1 --mode 1920x1200 --pos 3440x0 --rotate left
  feh --bg-fill ~/Pictures/wallpaper.jpg
  exit
fi
sleep 1
done
