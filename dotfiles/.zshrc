stty -ixon -ixoff
# =============================================================================
# history
# =============================================================================
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000000
SAVEHIST=10000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward

# =============================================================================
# zplug
# =============================================================================
source ~/.zplug/init.zsh

zplug "arzzen/calc.plugin.zsh"
zplug "Tarrasch/zsh-bd"
zplug "zsh-users/zsh-syntax-highlighting", defer:2, use:zsh-syntax-highlighting.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "jimhester/per-directory-history"
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/dirhistory", from:oh-my-zsh
zplug "plugins/dirpersist", from:oh-my-zsh
zplug "plugins/encode64", from:oh-my-zsh
zplug "plugins/fasd", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-extra", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/urltools", from:oh-my-zsh
zplug "bhilburn/powerlevel9k", as:theme
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time vcs dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time)
POWERLEVEL9K_DIR_HOME_BACKGROUND="black"
POWERLEVEL9K_DIR_HOME_FOREGROUND="249"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="black"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="249"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="black"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="249"
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='26'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='15'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='88'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='15'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='166'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='15'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='black'
zplug "~/.zsh_tgeng_extra", from:local, use:"*.zsh", defer:1
zplug "~/.zsh_tgeng_extra", from:local, use:"directories.zsh", defer:3
zplug "~/.zsh_tgeng_extra", from:local, use:"git.zsh", defer:3

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
# Somehow this alias in calc plugin does not work without repeating it here.
aliases[=]='noglob __calc_plugin'
