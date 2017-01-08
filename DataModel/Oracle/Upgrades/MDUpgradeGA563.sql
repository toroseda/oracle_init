prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
accept ts_pv_sys prompt 'Enter the name of Marketing Director system tables tablespace > '
prompt
accept ts_pv_ind prompt 'Enter the name of Marketing Director system indexes tablespace > '
prompt
accept type1_flag prompt 'Is your Type 1 substitution variable set to True? Enter Y or N > '
prompt
prompt

spool MDUpgradeGA563.log
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

select 1 into var_count from pvdm_upgrade where version_id = '5.6.2.1133.12';

  dbms_output.put_line( 'Processing Schema Upgrade from V5.6.2 to V5.6.3');
  dbms_output.put_line( '-------------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Change to Query Designer:');
  dbms_output.put_line( '     - Addition of SUBSTITUTION_FLG to STORED_FLD_TEMPL table');
  dbms_output.put_line( 'Change to Segmentation Manager:');
  dbms_output.put_line( '     - Add new columns BASE_NO_COUNTS_FLG, BASE_OPTIMISE_FLG and BASE_OPTIMISE_CL');
  dbms_output.put_line( '       to TREE_HDR table for fast execution and optimisation of Tree Base processing' );
  dbms_output.put_line( '     - Add new columns SUBSTITUTION_FLG, TREE_OPTIMISE_FLG and TREE_OPTIMISE_CL');
  dbms_output.put_line( '       to TREE_HDR for stored field substitution and optimisation at Tree level');
  dbms_output.put_line( '     - Add new columns SUBSTITUTION_FLG, OPTIMISE_FLG and OPTIMISE_CLAUSE');
  dbms_output.put_line( '       for stored field substitution and optimisation at Tree Node level'); 
  dbms_output.put_line( 'Change to PV_COLS view: ');
  dbms_output.put_line( '     - Add NULLABLE column to allow NULL | NOT NULL clause to be added to');
  dbms_output.put_line( '       column definitions of dynamic tables');
  dbms_output.put_line( 'Changes re: MM7 Enhancements:');
  dbms_output.put_line( '     - add system lookup tables WIRELESS_VENDOR and PROTOCOL_VERSION');
  dbms_output.put_line( '     - add columns VENDOR_ID, PROTOCOL_VER_ID, VASPID, VASID to WIRELESS_SERVER');
  dbms_output.put_line( '     - add new entry for MM7 to WIRELESS_PROTOCOL lookup');
  dbms_output.put_line( '     - add 2 new lookup table names to VANTAGE_ENT list');
  dbms_output.put_line( 'Changes re: CQDB104000746:');
  dbms_output.put_line( '     - extend the length of STRING_<n> columns from 40 to 160');
  dbms_output.put_line( 'Modification re: performance - added index on SPI_ID, DET_ID to SPI_CAMP_PROC table');
  dbms_output.put_line( 'Changes re: CQDB104001402:');
  dbms_output.put_line( '     - extend the length of INSERT_VAL column in ACTION_STORE_VAL and MAILBOX_RES_RULE from 40 to 160');
  dbms_output.put_line( '>');

  execute_sql( 'ALTER TABLE STORED_FLD_TEMPL ADD (SUBSTITUTION_FLG NUMBER(1) DEFAULT 0 NOT NULL)');

  execute_sql( 'ALTER TABLE STORED_FLD_TEMPL MODIFY SUBSTITUTION_FLG DEFAULT NULL' );  

  execute_sql( 'ALTER TABLE TREE_HDR ADD (BASE_NO_COUNTS_FLG NUMBER(1) DEFAULT 0 NOT NULL, 
                BASE_OPTIMISE_FLG NUMBER(1) DEFAULT 0 NOT NULL, BASE_OPTIMISE_CL VARCHAR2(300),
                SUBSTITUTION_FLG NUMBER(1) DEFAULT 0 NOT NULL, TREE_OPTIMISE_FLG NUMBER(1) DEFAULT 0 NOT NULL,
                TREE_OPTIMISE_CL VARCHAR2(300))');

  execute_sql( 'ALTER TABLE TREE_DET ADD (SUBSTITUTION_FLG NUMBER(1) DEFAULT 0 NOT NULL,
                OPTIMISE_FLG NUMBER(1) DEFAULT 0 NOT NULL, OPTIMISE_CLAUSE VARCHAR2(300))');

  execute_sql( 'CREATE OR REPLACE VIEW PV_COLS ( TABLE_OWNER, COLUMN_NAME,TABLE_NAME, DATA_TYPE, DATA_SCALE, 
                DATA_PRECISION, DATA_LENGTH, COLUMN_ID, EQUIV_TYPE, DEFINED_PRECISION, NULLABLE) AS
	        SELECT OWNER, COLUMN_NAME, TABLE_NAME, DATA_TYPE, NVL( DATA_SCALE,0 ), 
                NVL( DATA_PRECISION,0 ), DATA_LENGTH, COLUMN_ID, 
                DECODE( DATA_TYPE,' || '''VARCHAR2'''||','||'''CHAR'''||', DATA_TYPE), 
                DECODE( DATA_SCALE, NULL,'||'''N'''||','||'''Y'''||' ), NULLABLE FROM ALL_TAB_COLUMNS' );	

  execute_sql( 'CREATE TABLE WIRELESS_VENDOR (VENDOR_ID NUMBER(3) NOT NULL,
       VENDOR_NAME VARCHAR2(50) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql( 'CREATE UNIQUE INDEX XPKWIRELESS_VENDOR ON WIRELESS_VENDOR (VENDOR_ID ASC)
       TABLESPACE &ts_pv_ind');

  execute_sql( 'ALTER TABLE WIRELESS_VENDOR ADD (PRIMARY KEY (VENDOR_ID)
       USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql( 'CREATE TABLE PROTOCOL_VERSION (PROTOCOL_VER_ID NUMBER(3) NOT NULL,
       PROTOCOL_VER_NAME VARCHAR2(50) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql( 'CREATE UNIQUE INDEX XPKPROTOCOL_VERSION ON PROTOCOL_VERSION 
       (PROTOCOL_VER_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql( 'ALTER TABLE PROTOCOL_VERSION ADD (PRIMARY KEY (PROTOCOL_VER_ID)
       USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql( 'ALTER TABLE WIRELESS_SERVER ADD (VENDOR_ID NUMBER(3), PROTOCOL_VER_ID NUMBER(3),
       VASPID VARCHAR2(50), VASID VARCHAR2(50))');

  execute_sql( 'ALTER TABLE WIRELESS_RES MODIFY (STRING_1 VARCHAR2(160), STRING_2 VARCHAR2(160), 
       STRING_3 VARCHAR2(160), STRING_4 VARCHAR2(160), STRING_5 VARCHAR2(160), STRING_6 VARCHAR2(160),
       STRING_7 VARCHAR2(160), STRING_8 VARCHAR2(160), STRING_9 VARCHAR2(160), STRING_10 VARCHAR2(160))');

  execute_sql( 'ALTER TABLE EMAIL_RES MODIFY (STRING_1 VARCHAR2(160), STRING_2 VARCHAR2(160), 
       STRING_3 VARCHAR2(160), STRING_4 VARCHAR2(160), STRING_5 VARCHAR2(160), STRING_6 VARCHAR2(160),
       STRING_7 VARCHAR2(160), STRING_8 VARCHAR2(160), STRING_9 VARCHAR2(160), STRING_10 VARCHAR2(160))');

  execute_sql( 'CREATE INDEX XIE6SPI_CAMP_PROC ON SPI_CAMP_PROC (SPI_ID ASC, DET_ID ASC)
       TABLESPACE &ts_pv_ind');

  execute_sql( 'ALTER TABLE ACTION_STORE_VAL MODIFY (INSERT_VAL VARCHAR2(160))');

  execute_sql( 'ALTER TABLE MAILBOX_RES_RULE MODIFY (INSERT_VAL VARCHAR2(160))');

  update pvdm_upgrade set version_id = '5.6.3.-1';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> Upgrade step 1 - Procedure 1 successfully completed' );
  dbms_output.put_line( '>' );
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (1) error occurred.' );
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

type1_flag      CHAR;

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

  type1_flag:= '&type1_flag';

  select 1 into var_count from pvdm_upgrade where version_id = '5.6.3.-1';

  select count(SEG_ID) into var_count from stored_fld_templ where dyn_col_name = 'A1';

  IF ( type1_flag = 'Y' AND var_count > 0 ) THEN
     
     update STORED_FLD_TEMPL set SUBSTITUTION_FLG = 1 where DYN_COL_NAME = 'A1';	
     COMMIT;

  END IF;

  insert into wireless_vendor values (1, 'Nokia');
  insert into wireless_vendor values (2, 'Ericsson');
  COMMIT;

  insert into protocol_version values (1, 'V530');
  insert into protocol_version values (2, 'V630');
  COMMIT; 

  insert into wireless_protocol values (5, 'MM7', 50);
  COMMIT;

  insert into vantage_ent values ('PROTOCOL_VERSION',1,1);
  insert into vantage_ent values ('WIRELESS_VENDOR',1,1);
  COMMIT;

  execute_sql( 'GRANT SELECT ON PV_COLS TO &md_role');
  execute_sql( 'GRANT SELECT, INSERT, UPDATE, DELETE ON WIRELESS_VENDOR TO &md_role');  
  execute_sql( 'GRANT SELECT, INSERT, UPDATE, DELETE ON PROTOCOL_VERSION TO &md_role');

  update pvdm_upgrade set version_id = '5.6.3.1206';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> V5.6.2 Marketing Director Schema has been upgraded to V5.6.3');
  dbms_output.put_line( '>' );
  dbms_output.put_line( '>' );
 

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (2) error occurred.' );
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
