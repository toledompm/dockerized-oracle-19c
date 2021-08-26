SCHEMA_DIR=/opt/oracle/product/19c/dbhome_1/demo/schema
SYS_PASSWORD=sys

define INSTALL_SCHEMAS_SCRIPT
source /home/oracle/.bashrc; \
echo exit | sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba @?/demo/schema/human_resources/hr_main.sql hr users temp $(SYS_PASSWORD) $(SCHEMA_DIR)/human_resources/ localhost/ORCLPDB1 && \
echo exit | sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba @?/demo/schema/order_entry/oe_main.sql oe users temp hr $(SYS_PASSWORD) $(SCHEMA_DIR)/order_entry/ $(SCHEMA_DIR)/order_entry/ v3 localhost/ORCLPDB1 && \
echo exit | sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba @?/demo/schema/product_media/pm_main.sql hr users temp oe $(SYS_PASSWORD) $(SCHEMA_DIR)/product_media/ $(SCHEMA_DIR)/product_media/ $(SCHEMA_DIR)/product_media/ localhost/ORCLPDB1 && \
echo exit | sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba @?/demo/schema/info_exchange/ix_main.sql ix users temp $(SYS_PASSWORD) $(SCHEMA_DIR)/info_exchange/ v3 localhost/ORCLPDB1 && \
echo exit | sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba @?/demo/schema/sales_history/sh_main.sql sh users temp $(SYS_PASSWORD) $(SCHEMA_DIR)/sales_history/ $(SCHEMA_DIR)/sales_history/ v3 localhost/ORCLPDB1
endef

define CP_SCHEMAS_SCRIPT
source /home/oracle/.bashrc && \
cd $(SCHEMA_DIR) && \
cp -r /db-sample-schemas/* .
endef

sys:
	docker-compose exec oracle bash -c "source /home/oracle/.bashrc; sqlplus sys/$(SYS_PASSWORD)@ORCLPDB1 as sysdba"

bash:
	docker-compose exec oracle bash -c "source /home/oracle/.bashrc; bash"

setup: download-schemas cp-schemas change-password

change-password:
	docker-compose exec oracle ./setPassword.sh $(SYS_PASSWORD)

run-schemas:
	docker-compose exec oracle bash -c "$(INSTALL_SCHEMAS_SCRIPT)"

cp-schemas:
	docker-compose exec oracle bash -c "$(CP_SCHEMAS_SCRIPT)"

download-schemas:
	curl -L https://github.com/oracle/db-sample-schemas/archive/refs/tags/v19.2.zip > ./samples.zip
	unzip ./samples.zip
	rm -rf ./samples.zip
	cd db-sample-schemas-19.2 && perl -p -i.bak -e 's#__SUB__CWD__#'$(SCHEMA_DIR)'#g' *.sql */*.sql */*.dat
