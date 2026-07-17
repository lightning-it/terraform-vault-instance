# Vault Namespace
resource "vault_namespace" "name" {
  for_each = var.bootstrap_phase >= 1 ? local.active.namespaces : {}
  path     = each.value.path
}
