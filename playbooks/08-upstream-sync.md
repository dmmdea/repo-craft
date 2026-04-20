---
profile: 08-upstream-sync
version: 0.1.0
requires_refs:
  - "07#lifecycle-stability"
requires_skills:
  - git-advanced-workflows
  - commit
---

# Playbook 08 — Upstream Sync

**When:** fork has drifted from upstream; need to reconcile.
**Goal:** fork is current with upstream with minimal local disruption.

## Pre-flight

### Step 1 — Snapshot current state

```bash
git status
git log --oneline -10
git branch -vv
```

If uncommitted changes: STOP. Commit or stash before syncing.

### Step 2 — Fetch upstream

```bash
git fetch upstream
git fetch origin
```

### Step 3 — Measure drift

```bash
echo "commits ahead of upstream:"
git rev-list --count upstream/main..origin/main
echo "commits behind upstream:"
git rev-list --count origin/main..upstream/main
```

## Rebase vs merge decision

### Step 4 — Pick strategy

| Situation | Strategy |
|-----------|----------|
| Solo fork, no open PRs, <20 commits ahead | rebase (cleaner history) |
| Fork has published/open PRs on branches | merge (preserves PR commits) |
| Fork has local-only patches you want clearly separable | rebase `main` + keep `patches/*` branches on merge |
| Upstream rewrote history (unusual) | recreate fork (last resort) |

Default: **rebase** for main; **merge** for PR branches.

### Step 5a — Rebase path

```bash
git checkout main
git rebase upstream/main
# On conflict: resolve → git add → git rebase --continue
```

### Step 5b — Merge path

```bash
git checkout main
git merge upstream/main
# On conflict: resolve → git add → git commit (merge commit)
```

### Step 6 — Push fork

```bash
# Rebase path requires force-with-lease (NEVER bare --force)
git push origin main --force-with-lease

# Merge path is a regular push
git push origin main
```

## After sync

### Step 7 — Rebase any live branches

For each local branch `feat/*`, `fix/*`:

```bash
git checkout <branch>
git rebase main   # not upstream/main — rebase on now-synced local main
git push origin <branch> --force-with-lease
```

### Step 8 — Verify patches still apply (for fork-contribute users)

If you have `patches/*` branches, re-test they still apply cleanly:

```bash
git checkout patches/<name>
git rebase main
# On failure: patch may be obsolete — retire if upstream caught up
```

### Step 9 — Record sync in memory

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<repo> "$(jq -n --arg p '08-upstream-sync' --arg ts "$(date -u +%FT%TZ)" '{profile:$p, ts:$ts, last_sync:$ts}')"
```

## Conflict-resolution safety

- NEVER accept "theirs" or "ours" blindly — read both, decide
- If a conflict involves a security-sensitive file (ref 15#repo-security-baseline),
  pause and ask user
- If in doubt, merge (preserves both histories) — never destructive rebase

## Safety gate

Before `git push --force-with-lease`: confirm the branch is a personal fork, not
a shared collaboration branch. If shared: STOP and coordinate.
