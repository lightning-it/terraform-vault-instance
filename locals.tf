locals {
  active_roots = {
    for k, v in var.vault_pki_roots : k => v if !try(v.absent, false)
  }

  active_inters = {
    for k, v in var.vault_pki_intermediates : k => v if !try(v.absent, false)
  }

  active_roles = {
    for k, v in var.vault_pki_roles : k => v if !try(v.absent, false)
  }
}
