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

    kubectl create serviceaccount dashboard-admin-sa -n kube-system
    kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin-sa
    kubectl apply -f k8s-dashboard-tryrocket-cloud-tls-cert.yaml
    kubectl apply -f kubernetes-dashboard-ingress.yaml
## Get login token
