locals {
  active = {
    auth_backends = { for k, v in var.auth_backends : k => v if !try(v.absent, false) }
    policies      = { for k, v in var.policies : k => v if !try(v.absent, false) }
    secret_stores = { for k, v in var.secret_stores : k => v if !try(v.absent, false) }
    approles      = { for k, v in var.approle_secrets : k => v if !try(v.absent, false) }
    pki_roots     = { for k, v in var.pki_roots : k => v if !try(v.absent, false) }
    pki_inters    = { for k, v in var.pki_intermediates : k => v if !try(v.absent, false) }
    pki_roles     = { for k, v in var.pki_roles : k => v if !try(v.absent, false) }
    jwt_backends  = { for k, v in var.jwt_auth_backends : k => v if !try(v.absent, false) }
    jwt_roles     = { for k, v in var.jwt_auth_backend_roles : k => v if !try(v.absent, false) }
    transit_keys  = { for k, v in var.transit_secret_backend_keys : k => v if !try(v.absent, false) }
    namespaces    = { for k, v in var.namespaces : k => v if !try(v.absent, false) }
  }

  global_backend = "global_approle"
}
