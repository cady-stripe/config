if [[ -e /usr/local/google/home ]]; then
  function psj() {
    if [[ $PWD =~ '(.*)/javatests(.*)' ]]; then
      echo "${match[1]}/java${match[2]}"
    else
      echo "${PWD/\/google3\/java//google3/javatests}"
    fi
  }

  function sj() {
    cd $(psj)
  }

  function bb() {
    if [[ $PWD =~ '(.*)/(blaze|bazel)-bin(.*)' ]]; then
      cd "${match[1]}${match[3]}"
    else
      if [[ $PWD =~ '(.*)google3/(.*)' ]]; then
        cd $(echo $PWD| sed 's!\(google3\)!\1/blaze-bin!')
      else
        cd $(echo $PWD| sed 's!\(studio-master-dev\)!\1/bazel-bin!')
      fi
    fi
  }

  alias gme='g fix5 && g multi export'
  alias gl='g log5'
  alias gr='g rb5'
  alias gms='g multi sync'
  alias gcm='g commit --amend --no-edit'
  alias gcam='g commit -a --amend --no-edit'
  alias gca='g commit -a'
  alias gfix='g fix5'
  alias grc='g rebase --continue'
  alias gra='g rebase --abort'
  alias ga='noglob g add'
  alias fixjs=/google/src/components/head/google3/third_party/java_src/jscomp/java/com/google/javascript/jscomp/lint/fixjs.sh
  alias apitool='/google/data/ro/teams/cloud-marketplace/apitool'
  function gg() {
    if [[ -d ~/git/$1/google3 ]]; then
      cd ~/git/$1/google3
    else
      g4d $1
    fi
  }
  function depotp() {
    pwd | sed 's|/usr/local/google/home/tgeng/git/[^/]\+/google3/\(.\+\)|\1|' | sed 's|/google/src/cloud/tgeng/[^/]\+/google3/\(.\+\)|\1|' | sed 's|^/.*||'
  }
  function sc() {
    local current
    current=$(depotp)
    g4d $1 && cd $current
  }
  function sg() {
    local current
    current=$(depotp)
    gg $1 && cd $current
  }
  function p() {
    echo -n '//'`depotp` | xclip -selection clipboard
  }

  function cdg() {
    bd google3 > /dev/null
    if [ $1 ]; then
      cdt_ $1
    fi
  }

  function cdc() {
    local opened
    opened=$(g4 whatsout | sed "s|$PWD/||")
    if [[ -n $opened  ]]; then
      opened=$(echo $opened | fzfi $1)
      if [[ -n $opened  ]]; then
        cdt $opened
      fi
    else
      echo "no opened file"
    fi
  }
  alias csearch='noglob /google/data/ro/projects/codesearch/csearch'
  alias cs='noglob /google/data/ro/projects/codesearch/cs'

  function csd_() {
    if [[ -z "$_FASD_PREFIX" ]]; then
      cs $@ --local
    else
      local file="file:^//depot$(pwd|sed "s|$_FASD_PREFIX||")"
      cs $file $@ --local
    fi
  }
  function csd_browser() {
    local file="//depot$(pwd|sed "s|$_FASD_PREFIX||")"
    if [[ -z $1 ]]; then
      xdg-open "https://cs.corp.google.com/piper/$file" > /dev/null 2>&1
    else
      local q="$*"
      xdg-open "https://cs.corp.google.com/search/?q=file:^$file $q" > /dev/null 2>&1
    fi
  }
  alias csd='noglob csd_browser'

  cdt_() {
    if [[ -n $1 ]]; then
      cd $1 2> /dev/null || cd $(dirname $1)
    fi
  }
  get_aosp_dir() {
    current_dir=$(pwd)
    while [ $current_dir != '/' ] && ! ls "$current_dir/.repo" > /dev/null 2>&1; do
      current_dir=$(dirname $current_dir)
    done
    if [ $current_dir != '/' ]; then
      echo $current_dir
    fi
  }
  cd_aosp() {
    aosp_dir=$(get_aosp_dir)
    [ -n $aosp_dir ] && cd $aosp_dir
  }
  alias cda='cd_aosp'
  alias cdt='cdt_'
  alias c='clear'
  fzfi() {
    local FZF_OPTIONS
    local FZF_QUERY
    FZF_OPTIONS="-1 --reverse --tac --height=20 --min-height=1 --ansi"
    if [ -n "$1" ]; then
      FZF_OPTIONS="$FZF_OPTIONS -e -q"
      FZF_QUERY="$1"
    fi
    fzf ${=FZF_OPTIONS} ${FZF_QUERY}
  }
  select_fig_branch_() {
    hg xl --color always | sed "s%[:x*| /o@]\+\?  \(.*\)$%\1%" | head -n -1 | paste -d" " - - | fzfi "$1" | cut -f1 -d" "
  }

  select_aosp_branch_and_cd_to_it_() {
    branches=$(script -q --return -c "repo branch" /dev/null)
    if [ -z "$branches" ]; then
      return
    fi
    selection=$(echo $branches | fzfi "$1" | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | tr -d '[:cntrl:]')
    if [ -z "$selection" ]; then
      return
    fi
    branch=$(echo "$selection" | sed 's/.[^ ]* \+\([^ ]\+\).*/\1/')
    project=$(echo "$selection" | sed 's/.* \([^ ]\+\)/\1/')
    cd_aosp && cd $project && git checkout $branch
  }
  alias prune-all='repo forall -c prune-ng'
  return_fig_branch_() {
    LBUFFER="${LBUFFER}$(select_fig_branch_)"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
  }
  zle     -N   return_fig_branch_
  function s() {
    if [[ $(pwd) == "/google/src/cloud"* ]]; then
      select_fig_branch_ "$*" | xargs -r hg update
    else
      select_aosp_branch_and_cd_to_it_ "$*"
    fi
  }
  bindkey '^S' return_fig_branch_

  FZF_CTRL_R_OPTS='--reverse'

  function vc() {
    local opened
    opened=$(g4 whatsout | sed "s|$PWD/||")
    if [[ -n $opened  ]]; then
      opened=$(echo $opened | fzfi $1)
      if [[ -n $opened  ]]; then
        fasd --add $opened $(dirname $opened)
        vim $opened
      fi
    else
      echo "no opened file"
    fi
  }
  function fs_() {
    if [[ -z $_FASD_PREFIX ]]; then
      echo "You must be in a Citc or git5 directory."
      return
    fi
    local cmd=$1;shift
    local results
    results=$(csd_ -l --max_num_results=100 $@ 2> /dev/null | sed "s|$PWD/||")
    if [[ -n $results  ]]; then
      results=$(echo $results | fzfi $1)
      if [[ -n $results  ]]; then
        fasd --add $results $(dirname $results)
        $cmd $results
      fi
    else
      echo "no opened file"
    fi
  }

  alias vs='noglob fs_ vim'
  alias cds='noglob fs_ cdt_'

  source /etc/bash_completion.d/g4d
  # for pulling CITC change back to git multi, see https://docs.google.com/document/d/1gRXK5WAh7Ml_ezx7LmKwz40XMx3m7jwUftezrHhzUjU/edit#
  PATH=$PATH:/google/data/ro/users/ho/hoffstaetter/scripts:/google/data/ro/projects/goops

  gput() {
    if [ -n "$(git status --porcelain)" ]; then
      # Uncommitted changes
      echo "Workspace is not clean"
      return
    fi
    local new_branch current_path current_branch
    new_branch=$1
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ $new_branch = $current_branch ]];then
      echo "Cannot send to current branch."
      return
    fi
    shift
    current_path=$(depotp)
    all_files=$(realpath $@)
    cdg &&\
      gco $new_branch || g start $new_branch && g multi sync &&\
      xargs rm -r <<< $all_files 2> /dev/null
    gco $current_branch -- $(echo $all_files | sed "s|$PWD|./|") &&\
    if [[ -z $(gl) ]]; then
      # no outstanding commit
      g commit -a
    else
      g commit -a --amend --no-edit
    fi && gco $current_branch && cdg $current_path
  }

  gexport() {
    local new_branch current_path current_branch
    new_branch=$1
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    current_path=$(depotp)
    gco $new_branch && g fix5 && g multi export && gco $current_branch && cdg $current_path
  }

  gsend() {
    new_branch=$1
    if [[ -z $2 ]]; then
      if [[ -e $(psj) ]]; then
        gput $1 . $(psj)
      else
        gput $1 .
      fi
    else
      gput $@
    fi && gexport $1
  }
