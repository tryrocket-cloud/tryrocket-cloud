# tryrocket-cloud

## How to

**Grant new database to vault admin**

    GRANT CONNECT ON DATABASE <db> TO <user> WITH GRANT OPTION;
    GRANT USAGE ON SCHEMA public TO <user> WITH GRANT OPTION;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO <user> WITH GRANT OPTION

https://github.com/tryrocket-cloud/tryrocket-cloud/issues/11