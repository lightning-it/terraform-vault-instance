# AppRole Backend-Rollen
resource "vault_approle_auth_backend_role" "cluster" {
  for_each = var.bootstrap_phase >= 3 ? local.active.approles : {}

  backend        = vault_auth_backend.approle[each.value.backend].path
  role_name      = each.value.role_name
  namespace      = each.value.namespace
  token_ttl      = each.value.token_ttl
  token_max_ttl  = each.value.token_max_ttl
  token_policies = each.value.token_policy
  token_type     = lookup(each.value, "token_type", "default")
  token_period   = each.value.token_period

  depends_on = [
    vault_policy.policy,
    vault_mount.secret
  ]
}

# Secret IDs
resource "vault_approle_auth_backend_role_secret_id" "cluster" {
  for_each = var.bootstrap_phase >= 3 ? vault_approle_auth_backend_role.cluster : {}

  backend   = each.value.backend
  role_name = each.value.role_name
  namespace = each.value.namespace
}

# KV Secrets mit role_id und secret_id
resource "vault_kv_secret_v2" "approle_credentials" {
  for_each = var.bootstrap_phase >= 3 ? vault_approle_auth_backend_role_secret_id.cluster : {}

  depends_on = [
    vault_mount.secret
  ]
  mount     = local.active.approles[each.key].kv_mount
  name      = local.active.approles[each.key].credential_path
  namespace = each.value.namespace

  data_json = jsonencode({
    role_id   = vault_approle_auth_backend_role.cluster[each.key].role_id
    secret_id = each.value.secret_id
  })
}
