#!/usr/bin/env bash

scratchpad_id=$(cat ~/.yabai_scratchpad 2> /dev/null || exit)
current_focus=$(yabai -m query --windows --window | jq .id || exit)
current_space=$(yabai -m query --spaces --space | jq '.index')

if [[ "$current_focus" -eq "$scratchpad_id" ]]; then
  last_focus=$(cat ~/.yabai_last_focus 2> /dev/null)
  if [ -n "$last_focus" ]; then
    yabai -m window --focus $last_focus
  fi
  yabai -m window "$scratchpad_id" --minimize
else
  echo -n $current_focus > ~/.yabai_last_focus
  yabai -m window "$scratchpad_id" --space "$current_space"
  yabai -m window --focus "$scratchpad_id"
fi

