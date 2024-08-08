# cert-manager

## Installation

On `pi4` cluster:

    kubectl config use-context tryrocket.cloud

    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/infrastructure/cert-manager/application-pi4.yaml

    kubectl config use-context pi4

    kustomize build "https://github.com/tryrocket-cloud/tryrocket-cloud//infrastructure/cert-manager/overlays/pi4?ref=main" | kubectl apply -f -

On `tryrocket.cloud` cluster:

    kubectl config use-context tryrocket.cloud
    
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/infrastructure/cert-manager/application-tryrocket.cloud.yaml

    kustomize build "https://github.com/tryrocket-cloud/tryrocket-cloud//infrastructure/cert-manager/overlays/tryrocket.cloud?ref=main" | kubectl apply -f -
