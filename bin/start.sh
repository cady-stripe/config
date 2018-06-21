/usr/bin/cinnamon-settings-daemon &
# (sleep 2; nm-applet) &
(sleep 2; /usr/share/goobuntu-indicator/goobuntu_indicator.py) &
(sleep 2; /usr/bin/goobuntu-welcome) &
gsettings-data-convert &
(sleep 3; /usr/share/gsysnews/gsysnews-launcher.sh) &
start-pulseaudio-x11 &
(sleep 3; cinnamon-sound-applet)

# if [ -f /usr/lib/gnome-settings-daemon/gsd-xsettings ]; then
#   /usr/lib/gnome-settings-daemon/gsd-xsettings
#   # gnome-power-manager
#   # /home/tgeng/bin/setup_screen.sh
#   nm-applet
#   # coq_guard.sh
# fi
# sleep 4; /home/tgeng/bin/kbd

#pacmd set-default-sink 0
#TERM=screen-256color-bce tilda

# Desktop environment
#gnome-settings-daemon &
#gnome-keyring-daemon
#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
#nm-applet &
# xautolock -time 30 -locker "gnome-screensaver-command --lock" &
#git annex assistant --autostart
# i3-battery-indicator &

# Cleanup unnecessary files
#rm -rf $HOME/.local/share/Trash

#sleep 5 && ~/bin/kbd
# xinput disable "SynPS/2 Synaptics TouchPad"
#xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Velocity Scaling" 250
#xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Profile" 2

#synclient PalmDetect=1
#synclient PalmMinWidth=2
#synclient PalmMinZ=20
#synclient ClickFinger2=2
#synclient ClickFinger3=3
#synclient TapButton3=3
#synclient TapButton2=2
#synclient SingleTapTimeout=50
