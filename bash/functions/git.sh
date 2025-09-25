# Git-focused helper functions.

command -v git >/dev/null 2>&1 || return

git_main_branch() {
  git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null \
    | sed 's@^refs/remotes/origin/@@' \
    || echo main
}

gu() {
  local branch=${1:-$(git_main_branch)}
  [[ $branch == */* ]] || branch="origin/$branch"
  local cmd=(git cherry -v "$branch")
  printf '%s ' "${cmd[@]}"
  printf '\n'
  "${cmd[@]}"
}

gco() {
  if [[ -n $1 ]]; then
    git checkout "$@"
    return
  fi

  if command -v fzf >/dev/null 2>&1; then
    local branch
    branch=$(git branch --all --format='%(refname:short)' | sort -u | fzf --exit-0)
    [[ -n $branch ]] || return 1
    git checkout "$branch"
  else
    echo "gco: provide a branch name or install fzf for interactive selection" >&2
    return 1
  fi
}

st() {
  if [[ -d .svn ]]; then
    svn status "$@"
  else
    git status "$@"
  fi
}

glrb() {
  git fetch && git rebase "origin/$(git_main_branch)"
}

gup() {
  git stash && git pull --rebase && git stash pop
}

gupb() {
  git stash && git fetch && git rebase "origin/$(git_main_branch)" && git stash pop
}
