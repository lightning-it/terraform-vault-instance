resource "vault_pki_secret_backend_role" "issue" {
  for_each = var.bootstrap_phase >= 3 ? local.active.pki_roles : {}

  backend   = vault_mount.inter[each.value.mount].path
  name      = each.value.name
  namespace = each.value.namespace

  key_type           = try(each.value.key_type, "ec")
  key_bits           = try(each.value.key_bits, 256)
  allowed_domains    = each.value.allowed_domains
  allow_subdomains   = try(each.value.allow_subdomains, false)
  allow_ip_sans      = try(each.value.allow_ip_sans, false)
  allow_bare_domains = try(each.value.allow_bare_domains, false)
  allow_glob_domains = try(each.value.allow_glob_domains, true)
  allow_localhost    = try(each.value.allow_localhost, false)
  ttl                = try(each.value.ttl, 7776000)
  max_ttl            = try(each.value.max_ttl, 7776000)
  generate_lease     = try(each.value.generate_lease, true)
}
