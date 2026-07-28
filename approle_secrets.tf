# AppRole Backend-Rollen
resource "vault_approle_auth_backend_role" "cluster" {
  for_each = var.bootstrap_phase >= 3 ? local.active.approles : {}

  backend            = vault_auth_backend.approle[each.value.backend].path
  role_name          = each.value.role_name
  namespace          = each.value.namespace
  token_ttl          = each.value.token_ttl
  token_max_ttl      = each.value.token_max_ttl
  token_policies     = each.value.token_policy
  token_type         = lookup(each.value, "token_type", "default")
  token_period       = each.value.token_period
  secret_id_ttl      = each.value.secret_id_ttl
  secret_id_num_uses = each.value.secret_id_num_uses
  depends_on = [
    vault_policy.policy,
    vault_mount.secret
  ]
}

# KV Secrets mit role_id
resource "vault_kv_secret_v2" "approle_credentials" {
  for_each = var.bootstrap_phase >= 3 ? local.active.approles : {}

  mount     = each.value.kv_mount
  name      = each.value.credential_path
  namespace = each.value.namespace

  # Dynamische Werte (role_id) werden hier referenziert
  data_json = jsonencode({
    role_id   = vault_approle_auth_backend_role.cluster[each.key].role_id
  })

  depends_on = [
    vault_mount.secret
  ]
}
