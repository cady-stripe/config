alias gb='git for-each-ref --sort=committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'''
alias gs='git status'
alias gsu='git submodule update --init --recursive'
alias grs='git rebase --skip'
alias grc='git rebase --continue'

z_() {
  local dir
  local candidates
  candidates=$(fasd -Rdl "$1")
  if [[ -n $candidates ]]; then
    if [[ $(wc -l <<< $candidates) = 1 ]]; then
      cd $candidates
    else
      dir="$(echo $candidates | fzy)" && cd "${dir}" || return 1
    fi
  fi
}

alias zz=z_

v_() {
  local file
  local candidates
  candidates=$(fasd -Rfl "$1")
  if [[ -n $candidates ]]; then
    if [[ $(wc -l <<< $candidates) = 1 ]]; then
      vim $candidates
    else
      file="$(echo $candidates | fzy)" && vim "${file}" || return 1
    fi
  fi
}

alias v=v_
