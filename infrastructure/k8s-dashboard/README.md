# kubernetes-dashboard

## Install

    argocd app create kubernetes-dashboard \
                     --repo https://kubernetes.github.io/dashboard/ \
                     --path . \
                     --dest-server https://192.168.178.101:6443 \
                     --dest-namespace kube-system \
                     --helm-chart kubernetes-dashboard \
                     --revision 7.5.0 \
                     --project default \
                     --sync-policy automated \
                     --self-heal \
                     --auto-prune

    argocd app create kubernetes-dashboard-tryrocket-cloud \
                                   --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                                   --path infrastructure/k8s-dashboard \
                                   --dest-server https://192.168.178.101:6443 \
                                   --dest-namespace kube-system \
                                   --revision HEAD \
                                   --project default \
                                   --sync-policy automated \
                                   --self-heal \
                                   --auto-prune

    kubectl create serviceaccount dashboard-admin-sa -n kube-system
    kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin-sa
    
## Get login token
