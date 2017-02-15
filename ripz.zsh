#!env zsh

(( $+commands[rg] )) || exit

function _ripz_find() {
  echo $(alias | tail -r | rg --max-count 1 --no-line-number ".*='{0,1}${1//\\/}'{0,1}")
}

function _ripz_prexec() {
  [[ -n $(alias $@) ]] && return
  expand=$(alias -m $1 | cut -d"'" -f2)
  result=$(_ripz_find $expand ${@[2,-1]})
  [[ -n $result ]] && echo ${RIPZ_TEXT:-'Ripz:'} $result | cut -d'=' -f1
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _ripz_prexec