fi

alias sp='span sql /span/global/cloud-commerce-eng:procurement-prod'
alias spstg='span sql /span/nonprod/cloud-commerce-eng:procurement-staging'
alias si='span sql /span/global/cloud-commerce-eng:inventory-prod'
alias sistg='span sql /span/nonprod/cloud-commerce-eng:inventory-staging'
rpcreplay() {
  local error
  error=$(cdg)
  cdg > /dev/null
  /google/data/ro/teams/frameworks-test-team/rpcreplay-cli/live/rpcreplay $@
  if [ -z $error  ]; then
    -
  fi
}

alias afseu='hg amend && hg fix && hg sync && hg evolve && hg uploadall'
alias afsu='hg amend && hg fix && hg sync && hg uploadchain'
alias fsu='hg fix && hg sync && hg uploadchain'
function goog-email-to-gaia-id() {
  local emailAddress="$1"
  echo "Username: '${emailAddress}'" |
    stubby call blade:gaia-backend GaiaServerStubby.Lookup |
    grep 'UserID' |
    cut -d: -f2 |
    xargs
}


function goog-gaia-id-to-email() {
  # local user_id="$1"
  echo "UserID: {ID: $user_id}" |
    stubby call blade:gaia-backend GaiaServerStubby.Lookup |
    grep 'Email:' |
    cut -d: -f2 |
    xargs |
    tr " " "\n"
}
function adt_bazel() {
  aosp_dir=$(get_aosp_dir)
  if [ -z "$aosp_dir" ]; then
    echo "Must be under an AOSP dir or subdir"
    return
  fi
  $(get_aosp_dir)/tools/base/bazel/bazel $@
}

