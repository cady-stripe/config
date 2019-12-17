alias gb='git for-each-ref --sort=committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'''
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
return_git_status_files() {
    LBUFFER="${LBUFFER}$(git status -s | fzf -1 --reverse --tac --height=20 --min-height=1 --ansi -m | cut -c4- | sed 's/ -> / /' | tr '\r\n' ' ')"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}
zle     -N   return_git_status_files
bindkey '^S' return_git_status_files
