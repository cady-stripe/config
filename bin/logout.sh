if command -v xfce4-session-logout; then
  xfce4-session-logout --logout
else
  i3-msg exit
fi

