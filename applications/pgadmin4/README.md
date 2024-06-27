# pgadmin4

## Install

    kubectl create namespace pgadmin4
    
    argocd app create pgadmin4 \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/pgadmin4/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace pgadmin4 \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

# Manual steps

- create new user
- delete default user

## Links

- https://artifacthub.io/packages/helm/runix/pgadmin4
