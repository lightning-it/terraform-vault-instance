# Auth Backends
resource "vault_auth_backend" "approle" {
  for_each = var.bootstrap_phase >= 2 ? local.active.auth_backends : {}

  type        = each.value.type
  path        = each.value.path
  namespace   = try(each.value.namespace, null)
  description = try(each.value.description, null)
}
