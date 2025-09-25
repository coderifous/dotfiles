# Bash completions and related helpers.

if ! is_interactive; then
  return
fi

for candidate in \
  /opt/local/etc/bash_completion \
  /etc/bash_completion \
  /etc/profile.d/bash_completion \
  /usr/local/etc/profile.d/bash_completion.sh \
  /usr/local/etc/bash_completion; do
  if [[ -r "$candidate" ]]; then
    source "$candidate"
    break
  fi
done

source_if_exists "$HOME/bin/rake_completion"
source_if_exists "$HOME/bin/thor_completion"
source_if_exists "$HOME/bin/git_completion"
source_if_exists "$HOME/dotfiles/tmuxinator.bash"

if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  source_if_exists "$HOMEBREW_PREFIX/etc/bash_completion.d/cdargs-bash.sh"
fi

_ssh_completion() {
  [[ -r "$HOME/.ssh/config" ]] || return
  perl -ne 'print "$1 " if /^Host (.+)$/' "$HOME/.ssh/config"
}
complete -W "$(_ssh_completion)" ssh
