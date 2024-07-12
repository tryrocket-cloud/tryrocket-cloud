# vikunja

## Install

Install vikunja as an Argo CD application

    create a longhorn volume
    create vikunja database user 
    create a new database with this new user and matching the creds in deployment

    argocd app create vikunja \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/vikunja/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace vikunja \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

## Backup

    data backup over cronjob

    longhorn volume
