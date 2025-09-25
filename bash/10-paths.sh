# Path configuration and package-manager setup.

path_prepend "$HOME/bin"
path_append "$HOME/dotfiles/bin"
path_prepend "$HOME/.local/bin"

# Ensure common Homebrew locations are searchable before invoking brew.
path_prepend "/opt/homebrew/bin"
path_append "/opt/homebrew/sbin"
path_prepend "/usr/local/bin"
path_append "/usr/local/sbin"

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)" 2>/dev/null
fi
