> **Consult this if:** citing a canonical doc, verifying guidance against an authoritative source, or needing a reference for a spec/standard.
>
> **Cross-refs:** [16](./16-security-sources.md) (security-specific sources) · [INDEX.md](./INDEX.md)

## Table of Contents

- [Core Specs](#core-specs)
- [GitHub Docs](#github-docs)
- [Git Docs](#git-docs)
- [CLI API](#cli-api)
- [Governance Exemplars](#governance-exemplars)
- [Security](#security)
- [Community](#community)
- [Release Tools](#release-tools)

---

# GitHub Skill — External Source Map

Canonical external references for the GitHub repo-management + contribution skill.
Consult this map when in-context knowledge is stale, ambiguous, or a definitive source is required.

**Column order:** Title | URL | What it is | Consult when | Stability

Stability legend:
- **STABLE** — versioned spec or long-settled doc, rarely changes
- **LIVE** — product docs that evolve; re-check on non-trivial decisions
- **DEPRECATED** — superseded but still encountered in the wild

---

## Core Specs

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| Conventional Commits 1.0.0 | https://www.conventionalcommits.org/en/v1.0.0/ | Lightweight spec for commit messages that machines can parse (feat/fix/BREAKING CHANGE). | IF drafting a commit message, designing a commit lint rule, or mapping commit types to release impact. | STABLE |
| Angular Commit Message Convention | https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md | The original type(scope): subject convention that Conventional Commits was derived from; defines the canonical scope list and revert format. | IF deciding between Conventional Commits and stricter Angular form, or handling `revert:` / footer semantics. | STABLE |
| Semantic Versioning 2.0.0 | https://semver.org/spec/v2.0.0.html | MAJOR.MINOR.PATCH versioning spec with precedence and pre-release rules. | IF unsure whether a change warrants a major/minor/patch bump, or comparing pre-release identifiers. | STABLE |
| Keep a Changelog 1.1.0 | https://keepachangelog.com/en/1.1.0/ | Human-readable CHANGELOG.md format with Added/Changed/Deprecated/Removed/Fixed/Security sections. | IF structuring CHANGELOG entries or converting auto-generated release notes to human form. | STABLE |
| Developer Certificate of Origin (DCO) 1.1 | https://developercertificate.org/ | Lightweight contributor sign-off (`Signed-off-by:`) as an alternative to a CLA. | IF a project requires DCO sign-off or deciding between DCO vs CLA for new repos. | STABLE |
| All Contributors Specification | https://allcontributors.org/docs/en/specification | Spec + emoji key for recognizing all contribution types (code, docs, design, triage). | IF adding contributor recognition, configuring the `.all-contributorsrc`, or resolving emoji key disputes. | STABLE |

## GitHub Docs

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| GitHub Flow | https://docs.github.com/en/get-started/using-github/github-flow | GitHub's canonical lightweight branch-and-PR workflow. | IF bootstrapping a branching strategy or explaining the default contribution loop to a new project. | LIVE |
| About Protected Branches | https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches | Branch protection rule capabilities (required reviews, status checks, linear history, force-push blocks). | IF setting up branch protection rules on a new repo or debugging why a push was rejected. | LIVE |
| About CODEOWNERS | https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners | Syntax and precedence for `.github/CODEOWNERS` auto-review-request routing. | IF authoring/editing a CODEOWNERS file or debugging why a reviewer isn't auto-requested. | LIVE |
| Community Standards Checklist | https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions | The set of files GitHub expects for a "healthy" repo (README, LICENSE, CoC, CONTRIBUTING, ISSUE/PR templates, SECURITY). | IF auditing a repo's community health score or bootstrapping a new OSS project's meta files. | LIVE |
| Issue Forms (YAML templates) | https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms | YAML schema for structured issue forms in `.github/ISSUE_TEMPLATE/`. | IF converting markdown issue templates to YAML forms or adding required/validated fields. | LIVE |
| Pull Request Templates | https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository | How to create single or multiple PR templates, including query-string selection. | IF adding or restructuring PR templates (including per-branch or multi-template setups). | LIVE |
| About Commit Signature Verification | https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification | GPG / SSH / S/MIME / Sigstore commit signing support and the "Verified" / "Unverified" badges. | IF configuring signed commits, debugging an Unverified badge, or enforcing signature requirements via rulesets. | LIVE |
| gitignore Patterns | https://docs.github.com/en/get-started/git-basics/ignoring-files | Pattern syntax for `.gitignore` and reference to the curated github/gitignore template repo. | IF authoring a `.gitignore` from scratch or untangling a pattern that isn't matching as expected. | LIVE |
| About Releases | https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases | Release object model (tag, title, body, assets, pre-release, latest). | IF publishing a release manually/programmatically or deciding how to attach binaries vs source archives. | LIVE |
| Required Reviewers | https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/approving-a-pull-request-with-required-reviews | How required-review rules, CODEOWNER reviews, and dismissal behavior interact. | IF tuning required-review counts, dismiss-stale-reviews, or CODEOWNER review enforcement. | LIVE |
| Merge Queue | https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue | Serial / batched PR merging with re-run of checks against the queued state. | IF enabling merge queue, debugging queued PR failures, or choosing between squash/merge/rebase at queue time. | LIVE |
| Repository Rulesets | https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets | Next-gen branch/tag/push rulesets with layered enforcement and bypass lists. | IF migrating from classic branch protection, layering org-level rules, or auditing rule evaluation order. | LIVE |
| Syncing a Fork | https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork | UI/CLI/API methods to bring a fork up to date with its upstream. | IF a contributor's fork is behind and you need to pick between `gh repo sync`, UI, or manual merge/rebase. | LIVE |
| Repository Security Advisories | https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/about-repository-security-advisories | Private advisory drafting, CVE requests, and coordinated disclosure flow. | IF a vulnerability is reported privately and you need to draft, request a CVE, or publish an advisory. | LIVE |
| About GitHub Actions | https://docs.github.com/en/actions/about-github-actions/understanding-github-actions | Core concepts: workflows, jobs, steps, runners, events. | IF designing a new workflow or explaining Actions fundamentals to a contributor. | LIVE |
| Reusable Workflows | https://docs.github.com/en/actions/sharing-automations/reusing-workflows | `workflow_call` semantics, inputs/secrets passing, permissions inheritance. | IF factoring duplicate workflow YAML into a shared reusable workflow or debugging secret inheritance. | LIVE |
| Dependabot Configuration Options | https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference | Full `dependabot.yml` reference (ecosystems, schedule, grouping, ignore, target-branch). | IF authoring/tuning `.github/dependabot.yml` or grouping/ignoring specific dependency updates. | LIVE |
| About Secret Scanning | https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning | Secret scanning alerts, push protection, validity checks, and partner program. | IF enabling secret scanning/push protection, handling a leaked-secret alert, or writing custom patterns. | LIVE |

## Git Docs

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| Pro Git (2nd ed.) | https://git-scm.com/book/en/v2 | Free canonical Git book covering plumbing, porcelain, and internals. | IF needing authoritative Git behavior (refs, objects, reflog) beyond what a man page answers. | STABLE |
| git-rebase Manual | https://git-scm.com/docs/git-rebase | Full reference for `git rebase`, including interactive mode and `--onto`. | IF planning a non-trivial rebase (onto, interactive reorder, exec), or resolving rebase conflicts. | STABLE |
| git-worktree Manual | https://git-scm.com/docs/git-worktree | Managing multiple working trees attached to one repo. | IF setting up parallel branches/reviews without re-cloning, or cleaning up stale worktrees. | STABLE |
| git-cherry-pick Manual | https://git-scm.com/docs/git-cherry-pick | Apply specific commits from one branch onto another. | IF backporting a fix to a release branch or salvaging commits from an abandoned branch. | STABLE |
| git-commit (--fixup / --squash) + rebase --autosquash | https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---fixupltcommitgt | `--fixup`/`--squash` commit creation that `rebase -i --autosquash` will auto-order and merge. | IF performing a fixup-autosquash workflow to clean history before merging a PR. | STABLE |

## CLI / API

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| GitHub CLI Manual | https://cli.github.com/manual/ | Complete `gh` command reference (repo, pr, issue, release, api, workflow, ruleset). | IF scripting a repo task, choosing a `gh` subcommand, or passing `--jq`/`--template` to `gh api`. | LIVE |
| Octokit REST API (octokit.js) | https://github.com/octokit/octokit.js#readme | JS client for the GitHub REST API with plugins, auth, pagination, throttling. | IF writing a Node/TS automation against the REST API and picking auth/pagination patterns. | LIVE |
| GitHub GraphQL API Docs | https://docs.github.com/en/graphql | Schema, queries, mutations, pagination, rate limits for the GraphQL API. | IF a REST call would require many round trips or you need fields only exposed in GraphQL (projects v2, discussions). | LIVE |
| GitHub GraphQL Explorer | https://docs.github.com/en/graphql/overview/explorer | Authenticated in-browser GraphiQL against the live API. | IF drafting/validating a GraphQL query before wiring it into automation. | LIVE |

## Governance Exemplars

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| Kubernetes Contributor Guide | https://www.kubernetes.dev/docs/guide/ | Large-project contributor model: SIGs, OWNERS files, Prow bot commands, KEP process. | IF designing governance for a large multi-maintainer project or adopting OWNERS-style review routing. | LIVE |
| Node.js TSC Charter | https://github.com/nodejs/TSC/blob/main/TSC-Charter.md | Technical Steering Committee charter: scope, membership, voting, decision-making. | IF drafting a TSC/steering-committee charter or formalizing voting and conflict-resolution rules. | LIVE |
| Rust RFC Process | https://github.com/rust-lang/rfcs#readme | PR-driven RFC workflow with Final Comment Period (FCP) for substantial language/library changes. | IF introducing an RFC process for non-trivial design changes in an OSS project. | LIVE |
| React CONTRIBUTING | https://github.com/facebook/react/blob/main/CONTRIBUTING.md | React's contributor guide: bug reports, proposals, PR etiquette, style/tests. | IF modeling a contributor guide for a high-traffic library with many drive-by PRs. | LIVE |
| Vue Core Contributing Guide | https://github.com/vuejs/core/blob/main/.github/contributing.md | Vue 3 core contribution rules: scope, issue triage, commit format, PR checklist. | IF modeling a contributor guide for a focused core library with strict scope rules. | LIVE |
| TypeScript CONTRIBUTING | https://github.com/microsoft/TypeScript/blob/main/CONTRIBUTING.md | TS compiler contribution rules incl. Design Meeting / "Suggestion" triage states. | IF handling a language/compiler project where most feature requests need design-meeting triage. | LIVE |
| Linux Kernel — Submitting Patches | https://docs.kernel.org/process/submitting-patches.html | Canonical email-patch workflow, Signed-off-by, trailer tags, subsystem routing. | IF working with an email-driven patch workflow or interpreting Reported-by/Reviewed-by/Acked-by trailers. | STABLE |
| Astro CONTRIBUTING | https://github.com/withastro/astro/blob/main/CONTRIBUTING.md | Changesets-based release workflow, monorepo with pnpm, examples PR rules. | IF bootstrapping a pnpm monorepo + changesets contributor flow. | LIVE |
| Svelte CONTRIBUTING | https://github.com/sveltejs/svelte/blob/main/CONTRIBUTING.md | Svelte monorepo contribution rules: tests, changesets, RFC pointer for design changes. | IF modeling contributor docs for a compiler/framework monorepo. | LIVE |

## Security

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| OpenSSF Scorecard | https://github.com/ossf/scorecard#readme | Automated checks that score an OSS repo's security posture (branch protection, signed releases, SAST, etc.). | IF auditing a repo against industry baseline security checks or prioritizing hardening work. | LIVE |
| OpenSSF Best Practices Badge | https://www.bestpractices.dev/ | Self-assessed passing/silver/gold criteria for FLOSS projects. | IF pursuing a public security-maturity badge or using the criteria as a checklist for OSS hardening. | LIVE |
| SLSA Framework | https://slsa.dev/spec/v1.0/ | Supply-chain levels for software artifacts (build provenance, source integrity). | IF designing a release pipeline that needs attestations/provenance at a specific SLSA level. | STABLE |
| Sigstore cosign | https://docs.sigstore.dev/cosign/signing/overview/ | Keyless signing/verification of containers and artifacts via OIDC + Rekor transparency log. | IF signing release artifacts or verifying a signed artifact in CI. | LIVE |

## Community

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| First Timers Only | https://www.firsttimersonly.com/ | Guidance + labels for making a repo approachable to first-time contributors. | IF onboarding-friendly issue labeling/docs are needed (e.g., `first-timers-only`). | STABLE |
| Up For Grabs | https://up-for-grabs.net/ | Directory of projects with curated beginner-friendly issues + label conventions. | IF listing a project publicly as newcomer-friendly or choosing a label name (`up-for-grabs`, `help wanted`). | LIVE |
| Hacktoberfest — Maintainers / Quality Standards | https://hacktoberfest.com/participation/#maintainers | Opt-in rules, spam-PR mitigation, `hacktoberfest-accepted` label guidance. | IF a project is opting into Hacktoberfest or dealing with low-quality October PRs. | LIVE |
| CodeTriage | https://www.codetriage.com/ | Service that emails contributors open issues from projects they've subscribed to. | IF a project wants a low-friction channel to route stale issues back to interested contributors. | LIVE |

## Release Tools

| Title | URL | What it is | Consult when | Stability |
|---|---|---|---|---|
| semantic-release | https://semantic-release.gitbook.io/semantic-release | Fully automated version determination + changelog + publish driven by Conventional Commits. | IF a project wants zero-touch releases strictly tied to commit messages. | LIVE |
| release-please | https://github.com/googleapis/release-please#readme | Release-PR automation (opens a rolling PR with version bump + CHANGELOG) using Conventional Commits; supports monorepos. | IF preferring a human-reviewed release PR over fully automatic publishes, especially in polyglot monorepos. | LIVE |
| Changesets | https://github.com/changesets/changesets#readme | Contributor-authored changeset files combined into versioned releases; ideal for JS monorepos with independent package versions. | IF running a pnpm/npm monorepo and needing per-package independent versioning with contributor-authored notes. | LIVE |
| Release Drafter | https://github.com/release-drafter/release-drafter#readme | GitHub Action that drafts the next release's notes from merged PR titles/labels. | IF wanting curated release notes grouped by PR labels without full semantic-release automation. | LIVE |

---

**Total entries: 46**
- Core Specs: 6
- GitHub Docs: 18
- Git Docs: 5
- CLI / API: 4
- Governance Exemplars: 9
- Security: 4
- Community: 4
- Release Tools: 4
