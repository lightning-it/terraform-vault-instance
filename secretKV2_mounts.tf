# Secret stores
resource "vault_mount" "secret" {
  for_each    = { for key, value in var.secret_stores : key => value if value.absent == false }
  path        = each.value.path
  type        = each.value.type
  options     = each.value.options
  description = each.value.description
}
