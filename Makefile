sys:
	docker-compose exec oracle bash -c \
		"source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba"

bash:
	docker-compose exec oracle bash -c \
		"source /home/oracle/.bashrc; bash"

SCHEMA_DIR="/u01/app/oracle/product/12.2.0/dbhome_1/demo/schema"
setup: download-schemas cp-schemas

cp-schemas:
	docker-compose exec oracle bash -c \
		"source /home/oracle/.bashrc && \
		 cd $(SCHEMA_DIR) && \
		 cp -r /home/oracle/db-sample-schemas/* ."

download-schemas:
	curl -L https://github.com/oracle/db-sample-schemas/archive/refs/tags/v12.2.0.1.zip > ./v12.2.0.1.zip
	unzip ./v12.2.0.1.zip
	rm -rf ./v12.2.0.1.zip
	cd db-sample-schemas-12.2.0.1 && perl -p -i.bak -e 's#__SUB__CWD__#'$(SCHEMA_DIR)'#g' *.sql */*.sql */*.dat
