# Language runtimes and project-aware helpers.

if is_interactive && command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - bash)" 2>/dev/null
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)" 2>/dev/null
fi

export NVM_DIR="$HOME/.nvm"
source_if_exists "$NVM_DIR/nvm.sh"
source_if_exists "$NVM_DIR/bash_completion"

if is_macos && command -v arch >/dev/null 2>&1; then
  if [[ $(arch) == "arm64" ]]; then
    path_append "/usr/local/Homebrew/bin"
    path_append "/usr/local/Homebrew/sbin"
  fi
fi

alias ibrew='arch --x86_64 /usr/local/Homebrew/bin/brew'
