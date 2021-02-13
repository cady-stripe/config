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
  branch=$(git branch --show-current)
  hub pr show -h google:prr/$USER/$branch
}

function listpr() {
  branch=$(git branch --show-current)
  hub pr list -s all -h google:prr/$USER/$branch -f '%pC%>(8)%i%Creset  %t%  l [%pS]%n%n   %U%n'
}

function prune-all() {
  git for-each-ref --format='%(refname:short)' refs/heads | while read branch
  do
    if [[ "$branch" = prr/* ]]; then
      git branch -D "$branch" || (git checkout origin/master && git branch -D "$branch")
    else
      state=$(hub pr list -s all -h google:prr/$USER/$branch -f '%S' -s closed)
      if [[ "$state" = "closed" ]]; then
        git branch -D "$branch" || (git checkout origin/master && git branch -D "$branch")
      fi
    fi
  done
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
  git push -f google $branch:prr/$USER/$branch
}

function dpr() {
  gpk
  branch=$(git branch --show-current)
  hub pull-request -d -b JetBrains:master -h google:prr/$USER/$branch $@
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
    hub pr list -s all -h google:prr/$USER/$branch -f '%pC%>(8)%i%Creset [%pS]'
    echo
  done
}

function s() {
  selected=$(gb_ | grep -v '^\*' | cut -c3- | grep -v 'heads/' | grep -v 'prr/' | fzf -1 --reverse --tac --height=20 --min-height=1 --ansi -m | cut -d' ' -f1)
  git checkout $selected
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
