#!/bin/bash
if [ -f ~/.i3/$1 ]; then
  target=$(cat ~/.i3/$1)
else
  target=$2
  echo $target > ~/.i3/$1
fi
i3-msg workspace $target
