# Source interactive helper functions.

if ! is_interactive; then
  return
fi

for helper in "$HOME/dotfiles/bash/functions"/*.sh; do
  [[ -r "$helper" ]] && source "$helper"
done
