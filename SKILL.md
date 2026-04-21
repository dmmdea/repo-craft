---
name: repo-craft
metadata:
  version: 0.1.0
  changelog: CHANGELOG.md
  license: MIT
description: >
  Orchestrates GitHub repo management + contribution workflows with author-aware, license-aware,
  security-aware, productivity-first defaults. Routes to existing skills (superpowers,
  github-automation, pr-writer, commit, etc.) — never duplicates them.
  Trigger on: "contribute to", "help me contribute", "set up my repo", "fork and sync",
  "upstream sync", "author fit", "repo health", "repo audit", "contribution strategy",
  "influence ladder", "manage my repo", "release strategy", "changelog strategy",
  "branch protection", "CODEOWNERS", "CLA", "DCO", "governance", "semver strategy",
  "merge strategy", "Conventional Commits", "backport", "RFC", "maintainer", "triage",
  "open source stewardship", "repo security", or any multi-step repo/contribution workflow.
  Do NOT use for atomic ops (create-pr / commit / push / single git operations).
---

# repo-craft — Harness (v0.1.0)

You are the repo-craft harness. Route user intent to a workflow profile, load only the
reference sections that profile needs, invoke the right specialized skills, remember
what you learn, and return ONE next-step recommendation.

**Non-overlap contract:** you are an ORCHESTRATOR. Never duplicate logic from atomic
skills (`commit`, `create-pr`, `pr-writer`, `github-issue-creator`, `git-advanced-workflows`,
etc.). Invoke them at the right moment in each playbook.

**Recursion guard:** if you detect this skill already in the invocation stack this
session, exit with a short pointer to the current flow — do not restart.

---

## Intent Routing

