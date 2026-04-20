# Contributing to repo-craft

Thanks for your interest! This skill is early (v0.1.0), so contributions are welcome — especially around the 8 deferred profiles and edge cases in reference anchor resolution.

## How to contribute

1. **Open an issue first** for anything non-trivial. Drive-by doc typo fixes can go straight to a PR.
2. **Keep PRs small** — under 400 LOC net where possible.
3. **One concern per PR.** No mixing profile-additions with infra refactors.

## Running tests

```bash
bash lib/sniff.test.sh
bash lib/load-ref.test.sh
bash lib/memory.test.sh
bash e2e.sh
```

All four must pass before requesting review.

## Adding a profile

1. Add `playbooks/NN-<name>.md` with YAML frontmatter listing `requires_refs` and `requires_skills`.
2. Reference the playbook from `SKILL.md` under the Profile Selection table and add a `Profile NN — <name>` anchor section.
3. Add the profile row to `README.md`'s profile status table.
4. If the playbook references a new anchor (e.g. `10#my-new-section`), add it to the reference file and verify with `bash lib/load-ref.sh 10#my-new-section`.

## Instrumenting a new reference file

1. Drop the raw content at `references/NN-<name>.md`.
2. Prepend a `> **Consult this if:**` block and a `## Table of Contents` listing critical anchors.
3. Normalize H2 headings so the slug rule (lowercase, strip punctuation, spaces→dashes) produces the expected anchor.
4. Add a row to `references/INDEX.md`.
5. Verify each declared anchor resolves with `bash lib/load-ref.sh NN#<anchor>`.

## Commit style

[Conventional Commits](https://www.conventionalcommits.org/). Scope matches the directory: `feat(lib)`, `feat(references)`, `feat(playbook)`, `feat(skill)`, `feat(install)`, `test`, `docs`, `chore`.

## Non-goals

- Hooks / custom slash commands / MCP servers — this is a **skill**, not a plugin. Don't add harness machinery.
- Absorbing other skills' logic. Call `commit` / `create-pr` / `pr-writer` / etc. — don't inline their behavior.
- Drive / cloud sync daemons. Runtime is local.
