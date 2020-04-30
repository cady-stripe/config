#!/bin/sh
revert() {
  xset dpms 0 0 0
}
trap revert SIGHUP SIGINT SIGTERM

# Lock screen displaying this image.
i3lock -i /usr/local/google/home/tgeng/Pictures/lock.png

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
revert
