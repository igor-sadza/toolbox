# OpenCode Integration

The bundled MCP configuration preserves the intended Atlassian integration, but the current OpenCode launch path is not a verified setup procedure. Static inspection on October 10, 2026 found the blockers below. Do not assume a launching user's configuration or exported credentials reach OpenCode.

## Launch and Configuration Boundaries

The [repository wrapper](../../build/rootfs/opt/toolbox/bin/opencode) requires a Git checkout and launches a separate Docker container, mounting that repository at `/workspace` and a persistent sandbox home from `~/.local/share/opencode-sandbox`. It drops capabilities and applies resource limits, but the repository remains writable. These configured restrictions do not establish a verified security boundary.

The wrapper selects shared configuration under `/opt/toolbox/config/opencode`, not the launching user's `~/.config/opencode`. Its data/cache/state live beneath the sandbox home. When launched through Toolbox, persistence requires the [host home mount](runtime.md#persistence-boundaries), and Docker bind sources must exist on the daemon host.

Two environment boundaries matter: the host `toolbox` wrapper does not forward arbitrary variables into `docker exec`, and this OpenCode wrapper does not forward the Atlassian variables into its child `docker run`. Sourcing credentials in the parent alone is insufficient. Unsetting a parent variable also does not remove a selected image's default.

The [Dockerfile](../../build/Dockerfile) sets `OPENCODE_CONFIG` and `OPENCODE_CONFIG_CONTENT`; the latter is a directory string, although it is an inline-configuration input. The child wrapper leaves those image defaults in place. Their effect with the selected binary has not been tested. The bundled JSON defines MCP configuration, not a provisioned model/provider or default engineering agent.

Additional launch uncertainties in the current source:

- Checkout wrappers have mode `0644`, but Dockerfile finalization gives `toolbox-shared` group execute permission on shared binaries. Normal Toolbox sessions receive that group. Actual image dispatch and the child container's executable access still require verification; checkout modes alone do not establish a failure.
- The wrapper targets `/usr/bin/opencode`, while installation uses npm global installation. That executable path is not established by an observed image check.

Runtime code was not changed during documentation cleanup. These are integration gaps, not confirmed failures in a deployed image.

## Atlassian Compatibility and Credentials

The [bundled JSON](../../build/rootfs/opt/toolbox/config/opencode/opencode.json) uses `uvx`, pins `mcp-atlassian` and `atlassian-python-api`, and substitutes environment values rather than embedding endpoints or tokens. [October 8, 2026 planning](https://github.com/wsadza/toolbox/blob/8fb3f07e7d639cc613a2bc04b5bef27dc3bade8c/TODO_08_10_2026.md) records Confluence DC 10.2 compatibility as the reason for the dependency pin; compatibility has not been reverified. Read current pins from the source rather than duplicating versions here.

| Required variable | Meaning |
|---|---|
| `JIRA_URL` | Authorized Jira base URL |
| `JIRA_USERNAME` | User identifier for the configured integration |
| `JIRA_PERSONAL_TOKEN` | Jira personal access token |
| `CONFLUENCE_URL` | Authorized Confluence base URL |
| `CONFLUENCE_PERSONAL_TOKEN` | Confluence personal access token |

Use administrator-approved authentication with only the necessary permissions. Keep credential files private and out of Git/logs; sourcing a file executes shell code. Package resolution through `uvx` needs network/package-source access on initial installation. The shared `ENABLED_TOOLS` allowlist includes writes: it is not a read-only access boundary. Keep the generic configuration simple; templating was deferred until projects actually need different models, MCP servers, or toolsets.

## Verification Gate

First establish actual executable dispatch, the effective child configuration, credential presence without printing values, and package/provider availability. Only in that confirmed application environment:

1. Run `opencode mcp list`. Expected: `atlassian` is connected. Stop on errors and inspect configuration, environment, package/network access, and server messages.
2. Perform narrowly scoped `jira_search` and `confluence_search` reads against authorized test content, then fetch a known issue/page. Verify endpoint, project/space, and content; connectivity alone proves neither authorization nor the correct deployment.
3. Test writes only with explicit approval for the target and operation, disposable content, and a cleanup plan. Live writes are unnecessary for documentation validation.

Executable dispatch, provider authentication and persistence, package resolution, MCP reads/writes, and server compatibility remain unverified.
