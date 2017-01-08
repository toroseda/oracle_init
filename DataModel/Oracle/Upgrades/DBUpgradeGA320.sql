prompt
prompt
prompt 'V3.2 Prime@Vantage Schema Upgrade'
prompt '================================='
prompt
prompt
accept pv_app_role prompt 'Enter name of Prime@Vantage Application Role > '
prompt
prompt
accept sms_alias prompt 'Enter Vantage Alias of the entity containing SMS Telephone Number [Press <ENTER> if not used] > '
prompt
accept sms_col prompt 'Enter Column Name containing SMS Telephone Number [Press <ENTER> if not used ] > '
prompt
prompt

spool DBUpgradeGA320.log
set SERVEROUT ON SIZE 20000

DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;
web_count  NUMBER(4):= 0;
var_dtype varchar2(30);
var_dlen number;
var_dprec number;
var_dscale number;
var_coltype varchar2(40);
var_coltype2 varchar2(40);
var_main_view varchar2(30); 
var_sms_col varchar2(128) := '&sms_col';
var_sms_alias varchar2(128) := '&sms_alias';

var_ts_pv_sys varchar2(30);
var_ts_pv_ind varchar2(30);
var_ts_pv_comm varchar2(30);
var_ts_pv_cind varchar2(30);


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

