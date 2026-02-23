resource "vault_mount" "inter" {
  for_each = local.active_inters

  path        = each.value.mount
  type        = "pki"
  description = "Intermediate CA - ${each.value.common_name}"

  default_lease_ttl_seconds = each.value.ttl
  max_lease_ttl_seconds     = each.value.max_ttl
}

# generate CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "csr" {
  for_each = local.active_inters

  backend     = vault_mount.inter[each.key].path
  type        = "internal"
  common_name = each.value.common_name
}

# optional save CSR as Secret
resource "vault_kv_secret_v2" "csr_store" {
  for_each = { for k, v in local.active_inters : k => v if try(v.store_csr, false) }

  depends_on = [vault_mount.secret]
  mount      = var.secret_mount
  name       = "${each.key}/csr"

  data_json = jsonencode({
    csr = vault_pki_secret_backend_intermediate_cert_request.csr[each.key].csr
  })
}

# Root is in Vault
resource "vault_pki_secret_backend_root_sign_intermediate" "signed_by_vault" {
  for_each = {
    for k, v in local.active_inters : k => v
    if try(v.sign_method, "vault") == "vault"
  }
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

# External signed Certificate from Secret
data "vault_kv_secret_v2" "external_cert" {
  for_each = {
    for k, v in local.active_inters : k => v
    if try(v.sign_method, "vault") == "external"
    && try(v.external_cert_ready, false) == true
  }

  depends_on = [vault_mount.secret]
  mount      = var.secret_mount
  name       = each.value.external_cert_secret
}

resource "vault_pki_secret_backend_intermediate_set_signed" "set_cert_vault" {
  for_each = {
    for k, v in local.active_inters : k => v
    if try(v.sign_method, "vault") == "vault"
  }

  backend     = vault_mount.inter[each.key].path
  certificate = vault_pki_secret_backend_root_sign_intermediate.signed_by_vault[each.key].certificate
}

resource "vault_pki_secret_backend_intermediate_set_signed" "set_cert_external" {
  for_each = {
    for k, v in local.active_inters : k => v
    if try(v.sign_method, "vault") == "external"
    && try(v.external_cert_ready, false) == true
  }

  backend     = vault_mount.inter[each.key].path
  certificate = data.vault_kv_secret_v2.external_cert[each.key].data["certificate"]
}

resource "vault_pki_secret_backend_config_urls" "inter_urls" {
  for_each = local.active_inters

  backend                 = vault_mount.inter[each.key].path
  issuing_certificates    = ["${each.value.vault_server}/v1/${vault_mount.inter[each.key].path}/ca"]
  crl_distribution_points = ["${each.value.vault_server}/v1/${vault_mount.inter[each.key].path}/crl"]
}
