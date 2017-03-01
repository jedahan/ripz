#!env zsh

(( $+commands[rg] )) || exit
[[ `uname` == Darwin ]] && _ripz_tail_options="-r"

function _ripz_find() {
  echo $(alias | tail $_ripz_tail_options | rg --max-count 1 --no-line-number ".*='{0,1}${1//\\/}'{0,1}")
}

function _ripz_prexec() {
  [[ -n $(alias $@) ]] && return
  local expanded=$(alias -m $1 | cut -d'=' -f2 | cut -d"'" -f2)
  [[ -z $expanded ]] && local result=$(_ripz_find $@) || local result=$(_ripz_find $expanded ${@[2,-1]})
  [[ -n $result ]] && echo ${RIPZ_TEXT:-'Ripz:'} $result | cut -d'=' -f1
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _ripz_prexec
