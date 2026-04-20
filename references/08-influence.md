> **Consult this if:** planning a long-term contribution arc, choosing tactics to build trust with maintainers, or auditing your own behavior for anti-patterns.
>
> **Cross-refs:** [02](./02-contribution.md) · [06](./06-archaeology-author.md) · [14](./14-maintainer-profiles.md)

## Table of Contents

- [Influence Ladder](#influence-ladder)
- [Influence Tactics](#influence-tactics)
- [Anti-Patterns](#anti-patterns)
- [Strategic Influence](#strategic-influence)
- [Contribution as Portfolio](#contribution-as-portfolio)

---

# 08 — Contribution as Influence

*Research slice for the GitHub repo-management + contribution skill. Focus: the soft-power layer that turns a contributor into a trusted voice, and eventually into a maintainer or co-owner of a project's direction.*

Most "how to contribute" guides stop at technical etiquette — fork, branch, signed commits, conventional commit messages, CONTRIBUTING.md. That is table stakes. What actually determines whether a contributor's ideas get shipped, whose PRs get fast-tracked through review, and who gets invited into the governance conversation is a separate, largely informal system of **reputation, labor visibility, and trust accrual**. This document maps it.

---

## Influence Ladder

Healthy OSS projects exhibit a remarkably consistent progression. The explicit ladders codified by the Kubernetes and CNCF communities are the clearest public examples, but the same shape appears in Rust, Python, React, Node, and the Linux kernel. Stage durations are empirical medians from maintainer-authored essays and project governance documents; they vary wildly by project intensity.

### Rung 1 — Drive-by Bug Reporter
**What it looks like:** First issue filed. No prior footprint.
**Duration:** single interaction.
**Moves you up:** writing a *reproducible* report (minimal repro, version info, expected vs actual) rather than "doesn't work, please fix." Maintainers remember reproducers for months. See Kubernetes' issue triage guide which explicitly rewards `/kind bug` reporters whose issues become PRs ([kubernetes/community issue-triage](https://github.com/kubernetes/community/blob/master/contributors/guide/issue-triage.md)).

### Rung 2 — First-time Patch Contributor
**What it looks like:** A merged PR, usually a typo/doc/test fix from a `good first issue` label.
**Duration:** days to weeks after the first issue.
**Moves you up:** the second and third PR, landed without maintainer hand-holding. GitHub's "first-time contributor" badge appears on PRs automatically. Kubernetes requires 2 LGTMs and active participation for 3+ months before promotion ([kubernetes/community community-membership.md](https://github.com/kubernetes/community/blob/master/community-membership.md)).

### Rung 3 — Regular Contributor
**What it looks like:** ~5–10 merged PRs, name recognized by maintainers, mentioned in release notes.
**Duration:** 3–12 months of sustained activity.
**Moves you up:** demonstrated judgement on non-trivial changes, helpful comments on *other people's* PRs, consistent responsiveness to review feedback. This is the rung at which Kubernetes formally admits you as a "Member" with `/lgtm` privileges ([kubernetes community-membership.md §Member](https://github.com/kubernetes/community/blob/master/community-membership.md)).

### Rung 4 — Trusted Contributor
**What it looks like:** Tagged on related issues, pinged for review by area owners, treated as a peer in design discussion. May hold the floor in a GitHub Discussion or Discord channel.
**Duration:** 1–2 years typical.
**Moves you up:** authoring your first accepted design document (RFC, PEP, KEP) — this is the qualitative leap from "someone who writes code" to "someone who shapes what code gets written."

### Rung 5 — Triager / Helper
**What it looks like:** Regularly labels, deduplicates, reproduces, and closes others' issues. Answers newcomer questions. Kubernetes SIGs have an explicit "triage role" independent of code contributions.
**Duration:** can overlap rungs 3–4; some contributors specialize here.
**Moves you up:** consistent triage labor is one of the fastest routes to reviewer status because it demonstrates judgement at scale. The CNCF TAG Contributor Strategy explicitly names non-code labor as promotion-qualifying ([cncf/tag-contributor-strategy contributor-growth](https://github.com/cncf/tag-contributor-strategy/blob/main/contributor-growth/README.md)).

### Rung 6 — Reviewer
**What it looks like:** Listed in an `OWNERS` file as a reviewer for a subpath. Can `/lgtm` PRs in scope; carries non-binding but weighted opinion.
**Duration:** 1.5–3 years from first PR.
**Moves you up:** Kubernetes documents this explicitly — reviewers must be members for 3+ months, have reviewed 5+ PRs primarily, be knowledgeable about the subproject ([kubernetes community-membership.md §Reviewer](https://github.com/kubernetes/community/blob/master/community-membership.md)).

### Rung 7 — Committer / Approver
**What it looks like:** Merge rights. Listed as `approvers` in `OWNERS`. Can land your own PRs with only peer LGTM. Kubernetes calls this "Approver"; many projects call it "Committer."
**Duration:** 2–4 years.
**Moves you up:** "holistic acceptance of a contribution including backwards/forwards compatibility, API conventions, subtle performance and correctness, interactions with other parts of the system" ([kubernetes community-membership.md §Approver](https://github.com/kubernetes/community/blob/master/community-membership.md)).

### Rung 8 — Co-maintainer
**What it looks like:** Shares the roadmap decision. Named in README/MAINTAINERS. Has a vote on new committer nominations. In Kubernetes terms, "Owner" / top-level OWNERS file entry; in CNCF's template governance, a "maintainer" who votes on TOC representation ([cncf project-template GOVERNANCE-maintainer.md](https://github.com/cncf/project-template/blob/main/GOVERNANCE-maintainer.md)).
**Duration:** 3–6 years typical.
**Moves you up:** being the obvious successor — deep historical context, trusted across subgroups, willing to do the un-fun work (security, release management, governance paperwork).

### Rung 9 — BDFL Successor / TSC / Steering Council Member
**What it looks like:** Named in the project's governance doc as holding formal roadmap authority. Python's 5-person Steering Council ([PEP 13](https://peps.python.org/pep-0013/), [PEP 8016](https://peps.python.org/pep-8016/)), Rust's Leadership Council, the Node.js TSC, a CNCF TOC seat. Typically elected by the current maintainer pool.
**Duration:** 5+ years of high-trust work.
**Moves you up:** nothing — this is the top for contribution-ladder purposes; lateral moves are to foundation board seats or project founding.

**Real examples:**
- **Guido van Rossum → Python Steering Council:** stepped down as BDFL in 2018; governance model codified in [PEP 13](https://peps.python.org/pep-0013/). Now a regular member.
- **Kohsuke Kawaguchi (@kohsuke):** Hudson → Jenkins founder, archetypal BDFL-through-fork story ([Wikipedia: Jenkins](https://en.wikipedia.org/wiki/Jenkins_(software))).
- **Michael "Monty" Widenius (@montywi):** MySQL core dev → MariaDB founder after Oracle acquisition ([Wikipedia: Michael Widenius](https://en.wikipedia.org/wiki/Michael_Widenius)).
- **Andrew "BurntSushi" Gallant:** ripgrep author, long-standing Rust libs contributor, Rust moderation team — exemplar of rising through code + review labor ([rust-lang/team#671](https://github.com/rust-lang/team/pull/671)).

---

## Influence Tactics

Ranked roughly by return-on-effort for trust accrual.

### 1. Issue Quality as Reputation
A well-scoped issue with a minimal repro is worth five sloppy PRs. Maintainers triage dozens of issues per week; the ones with a git-bisected commit, a runnable test case, and a clean write-up get remembered — and the author gets the benefit of the doubt on future contributions. **Failure mode:** escalating frustration in thread comments when a reproducer isn't instantly fixed.

### 2. Review Labor (the single best ROI move)
Reviewing others' PRs — generously, substantively, and before being asked — is the fastest path to being reviewed yourself. Kubernetes requires "primary reviewer for at least 5 PRs" before reviewer promotion ([community-membership.md](https://github.com/kubernetes/community/blob/master/community-membership.md)); Rust's team promotion criteria cite "mentoring and the path to team membership" as a cross-cutting concern ([aturon.github.io: Refining Rust's RFCs](https://aturon.github.io/blog/2016/07/05/rfc-refinement/)). **Failure mode:** drive-by "LGTM" on areas you don't understand; nitpicking style in PRs from people below your rung.

### 3. Triage Labor
Labeling, deduplicating, reproducing other people's bugs. Thankless but highly visible to maintainers. CNCF's TAG Contributor Strategy explicitly calls out non-code contributions as promotion-qualifying ([cncf tag-contributor-strategy](https://github.com/cncf/tag-contributor-strategy/blob/main/contributor-growth/README.md)). **Failure mode:** closing issues prematurely as "can't reproduce."

### 4. RFC / Design-Doc Authorship
The qualitative jump from contributor to shaper. All major projects have an analog:
- **Rust RFCs:** [rust-lang/rfcs](https://github.com/rust-lang/rfcs), process defined in [RFC 0002](https://rust-lang.github.io/rfcs/0002-rfc-process.html). Requires pre-discussion on Zulip/internals before submission.
- **Python PEPs:** [PEP 1](https://peps.python.org/pep-0001/) mandates that non-core-dev authors find a core sponsor.
- **Kubernetes KEPs:** [kubernetes/enhancements](https://github.com/kubernetes/enhancements/blob/master/keps/README.md) — formal SIG review, required for any enhancement touching GA.
- **TC39 Proposals:** 5 stages, 0→4; a "champion" (TC39 delegate) is mandatory ([tc39/how-we-work champion.md](https://github.com/tc39/how-we-work/blob/main/champion.md)).
- **React RFCs:** adopted 2017 following Rust's model ([InfoQ: React Adopts RFC Process](https://www.infoq.com/news/2017/12/react-rfc-process/)).

What makes an RFC succeed: motivation section grounded in real user pain, explicit alternatives considered, drawbacks honestly listed, prior art from other languages/projects, *conservative* scope ([rust-lang.github.io/rfcs](https://rust-lang.github.io/rfcs/)). What makes it fail: "wouldn't it be cool if" without evidence of demand; arguing in the comments instead of updating the doc.

### 5. Discussion Participation — "Lurk First, Speak Once You Understand"
Mailing lists, Discourse, Discord, GitHub Discussions. Read 100 threads before posting in one. When you post, add signal: link prior art, summarize the disagreement, quote the spec. Rust's internals forum and Python's discuss.python.org are the canonical watering holes for would-be RFC/PEP authors.

### 6. Documentation Contributions
Underwatched and highly welcomed. Many maintainers are privately desperate for doc PRs. It's also the gateway drug to deep code work — you can't document a subsystem without reading its source. Google's "Season of Docs" ([developers.google.com/season-of-docs](https://developers.google.com/season-of-docs)) is a structured version of this path.

### 7. Test + Benchmark Contributions
Low risk, high trust. Adding tests for existing behavior exposes assumptions; benchmark suites make you the go-to person for perf work. Rust's perf.rust-lang.org ecosystem turned several benchmark-curious contributors into compiler team members.

### 8. Sponsor Other Contributors
Re-review first-time PRs kindly. Answer newcomer questions in Discussions. Write tutorials that cite the project. This is the "middle-management" move that maintainers notice without being told. CNCF's "maintainers-circle" program explicitly rewards this ([cncf tag-contributor-strategy maintainers-circle](https://github.com/cncf/tag-contributor-strategy/blob/main/maintainers-circle/README.md)).

### 9. Write Publicly About the Project
Blog posts, conference talks, YouTube explainers. Brings users, which brings maintainer goodwill. Julia Evans (@jvns)' deep-dive posts on tools she doesn't maintain have earned her reviewer-adjacent status on several projects. Risk: inaccurate posts attributed to the project damage trust.

### 10. Backport + LTS Work
Unglamorous. Fixing CVEs on the 3.8 branch when everyone's on 3.12. Veteran maintainers notice immediately — you're saving *their* reputational debt. Python, Node, and the Linux kernel all have LTS contributors who moved straight into committer roles via this path.

### 11. Security Disclosure
Private, responsible, credited. A well-handled CVE on a project earns more trust than ten feature PRs. All major projects have SECURITY.md with a disclosure address. GitHub's Security Advisories feature provides a structured channel.

### 12. Community Programs
Structured trust pathways:
- **Google Summer of Code:** paid mentorship, 185 mentoring orgs in 2026 ([summerofcode.withgoogle.com](https://summerofcode.withgoogle.com/), [opensource.googleblog.com GSoC 2026](https://opensource.googleblog.com/2026/01/mentor-org-applications-for-google-summer-of-code-2026-open-through-feb-3.html)).
- **Outreachy:** focused on underrepresented groups, twice yearly.
- **Hacktoberfest:** opt-in only since 2020 after the spam crisis (see Part C).
- **Season of Docs:** Google's docs-contribution program.

---

## Anti-Patterns

The fastest ways to burn reputation.

### 1. Status-bumping ("+1", "any update?", "please merge")
Adds no signal, pings every watcher, burns goodwill. Use emoji reactions. If a PR is stale, ask *what you can do to unblock it*.

### 2. @-Mentioning Maintainers Directly
Especially across repos or on weekends. Maintainers are drowning. The Rust moderation team's resignation letter cited pattern-of-behavior from the core team that included inappropriate escalation tactics ([rust-lang/team#671](https://github.com/rust-lang/team/pull/671), [The Register: Rust moderation team quits](https://www.theregister.com/2021/11/23/rust_moderation_team_quits/)).

### 3. Reopening Rejected PRs / Relitigating Decisions
If an RFC was declined, don't open a sibling RFC three weeks later. Accept the decision or take it to the pre-RFC forum.

### 4. Lecturing Maintainers on Their Own Project
Explaining Git to Linus. Explaining React internals to Dan Abramov. Near-universal reputation-killer.

### 5. Unsolicited Large Rewrites
The "I rewrote your parser, please merge" PR. Impossible to review, signals disrespect for the existing author's decisions. Always open an issue first for anything >~200 lines.

### 6. Drive-by LGTM Outside Your Expertise
Approving a PR in a subsystem you've never touched. Devalues the LGTM signal. Kubernetes reviewer guidance explicitly warns against this ([kubernetes community-membership.md](https://github.com/kubernetes/community/blob/master/community-membership.md)).

### 7. Litigating CODE_OF_CONDUCT in Technical Threads
Mixing governance disputes into PR reviews. Forces maintainers to wear moderator hats mid-technical-work. The Rust moderation crisis of 2021 showed how even *maintainers* doing this can fracture a project ([thenewstack.io: Rust Mod Team Resigns](https://thenewstack.io/rust-mod-team-resigns-in-protest-of-unaccountable-core-team/)).

### 8. Political Pressure / Brigading
Recruiting outsiders to push a decision. Visible, reversible, reputation-ending.

### 9. Protestware / Sabotage
The nuclear option. Near-instantaneous permanent exile.
- **Marak Squires / colors.js + faker.js (Jan 2022):** deliberately pushed an infinite loop to libraries with 3.3B+ lifetime downloads to protest unpaid corporate use. GitHub suspended his account; the community forked both packages ([Sonatype](https://www.sonatype.com/blog/npm-libraries-colors-and-faker-sabotaged-in-protest-by-their-maintainer-what-to-do-now), [BleepingComputer](https://www.bleepingcomputer.com/news/security/dev-corrupts-npm-libs-colors-and-faker-breaking-thousands-of-apps/)).
- **Brandon Nozaki Miller / node-ipc peacenotwar (Mar 2022):** CVE-2022-23812 — the package wiped files on systems geolocated to Russia/Belarus. Supply-chain damage to Vue.js and dependents ([Snyk](https://snyk.io/blog/peacenotwar-malicious-npm-node-ipc-package-vulnerability/), [CNCF TAG Security catalog](https://tag-security.cncf.io/community/catalog/compromises/2022/node-ipc-peacenotwar/)).

### 10. Speculative Feature PRs Without Roadmap Alignment
Opening a 2000-line PR for a feature no maintainer has signaled wanting. Burns your time, burns their review time, teaches you nothing about roadmap signal-reading.

---

## Strategic Influence

### 1. Roadmap Alignment
Before you contribute *anything* non-trivial, read:
- The project's pinned issues and milestones.
- The most recent conference talk by a maintainer (YouTube).
- The last 3 months of blog posts on the project site.
- Any roadmap.md, ROADMAP, or GitHub Projects board.

Volunteer for what the *maintainer wants to ship*, not what you want them to ship. Rust's pre-RFC practice on internals.rust-lang.org exists precisely to filter this ([internals.rust-lang.org](https://internals.rust-lang.org/)).

### 2. Corporate Sponsorship Dynamics
When a company pays a maintainer via GitHub Sponsors, Tidelift, Open Collective, or direct employment, roadmaps shift. GitHub Sponsors has directed $40M to maintainers as of 2024 ([blog.opencollective.com](https://blog.opencollective.com/github-sponsors-for-companies-open-source-collective-for-people/)). Tidelift pays thousands of maintainers to adopt secure-development practices ([socket.dev: Sonar to Acquire Tidelift](https://socket.dev/blog/sonar-to-acquire-tidelift)).

Ethical sponsored-contribution tactics: disclose the employer in PR descriptions; avoid pushing changes that benefit your employer but not the project; don't use sponsorship as implicit pressure. Unethical: "our enterprise customers need this" as the only justification.

### 3. RFC Authorship Pipeline
The consistent shape across Rust, Python, Kubernetes, TC39:
1. **Pre-discussion** on an informal forum (Zulip, Discourse, Discord).
2. **Draft** shared informally for feedback.
3. **Formal PR** to the RFC repo.
4. **Extended comment period** (usually 10+ days).
5. **Final Comment Period** with team sign-off.
6. **Merge → implementation tracking issue**.

What makes RFCs succeed: existing implementation or prototype; demonstrated user demand; one well-scoped idea; co-authors from multiple companies/geographies ([rust-lang.github.io/rfcs](https://rust-lang.github.io/rfcs/), [aturon.github.io](https://aturon.github.io/blog/2016/07/05/rfc-refinement/)).

### 4. Fork-to-Replace Pattern
Legitimate when the project is abandoned or the license is changed adversarially. Hostile when a community split would fragment a healthy ecosystem. Key case studies:

- **Hudson → Jenkins (2011):** Oracle's trademark grab after the Sun acquisition. Community vote overwhelming for rename. Jenkins is now the canonical project; Hudson was donated to Eclipse and collapsed ([Wikipedia: Hudson](https://en.wikipedia.org/wiki/Hudson_(software)), [The Register](https://www.theregister.com/2011/02/01/oracle_hudson_fork/)).
- **OpenOffice → LibreOffice (2010):** Document Foundation spin-off after Oracle's Sun acquisition. LibreOffice now dominant; Apache OpenOffice has minimal development ([opensource.com: LibreOffice history](https://opensource.com/article/18/9/libreoffice-history)).
- **MySQL → MariaDB (2009):** Monty Widenius started MariaDB *the day* Oracle announced the Sun deal ([Wikipedia: Michael Widenius](https://en.wikipedia.org/wiki/Michael_Widenius)).
- **Node.js → io.js → Node.js (2014–2015):** governance fork reconciled under the Linux Foundation's Node Foundation; merger at Node 4.0 ([The Register: Node reunites with io.js](https://www.theregister.com/2015/09/09/node_js_v400_reunites_with_io_js/)). The textbook *reconciliation* case.
- **Elasticsearch → OpenSearch (2021):** Elastic moved to SSPL + Elastic License; AWS forked and donated to the Linux Foundation ([aws.amazon.com/what-is/opensearch](https://aws.amazon.com/what-is/opensearch/), [Wikipedia: SSPL](https://en.wikipedia.org/wiki/Server_Side_Public_License)). Elastic eventually re-added AGPLv3 in 2024.
- **Terraform → OpenTofu (2023):** HashiCorp's move to BSL triggered the Manifesto (Aug 15), fork (Aug 25), Linux Foundation acceptance (Sep 20), 1.6 stable (Jan 2024) ([opentofu.org/blog](https://opentofu.org/blog/opentofu-announces-fork-of-terraform/)).
- **Redis → Valkey (2024):** Redis moved from BSD to dual RSALv2/SSPL; six senior engineers from AWS/Google/Oracle/Ericsson forked to Valkey under Linux Foundation. 83% of large Redis users adopted or tested Valkey within the first year ([linuxfoundation.org: A Year of Valkey](https://www.linuxfoundation.org/blog/a-year-of-valkey), [thenewstack.io: How the Valkey Team Knew](https://thenewstack.io/how-the-team-behind-valkey-knew-it-was-time-to-fork/)). Redis re-added AGPLv3 in 2024 in response.

Pattern: license relicensing from permissive to source-available almost universally triggers a credible fork within 6 weeks, with a foundation-backed landing within 6 months.

### 5. Upstream-First vs Downstream-Patch Strategy
Kernel vendor-tree pattern: carry patches locally for speed, but upstream aggressively to avoid carrying cost forever. Companies that hold patches downstream (classic early Android) pay perpetual merge tax; companies that upstream everything (classic Red Hat) build influence. The CNCF Contributor Strategy TAG explicitly recommends upstream-first as the sustainable path ([cncf/tag-contributor-strategy](https://github.com/cncf/tag-contributor-strategy)).

---

## Contribution as Portfolio

For individuals:
- **Track-record visibility:** GitHub profile contribution graph, pinned repos, README "Acknowledgements" sections, CHANGELOG attributions, conference bio "contributor to X, Y, Z."
- **Public attribution patterns:** `Co-authored-by:` trailers, `Reviewed-by:` in Linux-kernel-style projects, release-notes shout-outs, "Contributor of the Month" programs (Kubernetes and Rust both have them).
- **Long-term arc:** 5-year involvement at one project > 5-month involvement at ten. Maintainership is a trailing indicator of sustained presence.

For companies:
- **Ethical positioning:** what NOT to extract. Don't hire away a solo maintainer and leave the project vendored. Don't relicense without community consultation (Hashi, Elastic, Redis all paid reputational cost).
- **Visible sponsorship:** GitHub Sponsors badge on profile; Open Collective backer listing; employees visible in commit logs under `@company.com` addresses.
- **Staff allocation:** 20% time; dedicated OSPO staff; "upstream first" mandates. Google, Meta, Microsoft, Red Hat, AWS all publish their top OSS-contributing-employees as a recruiting signal.
- **Neutral foundation contributions:** donating trademarks/code to CNCF, Apache, Linux Foundation preempts the "hostage-taking" criticism that triggered the Terraform and Redis forks.

---

## Influence Ladder Summary (9 Rungs)

1. Drive-by bug reporter
2. First-time patch contributor
3. Regular contributor
4. Trusted contributor (RFC-authoring privileges)
5. Triager / helper
6. Reviewer (LGTM authority in a subpath)
7. Committer / approver (merge rights)
8. Co-maintainer (roadmap vote)
9. BDFL successor / TSC / Steering Council member

## Top 10 Influence Tactics

1. **Issue quality as reputation** — minimal repros outperform sloppy PRs.
2. **Review labor** — generous review of others' PRs is the single highest-ROI trust move.
3. **Triage labor** — labeling, dedup, reproduction; invisible to outsiders, obvious to maintainers.
4. **RFC / design-doc authorship** — the qualitative leap from "coder" to "shaper."
5. **Lurk-then-speak discussion participation** — earn quota before spending it.
6. **Documentation contributions** — undervalued, welcomed, gateway to deep work.
7. **Test + benchmark contributions** — low risk, high trust.
8. **Sponsor other contributors** — re-review newcomers kindly; answer their questions.
9. **Public writing about the project** — brings users, brings goodwill.
10. **Backport + LTS + security-disclosure work** — unglamorous, veteran-trust-building.

## Top 10 Anti-Patterns

1. **Status-bumping** — "+1", "any update?", "please merge" comments.
2. **@-mentioning maintainers** across repos or on weekends.
3. **Reopening rejected PRs** or relitigating declined RFCs.
4. **Lecturing maintainers** on their own project's design.
5. **Unsolicited large rewrites** — PRs >200 lines without a prior issue.
6. **Drive-by LGTM** on areas outside your expertise.
7. **Litigating CODE_OF_CONDUCT** inside technical threads.
8. **Political pressure / brigading** — recruiting outsiders to push a decision.
9. **Protestware / sabotage** — Marak-style (colors.js/faker.js) or node-ipc-style permanent exile.
10. **Speculative feature PRs** with no roadmap alignment — burns your time and theirs.
