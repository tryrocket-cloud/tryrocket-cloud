# Homer

## Requirements

- [Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli)

## Install

Install Homer as an Argo CD application

    argocd app create homer \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/homer/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace homer \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
