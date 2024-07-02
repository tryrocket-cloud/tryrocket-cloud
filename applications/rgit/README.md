# rgit

## Install

Install rgit as an Argo CD application

    argocd app create rgit \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/rgit/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace rgit \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
