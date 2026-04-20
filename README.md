# repo-craft

**A Claude Code skill that orchestrates GitHub repo management and contribution workflows.** Turns any repo-related intent — your own repo or someone else's — into the right flow, executed by the right existing skills, with just enough ritual for the stakes.

> `repo-craft` is an **orchestrator**, not an absorber. It invokes atomic skills (`commit`, `create-pr`, `pr-writer`, `github-issue-creator`, `superpowers:brainstorming`, etc.) at the right moments — it never duplicates their logic.

## What it does

- **Context-aware routing** — sniffs `own-repo` vs `fork` vs `someone-elses-repo` vs `off-repo` and picks one of 12 named profiles.
- **Productivity-first defaults** — single-prompt-per-phase, anti-saturation, decision-on-demand.
- **Token-light references** — 13 instrumented reference files (~400 KB raw) loaded on demand via bash awk-based H2 section extractor. A typical flow loads under 20k tokens.
- **Safety gates** — hard stops on `git push --force`, `git reset --hard`, `gh pr merge`, and any action that signs/submits a CLA on the user's behalf.
- **Graceful degradation** — works file-only if `gh` CLI is absent.
- **Local memory** — JSON state at `state/repos.json` and `state/preferences.json` for remembered repo/profile touches.
- **Zero-residue uninstall** — `rm -rf ~/.claude/skills/repo-craft/` leaves no trace. No hooks, no MCP servers, no edits to `settings.json`.

## Activation

- **Conversational** — mentions of *contribute to, fork, upstream, repo health, author fit, release strategy, maintainer, CODEOWNERS, changelog, semver, governance, RFC, repo security*, etc.
- **Explicit** — `/repo-craft`, `/repo-craft help`, `/repo-craft <profile>`, `/repo-craft quick`, `/repo-craft deep`

## Profiles (12 total; 4 active in v0.1)

| # | Profile | Status |
|---|---------|--------|
| 01 | drive-by-fix | v0.2 |
| 02 | first-time-contributor | ✅ v0.1 |
| 03 | known-repo-contributor | v0.2 |
| 04 | feature-proposal | v0.2 |
| 05 | rfc-author | v0.3 |
| 06 | security-disclosure | v0.3 |
| 07 | fork-contribute | ✅ v0.1 |
| 08 | upstream-sync | ✅ v0.1 |
| 09 | own-repo-health-audit | ✅ v0.1 |
| 10 | own-repo-release | v0.2 |
| 11 | own-repo-setup | v0.2 |
| 12 | influence-ladder-climb | v0.3 |

## Architecture

Single Claude Code skill (not a plugin). ~300 LOC orchestrator (`SKILL.md`) that:
1. Sniffs context → one of 4 loci
2. Checks memory for prior touches on this repo
3. Picks a profile
4. Loads only the reference sections the profile needs
5. Dispatches the corresponding playbook
6. Persists outcome
7. Returns **one** next-step recommendation

```
repo-craft/
├── SKILL.md           # orchestrator (YAML auto-activation + routing)
├── lib/               # sniff, load-ref, remember, recall, common (all bash)
├── references/        # 13 instrumented refs + INDEX.md (load on demand)
├── playbooks/         # 4 profile-specific execution plans
├── state/             # local memory (runtime-only, not tracked)
├── install.sh uninstall.sh update.sh
└── e2e.sh             # install → validate → uninstall test
```

## Install

**Prerequisites:** `bash`, `git`, `jq`, `awk`, `sed`. `gh` CLI is optional (without it, API-driven flows degrade to file-only).

```bash
git clone https://github.com/dmmdea/repo-craft.git
cd repo-craft
bash install.sh
```

Installs to `~/.claude/skills/repo-craft/`. Idempotent. Preserves existing `state/` on re-install.

## Verify

```bash
bash e2e.sh   # install → validate → uninstall, all from scratch
```

Expected: `ALL E2E TESTS PASSED`.

In a Claude Code session:

```
/repo-craft help
```

## Uninstall

```bash
bash ~/.claude/skills/repo-craft/uninstall.sh --yes
```

Zero residue. `state/` can be preserved with `--keep-state`.

## What it does NOT do

- Write code for you
- Replace `git` or `gh`
- Duplicate atomic skills (commit, create-pr, etc. — those are invoked, never absorbed)
- Sync to any cloud
- Install globally or edit shared config

## Status

**v0.1.0** — first usable release. 4 of 12 profiles active; the rest route to "not yet implemented — see CHANGELOG".

## License

MIT. See [LICENSE](./LICENSE).
