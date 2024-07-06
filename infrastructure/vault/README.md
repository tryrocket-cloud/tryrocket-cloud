# vault

## Install

Install vault as an Argo CD application

    create database user 
    create a new database with this new user and matching the creds in deployment
    https://developer.hashicorp.com/vault/docs/configuration/storage/postgresql
    
    argocd app create vault \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/vault/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace vault \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
