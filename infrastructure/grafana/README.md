# grafana

## Install

Install grafana as an Argo CD application
    
    create grafana volunme
    argocd app create grafana \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/grafana/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace grafana \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
