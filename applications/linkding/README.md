# linkding

- [GitHub](https://github.com/sissbruecker/linkding)
- [DockerHub](https://hub.docker.com/r/sissbruecker/linkding)

## Install

Install linkding as an Argo CD application

    argocd app create linkding \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/linkding/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace linkding \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

     python manage.py createsuperuser --username=joe --email=joe@example.com

## Dev Notes

- Vault postgres user `v-linkding`
- linkding postgres user `u-linkding`
- Vault changes credentials every 24h
- `External Secrets` operator updates credentials in the pod every 1h
- `u-linkding` is the owner of the database `linkding`


## Example linkding

Create a 'v-lingding' postgres user with LOGIN and CREATEROLE capabilities to be able to connect from vault.  Create a 'u-lingding' postgres user with LOGIN capabilities to be able to connect from pods. Add capabilities to 'v-lingding' to change password for 'u-lingding'

### Postgres

```sql
CREATE ROLE "v-linkding" WITH 
    LOGIN 
    NOSUPERUSER 
    NOCREATEDB 
    CREATEROLE 
    NOINHERIT 
    NOREPLICATION 
    NOBYPASSRLS 
    CONNECTION LIMIT -1 
    PASSWORD 'test123';
GRANT CONNECT ON DATABASE linkding TO "v-linkding";

CREATE ROLE "u-linkding" WITH
    LOGIN
    NOSUPERUSER 
    NOCREATEDB 
    NOCREATEROLE 
    NOINHERIT 
    NOREPLICATION 
    NOBYPASSRLS 
    CONNECTION LIMIT -1 
    PASSWORD 'test123';
GRANT CONNECT ON DATABASE linkding TO "u-linkding";
GRANT USAGE, CREATE ON SCHEMA public TO "u-linkding";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "u-linkding";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "u-linkding";
GRANT "u-linkding" TO "v-linkding" WITH ADMIN OPTION;
```

### Vault
```sh
vault write database/config/linkding \
    plugin_name=postgresql-database-plugin \
    allowed_roles="linkding-static-role" \
    connection_url="postgresql://{{username}}:{{password}}@postgres.postgres-16.svc.cluster.local:5432/linkding?sslmode=disable" \
    username="v-linkding" \
    password="test123"

vault write database/static-roles/linkding-static-role \
    db_name=linkding \
    rotation_statements="ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';" \
    username="u-linkding" \
    rotation_period="24h"

# read creds
vault read database/static-creds/linkding-static-role

# rotate creds
vault write -f database/rotate-role/linkding-static-role
```

### TODO:

- clean up linkding database from unneeded users
