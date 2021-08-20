SCHEMA_DIR=/u01/app/oracle/product/12.2.0/dbhome_1/demo/schema

define INSTALL_SCHEMAS_SCRIPT
source /home/oracle/.bashrc; \
echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/human_resources/hr_main.sql hr users temp Oradoc_db1 $(SCHEMA_DIR)/human_resources/ localhost/orclpdb1.localdomain && \
echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/order_entry/oe_main.sql oe users temp hr Oradoc_db1 $(SCHEMA_DIR)/order_entry/ $(SCHEMA_DIR)/order_entry/ v3 localhost/orclpdb1.localdomain && \
echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/product_media/pm_main.sql hr users temp oe Oradoc_db1 $(SCHEMA_DIR)/product_media/ $(SCHEMA_DIR)/product_media/ $(SCHEMA_DIR)/product_media/ localhost/orclpdb1.localdomain && \
echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/info_exchange/ix_main.sql ix users temp Oradoc_db1 $(SCHEMA_DIR)/info_exchange/ v3 localhost/orclpdb1.localdomain && \
echo exit | sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba @?/demo/schema/sales_history/sh_main.sql sh users temp Oradoc_db1 $(SCHEMA_DIR)/sales_history/ $(SCHEMA_DIR)/sales_history/ v3 localhost/orclpdb1.localdomain
endef

define CP_SCHEMAS_SCRIPT
source /home/oracle/.bashrc && \
cd $(SCHEMA_DIR) && \
cp -r /home/oracle/db-sample-schemas/* .
endef

sys:
	docker-compose exec oracle bash -c "source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLPDB1 as sysdba"

bash:
	docker-compose exec oracle bash -c "source /home/oracle/.bashrc; bash"

setup: download-schemas cp-schemas

run-schemas:
	docker-compose exec oracle bash -c "$(INSTALL_SCHEMAS_SCRIPT)"

cp-schemas:
	docker-compose exec oracle bash -c "$(CP_SCHEMAS_SCRIPT)"

download-schemas:
	curl -L https://github.com/oracle/db-sample-schemas/archive/refs/tags/v12.2.0.1.zip > ./v12.2.0.1.zip
	unzip ./v12.2.0.1.zip
	rm -rf ./v12.2.0.1.zip
	cd db-sample-schemas-12.2.0.1 && perl -p -i.bak -e 's#__SUB__CWD__#'$(SCHEMA_DIR)'#g' *.sql */*.sql */*.dat
