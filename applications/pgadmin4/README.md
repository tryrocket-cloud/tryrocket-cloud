# pgadmin4

## Install

    kubectl create namespace postgres
    
    argocd app create pgadmnin4 \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/pgadmin4/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace postgres \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

## Links

- https://artifacthub.io/packages/helm/runix/pgadmin4
