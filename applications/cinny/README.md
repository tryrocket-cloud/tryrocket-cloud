# cinny

- [GitHub](https://github.com/cinnyapp/cinny)
- [Release Page](https://github.com/cinnyapp/cinny/releases)

## Install

Install cinny as an Argo CD application

    argocd app create cinny \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/cinny/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace cinny \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
