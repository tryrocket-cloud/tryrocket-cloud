# davis

## Install

Install davis as an Argo CD application

    create database 
    create a new database with this new user and matching the creds in deployment

    argocd app create davis \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/davis/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace davis \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

## Links

- https://davis.tryrocket.cloud/dashboard
- https://davis.tryrocket.cloud/dav
- https://davis.tryrocket.cloud/dav/principals/<name>

## Notes

- vault static postgres role