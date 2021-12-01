#!/bin/bash

set -e

repo=/usr/local/google/home/tgeng/dev/kotlin-diagnostics
output_dir=/tmp/kotlin-diagnostic-delta/`date "+%F-%T"`
before=$(git rev-parse @{u} 2>/dev/null || git merge-base origin/master HEAD)
after=$(git rev-parse HEAD)

mkdir -p $output_dir
pushd $repo
git checkout -b kotlin-diagnostics $after
git push -f google kotlin-diagnostics:tmp/tgeng/kotlin-diagnostics
git checkout origin/master
git branch -D kotlin-diagnostics
diagnostics-diff-delta --format HTML --repo JetBrains/kotlin --before $before --after $after compiler/testData/diagnostics $output_dir
google-chrome --new-window $output_dir/index.html
popd
