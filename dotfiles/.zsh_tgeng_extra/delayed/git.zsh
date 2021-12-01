alias gb_='git for-each-ref --color=always --sort=committerdate refs/heads/ --format='\''%(HEAD) %(color:red)%(objectname:short) %(color:yellow)%(refname:short)%(color:reset) %(contents:subject) (%(color:blue)%(committerdate:relative)%(color:reset))'\'''
alias gco='git checkout'
alias gs='git status'
alias gsu='git submodule update --init --recursive'
alias grs='git rebase --skip'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias gdiscard='git reset --hard'
alias guncommit='git reset --soft HEAD~1'
alias gunamend='git reset --soft HEAD@{1}'
alias gcam='git commit --amend --no-edit'
alias gca='git commit -a'
alias gra='git rebase --abort'
alias ga='noglob git add'
alias gc='git commit'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias gcps='git cherry-pick --skip'

function _remote() {
  echo -n space
  # repo_name=$(git_repo_name)
  # if [ "$repo_name" = "kotlin-ide" ] || [ "$repo_name" = "intellij" ]; then
  #   echo -n google
  # else
  #   local branch=$(_remote_branch)
  #   if [ -z "$(hub pr list -s all -h google:$branch -f '%pS %sH %i')" ]; then
  #     echo -n space
  #   else
  #     echo -n google
  #   fi
  # fi
}

function gtm() {
  git branch -u origin/$(_master)
}

function gpr() {
  tracked_branch=$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)")
  branch=$(_remote_branch)
  if [[ $tracked_branch = "origin/$branch" ]];then
    gtm
  fi
  git pull --rebase
}

function hco() {
  hub checkout https://github.com/JetBrains/intellij-community/pull/$@ && gtm
}

function showpr() {
  if [[ $1 = '' ]]; then
    branch=$(_remote_branch) && \
      hub pr show -h $(_remote):$branch
  else
    xdg-open https://github.com/JetBrains/intellij-community/pull/$1
  fi
}

function listpr() {
  branch=$(_remote_branch) && \
    hub pr list -s all -h $(_remote):$branch -f '%pC%>(8)%i%Creset  %t%  l [%pS]%n%n   %U%n'
}

# function showci() {
#   branch=$(_remote_branch) && \
#     google-chrome --new-window "https://teamcity.jetbrains.com/buildConfiguration/Kotlin_KotlinForGoogle_AggregateBranch?branch=${branch}&buildTypeTab=overview&mode=builds"
# }

function db() {
  local branch=$1
  if ! git branch -D "$branch" 2> /dev/null; then
    local checkout_location=$(git branch -D "$branch" 2>&1 >/dev/null | cut -d"'" -f 4)
    if ! [ "$PWD" = "$checkout_location" ]; then
      pushd $checkout_location >/dev/null
    fi
    git checkout origin/$(_master) 2>/dev/null && git branch -D "$branch"
    if ! [ "$PWD" = "$checkout_location" ]; then
      popd >/dev/null
    fi
  fi
}

compdef _git db=git-branch

function prune-all() {
  remote=$(_remote)
  if [ "$remote" = "space" ]; then
    remote=google
  fi
  git for-each-ref --format='%(refname:short)' refs/heads | while read branch
  do
    remote_branch=$(_convert_to_remote_branch $branch)
    if [[ "$remote_branch" = "$branch" ]]; then
      db $branch
    else
      state_and_commit=$(hub pr list -s all -h $remote:$remote_branch -f '%S %sH')
      if [[ $state_and_commit = "" ]]; then
        commit_id=$(git rev-parse --verify space/$remote_branch 2> /dev/null)
        head_commit_id=$(git rev-parse --verify $branch 2> /dev/null)
        if [ -n "$commit_id" ]; then
          state=space
          commit=$head_commit_id
        elif [ -f ~/.space_remote_branches/"$branch" ]; then
          state=closed
          commit=$head_commit_id
          rm ~/.space_remote_branches/"$branch"
        fi
      else
        state=$(echo -n $state_and_commit | cut -d' ' -f1)
        commit=$(echo -n $state_and_commit | cut -d' ' -f2)
      fi
      if [[ "$state" = "closed" ]] || [[ "$state" = "merged" ]] || ([[ "$commit" != "" ]] && ! git cat-file -e "${commit}"); then
        db $branch
      fi
    fi
  done
}

function _master() {
  repo_name=$(git_repo_name)
  if [ "$repo_name" = "kotlin-ide" ] || [ "$repo_name" = "intellij" ]; then
    echo -n kt-212-master
  else
    echo -n master
  fi
}

function _branch() {
  git branch --show-current
}

function _remote_branch() {
  _convert_to_remote_branch $(git branch --show-current)
}

