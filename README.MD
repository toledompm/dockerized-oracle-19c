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
```
make setup
```

5 - Now all thats left, is to connect to the database and install the schemas, you can head over to the official docs for a step by step guide on how to do that: https://docs.oracle.com/database/121/COMSC/installation.htm. To connect to the database you can just run:
```
make sys
```

## FAQ
### HR Install:
  - Step 4 - sys default password: `Oradoc_db1`
  - Step 6 - connection string: `localhost/orclpdb1.localdomain`

## Sources:
- https://github.com/oracle/db-sample-schemas/
- https://github.com/oracle/docker-images/
