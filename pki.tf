# Root & Intermediate CA mit Vault via Terraform – End-to-End
locals {
  active_roots = {
    for k, v in var.vault_pki_roots : k => v if !try(v.absent, false)
  }

  active_inters = {
    for k, v in var.vault_pki_intermediates : k => v if !try(v.absent, false)
  }

  active_roles = {
    for k, v in var.vault_pki_roles : k => v if !try(v.absent, false)
  }
}

# Root CA: mount
resource "vault_mount" "root" {
  for_each = local.active_roots

  path        = each.value.mount
  type        = "pki"
  description = "Root CA - ${each.value.common_name}"

  default_lease_ttl_seconds = local.active_roots[each.key].ttl
  max_lease_ttl_seconds     = local.active_roots[each.key].ttl
}

# Root CA: Zertifikat
resource "vault_pki_secret_backend_root_cert" "root" {
  for_each = local.active_roots

  depends_on = [vault_mount.root]

  backend = vault_mount.root[each.key].path

  type                 = "internal"
  common_name          = each.value.common_name
  ttl                  = each.value.ttl
  format               = "pem"
  private_key_format   = "der"
  key_type             = try(each.value.key_type, "rsa")
  key_bits             = try(each.value.key_bits, 4096)
  exclude_cn_from_sans = true
  ou                   = try(each.value.ou, null)
  organization         = try(each.value.organization, null)
  country              = try(each.value.country, null)
  locality             = try(each.value.locality, null)
  province             = try(each.value.province, null)
}

# Modify the mount point and set URLs for the issuer and crl.
resource "vault_pki_secret_backend_config_urls" "config_urls" {
  for_each = local.active_roots

  depends_on              = [vault_mount.root]
  backend                 = vault_mount.root[each.key].path
  issuing_certificates    = ["${each.value.vault_server}/v1/${vault_mount.root[each.key].path}/ca"]
  crl_distribution_points = ["${each.value.vault_server}/v1/${vault_mount.root[each.key].path}/crl"]
}

# Intermediate CA: mount
resource "vault_mount" "inter" {
  for_each = local.active_inters

  path        = each.value.mount
  type        = "pki"
  description = "Intermediate CA - ${each.value.common_name}"

  default_lease_ttl_seconds = local.active_inters[each.key].ttl
  max_lease_ttl_seconds     = local.active_inters[each.key].max_ttl
}

# Intermediate CA: CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "csr" {
  for_each = local.active_inters

  backend              = vault_mount.inter[each.key].path
  type                 = "internal"
  common_name          = each.value.common_name
  key_type             = try(each.value.key_type, "ec")
  key_bits             = try(each.value.key_bits, 256)
  exclude_cn_from_sans = true
  ou                   = try(each.value.ou, null)
  organization         = try(each.value.organization, null)
  country              = try(each.value.country, null)
  locality             = try(each.value.locality, null)
  province             = try(each.value.province, null)
}

# Intermediate CA: Signierung durch Root
resource "vault_pki_secret_backend_root_sign_intermediate" "signed" {
  for_each = local.active_inters

  backend      = vault_mount.root[each.value.signer_root_id].path
  csr          = vault_pki_secret_backend_intermediate_cert_request.csr[each.key].csr
  common_name  = each.value.common_name
  ou           = try(each.value.ou, null)
  organization = try(each.value.organization, null)
  country      = try(each.value.country, null)
  locality     = try(each.value.locality, null)
  province     = try(each.value.province, null)
  ttl          = each.value.max_ttl
}

# Intermediate CA: Zertifikat setzen
resource "vault_pki_secret_backend_intermediate_set_signed" "set_cert" {
  for_each = local.active_inters

  backend     = vault_mount.inter[each.key].path
  certificate = vault_pki_secret_backend_root_sign_intermediate.signed[each.key].certificate
}

resource "vault_pki_secret_backend_crl_config" "crl_config" {
  for_each = local.active_inters

  backend      = vault_mount.inter[each.key].path
  auto_rebuild = try(each.value.csr_auto_rebuild, false)
  expiry       = try(each.value.csr_expiry, "72h")
}

resource "vault_pki_secret_backend_config_urls" "inters_config_urls" {
  for_each = local.active_inters

  backend                 = vault_mount.inter[each.key].path
  issuing_certificates    = ["${each.value.vault_server}/v1/${vault_mount.inter[each.key].path}/ca"]
  crl_distribution_points = ["${each.value.vault_server}/v1/${vault_mount.inter[each.key].path}/crl"]
}

# PKI Rollen für Zertifikate
resource "vault_pki_secret_backend_role" "issue" {
  for_each = local.active_roles

  backend = vault_mount.inter[each.value.mount].path
  name    = each.value.name

  key_type           = try(each.value.key_type, "ec")
  key_bits           = try(each.value.key_bits, 256)
  allowed_domains    = each.value.allowed_domains
  allow_subdomains   = try(each.value.allow_subdomains, false)
  allow_ip_sans      = try(each.value.allow_ip_sans, false)
  allow_bare_domains = try(each.value.allow_bare_domains, false)
  allow_glob_domains = try(each.value.allow_glob_domains, true)
  allow_localhost    = try(each.value.allow_localhost, false)
  ttl                = try(each.value.ttl, 7776000)
  max_ttl            = try(each.value.max_ttl, 7776000)
  generate_lease     = try(each.value.generate_lease, true)
}
