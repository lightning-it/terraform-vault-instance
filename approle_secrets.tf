# Approles for external secrets
# Lokale gefilterte Liste ohne "absent: true"
locals {
  active_approles = {
    for key, value in var.approle_secrets :
    key => value if !try(value.absent, false)
  }
}

# AppRole Backend-Rollen
resource "vault_approle_auth_backend_role" "cluster" {
  for_each = local.active_approles

  backend        = vault_auth_backend.approle.path
  role_name      = each.value.role_name
  namespace      = each.value.namespace
  token_ttl      = each.value.token_ttl
  token_max_ttl  = each.value.token_max_ttl
  token_policies = each.value.token_policy

  depends_on = [
    vault_policy.policy
  ]
}

# Secret IDs
resource "vault_approle_auth_backend_role_secret_id" "cluster" {
  for_each = vault_approle_auth_backend_role.cluster

  backend   = each.value.backend
  role_name = each.value.role_name
  namespace = each.value.namespace
}

# KV Secrets mit role_id und secret_id
resource "vault_kv_secret_v2" "approle_credentials" {
  for_each = vault_approle_auth_backend_role_secret_id.cluster

  mount     = local.active_approles[each.key].kv_mount
  name      = local.active_approles[each.key].credential_path
  namespace = each.value.namespace

  data_json = jsonencode({
    role_id   = vault_approle_auth_backend_role.cluster[each.key].role_id
    secret_id = each.value.secret_id
  })
}
