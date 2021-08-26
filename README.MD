# Dockerized Oracle 12c - With Sample Databases

## Pre requisites
- **Docker image**: you need to build your own docker image, you can find the resources to do that here: https://github.com/oracle/docker-images
## Setup
1 - Setup your compose.override file:
```yml
version: '3.8'
services:
  oracle:
    image: <my-oracle-19-image>
```

2 - Bring the container up:
``` bash
docker-compose up
```

3 - Download and copy the schemas to the `$ORACLE_HOME/demo/schema` directory:
``` bash
make setup
```

4 - Install the Schemas! You can check the next session for a more detailed view into the inputs:
```
make run-schemas
```

## Install scripts input
*: sys password is altered to `sys` during the `make setup` command, if you want it to be something else just change it directly in the [makefile](./Makefile#L2)
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
  - Step 4 - sys default password: * `sys`
  - Step 5 - log directory: ** `$ORACLE_HOME/demo/schema/human_resources/`
  - Step 6 - connection string: `localhost/ORCLPDB1`

Oneliner:
```
@?/demo/schema/human_resources/hr_main.sql hr users temp sys $ORACLE_HOME/demo/schema/human_resources/ localhost/ORCLPDB1
```

### OE/OC:
`@?/demo/schema/order_entry/oe_main.sql`
  - Step 1 - oe password: ** `oe`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - hr password: ** `hr` - *whatever you input for hr step 1*
  - Step 5 - sys default password: * `sys`
  - Step 6 - data directory: ** `$ORACLE_HOME/demo/schema/order_entry/`
  - Step 7 - log directory: ** `$ORACLE_HOME/demo/schema/order_entry/`
  - Step 8 - version: ** `v3`
  - Step 9 - connection string: `localhost/ORCLPDB1`

Oneliner:
```
@?/demo/schema/order_entry/oe_main.sql oe users temp hr sys $ORACLE_HOME/demo/schema/order_entry/ $ORACLE_HOME/demo/schema/order_entry/ v3 localhost/ORCLPDB1
```

### PM:
`@?/demo/schema/product_media/pm_main.sql`
  - Step 1 - hr password: ** `hr`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - oe password: ** `oe` - *whatever you input for oe/oc step 1*
  - Step 5 - sys default password: * `sys`
  - Step 6 - data directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 7 - log directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 8 - work path directory: ** `$ORACLE_HOME/demo/schema/product_media/`
  - Step 9 - connection string: `localhost/ORCLPDB1`

Oneliner:
```
@?/demo/schema/product_media/pm_main.sql hr users temp oe sys $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ localhost/ORCLPDB1
```

### IX:
`@?/demo/schema/info_exchange/ix_main.sql`
  - Step 1 - ix password: ** `ix`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - sys default password: * `sys`
  - Step 5 - log directory: ** `$ORACLE_HOME/demo/schema/info_exchange/`
  - Step 6 - version: ** `v3`
  - Step 7 - connection string: `localhost/ORCLPDB1`

Oneliner:
```
@?/demo/schema/info_exchange/ix_main.sql ix users temp sys $ORACLE_HOME/demo/schema/info_exchange/ v3 localhost/ORCLPDB1
```

### SH:
`@?/demo/schema/sales_history/sh_main.sql`
  - Step 1 - sh password: ** `sh`
  - Step 2 - tablespace: `users`
  - Step 3 - temp tablespace: `temp`
  - Step 4 - sys default password: * `sys`
  - Step 5 - data directory: ** `$ORACLE_HOME/demo/schema/sales_history/`
  - Step 6 - log directory: ** `$ORACLE_HOME/demo/schema/sales_history/`
  - Step 7 - version: ** `v3`
  - Step 8 - connection string: `localhost/ORCLPDB1`

Oneliner:
```
@?/demo/schema/sales_history/sh_main.sql sh users temp sys $ORACLE_HOME/demo/schema/sales_history/ $ORACLE_HOME/demo/schema/sales_history/ v3 localhost/ORCLPDB1
```

## FAQ

*Permission errors* - if you see a lot of file permission errors like `Cannot create directory "/opt/oracle/oradata/ORCLCDB".` while bringing the containers up for the first time, you need to change your oradata permissions:
```bash
$ chown -R o+w ./oradata
```
