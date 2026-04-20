# Security Policy

## Scope

`repo-craft` is a Claude Code skill that executes local shell commands and invokes `gh`/`git`. It does **not** expose a network service, accept untrusted remote input, or persist credentials.

## Reporting a vulnerability

If you find a security issue — especially a code-injection path in a playbook, a path-traversal in `lib/load-ref.sh`, or a state-file poisoning vector in `lib/remember.sh` — please **do not** open a public issue.

Email the maintainer directly (see the commit history for contact), or use GitHub's **Report a vulnerability** feature under the Security tab.

Response SLA: best-effort within 7 days. This is a personal project; no formal incident-response process.

## What counts

- Command injection via untrusted arguments into any of the lib scripts
- Path traversal escaping `$REPO_CRAFT_STATE_DIR` or `$REPO_CRAFT_REFS_DIR`
- State file (JSON) tampering that leads to arbitrary code execution
- Accidental credential exfiltration by a playbook (e.g. leaking `$GH_TOKEN` into a state file)

## What doesn't

- The skill reading files under `~/.claude/skills/repo-craft/` — that's by design.
- The skill invoking `gh` CLI on the user's behalf — that's the point.
- Insecure defaults in the user's own repo that `repo-craft` merely reports on (profile 09).

## Supported versions

Only `main` (latest tag). Older tags are not patched.
