# memos

## Install

Install memos as an Argo CD application

    argocd app create memos \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/memos/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace memos \
                        --revision HEAD \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune