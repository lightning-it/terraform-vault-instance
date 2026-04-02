# Vault Policies 
resource "vault_policy" "policy" {
  for_each  = var.bootstrap_phase >= 2 ? local.active.policies : {}
  name      = each.value.name
  namespace = each.value.namespace
  policy    = each.value.policy

  depends_on = [
    vault_mount.secret,
    vault_namespace.name
  ]
}