function repo_sync_to_bid() {
  bid=$1
  if [ -z "$bid" ]; then
    echo "Must set a build ID"
    return
  fi
  aosp_dir=$(get_aosp_dir)
  if [ -z "$aosp_dir" ]; then
    echo "Must be under an AOSP dir or subdir."
    return
  fi
  current_dir=$(pwd)
  cd /tmp &&\
  /google/data/ro/projects/android/fetch_artifact --bid $bid --target studio "manifest_$bid.xml"  &&\
  mv "manifest_$bid.xml" $aosp_dir/.repo/manifests/ &&\
  cd $current_dir &&\
  repo sync -j128 -d -m manifest_${bid}.xml
}

function repo_sync_to_branch() {
  repo init -b $1 && repo sync -j128
}
alias kill_as="ps aux | grep intellij\.android\.jps | grep -v grep | fzf | tr -s ' ' | cut -d' ' -f 2 | xargs -r kill"

function run_studio () {
  local bid=$1
  local studio_dir="$HOME/as-releases/android-studio-$bid"
  if [ ! -d "$studio_dir" ]; then
    if [ ! -f "$studio_dir.tar.gz" ]; then
      local current_dir=$(pwd)
      mkdir -p $HOME/as-releases
      cd $HOME/as-releases
      /google/data/ro/projects/android/fetch_artifact --bid "$bid" --target studio "android-studio-$bid.tar.gz"
      cd $current_dir
    fi
    if [ ! -f "$studio_dir.tar.gz" ]; then
      echo "Failed downloading build $bid"
      return
    fi
    mkdir -p $studio_dir
    tar -xvf "$studio_dir.tar.gz" -C $studio_dir
  fi
  $studio_dir/bin/studio.sh || $studio_dir/android-studio/bin/studio.sh
}