select 1 into var_count from pvdm_upgrade where version_id = '3.1.1.296';

	dbms_output.put_line( 'Processing Schema Upgrade from V3.1.1 to V3.2.0');
	dbms_output.put_line( '--------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '      - corrections of field sizes resulting from general standards overview');
	dbms_output.put_line( '      - add entry for SMS channel type into CHAN_TYPE table');
	dbms_output.put_line( '      - add new entries to OBJ_TYPE, CHAN_TYPE and MODULE_DEFINITION');
	dbms_output.put_line( '      - modifications re addition of SMS:'); 
	dbms_output.put_line( '      - rename and modify EMAIL_RES_RULE_HDR, EMAIL_RES_RULE_DET to ERES_RULE_HDR, ERES_RULE_DET');
	dbms_output.put_line( '        add ERES_RULE_GRP, ERES_RULE_TYPE and pre-populate, SMSC and SMSC_RES_RULE');
	dbms_output.put_line( '	     - modify: add columns for additional Email Mailbox details in EMAIL_SERVER, EMAIL_MAILBOX');
	dbms_output.put_line( '	     - In Treatments modify: add columns for additional details in ELEM, TREATMENT, CHARAC');
	dbms_output.put_line( '        add new tables CHARAC_GRP, TREATMENT_TEST, TEST_TEMPL_MAP, and add and pre-populate ');
	dbms_output.put_line( '	       tables ATTACHMENT, TEST_TYPE, EMAIL_TYPE, MESSAGE_TYPE'); 
	dbms_output.put_line( '      - In Campaign Builder modify: CAMP_OUT_DET, DELIVERY_CHAN, OUT_SEED_MAPPING, CAMP_OUT_RESULT');
	dbms_output.put_line( '        add new tables DELIVERY_SERVER and CAMP_RESULT_PROC');
	dbms_output.put_line( '	     - add entries to PROC_CONTROL and PROC_PARAM');
	dbms_output.put_line( '	     - update VANTAGE_ENT table with new entity details');
	dbms_output.put_line( '	     - add entries for additions to referential integrity to REF_INDICATOR');
	dbms_output.put_line( '        and CONSTRAINT_SETTING');
	dbms_output.put_line( '	     - populate new and modified tables mapping re-structured information to new data fields');
	dbms_output.put_line( '      - update Application Role access to new entities');
	dbms_output.put_line( '      - update object type 64 - name to Email Delivery Engine');
	dbms_output.put_line( '      - add new object type entry for SMS Delivery Engine');
	dbms_output.put_line( '	     - add entries into PROC_CONTROL and PROC_PARAM for SMS Delivery Process');
	dbms_output.put_line( '	     - modify EMAIL_RES table with KEYCODE size changed to 30, and additional columns');
	dbms_output.put_line( '	     - add table SMS_RES to store SMS responses');
	dbms_output.put_line( '>');

	/* get names of tablespaces for system and communication tables and indexes */

	select tablespace_name into var_ts_pv_sys from user_tables where table_name = 'CUST_TAB' and rownum = 1;
	select tablespace_name into var_ts_pv_ind from user_indexes where table_name = 'CUST_TAB' and rownum = 1;
	select tablespace_name into var_ts_pv_comm from user_tables where table_name = 'CAMP_COMM_OUT_DET' and rownum = 1;
	select tablespace_name into var_ts_pv_cind from user_indexes where table_name = 'CAMP_COMM_OUT_DET' and rownum = 1;

	/* drop triggers to be re-defined due to change in the referenced entity name (EMAIL_RES... to ERES...) */

	execute_sql ('DROP TRIGGER TD_MAILBOX_RES_RUL');
	execute_sql ('DROP TRIGGER TI_MAILBOX_RES_RUL');
	execute_sql ('DROP TRIGGER TU_MAILBOX_RES_RUL');

	/* minor modifications re: corrections resulting from general standards overview */

	execute_sql ('ALTER TABLE CAMP_REP_COL MODIFY (COL_NAME VARCHAR2(128), DFT_FUNCTION_ID NUMBER(2))');
	execute_sql ('ALTER TABLE DATAVIEW_TEMPL_DET MODIFY (SEQ_NUMBER NUMBER(4), DISPLAY_NAME VARCHAR2(50))');
	execute_sql ('ALTER TABLE STORED_FLD_TEMPL MODIFY (DYN_COL_NAME VARCHAR2(18))');
	execute_sql ('ALTER TABLE CAMP_MAP_SFDYN MODIFY (DYN_COL_NAME VARCHAR2(18))');
	execute_sql ('ALTER TABLE CAMP_OUT_GRP_SPLIT MODIFY (SPLIT_FLD_VAL VARCHAR2(255))');
	execute_sql ('ALTER TABLE GRP_FUNCTION MODIFY (GRP_FUNCTION_ID NUMBER(2))');

	execute_sql ('create table temp_tree_det as select * from tree_det');
	delete from tree_det;
	commit;
	execute_sql ('ALTER TABLE TREE_DET MODIFY (ORIGIN_SUB_ID NUMBER(6))');
 
	execute_sql ('ALTER TABLE INTERVAL_CYC_DET MODIFY (NUMBER_OF_RUNS NUMBER(9))');

	execute_sql ('create table temp_search_area as select * from search_area');
	delete from search_area;
	commit;
	execute_sql ('ALTER TABLE SEARCH_AREA MODIFY (SEARCH_AREA_ID NUMBER(2))');
	
	execute_sql ('create table temp_grp_ftr_type as select * from grp_ftr_type');
	delete from grp_ftr_type;
	commit;
	execute_sql ('ALTER TABLE GRP_FTR_TYPE MODIFY (GRP_FTR_TYPE_ID NUMBER(1))');

	/* adding pre-populated values */
	
	delete from MODULE_DEFINITION X where exists 
		(select * from MODULE_DEFINITION where module_id = 95 
		and module_name = 'Seed Lists' and module_id = x.module_id);

	insert into MODULE_DEFINITION values (77, 'Seed Lists','Seed Lists',1,4,4,4);
	COMMIT;

	insert into chan_type values (40, 'SMS', 1,1);
	COMMIT;

	delete from obj_type where obj_type_id > 75;
	insert into obj_type values (76, 'Seed List Group', null);
	insert into obj_type values (77, 'Undelivered Email Rule', NULL);
	insert into obj_type values (78, 'SMS Response Rule', NULL);
	insert into obj_type values (79, 'SMSC', NULL);
	insert into obj_type values (80, 'Characteristic Group', NULL);
	insert into obj_type values (81, 'Response Rule Group', NULL);
	insert into obj_type values (82, 'Optimised Segment', NULL);
	insert into obj_type values (83, 'Optimised Treatment Result','TO');
	update obj_type set obj_name = 'Resolution Rule' where obj_type_id = 69;
	COMMIT;
	
	/* renaming EMAIL_RES_RULE_HDR and EMAIL_RES_RULE_DET to ERES_RULE_HDR and ERES_RULE_DET respectively */
	/* and adding ERES_RULE_TYPE and ERES_RULE_GRP tables */

	execute_sql ('CREATE TABLE ERES_RULE_TYPE (RULE_TYPE_ID NUMBER(1) NOT NULL, RULE_TYPE_NAME VARCHAR2(100) NOT NULL) TABLESPACE ' || var_ts_pv_sys );

	execute_sql ('CREATE UNIQUE INDEX XPKERES_RULE_TYPE ON ERES_RULE_TYPE (RULE_TYPE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ERES_RULE_TYPE ADD (PRIMARY KEY (RULE_TYPE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE ERES_RULE_GRP (RES_RULE_GRP_ID NUMBER(4) NOT NULL, RULE_TYPE_ID NUMBER(1) NOT NULL, RES_RULE_GRP_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKERES_RULE_GRP ON ERES_RULE_GRP( RES_RULE_GRP_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ERES_RULE_GRP ADD (PRIMARY KEY (RES_RULE_GRP_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE TEMP_ERES_RULE_HDR AS SELECT * FROM EMAIL_RES_RULE_HDR');
	execute_sql ('CREATE TABLE TEMP_ERES_RULE_DET AS SELECT * FROM EMAIL_RES_RULE_DET');

	delete from email_res_rule_hdr;
	delete from email_res_rule_det;
	commit;

	execute_sql ('RENAME EMAIL_RES_RULE_HDR TO ERES_RULE_HDR');
	execute_sql ('RENAME EMAIL_RES_RULE_DET TO ERES_RULE_DET');

	execute_sql ('ALTER TABLE ERES_RULE_HDR DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE ERES_RULE_DET DROP PRIMARY KEY');

	execute_sql ('CREATE UNIQUE INDEX XPKERES_RULE_HDR ON ERES_RULE_HDR (RULE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ERES_RULE_HDR ADD ( PRIMARY KEY (RULE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('ALTER TABLE ERES_RULE_HDR ADD (RULE_TYPE_ID NUMBER(1) NOT NULL, RES_RULE_GRP_ID NUMBER(4) NOT NULL)');

	execute_sql ('ALTER TABLE ERES_RULE_DET MODIFY (STRING_VAL VARCHAR2(200))');

	execute_sql ('CREATE UNIQUE INDEX XPKERES_RULE_DET ON ERES_RULE_DET( RULE_ID ASC, RULE_DET_SEQ ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ERES_RULE_DET ADD ( PRIMARY KEY (RULE_ID, RULE_DET_SEQ) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* modifying (adding new columns to) existing tables EMAIL_SERVER, EMAIL_MAILBOX, ERES_RULE_HDR */

	execute_sql ('ALTER TABLE EMAIL_SERVER ADD (DOMAIN_NAME VARCHAR2(255), OUTB_CONNECT_RETRY NUMBER(2) DEFAULT 3 NOT NULL, OUTB_CONNECT_WAIT NUMBER(4) DEFAULT 300 NOT NULL, TEST_SEND_FLG NUMBER(1) DEFAULT 0 NOT NULL, TEST_SEND_TO VARCHAR2(100), MAX_CONNECTIONS NUMBER(2) DEFAULT 1 NOT NULL )');
	commit;
	execute_sql ('ALTER TABLE EMAIL_SERVER MODIFY (DOMAIN_NAME DEFAULT NULL, OUTB_CONNECT_RETRY DEFAULT NULL, OUTB_CONNECT_WAIT DEFAULT NULL, TEST_SEND_FLG DEFAULT NULL, MAX_CONNECTIONS DEFAULT NULL )');

	execute_sql ('ALTER TABLE EMAIL_MAILBOX ADD (PASSWORD_FLG NUMBER(1) DEFAULT 1 NOT NULL, TEST_SEND_FLG NUMBER(1) DEFAULT 0 NOT NULL, FORWARD_BOUNCE_FLG NUMBER(1) DEFAULT 0 NOT NULL, FORWARD_BOUNCE_TO VARCHAR2(100))');

	COMMIT;

	execute_sql ('ALTER TABLE EMAIL_MAILBOX MODIFY (PASSWORD_FLG DEFAULT NULL, TEST_SEND_FLG DEFAULT NULL, FORWARD_BOUNCE_FLG DEFAULT NULL)');


	/* adding new entities for SMCS: SMCS, SMCS_RES_RULE */

	execute_sql ('CREATE TABLE SMSC (SMSC_ID NUMBER(4) NOT NULL, SMSC_NAME VARCHAR2(50) NOT NULL, SMSC_DESC VARCHAR2(300) NULL, IP_ADDRESS VARCHAR2(15) NULL, 
DEFAULT_SMSC_FLG NUMBER(1) NOT NULL, OUTB_SMSC_FLG NUMBER(1) NOT NULL, INB_SMSC_FLG NUMBER(1) NOT NULL, PORT NUMBER(8)NULL, TIMEOUT NUMBER(8) NULL, CONNECT_RETRY NUMBER(2) NULL, 
CONNECT_WAIT NUMBER(4) NULL, MAX_MESSAGE_LENGTH NUMBER(3) NULL, CONCATENATED_FLG NUMBER(1) NOT NULL, UNDELIVERED_FLG NUMBER(1) NOT NULL, READ_FLG NUMBER(1) NOT NULL, 
REPLY_FLG NUMBER(1) NOT NULL, TEST_SEND_FLG NUMBER(1) NOT NULL, TEST_SEND_TO VARCHAR2(50) NULL, CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, UPDATED_BY VARCHAR2(30) NULL, 
UPDATED_DATE DATE NULL, TON NUMBER(1) NOT NULL, NPI NUMBER(1) NOT NULL, SYSTEM_ID VARCHAR2(15) NULL, SYSTEM_TYPE VARCHAR2(12) NULL, PASSWORD VARCHAR2(8) NULL, MAX_CONNECTIONS NUMBER(2) NOT NULL, 
TEST_SEND_FROM VARCHAR2(50) NULL) TABLESPACE '|| var_ts_pv_sys );

	execute_sql ('CREATE UNIQUE INDEX XPKSMSC ON SMSC (SMSC_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE SMSC ADD (PRIMARY KEY (SMSC_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE SMSC_RES_RULE (SMSC_ID NUMBER(4) NOT NULL, RULE_ID NUMBER(4) NOT NULL, RULE_SEQ NUMBER(2) NULL, INSERT_VAL VARCHAR2(40) NULL, VANTAGE_ALIAS VARCHAR2(128) NULL, COL_NAME VARCHAR2(128) NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKSMSC_RES_RULE ON SMSC_RES_RULE (SMSC_ID ASC, RULE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE SMSC_RES_RULE ADD (PRIMARY KEY (SMSC_ID, RULE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE TON_TYPE (TON NUMBER(1) NOT NULL, TON_NAME VARCHAR2(20) NOT NULL) TABLESPACE '|| var_ts_pv_sys );

	execute_sql ('CREATE UNIQUE INDEX XPKTON_TYPE ON TON_TYPE (TON ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE TON_TYPE ADD (PRIMARY KEY (TON) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE NPI_TYPE (NPI NUMBER(1) NOT NULL, NPI_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys );

	execute_sql ('CREATE UNIQUE INDEX XPKNPI_TYPE ON NPI_TYPE (NPI ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE NPI_TYPE ADD (PRIMARY KEY (NPI) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');


	/* altering TREATMENT, CHARAC and ELEM entities */

	execute_sql ('create table temp_elem as select * from elem');
	delete from elem;
	commit;
	execute_sql ('drop table elem');

	execute_sql ('CREATE TABLE ELEM (ELEM_ID NUMBER(8) NOT NULL, ELEM_GRP_ID NUMBER(4) NOT NULL, ELEM_NAME VARCHAR2(50) NOT NULL, ELEM_DESC VARCHAR2(300) NULL, VAR_COST NUMBER(12,3) NOT NULL, VAR_COST_QTY NUMBER(8) NOT NULL, CONTENT_FILENAME VARCHAR2(255) NULL, CONTENT_FORMT_ID NUMBER(2) NULL, DYN_CONTENT_FLG NUMBER(1) NOT NULL, CONTENT_LENGTH NUMBER(4) NULL, CONTENT VARCHAR2(2000) NULL, DYN_PLACEHOLDERS NUMBER(2) NULL, WEB_METHOD_ID NUMBER(1) NULL, MESSAGE_TYPE_ID NUMBER(1) NULL, CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, UPDATED_BY VARCHAR2(30) NULL, UPDATED_DATE DATE NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKELEM ON ELEM (ELEM_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ELEM ADD (PRIMARY KEY (ELEM_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('ALTER TABLE TREATMENT ADD (EMAIL_TYPE_ID NUMBER(1) NULL, EMAIL_SUBJECT VARCHAR2(100) NULL, TOTAL_PLACEHOLDERS NUMBER(3) NULL)');

	execute_sql ('CREATE TABLE ATTACHMENT (TREATMENT_ID NUMBER(8) NOT NULL, ATTACHMENT_ID NUMBER(2) NOT NULL, PATH_FILENAME VARCHAR2(255) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKATTACHMENT ON ATTACHMENT (TREATMENT_ID ASC, ATTACHMENT_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE ATTACHMENT ADD (PRIMARY KEY (TREATMENT_ID, ATTACHMENT_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE TREATMENT_TEST (TREATMENT_ID NUMBER(8) NOT NULL, TEST_TYPE_ID NUMBER(1) NOT NULL, FROM_SERVER_ID NUMBER(4) NULL, FROM_MAILBOX_ID NUMBER(4) NULL, REPLY_SERVER_ID NUMBER(4) NULL, REPLY_MAILBOX_ID NUMBER(4) NULL, FROM_ALIAS VARCHAR2(100) NULL, REPLY_ALIAS VARCHAR2(100) NULL, CHAN_ID NUMBER(8) NULL, SEG_TYPE_ID NUMBER(2) NULL, SEG_ID NUMBER(8) NULL, SEG_SUB_ID NUMBER(6) NULL, SEED_LIST_ID NUMBER(4) NULL, SEG_COUNT_FLG NUMBER(1) NOT NULL, SEG_COUNT NUMBER(4) NULL, SAMPLE_COUNT NUMBER(4) NULL, SEND_TO VARCHAR2(200) NULL, DYN_TAB_NAME VARCHAR2(18) NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKTREATMENT_TEST ON TREATMENT_TEST (TREATMENT_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE TREATMENT_TEST ADD (PRIMARY KEY (TREATMENT_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE TEST_TEMPL_MAP (TREATMENT_ID NUMBER(8) NOT NULL, PLACEHOLDER VARCHAR2(50) NOT NULL, TEMPL_LINE_SEQ NUMBER(4) NOT NULL, OUT_LINE_SEQ NUMBER(4) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKTEST_TEMPL_MAP ON TEST_TEMPL_MAP (TREATMENT_ID ASC, PLACEHOLDER ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE TEST_TEMPL_MAP ADD (PRIMARY KEY (TREATMENT_ID, PLACEHOLDER) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE CHARAC_GRP (CHARAC_GRP_ID NUMBER(4) NOT NULL, CHARAC_GRP_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKCHARAC_GRP ON CHARAC_GRP (CHARAC_GRP_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE CHARAC_GRP ADD (PRIMARY KEY (CHARAC_GRP_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('create table temp_charac as select * from charac');
	delete from charac;
	commit;

	execute_sql ('ALTER TABLE CHARAC ADD (CHARAC_GRP_ID NUMBER(4) NOT NULL)');

	execute_sql ('ALTER TABLE CHARAC MODIFY (CHARAC_GRP_ID DEFAULT NULL)');

	execute_sql ('CREATE TABLE TEST_TYPE (TEST_TYPE_ID NUMBER(1) NOT NULL, TEST_TYPE_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKTEST_TYPE ON TEST_TYPE (TEST_TYPE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE TEST_TYPE ADD (PRIMARY KEY (TEST_TYPE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');
	
	execute_sql ('CREATE TABLE EMAIL_TYPE (EMAIL_TYPE_ID NUMBER(1) NOT NULL, EMAIL_TYPE_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKEMAIL_TYPE ON EMAIL_TYPE (EMAIL_TYPE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE EMAIL_TYPE ADD (PRIMARY KEY (EMAIL_TYPE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE MESSAGE_TYPE ( MESSAGE_TYPE_ID NUMBER(1) NOT NULL, MESSAGE_TYPE_NAME VARCHAR2(100) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKMESSAGE_TYPE ON MESSAGE_TYPE ( MESSAGE_TYPE_ID ASC ) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE MESSAGE_TYPE ADD ( PRIMARY KEY (MESSAGE_TYPE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* modifying CAMP_OUT_DET table: renaming columns EMAIL_FROM and EMAIL_REPLY to FROM_ALIAS and */
	/* REPLY_ALIAS adding columns FROM_SERVER_ID, FROM_MAILBOX_ID, REPLY_SERVER_ID, REPLY_MAILBOX_ID */

	execute_sql ('create table temp_camp_out_det as select * from camp_out_det');
	delete from camp_out_det;
	commit;
	execute_sql ('drop table camp_out_det');

	execute_sql ('CREATE TABLE CAMP_OUT_DET (CAMP_ID NUMBER(8) NOT NULL, CAMP_OUT_GRP_ID NUMBER(4) NOT NULL, CAMP_OUT_DET_ID NUMBER(8) NOT NULL, 
SPLIT_SEQ NUMBER(3) NOT NULL, CHAN_ID NUMBER(8) NOT NULL, ALT_EXT_TEMPL_FLG NUMBER(1) NOT NULL, EXT_TEMPL_ID NUMBER(8) NULL, USE_TEMPL_SEQ_FLG NUMBER(1) NOT NULL, 
NUMBER_OF_SAMPLES NUMBER(4) NOT NULL, FROM_ALIAS VARCHAR2(100) NULL, REPLY_ALIAS VARCHAR2(100) NULL, OUT_NAME_SUFFIX CHAR(3) NULL, FROM_SERVER_ID NUMBER(4) NULL, 
FROM_MAILBOX_ID NUMBER(4) NULL, REPLY_SERVER_ID NUMBER(4) NULL, REPLY_MAILBOX_ID NUMBER(4) NULL, SEED_LIST_ID NUMBER(4) NULL) 
TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_OUT_DET ON CAMP_OUT_DET (CAMP_ID ASC, CAMP_OUT_GRP_ID ASC, CAMP_OUT_DET_ID ASC, SPLIT_SEQ ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE CAMP_OUT_DET ADD (PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* modify seed list details */

	execute_sql ('create table temp_out_seed_mapping as select * from out_seed_mapping');
	delete from out_seed_mapping;
	commit;
	execute_sql ('drop table out_seed_mapping');

	execute_sql ('CREATE TABLE OUT_SEED_MAPPING (CAMP_ID NUMBER(8) NOT NULL, CAMP_OUT_GRP_ID NUMBER(4) NOT NULL, CAMP_OUT_DET_ID NUMBER(8) NOT NULL, SPLIT_SEQ NUMBER(3) NOT NULL, 
TEMPL_LINE_SEQ NUMBER(4) NOT NULL, SEED_LIST_ID NUMBER(4) NULL, SEED_COL_SEQ NUMBER(4) NULL, DEFAULT_VAL VARCHAR2(100) NULL) 
TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKOUT_SEED_MAPPING ON OUT_SEED_MAPPING (CAMP_ID ASC, CAMP_OUT_GRP_ID ASC, CAMP_OUT_DET_ID ASC, SPLIT_SEQ ASC, TEMPL_LINE_SEQ ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE OUT_SEED_MAPPING ADD (PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ, TEMPL_LINE_SEQ) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* amending DELIVERY_CHAN table removing columns LABEL_ID, INC_KEYCODE_FLG, VANTAGE_ALIAS, COLUMN_NAME, */
	/* BOUNCE_MAILBOX_ID, BOUNCE_SERVER_ID, SEND_EMAIL_FLG, SERVER_ID */
	/* and adding columns FORWARD_SERVER_ID, ENC_KEYCODE_FLG */

	execute_sql ('create table temp_delivery_chan as select * from delivery_chan');
	delete from delivery_chan;
	commit;
	execute_sql ('drop table delivery_chan');

	execute_sql ('CREATE TABLE DELIVERY_CHAN (CHAN_ID NUMBER(8) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, DELIVERY_METHOD_ID NUMBER(1) NOT NULL, CHAN_OUT_TYPE_ID NUMBER(2) NOT NULL, 
DFT_EXT_TEMPL_ID NUMBER(8) NOT NULL, CHAN_NAME VARCHAR2(50) NOT NULL, CHAN_DESC VARCHAR2(300) NULL, RECORD_DELIMITER CHAR(5) NULL, FLD_DELIMITER CHAR(5) NULL, ENCLOSE_DELIMITER CHAR(5) NULL, 
APPEND_FLG NUMBER(1) NOT NULL, DELIVERY_FUNC_ID NUMBER(6) NOT NULL, INC_CAMP_KEYS_FLG NUMBER(1) NOT NULL, ENCRYPT_FLG NUMBER(1) NOT NULL, CUSTOM_LENGTH_FLG NUMBER(1) NOT NULL, 
FORWARD_FILE_TO VARCHAR2(100) NULL,  FORWARD_SERVER_ID NUMBER(4) NULL, CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, UPDATED_BY VARCHAR2(30) NULL, UPDATED_DATE DATE NULL,
VIEW_ID VARCHAR2(30) NOT NULL) 
TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKDELIVERY_CHAN ON DELIVERY_CHAN (CHAN_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE DELIVERY_CHAN ADD (PRIMARY KEY (CHAN_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* dropping table LABEL_PARAM no longer used */
	
	execute_sql ('drop table label_param');

	/* adding new table DELIVERY_SERVER */

	execute_sql ('CREATE TABLE DELIVERY_SERVER (SERVER_ID NUMBER(4) NOT NULL, CHAN_ID NUMBER(8) NOT NULL, SERVER_PCTG NUMBER(3) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKDELIVERY_SERVER ON DELIVERY_SERVER (SERVER_ID ASC, CHAN_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE DELIVERY_SERVER ADD (PRIMARY KEY (SERVER_ID, CHAN_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	/* adding flag to CAMP_TREAT_DET to allow definition of AND or OR relationship between segments attached to treatment */

	execute_sql ('ALTER TABLE CAMP_TREAT_DET ADD (IN_ALL_FLG NUMBER(1) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_TREAT_DET MODIFY (IN_ALL_FLG DEFAULT NULL)'); 

	/* amending CAMP_OUT_RESULT and adding CAMP_RESULT_PROC for campaign output parallel process details */

	execute_sql ('create table temp_camp_out_result as select * from camp_out_result');
	delete from camp_out_result;
	commit;
	execute_sql ('drop table camp_out_result');	

	execute_sql ('CREATE TABLE CAMP_OUT_RESULT (CAMP_ID NUMBER(8) NOT NULL, CAMP_OUT_GRP_ID NUMBER(4) NOT NULL, CAMP_OUT_DET_ID NUMBER(8) NOT NULL, SPLIT_SEQ NUMBER(3) NOT NULL, 
CAMP_CYC NUMBER(8) NOT NULL, OUT_NAME VARCHAR2(255) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, OUT_PATH VARCHAR2(255) NULL, OUT_DATE DATE NULL, OUT_TIME CHAR(8) NULL, OUT_QTY NUMBER(10) NULL, APPEND_FLG NUMBER(1) NOT NULL, 
SENT_STARTED_FLG NUMBER(1) NULL, SENT_QTY NUMBER(10) NULL, CHILD_PROC_COUNT NUMBER(4) NULL) 
TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_OUT_RESULT ON CAMP_OUT_RESULT (CAMP_ID ASC, CAMP_OUT_GRP_ID ASC, CAMP_OUT_DET_ID ASC, SPLIT_SEQ ASC, CAMP_CYC ASC, OUT_NAME ASC, RUN_NUMBER ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE CAMP_OUT_RESULT ADD (PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ, CAMP_CYC, OUT_NAME, RUN_NUMBER) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');

	execute_sql ('CREATE TABLE CAMP_RESULT_PROC (CAMP_ID NUMBER(8) NOT NULL, CAMP_OUT_GRP_ID NUMBER(4) NOT NULL, CAMP_OUT_DET_ID NUMBER(8) NOT NULL, SPLIT_SEQ NUMBER(3) NOT NULL, 
CAMP_CYC NUMBER(8) NOT NULL, OUT_NAME VARCHAR2(255) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, CHILD_PROC_ID NUMBER(4) NOT NULL, FROM_SEL_ORDER NUMBER NOT NULL, TO_SEL_ORDER NUMBER NOT NULL, LAST_SEL_ORDER NUMBER NOT NULL) 
TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_RESULT_PROC ON CAMP_RESULT_PROC (CAMP_ID ASC, CAMP_OUT_GRP_ID ASC, CAMP_OUT_DET_ID ASC, SPLIT_SEQ ASC, CAMP_CYC ASC, OUT_NAME ASC, RUN_NUMBER ASC, CHILD_PROC_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE CAMP_RESULT_PROC ADD (PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ, CAMP_CYC, OUT_NAME, RUN_NUMBER, CHILD_PROC_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');


	/* addition for BUILD 318 - re: Dynamic RPC messaging */

	execute_sql ('ALTER TABLE REM_CLIENT_HDR ADD (MESSAGE_COUNT NUMBER(4) NULL)');

	execute_sql ('ALTER TABLE REM_CLIENT_DET ADD (PORTION_TYPE_ID NUMBER(1) DEFAULT 1 NOT NULL)');

	execute_sql ('ALTER TABLE REM_CLIENT_DET MODIFY (PORTION_TYPE_ID DEFAULT NULL)');

	execute_sql ('ALTER TABLE SPI_AUDIT_PARAM MODIFY (PARAM_VAL VARCHAR2(300))');

	execute_sql ('ALTER TABLE PROC_AUDIT_PARAM MODIFY (PARAM_VAL VARCHAR2(300))');

	execute_sql ('CREATE TABLE PORTION_TYPE ( PORTION_TYPE_ID NUMBER NOT NULL, PORTION_NAME VARCHAR2(20) NOT NULL) TABLESPACE '|| var_ts_pv_sys);

	execute_sql ('CREATE UNIQUE INDEX XPKPORTION_TYPE ON PORTION_TYPE ( PORTION_TYPE_ID ASC) TABLESPACE '|| var_ts_pv_ind);

	execute_sql ('ALTER TABLE PORTION_TYPE  ADD ( PRIMARY KEY (PORTION_TYPE_ID) USING INDEX TABLESPACE '|| var_ts_pv_ind ||')');


	/* additions re: build 362 */
	
	execute_sql('ALTER TABLE SPI_MASTER ADD (FREQ_OVERRIDE_FLG NUMBER(1) DEFAULT 0 NOT NULL)');
	COMMIT;

	execute_sql('ALTER TABLE SPI_MASTER MODIFY (FREQ_OVERRIDE_FLG DEFAULT NULL)');

	execute_sql('ALTER TABLE SPI_AUDIT_HDR MODIFY (SOFTWARE_VER VARCHAR2(128))');

	execute_sql('ALTER TABLE PROC_AUDIT_HDR MODIFY (SOFTWARE_VER VARCHAR2(128))');

	/* correction re: build 381 - patched into 379 (MKS 108193) */

	execute_sql( 'ALTER TABLE REM_CLIENT_DET MODIFY (PORTION_SEQ NUMBER(6))' );

	/* update VANTAGE_ENT table */

	delete from vantage_ent where ent_name = 'LABEL_PARAM';
	update vantage_ent set ent_name = 'ERES_RULE_HDR' where ent_name = 'EMAIL_RES_RULE_HDR';
	update vantage_ent set ent_name = 'ERES_RULE_DET' where ent_name = 'EMAIL_RES_RULE_DET';
	update vantage_ent set ent_name = 'ERES_RULE_TYPE' where ent_name = 'RULE_TYPE';
	update vantage_ent set ent_name = 'CAMP_COMM_OUT_SUM' where ent_name = 'CAMP_COMM_OUTB_SUM';

	insert into vantage_ent values ('ATTACHMENT',1,0);
	insert into vantage_ent values ('CHARAC_GRP',1,0);
	insert into vantage_ent values ('CAMP_RESULT_PROC',1,0);
	insert into vantage_ent values ('DELIVERY_SERVER',1,0);
	insert into vantage_ent values ('EMAIL_TYPE',1,1);
	insert into vantage_ent values ('ERES_RULE_GRP',1,0);
	insert into vantage_ent values ('TREATMENT_TEST',1,0);
	insert into vantage_ent values ('SMSC',1,0);
	insert into vantage_ent values ('SMSC_RES_RULE',1,0);
	insert into vantage_ent values ('SMS_RES',1,0);
	insert into vantage_ent values ('TEST_TEMPL_MAP',1,0);
	insert into vantage_ent values ('ERES_RULE_TYPE',1,1);
	insert into vantage_ent values ('MESSAGE_TYPE',1,1);
	insert into vantage_ent values ('TEST_TYPE',1,1);
	insert into vantage_ent values ('NPI_TYPE',1,1);
	insert into vantage_ent values ('PORTION_TYPE',1,1);
	insert into vantage_ent values ('TON_TYPE',1,1);

	COMMIT;

	/* update REF_INDICATOR entries */

	insert into ref_indicator values (24, 'From');
	insert into ref_indicator values (25, 'Reply');
	insert into ref_indicator values (26, 'Output From');
	insert into ref_indicator values (27, 'Output Reply');
	insert into ref_indicator values (28, 'Delivery');
	COMMIT;

	/* update CONSTRAINT_SETTING table for new entries */

	update constraint_setting set obj_type_id = 12 where ref_type_id = 11 and ref_indicator_id = 1;
	update constraint_setting set obj_type_id = 11 where ref_type_id = 24 and ref_indicator_id = 21;
	update constraint_setting set ref_type_id = 21, obj_type_id = 14 where ref_type_id = 24 and ref_indicator_id = 15 and obj_type_id is null;

	insert into constraint_setting values ( 24, 21, 12, 2 );
	insert into constraint_setting values ( 24, 26, 62, 2 );
	insert into constraint_setting values ( 24, 27, 62, 2 );
	insert into constraint_setting values ( 42,  1, 80, 1 );  
	insert into constraint_setting values ( 11,  1, 61, 2 );
	insert into constraint_setting values ( 11, 28, null, 2 );
	insert into constraint_setting values ( 14,  1, null, 1 );
	insert into constraint_setting values ( 79,  1, 69, 2 );
	insert into constraint_setting values ( 69,  1, null, 1 );
	COMMIT;

	/* update PROC_CONTROL and PROC_PARAM with additional values for Seed Lists, and Test Treatment processes */

	insert into proc_control select 'Seed Lists', null, 1, 'v_seedlistsproc', location, 12 
		from proc_control where proc_name = 'Score Model';
	
	insert into proc_param values ('Seed Lists', 0, 'Server executable name', 'v_seedlistsproc');
	insert into proc_param values ('Seed Lists', 1, 'Call Type', null );
	insert into proc_param values ('Seed Lists', 2, 'RPC Id / SPI Audit Id', null );
	insert into proc_param values ('Seed Lists', 3, 'Process Audit Id', null );
	insert into proc_param values ('Seed Lists', 4, 'Secure Database Account Name', null );
	insert into proc_param values ('Seed Lists', 5, 'Secure Database Password', null );
	insert into proc_param values ('Seed Lists', 6, 'Customer Data View Id', null );
	insert into proc_param values ('Seed Lists', 7, 'User Id', null );
	insert into proc_param values ('Seed Lists', 8, 'Database Vendor Id', null );
	insert into proc_param values ('Seed Lists', 9, 'Database Connection String', null );
	insert into proc_param values ('Seed Lists', 10, 'Language Id', null );
	insert into proc_param values ('Seed Lists', 11, 'Seed List Id', null );
	COMMIT;

	insert into proc_control select 'Test Treatment', null, 1, 'v_treatmenttest_proc', location, 13 
		from proc_control where proc_name = 'Score Model';
	
	insert into proc_param values ('Test Treatment', 0, 'Server executable name', 'v_treatmenttest_proc');
	insert into proc_param values ('Test Treatment', 1, 'Call Type', 'S' );
	insert into proc_param values ('Test Treatment', 2, 'RPC Id / SPI Audit Id', null );
	insert into proc_param values ('Test Treatment', 3, 'Process Audit Id', null );
	insert into proc_param values ('Test Treatment', 4, 'Secure Database Account Name', null );
	insert into proc_param values ('Test Treatment', 5, 'Secure Database Password', null );
	insert into proc_param values ('Test Treatment', 6, 'Customer Data View Id', null );
	insert into proc_param values ('Test Treatment', 7, 'User Id', null );
	insert into proc_param values ('Test Treatment', 8, 'Database Vendor Id', null );
	insert into proc_param values ('Test Treatment', 9, 'Database Connection String', null );
	insert into proc_param values ('Test Treatment', 10, 'Language Id', null );
	insert into proc_param values ('Test Treatment', 11, 'Treatment Type Id', null );
	insert into proc_param values ('Test Treatment', 12, 'Treatment Id', null );
	COMMIT;

	/* Further additions re: SPI process entries for SMS, amendment to EMAIL_RES and addition of SMS_RES */

	update obj_type set obj_name = 'Email Delivery Engine' 
		where obj_type_id = 64 and obj_name = 'Email Delivery';
	update obj_type set obj_name = 'Email Rule' 
		where obj_type_id = 69 and obj_name = 'Resolution Rule';
	insert into obj_type values (84, 'SMS Delivery Engine', NULL);
	insert into obj_type values (85, 'User Group', NULL);
	insert into obj_type values (86, 'User', NULL);
	insert into obj_type values (87, 'CDV', NULL);
	insert into obj_type values (88, 'Module', NULL);
	insert into obj_type values (89, 'Placement', NULL);

	COMMIT;

	insert into proc_control select 'SMS Delivery', null, 1, 'v_sms_proc', location, 17 
 		from proc_control where proc_name = 'Seed Lists';

	insert into proc_param values ('SMS Delivery', 0, 'Server executable name', 'v_sms_proc');
	insert into proc_param values ('SMS Delivery', 1, 'Call Type', 'S' );
	insert into proc_param values ('SMS Delivery', 2, 'RPC Id / SPI Audit Id', null );
	insert into proc_param values ('SMS Delivery', 3, 'Process Audit Id', null );
	insert into proc_param values ('SMS Delivery', 4, 'Secure Database Account Name', null );
	insert into proc_param values ('SMS Delivery', 5, 'Secure Database Password', null );
	insert into proc_param values ('SMS Delivery', 6, 'Customer Data View Id', null );
	insert into proc_param values ('SMS Delivery', 7, 'User Id', null );
	insert into proc_param values ('SMS Delivery', 8, 'Database Vendor Id', null );
	insert into proc_param values ('SMS Delivery', 9, 'Database Connection String', null );
	insert into proc_param values ('SMS Delivery', 10, 'Language Id', null );
	insert into proc_param values ('SMS Delivery', 11, 'Campaign Id', null );
	insert into proc_param values ('SMS Delivery', 12, 'Campaign Output Group Id', null );
	insert into proc_param values ('SMS Delivery', 13, 'Campaign Output Detail Id', null );
	insert into proc_param values ('SMS Delivery', 14, 'Split Sequence', null );
	insert into proc_param values ('SMS Delivery', 15, 'Campaign Cycle Number', null );
	insert into proc_param values ('SMS Delivery', 16, 'Run Number', null );
	COMMIT;

	SELECT VIEW_ID INTO var_main_view FROM CUST_TAB WHERE DB_ENT_NAME = 'CAMP_COMM_OUT_DET' AND ROWNUM = 1;

	SELECT DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE INTO var_dtype, var_dlen, var_dprec, var_dscale FROM PV_COLS X 
	  WHERE EXISTS (SELECT * FROM CUST_TAB WHERE VIEW_ID = var_main_view AND VANTAGE_TYPE = 1 AND DB_ENT_OWNER = X.TABLE_OWNER AND DB_ENT_NAME = X.TABLE_NAME AND STD_JOIN_FROM_COL = X.COLUMN_NAME);

	IF  var_dtype = 'NUMBER' THEN
		IF var_dscale = 0 THEN
			IF var_dprec = 0 THEN
				var_coltype := var_dtype;
			ELSE
				var_coltype := var_dtype || '(' || var_dprec || ')';
			END IF;
		ELSE
			var_coltype := var_dtype || '(' || var_dprec || ',' || var_dscale || ')';
		END IF;
	ELSE
		var_coltype := var_dtype || '(' || var_dlen || ')';
	END IF; 

	execute_sql ('ALTER TABLE EMAIL_RES MODIFY (KEYCODE VARCHAR2(30))');

	execute_sql ('ALTER TABLE EMAIL_RES ADD (A1 ' || var_coltype || ' NULL, CAMP_ID NUMBER(8), DET_ID NUMBER(4) NULL, CAMP_CYC NUMBER(8) NULL, RUN_NUMBER VARCHAR2(200) NULL)');

	execute_sql ('CREATE INDEX XIE3EMAIL_RES ON EMAIL_RES (A1 ASC) TABLESPACE '|| var_ts_pv_cind);

	execute_sql ('CREATE INDEX XIE4EMAIL_RES ON EMAIL_RES (CAMP_ID ASC, DET_ID ASC) TABLESPACE '|| var_ts_pv_cind);

	execute_sql ('CREATE TABLE SMS_RES (RES_DATE DATE NOT NULL, RES_TIME CHAR(8) NOT NULL, KEYCODE VARCHAR2(30) NULL, 
A1 ' || var_coltype || ' NULL, CAMP_ID NUMBER(8) NULL, DET_ID NUMBER(4) NULL, CAMP_CYC NUMBER(8) NULL, RUN_NUMBER VARCHAR2(200) NULL, 
TELEPHONE_NUMBER VARCHAR2(100) NULL, STRING_1 VARCHAR2(40) NULL, STRING_2 VARCHAR2(40) NULL, STRING_3 VARCHAR2(40) NULL, STRING_4 VARCHAR2(40) NULL, 
STRING_5 VARCHAR2(40) NULL, STRING_6 VARCHAR2(40) NULL, STRING_7 VARCHAR2(20) NULL, STRING_8 VARCHAR2(40) NULL, STRING_9 VARCHAR2(40) NULL, 
STRING_10 VARCHAR2(40) NULL) TABLESPACE '|| var_ts_pv_comm);

	execute_sql ('CREATE INDEX XIE1SMS_RES ON SMS_RES (KEYCODE ASC) TABLESPACE '|| var_ts_pv_cind);

	execute_sql ('CREATE INDEX XIE2SMS_RES ON SMS_RES (TELEPHONE_NUMBER ASC) TABLESPACE '|| var_ts_pv_cind);

	execute_sql ('CREATE INDEX XIE3SMS_RES ON SMS_RES (A1 ASC) TABLESPACE '|| var_ts_pv_cind);

	execute_sql ('CREATE INDEX XIE4SMS_RES ON SMS_RES (CAMP_ID ASC, DET_ID ASC) TABLESPACE '|| var_ts_pv_cind);

	IF ((var_sms_alias IS NOT NULL) AND (var_sms_col IS NOT NULL)) THEN
	   insert into cust_tab select view_id, 'SMS_RES', 'SMS Inbound Communications', 99, 99999, NULL, NULL, 'SMS_RES', user, NULL, NULL, 1, 'TELEPHONE_NUMBER', var_sms_col, var_sms_alias, 'order by column_name', 1 
		from cust_tab where db_ent_name = 'EMAIL_RES';
	   COMMIT;
	END IF;

	update pvdm_upgrade set version_id = '3.2.379.1';

	COMMIT;

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('> The V31.1 to V3.2 Upgrade is not applicable.');
		dbms_output.put_line('>');
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure error occurred');
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;

END;
/


/* trigger changes */

create or replace trigger TD_CAMP_OUT_DET
  AFTER DELETE
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:06:36 2000 */
/* default body for TD_CAMP_OUT_DET */
declare numrows INTEGER;
      

begin

if :old.chan_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
    and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
    obj_type_id = 11 and obj_id = :old.chan_id;
end if;

if (:old.ext_templ_id is not null and :old.ext_templ_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 12 and obj_id = :old.ext_templ_id;
end if;

if (:old.seed_list_id is not null and :old.seed_list_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 14 and obj_id = :old.seed_list_id;
end if;

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
     obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
end if;

if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
     obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
end if;

end;
/


create or replace trigger TI_CAMP_OUT_DET
  AFTER INSERT
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:06:47 2000 */
/* default body for TI_CAMP_OUT_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.chan_id <> 0 then
  /* check referenced delivery channel still exists */
  select chan_id into var_id from delivery_chan where chan_id = :new.chan_id;

  insert into referenced_obj select 11, :new.chan_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 11 or obj_type_id is null);
end if;

if (:new.ext_templ_id is not null and :new.ext_templ_id <> 0) then
  /* check referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.ext_templ_id;

  insert into referenced_obj select 12, :new.ext_templ_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 12 or obj_type_id is null);
end if;

if (:new.seed_list_id is not null and :new.seed_list_id <> 0) then
  /* check referenced seed list still exists */
  select seed_list_id into var_id from seed_list_hdr where seed_list_id = :new.seed_list_id;

  insert into referenced_obj select 14, :new.seed_list_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 14 or obj_type_id is null);
end if;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  /* check referenced from mailbox still exists */
  select server_id into var_id from email_mailbox where server_id = :new.from_server_id
    and mailbox_id = :new.from_mailbox_id;

  insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
    and (obj_type_id = 62 or obj_type_id is null);
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  /* check referenced reply mailbox still exists */
  select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
    and mailbox_id = :new.reply_mailbox_id;

  insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
    and (obj_type_id = 62 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_OUT_DET_DC
  AFTER UPDATE OF 
        CHAN_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:07:19 2000 */
/* default body for TU_CAMP_OUT_DET_DC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.chan_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
    and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
    obj_type_id = 11 and obj_id = :old.chan_id;
end if;

if :new.chan_id <> 0 then
  /* check referenced delivery channel still exists */
  select chan_id into var_id from delivery_chan where chan_id = :new.chan_id;

  insert into referenced_obj select 11, :new.chan_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 11 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_OUT_DET_ET
  AFTER UPDATE OF 
        EXT_TEMPL_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:07:36 2000 */
/* default body for TU_CAMP_OUT_DET_ET */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.ext_templ_id is not null and :old.ext_templ_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 12 and obj_id = :old.ext_templ_id;
end if;

if (:new.ext_templ_id is not null and :new.ext_templ_id <> 0) then
  /* check referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.ext_templ_id;

  insert into referenced_obj select 12, :new.ext_templ_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 12 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_OUT_DET_FM
  AFTER UPDATE OF 
        FROM_SERVER_ID,
        FROM_MAILBOX_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:07:51 2000 */
/* default body for TU_CAMP_OUT_DET_FM */
declare numrows INTEGER;
        var_id INTEGER;
begin

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
     obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
end if;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  /* check referenced from mailbox still exists */
  select server_id into var_id from email_mailbox where server_id = :new.from_server_id
    and mailbox_id = :new.from_mailbox_id;

  insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
    and (obj_type_id = 62 or obj_type_id is null);
end if;

end;
/


create or replace trigger TU_CAMP_OUT_DET_RM
  AFTER UPDATE OF 
        REPLY_SERVER_ID,
        REPLY_MAILBOX_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:08:01 2000 */
/* default body for TU_CAMP_OUT_DET_RM */
declare numrows INTEGER;
        var_id INTEGER;
begin
if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
     obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  /* check referenced reply mailbox still exists */
  select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
    and mailbox_id = :new.reply_mailbox_id;

  insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
    and (obj_type_id = 62 or obj_type_id is null);
end if;

end;
/


create or replace trigger TU_CAMP_OUT_DET_SL
  AFTER UPDATE OF 
        SEED_LIST_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Jul 31 12:08:18 2000 */
/* default body for TU_CAMP_OUT_DET_SL */
declare numrows INTEGER;
        var_id INTEGER;
begin

if (:old.seed_list_id is not null and :old.seed_list_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 14 and obj_id = :old.seed_list_id;
end if;

if (:new.seed_list_id is not null and :new.seed_list_id <> 0) then
  /* check referenced delivery channel still exists */
  select seed_list_id into var_id from seed_list_hdr where seed_list_id = :new.seed_list_id;

  insert into referenced_obj select 14, :new.seed_list_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 14 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TD_CHARAC
  AFTER DELETE
  on CHARAC
  
  for each row
/* ERwin Builtin Mon Jul 31 12:13:48 2000 */
/* default body for TD_CHARAC */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 42 and ref_id = :old.charac_id 
  and ref_indicator_id = 1 and obj_type_id = 80 and obj_id = :old.charac_grp_id; 

end;
/

create or replace trigger TI_CHARAC
  AFTER INSERT
  on CHARAC
  
  for each row
/* ERwin Builtin Mon Jul 31 12:13:59 2000 */
/* default body for TI_CHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select charac_grp_id into var_id from charac_grp where charac_grp_id = :new.charac_grp_id;

insert into referenced_obj select 80, :new.charac_grp_id, null, null, null, null, null, 
  42, :new.charac_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 42 and ref_indicator_id = 1 and 
  (obj_type_id = 80 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/

create or replace trigger TU_CHARAC
  AFTER UPDATE OF 
        CHARAC_GRP_ID
  on CHARAC
  
  for each row
/* ERwin Builtin Fri Aug 11 16:26:38 2000 */
/* default body for TU_CHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 42 and ref_id = :old.charac_id 
  and ref_indicator_id = 1 and obj_type_id = 80 and obj_id = :old.charac_grp_id; 

/* check referenced object still exists */
select charac_grp_id into var_id from charac_grp where charac_grp_id = :new.charac_grp_id;

insert into referenced_obj select 80, :new.charac_grp_id, null, null, null, null, null, 42, :new.charac_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 42 and ref_indicator_id = 1 and (obj_type_id = 80 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TD_DELIVERY_CHAN
  AFTER DELETE
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Jul 31 13:22:59 2000 */
/* default body for TD_DELIVERY_CHAN */
declare numrows INTEGER;

begin

if :old.dft_ext_templ_id <> 0 then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 12 and obj_id = :old.dft_ext_templ_id;
end if;

if (:old.forward_server_id is not null and :old.forward_server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.forward_server_id;
end if;

end;
/

create or replace trigger TI_DELIVERY_CHAN
  AFTER INSERT
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Jul 31 13:23:17 2000 */
/* default body for TI_DELIVERY_CHAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.dft_ext_templ_id <> 0 then
  /* check that referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.dft_ext_templ_id;
  
  insert into referenced_obj select 12, :new.dft_ext_templ_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 12 or obj_type_id is null);
end if;

if (:new.forward_server_id is not null and :new.forward_server_id <> 0) then
  /* check that referenced FORWARD EMAIL SERVER still exists */
  select server_id into var_id from email_server where server_id = :new.forward_server_id;
  
  insert into referenced_obj select 61, :new.forward_server_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 61 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TU_DELIVERY_CHAN_E
  AFTER UPDATE OF 
        DFT_EXT_TEMPL_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Jul 31 13:23:28 2000 */
/* default body for TU_DELIVERY_CHAN_E */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.dft_ext_templ_id <> 0 then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 12 and obj_id = :old.dft_ext_templ_id;
end if;

if :new.dft_ext_templ_id <> 0 then
  /* check that referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.dft_ext_templ_id;
  
  insert into referenced_obj select 12, :new.dft_ext_templ_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 12 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TU_DELIVERY_CHAN_FS
  AFTER UPDATE OF 
        FORWARD_SERVER_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Jul 31 13:24:00 2000 */
/* default body for TU_DELIVERY_CHAN_FS */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.forward_server_id is not null and :old.forward_server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.forward_server_id;
end if;

if (:new.forward_server_id is not null and :new.forward_server_id <> 0) then
  /* check that referenced FORWARD EMAIL SERVER still exists */
  select server_id into var_id from email_server where server_id = :new.forward_server_id;
  
  insert into referenced_obj select 61, :new.forward_server_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 61 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/

create or replace trigger TD_DELIVERY_SERVER
  AFTER DELETE
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Jul 31 13:44:53 2000 */
/* default body for TD_DELIVERY_SERVER */
declare numrows INTEGER;
        var_chan_type INTEGER;
begin

if (:old.server_id is not null and :old.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :old.chan_id;

  if (var_chan_type = 30) then /* Email Server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 61 and obj_id = :old.server_id;
  elsif (var_chan_type = 40) then /* SMSC */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 79 and obj_id = :old.server_id;
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/

create or replace trigger TI_DELIVERY_SERVER
  AFTER INSERT
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Jul 31 13:45:09 2000 */
/* default body for TI_DELIVERY_SERVER */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type INTEGER;
begin

if (:new.server_id is not null and :new.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :new.chan_id;

  if (var_chan_type = 30) then /* Email Server */
     select server_id into var_id from email_server where server_id = :new.server_id;

     insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 61 or obj_type_id is null);

  elsif (var_chan_type = 40) then /* SMSC */
     select smsc_id into var_id from smsc where smsc_id = :new.server_id;

     insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 79 or obj_type_id is null);   
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/

create or replace trigger TU_DELIVERY_SERVER
  AFTER UPDATE OF 
        SERVER_ID
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Jul 31 13:45:18 2000 */
/* default body for TU_DELIVERY_SERVER */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type INTEGER;
begin

if (:old.server_id is not null and :old.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :old.chan_id;

  if (var_chan_type = 30) then /* Email Server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 61 and obj_id = :old.server_id;

  elsif (var_chan_type = 40) then /* SMSC */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 79 and obj_id = :old.server_id;
  end if;
end if;

if (:new.server_id is not null and :new.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :new.chan_id;

  if (var_chan_type = 30) then /* Email Server */
     select server_id into var_id from email_server where server_id = :new.server_id;

     insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 61 or obj_type_id is null);

  elsif (var_chan_type = 40) then /* SMSC */
     select smsc_id into var_id from smsc where smsc_id = :new.server_id;

     insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 79 or obj_type_id is null);   
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TD_MAILBOX_RES_RUL
  AFTER DELETE
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:33:06 2000 */
/* default body for TD_MAILBOX_RES_RUL */
declare numrows INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
    ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 69 and
    obj_id = :old.rule_id;
end if;

end;
/

create or replace trigger TI_MAILBOX_RES_RUL
  AFTER INSERT
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:33:38 2000 */
/* default body for TI_MAILBOX_RES_RUL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_MAILBOX_RES_RUL
  AFTER UPDATE OF 
        RULE_ID
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:33:53 2000 */
/* default body for TU_MAILBOX_RES_RUL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
    ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 69 and
    obj_id = :old.rule_id;
end if;

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_SMSC_RES_RULE
  AFTER DELETE
  on SMSC_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:37:22 2000 */
/* default body for TD_SMSC_RES_RULE */
declare numrows INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 79 and ref_id = :old.smsc_id and
    ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
end if;

end;
/


create or replace trigger TI_SMSC_RES_RULE
  AFTER INSERT
  on SMSC_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:38:14 2000 */
/* default body for TI_SMSC_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    79, :new.smsc_id, null, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 79 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_SMSC_RES_RULE
  AFTER UPDATE OF 
        RULE_ID
  on SMSC_RES_RULE
  
  for each row
/* ERwin Builtin Wed Aug 09 17:38:40 2000 */
/* default body for TU_SMSC_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 79 and ref_id = :old.smsc_id and
    ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
end if;

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    79, :new.smsc_id, null, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 79 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_SEED_LIST_HDR
  AFTER DELETE
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 12:56:53 2000 */
/* default body for TD_SEED_LIST_HDR */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 14 and ref_id = :old.seed_list_id 
  and ref_indicator_id = 1 and obj_type_id = 76 and obj_id = :old.seed_list_grp_id; 

end;
/


create or replace trigger TI_SEED_LIST_HDR
  AFTER INSERT
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 12:57:09 2000 */
/* default body for TI_SEED_LIST_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select seed_list_grp_id into var_id from seed_list_grp where seed_list_grp_id = :new.seed_list_grp_id;

insert into referenced_obj select 76, :new.seed_list_grp_id, null, null, null, null, null, 
  14, :new.seed_list_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 14 and ref_indicator_id = 1 and 
  (obj_type_id = 76 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_SEED_LIST_HDR
  AFTER UPDATE OF 
        SEED_LIST_GRP_ID
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 12:57:21 2000 */
/* default body for TU_SEED_LIST_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 14 and ref_id = :old.seed_list_id 
  and ref_indicator_id = 1 and obj_type_id = 76 and obj_id = :old.seed_list_grp_id; 

/* check referenced object still exists */
select seed_list_grp_id into var_id from seed_list_grp where seed_list_grp_id = :new.seed_list_grp_id;

insert into referenced_obj select 76, :new.seed_list_grp_id, null, null, null, null, null, 14, :new.seed_list_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 14 and ref_indicator_id = 1 and (obj_type_id = 76 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TD_ERES_RULE_HDR
  AFTER DELETE
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 13:04:12 2000 */
/* default body for TD_ERES_RULE_HDR */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 69 and ref_id = :old.rule_id 
  and ref_indicator_id = 1 and obj_type_id = 81 and obj_id = :old.res_rule_grp_id; 

end;
/


create or replace trigger TI_ERES_RULE_HDR
  AFTER INSERT
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 13:04:24 2000 */
/* default body for TI_ERES_RULE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select res_rule_grp_id into var_id from eres_rule_grp where res_rule_grp_id = :new.res_rule_grp_id;

insert into referenced_obj select 81, :new.res_rule_grp_id, null, null, null, null, null, 69, :new.rule_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 69 and ref_indicator_id = 1 and (obj_type_id = 81 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TU_ERES_RULE_HDR
  AFTER UPDATE OF 
        RES_RULE_GRP_ID
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Wed Aug 02 13:04:38 2000 */
/* default body for TU_ERES_RULE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 69 and ref_id = :old.rule_id 
  and ref_indicator_id = 1 and obj_type_id = 81 and obj_id = :old.res_rule_grp_id; 

/* check referenced object still exists */
select res_rule_grp_id into var_id from eres_rule_grp where res_rule_grp_id = :new.res_rule_grp_id;

insert into referenced_obj select 81, :new.res_rule_grp_id, null, null, null, null, null, 69, :new.rule_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 69 and ref_indicator_id = 1 and (obj_type_id = 81 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/

create or replace trigger TD_ELEM
  AFTER DELETE
  on ELEM
  
  for each row
/* ERwin Builtin Thu Aug 24 11:42:18 2000 */
/* default body for TD_ELEM */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 44 and ref_id = :old.elem_id 
  and ref_indicator_id = 1 and obj_type_id = 43 and obj_id = :old.elem_grp_id; 

end;
/

create or replace trigger TI_ELEM
  AFTER INSERT
  on ELEM
  
  for each row
/* ERwin Builtin Thu Aug 24 11:42:44 2000 */
/* default body for TI_ELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced object still exists */
select elem_grp_id into var_id from elem_grp where elem_grp_id = :new.elem_grp_id;

insert into referenced_obj select 43, :new.elem_grp_id, null, null, null, null, null, 44, :new.elem_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 44 and ref_indicator_id = 1 and (obj_type_id = 43 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TU_ELEM
  AFTER UPDATE OF 
        ELEM_GRP_ID
  on ELEM
  
  for each row
/* ERwin Builtin Thu Aug 24 11:43:03 2000 */
/* default body for TU_ELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 44 and ref_id = :old.elem_id 
  and ref_indicator_id = 1 and obj_type_id = 43 and obj_id = :old.elem_grp_id; 

/* check referenced object still exists */
select elem_grp_id into var_id from elem_grp where elem_grp_id = :new.elem_grp_id;

insert into referenced_obj select 43, :new.elem_grp_id, null, null, null, null, null, 44, :new.elem_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 44 and ref_indicator_id = 1 and (obj_type_id = 43 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


set SERVEROUT OFF

insert into search_area select * from temp_search_area 
  where 0 = (select count(*) from search_area)
  and exists (select * from pv_tabs where table_name = 'TEMP_SEARCH_AREA');
COMMIT;

insert into grp_ftr_type select * from temp_grp_ftr_type
  where 0 = (select count(*) from grp_ftr_type)
  and exists (select * from pv_tabs where table_name = 'TEMP_GRP_FTR_TYPE');
COMMIT;

insert into tree_det select * from temp_tree_det
  where 0 = (select count(*) from tree_det)
  and exists (select * from pv_tabs where table_name = 'TEMP_TREE_DET');
COMMIT;

insert into eres_rule_type select 1, 'Email Response Rule' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from eres_rule_type where rule_type_id = 1);
insert into eres_rule_type select 2, 'Email Non Delivery Rule' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from eres_rule_type where rule_type_id = 2);
insert into eres_rule_type select 3, 'SMS Response Rule' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from eres_rule_type where rule_type_id = 3);
COMMIT;

insert into ERES_RULE_GRP select 1,1,'Default Email Rule Group' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from eres_rule_grp where res_rule_grp_id = 1);

insert into eres_rule_hdr (rule_id, rule_name, rule_type_id, res_rule_grp_id, created_by, created_date, updated_by, updated_date)
	select rule_id, rule_name, 1, 1, created_by, created_date, updated_by, updated_date 
	from temp_eres_rule_hdr x where exists (select * from pv_tabs where table_name = 'TEMP_ERES_RULE_DET');

insert into eres_rule_det (rule_id, rule_det_seq, string_val, search_area_id, start_after_string, end_before_string, case_sensitive_flg, join_operator_id)
 	select rule_id, rule_det_seq, string_val, search_area_id, start_after_string, end_before_string, case_sensitive_flg, join_operator_id 
	from temp_eres_rule_det x where exists (select * from pv_tabs where table_name = 'TEMP_ERES_RULE_DET');

update eres_rule_det set search_area_id = 6 where search_area_id = 7 and exists (select * from pvdm_upgrade 
	where substr(version_id,1,3) = '3.2');
COMMIT;

insert into elem (elem_id, elem_grp_id, elem_name, elem_desc, var_cost, var_cost_qty, 
  content_filename, content_formt_id, dyn_content_flg, content_length, content, dyn_placeholders, 
  web_method_id, message_type_id, created_by, created_date, updated_by, updated_date) 
select elem_id, elem_grp_id, elem_name, elem_desc, var_cost, var_cost_qty, 
  content_filename, content_formt_id, dyn_content_flg, null, null, dyn_placeholders, 
  web_method_id, null, created_by, created_date, updated_by, updated_date from temp_elem 
  where 0 = (select count(*) from elem) and exists (select * from pv_tabs where table_name = 'TEMP_ELEM');
COMMIT;

/* map content format from old elem table to treatment email_type for 'HTML' and 'Text' */

update treatment x set email_type_id = 1 where exists (select * from temp_elem e, telem t
    where t.treatment_id = x.treatment_id and t.elem_id = e.elem_id and e.content_formt_id = 13 and rownum = 1)
    and exists (select * from pv_tabs where table_name = 'TEMP_ELEM');

update treatment x set email_type_id = 2 where exists (select * from temp_elem e, telem t
    where t.treatment_id = x.treatment_id and t.elem_id = e.elem_id and e.content_formt_id = 11 and rownum = 1)
    and exists (select * from pv_tabs where table_name = 'TEMP_ELEM');
COMMIT;

/* map email subject from old elem table to treatment email_type for 'HTML' and 'Text' */

update treatment x set email_subject = (select unique email_subject from temp_elem e, telem t
    where t.treatment_id = x.treatment_id and t.elem_id = e.elem_id and rownum = 1)
    where exists (select * from pv_tabs where table_name = 'TEMP_ELEM');
COMMIT;

/* map dynamic placeholders value from old elem table to new treatment column TOTAL_PLACEHOLDERS */

update treatment x set total_placeholders = (select  max(dyn_placeholders) from temp_elem e, telem t
    where t.treatment_id = x.treatment_id and t.elem_id = e.elem_id)
    where exists (select * from pv_tabs where table_name = 'TEMP_ELEM');
COMMIT;

insert into test_type select 1, 'Samples' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from test_type where test_type_id = 1);
insert into test_type select 2, 'Segment' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from test_type where test_type_id = 2);
insert into test_type select 3, 'Seed List' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from test_type where test_type_id = 3);
COMMIT;

/* populate treatment_test table with default values for all email treatments */

insert into treatment_test select treatment_id, 1, 0, 0, 0, 0, null, null, 0, 0, 0, 0, 0, 0, 0, 1, null, null 
	from treatment x where exists (select * from treatment_grp where chan_type_id = 30 and treatment_grp_id = x.treatment_grp_id);
COMMIT;

insert into charac_grp select 1, 'Default Characteristic Group' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from charac_grp where charac_grp_id = 1);
COMMIT;
insert into charac (charac_id, charac_name, charac_desc, created_by, created_date, updated_by, updated_date, charac_grp_id)
   select charac_id, charac_name, charac_desc, created_by, created_date, updated_by, updated_date, 1 from temp_charac;
COMMIT;

insert into delivery_chan (chan_id, chan_type_id, delivery_method_id, chan_out_type_id, dft_ext_templ_id, chan_name, chan_desc, record_delimiter, fld_delimiter, enclose_delimiter, append_flg, delivery_func_id, inc_camp_keys_flg, encrypt_flg, custom_length_flg, forward_file_to, forward_server_id, created_by, created_date, updated_by, updated_date, view_id) 
select chan_id, chan_type_id, delivery_method_id, chan_out_type_id, dft_ext_templ_id, chan_name, chan_desc, record_delimiter, fld_delimiter, enclose_delimiter, append_flg, delivery_func_id, inc_keycode_flg, 0, custom_length_flg, forward_file_to, null, created_by, created_date, updated_by, updated_date, view_id from temp_delivery_chan
  where 0 = (select count(*) from delivery_chan)
  and exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

/* update delivery method in new table to PV Email Delivery Engine where old data had SEND_EMAIL_FLG set to TRUE */

update delivery_chan x set delivery_method_id = 3 where exists (select * from temp_delivery_chan 
   where chan_id = x.chan_id and send_email_flg = 1) 
   and exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');
COMMIT;

/* map old delivery channel and server details from DELIVERY_CHAN to new DELIVERY_SERVER table */
insert into delivery_server (server_id, chan_id, server_pctg) 
  select server_id, chan_id, 100 from temp_delivery_chan where (server_id is not null and server_id <> 0) 
  and exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

COMMIT;

insert into camp_out_det (camp_id, camp_out_grp_id, camp_out_det_id, split_seq, chan_id, alt_ext_templ_flg, ext_templ_id, use_templ_seq_flg, number_of_samples, from_alias, reply_alias, out_name_suffix, from_server_id, from_mailbox_id, reply_server_id, reply_mailbox_id, seed_list_id) 
select camp_id, camp_out_grp_id, camp_out_det_id, split_seq, chan_id, alt_ext_templ_flg, ext_templ_id, use_templ_seq_flg, number_of_samples, email_from, email_reply_to, out_name_suffix, null, null, null, null, null from temp_camp_out_det
  where 0 = (select count(*) from camp_out_det)
  and exists (select * from pv_tabs where table_name = 'TEMP_CAMP_OUT_DET');

/* map old bounce mailbox in delivery_chan table to from and reply mailbox in new camp_out_det table */

update camp_out_det x set from_server_id = (select bounce_server_id from temp_delivery_chan where chan_id = x.chan_id)
   where exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

update camp_out_det x set from_mailbox_id = (select bounce_mailbox_id from temp_delivery_chan where chan_id = x.chan_id)
   where exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

update camp_out_det x set reply_server_id = (select bounce_server_id from temp_delivery_chan where chan_id = x.chan_id)
   where exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

update camp_out_det x set reply_mailbox_id = (select bounce_mailbox_id from temp_delivery_chan where chan_id = x.chan_id)
   where exists (select * from pv_tabs where table_name = 'TEMP_DELIVERY_CHAN');

COMMIT;

/* populate new domain name attribute in EMAIL_SERVER with default values */

update email_server set domain_name = hostname where domain_name is null
        and exists (select * from pvdm_upgrade where substr(version_id,1,3) = '3.2');

/* adding pre-populated entries for EMAIL and SMS to DELIVERY_METHOD table */
delete from DELIVERY_METHOD where delivery_method_id > 2;
insert into DELIVERY_METHOD select 3, 'Prime@Vantage Email Delivery Engine' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from delivery_method where delivery_method_id = 3);
insert into DELIVERY_METHOD select 4, 'Prime@Vantage SMS Delivery Engine' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from delivery_method where delivery_method_id = 4);
COMMIT;

insert into email_type select 1, 'Text' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from email_type where email_type_id = 1);
insert into email_type select 2, 'HTML' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from email_type where email_type_id = 2);
insert into email_type select 3, 'Choose Best' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from email_type where email_type_id = 3);
COMMIT;
	
insert into message_type select 1, 'SMS Single Message' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from message_type where message_type_id = 1);
insert into message_type select 2, 'SMS Concatenated Message' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from message_type where message_type_id = 2);
COMMIT;
	
insert into out_seed_mapping (camp_id, camp_out_grp_id, camp_out_det_id, split_seq, templ_line_seq, seed_list_id, 
  seed_col_seq, default_val) select camp_id, camp_out_grp_id, camp_out_det_id, split_seq, templ_line_seq, 
  seed_list_id, seed_col_seq, default_val from temp_out_seed_mapping
  where 0 = (select count(*) from out_seed_mapping)
  and exists (select * from pv_tabs where table_name = 'TEMP_OUT_SEED_MAPPING');
COMMIT;

insert into CAMP_OUT_RESULT (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ, CAMP_CYC, OUT_NAME, RUN_NUMBER, OUT_PATH, OUT_DATE, OUT_TIME, OUT_QTY, APPEND_FLG, SENT_STARTED_FLG, SENT_QTY, CHILD_PROC_COUNT) 
SELECT CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, SPLIT_SEQ, CAMP_CYC, OUT_NAME, CAMP_CYC, OUT_PATH, OUT_DATE, OUT_TIME, OUT_QTY, APPEND_FLG, EMAIL_STARTED_FLG, EMAIL_SENT_QTY, 0 from temp_camp_out_result
  where 0 = (select count(*) from  camp_out_result)
  and exists (select * from pv_tabs where table_name = 'TEMP_CAMP_OUT_RESULT');
COMMIT;


insert into TON_TYPE select 0, 'Unknown' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from ton_type where ton = 0);
insert into TON_TYPE select 1, 'National' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from ton_type where ton = 1);
insert into TON_TYPE select 2, 'International' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from ton_type where ton = 2);
insert into TON_TYPE select 3, 'Network specific' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from ton_type where ton = 3);
insert into TON_TYPE select 4, 'Short' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from ton_type where ton = 4);
COMMIT;


insert into NPI_TYPE select 0, 'Unknown' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 0);
insert into NPI_TYPE select 1, 'ISDN / telephone numbering plan (CCITT Rec.E.164/E.163)' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 1);
insert into NPI_TYPE select 3, 'Data numbering plan (CCITT Rec.x.121)' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 3);
insert into NPI_TYPE select 4, 'Telex numbering plan' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 4);
insert into NPI_TYPE select 8, 'National numbering plan' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 8);
insert into NPI_TYPE select 9, 'Private numbering plan' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from npi_type where npi = 9);
COMMIT;

