# Helper functions shared by bash configuration fragments.

is_macos() {
  [[ ${OSTYPE:-} == darwin* ]]
}

is_interactive() {
  [[ $- == *i* ]]
}

source_if_exists() {
  local target="$1"
  [[ -r "$target" ]] && source "$target"
}

# Adds a directory to PATH if it exists and is not already present.
path_prepend() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  case ":$PATH:" in
    *:"$dir":*) ;; # already on PATH
    *) PATH="$dir${PATH:+:$PATH}" ;;
  esac
}

path_append() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  case ":$PATH:" in
    *:"$dir":*) ;; # already on PATH
    *) PATH="${PATH:+$PATH:}$dir" ;;
  esac
}
