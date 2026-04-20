#!/usr/bin/env bash
# sniff.sh — detect repo context and print JSON to stdout
# Usage: lib/sniff.sh [path]
# Output fields: locus, remote_url, default_branch, in_fork, has_gh
set -euo pipefail

PATH_ARG="${1:-$(pwd)}"
cd "$PATH_ARG" 2>/dev/null || { echo '{"locus":"off-repo","error":"path not accessible"}'; exit 0; }

# Detect git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo '{"locus":"off-repo","remote_url":null,"in_fork":false,"has_gh":false}'
  exit 0
fi

# Inside a git repo
remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
default_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || echo "")

# Detect fork via `gh` if available
in_fork="false"
has_gh="false"
locus="own-repo"
if command -v gh >/dev/null 2>&1; then
  has_gh="true"
  fork_info=$(gh repo view --json isFork,parent 2>/dev/null || echo "")
  if echo "$fork_info" | jq -e '.isFork == true' >/dev/null 2>&1; then
    in_fork="true"
    locus="fork"
  elif [ -n "$remote_url" ]; then
    # Has a remote but not a fork — could be own-repo or someone-else's
    # Heuristic: if we have push rights, call it own-repo; else someone-else's
    owner=$(echo "$remote_url" | sed -E 's|.*[:/]([^/]+)/[^/]+\.git$|\1|; s|.*[:/]([^/]+)/[^/]+$|\1|')
    my_login=$(gh api user --jq .login 2>/dev/null || echo "")
    if [ -n "$my_login" ] && [ "$owner" = "$my_login" ]; then
      locus="own-repo"
    else
      locus="someone-elses-repo"
    fi
  fi
fi

# Emit JSON
jq -n \
  --arg locus "$locus" \
  --arg remote_url "$remote_url" \
  --arg default_branch "$default_branch" \
  --argjson in_fork "$in_fork" \
  --argjson has_gh "$has_gh" \
  '{locus: $locus, remote_url: $remote_url, default_branch: $default_branch, in_fork: $in_fork, has_gh: $has_gh}'
