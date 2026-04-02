# Secret stores
# Secret Mounts without namespace dependency
resource "vault_mount" "secret_base" {
  for_each = var.bootstrap_phase >= 1 ? {
    for k, v in local.active.secret_stores : k => v if try(v.namespace, null) == null
  } : {}
  path        = each.value.path
  type        = each.value.type
  description = each.value.description
  options     = each.value.options
}

resource "vault_mount" "secret" {
  for_each = var.bootstrap_phase >= 2 ? {
    for k, v in local.active.secret_stores : k => v if try(v.namespace, null) != null
  } : {}
  path        = each.value.path
  namespace   = each.value.namespace
  type        = each.value.type
  description = each.value.description
  options     = each.value.options
}
