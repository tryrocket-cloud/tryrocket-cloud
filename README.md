# tryrocket-cloud

## TLDR;

    # list all applications
    just list-apps

    # list all environments of an application
    just list-environments <application>

    # create argocd application
    just app-deploy <application> <environment>

## Prerequisites

- [k3s](https://k3s.io/)
- [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [External Secrets Operator](https://external-secrets.io/latest/)
- [cert-manager](https://cert-manager.io/)
- [Longhorn](https://longhorn.io/)
- [stakater](https://docs.stakater.com/reloader/#)
- [#44](https://github.com/tryrocket-cloud/tryrocket-cloud/issues/44) [Argo CD Vault Plugin ](https://argocd-vault-plugin.readthedocs.io/en/stable/)

## Tools

- Longhorn cli
- Argo CD cli
- Ansible
- kubectl
- yq
- jq
- Postgres tool
  - pg_dump
  - pg_reatore
- Docker
- Just
- Kustomize


## Additional Services

- [Hetzner](https://www.hetzner.com/)
- [IONOS Cloud](https://cloud.ionos.de/)
- [IONOS](https://www.ionos.de)
- [Cloudflare](https://www.cloudflare.com)
- [GitHub](https://github.com/)

## Installation

- Prepare Debian nodes
  - Install Debian OS
  - Install k3s on each node and connect to each other
  - Install neovim, fish
- Install ArgoCD
- Install Vault (ArgoCD Application + Helm)
- Install External Secrets Operator (ArgoCD Application + Helm)
- Install CertManager
- Install Longhorn