#!/bin/bash

if [ -f ~/.i3/remote-workspace ]; then
  current=$(cat ~/.i3/remote-workspace)
  if [ $current = "RemoteLinux" ]; then
    current="RemoteWindows"
  else
    current="RemoteLinux"
  fi
  echo $current > ~/.i3/remote-workspace
fi
