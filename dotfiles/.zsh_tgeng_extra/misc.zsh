## Load smart urls if available
# bracketed-paste-magic is known buggy in zsh 5.1.1 (only), so skip it there; see #4434
autoload -Uz is-at-least
if [[ $ZSH_VERSION != 5.1.1 ]]; then
  for d in $fpath; do
  	if [[ -e "$d/url-quote-magic" ]]; then
  		if is-at-least 5.1; then
  			autoload -Uz bracketed-paste-magic
  			zle -N bracketed-paste bracketed-paste-magic
  		fi
  		autoload -Uz url-quote-magic
  		zle -N self-insert url-quote-magic
      break
  	fi
  done
fi

## jobs
setopt long_list_jobs

## pager
env_default PAGER 'less'
env_default LESS '-R'

## super user alias
alias _='sudo'
alias please='sudo'

## more intelligent acking for ubuntu users
if which ack-grep &> /dev/null; then
  alias afind='ack-grep -il'
else
  alias afind='ack -il'
fi

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
	export LC_CTYPE=${LANG%%:*} # pick the first entry from LANG
fi

# recognize comments
setopt interactivecomments
alias locs='ls | xargs -I % sh -c "echo %; loc %; echo"'

function foreachdo() {
  cmd=$(echo $@)
  xargs -I % sh -c "echo %; "$cmd"; echo"
}

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

alias aga='ag --hidden -a'
alias cpb='xclip -selection clipboard'
