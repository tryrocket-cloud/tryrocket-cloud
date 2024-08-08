# cert-manager

## Install 08.08.2024

    kubectl apply -f cert-manager-application.yaml


## Install
    
    kubectl create namespace cert-manager
    
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.crds.yaml
    
    argocd app create cert-manager \
                     --repo https://charts.jetstack.io \
                     --path . \
                     --dest-server https://192.168.178.120:6443 \
                     --dest-namespace cert-manager \
                     --helm-chart cert-manager \
                     --revision 1.15.1 \
                     --project default \
                     --sync-policy automated \
                     --self-heal \
                     --auto-prune

