provider "ionoscloud" {
  token         = var.ionos_token
  s3_access_key = var.s3_access_key
  s3_secret_key = var.s3_secret_key
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

# Create tryrocket.cloud bucket
resource "ionoscloud_s3_bucket" "tryrocket_cloud_bucket" {
  name   = var.bucket_name
  region = "eu-central-3"
}

# Groups
resource "ionoscloud_group" "tryrocket_cloud_group_s3" {
  name         = "s3"
  s3_privilege = true
}

# Users
resource "ionoscloud_user" "vaultwarden" {
  first_name     = "Application"
  last_name      = "Vaultwarden"
  email          = var.user_vaultwarden_email
  password       = random_password.vaultwarden.result
  administrator  = false
  force_sec_auth = false
  active         = true
  group_ids      = [ionoscloud_group.tryrocket_cloud_group_s3.id]
}
resource "ionoscloud_user" "vault" {
  first_name     = "Application"
  last_name      = "Vault"
  email          = var.user_vault_email
  password       = random_password.vault.result
  administrator  = false
  force_sec_auth = false
  active         = true
  group_ids      = [ionoscloud_group.tryrocket_cloud_group_s3.id]
}
resource "ionoscloud_user" "davis" {
  first_name     = "Application"
  last_name      = "Davis"
  email          = var.user_davis_email
  password       = random_password.davis.result
  administrator  = false
  force_sec_auth = false
  active         = true
  group_ids      = [ionoscloud_group.tryrocket_cloud_group_s3.id]
}

# Generate a random password for the user
resource "random_password" "vaultwarden" {
  length  = 128
  special = false
}
# Generate a random password for the user
resource "random_password" "vault" {
  length  = 128
  special = false
}
# Generate a random password for the user
resource "random_password" "davis" {
  length  = 128
  special = false
}

# Grant the user access to the S3 bucket
resource "ionoscloud_s3_key" "vaultwarden_s3_key" {
  user_id = ionoscloud_user.vaultwarden.id
  active  = true
}
resource "ionoscloud_s3_key" "vault_s3_key" {
  user_id = ionoscloud_user.vault.id
  active  = true
}
resource "ionoscloud_s3_key" "davis_s3_key" {
  user_id = ionoscloud_user.davis.id
  active  = true
}

resource "vault_kv_secret_v2" "store_vaultwarden" {
  mount = "kv"
  name  = format("ionos.com/users/%s", ionoscloud_user.vaultwarden.email)

  data_json = jsonencode({
    id                   = ionoscloud_user.vaultwarden.id,
    password             = random_password.vaultwarden.result,
    administrator        = ionoscloud_user.vaultwarden.administrator,
    s3_canonical_user_id = ionoscloud_user.vaultwarden.s3_canonical_user_id,
    AWS_ACCESS_KEY       = ionoscloud_s3_key.vaultwarden_s3_key.id,
    AWS_SECRET_KEY       = ionoscloud_s3_key.vaultwarden_s3_key.secret_key
  })
}
resource "vault_kv_secret_v2" "store_vault" {
  mount = "kv"
  name  = format("ionos.com/users/%s", ionoscloud_user.vault.email)

  data_json = jsonencode({
    id                   = ionoscloud_user.vault.id,
    password             = random_password.vault.result,
    administrator        = ionoscloud_user.vault.administrator,
    s3_canonical_user_id = ionoscloud_user.vault.s3_canonical_user_id,
    AWS_ACCESS_KEY       = ionoscloud_s3_key.vault_s3_key.id,
    AWS_SECRET_KEY       = ionoscloud_s3_key.vault_s3_key.secret_key
  })
}
resource "vault_kv_secret_v2" "store_davis" {
  mount = "kv"
  name  = format("ionos.com/users/%s", ionoscloud_user.davis.email)

  data_json = jsonencode({
    id                   = ionoscloud_user.davis.id,
    password             = random_password.davis.result,
    administrator        = ionoscloud_user.davis.administrator,
    s3_canonical_user_id = ionoscloud_user.davis.s3_canonical_user_id,
    AWS_ACCESS_KEY       = ionoscloud_s3_key.davis_s3_key.id,
    AWS_SECRET_KEY       = ionoscloud_s3_key.davis_s3_key.secret_key
  })
}

resource "ionoscloud_s3_bucket_policy" "tryrocket_cloud_bucket_policy" {
  bucket = ionoscloud_s3_bucket.tryrocket_cloud_bucket.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Principal = [
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.vaultwarden.id)}",
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.vault.id)}",
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.davis.id)}",
        ]
        Resource = [
          "${format("arn:aws:s3:::%s", var.bucket_name)}",
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Principal = [
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.vaultwarden.id)}"
        ]
        Resource = [
          "${format("arn:aws:s3:::%s/vaultwarden/*", var.bucket_name)}",
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Principal = [
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.vault.id)}"
        ]
        Resource = [
          "${format("arn:aws:s3:::%s/vault/*", var.bucket_name)}",
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Principal = [
          "${format("arn:aws:iam:::user/%s:%s", var.ionos_contract, ionoscloud_user.davis.id)}"
        ]
        Resource = [
          "${format("arn:aws:s3:::%s/davis/*", var.bucket_name)}",
        ]
      }
    ]
  })
}

