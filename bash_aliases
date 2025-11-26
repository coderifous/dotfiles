# Adds an alias to the current shell and to this file.
# Borrowed from Mislav (http://github.com/mislav/dotfiles/tree/master/bash_aliases)
add-alias ()
{
   local name=$1 value=$2
   echo "alias $name='$value'" >> ~/.bash_aliases
   eval "alias $name='$value'"
   alias $name
}

############################################################
## Listing
############################################################

if [[ `uname` == 'Darwin' ]]; then
  alias ls="ls -G"
  export LSCOLORS=gxfxcxdxbxegedabagacad
else
  alias ls="ls --color=auto"
  export LS_COLORS='no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;31:'
fi

alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lal="ls -al"

############################################################
## Git
############################################################

alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias amend="git commit --amend"
alias gd="git diff --word-diff"
alias gl="git pull"
alias gp="git push"
alias gs="git status; echo; echo Skipped:; echo; git skipped"
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gst="git stash"
alias gstp="git stash pop"
alias ts="tig status"
alias gsui="git submodule update --init"
alias gsur="git submodule update --remote"
alias grb="git rebase "
alias gri="git rebase -i "
alias gmo="git merge origin/main"
alias gcs="gh copilot suggest"

############################################################
## Bundler & Ruby
############################################################

alias b="bundle"
alias bu="b update"
alias be="b exec"
alias bi="b install"
alias bil='bi --local'
alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"
alias bo="EDITOR=nvim b open"
alias r="rake"
alias s="spring"
alias irb="echo Don\\'t you really want pry? or type irbirb."
alias irbirb="\\irb"
alias ws="rbenv shell 2.7.5 && working_set"

############################################################
## Rails
############################################################

alias rc="bin/rails console"
alias rs="bin/rails server"
alias rdbm="bin/rails db:migrate"
alias rgm='bin/rails generate model'
alias tl='tail -f log/development.log'
alias rtags='ctags -e -R app lib vendor tasks'

############################################################
## macOS & networking
############################################################

alias dstore-clean='find . -type f -name .DS_Store -print0 | xargs -0 rm'
alias flushdns='dscacheutil -flushcache'

############################################################
## Utilities
############################################################

alias serve='python3 -m http.server'
alias grep='GREP_COLOR="1;37;41" grep --color=auto'
alias wgeto="wget -q -O -"
alias sha1="openssl dgst -sha1"
alias sha2="openssl dgst -sha256"
alias b64="openssl enc -base64"
alias top=htop
alias tmux='TERM=screen-256color tmux'
alias target='echo $TMUX | cut -f1 -d, > .tmux-target; tmux display-message -p "#{window_id}.#{pane_id}" >> .tmux-target'
alias t='target'
alias vi=nvim
if [ -n "$TMUX" ]; then
  alias clcl='clear; tmux clear-history'
else
  alias clcl='clear'
fi
alias cv="TERM=xterm-256color cdb"
