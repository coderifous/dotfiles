# ~/.bash_profile: executed by bash for login shells.

# # This stuff is for performance tuning.
# # See more: https://mdjnewman.me/2017/10/debugging-slow-bash-startup-files/
#
# # open file descriptor 5 such that anything written to /dev/fd/5
# # is piped through ts and then to /tmp/timestamps
# exec 5> >(ts -i "%.s" >> /tmp/timestamps)
# # https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
# export BASH_XTRACEFD="5"
# # Enable tracing
# set -x

if [ -e ~/.bashrc ] ; then
  . ~/.bashrc
fi

# Put all local machine customizations in ~/.bash_local
if [ -e ~/.bash_local ] ; then
  . ~/.bash_local
fi

