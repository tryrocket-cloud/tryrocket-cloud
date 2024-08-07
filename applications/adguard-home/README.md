# adguard-home

## Install

Install adguard-home as an Argo CD application

    create database user 
    create a new database with this new user and matching the creds in deployment

    argocd app create adguard-home \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/adguard-home/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace adguard-home \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

    argocd app create adguard-home \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/adguard-home/overlays/pi4 \
                        --dest-server https://192.168.178.75:6443 \
                        --dest-namespace adguard-home \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune


    kubectl apply -f adguard-home-configmap.yaml

    # Check AdGuardHome.yaml
    docker run --rm -v ./AdGuardHome.yaml:/opt/adguardhome/AdGuardHome.yaml adguard/adguardhome:latest --check-config -c /opt/adguardhome/AdGuardHome.yaml