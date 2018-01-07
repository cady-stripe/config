if command -v xfce4-session-logout; then
  gnome-session-quit --force --logout
else
  i3-msg exit
fi

