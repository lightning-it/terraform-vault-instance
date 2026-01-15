# Vault Policies 
resource "vault_policy" "policy" {
  for_each = { for key, value in var.policies : key => value if value.absent == false }
  name     = each.value.name
  policy   = each.value.policy
}
