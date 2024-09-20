variable "vault_token" {
  description = "Vault API token"
}
variable "vault_address" {
  description = "Vault API address"
  type        = string
}

variable "ionos_token" {
  description = "Token for IONOS Cloud API"
  type        = string
}

variable "s3_access_key" {
  description = "Token for IONOS Cloud API"
  type        = string
}
variable "s3_secret_key" {
  description = "Token for IONOS Cloud API"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket to create"
  type        = string
}

variable "user_vaultwarden_email" {}
variable "user_vault_email" {}
variable "user_davis_email" {}
variable "ionos_contract" {
  type = string
}
