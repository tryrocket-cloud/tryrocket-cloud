## Before prod

name: vault
namespace: vault

## Install

    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault-helm/application.yaml -n argocd

## After install

    vault operator init

    https://vault.tryrocket.cloud/ui/vault/unseal

    # Configure Kubernetes 
    https://vault.tryrocket.cloud/ui/vault/secrets/kubernetes/kubernetes/configuration