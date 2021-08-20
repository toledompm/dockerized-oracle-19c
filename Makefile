sys:
	docker-compose exec oracle \
		bash -c "source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba"

bash:
	docker-compose exec oracle \
		bash -c "source /home/oracle/.bashrc; bash"

SCHEMA_DIR="/u01/app/oracle/product/12.2.0/dbhome_1/demo/schema"
setup: download-schemas cp-schemas

run-schemas:
	docker-compose exec oracle \
		bash -c "source /home/oracle/.bashrc; \
			echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/human_resources/hr_main.sql hr users temp Oradoc_db1 $ORACLE_HOME/demo/schema/human_resources/ localhost/orclpdb1.localdomain && \
			echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/order_entry/oe_main.sql oe users temp hr Oradoc_db1 $ORACLE_HOME/demo/schema/order_entry/ $ORACLE_HOME/demo/schema/order_entry/ v3 localhost/orclpdb1.localdomain && \
			echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/product_media/pm_main.sql hr users temp oe Oradoc_db1 $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ $ORACLE_HOME/demo/schema/product_media/ localhost/orclpdb1.localdomain && \
			echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/info_exchange/ix_main.sql ix users temp Oradoc_db1 $ORACLE_HOME/demo/schema/info_exchange/ v3 localhost/orclpdb1.localdomain && \
			echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/sales_history/sh_main.sql sh users temp Oradoc_db1 $ORACLE_HOME/demo/schema/sales_history/ $ORACLE_HOME/demo/schema/sales_history/ v3 localhost/orclpdb1.localdomain"

cp-schemas:
	docker-compose exec oracle \
		bash -c "source /home/oracle/.bashrc && \
			cd $(SCHEMA_DIR) && \
			cp -r /home/oracle/db-sample-schemas/* ."

download-schemas:
	curl -L https://github.com/oracle/db-sample-schemas/archive/refs/tags/v12.2.0.1.zip > ./v12.2.0.1.zip
	unzip ./v12.2.0.1.zip
	rm -rf ./v12.2.0.1.zip
	cd db-sample-schemas-12.2.0.1 && perl -p -i.bak -e 's#__SUB__CWD__#'$(SCHEMA_DIR)'#g' *.sql */*.sql */*.dat
