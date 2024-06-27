# Postgres

## Install

Install PostgreSQL as an Argo CD application

    argocd app create postgres \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path infrastructure/postgres \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace postgres \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune