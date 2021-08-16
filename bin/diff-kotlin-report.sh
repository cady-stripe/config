#!/bin/bash

set -e

repo=/usr/local/google/home/tgeng/dev/kotlin-diagnostics
output_dir=/tmp/kotlin-diagnostic-reports/`date "+%F-%T"`
after=$(git rev-parse HEAD)

mkdir -p $output_dir
pushd $repo
git checkout -b kotlin-diagnostics $after
git push -f google kotlin-diagnostics:tmp/tgeng/kotlin-diagnostics-report
git checkout origin/master
git branch -D kotlin-diagnostics
diagnostics-diff-report --format HTML --repoAndCommit JetBrains/kotlin/$after compiler/testData/diagnostics $output_dir
google-chrome --new-window $output_dir/index.html
popd
