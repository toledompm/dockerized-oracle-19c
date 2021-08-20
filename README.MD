# Dockerized Oracle 12c - With Sample Databases
## Setup

1 - First things first, you need to "buy" (developer tier is free as of the time of writing) Oracle Database Enterprise Edition from [dockerhub](https://hub.docker.com/_/oracle-database-enterprise-edition)

2 - Login to the docker-hub account you used for step 1 ([docs](https://docs.docker.com/engine/reference/commandline/login/)):
``` bash
docker login --username <foo> --password-stdin
```

3 - Bring the container up:
``` bash
docker-compose up
```

4 - Download and copy the schemas to the `$ORACLE_HOME/demo/schema` directory:
``` bash
make setup
```

5 - Install the Schemas! You can check the next session for a more detailed view into the inputs:
```
make run-schemas
```

## Install scripts input
**: Not exactly the right or recomended answer, just what I wanted to input

If installing manually, after each install I recommend exiting and reconnecting:
``` bash
SQL > exit
...
$ > make sys
```

### HR:
`@?/demo/schema/human_resources/hr_main.sql`
  - Step 1 - hr password: ** `hr`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - sys default password: `Oradoc_db1`
  - Step 5 - log directory: ** `$ORACLE_HOME/demo/schema/human_resources/`
  - Step 6 - connection string: `localhost/orclpdb1.localdomain`

Oneliner:
```
@?/demo/schema/human_resources/hr_main.sql hr users temp Oradoc_db1 $ORACLE_HOME/demo/schema/human_resources/ localhost/orclpdb1.localdomain
```

### OE/OC:
`@?/demo/schema/order_entry/oe_main.sql`
  - Step 1 - oe password: ** `oe`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - hr password: ** `hr` - *whatever you input for hr step 1*
  - Step 5 - sys default password: `Oradoc_db1`
  - Step 6 - data directory: ** `$ORACLE_HOME/demo/schema/order_entry/`
  - Step 7 - log directory: ** `$ORACLE_HOME/demo/schema/order_entry/`
  - Step 8 - version: ** `v3`
  - Step 9 - connection string: `localhost/orclpdb1.localdomain`

Oneliner:
```
@?/demo/schema/order_entry/oe_main.sql oe users temp hr Oradoc_db1 $ORACLE_HOME/demo/schema/order_entry/ $ORACLE_HOME/demo/schema/order_entry/ v3 localhost/orclpdb1.localdomain
```

### PM:
`@?/demo/schema/product_media/pm_main.sql`
  - Step 1 - hr password: ** `hr`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - oe password: ** `oe` - *whatever you input for oe/oc step 1*
  - Step 5 - sys default password: `Oradoc_db1`
  - Step 6 - data directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 7 - log directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 8 - work path directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 9 - connection string: `localhost/orclpdb1.localdomain`

Oneliner:
```
@?/demo/schema/product_media/pm_main.sql hr users temp oe Oradoc_db1 $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ localhost/orclpdb1.localdomain
```

### IX:
`@?/demo/schema/info_exchange/ix_main.sql`
  - Step 1 - ix password: ** `ix`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - sys default password: `Oradoc_db1`
  - Step 5 - log directory: ** `$ORACLE_HOME/demo/schema/info_exchange/`
  - Step 6 - version: ** `v3`
  - Step 7 - connection string: `localhost/orclpdb1.localdomain`

Oneliner:
```
@?/demo/schema/info_exchange/ix_main.sql ix users temp Oradoc_db1 $ORACLE_HOME/demo/schema/info_exchange/ v3 localhost/orclpdb1.localdomain
```

### SH:
`@?/demo/schema/sales_history/sh_main.sql`
  - Step 1 - sh password: ** `sh`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - sys default password: `Oradoc_db1`
  - Step 5 - data directory: ** `$ORACLE_HOME/demo/schema/sales_history/`
  - Step 6 - log directory: ** `$ORACLE_HOME/demo/schema/sales_history/`
  - Step 7 - version: ** `v3`
  - Step 8 - connection string: `localhost/orclpdb1.localdomain`

Oneliner:
```
@?/demo/schema/sales_history/sh_main.sql sh users temp Oradoc_db1 $ORACLE_HOME/demo/schema/sales_history/ $ORACLE_HOME/demo/schema/sales_history/ v3 localhost/orclpdb1.localdomain
```

## Optional steps:
1 - Create a `docker-compose.override.yml` file to set a new value for `DB_MEMORY`:
``` yml
version: '3.8'
services:
  oracle:
    environment:
      DB_MEMORY: 4GB
```

## Sources:
- https://github.com/oracle/db-sample-schemas/
- https://github.com/oracle/docker-images/
- https://blog.dbi-services.com/migrating-the-oracle-12cr1-sample-schemas-to-postgresql-plus-advanced-server-9-4/
