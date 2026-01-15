variable "vault_url" {
  type        = string
  description = "URL to vault"
}

variable "ca_cert_file" {
  type        = string
  description = "CA Cert file"
  default     = "vault-ca.pem"
}

variable "secret_stores" {
  type = map(object({
    path        = string
    description = optional(string)
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
    name   = string
    policy = string
    absent = optional(bool, false)
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
    namespace       = optional(string)
    token_ttl       = optional(number, 300)
    token_max_ttl   = optional(number, 300)
    token_policy    = list(string)
    kv_mount        = string
    credential_path = string
    absent          = optional(bool, false)
  }))
  default = {
    placeholder = {
      role_name       = "placeholder"
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
    ttl          = optional(string, "315360000") # Default 10 Jahre
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

variable "vault_pki_intermediates" {
  type = map(object({
    mount            = string
    common_name      = string
    signer_root_id   = string
    vault_server     = string
    ttl              = optional(number, "3600")
    max_ttl          = optional(number, "94608000")
    key_type         = optional(string, "ec")
    key_bits         = optional(number, 256)
    country          = optional(string, "DE")
    locality         = optional(string, "Bonn")
    province         = optional(string, "NRW")
    ou               = optional(string, "IT")
    organization     = optional(string, "Example Inc.")
    csr_auto_rebuild = optional(bool, false)
    csr_expiry       = optional(string, "72h")
    absent           = optional(bool, false)
  }))
  default = {
    inter = {
      mount          = "pki-intermediate"
      common_name    = "intermediate.example.com"
      vault_server   = "https://localhost:8200"
      signer_root_id = "pki-root"
      max_ttl        = "94608000"
      absent         = true
    }
  }
}

variable "vault_pki_roles" {
  type = map(object({
    mount              = string
    name               = string
    key_type           = optional(string, "ec")
    key_bits           = optional(number, 256)
    allowed_domains    = list(string)
    allow_subdomains   = optional(bool, false)
    allow_ip_sans      = optional(bool, false)
    allow_bare_domains = optional(bool, false)
    allow_glob_domains = optional(bool, true)
    allow_localhost    = optional(bool, false)
    generate_lease     = optional(bool, true)
    ttl                = optional(number, "7776000")
    max_ttl            = optional(number, "7776000")
    absent             = optional(bool, false)
  }))
  default = {
    inter = {
      mount           = "pki-inter-cluster1"
      allowed_domains = ["cluster1.apps.example.com"]
      name            = "cluster1"
      max_ttl         = "7776000"
      absent          = true
    }
  }
}
