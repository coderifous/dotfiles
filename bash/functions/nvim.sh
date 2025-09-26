# Neovim with theme control
# Usage: nvim --light [files...]  for light theme
#        nvim [files...]           for dark theme (default)

nvim() {
  if [[ "$1" == "--light" ]]; then
    shift
    VIM_THEME=light command nvim "$@"
  else
    VIM_THEME=dark command nvim "$@"
  fi
}