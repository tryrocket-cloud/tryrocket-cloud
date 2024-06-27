# Postgres

## Install

Install PostgreSQL as an Argo CD application

    argocd app create postgres-16 \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/postgres/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace postgres-16 \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune