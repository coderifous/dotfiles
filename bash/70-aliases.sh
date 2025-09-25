# Load aliases for interactive shells.

if ! is_interactive; then
  return
fi

source_if_exists "$HOME/.bash_aliases"
