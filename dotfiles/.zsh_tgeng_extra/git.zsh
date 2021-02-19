alias gb_='git for-each-ref --color=always --sort=committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset))'\'''
alias gco='git checkout'
alias gs='git status'
alias gsu='git submodule update --init --recursive'
alias grs='git rebase --skip'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias gpr='git pull --rebase'
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

function showpr() {
  branch=$(_remote_branch) && \
  hub pr show -h google:$branch
}

function listpr() {
  branch=$(_remote_branch) && \
  hub pr list -s all -h google:$branch -f '%pC%>(8)%i%Creset  %t%  l [%pS]%n%n   %U%n'
}

function showci() {
  branch=$(_remote_branch) && \
    xdg-open "https://teamcity.jetbrains.com/buildConfiguration/Kotlin_KotlinForGoogle_AggregateBranch?branch=${branch}&buildTypeTab=overview&mode=builds"
}

function prune-all() {
  git for-each-ref --format='%(refname:short)' refs/heads | while read branch
  do
    remote_branch=$(_convert_to_remote_branch $branch)
    state_and_commit=$(hub pr list -s all -h google:$remote_branch -f '%S %sH')
    state=$(echo -n $state_and_commit | cut -d' ' -f1)
    commit=$(echo -n $state_and_commit | cut -d' ' -f2)
    if [[ "$state" = "closed" ]] || [[ "$state" = "merged" ]] || ([[ "$commit" != "" ]] && ! git cat-file -e "${commit}"); then
      git branch -D "$branch" || (git checkout origin/master && git branch -D "$branch")
    fi
  done
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


function gpu() {
  git fetch origin master
  KOTLIN_DEV_TAG=$(git describe --tags --abbrev=0 --match 'build-*-dev-*' origin/master)
  echo "pusing $KOTLIN_DEV_TAG" && \
  git push google $KOTLIN_DEV_TAG && \
  echo "pusing master" && \
  git push google origin/master:master
}

function gpk() {
  branch=$(git branch --show-current)
  remote_branch=$(_remote_branch)
  pr_status_commit_and_id=$(hub pr list -s all -h google:$remote_branch -f '%pS %sH %i')
  pr_commit=$(echo -n $pr_status_commit_and_id | cut -d' ' -f2)
  if [[ "$pr_commit" = "" ]] || git cat-file -e "${pr_commit}"; then
    git push -f google $branch:$remote_branch
  else
    echo "Your local branch is behind remote branch $remote_branch"
  fi
}

function dpr() {
  gpk || return 1
  branch=$(_remote_branch)
  hub pull-request -d -b JetBrains:master -h google:$branch $@ && \
  hub pr list -s all -h google:$branch -f '%U' | xclip -selection clipboard
}

function gst() {
  git fetch origin master
  git checkout -b $1 origin/master
}

function gb() {
  gb_ | while read branch_line
  do
    branch=$(echo -n $branch_line | sed -r "s/(\* )?\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | cut -d' ' -f1)
    if [ "${branch_line:0:2}" != '* ' ]; then
      echo -n "  "
    fi
    echo -n $branch_line
    echo -n ' '
    remote_branch=$(_convert_to_remote_branch $branch)
    pr_status_commit_and_id=$(hub pr list -s all -h google:$remote_branch -f '%pS %sH %i')
    if [[ $pr_status_commit_and_id != "" ]];then
      pr_status=$(echo -n $pr_status_commit_and_id | cut -d' ' -f1)
      pr_commit=$(echo -n $pr_status_commit_and_id | cut -d' ' -f2)
      pr_id=$(echo -n $pr_status_commit_and_id | cut -d' ' -f3)
      pr_summary=$pr_id
      if ! git cat-file -e "${pr_commit}"; then
        pr_summary="$pr_summary $fg_bold[red](behind)"
      elif [[ "$pr_commit" != $(git rev-parse $branch | awk '{$1=$1};1') ]] ;then
        pr_summary="$pr_summary $fg_bold[yellow](ahead)"
      fi
      if [[ $pr_status = 'draft' ]]; then
        _echo_bg 31 $pr_summary
      elif [[ $pr_status = 'open' ]]; then
        _echo_bg 28 $pr_summary
      elif [[ $pr_status = 'merged' ]]; then
        _echo_bg 99 $pr_summary
      elif [[ $pr_status = 'closed' ]]; then
        _echo_bg 124 $pr_summary
      else
        echo -n $pr_summary
      fi
    fi
    echo
  done
}

function _echo_bg() {
  TAG="\e[48;5;${1}m"
  echo -ne "${TAG} $2 \e[0m"
}

function s() {
  selected=$(gb_ | grep -v '^\*' | cut -c3- | grep -v 'heads/' | grep -iF "$1" | fzf -1 --reverse --tac --height=20 --min-height=1 --ansi -m | cut -d' ' -f1)
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
