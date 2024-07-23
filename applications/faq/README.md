# faq


## Install

Install faq as an Argo CD application

    argocd app create faq \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/faq/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace faq \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune


          volumeMounts:
            - name: faq-config
              mountPath: /usr/share/nginx/html/index.html
              subPath: index.html
              readOnly: true