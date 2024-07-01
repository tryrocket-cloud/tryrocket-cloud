# unbound

## Install

Install unbound as an Argo CD application

    argocd app create unbound \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/unbound/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace unbound \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
