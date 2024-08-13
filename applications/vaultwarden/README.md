# vaultwarden

## Install

Install vaultwarden as an Argo CD application

    create database user 
    create a new database with this new user and matching the creds in deployment

    argocd app create vaultwarden \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/vaultwarden/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace vaultwarden \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

## TODOs

remove unneeded permissions from backup-role.yaml