prompt
prompt
prompt 'Marketing Director Build Level Schema Upgrade to GA6.1.0 (build level 1436')
prompt '============================================================================'
prompt 'Current schema must be V6.0 GA'
prompt '------------------------------'
prompt
prompt
accept ts_pv_sys prompt 'Enter the name of Marketing Director system data tablespace > '
prompt
accept ts_pv_ind prompt 'Enter the name of Marketing Director index data tablespace > '
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

spool MDUpgradeGA61.log
set SERVEROUT ON SIZE 20000

DECLARE

var_count  NUMBER(10):= 0;
cid INTEGER;

err_num		NUMBER;
err_msg		VARCHAR2(100);

PROCEDURE execute_sql (sql_string IN VARCHAR2) IS
	cid INTEGER;
BEGIN
cid := DBMS_SQL.OPEN_CURSOR;
	/* Parse and immediately execute dynamic SQL statement */
	DBMS_SQL.PARSE(cid, sql_string, dbms_sql.v7);
	DBMS_SQL.CLOSE_CURSOR(cid);
EXCEPTION
	/* If an exception is raised, close cursor before exiting. */
	WHEN OTHERS THEN
		DBMS_SQL.CLOSE_CURSOR(cid);
	RAISE;
END execute_sql;


BEGIN

