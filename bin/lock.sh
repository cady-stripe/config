#!/bin/sh
revert() {
  xset dpms 0 0 0
  /home/tgeng/bin/setup_screen.sh
}
trap revert SIGHUP SIGINT SIGTERM
xset +dpms dpms 5 5 5
i3lock -n
revert
