variable "bootstrap_phase" {
  description = "Vault bootstrap phase"
  type        = number
  default     = 3
}

variable "vault_url" {
  type        = string
  description = "URL to vault"
}

variable "ca_cert_file" {
  type        = string
  description = "CA Cert file"
  default     = "vault-ca.pem"
}

variable "auth_backends" {
  type = map(object({
    type        = string
    path        = optional(string)
    namespace   = optional(string)
    description = optional(string)
  }))
  default = {
    placeholder = {
      type        = "approle"
      path        = "approle"
      namespace   = "test"
      description = "AppRole Authentication Backend for test"
    }
  }
}

variable "secret_stores" {
  type = map(object({
    path        = string
    description = optional(string)
    namespace   = optional(string)
    type        = optional(string, "kv-v2")
    options     = optional(map(string))
    absent      = optional(bool, false)
  }))
  default = {
    placeholder = {
      path   = "placeholder"
      absent = true
    }
  }
}

variable "policies" {
  type = map(object({
    name      = string
    namespace = optional(string)
    policy    = string
    absent    = optional(bool, false)
  }))
  default = {
    placeholder = {
      name   = "placeholder"
      policy = "dummy"
      absent = true
    }
  }
}

variable "approle_secrets" {
  type = map(object({
    role_name       = string
    backend         = optional(string, "global_approle")
    namespace       = optional(string)
    token_ttl       = optional(number, 300)
    token_max_ttl   = optional(number, 300)
    token_policy    = list(string)
    token_type      = optional(string, "default")
    token_period    = optional(number)
    kv_mount        = string
    credential_path = string
    absent          = optional(bool, false)
  }))
  validation {
    condition = alltrue([
      for k, v in var.approle_secrets :
      v.absent == true ? true : contains(keys(var.auth_backends), v.backend)
    ])
    error_message = "Backend in approle_secrets must exist in auth_backends."
  }
  default = {
    placeholder = {
      role_name       = "placeholder"
      backend         = "global_approle"
      kv_mount        = "default"
      credential_path = "cluster/1/approle"
      token_policy    = ["default"]
      absent          = true
    }
  }
}

variable "vault_pki_roots" {
  type = map(object({
    mount        = string
    common_name  = string
    vault_server = string
    namespace    = optional(string)
    ttl          = optional(number, 315360000) # Default 10 Jahre
    key_type     = optional(string, "ec")
    key_bits     = optional(number, 256)
    country      = optional(string, "DE")
    locality     = optional(string, "Bonn")
    province     = optional(string, "NRW")
    ou           = optional(string, "IT")
    organization = optional(string, "Example Inc.")
    policy_name  = optional(string)
    absent       = optional(bool, false)
  }))
  default = {
    root = {
      mount        = "pki-root"
      common_name  = "example.com"
      vault_server = "https://localhost:8200"
      absent       = true
    }
  }
}

# TTL values are seconds (number)
# Vault duration values remain strings (e.g. csr_expiry)
variable "vault_pki_intermediates" {
  type = map(object({
    mount                = string
    common_name          = string
    vault_server         = string
    namespace            = optional(string)
    signer_root_id       = optional(string)
    sign_method          = optional(string, "vault")
    external_cert_secret = optional(string)
    external_cert_ready  = optional(bool, false)
    store_csr            = optional(bool, false)
    ttl                  = optional(number, 3600)
    max_ttl              = optional(number, 94608000)
    key_type             = optional(string, "ec")
    key_bits             = optional(number, 256)
    country              = optional(string, "DE")
    locality             = optional(string, "Bonn")
    province             = optional(string, "NRW")
    ou                   = optional(string, "IT")
    organization         = optional(string, "Example Inc.")
    csr_auto_rebuild     = optional(bool, false)
    csr_expiry           = optional(string, "72h")
    absent               = optional(bool, false)
  }))
  default = {
    inter = {
      mount          = "pki-intermediate"
      common_name    = "intermediate.example.com"
      vault_server   = "https://localhost:8200"
      signer_root_id = "pki-root"
      sign_method    = "vault"
      max_ttl        = 94608000
      absent         = true
    }
  }
  validation {
    condition = alltrue([
      for k, v in var.vault_pki_intermediates :
      (
        try(v.sign_method, "vault") != "external"
        || try(v.external_cert_secret, null) != null
      )
    ])
    error_message = "If sign_method = \"external\", external_cert_secret must be set."
  }
}

variable "vault_pki_roles" {
  type = map(object({
    mount              = string
    name               = string
    namespace          = optional(string)
    key_type           = optional(string, "ec")
    key_bits           = optional(number, 256)
    allowed_domains    = list(string)
    allow_subdomains   = optional(bool, false)
    allow_ip_sans      = optional(bool, false)
    allow_bare_domains = optional(bool, false)
    allow_glob_domains = optional(bool, true)
    allow_localhost    = optional(bool, false)
    generate_lease     = optional(bool, true)
    ttl                = optional(number, 7776000)
    max_ttl            = optional(number, 7776000)
    absent             = optional(bool, false)
  }))
  default = {
    inter = {
      mount           = "pki-inter-cluster1"
      allowed_domains = ["cluster1.apps.example.com"]
      name            = "cluster1"
      max_ttl         = 7776000
      absent          = true
    }
  }
}

variable "jwt_auth_backends" {
  type = map(object({
    path                   = string
    namespace              = optional(string)
    oidc_discovery_url     = optional(string)
    bound_issuer           = optional(string)
    type                   = optional(string, "oidc")
    oidc_discovery_ca_pem  = optional(string)
    jwt_validation_pubkeys = optional(list(string))
    absent                 = optional(bool, false)
  }))
  default = {
    placeholder = {
      path   = "placeholder"
      absent = true
    }
  }
}

variable "jwt_auth_backend_roles" {
  type = map(object({
    backend_key       = string
    role_name         = string
    user_claim        = string
    namespace         = optional(string)
    bound_claims_type = optional(string, "string")
    bound_claims      = optional(map(string))
    role_type         = optional(string, "jwt")
    bound_audiences   = optional(list(string))
    token_policy      = optional(list(string), ["default"])
    absent            = optional(bool, false)
  }))
  default = {
    placeholder = {
      backend_key  = "foo"
      role_name    = "placeholder"
      user_claim   = "claim"
      token_policy = ["default"]
      absent       = true
    }
  }
}

variable "secret_mount" {
  type    = string
  default = "pki-secrets"
}

variable "transit_secret_backend_key" {
  type = map(object({
    name      = string
    backend   = string
    namespace = optional(string)
    type      = optional(string, "aes256-gcm96")
    absent    = optional(bool, false)
  }))
  default = {
    placeholder = {
      backend = "placeholder"
      name    = "placeholder"
      absent  = true
    }
  }
}

variable "namespace" {
  type = map(object({
    path   = string
    absent = optional(bool, false)
  }))
  default = {
    placeholder = {
      path   = "placeholder"
      absent = true
    }
  }
}
