# linkding

## Install

Install linkding as an Argo CD application

    argocd app create linkding \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/linkding/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace linkding \
                        --revision HEAD \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune