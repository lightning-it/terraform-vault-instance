# terraform-vault-instance

<!-- BEGIN LIT_QUALITY_BADGES -->

[![CI](https://github.com/lightning-it/terraform-vault-instance/actions/workflows/repository-quality.yml/badge.svg?branch=develop)](https://github.com/lightning-it/terraform-vault-instance/actions/workflows/repository-quality.yml)
[![Latest Release](https://img.shields.io/github/v/release/lightning-it/terraform-vault-instance?sort=semver)](https://github.com/lightning-it/terraform-vault-instance/releases/latest)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/lightning-it/terraform-vault-instance/badge)](https://scorecard.dev/viewer/?uri=github.com/lightning-it/terraform-vault-instance)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

<!-- END LIT_QUALITY_BADGES -->

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

| Platform / Product | Status | Validation |
|---|---:|---|
| ubuntu-latest | Supported | Terraform validate |
| terraform | Tested where applicable | Terraform validate |
| vault-provider | Tested where applicable | Terraform validate |

<!-- END LIT_SHARED_RELEASE_MODEL -->
