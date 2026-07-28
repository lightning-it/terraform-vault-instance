# Release Model

This repository follows the Lightning IT shared release and quality model.

## Repository Classification

- Repository: `terraform-vault-instance`
- Type: `terraform_module`
- Release type: `semantic_release`
- Artifact type: `terraform_registry_module`
- Visibility: `public`
- Release evidence: `enabled`
- Heavy Incus release validation: `not required`

## Branch Flow

- `develop` is the integration branch for normal work, Renovate updates, and centrally managed synchronization.
- `main` is the protected release branch.
- Releases happen only after `main` is updated.
- A `develop` to `main` promotion PR is created automatically when releasable changes exist.
- The `develop` to `main` PR is a manual gate and must never be auto-merged.
- After `main` changes, a `main` to `develop` backmerge PR is created or updated automatically.
- Integration and backmerge PRs may auto-merge only after required checks pass, all review conversations are resolved, and there are no conflicts.

## Mandatory Quality Gates

- Required profiles: `terraform-fmt, terraform-validate, docs`.
- OS matrix: `ubuntu-latest`.
- Product/runtime matrix: `terraform, vault-provider`.
- Fork pull requests run validation without publishing credentials.
- Publishing secrets are available only to trusted `main` release workflows.
- GitHub token permissions must stay least-privilege for each workflow.

## Terraform Module Release

- CI validates Terraform formatting, provider lock consistency where applicable, linting, and documentation.
- Release tags correspond to Terraform Registry module versions where the module is published.
- Plans must use example or test inputs only and must not require production secrets.
- Publishing, if enabled, happens only from trusted `main` release workflows.

## Release Evidence

The exact `main` commit, successful Terraform validation job,
semantic-release run, immutable version tag, generated changelog, GitHub
Release, and Terraform Registry version form the release evidence.

The registry distributes repository source for an immutable Git tag rather
than a binary or container, so a package SBOM is not applicable. Terraform
Registry has no consumer-side signature-verification contract for modules.
Provenance/signing is an exception owned by `@lightning-it/ent:release`,
compensated by protected release flow, full-SHA Actions, immutable tags, lock
files, and public source review; review/expiry: `2026-10-31`.

As of `2026-07-28`, the latest `semantic-release` transitively bundles npm
versions affected by `GHSA-mh99-v99m-4gvg` (high) and
`GHSA-r292-9mhp-454m` (moderate); no non-breaking upstream release resolves
them. The tooling runs only after protected-branch validation and consumes the
fixed release configuration, not user-provided glob or tar input. Exception
owner: `@lightning-it/ent:release`; review/expiry: `2026-08-31`. Renovate must
adopt the first compatible upstream fix.

Evidence files must not contain tokens, credentials, private inventory values, or secret material.
