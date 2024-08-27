alias le := list-environments
alias la := list-apps

alias ad := app-deploy
alias al := app-list
alias ag := app-get
alias as := app-sync
alias au := app-undeploy

# This help
help:
    @just --list

# Prints ArgoCD version
argocd-version:
    @argocd version

# ArgoCD login to the server
argocd-login server="argocd.tryrocket.cloud":
    @argocd login {{server}}

# ArgoCD logout from server
argocd-logout server="argocd.tryrocket.cloud":
    @argocd logout {{server}}

# List kustomize environments
list-environments app:
    @echo "Fetching environments from repository..."
    @curl -sL https://api.github.com/repos/tryrocket-cloud/tryrocket-cloud/contents/applications/{{app}}/overlays | jq -r '.[] | select(.type=="dir") | .name'

# List possible applciations for deployment
list-apps:
    @echo "Fetching application from repository..."
    @curl -sL https://api.github.com/repos/tryrocket-cloud/tryrocket-cloud/contents/applications | jq -r '.[] | select(.type=="dir") | .name'

# Deploy an app
app-deploy app environment="production":
    @kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/{{app}}/overlays/{{environment}}/application.yaml -n argocd

# List deployed apps
app-list:
    @argocd app list

# Get information of deployed app
app-get app:
    @argocd app get {{app}}

# Sync deployed app
app-sync app:
    @argocd app sync {{app}}

# Delete deployed app
app-undeploy app:
    @argocd app delete {{app}}

# Build kustomize environment
kustomize-build-environment app environment="production":
    kustomize build "https://github.com/tryrocket-cloud/tryrocket-cloud.git/applications/{{app}}/overlays/{{environment}}?ref=main"