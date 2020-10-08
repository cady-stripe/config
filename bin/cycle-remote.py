#!/usr/bin/python3
import subprocess as sp
import json
import sys

if sys.argv[1] == 'next':
    offset = 1
else:
    offset = -1

p = sp.run(['i3-msg', '-t', 'get_workspaces'], stdout=sp.PIPE)
workspaces = json.loads(p.stdout)

remote_workspaces = ["100:Linux", "101:Cloudtop", "102:Windows"]
#  all_workspaces = [ws["name"] for ws in workspaces if ws["name"] not in remote_workspaces] + remote_workspaces
all_workspaces = remote_workspaces

focused = [ws for ws in workspaces if ws["focused"]][0]
focused_name = focused["name"]

if focused_name in all_workspaces:
    current_index = all_workspaces.index(focused_name)
    new_index = (current_index + offset) % len(all_workspaces)
else:
    new_index = int(-0.5 + offset / 2)

new_ws = all_workspaces[new_index]

sp.run(['i3-msg', 'workspace', new_ws])
