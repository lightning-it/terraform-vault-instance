# Transit Secret
resource "vault_transit_secret_backend_key" "name" {
  for_each  = var.bootstrap_phase >= 2 ? local.active.transit_keys : {}
  namespace = each.value.namespace
  backend   = each.value.backend
  name      = each.value.name
  type      = each.value.type

  depends_on = [vault_mount.secret]
}
