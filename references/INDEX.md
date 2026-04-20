# References Index

Master map of all `repo-craft` reference material. Files load on-demand via `lib/load-ref.sh`; this INDEX is always loaded first at ~2k tokens.

## Reference files (13 in v0.1)

| # | File | One-liner | Consult when |
|---|------|-----------|--------------|
| 01 | [repo-management.md](./01-repo-management.md) | Owner playbook: 10 actionable practices | Setting up or auditing your own repo |
| 02 | [contribution.md](./02-contribution.md) | 10 habits of effective contributors | Preparing a PR to someone else's repo |
| 03 | [tooling.md](./03-tooling.md) | CLI tools + 16 candidate skills | Choosing dependencies or planning tool adoption |
| 04 | [sources.md](./04-sources.md) | 46-entry external source map | Citing canonical docs or verifying guidance |
| 05 | [methodology-business.md](./05-methodology-business.md) | Methodology × license → decision rules | Assessing repo posture before committing to contribute |
| 06 | [archaeology-author.md](./06-archaeology-author.md) | Pre-PR ritual + author mind-modeling | Preparing first non-trivial PR to a new repo |
| 07 | [adjacent.md](./07-adjacent.md) | 30-row trigger map (lifecycle, security, human, legal, hygiene) | When an adjacent signal appears |
| 08 | [influence.md](./08-influence.md) | 9-rung ladder + 10 anti-patterns | Planning long-term contribution arc |
| 09 | [repo-as-data.md](./09-repo-as-data.md) | 26-artifact checklist + health query pack | Auditing or organizing a repo |
| 10 | [templates.md](./10-templates.md) | 15-section template library (PR/issue/ADR/RFC/CHANGELOG/etc.) | Writing any artifact |
| 14 | [maintainer-profiles.md](./14-maintainer-profiles.md) | 8 maintainer case studies + meta-analysis | Before first PR to a maintainer you don't know |
| 15 | [security.md](./15-security.md) | Repo security + AI-era + PQC readiness | Any security-sensitive decision |
| 16 | [security-sources.md](./16-security-sources.md) | 104 security-specific canonical sources | Citing security guidance |

## Profile → Refs table

| Profile | Primary refs loaded |
|---------|---------------------|
| 02-first-time-contributor | 02, 06, 08, 10, 14 |
| 07-fork-contribute | 02, 07, 11 (11 in v0.2) |
| 08-upstream-sync | 07, 11, 12 (11 & 12 in v0.2) |
| 09-own-repo-health-audit | 01, 09, 11 (11 in v0.2), 15 |

*(Other profiles route to "not yet implemented" in v0.1.)*

## Keyword index (abbreviated; full in §3 of each reference)

| Topic | Ref → Anchor |
|-------|--------------|
| Branch protection | 01#branch-protection |
| CODEOWNERS | 01#codeowners |
| Release automation decision | 01#release-automation, 05#release-tool-decision |
| CLA / DCO | 02#dco-sign-off, 05#cla-types |
| Conventional Commits | 02#conventional-commits |
| Author mind-modeling | 06#author-mind-model |
| 10-step pre-PR ritual | 06#pre-pr-ritual |
| Influence ladder | 08#influence-ladder |
| Anti-patterns | 08#anti-patterns |
| SBOM / SLSA | 15#supply-chain, 16#supply-chain |
| Post-Quantum crypto | 15#post-quantum, 16#post-quantum |
| Maintainer profiles | 14 |

## Loading convention

Playbooks declare required refs in frontmatter:

```yaml
requires_refs:
  - "02"
  - "06#pre-pr-ritual"
  - "14"
```

The orchestrator calls `lib/load-ref.sh` for each — loading only the cited section for anchored entries, full file otherwise.
