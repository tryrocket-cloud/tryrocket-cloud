# cert-manager

## Install
    
    kubectl create namespace cert-manager
    
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

