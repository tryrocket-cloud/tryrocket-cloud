# Vault

## Prerequisites

- [External Secrets Operator](https://external-secrets.io/latest/) is installed

- [Vault](https://www.vaultproject.io/) is installed and configured

- Create Vaultwarden kubernetes role Vault

      vault write auth/kubernetes/role/vaultwarden \
          bound_service_account_names=vaultwarden-vault-sa \
          bound_service_account_namespaces=vaultwarden \
          policies=vaultwarden \
          ttl=24h

- Create Vaultwarden policy in Vault ([vaultwarden-policy.hcl](/applications/vaultwarden/overlays/production/vaultwarden-policy.hcl))
    
      vault policy write vaultwarden vaultwarden-policy.hcl

## Install
    
    # Argo CD Vault Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault/application.yaml -n argocd

    # Argo CD Vault Backup Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault/backup-application.yaml -n argocd

## After install

    # Initialize Vault
    vault operator init

    https://vault.tryrocket.cloud/ui/vault/unseal

    # Configure Kubernetes 
    https://vault.tryrocket.cloud/ui/vault/secrets/kubernetes/kubernetes/configuration

    # CLI Login
    export VAULT_ADDR='https://vault.tryrocket.cloud'
    vault login

    - vault auth enable kubernetes
    - apply `tryrocket.cloud-policy.hcl`
