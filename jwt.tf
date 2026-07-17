# JWT Auth Backend
resource "vault_jwt_auth_backend" "backend" {
  for_each = var.bootstrap_phase >= 2 ? local.active.jwt_backends : {}

  namespace              = try(each.value.namespace, null)
  path                   = each.value.path
  type                   = try(each.value.type, "oidc")
  oidc_discovery_url     = try(each.value.oidc_discovery_url, null)
  bound_issuer           = try(each.value.bound_issuer, null)
  oidc_discovery_ca_pem  = try(each.value.oidc_discovery_ca_pem, null)
  jwt_validation_pubkeys = try(each.value.jwt_validation_pubkeys, null)

  lifecycle {
    ignore_changes = [
      jwt_validation_pubkeys
    ]
  }
}

# JWT Auth Backend roles
resource "vault_jwt_auth_backend_role" "role" {
  for_each = var.bootstrap_phase >= 2 ? local.active.jwt_roles : {}

  namespace = try(each.value.namespace, null)

  backend = vault_jwt_auth_backend.backend[
    each.value.backend_key
  ].path

  role_name         = each.value.role_name
  role_type         = try(each.value.role_type, "jwt")
  user_claim        = each.value.user_claim
  bound_claims_type = try(each.value.bound_claims_type, "string")
  bound_claims      = try(each.value.bound_claims, null)
  bound_audiences   = try(each.value.bound_audiences, null)
  token_policies    = each.value.token_policy

  depends_on = [
    vault_jwt_auth_backend.backend,
    vault_policy.policy
  ]
}
