# Prompt and terminal presentation.

if ! is_interactive; then
  return
fi

_git_branch() {
  git symbolic-ref --quiet --short HEAD 2>/dev/null || \
    git rev-parse --short HEAD 2>/dev/null
}

_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null || echo '*'
}

__bash_prompt() {
  local exit_code=$?

  case ${TERM:-} in
    xterm*|rxvt|Eterm|eterm)
      printf '\033]0;%s@%s:%s\007' "$USER" "${HOSTNAME%%.*}" "${PWD/$HOME/~}"
      ;;
    screen*)
      printf '\033_%s@%s:%s\033\\' "$USER" "${HOSTNAME%%.*}" "${PWD/$HOME/~}"
      ;;
  esac

  local git_segment=""
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch=$(_git_branch)
    if [[ -n $branch ]]; then
      git_segment=" (${branch}$(_git_dirty))"
    fi
  fi

  PS1="\[\033[32m\]\n[\s: \w]${git_segment}\n\[\033[31m\][\u@\h]\$ \[\033[00m\]"
  return $exit_code
}

PROMPT_COMMAND=__bash_prompt
