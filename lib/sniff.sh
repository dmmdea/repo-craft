#!/usr/bin/env bash
# sniff.sh — detect repo context and print JSON to stdout
# Usage:
#   lib/sniff.sh                          # inspect current working directory
#   lib/sniff.sh <path>                   # inspect <path> (local repo)
#   lib/sniff.sh --target <owner>/<repo>  # inspect a remote GitHub repo (no clone needed)
# Output fields: locus, remote_url, default_branch, in_fork, has_gh [, target]
# Exit: always 0 with JSON on stdout; off-repo / errors reflected in locus.
set -euo pipefail

TARGET=""
PATH_ARG=""
if [ "${1:-}" = "--target" ] && [ -n "${2:-}" ]; then
  TARGET="$2"
elif [ -n "${1:-}" ]; then
  PATH_ARG="$1"
fi

has_gh="false"
command -v gh >/dev/null 2>&1 && has_gh="true"

if [ -n "$TARGET" ]; then
  # Remote-target mode: consult GitHub API only.
  if [ "$has_gh" != "true" ]; then
    jq -n --arg t "$TARGET" '{locus:"off-repo", remote_url:null, default_branch:null, in_fork:false, has_gh:false, target:$t, error:"gh CLI required for --target"}'
    exit 0
  fi
  meta=$(gh repo view "$TARGET" --json owner,name,isFork,parent,defaultBranchRef,url 2>/dev/null || echo "")
  if [ -z "$meta" ]; then
    jq -n --arg t "$TARGET" '{locus:"off-repo", remote_url:null, default_branch:null, in_fork:false, has_gh:true, target:$t, error:"gh repo view failed"}'
    exit 0
  fi
  my_login=$(gh api user --jq .login 2>/dev/null || echo "")
  owner=$(echo "$meta" | jq -r '.owner.login')
  is_fork=$(echo "$meta" | jq -r '.isFork')
  remote_url=$(echo "$meta" | jq -r '.url')
  default_branch=$(echo "$meta" | jq -r '.defaultBranchRef.name // ""')
  if [ "$is_fork" = "true" ] && [ "$owner" = "$my_login" ]; then
    locus="fork"
  elif [ "$owner" = "$my_login" ]; then
    locus="own-repo"
  else
    locus="someone-elses-repo"
  fi
  jq -n \
    --arg locus "$locus" \
    --arg remote_url "$remote_url" \
    --arg default_branch "$default_branch" \
    --argjson in_fork "$is_fork" \
    --argjson has_gh true \
    --arg target "$TARGET" \
    '{locus:$locus, remote_url:$remote_url, default_branch:$default_branch, in_fork:$in_fork, has_gh:$has_gh, target:$target}'
  exit 0
fi

# Local-path mode (default).
PATH_ARG="${PATH_ARG:-$(pwd)}"
cd "$PATH_ARG" 2>/dev/null || { echo '{"locus":"off-repo","error":"path not accessible"}'; exit 0; }

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  jq -n --argjson has_gh "$has_gh" '{locus:"off-repo", remote_url:null, default_branch:null, in_fork:false, has_gh:$has_gh}'
  exit 0
fi

remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
default_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || echo "")

in_fork="false"
locus="own-repo"
if [ "$has_gh" = "true" ]; then
  fork_info=$(gh repo view --json isFork,parent 2>/dev/null || echo "")
  if echo "$fork_info" | jq -e '.isFork == true' >/dev/null 2>&1; then
    in_fork="true"
    locus="fork"
  elif [ -n "$remote_url" ]; then
    owner=$(echo "$remote_url" | sed -E 's|.*[:/]([^/]+)/[^/]+\.git$|\1|; s|.*[:/]([^/]+)/[^/]+$|\1|')
    my_login=$(gh api user --jq .login 2>/dev/null || echo "")
    if [ -n "$my_login" ] && [ "$owner" = "$my_login" ]; then
      locus="own-repo"
    else
      locus="someone-elses-repo"
    fi
  fi
fi

jq -n \
  --arg locus "$locus" \
  --arg remote_url "$remote_url" \
  --arg default_branch "$default_branch" \
  --argjson in_fork "$in_fork" \
  --argjson has_gh "$has_gh" \
  '{locus:$locus, remote_url:$remote_url, default_branch:$default_branch, in_fork:$in_fork, has_gh:$has_gh}'
