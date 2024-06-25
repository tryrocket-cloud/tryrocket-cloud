# pgadmin4

## Install

    kubectl create namespace postgres
    
        argocd app create pgadmin \
                                   --repo https://helm.runix.net \
                                   --path . \
                                   --dest-server https://192.168.178.101:6443 \
                                   --dest-namespace postgres \
                                   --helm-chart pgadmin4 \
                                   --revision 1.26.0 \
                                   --project default \
                                   --sync-policy automated \
                                   --self-heal \
                                   --auto-prune



## Links

- https://artifacthub.io/packages/helm/runix/pgadmin4
