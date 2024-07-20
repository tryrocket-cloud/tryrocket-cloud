# semaphore

## Install

Install semaphore as an Argo CD application

    create database user 
    create a new database with this new user and matching the creds in deployment

    argocd app create semaphore \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/semaphore/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace semaphore \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