insert into portion_type select 1, 'Information Portion' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from portion_type where portion_type_id = 1);
insert into portion_type select 2, 'Message Portion' from pvdm_upgrade where substr(version_id,1,3) = '3.2'
	and not exists (select * from portion_type where portion_type_id = 2);
COMMIT;

update cust_tab set vantage_name = 'Email Inbound Communications' where db_ent_name = 'EMAIL_RES' and
vantage_name = 'Email Communications';
COMMIT;

drop table temp_search_area;
drop table temp_grp_ftr_type;
drop table temp_tree_det;

drop table temp_elem;
drop table temp_charac;
drop table temp_camp_out_det;
drop table temp_delivery_chan;
drop table temp_camp_out_result;	
drop table temp_out_seed_mapping;
drop table temp_eres_rule_hdr;
drop table temp_eres_rule_det;

/* correct historic entries in CAMP_MAP_SFDYN */

update camp_map_sfdyn x set vantage_alias = (select t.alt_join_src from cust_tab t, campaign c 
	where c.camp_id = x.camp_id and c.view_id = t.view_id and t.vantage_type = 2)
  where dyn_col_name = 'A2' and exists (select * from cust_tab t, campaign c 
	where c.camp_id = x.camp_id and c.view_id = t.view_id and t.vantage_type = 2 
	and t.alt_join_src is not null) and vantage_alias <> (select t.alt_join_src 
	from cust_tab t, campaign c where t.view_id = c.view_id and c.camp_id = x.camp_id 
	and t.vantage_type = 2);
commit;

/* update Prime@Vantage Application Role access to dropped and recreated objects */

GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_CHAN TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_DET TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON OUT_SEED_MAPPING TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ELEM TO &pv_app_role;	 
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_RESULT TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON SEARCH_AREA TO &pv_app_role;	
GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_DET TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON GRP_FTR_TYPE TO &pv_app_role;

/* update Prime@Vantage Application Role access to new / renamed objects */

GRANT SELECT, UPDATE, INSERT, DELETE ON CHARAC_GRP TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ATTACHMENT TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_SERVER TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_RESULT_PROC to &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON MESSAGE_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_GRP TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_HDR TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_DET TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON SMSC TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON SMSC_RES_RULE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON SMS_RES TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TREATMENT_TEST TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TEST_TEMPL_MAP TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TEST_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TON_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON NPI_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON PORTION_TYPE TO &pv_app_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON SEED_LIST_GRP TO &pv_app_role;

spool off;

exit;
