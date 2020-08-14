#!/usr/bin/python

from __future__ import print_function
import re
import sys
from pyquery import PyQuery as pq

archive_html = sys.argv[1].lower()

with open(archive_html, "r") as f:
  doc = pq(f.read())
  for release in doc("section.expandable")[1:]: # skip first one since it's the header
    r = pq(release)
    current_version = r(".expand-control")[0].text.strip()
    if current_version.startswith("Android Studio ") and r("a"):
      matched = re.match(".*\.([0-9]+).*", r("a")[0].text)
      if matched:
        print("(" + matched.group(1) + ") " + current_version)

