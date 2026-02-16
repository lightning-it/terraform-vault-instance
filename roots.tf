resource "vault_mount" "root" {
  for_each = local.active_roots

  path        = each.value.mount
  type        = "pki"
  description = "Root CA - ${each.value.common_name}"

  default_lease_ttl_seconds = each.value.ttl
  max_lease_ttl_seconds     = each.value.ttl
}

resource "vault_pki_secret_backend_root_cert" "root" {
  for_each   = local.active_roots
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
}

resource "vault_pki_secret_backend_config_urls" "root_urls" {
  for_each = local.active_roots

  backend                 = vault_mount.root[each.key].path
  issuing_certificates    = ["${each.value.vault_server}/v1/${vault_mount.root[each.key].path}/ca"]
  crl_distribution_points = ["${each.value.vault_server}/v1/${vault_mount.root[each.key].path}/crl"]
}
