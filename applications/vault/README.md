# Vault

## Install

    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault/application.yaml -n argocd

## After install

    vault operator init

    https://vault.tryrocket.cloud/ui/vault/unseal

    # Configure Kubernetes 
    https://vault.tryrocket.cloud/ui/vault/secrets/kubernetes/kubernetes/configuration