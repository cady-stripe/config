#!/bin/sh
revert() {
  xset dpms 0 0 0
}
if command -v xfce4-session-logout; then
  xfce4-session-logout --suspend
else
  trap revert SIGHUP SIGINT SIGTERM
  xset +dpms dpms 5 5 5
  i3lock -n
  revert
fi
