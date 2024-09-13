# Vault

## Prerequisites

- [External Secrets Operator](https://external-secrets.io/latest/) is installed

- [Vault](https://www.vaultproject.io/) is installed and configured

- Create Vaultwarden kubernetes role Vault

      vault write auth/kubernetes/role/vaultwarden \
          bound_service_account_names=vaultwarden-vault-sa \
          bound_service_account_namespaces=vaultwarden \
          policies=vaultwarden \
          ttl=24h

- Create Vaultwarden policy in Vault ([vaultwarden-policy.hcl](/applications/vaultwarden/overlays/production/vaultwarden-policy.hcl))
    
      vault policy write vaultwarden vaultwarden-policy.hcl

## Install
    
    # Argo CD Vault Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault/application.yaml -n argocd

    # Argo CD Vault Backup Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vault/backup-application.yaml -n argocd

## After install

    # Initialize Vault
    vault operator init

    https://vault.tryrocket.cloud/ui/vault/unseal

    # Configure Kubernetes 
    https://vault.tryrocket.cloud/ui/vault/secrets/kubernetes/kubernetes/configuration

    # CLI Login
    export VAULT_ADDR='https://vault.tryrocket.cloud'
    vault login

    - vault auth enable kubernetes
    - apply `tryrocket.cloud-policy.hcl`


## Cluster authentication

*TLDR;*

Service Account `vault-auth` with `system:auth-delegator` ClusterRole is needed to be able to generate a `token_reviewer_jwt` for Vault. `system:auth-delegator` grants permissions to use TokenReview API. Vault will be using `token_reviewer_jwt` as an authentication token for the TokenReview API calls. TokenReview API is the API to validate tokens. `token_reviewer_jwt` are short-lived tokens and for now need to be updated manually (need research).

### Create a service account for Vault Kubernetes authentication:

*Why:* Service Account is needed to generate a `token_reviewer_jwt` for 

    kubectl -n default create serviceaccount vault-auth

> [!NOTE]  
>
> When you create a service account, Kubernetes does not automatically generate a service account token secret in clusters using Kubernetes versions 1.24 and later. In those versions, Kubernetes has removed the automatic creation of service account tokens as part of the transition to a more secure TokenRequest API for short-lived tokens.

### Create token for `vault-auth` service account:

    kubectl -n default create token vault-auth
    kubectl -n default create token vault-auth --duration=24h

> [!NOTE]  
>
> `token_reviewer_jwt` is the token provided in the Vault configuration to enable Kubernetes authentication. It's used by Vault to validate service account tokens presented by other applications. In Kubernetes 1.24+, the `token_reviewer_jwt` is often short-lived when created using the TokenRequest API. This means you'll need to periodically update this token in Vault.

### How to validate if a token has permissions to perform a TokenReview

    # decode the token
    echo "$TOKEN" | cut -d '.' -f2 | base64 --decode | jq .

    # check permissions
    kubectl auth can-i create tokenreviews --as=system:serviceaccount:default:vault-auth -n default
    
### Who grants permissions to perform a TokenReview

[system:auth-delegator](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) Allows delegated authentication and authorization checks. This is commonly used by add-on API servers for unified authentication and authorization.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
...
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: system:auth-delegator # Grants access to the tokenreview API
...
```

### Combine `vault-auth` service account and `system:auth-delegator`

```yaml
# vault-cluster-role-binding.yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: vault-tokenreview-role-binding
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: system:auth-delegator   # Grants access to the tokenreview API
subjects:
- kind: ServiceAccount
    name: vault-auth
    namespace: default
```

    kubectl apply -f vault-cluster-role-binding.yaml

