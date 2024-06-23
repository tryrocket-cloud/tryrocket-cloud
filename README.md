# tryrocket-cloud

## Install

```
argocd app create homer \
                    --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                    --path applications/homer \
                    --dest-server https://192.168.178.101:6443 \
                    --dest-namespace homer \
                    --revision HEAD \
                    --project default \
                    --sync-policy automated \
                    --self-heal \
                    --auto-prune
```