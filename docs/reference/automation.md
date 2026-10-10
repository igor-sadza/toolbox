# Automation

GitHub Actions, Renovate, and semantic-release configure independent image checks, dependency updates, and publication. Repository files do not establish successful execution, installed GitHub Apps, branch protection, secret permissions, or registry state. Follow [image maintenance](../playbooks/image-maintenance.md) for local procedures.

## Workflows

The [build workflow](../../.github/workflows/build.yml) owns trigger/tag definitions: PR checks do not publish; edge pushes, weekly rebuilds, called releases, and explicitly selected manual publication have different outputs. The [release workflow](../../.github/workflows/release.yml) evaluates commits independently. Check those files for schedules and tag formats rather than duplicating a workflow inventory.

The [checksum workflow](../../.github/workflows/checksums.yml) refreshes checksums and the catalogue only for PRs to `develop` touching `.env.example` with a `renovate/*` head branch. That name filter does not verify bot authorship, and manual changes do not automatically receive the refresh. [Neovim updates](neovim-integration.md#updates-and-verification) have a separate workflow and ownership from weekly image rebuilds.

Weekly builds select the highest version-sorted `v*` Git tag, not a GitHub Release API result. If no such tag exists, they retain checked-out HEAD. The edge push build ignores Markdown and `docs/**` changes; PR checks are not excluded by that rule. Documentation-only pushes can still trigger release evaluation because `docs:` commits are eligible for patch releases.

## Dependency Updates

Selected inputs are pinned in source; not every installed package has an explicit version pin.

[`renovate.json`](../../renovate.json) configures a Monday window in the `Europe/Warsaw` timezone, with patch, minor, and digest automerge rules; it does not configure one combined weekly PR. Majors and `kubectl` minors require review under the configured rules. Effective CI merge gating depends on GitHub branch protection and required checks, not just Renovate settings.

There is no guaranteed serialized update-to-release pipeline. Inspect checks on the final refreshed PR commit rather than an earlier commit. Release evaluation does not wait for the independent edge build, and release artifacts can exist even if the subsequent release image build fails.

## Release Rules

The [semantic-release configuration](../../.releaserc.yml) owns commit rules on `develop`; Renovate uses `dep:`. In particular, `docs:` qualifies for a patch release even though Markdown/docs-only pushes are excluded from edge builds. Choose commit types deliberately rather than treating all documentation work as release-neutral.

A qualifying release is configured to tag `vX.Y.Z`, commit `CHANGELOG.md` with `[skip ci]`, create a GitHub release, and call the build workflow for version and `latest` image tags. The checked-in configuration sets `ci: false` and `dryRun: false`: invoking semantic-release locally is not a harmless validation command and can perform release writes.

## GitHub Settings

Check these external settings in GitHub before relying on automation:

| Item | Configured use or required check |
|---|---|
| Secret `WORKFLOW_TOKEN` | GHCR publishing, automation pushes, and semantic-release's `GITHUB_TOKEN` |
| Secret `SEMANTIC_RELEASE_TOKEN` | Release workflow checkout authentication; Git transport permissions require separate verification |
| Variable `GHCR_USERNAME` | Optional registry username; workflow defaults to `igor-sadza` |
| Renovate and automerge | Verify the app is installed and auto-merge enabled if intended |
| Branch protection `develop` | Verify actual required-check behavior, including the configured **Build Docker** check and final refreshed commit |
| GHCR package | Grant intended pull access; visibility and retention are external settings |

Secret presence and effective scopes, release Git writes, successful publication, and tag retention are unknown from repository files alone.
