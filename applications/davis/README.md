# davis

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