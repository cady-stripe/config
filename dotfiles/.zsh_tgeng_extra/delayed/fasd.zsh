if [ $commands[fasd] ]; then # check if fasd is installed
  fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"
  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init auto >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cache

  z_() {
    local dir
    local candidates
    candidates=$(fasd -Rdl "$1"| sed "s|$PWD/||")
    if [[ -n $candidates ]]; then
      if [[ $(wc -l <<< $candidates) = 1 ]]; then
        cd $candidates
      else
        dir="$(echo $candidates | fzy)" && cd "${dir}" || return 1
      fi
    fi
  }

  alias zz=z_

  f_() {
    local file
    local candidates
    candidates=$(fasd -Rfl "$2"| sed "s|$PWD/||")
    if [[ -n $candidates ]]; then
      if [[ $(wc -l <<< $candidates) = 1 ]]; then
        $1 $candidates
      else
        file="$(echo $candidates | fzy)" && $1 "${file}" || return 1
      fi
    fi
  }

  alias v='f_ vim'
  alias gv='NVIM_GTK_NO_HEADERBAR=1 f_ nvim-gtk'
  alias t='f_ cdt_'
fi