select 1 into var_count from pvdm_upgrade where version_id = '6.0.0.1312';

  dbms_output.put_line( 'Processing Schema Upgrade from GA6.0 to GA6.1.0');
  dbms_output.put_line( '-----------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Changes re: Components Migration Module');
  dbms_output.put_line( '     - new tables: EXPORT_HDR, IMPORT_HDR, IMPORT_OBJ_MAP, IMPORT_TYPE, REPLACE_TYPE');
  dbms_output.put_line( '     - new entry for Migrate Objects in MODULE_DEFINITION');
  dbms_output.put_line( '     - new entries for Migration Batch process in PROC_CONTROL and PROC_PARAM tables');
  dbms_output.put_line( '     - update VANTAGE_ENT list with entries for new objects');
  dbms_output.put_line( 'Extend dynamic table name length to 30 re: CQDB104003489, impacting DYN_TAB_NAME column in tables: ');
  dbms_output.put_line( '     - CAMP_DET, SEED_LIST_HDR, SCORE_SRC, DERIVED_VAL_SRC, SUBS_CAMP_CYC, DATA_CAT_HDR,');
  dbms_output.put_line( '     - TREATMENT_TEST, SEG_HDR, LOOKUP_TAB_HDR, and DATA_REP_SRC');
  dbms_output.put_line( '>');


  execute_sql ('CREATE TABLE EXPORT_HDR ( EXPORT_ID NUMBER(8) NOT NULL, FILENAME VARCHAR2(255) NOT NULL,
      EXPORT_DESC VARCHAR2(300) NULL, OBJ_TYPE_ID NUMBER(3) NOT NULL, OBJ_ID NUMBER(8) NOT NULL,
      OBJ_SUB_ID NUMBER(6) NULL, OBJ_NAME VARCHAR2(100) NOT NULL, VIEW_ID VARCHAR2(30) NOT NULL,
      CAMP_STATUS_ID NUMBER(2) NULL, INC_DYN_TAB_FLG NUMBER(1) NOT NULL, INC_CAMP_COMM_FLG NUMBER(1) NOT NULL,
      CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, RUN_DATE DATE NULL, RUN_TIME CHAR(8) NULL)
      TABLESPACE &ts_pv_sys' );

  execute_sql ('CREATE UNIQUE INDEX XPKEXPORT_HDR ON EXPORT_HDR (EXPORT_ID ASC)	TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE EXPORT_HDR ADD ( PRIMARY KEY (EXPORT_ID) USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE INDEX XIE1EXPORT_HDR ON EXPORT_HDR (OBJ_TYPE_ID ASC, OBJ_ID ASC)	TABLESPACE &ts_pv_ind');

  execute_sql ('CREATE TABLE IMPORT_HDR (IMPORT_ID NUMBER(8) NOT NULL, FILENAME VARCHAR2(255) NOT NULL,
      IMPORT_DESC VARCHAR2(300) NULL, OBJ_TYPE_ID NUMBER(3) NOT NULL, OBJ_ID NUMBER(8) NOT NULL,
      OBJ_SUB_ID NUMBER(6) NULL, OBJ_NAME VARCHAR2(100) NOT NULL, CREATED_BY VARCHAR2(30) NOT NULL,
      CREATED_DATE DATE NOT NULL, INC_DYN_TAB_FLG NUMBER(1) NOT NULL, INC_COMM_TAB_FLG NUMBER(1) NOT NULL,
      IMPORT_TYPE_ID NUMBER(2) NOT NULL, REPLACE_TYPE_ID NUMBER(2) NOT NULL, IMPORT_VIEW_ID VARCHAR2(30) NULL,
      EXPORT_BY VARCHAR2(30) NULL, EXPORT_DATE DATE NOT NULL, EXPORT_TIME CHAR(8) NULL,
      EXPORT_SERVER_NAME VARCHAR2(50) NULL, EXPORT_CONNECTION VARCHAR2(50) NULL, 
      EXPORT_VIEW_ID VARCHAR2(30) NULL, RUN_DATE DATE NULL, RUN_TIME CHAR(8) NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKIMPORT_HDR ON IMPORT_HDR (IMPORT_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE IMPORT_HDR ADD (PRIMARY KEY (IMPORT_ID) USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE INDEX XIE1IMPORT_HDR ON IMPORT_HDR (OBJ_TYPE_ID ASC, OBJ_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('CREATE TABLE IMPORT_OBJ_MAP ( IMPORT_ID NUMBER(8) NOT NULL, OBJ_TYPE_ID NUMBER(3) NOT NULL,
      OBJ_ID NUMBER(8) NOT NULL, OBJ_SUB_ID NUMBER(6) NOT NULL, ORIGIN_OBJ_ID NUMBER(8) NOT NULL, 
      ORIGIN_OBJ_SUB_ID NUMBER(6) NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKIMPORT_OBJ_MAP ON IMPORT_OBJ_MAP (IMPORT_ID ASC,	OBJ_TYPE_ID ASC,
      OBJ_ID ASC, OBJ_SUB_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE IMPORT_OBJ_MAP ADD (PRIMARY KEY (IMPORT_ID, OBJ_TYPE_ID, OBJ_ID, OBJ_SUB_ID)
      USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE INDEX XIE1IMPORT_OBJ_MAP ON IMPORT_OBJ_MAP (OBJ_TYPE_ID ASC,
      ORIGIN_OBJ_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('CREATE TABLE IMPORT_TYPE (IMPORT_TYPE_ID NUMBER(2) NOT NULL, 
      IMPORT_TYPE_DESC VARCHAR2(100) NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKIMPORT_TYPE ON IMPORT_TYPE (IMPORT_TYPE_ID ASC)
      TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE IMPORT_TYPE ADD (PRIMARY KEY (IMPORT_TYPE_ID) 
      USING INDEX TABLESPACE &ts_pv_ind)');


  execute_sql ('CREATE TABLE REPLACE_TYPE (REPLACE_TYPE_ID NUMBER(2) NOT NULL,
      REPLACE_TYPE_DESC VARCHAR2(100) NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKREPLACE_TYPE ON REPLACE_TYPE (REPLACE_TYPE_ID ASC)
      TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE REPLACE_TYPE ADD (PRIMARY KEY (REPLACE_TYPE_ID) USING INDEX
      TABLESPACE &ts_pv_ind )');

  execute_sql ('ALTER TABLE CAMP_DET MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE SEED_LIST_HDR MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE SCORE_SRC MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE DERIVED_VAL_SRC MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE SUBS_CAMP_CYC MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE DATA_CAT_HDR MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE TREATMENT_TEST MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE SEG_HDR MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE LOOKUP_TAB_HDR MODIFY DYN_TAB_NAME VARCHAR2(30)');
  execute_sql ('ALTER TABLE DATA_REP_SRC MODIFY DYN_TAB_NAME VARCHAR2(30)');

  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('EXPORT_HDR', 1, 0);
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_HDR', 1, 0);
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_OBJ_MAP', 1, 0);
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_TYPE', 1, 1);
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('REPLACE_TYPE', 1, 1);
  COMMIT;

  insert into MODULE_DEFINITION values (92, 'Migrate Objects', 'Migrate Objects', 1,4,4,4);
  COMMIT;

  insert into proc_control select 'Migration Batch', 'Migration Batch Processing', 1, 
    'RunMigration.cmd', location, 8 from proc_control where proc_name = 'Segment Processor';

  insert into proc_param values ('Migration Batch',0,'Server Script', 'RunMigration.cmd');
  insert into proc_param values ('Migration Batch',1,'User Id', null);
  insert into proc_param values ('Migration Batch',2,'Connection', null);
  insert into proc_param values ('Migration Batch',3,'Database Vendor', null);
  insert into proc_param values ('Migration Batch',4,'Process audit ID', null);
  insert into proc_param values ('Migration Batch',5,'Command Name', null);
  insert into proc_param values ('Migration Batch',6,'Import or Export ID', null);
  insert into proc_param values ('Migration Batch',7,'Debug', 'd');
  COMMIT;

  update pvdm_upgrade set version_id = '6.1.0.1436.GA-';
  COMMIT;

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('Upgrade to V6.1.0 GA cannot proceed - your CMD schema is not a correct version.');
                dbms_output.put_line('Please ensure your CMD schema is V6.0 GA before proceeding with this upgrade');
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure 1 error occurred.' );
		err_num := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 100);
		dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/


DECLARE

var_count  NUMBER(10):= 0;
cid INTEGER;

err_num		NUMBER;
err_msg		VARCHAR2(100);

PROCEDURE execute_sql (sql_string IN VARCHAR2) IS
	cid INTEGER;
BEGIN
cid := DBMS_SQL.OPEN_CURSOR;
	/* Parse and immediately execute dynamic SQL statement */
	DBMS_SQL.PARSE(cid, sql_string, dbms_sql.v7);
	DBMS_SQL.CLOSE_CURSOR(cid);
EXCEPTION
	/* If an exception is raised, close cursor before exiting. */
	WHEN OTHERS THEN
		DBMS_SQL.CLOSE_CURSOR(cid);
	RAISE;
END execute_sql;


BEGIN

select 1 into var_count from pvdm_upgrade where version_id = '6.1.0.1436.GA-';

  insert into import_type (import_type_id, import_type_desc) values (1, 'Exported ID');
  insert into import_type (import_type_id, import_type_desc) values (2, 'Next Available ID');
  insert into import_type (import_type_id, import_type_desc) values (3, 'Specific ID');
  COMMIT;

  insert into replace_type (replace_type_id, replace_type_desc) values (1, 'Create new version');
  insert into replace_type (replace_type_id, replace_type_desc) values (2, 'Overwrite existing component');
  insert into replace_type (replace_type_id, replace_type_desc) values (3, 'Exactly replicate');
  COMMIT;

  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON EXPORT_HDR TO &md_role'); 
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_HDR TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_OBJ_MAP TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_TYPE TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON REPLACE_TYPE TO &md_role');

  update pvdm_upgrade set version_id = '6.1.0.1436.GA';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The V6.0 Marketing Director schema has been upgraded to V6.1.0 GA');
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure 2 error occurred.' );
		err_num := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 100);
		dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/
spool off;
exit;