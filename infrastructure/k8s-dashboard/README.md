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

## Get login token
