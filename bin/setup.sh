#!/bin/bash

killall redshift
redshift -x
nohup redshift -l 47.61:-122.33 -t 5700:3600 -g 1 -m randr -v > /dev/null&
ps -e aux | grep "[r]emote_guard.sh" || nohup remote_guard.sh > /dev/null 2>&1 &
feh --bg-fill /home/tgeng/Pictures/wallpaper.jpg
nohup ~/dev/autorandr/contrib/autorandr_launcher/autorandr-launcher > /dev/null&
