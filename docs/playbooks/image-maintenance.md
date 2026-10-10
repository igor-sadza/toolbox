# Image Maintenance

Run from the checkout with Bash, GNU Make, Docker build access, and Compose; local CI emulation also needs `act`. Use only trusted [environment profiles](../reference/runtime.md#environment-selection). These procedures describe expected checks, not observed successful builds or publication.

## Build and Test

1. Build using the selected profile, then test the exact image tag produced. Set `IMAGE` to that profile's image/tag rather than testing an unrelated cached image.

   ```sh
   make build
   IMAGE='ghcr.io/igor-sadza/toolbox:latest'
   make test IMAGE="$IMAGE"
   ```

Expected: both commands exit successfully and no smoke checks fail. Stop on failure. The [smoke script](../../.cicd/tests/smoke.sh) checks selected commands, Neovim components, synthetic identity/permissions, and image hygiene. It does not validate actual Compose mounts, wrapper dispatch, real home permissions, Docker-socket access, NFS/FUSE, clipboard delivery, or cloud/cluster connectivity. Disabling installation flags can require corresponding test changes.

2. Optionally emulate PR checks locally:

   ```sh
   make cicd
   ```

Expected: `act` runs the build workflow in PR mode without image publication. Unlike the local Compose build, that workflow extracts build inputs from `.env.example`, not the selected Make profile. The [build workflow](../../.github/workflows/build.yml) owns lint/scanner options; its Gitleaks Git scan uses `HEAD`, not an arbitrary filesystem scan of untracked files.

3. Only after successful checks, optionally run `make start-local`. It builds again and recreates the long-lived container; it does not run the smoke test as a prerequisite. Preserve [container-local data](../reference/runtime.md#persistence-boundaries) and finish active work first.

## Review an Update

1. Inspect upstream release information and the proposed source/version change. Investigate unexpected binary asset changes before accepting replacement checksums. Review major updates and `kubectl` minors explicitly.
2. Review applicable plugin/registry inputs using [Neovim integration](../reference/neovim-integration.md#updates-and-verification). For matching Renovate branches, inspect the checksum/catalogue refresh and checks on the **final refreshed commit**, not an earlier commit.
3. After manual input or generator changes, validate and refresh the [selected tool catalogue](../reference/tools.md). Confirm both exact marker lines, `<!-- tools:start -->` and `<!-- tools:end -->`, exist in order before running the generator: it only checks for the start marker and can discard subsequent text if the end marker is missing.

   ```sh
   bash -n .cicd/docs/update-tools.sh
   .cicd/docs/update-tools.sh
   git diff -- .env.example .cicd/docs/update-tools.sh docs/reference/tools.md
   git status --short -- .env.example .cicd/docs/update-tools.sh docs/reference/tools.md
   ```

Expected: the table matches intended inputs and surrounding text is preserved. Inspect untracked files directly; `git diff` does not show their contents. Checksum refresh downloads assets and writes `.env.example`; run `.cicd/github/update-checksums.sh` only after upstream investigation. It cross-checks upstream checksum files only where configured, not independent authenticity, and writes incrementally: a later failure can leave earlier changes in place. Review the file even after failure.

4. Build and test the exact updated image, or inspect equivalent PR results. Verify actual branch protection and required checks before relying on automerge.
5. After merge or release evaluation, inspect the relevant workflow results and registry tags before selecting an image. Publication and release evaluation are independent of edge-build success; see [automation](../reference/automation.md). Rollback belongs in [usage](usage.md#update-roll-back-and-stop).

## Adding a Tool

Reuse the existing installation method and gating rather than inventing a per-tool switch/version for every package. Review argument wiring across `.env.example`, the Dockerfile, and Compose; managed pins need appropriate Renovate markers. Release binaries require pinned versions/checksums and checksum-refresh support. Add suitable smoke coverage. Update the catalogue only when the tool belongs in its selected set, and remove adopted work from the [roadmap](../roadmap.md).

## Failure Triage

These are source-based diagnostic suggestions, not recorded incidents.

| Symptom | Investigation and stop condition |
|---|---|
| Checksum mismatch | Stop; verify upstream asset/version and download integrity before refreshing checksums |
| Requested APT version unavailable | Check repository suite and package availability before changing the pin |
| `NO_PUBKEY` or `EXPKEYSIG` | Validate vendor notices, repository endpoint, and expected key; never bypass signature verification |
| Weekly fails while release builds pass | Compare selected Git tag and `APT_UPGRADE`: weekly uses the highest version-sorted `v*` tag, with HEAD fallback; this difference is not itself a root cause |
| Neovim plugin/Mason check fails | Inspect the failing output, installation/network/permissions, and changed plugin APIs or pins; validate a targeted fix or reviewed rollback |

Use [release rules and credential roles](../reference/automation.md#release-rules) before any release-triggering work. Do not invoke semantic-release locally as a harmless test: its checked-in configuration permits real writes. No release, push, or deployment is required for documentation validation.
