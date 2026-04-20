---
profile: 02-first-time-contributor
version: 0.1.0
requires_refs:
  - "02"
  - "06#pre-pr-ritual"
  - "08#anti-patterns"
  - "10"
  - "14"
requires_skills:
  - superpowers:brainstorming
  - create-branch
  - commit
  - pr-writer
  - create-pr
  - superpowers:requesting-code-review
---

# Playbook 02 — First-Time Contributor

**When:** non-trivial change + never merged to this repo before.
**Time budget:** 30-45 min ritual + implementation time.
**Goal:** first PR that matches maintainer expectations; build trust for future work.

## Pre-ritual (do before writing any code)

### Step 1 — Load refs

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 06#pre-pr-ritual
```

Follow the 10-step pre-PR ritual with G/Y/R scoring. If ≥2 reds, STOP and open an
issue first instead of a PR.

### Step 2 — Author profile

Is the maintainer profiled in ref 14? If yes:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 14#<maintainer-slug>
```

If not profiled: build a quick profile by sampling last 3 merged PRs + maintainer's
last blog/tweet if available. 5 min max.

### Step 3 — CONTRIBUTING + CODE_OF_CONDUCT

Read fully, not skim. Note: issue-first required? CLA required? Conventional Commits
enforced? Branch naming convention? DCO? Test requirements?

Record findings in memory:

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<repo> "$(jq -n --arg p '02-first-time-contributor' --arg ts "$(date -u +%FT%TZ)" --arg cla "<yes|no>" --arg dco "<yes|no>" '{profile:$p, ts:$ts, cla:$cla, dco:$dco}')"
```

### Step 4 — Issue-first (unless CONTRIBUTING explicitly waives)

Load templates:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 10#issue-body-templates
```

Invoke `github-issue-creator` or `issues` skill. Wait for maintainer engagement
before PR unless you're 100% sure of direction.

## PR flow

### Step 5 — Brainstorm the approach

Invoke `superpowers:brainstorming` to scope the change. Surface alternatives.
Check `05#roadmap-alignment` (ref 05, if loaded) for any explicit non-goals.

### Step 6 — Create branch

Invoke `create-branch`. Branch name format: match existing convention in recent
merged PRs (common: `fix/<short-desc>`, `feat/<short-desc>`).

### Step 7 — Implement + commit

For each atomic change: invoke `commit` with Conventional Commits, DCO sign-off if
required. Keep PRs < 400 LOC (see ref 02).

### Step 8 — Write PR body

Load templates:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 10#pr-body-templates
```

Invoke `pr-writer`. Body MUST include: problem, approach, test plan, linked issue.

### Step 9 — Open PR

Invoke `create-pr`. Mark as draft if large or if you want preview feedback.

### Step 10 — Record outcome

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh open_prs <owner>/<repo>#<N> "$(jq -n --arg url "<pr-url>" --arg ts "$(date -u +%FT%TZ)" '{url:$url, opened_ts:$ts}')"
```

## After PR

### Step 11 — Review response

When review lands: invoke `superpowers:receiving-code-review`. Use fixup commits,
not amend+force on shared branches. See ref 02#commit-discipline.

### Step 12 — Update memory on merge/close

On merge or close, update `state/repos.json` with outcome (merged/rejected/stale)
for future profile picking (profile 03-known-repo-contributor).

## Anti-patterns to avoid

Load:

```bash
bash ~/.claude/skills/repo-craft/lib/load-ref.sh 08#anti-patterns
```

Do not: status-bump, @-mention across weekends, reopen closed PRs, lecture
maintainers, submit unsolicited rewrites, drive-by LGTM, litigate CoC.
