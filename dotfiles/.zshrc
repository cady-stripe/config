if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
source ~/.bash_profile
source ~/.bashrc
export PATH="$HOME/bin:$PATH"
export TERM="xterm-256color"

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
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

export EDITOR=vim

# =============================================================================
# zplug
# =============================================================================
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH=$HOME/.idris2/bin:$HOME/go/bin:$HOME/dev/sbt/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.idris2/lib:$LD_LIBRARY_PATH
source ~/.zplug/init.zsh

zplug "arzzen/calc.plugin.zsh", defer:2
zplug "Tarrasch/zsh-bd"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
bindkey "^f" forward-word
bindkey "^b" backward-word
zplug "zsh-users/zsh-completions"
#zplug "jimhester/per-directory-history", defer:1
zplug "plugins/dirhistory", from:oh-my-zsh
zplug "plugins/dirpersist", from:oh-my-zsh
zplug "plugins/encode64", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
# zplug "plugins/fasd", from:oh-my-zsh, defer:2
zplug "plugins/git-extra", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/urltools", from:oh-my-zsh
zplug "Aloxaf/fzf-tab"
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "romkatv/powerlevel10k", as:theme

# POWERLEVEL9K_CUSTOM_HG_COMMIT='prompt_hg_commit'
# POWERLEVEL9K_CUSTOM_HG_COMMIT_FOREGROUND='227'
# POWERLEVEL9K_CUSTOM_HG_COMMIT_BACKGROUND='27'
# POWERLEVEL9K_CUSTOM_HG_COMMENT='prompt_hg_comment'
# POWERLEVEL9K_CUSTOM_HG_COMMENT_FOREGROUND='248'
# POWERLEVEL9K_CUSTOM_HG_COMMENT_BACKGROUND='234'

zplug "gradle/gradle-completion"

zplug "~/.zsh_tgeng_extra", from:local, use:"*.zsh", defer:1
zplug "~/.zsh_tgeng_extra", from:local, use:"delayed/*", defer:3

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Somehow this alias in calc plugin does not work without repeating it here.
aliases[=]='noglob __calc_plugin'

zplug load

# if type "nvim" > /dev/null ; then
  # alias vim=nvim
# fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google/home/tgeng/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/google/home/tgeng/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google/home/tgeng/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/google/home/tgeng/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

zstyle ':completion:*' accept-exact false
setopt menu_complete
unsetopt correct
set -o rmstarsilent
bindkey -M menuselect '^M' .accept-line

# ==================== Android Studio ===================
# JAVA_HOME=/usr/local/google/home/tgeng/dev/studio-master-dev/prebuilts/studio/jdk/linux
# export PATH=$JAVA_HOME:$PATH
# somehow
#
# autoload -U +X compinit && compinit
# autoload -U +X bashcompinit && bashcompinit
# source ~/dev/zsh-completion/android-completion/repo
#
fpath=($HOME/.zplug/repos/gradle/gradle-completion $fpath)

# PATH=$HOME/dev/cmake-master-dev/prebuilts/ninja/linux-x86:$(echo "$PATH" | sed -e 's|:/google/data/ro/[^:]*||g')
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/usr/local/google/home/tgeng/.sdkman"
[[ -s "/usr/local/google/home/tgeng/.sdkman/bin/sdkman-init.sh" ]] && source "/usr/local/google/home/tgeng/.sdkman/bin/sdkman-init.sh"

if [ -n "$TMUX" ]; then
  - > /dev/null
fi

# export ANDROID_HOME=/usr/local/google/home/tgeng/Android/Sdk/
# export ANDROID_SDK_ROOT=/usr/local/google/home/tgeng/Android/Sdk/

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.tgeng_config/p10k.zsh

alias b=/Users/cady/stripe/uppsala/bazel
