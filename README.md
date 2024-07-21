# tryrocket-cloud

## How to

**Grant new database to vault admin**

    GRANT CONNECT ON DATABASE <db> TO <user> WITH GRANT OPTION;
    GRANT USAGE ON SCHEMA public TO <user> WITH GRANT OPTION;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO <user> WITH GRANT OPTION

https://github.com/tryrocket-cloud/tryrocket-cloud/issues/11
https://github.com/tryrocket-cloud/tryrocket-cloud/issues/12

**Vault and dynamic creds**

    vault write database/config/<connection> \
            plugin_name=postgresql-database-plugin \
            allowed_roles="<role-name>" \
            connection_url="postgresql://{{username}}:{{password}}@<host>:5432/<db name>?sslmode=disable" \
            username="<user>" \
            password="<pw>"

    vault write database/roles/<role-name> \
            db_name=<db name> \
            creation_statements="
            CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
            GRANT USAGE ON SCHEMA public TO \"{{name}}\";
            GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public
            GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO \"{{name}}\";" \
            default_ttl="1h" \
            max_ttl="24h"

    vault read database/roles/gitea-admin-role # read config
    vault read database/creds/gitea-admin-role # Generate new dynamic creds
    vault list sys/leases/lookup/database/creds/<role-name> # list all leases
    vault write -force sys/leases/revoke-force/database/creds/<role-name> # remove force all leases
    vault lease revoke -prefix database/creds/<role-name> # scheduled lease revoke
    vault read sys/mounts/database/tune # list config
    vault write sys/mounts/database/tune default_lease_ttl=1h max_lease_ttl=24h # set ttls 

## Installed

- https://github.com/stakater/Reloader
