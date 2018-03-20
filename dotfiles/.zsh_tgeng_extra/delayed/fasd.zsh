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
    candidates=$(fasd -Rdl "$1")
    if [[ -n $candidates ]]; then
      if [[ $(wc -l <<< $candidates) = 1 ]]; then
        cd $candidates
      else
        dir="$(echo $candidates | fzy)" && cd "${_FASD_PREFIX}${dir}" || return 1
      fi
    fi
  }

  alias z=z_

  v_() {
    local file
    local candidates
    candidates=$(fasd -Rfl "$1")
    if [[ -n $candidates ]]; then
      if [[ $(wc -l <<< $candidates) = 1 ]]; then
        vim $candidates
      else
        file="$(echo $candidates | fzy)" && vim "${_FASD_PREFIX}${file}" || return 1
      fi
    fi
  }

  alias v=v_
fi
