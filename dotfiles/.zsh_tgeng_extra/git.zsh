alias gb='git for-each-ref --sort=committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'''
alias gc='git commit -v'
alias gco='git checkout'
alias gporm='git push origin HEAD:refs/for/master'
alias gpr='git pull --rebase'
alias gs='git status'
alias gsu='git submodule update --init --recursive'
_gcb() {
  [ -n "$1"  ] && git checkout -b $1 && git branch --set-upstream-to origin/master || echo "You must provide a unique branch name."
}
alias gcb=_gcb
