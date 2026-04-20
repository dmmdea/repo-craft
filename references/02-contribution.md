> **Consult this if:** preparing a contribution to someone else's repo, deciding issue-first vs PR-first, writing a PR body or commit message, navigating review feedback, or avoiding contributor anti-patterns.
>
> **Cross-refs:** [06#pre-pr-ritual](./06-archaeology-author.md#pre-pr-ritual) · [08#anti-patterns](./08-influence.md#anti-patterns) · [10](./10-templates.md) · [14](./14-maintainer-profiles.md)

## Table of Contents

- [Fork Setup and Upstream Sync](#fork-setup-and-upstream-sync)
- [Issue-First Discipline](#issue-first-discipline)
- [PR Anatomy](#pr-anatomy)
- [Commit Discipline](#commit-discipline)
- [Conventional Commits](#conventional-commits)
- [DCO Sign-Off](#dco-sign-off)
- [CLA Navigation](#cla-navigation)
- [Review Etiquette](#review-etiquette)
- [First-Time Contributor Playbook](#first-time-contributor-playbook)
- [Maintainer Psychology](#maintainer-psychology)
- [Top 10 Habits of Effective Contributors](#top-10-habits-of-effective-contributors)

---

# Contributing to Someone Else's GitHub Repo — Deep Reference

Status: research bundle for the github-skill orchestrator.
Target user: experienced engineer opening bug fixes and features against active OSS (first real target: ryaker/zora).
All claims carry inline URL citations.

---

## Fork Setup and Upstream Sync

The first thing a contributor does against a repo they don't own is fork. The canonical flow uses two remotes: `origin` (your fork, where you push) and `upstream` (the canonical repo, where you pull). GitHub's documentation lays this out as the default model: "When you fork a project in order to propose changes to the original repository, you can configure Git to pull changes from the original, or upstream, repository into the local clone of your fork" ([GitHub Docs — Configuring a remote repository for a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-repository-for-a-fork)).

The GitHub CLI collapses the whole bootstrap into one command. `gh repo fork <repo> --clone --remote` creates the fork server-side, clones it, wires `origin` to the fork, and adds `upstream` pointing at the source. Per the official `gh` reference, "By default, the new fork is set to be your origin remote and any existing origin remote is renamed to upstream" ([gh repo fork manual](https://cli.github.com/manual/gh_repo_fork)). Useful flags: `--remote-name` overrides the default `origin` name, `--fork-name` renames the server-side fork, `--default-branch-only` forks just the default branch (reduces clone size on large histories).

**Syncing upstream: three options, one recommended.** GitHub's docs promote three mechanisms: the web UI "Sync fork" button, `gh repo sync owner/fork -b BRANCH`, and the manual fetch+merge dance ([GitHub Docs — Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)). GitHub's own guidance uses `git merge upstream/main`, not rebase — because on a long-lived default branch that you haven't personally committed to, the merge will fast-forward and leave no merge commit. Rebase is appropriate for **your feature branches**, not your `main`. Rebasing `main` onto `upstream/main` rewrites history you share with the remote fork and will require a force-push on the next sync, which defeats the purpose.

**Stale-fork risks.** A fork that lags upstream for months accumulates three problems: (a) feature branches cut from stale `main` diverge from the real codebase and conflict on rebase; (b) CI on your fork may reference workflows, Actions, or secrets that have since moved; (c) security patches you haven't pulled in may leave you pushing insecure code into a new PR. Keeping the fork healthy = `git fetch upstream && git rebase upstream/main` on any feature branch before resuming work, plus a weekly `gh repo sync` on `main`. GitHub's "Dependabot for forks" covers the dependency half; the `gh repo sync` covers the branch half.

---

## Worktree Strategies for Multi-PR Forks

If you're submitting more than one PR at a time, branch-switching becomes the bottleneck — each switch wipes `node_modules/` reinstalls, cache invalidations, and editor state. Git's answer since 2.5 is `git worktree`: multiple working directories backed by one `.git` directory, each on a different branch ([git-tower — git worktree FAQ](https://www.git-tower.com/learn/git/faq/git-worktree)).

Typical layout for a fork:

```
~/src/zora/              # main worktree, checked out on main
~/src/zora-fix-auth/     # worktree for branch fix/auth
~/src/zora-feat-export/  # worktree for branch feat/export
```

Commands: `git worktree add ../zora-fix-auth fix/auth` attaches a new directory to an existing branch; `git worktree add -b fix/auth ../zora-fix-auth upstream/main` creates a new branch off upstream in one go. `git worktree list` enumerates, `git worktree remove` cleans up ([DataCamp — Git Worktree Tutorial](https://www.datacamp.com/tutorial/git-worktree-tutorial)).

**Constraints worth internalizing.** Only one worktree per branch — Git refuses to check the same branch out twice. Each worktree needs its own `npm install` / `uv sync` / `cargo build` cache because the node_modules and target dirs live outside `.git`. Hooks in `.git/hooks` are shared; per-worktree hooks require `core.hooksPath` gymnastics.

**Why this matters for PR discipline.** Worktrees make it cheap to: (a) keep a long-running refactor branch warm while you spin up a quick hotfix worktree off fresh upstream; (b) review an inbound PR by checking out the author's branch into a disposable worktree without stashing your own work ([barrd.dev — Parallel development with worktrees](https://barrd.dev/article/parallel-development-without-the-headaches-using-git-worktree/)). It also maps cleanly onto AI-agent workflows where each worktree gets its own agent context.

---

## Issue-First Discipline

The single biggest mistake experienced engineers make on their first PR to a new repo: opening a large PR without an issue first. Maintainers prefer a 30-second "is this in scope?" issue comment over a 4-hour review of a feature they're about to reject on philosophical grounds.

**When to open an issue first:**
- Any feature adding public API surface.
- Any bug fix whose repro isn't already in an existing issue.
- Any refactor touching >1 module.
- Never: typo fixes, one-line obvious bugs, test-only additions tied to an already-open issue.

**Write a minimal reproducible example.** The guidance Dan Abramov popularized in the React community — and which PLOS, Matthew Rocklin, and the SSCCE project have codified — is: strip the repro until removing any more line makes the bug disappear ([Craft Minimal Bug Reports — Matthew Rocklin](https://matthewrocklin.com/minimal-bug-reports.html); [PLOS — Ten simple rules for reporting a bug](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010540); [SSCCE.org](http://sscce.org/)). The repro should be copy-paste runnable. If you must attach a file, inline it. If you need data, synthesize 3 rows. Maintainers will close issues that require them to download a zip, unzip it, set up a Docker container, and clone a sibling repo.

**What maintainers want in an issue:**
1. Version / commit SHA / OS (one line).
2. What you did (code block).
3. What you expected (one sentence).
4. What actually happened (stack trace in a code fence, not a screenshot).
5. Minimal repro (gist or inline).
6. What you've already tried (signals you're not asking them to debug for free).

Sindre Sorhus — who maintains 1000+ npm packages — has written publicly that maintainers are not paid support. His framing: "users are not paying customers" and "if you have the option to walk away, take it" ([Vivian Cromwell interview with Sindre Sorhus](https://www.viviancromwell.com/blog/2019/8/21/between-the-wires-an-interview-with-open-source-developer-sindre-sorhus)). The practical translation: every minute you save a maintainer by writing a tight issue compounds into goodwill on your PR.

---

## PR Anatomy

**Title.** Use Conventional Commits as the default, even if the project doesn't enforce them — it parses cleanly, survives squash-merge, and generates changelogs for free. Spec: `<type>[scope]: <imperative description>`, types `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, optionally `!` for breaking ([Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)). Imperative mood ("add logging", not "added logging" or "adds logging") because Git's own tooling reads commits as imperative commands.

**Body structure** — the template that reviewers internalize quickly:

```
 ## Problem
 <1-3 sentences. Link the issue: Closes #123>

 ## Approach
 <Why this approach, what alternatives you ruled out>

 ## Test plan
 - [ ] Unit test X covers case Y
 - [ ] Manual repro of issue #123 now passes
 - [ ] CI green

 ## Screenshots / logs
 <Only if UI or observable output>
```

`Closes #N` / `Fixes #N` in the body auto-closes the issue on merge ([GitHub Docs — Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)).

**Draft PRs.** Use GitHub's native Draft state (not `[WIP]` in the title) whenever you want to expose work for early feedback. Drafts block merge, suppress CODEOWNERS review notifications, and signal "don't review yet" without hacky title prefixes ([GitHub Blog — Introducing draft pull requests](https://github.blog/news-insights/product-news/introducing-draft-pull-requests/)). Mark ready for review when tests pass locally and you've self-reviewed the diff.

**Size budget: the 400-line rule.** SmartBear's Cisco study — still the most-cited data on this — found review defect-detection rates collapse past ~400 changed LOC: 70-90% defect detection at 200-400 LOC per 60-90 minutes, dropping to 28% at 1000+ LOC ([SmartBear Collaborator — Optimal Review Size](https://support.smartbear.com/collaborator/docs/working-with/concepts/optimal-size.html); [BSSw — Pull Request Size Matters](https://bssw.io/items/pull-request-size-matters)). Practical: if your diff crosses 400 net lines (excluding lockfiles, generated code, snapshot tests), split. One PR = one reviewable idea. If you can't name the PR without "and", it's two PRs.

---

## Commit Discipline

**Atomic commits.** Each commit should build, pass tests, and tell one story. "Refactor X to enable Y" is two commits: the pure refactor, then Y. This matters because `git bisect` only works if each commit is individually runnable, and reviewers read commit-by-commit on well-maintained repos.

## Conventional Commits

**Conventional Commits in the body too**, not just the PR title. If the repo squash-merges, the PR title becomes the commit — but if it uses rebase-merge or merge-commit, your individual commit messages land in history and should match the spec.

See also the Conventional Commits v1.0.0 spec referenced in §PR Anatomy: `<type>[scope]: <imperative description>`, where `type ∈ {feat, fix, docs, refactor, perf, test, build, ci, chore}` and `!` marks breaking changes.

**fixup + autosquash.** The killer workflow for addressing review feedback without polluting history: `git commit --fixup=<sha>` creates a commit titled `fixup! <original subject>`, then `git rebase -i --autosquash upstream/main` silently reorders it next to its target and flips its action to `fixup` ([thoughtbot — Auto-squashing Git Commits](https://thoughtbot.com/blog/autosquashing-git-commits); [Andrew Lock — Smoother rebases with auto-squashing](https://andrewlock.net/smoother-rebases-with-auto-squashing-git-commits/)). Set `git config --global rebase.autosquash true` so `-i` always does this. Net effect: you keep clean, atomic commits through any number of review rounds.

## DCO Sign-Off

**DCO sign-off.** `git commit -s` appends `Signed-off-by: Name <email>` asserting the four DCO clauses: original work, or derivative with rights, or third-party passthrough, and acknowledgement that the contribution is public record ([developercertificate.org](https://developercertificate.org/); [cert-manager — DCO Sign Off](https://cert-manager.io/docs/contributing/sign-off/)). This is **not** cryptographic — it's a text assertion. Linux kernel, Docker, GitLab, and many CNCF projects require it; GitHub's DCO App enforces it per-PR.

**GPG / SSH / Sigstore signing.** Separate from DCO. `git commit -S` (capital S) cryptographically signs the commit. GitHub shows "Verified" on signed commits ([GitHub Docs — Signing commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)). Modern option: **gitsign** from Sigstore gives you keyless signing via OIDC — no GPG keys to manage, signatures logged in Rekor transparency log ([sigstore/gitsign](https://github.com/sigstore/gitsign); [Sigstore docs — Gitsign](https://docs.sigstore.dev/cosign/signing/gitsign/)). Caveat: GitHub doesn't yet render gitsign signatures as "Verified" in the native UI.

**Rewriting history: before push vs after push.** Before push to your fork: rewrite freely — `rebase -i`, `commit --amend`, `reset --hard`, anything. After push, if someone else may have based work on your branch, rewriting is destructive. `git commit --amend --no-edit` followed by `git push --force` on a branch that has open reviewer comments on specific lines will **orphan those comments** on GitHub and silently invalidate the reviewer's mental model. Rule: once a PR has review comments, prefer new commits (especially fixup commits) over amends until just before merge.

**Force-push safety.** When you do need to force-push (after rebase onto upstream, after autosquash cleanup), always use `git push --force-with-lease` — it refuses the push if someone else has pushed to your branch in the meantime ([Atlassian — force-with-lease](https://www.atlassian.com/blog/it-teams/force-with-lease); [Adam Johnson — Force push safely](https://adamj.eu/tech/2023/10/31/git-force-push-safely/)). Even safer: `--force-if-includes` also verifies your local has seen the latest remote. Never use bare `--force` on shared branches.

---

## CLA Navigation

Four agreement flavors you will meet:

**DCO (Developer Certificate of Origin).** Linux Foundation artifact. Lightest weight. Contributor asserts via the `Signed-off-by` line; no separate signup ([FINOS — CLAs and DCOs](https://osr.finos.org/docs/bok/artifacts/clas-and-dcos)). Used by: Linux kernel, Docker, GitLab, Chef, many CNCF projects. Navigation: add `-s` to every commit or set `git config commit.gpgsign` globally; fix missing ones with `git rebase --signoff upstream/main`.

**Apache ICLA.** Individual Contributor License Agreement. Required before commit access to any ASF project. Download PDF, sign (hand or GPG), email to `secretary@apache.org` with the `.pdf.asc` attached ([ASF Contributor Agreements](https://www.apache.org/licenses/contributor-agreements.html); [Apache ShenYu — Sign ICLA Guide](https://shenyu.apache.org/community/icla/)). Typing your name is explicitly not signing. Apache does not accept links, only attachments. Expect 1-2 weeks for processing.

**Google / Microsoft CLA.** Bot-mediated: first PR to google/* or microsoft/* triggers a CLA-check bot that blocks merge until you click through an electronic CLA. Signing covers all future contributions to that org's repos. Individual vs Corporate variants; if your employer owns your OSS work, you need the corporate one signed by your legal team.

**Linux Foundation EasyCLA.** SaaS that automates CLA signing for LF-hosted projects (CNCF, OpenJS, LF AI, etc.) ([Linux Foundation — EasyCLA](https://docs.linuxfoundation.org/lfx/easycla); [LF — EasyCLA FAQs](https://docs.linuxfoundation.org/lfx/easycla/v2-current/getting-started/easycla-faqs)). Choose ICLA or CCLA flow; signing is electronic and tied to your GitHub identity.

**Detection heuristic.** Before opening a PR, scan: `CONTRIBUTING.md`, `DCO`, `CLA.md`, `.github/ISSUE_TEMPLATE/`, and the PR template for mentions of "Signed-off-by", "ICLA", "CLA bot", or a linked CLA URL. If the repo has a CLA bot, your first PR will tell you — but you'll save a round trip by pre-signing.

---

## Review Etiquette

**Respond to every comment.** Either: (a) push a fixup addressing it, then reply "Done in <sha>"; (b) reply with reasoning if you disagree and wait for consensus; (c) mark as `Outdated` / resolved only after the reviewer confirms. Never silently ignore a comment.

**Fixup commits > force-push-after-review.** Once review has started, prefer `git commit --fixup` over amending because fixups preserve reviewer comment anchoring. Roll them up with `git rebase -i --autosquash` only just before merge, ideally announced ("squashing for merge now").

**Re-requesting review.** GitHub's "Re-request review" button notifies the reviewer cleanly. Use it after you've addressed all comments — not after each individual fixup. Batch your responses.

**Merge method — who decides.** The repo maintainer controls which merge methods are enabled at the repository settings level ([GitHub Docs — About merge methods](https://docs.github.com/articles/about-merge-methods-on-github); [GitHub Docs — Configuring commit squashing](https://docs.github.com/articles/configuring-commit-squashing-for-pull-requests)). Three options: merge-commit (preserves history + merge bubble), squash-and-merge (collapses PR to one commit — most popular for product repos), rebase-and-merge (replays commits linearly — popular for libraries that value per-commit history). As a contributor, your commit hygiene should work under all three: clean atomic commits satisfy rebase-merge maintainers, a good PR title satisfies squash-merge maintainers.

---

## First-Time Contributor Playbook

Deterministic sequence for a new repo:

1. **Read** `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/*`. This is 10 minutes and saves hours ([GitHub Docs — Setting guidelines for repository contributors](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors)).
2. **Scan labels** for `good first issue` and `help wanted`. The former is curated for newcomers; the latter signals maintainers want help but the work may need context ([Kubernetes — Help Wanted and Good First Issue Labels](https://www.kubernetes.dev/docs/guide/help-wanted/); [GitHub Docs — Encouraging helpful contributions](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/encouraging-helpful-contributions-to-your-project-with-labels)). Aggregators: goodfirstissues.com, github-help-wanted.com, Up For Grabs.
3. **Study 3 recently-merged PRs.** Look at commit message style, PR body structure, how the author responded to review, how long it took to merge, who the reviewers were. You're calibrating the local dialect.
4. **Claim your issue** with a comment before coding ("I'd like to pick this up — plan is X"). Wait 24h for maintainer ack on anything non-trivial.
5. **Open small.** First PR should be ≤100 LOC. Earn trust, then scale up.
6. **Run the project's tests and lint** before pushing. Nothing signals "I read the docs" like green CI on the first push.

---

## Maintainer Psychology

**Evan You (Vue).** Vue's contributing guide makes two asks explicit: target the right branch (`main` vs `minor` based on whether you add API surface), and "tick the 'Allow edits from maintainers' box" so maintainers can nudge your PR without a round trip ([Vue core contributing guide](https://github.com/vuejs/core/blob/main/.github/contributing.md)). Implicit: respect established conventions; large stylistic PRs that churn files add noise to `git blame` and are rejected.

**Rich Harris (Svelte).** Harris has framed Svelte's philosophy as opinion-driven: "We don't work on Svelte for the sake of adoption. We work on it because we have an idea in our heads about what the right way to build apps is" ([Vercel — The future of Svelte](https://vercel.com/blog/the-future-of-svelte-an-interview-with-rich-harris)). Translation for contributors: PRs that align with the stated philosophy get welcomed; PRs that add features "because React has them" get closed.

**Sindre Sorhus.** Runs a factory of small, focused npm packages — "Lego bricks that can be assembled" ([freeCodeCamp — Interview with Sindre Sorhus](https://www.freecodecamp.org/news/sindre-sorhus-8426c0ed785d/)). His issue/PR templates are strict; deviations get closed without comment. He's also public about "kill them with kindness" toward toxic contributors and strong emotional boundaries — don't be the reason someone invokes that.

**Anthony Fu (Antfu).** Maintains Vitest, VueUse, UnoCSS, Slidev, and core contributions to Vue/Nuxt/Vite. Has written publicly about maintainer self-expectation and pressure, and recommends "turning off push notifications and proactively checking issues when ready" ([Anthony Fu — Mental Health in Open Source](https://antfu.me/posts/mental-health-oss)). Practical implication: don't @-mention maintainers for status; don't bump issues; trust their queue.

**Universal pattern across these maintainers:** welcome = small, philosophy-aligned, tested, rebased, polite. Rejected = large, "just copied from framework X", untested, force-pushed over review comments, entitled in tone.

---

## Case Studies and Programs

**Sindre Sorhus's prolific pattern.** Thousands of tiny Unix-philosophy npm packages, each with strict scope. Lesson for contributors: match the scope. A PR adding options to `sindresorhus/is-odd` that make it also do even numbers will be closed.

**Antfu's maintain-many style.** Heavy use of bots (renovate, changesets), ESLint configs that auto-fix on commit, aggressive use of `stale-bot` on old issues. Contributors are expected to let CI autofix formatting rather than argue style.

**Linus's Signed-off-by culture.** The Linux kernel invented the DCO sign-off after the SCO lawsuits to establish a paper trail of contribution provenance. The kernel workflow is email-patch-based (`git format-patch` + `git send-email`), but GitHub adopted the semantic — the `-s` flag and DCO bot are the direct descendants ([developercertificate.org](https://developercertificate.org/); [wking/signed-off-by — DCO split out](https://github.com/wking/signed-off-by)).

**First Timers Only / Up For Grabs / Outreachy / Hacktoberfest.** Four adjacent programs with different rules:
- First Timers Only ([firsttimersonly.com](https://www.firsttimersonly.com/)): tagged issues explicitly for never-before contributors; extreme hand-holding expected.
- Up For Grabs (up-for-grabs.net): aggregator of projects seeking help; less beginner-specific.
- Outreachy: paid internships for underrepresented contributors; multi-month mentored work, not drive-by PRs.
- Hacktoberfest: October challenge; quality bar rose hard after the 2020 spam incident. Current rules disqualify contributors with 2+ spam PRs, and low-effort whitespace/typo PRs are explicitly banned ([Hacktoberfest 2025 Participation rules](https://hacktoberfest.com/participation/); [LinearB — Surviving Hacktoberfest PR overload](https://linearb.io/blog/how-to-survive-the-pr-overload-from-hacktoberfest)). If you're contributing in October, the "quality not quantity" principle is doubly enforced.

---

## Top 10 Habits of Effective Contributors

1. **Fork with `gh repo fork --clone --remote`; keep `upstream` synced weekly.** Stale forks produce stale PRs.
2. **Open an issue before a non-trivial PR.** Cheap alignment check beats rejected work.
3. **Write minimal reproducible examples.** Strip until removing any line hides the bug.
4. **Keep PRs under 400 LOC net.** Split on "and" — one idea per PR.
5. **Use Conventional Commits and imperative mood** in titles and commit messages, even if unenforced.
6. **Sign off every commit with `-s`** when DCO is in play; detect CLA requirements before first push.
7. **Address feedback with `--fixup` commits, not `--amend --force`** while review is live; autosquash at the end.
8. **Force-push only with `--force-with-lease`**, never bare `--force`, never on shared branches.
9. **Study three recent merged PRs before opening yours** — match the local dialect of title, body, and commit granularity.
10. **Respect maintainer time and philosophy** — no bumps, no @-mentions for status, no "copied from framework X" PRs; align with stated project direction or walk away.
