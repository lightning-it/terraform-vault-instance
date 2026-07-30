# terraform-vault-instance

Engineering controls follow the accepted repository-topology, branching and
release-governance, mandatory-CI and artifact-assurance ADRs, together with the
Lightning IT secure-SDLC, quality-gate, and software-supply-chain assurance
standards. Internal knowledge-base locations are intentionally not published.

<!-- BEGIN LIT_SHARED_RELEASE_MODEL -->

## Release and Quality Model

This repository follows the Lightning IT shared release and quality model.

See [RELEASE.md](./RELEASE.md) for:

- branch and release flow
- required quality checks
- test matrix
- release evidence
- artifact publishing
- supported repository-specific release behavior

Repository classification: **Terraform Module**.
Required test profiles: `terraform-fmt, terraform-validate, docs`.
Publishing targets: `terraform-registry`.

## Supported and Tested Platforms

| Platform / Product |                  Status | Validation         |
| ------------------ | ----------------------: | ------------------ |
| ubuntu-latest      |               Supported | Terraform validate |
| terraform          | Tested where applicable | Terraform validate |
| vault-provider     | Tested where applicable | Terraform validate |

<!-- END LIT_SHARED_RELEASE_MODEL -->

<!-- BEGIN LIT_QUALITY_BADGES -->

[![CI](https://github.com/lightning-it/terraform-vault-instance/actions/workflows/repository-quality.yml/badge.svg?branch=develop)](https://github.com/lightning-it/terraform-vault-instance/actions/workflows/repository-quality.yml)
[![Latest Release](https://img.shields.io/github/v/release/lightning-it/terraform-vault-instance?sort=semver)](https://github.com/lightning-it/terraform-vault-instance/releases/latest)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/lightning-it/terraform-vault-instance/badge)](https://scorecard.dev/viewer/?uri=github.com/lightning-it/terraform-vault-instance)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/13892/badge)](https://www.bestpractices.dev/projects/13892)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

<!-- END LIT_QUALITY_BADGES -->

`terraform-vault-instance` is managed by the Lightning IT shared release and quality model.

## Features

- Managed repository metadata and shared quality checks.
- Standard release, testing, and security documentation.

## Documentation

- [RELEASE.md](./RELEASE.md)
- [TESTING.md](./TESTING.md)
- [SECURITY.md](./SECURITY.md)

## Security

See [SECURITY.md](./SECURITY.md) for supported versions and vulnerability reporting.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution and review expectations.

## License

See [LICENSE](./LICENSE).

<!-- BEGIN LIT_RELEASE_QUALITY_MODEL -->

## Release and Quality Model

This repository follows the Lightning IT shared release and quality model.
The README shows the current supported and tested matrix.
Exact per-version validation proof is stored with each GitHub Release as `release-evidence.md` and `release-evidence.json`.
Releases are created from the protected `main` branch after a reviewed `develop -> main` release promotion.
Repository checks validate the managed structure, documentation, and release model for this repository type.

See:

- [RELEASE.md](./RELEASE.md)
- [TESTING.md](./TESTING.md)
- [GitHub Releases](../../releases)

Repository classification: **Terraform Module**.
Required test profiles: `terraform-fmt, terraform-validate, docs`.
Publishing targets: `terraform-registry`.

<!-- END LIT_RELEASE_QUALITY_MODEL -->

<!-- BEGIN LIT_COMPATIBILITY_MATRIX -->

## Compatibility Matrix

| Platform / Product | Status | Validation |
|---|---:|---|
| ubuntu-latest | Supported | Terraform validate |
| terraform | Tested where applicable | Terraform validate |
| vault-provider | Tested where applicable | Terraform validate |

Validation proof for each released version is stored in the corresponding GitHub Release evidence.

<!-- END LIT_COMPATIBILITY_MATRIX -->

## Release Evidence

This repository does not publish release artifacts by default; release evidence is recorded when artifact releases are enabled.
The evidence records:

- tested matrix combinations
- GitHub Actions run links
- artifact references
- publish status
- security scan status

See [GitHub Releases](../../releases), [RELEASE.md](./RELEASE.md), and [TESTING.md](./TESTING.md) for the release process and validation model.
