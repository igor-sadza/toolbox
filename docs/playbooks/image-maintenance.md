# Image Maintenance

Run from the checkout with Bash, GNU Make, Docker build access, and Compose. Local CI emulation also needs `act`. Use only trusted [environment profiles](../reference/runtime.md#environment-profile).

## Build and Test

1. Build and optionally start (choose ONE):

    ```sh
    make build          # Build image only
    make start-local    # Build image and start container
    ```

2. Smoke test the image:

    ```sh
    make test                        # Test built image
    make test IMAGE=ghcr.io/...:edge # Test a specific image
    ```

    **Expected**: Tests verify tool presence, Neovim components, identity/permissions, and image hygiene. Smoke checks do not validate actual Compose mounts, wrapper dispatch, Docker socket access, NFS/FUSE, clipboard, or cloud connectivity. Disabling installation flags can require corresponding test changes. See [smoke script](../../.cicd/tests/smoke.sh).

3. Emulate PR checks locally:

    ```sh
    make cicd
    ```

    **Expected**: `act` runs lint, scan, and build. The [build workflow](../../.github/workflows/build.yml) owns lint/scanner options.

## Review an Update

1. Inspect upstream release information and proposed source/version changes. Investigate unexpected binary asset changes before accepting replacement checksums. Review major updates and `kubectl` minors explicitly.

2. Review applicable plugin/registry inputs via [Neovim integration](../reference/neovim-integration.md#updates-and-verification). For matching Renovate branches, inspect the checksum/catalogue refresh on the **final refreshed commit**, not an earlier commit.

3. After changes, validate and refresh the [tool catalogue](../reference/tools.md):

    **Before running the generator**, confirm that both the `<!-- tools:start -->` and `<!-- tools:end -->` HTML marker lines exist in order in `docs/reference/tools.md`. The script checks for the start marker only; a missing end marker can silently discard trailing content.

    ```sh
    bash -n .cicd/docs/update-tools.sh
    .cicd/docs/update-tools.sh
    git diff -- .env.example .cicd/docs/update-tools.sh docs/reference/tools.md
    git status --short -- .env.example .cicd/docs/update-tools.sh docs/reference/tools.md
    ```

    **Expected**: The table matches intended inputs and surrounding text is preserved. Checksum refresh writes incrementally; a later failure can leave earlier changes. Review the file even after failure.

4. After merge, inspect workflow results and registry tags before selecting an image. For release rules and dependency update schedules, see [automation](../reference/automation.md).

## Adding a Tool

Reuse existing installation methods. Review argument wiring across `.env.example`, Dockerfile, and Compose. Managed pins need Renovate markers. Release binaries require pinned versions/checksums with checksum-refresh support. Update the catalogue when the tool belongs in the selected set; remove adopted work from the [roadmap](../roadmap.md).

## Failure Triage

| Symptom | Investigation |
|---|---|
| Checksum mismatch | Stop; verify upstream asset/version and download integrity before refreshing checksums |
| APT version unavailable | Check repository suite and package availability before changing the pin |
| `NO_PUBKEY` or `EXPKEYSIG` | Validate vendor notices, repository endpoint, and expected key. Never bypass verification |
| Build fails on develop, passes on weekly | Weekly uses the default branch with `APT_UPGRADE=true` and no cache. Compare source revision and packages |
| Neovim plugin/Mason check fails | Inspect failing output, network/permissions, changed plugin APIs. Validate a targeted fix or reviewed rollback |
| Versioned publication fails after release | Use `edge-<sha>` from the exact failed develop run. Do not use floating edge |

Do not invoke semantic-release locally as harmless validation — its checked-in configuration permits real writes.
