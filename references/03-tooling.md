> **Consult this if:** deciding which CLI tools or release automation to adopt, reviewing a dependency list for a repo, or evaluating new Claude Code skills to install.
>
> **Cross-refs:** [01#release-automation](./01-repo-management.md#release-automation) · [15](./15-security.md)

## Table of Contents

- [CLI and Extensions](#cli-and-extensions)
- [Git Power Tools](#git-power-tools)
- [Commit Tools](#commit-tools)
- [Release Automation](#release-automation)
- [Hooks Frameworks](#hooks-frameworks)
- [Quality Linting](#quality-linting)
- [Review Tooling](#review-tooling)
- [Fork and PR Queue](#fork-and-pr-queue)
- [Changelog](#changelog)
- [Required Tool Dependencies](#required-tool-dependencies)
- [Candidate New Claude Skills](#candidate-new-claude-skills)

---

# GitHub Repo Management Skill — Tooling & Claude Skill Gap Analysis

**Slice 03 of the GitHub-orchestration skill research.** This document inventories the CLI/toolchain dependencies the skill should recommend installing (opinionated, minimal, battle-tested), and identifies *net-new* Claude Code skills that would close real gaps beyond the 23 git/GitHub skills the user already owns.

---

## 1. Scope & Assumptions

The skill under design wraps end-to-end GitHub repo management: issue lifecycle, PR authoring and iteration, code review, release automation, merge-queue discipline, fork/upstream hygiene, and contribution analytics. The user already owns wide coverage for commit/branch/PR/issue creation and review. Tooling recommendations therefore focus on **force-multipliers at the edges** (static analysis, release automation, merge trains, changelogs, hooks) rather than core git plumbing.

Three tiers for tool verdicts:

- **RECOMMEND** — install as a hard dependency; the skill actively invokes or checks for it.
- **OPTIONAL** — the skill can detect and leverage if present, but does not require it.
- **SKIP** — niche, deprecated, redundant with better tools, or displaced by native GitHub/git features.

The ecosystem target is the user's Aorus 15P-XD primary (Windows 11 + WSL2). Installers prefer `winget`/`scoop` for native Windows, `apt`/`brew`/`cargo`/`go install` inside WSL, and `npm` for JS-native tools.

---

## CLI and Extensions

### 2.1 `gh` CLI (base)

**Verdict: RECOMMEND.** Non-negotiable. The skill should assert `gh auth status` succeeds before attempting any GitHub operation, and prefer `gh api` over raw REST calls. Install: `winget install GitHub.cli` or `brew install gh`. As of April 2026, `gh` is at 2.89.x and ships a new `gh skill` subcommand for discovering/installing Agent Skills directly from repos — worth surfacing in the skill's onboarding prompt. URL: https://cli.github.com

### 2.2 `gh-dash` (dlvhdr/gh-dash)

**Verdict: RECOMMEND.** The canonical TUI dashboard over PRs, issues, and review queues. The skill can launch `gh dash` for interactive triage when the user says "show me everything on my plate." It has been mirrored on SourceForge and broadly adopted since the 2024 HN launch — battle-tested. Install: `gh extension install dlvhdr/gh-dash`. URL: https://github.com/dlvhdr/gh-dash

### 2.3 `gh-poi` (seachicken/gh-poi)

**Verdict: RECOMMEND.** Safely deletes local branches whose PRs have merged — indispensable for squash-merge workflows where `git branch --merged` misses everything. Sole actively-maintained tool in the niche. Install: `gh extension install seachicken/gh-poi`. URL: https://github.com/seachicken/gh-poi

### 2.4 `gh-copilot` (github/gh-copilot)

**Verdict: SKIP.** Officially deprecated on 2025-10-25 in favour of the new agentic **GitHub Copilot CLI** binary; installing the extension now is a dead-end. If the user wants CLI AI assistance, they already have Claude Code. URL: https://github.blog/changelog/2025-09-25-upcoming-deprecation-of-gh-copilot-cli-extension/

### 2.5 `gh-nudge`

**Verdict: SKIP.** No canonical `gh-nudge` extension exists — the name maps to a commercial Nudge Bot GitHub App and `gh-reassign-reviewer` (ryo246912) for CLI-side re-requests. Recommend `gh-reassign-reviewer` as **OPTIONAL** instead for teams where reviewers ghost PRs. URL: https://github.com/ryo246912/gh-reassign-reviewer

### 2.6 `gh-pr-sync`

**Verdict: SKIP.** No widely-adopted extension with this name. Native `gh pr checkout` + `gh pr update-branch` cover the use cases. Skip to avoid recommending abandonware.

### 2.7 `gh-s` (gennaro-tedesco/gh-s)

**Verdict: OPTIONAL.** Fuzzy repo search across your orgs — useful when the skill needs to scope a cross-repo action but the user doesn't remember full names. Low install cost. Install: `gh extension install gennaro-tedesco/gh-s`.

### 2.8 Other high-signal extensions worth listing (all OPTIONAL)

- `gh-markdown-preview` (yusukebe) — render PR/issue markdown locally before posting.
- `gh-screensaver` (vilmibm) — cosmetic, skip.
- `gh-notify` (meiji163) — TUI for notifications; the skill can shell out to it for "what needs my attention."
- `gh-pr-await` — waits for PR CI to finish; useful in release scripts, but `gh pr checks --watch` is now native, so skip.
- `gh-skill` (built into 2.89+) — **RECOMMEND mentioning** because the skill is itself a GitHub-ecosystem artefact.

Source list: https://github.com/kodepandai/awesome-gh-cli-extensions

---

## Git Power Tools

### 3.1 `git-town` (git-town/git-town)

**Verdict: RECOMMEND** for teams doing stacked PRs; **OPTIONAL** otherwise. As of v22.x it has first-class stacked-changes support, automatically targets parent branches on PR creation, and ships a companion GitHub Action to visualise stacks. The cleanest on-ramp to stacked workflow without full Graphite lock-in. URL: https://www.git-town.com

### 3.2 `git-absorb` (tummychow/git-absorb)

**Verdict: RECOMMEND.** Auto-routes unstaged changes into the correct earlier commits via `git commit --fixup`. Makes review iteration painless. Install: `cargo install git-absorb` or `brew install git-absorb`.

### 3.3 `git-machete` (VirtusLab/git-machete)

**Verdict: OPTIONAL.** Strong alternative to git-town for stacked branches; older (2018) and Python-based. Pick git-town for new adoption, keep git-machete detection for existing users. URL: https://github.com/VirtusLab/git-machete

### 3.4 `git-spr` / `spr`

**Verdict: SKIP.** Original `git-spr` is archived; recommended successor `jj-spr` requires adopting Jujutsu. Route users to git-town or Graphite instead.

### 3.5 `git-branchless` (arxanas/git-branchless)

**Verdict: OPTIONAL.** Powerful undo-log + smartlog; learning curve is real. Flag it for advanced users only.

### 3.6 `jj` / Jujutsu (jj-vcs/jj)

**Verdict: OPTIONAL** (experimental). v0.24+ is increasingly stable and the jj-vcs org split in Dec 2024 signals maturity, but IDE integration and mental model costs remain. Not yet default-recommend. URL: https://github.com/jj-vcs/jj

### 3.7 `lazygit` (jesseduffield/lazygit)

**Verdict: RECOMMEND.** 76k★, 8 years, ubiquitous. The skill should detect it and offer `lazygit` for interactive rebase/staging instead of emitting raw `git rebase -i`. Install: `winget install JesseDuffield.lazygit`.

### 3.8 `gitui` (gitui-org/gitui)

**Verdict: OPTIONAL.** Rust alternative to lazygit — noticeably faster cold-start on huge repos; feature-narrower. Recommend only for repos >2 GB.

---

## Commit Tools

### 4.1 `commitizen` (cz-cli, JS)

**Verdict: OPTIONAL.** The original; mature but JavaScript-only. If the project is not Node, prefer commitizen-tools (Python).

### 4.2 `commitizen-tools` (Python)

**Verdict: RECOMMEND** for polyglot/Python projects. Bumps versions, generates changelogs, and enforces conventional-commit grammar in a single tool. Install via `pipx install commitizen` or `uv tool install commitizen`.

### 4.3 `cz-git` + `czg` (Zhengqbbb/cz-git)

**Verdict: RECOMMEND** for Node projects. Engineered, lightweight, dynamic commitlint config pickup, and native AI-subject mode. The `czg` standalone CLI avoids the commitizen adapter dance. Install: `npm i -g czg`. URL: https://cz-git.qbb.sh

### 4.4 `commitlint` (conventional-changelog/commitlint)

**Verdict: RECOMMEND.** Validate messages in a `commit-msg` hook. Pair with lefthook or husky.

---

## Release Automation

This is where the skill can provide the most leverage. Tool choice is **not one-size-fits-all**:

```
Is the repo public/library published to a registry (npm, PyPI, crates)?
├── YES → is it a monorepo with ≥2 independently-versioned packages?
│   ├── YES → changesets (RECOMMEND for TS/JS monorepos, Nx/Turborepo)
│   └── NO  → is the team comfortable with 100% commit-driven automation?
│       ├── YES → semantic-release (RECOMMEND)
│       └── NO  → release-please (RECOMMEND — PR-based, review-gated)
└── NO (private app, deployed artifact, internal tool)
    ├── App/service with human-curated notes → release-drafter (RECOMMEND)
    └── Cargo/Go/polyglot with conventional commits → git-cliff + GitHub Releases (RECOMMEND)
```

### 5.1 `semantic-release`

**Verdict: RECOMMEND** for single-package libraries with disciplined conventional-commit culture. Fully automated; commit messages drive version + changelog + publish. Weakness: monorepos. URL: https://github.com/semantic-release/semantic-release

### 5.2 `release-please` (googleapis/release-please)

**Verdict: RECOMMEND** as the default middle-ground. Opens a release PR you can review, generates CHANGELOG + version bump, handles monorepos via `release-please-config.json`. Now ships as a GitHub Action. URL: https://github.com/googleapis/release-please

### 5.3 `changesets` (changesets/changesets)

**Verdict: RECOMMEND** for TypeScript monorepos. Best dependency-graph awareness for bumping dependent packages in the same workspace. URL: https://github.com/changesets/changesets

### 5.4 `standard-version`

**Verdict: SKIP.** Deprecated; authors route users to changesets or release-please.

### 5.5 `release-drafter` (release-drafter/release-drafter)

**Verdict: RECOMMEND** for app repos that don't publish to a registry. Drafts release notes as PRs merge, labels-driven categorisation. No version math — you publish when ready. URL: https://github.com/release-drafter/release-drafter

### 5.6 `release-it`

**Verdict: OPTIONAL.** Flexible but less opinionated than semantic-release; most teams are better served by release-please.

---

## Hooks Frameworks

### 6.1 `lefthook` (evilmartians/lefthook)

**Verdict: RECOMMEND (default).** Go binary, parallel execution, ~10× faster than husky on large repos, language-agnostic. 2026 consensus choice for polyglot repos. Install: `brew install lefthook` or `go install github.com/evilmartians/lefthook@latest`. URL: https://github.com/evilmartians/lefthook

### 6.2 `husky` (typicode/husky)

**Verdict: OPTIONAL.** Still the Node ecosystem default and fine for pure-JS projects; pair with lint-staged. Recommend only when the project is already husky-native.

### 6.3 `pre-commit` (pre-commit/pre-commit)

**Verdict: RECOMMEND** for Python-heavy repos. Enormous ecosystem of prebuilt hooks (black, ruff, detect-secrets, etc.). Slower than lefthook but the plugin catalogue is unmatched. URL: https://pre-commit.com

### 6.4 `simple-git-hooks`

**Verdict: OPTIONAL.** Zero-deps; pick only if hook surface is trivially small.

---

## Quality Linting

| Tool | Verdict | Why |
|---|---|---|
| `lint-staged` | RECOMMEND | Canonical "lint only changed files" runner; pairs with any hook framework. |
| `markdownlint-cli2` | RECOMMEND | Fast, config-driven; catches broken links and heading hierarchy before review. |
| `actionlint` (rhysd) | RECOMMEND | Syntax/runner-compat analysis for `.github/workflows/*.yml`; largest rule set. |
| `zizmor` (zizmorcore/zizmor) | RECOMMEND | **Security** linter for GHA — finds template injection, unpinned uses, mutable-tag risk. Complements actionlint (breadth vs depth). URL: https://github.com/zizmorcore/zizmor |
| `hadolint` | RECOMMEND when Dockerfiles present | Lints Dockerfiles + embeds shellcheck on RUN blocks. |
| `shellcheck` | RECOMMEND | Still the definitive bash linter; required for any CI script work. |

Run all four via lefthook/pre-commit **or** via GHA with `super-linter` (which already bundles actionlint + zizmor).

---

## Review Tooling

### 8.1 `CodeRabbit`

**Verdict: OPTIONAL.** Largest installed AI reviewer (2M+ repos). Worth enabling on public repos; the user's own Claude Code review skills cover local workflow. The Anthropic official marketplace lists a `coderabbit` plugin wrapper for triggering it from inside Claude Code. URL: https://coderabbit.ai

### 8.2 `Graphite` (gt)

**Verdict: OPTIONAL.** Stacked-PR platform + AI review; acquired by Cursor in Dec 2025 but continues as an independent product. Only pick up if the team is committing to stacked workflow.

### 8.3 `Reviewpad`

**Verdict: SKIP.** Not deprecated, but the project has lost momentum in 2025-2026; Mergify covers the same surface with active development.

### 8.4 `diffblame`

**Verdict: SKIP.** Niche; not actively maintained in 2026.

---

## Fork and PR Queue

### 9.1 GitHub native Merge Queue

**Verdict: RECOMMEND (default).** Since 2023 GA, this is the baseline. The skill should detect `.github/rulesets/*.json` and prefer native queue over third-party for new repos.

### 9.2 `Mergify`

**Verdict: RECOMMEND** when native queue is insufficient (batch merging, priority rules, CI Insights, cross-repo policy). Actively evolving (changelog through April 2026 shows ongoing dep-rotations). URL: https://mergify.com

### 9.3 `Kodiak` (kodiakhq)

**Verdict: OPTIONAL.** Open-source Mergify alternative; maintained but lower velocity. Good for self-hosted/air-gapped orgs.

### 9.4 `Bulldozer` (palantir/bulldozer)

**Verdict: SKIP.** Legacy (2017) auto-merge app; Mergify and GitHub native both superior. Palantir themselves recommend moving off.

### 9.5 Fork sync

**Verdict: use native `gh repo sync`** (RECOMMEND). No third-party tool needed since `gh` 2.23+.

---

## Changelog

### 10.1 `git-cliff` (orhun/git-cliff)

**Verdict: RECOMMEND.** Rust binary, ~120 ms for 10k commits, Tera template engine, language-agnostic, keep-a-changelog format out of the box. Drop-in for any repo not already using release-please/changesets. Install: `cargo install git-cliff` or `brew install git-cliff`. URL: https://git-cliff.org

### 10.2 `auto-changelog` (cookpete/auto-changelog)

**Verdict: OPTIONAL.** Simpler/less opinionated than git-cliff; fine for small projects not using conventional commits.

---

## Required Tool Dependencies

| Tool | Verdict | Why | URL |
|---|---|---|---|
| `gh` CLI | RECOMMEND | Hard dep — the skill's primary IO surface for GitHub. | https://cli.github.com |
| `gh-dash` | RECOMMEND | Battle-tested PR/issue TUI for triage mode. | https://github.com/dlvhdr/gh-dash |
| `gh-poi` | RECOMMEND | Safe local-branch cleanup after squash-merge. | https://github.com/seachicken/gh-poi |
| `gh-s` | OPTIONAL | Fuzzy cross-org repo search. | https://github.com/gennaro-tedesco/gh-s |
| `gh-reassign-reviewer` | OPTIONAL | Re-request stalled reviewers from CLI. | https://github.com/ryo246912/gh-reassign-reviewer |
| `gh-copilot` | SKIP | Deprecated 2025-10-25. | https://github.blog/changelog/2025-09-25-upcoming-deprecation-of-gh-copilot-cli-extension/ |
| `gh-pr-sync` | SKIP | Not canonical; `gh pr checkout`/`update-branch` suffice. | — |
| `gh-nudge` | SKIP | No canonical extension; use gh-reassign-reviewer. | — |
| `git-town` | RECOMMEND (stacked) | First-class stacked PRs, parent-branch PR targeting. | https://www.git-town.com |
| `git-absorb` | RECOMMEND | Auto-routes fixups to correct commits. | https://github.com/tummychow/git-absorb |
| `git-machete` | OPTIONAL | Older stacked-branch alternative to git-town. | https://github.com/VirtusLab/git-machete |
| `git-spr`/`spr` | SKIP | Archived; successor requires jj adoption. | — |
| `git-branchless` | OPTIONAL | Advanced smartlog + undo; learning curve. | https://github.com/arxanas/git-branchless |
| `jj` (jujutsu) | OPTIONAL | Experimental but maturing VCS. | https://github.com/jj-vcs/jj |
| `lazygit` | RECOMMEND | De-facto TUI for interactive rebase/staging. | https://github.com/jesseduffield/lazygit |
| `gitui` | OPTIONAL | Rust TUI; faster on very large repos. | https://github.com/gitui-org/gitui |
| `commitizen` (JS) | OPTIONAL | Original cz-cli; prefer czg/cz-git for Node. | https://commitizen.github.io/cz-cli/ |
| `commitizen-tools` (Py) | RECOMMEND (Python) | Versioning + changelog + commit standard in one. | https://commitizen-tools.github.io/commitizen/ |
| `cz-git` / `czg` | RECOMMEND (Node) | Modern, AI-aware commitizen adapter + standalone CLI. | https://cz-git.qbb.sh |
| `commitlint` | RECOMMEND | Validate conventional-commit grammar in commit-msg hook. | https://commitlint.js.org |
| `semantic-release` | RECOMMEND (single-pkg lib) | Full automation from commits → publish. | https://github.com/semantic-release/semantic-release |
| `release-please` | RECOMMEND (default) | PR-gated bump + changelog; monorepo-aware. | https://github.com/googleapis/release-please |
| `changesets` | RECOMMEND (TS monorepo) | Best dependency-graph-aware monorepo releases. | https://github.com/changesets/changesets |
| `standard-version` | SKIP | Deprecated. | — |
| `release-drafter` | RECOMMEND (app repos) | Label-driven release-notes drafts for non-registry repos. | https://github.com/release-drafter/release-drafter |
| `release-it` | OPTIONAL | Flexible but less opinionated. | https://github.com/release-it/release-it |
| `lefthook` | RECOMMEND (default) | 10× faster than husky, parallel, polyglot. | https://github.com/evilmartians/lefthook |
| `husky` | OPTIONAL (Node) | Fine for pure-Node repos already using it. | https://typicode.github.io/husky/ |
| `pre-commit` | RECOMMEND (Python) | Unmatched hook catalogue. | https://pre-commit.com |
| `simple-git-hooks` | OPTIONAL | Zero-deps micro-alternative. | https://github.com/toplenboren/simple-git-hooks |
| `lint-staged` | RECOMMEND | Canonical "lint changed files only." | https://github.com/lint-staged/lint-staged |
| `markdownlint-cli2` | RECOMMEND | Fast markdown linting for PR descriptions/docs. | https://github.com/DavidAnson/markdownlint-cli2 |
| `actionlint` | RECOMMEND | GHA syntax + runner-compat checks. | https://github.com/rhysd/actionlint |
| `zizmor` | RECOMMEND | GHA **security** linter (injection, pins, mutable tags). | https://github.com/zizmorcore/zizmor |
| `hadolint` | RECOMMEND (if Docker) | Dockerfile linter with embedded shellcheck. | https://github.com/hadolint/hadolint |
| `shellcheck` | RECOMMEND | Definitive bash linter. | https://www.shellcheck.net |
| CodeRabbit | OPTIONAL | External AI reviewer; Claude covers local flow. | https://coderabbit.ai |
| Graphite (gt) | OPTIONAL | Stacked-PR platform; team-level decision. | https://graphite.dev |
| Reviewpad | SKIP | Momentum lost to Mergify. | — |
| diffblame | SKIP | Not actively maintained. | — |
| GitHub native Merge Queue | RECOMMEND (default) | Baseline since 2023 GA. | https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request-with-a-merge-queue |
| Mergify | RECOMMEND (advanced) | Batch, priority, CI insights beyond native. | https://mergify.com |
| Kodiak | OPTIONAL | OSS alternative; lower velocity. | https://kodiakhq.com |
| Bulldozer | SKIP | Legacy; Palantir itself moved on. | https://github.com/palantir/bulldozer |
| `git-cliff` | RECOMMEND | Fast, template-driven, language-agnostic changelog. | https://git-cliff.org |
| `auto-changelog` | OPTIONAL | Simpler non-conventional alternative. | https://github.com/cookpete/auto-changelog |

---

## 11. Claude Code Skill Gap Analysis

The user's 23 existing skills cover commit writing, branch creation, PR creation + iteration, review giving/receiving, hook automation, and finishing a development branch. What's *missing* from their stack, validated against anthropics/claude-plugins-official, awesome-claude-code (hesreallyhim, ComposioHQ, travisvn, jmanhype), claude-plugins.dev, and the Anthropic Skills repo:

### 11.1 Release lifecycle (largest gap)
No skill currently owns semver-bump classification, release-note generation, or release-PR authoring. The existing `commit`, `pr-writer`, and `create-pr` skills don't interpret commit history for release planning.

**Candidates found:**
- **`semver-advisor`** (alienfast/claude) — classifies diffs as MAJOR/MINOR/PATCH per semver; Haiku-based, cheap to run.
- **`changelog-generator`** (ComposioHQ) — turns commit history into customer-facing release notes.
- **`dependency-audit`** (makr.io) — audits deps for CVEs, unused packages, outdated versions with prioritised remediation.
- **`dependency-upgrade` / `dependabot-advisory-analyst`** — analyses Dependabot advisories and routes fixes.

### 11.2 CI/Workflow quality (large gap)
No skill analyses `.github/workflows/*.yml` or interprets CI failure logs. `git-hooks-automation` stops at local hooks.

**Candidates found:**
- **`gha-security-review`** (already in the user's available list — confirm loaded) — security-review workflow for GitHub Actions.
- **`/update-ci` command** (athola/claude-night-market marketplace) — reconciles pre-commit hooks and GitHub Actions with code changes.
- No dedicated zizmor/actionlint wrapper skill exists — this is a genuine green-field skill opportunity if the user wants to build one.

### 11.3 Merge / Queue / Backport (medium gap)
User has no skill managing merge queues, backport labels, or stale-PR cleanup.

**Candidates found:**
- `Issues Triage` skill (mcpmarket.com/skills/issues-triage) — analyses issues and manages labels locally.
- Native Claude Code Routines (documented at code.claude.com/docs/en/routines) already support label-gated backporting, CODEOWNERS-based assignment, and stale-label removal — these are **routines**, not skills, but the skill should know to scaffold them.

### 11.4 Fork / Upstream hygiene (small gap)
No skill handles upstream sync, rebase-vs-merge strategy for forks, or divergence detection. `git-advanced-workflows` partially covers but isn't fork-specific.

**No canonical community skill found.** Potential green-field skill.

### 11.5 Contribution analytics / Org health (small gap)
No skill surfaces org-level PR metrics, reviewer load, stale PR age, or triage SLAs. The Anthropic Analytics API (Enterprise) provides data, but no wrapper skill exists publicly.

**No canonical community skill found.** Potential green-field skill.

### 11.6 Signed commits / GPG setup (small gap)
No skill configures or verifies GPG/SSH-signed commits. The `commit` skill emits messages but doesn't handle signing.

**No canonical community skill found.** Worth noting in the skill as a hardening step rather than delegating.

### 11.7 PR size / budget enforcement (small gap)
No skill enforces PR size limits or proposes splits. Research shows Claude itself flags diffs >50 files as problematic but there's no pre-built skill.

**No canonical community skill found.** Green-field.

### 11.8 CODEOWNERS management (small gap)
No skill generates, validates, or audits `.github/CODEOWNERS`.

**No canonical community skill found.** Green-field.

---

## Candidate New Claude Skills

| Name | Gap Filled | Source | Install |
|---|---|---|---|
| `semver-advisor` | Classifies diffs into MAJOR/MINOR/PATCH with rationale | https://github.com/alienfast/claude/tree/main/skills/semver-advisor | Download `Semantic Version Advisor.zip` → claude.ai/settings/capabilities → Upload skill |
| `changelog-generator` | Transforms commit history into customer-facing release notes | https://github.com/ComposioHQ/awesome-claude-plugins/tree/master/changelog-generator | `claude --plugin-dir ./changelog-generator` or clone + load as plugin |
| `dependency-audit` | Audits deps for CVEs / unused / outdated with prioritised remediation | https://www.makr.io/skills/dependency-audit | Download from makr.io → Upload skill via settings |
| `dependabot-advisory-analyst` | Parses Dependabot advisories, proposes upgrade paths for direct+transitive deps | https://mcpmarket.com/tools/skills/dependabot-advisory-analyst | Install via mcpmarket CLI or clone + add to `.claude/skills/` |
| `dependabot-configurator` | Scaffolds `dependabot.yml` for npm/pip/docker/actions | https://mcpmarket.com/tools/skills/dependabot-configurator | Same as above |
| `dependency-upgrade` | End-to-end dep upgrade workflow, bumps + tests + PR | https://fastmcp.me/skills/details/351/dependency-upgrade | `fastmcp skill install dependency-upgrade` |
| `issues-triage` | Local label/triage layer for GitHub issues without cluttering remote | https://mcpmarket.com/tools/skills/issues-triage | Install via mcpmarket CLI |
| `ship` (ComposioHQ) | End-to-end PR-to-production pipeline (lint/test/review/deploy) — orchestrator, complements individual skills | https://github.com/ComposioHQ/awesome-claude-plugins/tree/master/ship | `claude --plugin-dir ./ship` |
| `semver` (cathy-kim/skill-semver) | Automatic version control for Claude Code *skills themselves* with auto-backup + changelog | https://github.com/cathy-kim/skill-semver | Clone + add to `.claude/skills/` |
| `/update-ci` command (Night Market) | Reconciles pre-commit hooks and GHA workflows with code changes | https://github.com/athola/claude-night-market | `/plugin marketplace add athola/claude-night-market` then install `update-ci` |
| `shopware-ci-log-interpreter` (template) | Interprets CI failure logs (PHPUnit, PHPStan, ESLint, Playwright) — **pattern template** for building a generic version | https://github.com/shopwareLabs/ai-coding-tools | `/plugin marketplace add shopwareLabs/ai-coding-tools` |
| **Green-field: `codeowners-manager`** | Generate/validate/audit `.github/CODEOWNERS` from commit history + team map | — (no canonical skill; build) | N/A — author as part of this skill |
| **Green-field: `fork-upstream-sync`** | Upstream divergence detection + rebase/merge strategy for forks | — | N/A — build |
| **Green-field: `pr-size-budget`** | Enforce PR line/file budgets; propose split points | — | N/A — build |
| **Green-field: `signed-commits-setup`** | One-shot GPG/SSH signing config + verification | — | N/A — build |
| **Green-field: `contribution-analytics`** | Wraps Anthropic Enterprise Analytics + GitHub API for org PR health reports | — | N/A — build |
| **Green-field: `gha-security-sweep`** | Runs zizmor + actionlint + interprets findings | — | N/A — build (or wait for community) |

---

## 12. Summary & Skill-Integration Recommendations

1. **Hard deps** the skill should verify on first run: `gh`, `git` (≥2.40), `lefthook` *or* `pre-commit` *or* `husky`, at least one of (`release-please` | `semantic-release` | `changesets` | `release-drafter`), `git-cliff` (unless one of the release tools is already handling changelog).
2. **Soft deps** (detect + offer): `gh-dash`, `gh-poi`, `lazygit`, `git-town`, `git-absorb`, `commitlint`, `czg`, `actionlint`, `zizmor`, `markdownlint-cli2`, `shellcheck`, `hadolint`.
3. **Skill installs** the skill should propose during onboarding (highest ROI first): `semver-advisor`, `changelog-generator`, `dependency-audit`, `issues-triage`, `dependabot-advisory-analyst`.
4. **Green-field opportunities** — the skill's author (user) would create genuine community value by publishing: `codeowners-manager`, `fork-upstream-sync`, `pr-size-budget`, `signed-commits-setup`, `contribution-analytics`, `gha-security-sweep`.
5. **Avoid recommending**: `gh-copilot` (deprecated), `standard-version` (deprecated), `Bulldozer` (legacy), `Reviewpad` (stalling), `git-spr` (archived).

The skill should treat tool detection as a one-time handshake and cache results in project-local state so subsequent invocations skip re-probing. Release-automation choice especially benefits from being asked once and committed to the repo's config, not re-decided per run.
