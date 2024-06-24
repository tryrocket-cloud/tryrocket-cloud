# kubernetes-dashboard

## Install

    kubectl create namespace kubernetes-dashboard
    
    argocd app create kubernetes-dashboard \
                     --repo https://kubernetes.github.io/dashboard/ \
                     --path . \
                     --dest-server https://192.168.178.101:6443 \
                     --dest-namespace kubernetes-dashboard \
                     --helm-chart kubernetes-dashboard \
                     --revision 7.5.0 \
                     --project default \
                     --sync-policy automated \
                     --self-heal \
                     --auto-prune

    argocd app create kubernetes-dashboard-tryrocket-cloud \
                                   --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                                   --path infrastructure/kubernetes-dashboard \
                                   --dest-server https://192.168.178.101:6443 \
                                   --dest-namespace kubernetes-dashboard \
                                   --revision main \
                                   --project default \
                                   --sync-policy automated \
                                   --self-heal \
                                   --auto-prune

## Get login token

    kubectl -n kubernetes-dashboard create token admin-user