# Clipboard Image Bridge

This is a proposed design — not implemented. An opt-in PNG clipboard bridge is tracked in the [roadmap](../roadmap.md#configuration-and-clipboard).

## Current State

Existing [terminal clipboard settings](../reference/terminal-clipboard.md) do not establish image retrieval support.

## Design Constraints

- **Platform**: Linux (Wayland `wl-paste`, X11 `xclip`), WSL (PowerShell).
- **Secure Forwarding**: Prefer a protected Unix socket; restrict to localhost if unavailable. **Authentication is required for every transport** (Unix socket and localhost). Filesystem restrictions or loopback access are not sufficient replacements.
- **Dedicated Directory**: One dedicated, narrowly scoped directory for the bridge.
- **Adapter Scope**: Image-read adapter only — rejects all non-image operations.
- **Consent**: Local confirmation or session consent required before exposing images.
- **Safety**: Payload size limits, I/O timeouts, failure handling for denied/timed-out requests.
- **Disclosure**: Any process with socket access can request images.
- **Fallback**: File-attachment fallback for sessions that cannot use the socket.

## Verification

Automated security and protocol checks:
- PNG retrieval, empty/non-image clipboards, disconnections, oversized payloads, denied requests.
- Acceptance checks: denial/limit enforcement, timeout handling, authentication requirements.

Interactive clipboard trials (separate from automated checks):
- Test PNG retrieval locally, over SSH, and in OpenCode behind tmux.
