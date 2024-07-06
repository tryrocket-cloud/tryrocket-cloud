ui = true

listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = 1
}

storage "postgresql" {
  connection_url = "postgres://vault:vault@postgres.postgre-16.svc.cluster.local:5432/vault"
}

api_addr = "https://vault.tryrocket.cloud"

disable_mlock = "true"

log_level = "debug"