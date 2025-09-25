# Core shell options and defaults.

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize
shopt -s histappend

export PAGER="less"
export EDITOR="nvim"

set -o emacs

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
export HISTCONTROL=erasedups
export HISTSIZE=10000

if [[ -z ${USER:-} && -n ${USERNAME:-} ]]; then
  USER=$USERNAME
fi
