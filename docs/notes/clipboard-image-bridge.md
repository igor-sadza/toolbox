# Clipboard Image Bridge

**Status: Proposal.** An opt-in PNG clipboard bridge is tracked in the [roadmap](../roadmap.md#configuration-and-clipboard), but no bridge is implemented or verified. Existing [terminal clipboard settings](../reference/terminal-clipboard.md) do not establish image retrieval support.

These constraints and acceptance checks derive from [historical October 7, 2026 planning](https://github.com/wsadza/toolbox/blob/8fb3f07e7d639cc613a2bc04b5bef27dc3bade8c/TODO_07_10_2026.md). That source records requirements, not implementation or test results.

## Design Constraints

Planned platform support is Wayland through `wl-paste`, X11 through `xclip`, and Windows clipboard access from WSL through `powershell.exe`, including direct native-Linux connections as well as SSH forwarding.

Use authenticated forwarding, preferably through a protected Unix socket. Expose only the dedicated bridge directory to Toolbox, not unrelated host paths. A narrowly scoped adapter for OpenCode image reads must explicitly reject other operations. Define local confirmation or session consent, payload-size limits, timeouts, and failure responses, and document that remote processes with socket access can request images. File attachment remains the fallback when no bridge is available.

The protocol, consent mechanism, adapter compatibility, and effective terminal behavior remain undecided or unverified. These constraints are proposed requirements, not implemented controls.

## Acceptance Checks

- Test PNG retrieval locally, through SSH, inside Toolbox, and finally in OpenCode behind tmux, against the configured OpenCode version in the [tool catalogue](../reference/tools.md).
- Test empty and non-image clipboards, disconnected tunnels, oversized payloads, and denied requests; verify limit and consent enforcement.
- Keep automated checks separate from interactive desktop clipboard tests.
