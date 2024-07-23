# magicpack

## Install

Install magicpack as an Argo CD application

    argocd app create magicpack \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/magicpack/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace magicpack \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
