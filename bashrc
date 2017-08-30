## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

############################################################
## PATH
############################################################

if [ -d ~/bin ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

if [ -d /usr/local/bin ] ; then
  PATH="/usr/local/bin:${PATH}"
fi

if [ -d /usr/local/sbin ] ; then
  PATH="${PATH}:/usr/local/sbin"
fi

# rbenv
if [ `which rbenv 2> /dev/null` ]; then
  eval "$(rbenv init -)"
fi

# Node Package Manager
if [ -d /usr/local/share/npm/bin ] ; then
  NODE_PATH="/usr/local/lib/node"
  PATH="${PATH}:/usr/local/share/npm/bin"
fi

# MySql
if [ -d /usr/local/mysql/bin ] ; then
  PATH="${PATH}:/usr/local/mysql/bin"
fi

PATH=./bin:${PATH}
PATH=.:${PATH}

############################################################
## MANPATH
############################################################

if [ -d /usr/local/man ] ; then
  MANPATH="/usr/local/man:${MANPATH}"
fi

############################################################
## RVM
############################################################

# if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

############################################################
## Terminal behavior
############################################################

# Change the window title of X terminals
case $TERM in
  xterm*|rxvt|Eterm|eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
  screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac

# Show the git branch and dirty state in the prompt.
# Borrowed from: http://henrik.nyh.se/2008/12/git-dirty-prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\(\1$(parse_git_dirty)\)/"
}

if [ `which git` ]; then
  function git_prompt {
    parse_git_branch
  }
else
  function git_prompt {
    echo ""
  }
fi

if [ `which rvm-prompt` ]; then
  function rvm_prompt {
    echo "($(rvm-prompt v g))"
  }
else
  function rvm_prompt {
    echo ""
  }
fi

# Do not set PS1 for dumb terminals
if [ "$TERM" != 'dumb' ] && [ -n "$BASH" ]; then
  # export PS1='\[\033[32m\]\n[\s: \w] $(rvm_prompt) $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
  export PS1='\[\033[32m\]\n[\s: \w] $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
fi

############################################################
## Optional shell behavior
############################################################

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export PAGER="less"
export EDITOR="vim"

############################################################
## History
############################################################

# When you exit a shell, the history from that session is appended to
# ~/.bash_history.  Without this, you might very well lose the history of entire
# sessions (weird that this is not enabled by default).
shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
# remove duplicates from the history (when a new item is added)
export HISTCONTROL=erasedups
# increase the default size from only 1,000 items
export HISTSIZE=10000

############################################################
## Bash Completion, if available
############################################################

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
elif  [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif  [ -f /etc/profile.d/bash_completion ]; then
  . /etc/profile.d/bash_completion
fi

# http://onrails.org/articles/2006/11/17/rake-command-completion-using-rake
if [ -f ~/bin/rake_completion ]; then
  complete -C ~/bin/rake_completion -o default rake
fi

if [ -f ~/bin/thor_completion ]; then
  . ~/bin/thor_completion
fi

if [ -f ~/bin/git_completion ]; then
  . ~/bin/git_completion
fi

function _ssh_completion() {
  perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}
complete -W "$(_ssh_completion)" ssh

# if [ -f ~/.rbenv/completions/rbenv.bash ]; then
#   . ~/.rbenv/completions/rbenv.bash
# fi

############################################################
## Other
############################################################

source /usr/local/etc/bash_completion.d/cdargs-bash.sh

if [[ "$USER" == '' ]]; then
  # mainly for cygwin terminals. set USER env var if not already set
  USER=$USERNAME
fi

############################################################
## Aliases
############################################################

if [ -e ~/.bash_aliases ] ; then
  . ~/.bash_aliases
fi

############################################################

set -o emacs

function git_remote_branch_report {
  if [ $1 ]; then
    for k in `git branch -r | sed "s/ ->.*//"`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"`\\t"$k";done | sort -r | grep -i $1 | column -t -s^
  else
    for k in `git branch -r | sed "s/ ->.*//"`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"`\\t"$k";done | sort -r | column -t -s^
  fi
}

function git_remote_branch_kill_by_author {
  if [ $1 ]; then
    read -r -d '' RUBY <<-'EOS'
      $remove_remaining = false
      $commands = []

      def remove(remote_ref)
        $commands << "git push origin :#{remote_ref}"
      end

      puts "Reading branches for #{ARGV[0]}..."
      lines = %x(for k in `git branch -r | sed "s/ ->.*//"`; do echo `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"` "$k"; done | sort -r | grep -i #{ARGV[0]}).split("\n")
      puts "Got #{lines.size} refs.\n"

      lines.each do |l|
        parts = l.split(/\s*\^\s*/)
        remote_ref = parts[-1].gsub(/origin\//, '')
        print parts.join("  ")
        if $remove_remaining
          puts
          remove remote_ref
        else
          print "   Remove? (y/n/a): "
          input = STDIN.gets.chomp
          if input == "a"
            puts "Removing remaining!"
            $remove_remaining = true
            remove(remote_ref)
          elsif input == "y"
            remove(remote_ref)
          end
        end
      end

      puts "Please wait while the branches are deleted..."
      $commands.each { |c| puts c; system(c) }
      puts "Done."
EOS
    echo "$RUBY" > /tmp/_grbkba.rb
    ruby /tmp/_grbkba.rb $1
  else
    echo Must provide name of author to grep on.
  fi
}

function pairwith {
  other="$*"
  if [ "$other" ]; then
    if [ "$other" == "self" ]; then
      unset GIT_AUTHOR_NAME
      echo Pairing with self... ಠ_ಠ
    else
      if [[ $other =~ , ]]; then
        other="$other,"
      fi
      export GIT_AUTHOR_NAME="$other & Garvin"
      echo $other > ~/.last_pairwith
      echo Committing as ${GIT_AUTHOR_NAME}
    fi
  else
    other=$(cat ~/.last_pairwith)
    export GIT_AUTHOR_NAME="${other} & Garvin"
    echo Committing as ${GIT_AUTHOR_NAME}
  fi
}

# kill by name - from Matt Swasey
function gkill () {
  pname=$1
  formatted_pname="[${pname:0:1}]${pname:1}"
  kill -9 $(ps aux | grep $formatted_pname | awk '{print $2}')
}
