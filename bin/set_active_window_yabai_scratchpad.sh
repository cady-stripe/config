#!/usr/bin/env bash

window_status=$(yabai -m query --windows --window)
scratchpad_id=$(echo $window_status | jq .id)
scratchpad_floating=$(echo $window_status | jq .floating)

if [[ "$scratchpad_floating" -eq 0 ]]; then
  yabai -m window --focus "$scratchpad_id"
  yabai -m window --toggle float
  yabai -m window --move abs:0:0
  yabai -m window --resize abs:1920:1080
fi

echo -n $scratchpad_id > ~/.yabai_scratchpad