function _convert_to_remote_branch() {
  if [[ "$1" = prr/* ]]; then
    echo -n $1
  else
    echo -n prr/tgeng/$1
  fi
}

function git_repo_name() {
  dir=$(get_dir_containing .git) && basename $dir
}

function gpu() {
  [ "$(git_repo_name)" = "kotlin-ide" ] && return
  git fetch origin master
  KOTLIN_DEV_TAG=$(git describe --tags --abbrev=0 --match 'build-*-dev-*' origin/master)
  echo "pusing $KOTLIN_DEV_TAG" && \
  git push google $KOTLIN_DEV_TAG && \
  echo "pusing master" && \
  git push google origin/master:master
}

function gpk() {
  remote=$(_remote)

  branch=$(git branch --show-current)
  remote_branch=$(_remote_branch)
  if ! [ $remote = "space" ]; then
    pr_status_commit_and_id=$(hub pr list -s all -h $remote:$remote_branch -f '%pS %sH %i')
    pr_commit=$(echo -n $pr_status_commit_and_id | cut -d' ' -f2)
  fi
  if [[ "$pr_commit" = "" ]] || git cat-file -e "${pr_commit}"; then
    git push -f $remote $branch:$remote_branch
    if [ $remote = "space" ]; then
      # push to github to get the tests running
      git push -f google $branch:$remote_branch
      touch ~/.space_remote_branches/"$branch"
    fi
  else
    echo "Your local branch is behind remote branch $branch"
  fi
}

function gps() {
  remote=$(_remote)

  branch=$(git branch --show-current)
  remote_branch=$(_remote_branch)
  pr_status_commit_and_id=$(hub pr list -s all -h $remote:$remote_branch -f '%pS %sH %i')
  pr_commit=$(echo -n $pr_status_commit_and_id | cut -d' ' -f2)
  if [[ "$pr_commit" = "" ]] || git cat-file -e "${pr_commit}"; then
    git push -f $remote $branch:$remote_branch
  else
    echo "Your local branch is behind remote branch $remote_branch"
  fi
}

function dpr() {
  gpk || return 1
  remote=$(_remote)
  master=$(_master)

  branch=$(_remote_branch)
  hub pull-request -d -b JetBrains:$master -h $remote:$branch $@ && \
    hub pr list -s all -h $remote:$branch -f '%U' | xclip -selection clipboard
}

function gst() {
  git checkout -b $1 origin/$(_master)
}

function gstc() {
  remote_branch=$(_remote_branch)
  if git rev-parse --verify space/$remote_branch > /dev/null ; then
    # space branch exists
    git checkout -b $1 space/$remote_branch
  else
    git checkout -b $1 origin/$(_master)
  fi
}

function gb() {
  remote=$(_remote)
  if [ "$remote" = "space" ]; then
    remote=google
  fi
  gb_ | while read branch_line
  do
    branch=$(echo -n $branch_line | sed -r "s/(\* )?\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | cut -d' ' -f2)
    remote_branch=$(_convert_to_remote_branch $branch)
    pr_status_commit_and_id=$(hub pr list -s all -h $remote:$remote_branch -f '%pS %sH %i')
    if [ "${branch_line:0:2}" = '* ' ]; then
      echo -n "* "
    else
      echo -n "  "
    fi
    if [[ $pr_status_commit_and_id = "" ]];then
      space_commit_id=$(git rev-parse --verify space/$remote_branch 2> /dev/null)
      if [[ $space_commit_id != "" ]]; then
        pr_status_commit_and_id="space $space_commit_id space"
      elif [ -f ~/.space_remote_branches/"$branch" ]; then
        head_commit_id=$(git rev-parse --verify $branch 2> /dev/null)
        pr_status_commit_and_id="closed $head_commit_id space"
      fi
    fi
    if [[ $pr_status_commit_and_id != "" ]];then
      pr_status=$(echo -n $pr_status_commit_and_id | cut -d' ' -f1)
      pr_commit=$(echo -n $pr_status_commit_and_id | cut -d' ' -f2)
      pr_id=$(echo -n $pr_status_commit_and_id | cut -d' ' -f3)
      pr_summary="$pr_id"
      if ! git cat-file -e "${pr_commit}"; then
        pr_summary="$pr_summary $fg_bold[red](behind)"
      elif [[ "$pr_commit" != $(git rev-parse $branch | awk '{$1=$1};1') ]] ;then
        pr_summary="$pr_summary $fg_bold[yellow](ahead)"
      fi
      if [[ $pr_status = 'draft' ]]; then
        _echo_bg 241 $pr_summary
      elif [[ $pr_status = 'open' ]]; then
        _echo_bg 28 $pr_summary
      elif [[ $pr_status = 'merged' ]]; then
        _echo_bg 99 $pr_summary
      elif [[ $pr_status = 'closed' ]]; then
        _echo_bg 124 $pr_summary
      elif [[ $pr_status = 'space' ]]; then
        _echo_bg 202 $pr_summary
      else
        echo -n $pr_summary
      fi
    else
      echo -n '       '
    fi
    echo -n ' '
    if [ "${branch_line:0:2}" = '* ' ]; then
      echo ${branch_line:2}
    else
      echo $branch_line
    fi
  done
}

function _echo_bg() {
  TAG="\e[48;5;${1}m\e[38;5;15m"
  echo -ne "${TAG} $2 \e[0m"
}

function s() {
  selected=$(gb_ | grep -v '^\*' | cut -c3- | grep -v 'heads/' | grep -v 'kotlin-playground' | grep -iF "$1" | fzf -1 --reverse --tac --height=20 --min-height=1 --ansi -m | cut -d' ' -f2)
  if [[ "$selected" != "" ]]; then
    git checkout $selected
  fi
}

return_git_status_files() {
    LBUFFER="${LBUFFER}$(git status -s | fzf -1 --reverse --tac --height=20 --min-height=1 --ansi -m | cut -c4- | sed 's/ -> / /' | tr '\r\n' ' ')"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}
zle     -N   return_git_status_files
bindkey '^S' return_git_status_files
