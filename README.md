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
