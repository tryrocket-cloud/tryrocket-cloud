# linkding

- [GitHub](https://github.com/seriousm4x/UpSnap)
- [GitHub Releases](https://github.com/seriousm4x/UpSnap/releases)

## Install

Install as an Argo CD application

    argocd app create upsnap \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/upsnap/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace upsnap \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune
