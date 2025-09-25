############################################################
## Base configuration loader
############################################################

[[ -r /etc/bashrc ]] && source /etc/bashrc

if [[ -d "$HOME/dotfiles/bash" ]]; then
  for config in "$HOME/dotfiles/bash"/*.sh; do
    [[ -r "$config" ]] || continue
    source "$config"
  done
fi