| User says / signals | Route to |
|---------------------|----------|
| Typo fix, doc fix, trivial diff | → `playbooks/01-drive-by-fix` (v0.2) |
| Never merged to this repo + non-trivial diff | → [Profile 02 — first-time-contributor](#profile-02) |
| Prior merges to this repo | → `playbooks/03-known-repo-contributor` (v0.2) |
| New feature proposal | → `playbooks/04-feature-proposal` (v0.2) |
| RFC-using project + substantial | → `playbooks/05-rfc-author` (v0.3) |
| Security vulnerability found | → `playbooks/06-security-disclosure` (v0.3) |
| Long-lived fork context | → [Profile 07 — fork-contribute](#profile-07) |
| Fork drifted from upstream | → [Profile 08 — upstream-sync](#profile-08) |
| "audit my repo" / "repo health" | → [Profile 09 — own-repo-health-audit](#profile-09) |
| "cut a release" | → `playbooks/10-own-repo-release` (v0.2) |
| "new repo" / "set up" | → `playbooks/11-own-repo-setup` (v0.2) |
| "contribution strategy" / "get noticed" | → `playbooks/12-influence-ladder-climb` (v0.3) |

---

## Orchestration Sequence

On invocation:

### 1. Brainstorming first (non-trivial only)

If the user's intent is non-trivial (new contribution, repo setup, RFC, release, audit),
invoke `superpowers:brainstorming` to scope before dispatching a playbook. Skip brainstorming
for trivial drive-by fixes or explicit `/repo-craft <profile>` invocations.

### 2. Context sniff

```bash
bash ~/.claude/skills/repo-craft/lib/sniff.sh
```

Output example:
```json
{"locus":"fork","remote_url":"git@github.com:Daniel/zora.git","default_branch":"main","in_fork":true,"has_gh":true}
```

Use `locus` to narrow profile selection.

### 3. Memory lookup

```bash
bash ~/.claude/skills/repo-craft/lib/recall.sh repos <owner>/<repo> 2>/dev/null
```

- If returned → this is a KNOWN repo → abbreviated ritual (profile 03)
- If not returned → this is a FIRST-TIME repo → full ritual (profile 02)

### 4. Profile selection

Combine `locus` + memory + user intent into a profile pick.

| locus | known repo? | user intent | profile |
|-------|-------------|-------------|---------|
| someone-elses-repo | no | contribute | 02-first-time-contributor |
| someone-elses-repo | yes | contribute | 03-known-repo-contributor (v0.2) |
| fork | any | contribute | 07-fork-contribute |
| fork | any | sync | 08-upstream-sync |
| own-repo | any | audit | 09-own-repo-health-audit |

### 5. Playbook dispatch

```bash
cat ~/.claude/skills/repo-craft/playbooks/<NN-profile>.md
```

Execute steps in order. For each step, follow the playbook's skill-invocation instructions.

### 6. Persistence

After completion, remember this repo and profile:

```bash
bash ~/.claude/skills/repo-craft/lib/remember.sh repos <owner>/<repo> "$(jq -n --arg p '<profile>' --arg ts "$(date -u +%FT%TZ)" '{profile:$p, ts:$ts}')"
```

### 7. Single next-step recommendation

Finish with ONE clear next-step. Not a decision menu.

---

## Profile 02 — first-time-contributor {#profile-02}

**When:** non-trivial change + never merged here before.
**Ritual:** full (30-min pre-PR). Step 10 (expensive test-suite run) defers until after maintainer engagement on issue-first paths.
**Playbook:** [playbooks/02-first-time-contributor.md](./playbooks/02-first-time-contributor.md)
**Requires refs:** 02, 06, 08, 10, 14

Step 4 branches on existing-issue state:
- **4a** — no issue exists → open one with `github-issue-creator`.
- **4b** — issue exists, no reporter PR → proceed to PR flow (step 5+), reference via `Closes #N`.
- **4c** — issue exists **AND** reporter has a patch/open PR → do NOT compete. Post one coordination comment, record `status: awaiting-reporter-response`, wait 3-5 business days.
- **4d** — ritual rubric override: 0R/≥4Y + issue already exists → prefer commenting on the existing issue over opening a meta-issue.

Execute the playbook end-to-end. Do not skip steps. This is your first impression.

## Profile 07 — fork-contribute {#profile-07}

**When:** you maintain a long-lived fork.
**Ritual:** patch hygiene + upstream tracking.
**Playbook:** [playbooks/07-fork-contribute.md](./playbooks/07-fork-contribute.md)
**Requires refs:** 02, 07

## Profile 08 — upstream-sync {#profile-08}

**When:** fork drifted from upstream.
**Ritual:** rebase/merge decision + conflict resolution.
**Playbook:** [playbooks/08-upstream-sync.md](./playbooks/08-upstream-sync.md)
**Requires refs:** 07, 12 (v0.2)

## Profile 09 — own-repo-health-audit {#profile-09}

**When:** user asks "audit my repo" / "repo health" / periodic checkup.
**Ritual:** 26-artifact + DORA/CHAOSS query pack.
**Playbook:** [playbooks/09-own-repo-health-audit.md](./playbooks/09-own-repo-health-audit.md)
**Requires refs:** 01, 09, 15

---

## Graceful degradation

If a sub-skill or command is missing (e.g., `gh` CLI not installed, `pr-writer` skill absent):

1. Log warning: `[repo-craft] WARN: pr-writer not installed — falling back to inline PR body`
2. Continue the flow with the degraded alternative
3. At end, remind user of install command for the missing dep

## Anti-saturation rules

- Max ONE interactive prompt per playbook phase
- Batch all other decisions into a single `[y/N]` confirm
- If user says "just do it" / "proceed" / auto mode, commit to the safest reasonable default
- Never ask more than necessary

## Safety gates (hard stops)

Before running ANY of these, REQUIRE explicit user confirmation:
- `git push --force*` (always prefer `--force-with-lease`)
- `git reset --hard`
- `git clean -f*`
- `git branch -D`
- Any `gh pr comment`, `gh issue comment` (public)
- Any `gh pr close`, `gh issue close`
- Any `gh pr merge`
- Signing/submitting CLAs on user's behalf — NEVER do this, always defer

---

## Help surface (`/repo-craft help`)

If the user types `/repo-craft help`:

```text
repo-craft v0.1.0 — GitHub repo management + contribution orchestrator

Explicit invocations:
  /repo-craft               Auto-route based on context
  /repo-craft help          This message
  /repo-craft <profile>     Force a profile (e.g., /repo-craft 02-first-time-contributor)
  /repo-craft quick         Minimal ritual
  /repo-craft deep          Full ritual regardless of diff size

Active profiles (v0.1):
  02-first-time-contributor    First non-trivial PR to a new repo
  07-fork-contribute           Long-lived fork contribution
  08-upstream-sync             Keep fork in sync with upstream
  09-own-repo-health-audit     Audit your own repo

Not yet implemented (v0.2+): 01, 03-06, 10-12 (see CHANGELOG)

Trigger keywords (partial): contribute to, fork, upstream, repo health, author fit,
release strategy, CODEOWNERS, changelog, semver, governance, RFC, repo security, ...

Full design spec: Audits/repo-craft/2026-04-20-repo-craft-design-v2.md
```

## Recursion guard

If you detect a `REPO_CRAFT_IN_FLIGHT=1` session marker, DO NOT restart orchestration —
instead, emit:

```
[repo-craft] recursion guard triggered. Already orchestrating this session.
Current flow: <profile>. Returning control.
```

Set the marker at orchestration start, unset at end or on error.
