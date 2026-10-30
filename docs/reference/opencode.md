# OpenCode Integration

The bundled MCP configuration is preserved, but the current launch path is not a verified setup procedure. Do not assume a launching user's configuration or exported credentials reach OpenCode.

## Launch and Configuration

**Wrapper**: The bundle wrapper at `/opt/toolbox/bin/opencode` is intended to execute `/usr/bin/opencode` inside the container, but the `npm install` location of the global `opencode` binary is not established. Verify the actual executable dispatch path before assuming availability.

**Config**: The wrapper at [`build/rootfs/opt/toolbox/bin/opencode`](../../build/rootfs/opt/toolbox/bin/opencode) sets `OPENCODE_CONFIG_DIR="${config}/opencode"` (see wrapper source). The Dockerfile sets `OPENCODE_CONFIG=${TOOLBOX_CONFIG}/opencode/opencode.json` and `OPENCODE_CONFIG_CONTENT=${TOOLBOX_CONFIG}/opencode` (see [Dockerfile](../../build/Dockerfile)); `OPENCODE_CONFIG_CONTENT` is the intended inline config input variable, currently set to a directory path rather than actual inline config. The child container inherits the image's default config from the Dockerfile, *not* the host's `XDG_CONFIG_HOME` or `~/.config/opencode`. Verify effective configuration before use.

The wrapper selects shared configuration under `/opt/toolbox/config/opencode`, not the user's `~/.config/opencode`. When launched through Toolbox, persistence requires the [host home mount](runtime.md#persistence-boundaries).

Two environment boundaries matter: the host wrapper does not forward arbitrary variables to `docker exec`, and this OpenCode wrapper does not forward credentials into its child container. Sourcing credentials in the parent alone is insufficient.

## Atlassian Credentials

| Variable | Meaning |
|---|---|
| `JIRA_URL` | Authorized Jira base URL |
| `JIRA_USERNAME` | User identifier |
| `JIRA_PERSONAL_TOKEN` | Personal access token |
| `CONFLUENCE_URL` | Authorized Confluence base URL |
| `CONFLUENCE_PERSONAL_TOKEN` | Personal access token |

The bundled JSON uses `uvx`, pins `mcp-atlassian` and `atlassian-python-api`. Before running `mcp list`, verify that required packages and providers are available in the image. The `ENABLED_TOOLS` allowlist includes write-capable tools — it is not a read-only access boundary. Use administrator-approved authentication with minimal privileges. Keep credentials present without printing values.

## Verification

1. `opencode mcp list`. Expected: at least `atlassian` is listed as connected.
2. NARROWLY scoped `jira_search` and `confluence_search` reads against test content.
3. Test writes only with explicit approval for target, operation, and a cleanup plan.

The following remain unverified: actual executable dispatch (is `/usr/bin/opencode` present?), effective child config `OPENCODE_CONFIG_CONTENT` value and `OPENCODE_CONFIG_DIR` path, credential presence without printing values, and package/provider availability before `mcp list`.
