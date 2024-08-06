# opengist

- [GitHub](https://github.com/thomiceli/opengist)

## Install

Install opengist as an Argo CD application

    argocd app create opengist \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/opengist/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace opengist \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
