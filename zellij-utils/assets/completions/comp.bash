function __zellij_complete_sessions () {
  zellij list-sessions --short --no-formatting 2>/dev/null
}

function __zellij_has_session_subcommand () {
  if [ "${COMP_CWORD}" -lt 2 ]; then
    return 1
  fi

  local word
  for word in "${COMP_WORDS[@]:1:${COMP_CWORD}}"; do
    case "${word}" in
      attach|a|kill-session|k|watch|w|delete-session|d)
        return 0
        ;;
    esac
  done
  return 1
}

function __zellij_is_setup_generate_completion_value () {
  if [ "${COMP_CWORD}" -lt 2 ]; then
    return 1
  fi

  if [ "${COMP_WORDS[COMP_CWORD-1]}" != "--generate-completion" ]; then
    return 1
  fi

  local word
  for word in "${COMP_WORDS[@]:1:${COMP_CWORD}}"; do
    if [ "${word}" = "setup" ]; then
      return 0
    fi
  done

  return 1
}

function _zellij () {
  local cur
  local sessions
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=()

  if __zellij_is_setup_generate_completion_value; then
    COMPREPLY=($(compgen -W "bash elvish fish zsh powershell" -- "${cur}"))
    return 0
  fi

  if ! __zellij_has_session_subcommand; then
    return 0
  fi

  sessions="$(__zellij_complete_sessions)"
  COMPREPLY=($(compgen -W "${sessions}" -- "${cur}"))
}

complete -F _zellij zellij

function zr () { zellij run --name "$*" -- bash -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- bash -ic "$*";}
function zri () { zellij run --name "$*" --in-place -- bash -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}
function zei () { zellij edit --in-place "$*";}
function zpipe () {
  if [ -z "$1" ]; then
    zellij pipe;
  else
    zellij pipe -p $1;
  fi
}
