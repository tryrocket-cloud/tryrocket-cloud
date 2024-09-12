# davis

## Prerequisites

- [External Secrets Operator](https://external-secrets.io/latest/) is installed

- [Vault](https://www.vaultproject.io/) is installed and configured

- Create Davis kubernetes role Vault

      vault write auth/kubernetes/role/davis \
          bound_service_account_names=davis-vault-sa \
          bound_service_account_namespaces=davis \
          policies=davis \
          ttl=24h

- Create Davis policy in Vault ([davis-policy.hcl](/applications/davis/overlays/production/davis-policy.hcl))
    
      vault policy write davis davis-policy.hcl

## First Run

> [!IMPORTANT]
> 
> ⚠ Do not forget to run all the database migrations the first time you run the container :
>
>     docker exec -it davis sh -c "APP_ENV=prod bin/console doctrine:migrations:migrate --no-interaction"

## TODO

- add longhorn-volumes as k8s manifests
- add longhorn recurring tasks for snapshot an backup


## Install

    # Argo CD Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/davis/overlays/production/application.yaml -n argocd

    # Argo CD Preview Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/davis/overlays/preview/application-set.yaml -n argocd


## Install

Install davis as an Argo CD application

    create database 
    create a new database with this new user and matching the creds in deployment

    argocd app create davis \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/davis/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace davis \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune


## Update

- https://github.com/tchapi/davis?tab=readme-ov-file#updating-from-a-previous-version (db migration)
- change davis version for restic backup/kustomization.yaml

## Links

- https://davis.tryrocket.cloud/dashboard
- https://davis.tryrocket.cloud/dav
- https://davis.tryrocket.cloud/dav/principals/<name>

## Notes

```sql
vault write database/config/davis \
    plugin_name=postgresql-database-plugin \
    allowed_roles="davis-static-role" \
    connection_url="postgresql://{{username}}:{{password}}@postgres.postgres-16.svc.cluster.local:5432/davis?sslmode=disable" \
    username="v-davis" \
    password="test123"

vault write database/static-roles/davis-static-role \
    db_name=davis \
    rotation_statements="ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';" \
    username="u-davis" \
    rotation_period="24h`
```