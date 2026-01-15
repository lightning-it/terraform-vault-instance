# https://registry.terraform.io/providers/hashicorp/vault/latest/docs
provider "vault" {
  address         = var.vault_url
  ca_cert_file    = var.ca_cert_file
  skip_tls_verify = true
}
