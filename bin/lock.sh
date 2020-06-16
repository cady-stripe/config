#!/bin/sh
revert() {
  xset dpms 0 0 0
}
trap revert SIGHUP SIGINT SIGTERM

# Lock screen displaying this image.
i3lock -i /usr/local/google/home/tgeng/Pictures/wallpaper.jpg

# Turn the screen off after a delay.
sleep 10; pgrep i3lock && xset dpms force off
revert
