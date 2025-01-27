# Argo CD

## Install

- `helm repo add argo https://argoproj.github.io/argo-helm`
- `helm repo update`
- `kubectl create namespace argocd`
- `helm install argocd argo/argo-cd --namespace argocd -f argocd-values.yaml`
- `kubectl apply -f argocd-dashboard-ingress.yaml`
- get first time login password - `argocd admin initial-password -n argocd`

## change first time login password (not working)

- `argocd login argocd.tryrocket.cloud`
- `argocd login argocd.tryrocket.cloud --grpc-web`
- `argocd account update-password --account admin --grpc-web`

## change first time login password (working)

- `htpasswd -bnBC 10 "" "newpassword" | tr -d ':\n'`
- generate password

      patch secret - kubectl -n argocd patch secret argocd-secret \
                  -p '{"stringData": {
                "admin.password": "<new password hash>",
                "admin.passwordMtime": "'$(date +%FT%T%Z)'"
              }}'



## add capabilities to admin

https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#create-new-user

    argocd account list

One does not simply login with a token.... one simply uses it, like so:
argocd app list --server argocd.blabla.com --insecure --auth-token {AUTH_TOKEN}