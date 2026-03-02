function __zellij_complete_sessions () {
  zellij list-sessions --short --no-formatting 2>/dev/null
}

function __zellij_has_session_subcommand () {
  local i word
  for (( i = 2; i <= CURRENT; i++ )); do
    word="${words[i]}"
    case "${word}" in
      attach|a|kill-session|k|watch|w|delete-session|d)
        return 0
        ;;
    esac
  done
  return 1
}

function __zellij_is_setup_generate_completion_value () {
  (( CURRENT > 1 )) || return 1
  [[ "${words[CURRENT-1]}" == "--generate-completion" ]] || return 1
  local i
  for (( i = 2; i <= CURRENT; i++ )); do
    [[ "${words[i]}" == "setup" ]] && return 0
  done
  return 1
}

function _zellij () {
  local -a sessions

  if __zellij_is_setup_generate_completion_value; then
    compadd -- bash elvish fish zsh powershell
    return 0
  fi

  if __zellij_has_session_subcommand; then
    sessions=("${(@f)$(__zellij_complete_sessions)}")
    (( ${#sessions[@]} )) && compadd -- "${sessions[@]}"
  fi
}

if (( $+functions[compdef] )); then
  compdef _zellij zellij
fi

function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function zri () { zellij run --name "$*" --in-place -- zsh -ic "$*";}
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
