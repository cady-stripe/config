#!/bin/bash
ps aux | grep "[c]ompton" || nohup compton > /dev/null 2>&1 &
ps aux | grep "[t]ilda" || nohup tilda > /dev/null 2>&1 &
killall albert && nohup albert > /dev/null 2>&1 &
killall autokey-gtk && nohup autokey-gtk > /dev/null 2>&1 &
feh --bg-fill ~/Pictures/wallpaper.jpg
kbd
