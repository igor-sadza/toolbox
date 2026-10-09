---
name: runbook
description: Use when creating, updating, or reviewing operational playbooks or runbooks for setup, deployment, maintenance, recovery, or troubleshooting with actionable commands, expected results, and verification.
---

# Operational Playbooks

Load `documentation` for routing: procedures belong under `docs/playbooks/`, with
topic subdirectories only when useful. Preserve existing locations unless migration
is requested. Link to reference settings and architecture instead of copying them.
Read only relevant scripts, configuration, and tool references.

## Procedure

1. **Prerequisites:** objective, environment, tools, access, working directory, shell, and necessary backups.
2. **Commands:** numbered steps with copy-paste-ready, language-tagged blocks. Prefer repository scripts or documented tool commands; no invented flags, prompt symbols, or unexplained ellipses.
3. **Expected results:** observable outcome for meaningful steps; distinguish expected from observed.
4. **Verification:** concrete commands, success criteria, and when to stop on failure. Configuration alone is not proof of operation.
5. **Troubleshooting:** relevant symptoms, evidenced causes, diagnostics, corrections, and recovery limits.

Use documented placeholders with quoted assignments, never secrets or unquoted
angle brackets. Clearly label destructive commands with target, impact, approval,
and recovery limits; prefer supported dry runs.

Writing a command is not permission to execute it. Deployments, destructive actions,
and live-environment changes require explicit approval. Report unverified commands
and outcomes; link to background instead of repeating it.
