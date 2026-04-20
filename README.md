# repo-craft

Conversational and explicit-invoke orchestrator for GitHub repo management and contribution.

**What it does:** turns any repo-related intent — own-repo or someone else's — into the right flow, executed by the right existing skills, with just enough ritual for the stakes.

**Activation:**
- Conversational — mentions of *contribute to, fork, upstream, repo health, author fit, release strategy, maintainer, CODEOWNERS, changelog, semver, governance, RFC, repo security*, etc.
- Explicit — `/repo-craft`, `/repo-craft help`, `/repo-craft <profile>`, `/repo-craft quick`, `/repo-craft deep`

**Profiles (12):** drive-by-fix, first-time-contributor, known-repo-contributor, feature-proposal, rfc-author, security-disclosure, fork-contribute, upstream-sync, own-repo-health-audit, own-repo-release, own-repo-setup, influence-ladder-climb. v0.1 ships 4; the rest route to "not yet implemented".

**Install:**

```bash
bash install.sh
```

Installs to `~/.claude/skills/repo-craft/`. Idempotent. No edits to `settings.json`, no hooks, no MCP servers.

**Uninstall:**

```bash
bash ~/.claude/skills/repo-craft/uninstall.sh
```

Removes everything. Zero residue.

**Does NOT:** write code, replace `git`/`gh`, duplicate atomic skills (`commit`, `create-pr`, etc. — those are invoked, never absorbed), sync to any cloud, install itself globally.

**Design spec:** `D:/My Drive/AI Ecosystem/Skill and Gem Creation/Audits/repo-craft/2026-04-20-repo-craft-design-v2.md`
**License:** MIT
