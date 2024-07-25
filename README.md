# tryrocket-cloud

## How to

**Grant new database to vault admin**

    GRANT CONNECT ON DATABASE <db> TO <user> WITH GRANT OPTION;
    GRANT USAGE, CREATE ON SCHEMA public TO <user> WITH GRANT OPTION;
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


## Vault stattic roles

    # create a <vault user>
    CREATE ROLE <vault user> WITH LOGIN PASSWORD 'secure_password';
    ALTER ROLE <vault user> WITH CREATEROLE;

    # create database
    # connect to database

    # create a <app user>
    CREATE ROLE <app user> WITH LOGIN PASSWORD 'test123';
    GRANT CONNECT ON DATABASE <db name> TO <app user>;
    GRANT USAGE ON SCHEMA public TO <app user>;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO <app user>;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO <app user>;
    GRANT <app user> TO <vault user> WITH ADMIN OPTION;

    vault write database/config/<app user> \
                      plugin_name=postgresql-database-plugin \
                      allowed_roles="<app user>-static-role" \
                      connection_url="postgresql://{{username}}:{{password}}@postgres.postgres-16.svc.cluster.local:5432/<db name>?sslmode=disable" \
                      username="<vault user>" \
                      password="<vault user password>"

    vault write database/static-roles/<app user>-static-role \
                                         db_name=<db name> \
                                         rotation_statements="ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';" \
                                         username="<app user>" \
                                         rotation_period="24h"

    # read creds
    vault read database/static-creds/<app user>-static-role

    # rotate creds
    vault write -f database/rotate-role/<app user>-static-role