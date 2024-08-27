alias av := argocd-version
alias ali := argocd-login
alias alo := argocd-logout
alias aal := argocd-app-list
alias aag := argocd-app-get
alias aas := argocd-app-sync
alias aad := argocd-app-delete
alias aac := argocd-app-create

alias le := list-environments
alias kbe := kustomize-build-environment

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

# List ArgoCD apps
argocd-app-list:
    @argocd app list

# Creates an ArgoCD app
argocd-app-create app environment:
    @kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/{{app}}/overlays/{{environment}}/application.yaml -n argocd

# Get information of ArgoCD app
argocd-app-get app:
    @argocd app get {{app}}

# Sync ArgoCD app with GitHub repository
argocd-app-sync app:
    @argocd app sync {{app}}

# Delete ArgoCD app
argocd-app-delete app:
    @argocd app delete {{app}}

# List kustomize overlays
list-environments app:
    @echo "Fetching environments from repository..."
    @curl -sL https://api.github.com/repos/tryrocket-cloud/tryrocket-cloud/contents/applications/{{app}}/overlays | jq -r '.[] | select(.type=="dir") | .name'

# List kustomize overlays
list-applications:
    @echo "Fetching application from repository..."
    @curl -sL https://api.github.com/repos/tryrocket-cloud/tryrocket-cloud/contents/applications | jq -r '.[] | select(.type=="dir") | .name'

# Build kustomize environment
kustomize-build-environment app environment:
    kustomize build "https://github.com/tryrocket-cloud/tryrocket-cloud.git/applications/{{app}}/overlays/{{environment}}?ref=main"