# mailrise

## Install

Install mailrise as an Argo CD application

    kubectl create namespace mailrise
    kubectl apply -f mailrise-configmap.yaml

    argocd app create mailrise \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/mailrise/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace mailrise \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune