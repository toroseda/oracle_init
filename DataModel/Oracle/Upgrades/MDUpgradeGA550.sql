prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
accept main_view prompt 'Enter the VIEW_ID of Primary Customer Data View > '
prompt
accept v3role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt
accept ts_pv_sys prompt 'Enter the tablespace name for Marketing Director System Tables > '
prompt
accept ts_pv_ind prompt 'Enter the name of tablespace for Marketing Director System Indexes > '
prompt
accept ts_pv_comm prompt 'Enter the name of tablespace for Marketing Director Communication Tables > '
prompt
accept ts_pv_cind prompt 'Enter the name of tablespace for Marketing Director Communication Indexes > '
prompt

spool MDUpgradeGA550.log
set SERVEROUT ON SIZE 20000



DECLARE
 
var_count  NUMBER(4):= 0;

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
	select 1 into var_count from pvdm_upgrade where version_id in ('5.0.1.617.2', '5.1.0.675');

	dbms_output.put_line( 'V5 Data Model Schema Upgrade to Build Level to V5.2.0.684');
	dbms_output.put_line( '-----------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '    - addition of entities for definition of Subscription Campaigns');
	dbms_output.put_line( '      for Channel Marketing');
	dbms_output.put_line( '	   - addition of flags to Dataview header for Channel Marketing');
	dbms_output.put_line( '>');

	execute_sql ('ALTER TABLE CAMPAIGN ADD (SUBS_CAMP_FLG NUMBER(1) DEFAULT 0 NOT NULL)');

	execute_sql ('ALTER TABLE CAMPAIGN MODIFY SUBS_CAMP_FLG DEFAULT NULL');


	execute_sql ('CREATE TABLE SUBS_CAMPAIGN (CAMP_ID NUMBER(8) NOT NULL, ORG_TYPE_ID NUMBER(4) NOT NULL, 
           INSTRUCTION VARCHAR2(300) NULL, ALL_ORG_FLG NUMBER(1) NOT NULL, DEFAULT_SUBS_FLG NUMBER(1) NOT NULL, 
           ALLOW_UNSUBS_FLG NUMBER(1) NOT NULL, INPUT_DAYS NUMBER(2) NOT NULL, REVIEW_DAYS NUMBER(2) NOT NULL, 
           AUTO_EXECUTE_FLG NUMBER(1) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMPAIGN ON SUBS_CAMPAIGN (CAMP_ID ASC)
           TABLESPACE &ts_pv_ind');

        execute_sql ('ALTER TABLE SUBS_CAMPAIGN ADD (PRIMARY KEY (CAMP_ID) 
           USING INDEX TABLESPACE &ts_pv_ind )');


	execute_sql ('CREATE TABLE SUBS_CAMP_CYC (CAMP_ID NUMBER(8) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL,
           DYN_TAB_NAME VARCHAR2(18) NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC ON SUBS_CAMP_CYC (CAMP_ID ASC, CAMP_CYC ASC) 
           TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_CYC ADD (PRIMARY KEY (CAMP_ID, CAMP_CYC) 
           USING INDEX TABLESPACE &ts_pv_ind )');

	execute_sql ('CREATE TABLE SUBS_CAMP_CYC_ORG (CAMP_ID NUMBER(8) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL,
          ORG_ID VARCHAR2(50) NOT NULL, SUBS_FLG NUMBER(1) NOT NULL, EDIT_COMPLETED_FLG NUMBER(1) NOT NULL) 
          TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
           ( CAMP_ID ASC, CAMP_CYC ASC, ORG_ID ASC ) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG ADD ( PRIMARY KEY (CAMP_ID, CAMP_CYC, ORG_ID)
           USING INDEX TABLESPACE &ts_pv_ind )');


	execute_sql ('CREATE TABLE SUBS_CAMP_ORG_DET (CAMP_ID NUMBER(8) NOT NULL,
           CAMP_CYC NUMBER(8) NOT NULL, ORG_ID VARCHAR2(50) NOT NULL, DET_ID NUMBER(4) NOT NULL,
           INITIAL_QTY NUMBER(10) NOT NULL, LOCAL_INC_QTY NUMBER(10) NOT NULL,
           LOCAL_EXC_QTY NUMBER(10) NOT NULL ) TABLESPACE &ts_pv_sys');

        execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_ORG_DET ON SUBS_CAMP_ORG_DET 
           (CAMP_ID ASC, CAMP_CYC ASC, ORG_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET ADD (PRIMARY KEY (CAMP_ID, CAMP_CYC, ORG_ID, DET_ID) 
           USING INDEX TABLESPACE &ts_pv_ind )');

	--

	execute_sql ('CREATE INDEX XIE3CAMPAIGN ON CAMPAIGN (CAMP_NAME ASC) TABLESPACE &ts_pv_ind');
	
	execute_sql ('CREATE INDEX XIE1SUBS_CAMPAIGN ON SUBS_CAMPAIGN(ORG_TYPE_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (ORG_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE2SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (SUBS_FLG ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE3SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (EDIT_COMPLETED_FLG ASC) TABLESPACE &ts_pv_ind');
	
	execute_sql ('CREATE INDEX XIE1SPI_CAMP_PROC ON SPI_CAMP_PROC (CAMP_ID ASC, CAMP_CYC ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE2SPI_CAMP_PROC ON SPI_CAMP_PROC (CAMP_PROC_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE3SPI_CAMP_PROC ON SPI_CAMP_PROC (STATUS_SETTING_ID ASC) TABLESPACE &ts_pv_ind');

	--

	execute_sql ('ALTER TABLE DATAVIEW_TEMPL_HDR ADD (CM_FLG NUMBER(1) DEFAULT 0 NOT NULL, DEFAULT_CM_FLG NUMBER(1) DEFAULT 0 NOT NULL)');
	execute_sql ('ALTER TABLE DATAVIEW_TEMPL_HDR MODIFY (CM_FLG DEFAULT NULL, DEFAULT_CM_FLG DEFAULT NULL)');

	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMPAIGN TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_CYC TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_CYC_ORG TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_ORG_DET TO &v3role');

	insert into vantage_ent values ('SUBS_CAMPAIGN',1,0);
	insert into vantage_ent values ('SUBS_CAMP_CYC',1,0);
	insert into vantage_ent values ('SUBS_CAMP_CYC_ORG',1,0);
	insert into vantage_ent values ('SUBS_CAMP_ORG_DET',1,0);
	COMMIT;
	
        insert into status_setting values (17, 'X', 'Published', NULL, 'This Subscription Campaign has been published to Local Marketer Organisations - this replaces Scheduled status for all Subscription Campaigns');
	COMMIT;

	insert into proc_control select 'Publish Campaign', null, 1, 'v_pubcampproc', location, 18
		from proc_control where proc_name = 'Segment Processor';
	COMMIT;

	insert into proc_param values ('Publish Campaign',0,'Server executable name','v_pubcampproc');
	insert into proc_param values ('Publish Campaign',1,'Call Type',null );
	insert into proc_param values ('Publish Campaign',2,'RPC Id / SPI Audit Id',null );
	insert into proc_param values ('Publish Campaign',3,'Process Audit Id',null );
	insert into proc_param values ('Publish Campaign',4,'Secure Database Account Name',null );
	insert into proc_param values ('Publish Campaign',5,'Secure Database Password',null );
	insert into proc_param values ('Publish Campaign',6,'Customer Data View Id',null );
	insert into proc_param values ('Publish Campaign',7,'User Id',null );
	insert into proc_param values ('Publish Campaign',8,'Database Vendor Id',null );
	insert into proc_param values ('Publish Campaign',9,'Database Connection String',null );
	insert into proc_param values ('Publish Campaign',10,'Language Id',null );
	insert into proc_param values ('Publish Campaign',11,'Campaign Id',null );
	insert into proc_param values ('Publish Campaign',12,'Campaign Cycle Number',null );
	insert into proc_param values ('Publish Campaign',13,'Segment Id',null );
	insert into proc_param values ('Publish Campaign',14,'Segment Type Id',null );
	insert into proc_param values ('Publish Campaign',15,'Dynamic CS Table Name',null );
	insert into proc_param values ('Publish Campaign',16,'Campaign Process Sequence', null);
	insert into proc_param values ('Publish Campaign',17,'Tree Sequence Number', null);
	COMMIT;

        update PVDM_UPGRADE set VERSION_ID = '5.2.0.684';
        COMMIT;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> Marketing Director Schema has been upgraded to V5.2.0 Build Level 684');
        dbms_output.put_line( '>' );
        dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('> The upgrade to Build Level 5.2.0.684 is not applicable.');
		dbms_output.put_line('>');
		dbms_output.put_line('>');

END;
/


DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;

var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_pv_owner varchar2(128);

var_main_view varchar2(30);
var_dtype varchar2(30);
var_dlen number;
var_dprec number;
var_dscale number;
var_coltype varchar2(40);


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

var_main_view := '&main_view';

select 1 into var_count from pvdm_upgrade where version_id = '5.2.0.684';

	dbms_output.put_line( 'Processing Schema Upgrade from V5.2.0 (Build 684) to V5.5.0 (Build 760)');
	dbms_output.put_line( '-------------------------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '   Changes for Campaign Versioning:-');
	dbms_output.put_line( '      - Table CAMPAIGN restructured into CAMPAIGN and CAMP_VERSION');
	dbms_output.put_line( '      - VERSION_ID column added into Primary Key of following tables:');
	dbms_output.put_line( '        SUBS_CAMPAIGN, SUBS_CAMP_CYC, SUBS_CAMP_CYC_ORG, SUBS_CAMP_ORG_DET,' ); 
	dbms_output.put_line( '        CAMP_DET, TREAT_FIXED_COST, CAMP_SEG, CAMP_TREAT_DET, CAMP_RES_MODEL,' );
	dbms_output.put_line( '        CAMP_RES_DET, ELEM_WEB_MAP, CAMP_PLACEMENT, CAMP_DDROP, CAMP_POST,' );
	dbms_output.put_line( '	       CAMP_PUB, CAMP_RADIO, CAMP_DRTV, CAMP_LEAF, CAMP_STATUS_HIST,' );
	dbms_output.put_line( '        CAMP_COMM_OUT_HDR, CAMP_COMM_IN_HDR' ); 
     	dbms_output.put_line( '      - Add VERSION_ID column to table CAMP_CYC_STATUS, but not part of the Primary key');
	dbms_output.put_line( '      - Triggers on Campaign table changed, new triggers on CAMP_VERSION');
	dbms_output.put_line( '      - Further amendments to triggers as a result of changes to Primary key' );
	dbms_output.put_line( '	       on following tables:  CAMP_DET, TREAT_FIXED_COST, CAMP_DDROP, CAMP_POST' ); 
 	dbms_output.put_line( '        CAMP_PUB, CAMP_RADIO, CAMP_DRTV, CAMP_LEAF' );
	dbms_output.put_line( '   Changes for Non-contact Communications:' );
	dbms_output.put_line( '	     - new table COMM_NON_CONTACT, and lookup table UPDATE_STATUS');
	dbms_output.put_line( '	     - mapping for COMM_NON_CONTACT table added to CUST_TAB for Primary CDV');
	dbms_output.put_line( '	  Changes for Send Enhanced Messages module:');
	dbms_output.put_line( '	     - new entries in CHAN_TYPE lookup table');
	dbms_output.put_line( '	     - new entries in CONTENT_FORMT lookup table');
	dbms_output.put_line( '      - new entries in MESSAGE_TYPE lookup table');
	dbms_output.put_line( '      - new lookup table WIRELESS_PROTOCOL populated with new entries');
	dbms_output.put_line( '      - table SMSC restructured and renamed to WIRELESS_SERVER to store');
        dbms_output.put_line( '        SMSC and MMSC information - see dictionary for details');
	dbms_output.put_line( '      - table SMS_RES_RULE renamed to WIRELESS_RES_RULE');
	dbms_output.put_line( '      - table SMS_RES renamed to WIRELESS_RES');
	dbms_output.put_line( '	     - object names in OBJ_TYPE table amended for object type id 78,79');
	dbms_output.put_line( '	     - Triggers on WIRELESS_RES_RULE and DELIVERY_SERVER tables re-defined');
     	dbms_output.put_line( '	       to incorporate the structural changes.');
	dbms_output.put_line( '>');


	-- DROP Triggers on CAMPAIGN:
	execute_sql ('drop trigger TD_CAMPAIGN');
	execute_sql ('drop trigger TI_CAMPAIGN');
	execute_sql ('drop trigger TU_CAMPAIGN_BMAN');
	execute_sql ('drop trigger TU_CAMPAIGN_CMAN');
	execute_sql ('drop trigger TU_CAMPAIGN_GRP');
	execute_sql ('drop trigger TU_CAMPAIGN_TYPE');
	execute_sql ('drop trigger TU_CAMPAIGN_WEBSEG');

	-- DROP Triggers on CAMP_DET:
	execute_sql ('drop trigger TD_CAMP_DET');
	execute_sql ('drop trigger TI_CAMP_DET');
	execute_sql ('drop trigger TU_CAMP_DET');

	-- DROP Triggers on TREAT_FIXED_COST:
	execute_sql ('drop trigger TD_TREAT_FIXED_COST');
	execute_sql ('drop trigger TI_TREAT_FIXED_COST');
	execute_sql ('drop trigger TU_TREAT_FIXED_COST_AREA');
	execute_sql ('drop trigger TU_TREAT_FIXED_COST_FC');
	execute_sql ('drop trigger TU_TREAT_FIXED_COST_SUP');

	-- DROP Triggers on CAMP_DDROP:
	execute_sql ('drop trigger TD_CAMP_DDROP');
	execute_sql ('drop trigger TI_CAMP_DDROP');
	execute_sql ('drop trigger TU_CAMP_DDROP_CARR');
	execute_sql ('drop trigger TU_CAMP_DDROP_REG');

	-- DROP Triggers on CAMP_POST:
	execute_sql ('drop trigger TD_CAMP_POST');
	execute_sql ('drop trigger TI_CAMP_POST');
	execute_sql ('drop trigger TU_CAMP_POST_CO');
	execute_sql ('drop trigger TU_CAMP_POST_PS');
	execute_sql ('drop trigger TU_CAMP_POST_PT');

	-- DROP Triggers on CAMP_PUB:
	execute_sql ('drop trigger TD_CAMP_PUB');
	execute_sql ('drop trigger TI_CAMP_PUB');
	execute_sql ('drop trigger TU_CAMP_PUB');

	-- DROP Triggers on CAMP_RADIO:
	execute_sql ('drop trigger TD_CAMP_RADIO');
	execute_sql ('drop trigger TI_CAMP_RADIO');
	execute_sql ('drop trigger TU_CAMP_RADIO_RA');
	execute_sql ('drop trigger TU_CAMP_RADIO_RR');

	-- DROP Triggers on CAMP_DRTV:
	execute_sql ('drop trigger TD_CAMP_DRTV');
	execute_sql ('drop trigger TI_CAMP_DRTV');
	execute_sql ('drop trigger TU_CAMP_DRTV_REG');
	execute_sql ('drop trigger TU_CAMP_DRTV_ST');

	-- DROP Triggers on CAMP_LEAF:
	execute_sql ('drop trigger TD_CAMP_LEAF');
	execute_sql ('drop trigger TI_CAMP_LEAF');
	execute_sql ('drop trigger TU_CAMP_LEAF_CP');
	execute_sql ('drop trigger TU_CAMP_LEAF_DP');
	execute_sql ('drop trigger TU_CAMP_LEAF_LD');
	execute_sql ('drop trigger TU_CAMP_LEAF_LR');

	-- DROP Triggers for Send Enhanced Messages enhancements:
	
	-- DROP Triggers on SMS_RES_RULE:
	execute_sql ('drop trigger TD_SMSC_RES_RULE');
	execute_sql ('drop trigger TI_SMSC_RES_RULE');
	execute_sql ('drop trigger TU_SMSC_RES_RULE');
	
	-- DROP Triggers on DELIVERY_SERVER:
	execute_sql ('drop trigger TD_DELIVERY_SERVER');
	execute_sql ('drop trigger TI_DELIVERY_SERVER');
	execute_sql ('drop trigger TU_DELIVERY_SERVER');
	
	-- Re-structure CAMPAIGN table into CAMPAIGN and CAMP_VERSION:

	execute_sql ('CREATE TABLE TEMP_CAMPAIGN AS SELECT * FROM CAMPAIGN');

	execute_sql ('DROP TABLE CAMPAIGN');

	execute_sql ('CREATE TABLE CAMPAIGN (CAMP_ID NUMBER(8) NOT NULL, CAMP_NAME VARCHAR2(50) NOT NULL, CAMP_DESC VARCHAR2(300),
        	CAMP_OBJECTIVE VARCHAR2(300), CAMP_TEMPL_ID NUMBER(2) NOT NULL, CAMP_TYPE_ID NUMBER(4),
        	CAMP_GRP_ID NUMBER(4) NOT NULL, CAMP_CODE VARCHAR2(10), START_DATE DATE, START_TIME CHAR(8), EST_END_DATE DATE,
        	VIEW_ID VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, CREATED_BY VARCHAR2(30) NOT NULL, UPDATED_DATE DATE,
        	UPDATED_BY VARCHAR2(30), SUBS_CAMP_FLG NUMBER(1) NOT NULL, CURRENT_VERSION_ID NUMBER(3) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKCAMPAIGN ON CAMPAIGN (CAMP_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('CREATE INDEX XIE1CAMPAIGN ON CAMPAIGN (CAMP_TYPE_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('CREATE INDEX XIE2CAMPAIGN ON CAMPAIGN (CAMP_ID ASC, CURRENT_VERSION_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('CREATE INDEX XIE3CAMPAIGN ON CAMPAIGN (CAMP_NAME ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE CAMPAIGN ADD PRIMARY KEY (CAMP_ID) USING INDEX TABLESPACE &ts_pv_ind' );

	execute_sql ('CREATE TABLE CAMP_VERSION (CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL, VERSION_NAME VARCHAR2(50),
        	MANAGER_ID NUMBER(4), BUDGET_MANAGER_ID NUMBER(4), MAILING_DELAY_DAYS NUMBER(3), RESTRICT_TYPE_ID NUMBER(1) NOT NULL,
        	WEB_FILTER_TYPE_ID NUMBER(2), WEB_FILTER_ID NUMBER(8), PROC_FLG NUMBER(1) NOT NULL, CREATED_DATE DATE NOT NULL, 
        	CREATED_BY VARCHAR2(30) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_VERSION ON CAMP_VERSION (CAMP_ID ASC, VERSION_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE CAMP_VERSION ADD PRIMARY KEY (CAMP_ID, VERSION_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter PK in respective tables -
	-- Alter table SUBS_CAMPAIGN, modify Primary Key Index:

	execute_sql ('ALTER TABLE SUBS_CAMPAIGN DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE SUBS_CAMPAIGN ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE SUBS_CAMPAIGN MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMPAIGN ON SUBS_CAMPAIGN (CAMP_ID ASC, VERSION_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE SUBS_CAMPAIGN ADD PRIMARY KEY (CAMP_ID, VERSION_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table SUBS_CAMP_CYC, modify Primary Key Index:

	execute_sql ('ALTER TABLE SUBS_CAMP_CYC DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC ON SUBS_CAMP_CYC (CAMP_ID ASC, VERSION_ID ASC, CAMP_CYC ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC ADD PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table SUBS_CAMP_CYC_ORG, modify Primary Key Index:
	
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (CAMP_ID ASC, VERSION_ID ASC, CAMP_CYC ASC, ORG_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG ADD PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC, ORG_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table SUBS_CAMP_ORG_DET, modify Primary Key Index:

	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_ORG_DET ON SUBS_CAMP_ORG_DET (CAMP_ID ASC, VERSION_ID ASC, CAMP_CYC ASC, ORG_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET ADD PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC, ORG_ID, DET_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_DET, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_DET DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_DET ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_DET MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_DET ON CAMP_DET (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_DET ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table TREAT_FIXED_COST, modify Primary Key Index:

	execute_sql ('ALTER TABLE TREAT_FIXED_COST DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE TREAT_FIXED_COST ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE TREAT_FIXED_COST MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKTREAT_FIXED_COST ON TREAT_FIXED_COST (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, TREAT_COST_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE TREAT_FIXED_COST ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, TREAT_COST_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_SEG, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_SEG DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_SEG ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_SEG MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_SEG ON CAMP_SEG (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_SEG ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_TREAT_DET, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_TREAT_DET DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_TREAT_DET ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_TREAT_DET MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_TREAT_DET ON CAMP_TREAT_DET (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_TREAT_DET ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table ELEM_WEB_MAP, modify Primary Key Index:

	execute_sql ('ALTER TABLE ELEM_WEB_MAP DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE ELEM_WEB_MAP ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE ELEM_WEB_MAP MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKELEM_WEB_MAP ON ELEM_WEB_MAP (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, ELEM_ID ASC, PLACEHOLDER ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE ELEM_WEB_MAP ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, ELEM_ID, PLACEHOLDER) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_PLACEMENT, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_PLACEMENT DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_PLACEMENT ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_PLACEMENT MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_PLACEMENT ON CAMP_PLACEMENT (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_PLACEMENT ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_RES_MODEL, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_RES_MODEL DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_RES_MODEL ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_RES_MODEL MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_RES_MODEL ON CAMP_RES_MODEL (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_RES_MODEL ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_RES_DET, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_RES_DET DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_RES_DET ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_RES_DET MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_RES_DET ON CAMP_RES_DET (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, SEG_TYPE_ID ASC, SEG_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_RES_DET ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, SEG_TYPE_ID, SEG_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_MAP_SFDYN, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_MAP_SFDYN DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_MAP_SFDYN ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_MAP_SFDYN MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_MAP_SFDYN ON CAMP_MAP_SFDYN (CAMP_ID ASC, VERSION_ID ASC, DIRECTION_TYPE ASC, DYN_COL_NAME ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_MAP_SFDYN ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DIRECTION_TYPE, DYN_COL_NAME) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_COMM_OUT_HDR, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, CAMP_CYC ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, 
                    PAR_COMM_DET_ID ASC) TABLESPACE &ts_pv_cind');
	execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID) USING INDEX TABLESPACE &ts_pv_cind');
	
	-- Alter table CAMP_COMM_IN_HDR, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC ) TABLESPACE &ts_pv_cind');
	execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, PLACEMENT_SEQ, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID) USING INDEX TABLESPACE &ts_pv_cind');

	-- Alter table CAMP_STATUS_HIST, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_STATUS_HIST DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_STATUS_HIST ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_STATUS_HIST MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_STATUS_HIST ON CAMP_STATUS_HIST (CAMP_ID ASC, VERSION_ID ASC, CAMP_HIST_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_STATUS_HIST ADD PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_HIST_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_DROP, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_DDROP DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_DDROP ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_DDROP MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_DDROP ON CAMP_DDROP (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_DDROP ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_POST, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_POST DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_POST ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_POST MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_POST ON CAMP_POST (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_POST ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_PUB, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_PUB DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_PUB ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_PUB MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_PUB ON CAMP_PUB (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_PUB ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_RADIO, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_RADIO DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_RADIO ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_RADIO MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_RADIO ON CAMP_RADIO (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_RADIO ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_DRTV, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_DRTV DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_DRTV ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_DRTV MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_DRTV ON CAMP_DRTV (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_DRTV ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_LEAF, modify Primary Key Index:

	execute_sql ('ALTER TABLE CAMP_LEAF DROP PRIMARY KEY');
	execute_sql ('ALTER TABLE CAMP_LEAF ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_LEAF MODIFY (VERSION_ID DEFAULT NULL)');
	execute_sql ('CREATE UNIQUE INDEX XPKCAMP_LEAF ON CAMP_LEAF (CAMP_ID ASC, VERSION_ID ASC, DET_ID ASC, PLACEMENT_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE CAMP_LEAF ADD PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ) USING INDEX TABLESPACE &ts_pv_ind');

	-- Alter table CAMP_CYC_STATUS:

	execute_sql ('ALTER TABLE CAMP_CYC_STATUS ADD (VERSION_ID NUMBER(3) DEFAULT 1 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_CYC_STATUS MODIFY (VERSION_ID DEFAULT NULL)');


	-- Update existing references in REFERENCED_OBJ table:

	update referenced_obj set ref_sub_det_id = ref_det_id, ref_det_id = ref_sub_id, ref_sub_id = 1
		where ref_type_id = 24 and obj_type_id not in (33,37) and ref_indicator_id not in (5,6,21,26,27);

	update referenced_obj set ref_sub_det_id = ref_det_id, ref_det_id = ref_sub_id, ref_sub_id = 1
		where ref_type_id = 24 and ref_indicator_id = 5 and ref_det_id is not null;
	commit;

	insert into vantage_ent values ('CAMP_VERSION',1,0);
	insert into vantage_ent values ('COMM_NON_CONTACT',1,0);
	insert into vantage_ent values ('UPDATE_STATUS',1,1);

	delete from vantage_ent where ent_name in ('SMSC','SMSC_RES_RULE','SMS_RES');

	insert into vantage_ent values ('WIRELESS_PROTOCOL',1,1);
	insert into vantage_ent values ('WIRELESS_RES',1,0);
	insert into vantage_ent values ('WIRELESS_RES_RULE',1,0);
	insert into vantage_ent values ('WIRELESS_SERVER',1,0);

	commit;

	-- Create table UPDATE_STATUS for Communications Enhancement functionality

	execute_sql ('CREATE TABLE UPDATE_STATUS (UPDATE_STATUS_ID NUMBER(2) NOT NULL, UPDATE_STATUS_NAME VARCHAR2(50) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKUPDATE_STATUS ON UPDATE_STATUS (UPDATE_STATUS_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE UPDATE_STATUS ADD PRIMARY KEY (UPDATE_STATUS_ID) USING INDEX TABLESPACE &ts_pv_ind');


	-- Create table COMM_NON_CONTACT for Communications Enhancement functionality

	var_main_view := '&main_view';

	SELECT DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE INTO var_dtype, var_dlen, var_dprec, var_dscale 
	     FROM PV_COLS X WHERE EXISTS (SELECT * FROM CUST_TAB WHERE VIEW_ID = var_main_view AND 
	     VANTAGE_TYPE = 1 AND DB_ENT_OWNER = X.TABLE_OWNER AND DB_ENT_NAME = X.TABLE_NAME AND 
             STD_JOIN_FROM_COL = X.COLUMN_NAME);

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

	execute_sql ('CREATE TABLE COMM_NON_CONTACT (CAMP_ID NUMBER(8) NOT NULL, DET_ID NUMBER(4) NOT NULL, 
		CAMP_CYC NUMBER(8) NOT NULL, REMOVE_FLG NUMBER(1) NOT NULL, UPDATE_STATUS_ID NUMBER(2) NOT NULL, 
		UPDATED_DATE DATE, UPDATE_COST_FLG NUMBER(1) NOT NULL, SESSION_NUMBER NUMBER(8), 
		A1 ' || var_coltype || ' NOT NULL) TABLESPACE &ts_pv_comm');

	execute_sql ('CREATE INDEX XIE1COMM_NON_CONTACT ON COMM_NON_CONTACT (A1 ASC, CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC) 
		TABLESPACE &ts_pv_cind');

	-- Update Communication table mapping with details for COMM_NON_CONTACT table

	update CUST_TAB set tab_display_seq = tab_display_seq +1 where tab_display_seq > 99992 and
		tab_display_seq < 100100;
	commit;

	insert into cust_tab select view_id, 'COMM_NON_CONTACT', 'Campaign Outbound Non-Contact Details', 99, 99993, 
   	NULL, NULL, 'COMM_NON_CONTACT', db_ent_owner, NULL, NULL, 1, 'A1', std_join_to_col, par_vantage_alias, 
   	'order by column_name', 1 from CUST_TAB where db_ent_name = 'CAMP_COMM_OUT_DET' and view_id = var_main_view;
	commit;  

	-- ****************************************************
	-- Data model changes for Send Enhanced messages module:

	-- Create new lookup table WIRELESS_PROTOCOL for Send Enhanced Messages module.

	execute_sql ('CREATE TABLE WIRELESS_PROTOCOL (PROTOCOL_ID NUMBER(2) NOT NULL, PROTOCOL_NAME VARCHAR2(50) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKWIRELESS_PROTOCOL ON WIRELESS_PROTOCOL (PROTOCOL_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE WIRELESS_PROTOCOL ADD PRIMARY KEY (PROTOCOL_ID) USING INDEX TABLESPACE &ts_pv_ind' );

	-- Rename table SMS_RES to WIRELESS_RES for Send Enhanced Messages module.

	execute_sql ('RENAME SMS_RES to WIRELESS_RES');
	execute_sql ('drop index xie1sms_res');
	execute_sql ('drop index xie2sms_res');
	execute_sql ('drop index xie3sms_res');
	execute_sql ('drop index xie4sms_res');

	execute_sql ('CREATE INDEX XIE1WIRELESS_RES ON WIRELESS_RES (KEYCODE ASC) TABLESPACE &ts_pv_cind');

	execute_sql ('CREATE INDEX XIE2WIRELESS_RES ON WIRELESS_RES (TELEPHONE_NUMBER ASC) TABLESPACE &ts_pv_cind');

	execute_sql ('CREATE INDEX XIE3WIRELESS_RES ON WIRELESS_RES (A1 ASC) TABLESPACE &ts_pv_cind');

	execute_sql ('CREATE INDEX XIE4WIRELESS_RES ON WIRELESS_RES (CAMP_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_cind');

	-- Save and drop SMSC_RES_RULE to create table WIRELESS_RES_RULE replacing it, for Send Enhanced Messages module.

	execute_sql ('CREATE TABLE TEMP_SMSC_RES_RULE AS SELECT * FROM SMSC_RES_RULE');
	execute_sql ('drop table SMSC_RES_RULE');

	execute_sql ('CREATE TABLE WIRELESS_RES_RULE (SERVER_ID NUMBER(4) NOT NULL, RULE_ID NUMBER(4) NOT NULL, 
    		RULE_SEQ NUMBER(2), INSERT_VAL VARCHAR2(40), VANTAGE_ALIAS VARCHAR2(128), COL_NAME VARCHAR2(128)) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKWIRELESS_RES_RULE ON WIRELESS_RES_RULE (SERVER_ID ASC, RULE_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE WIRELESS_RES_RULE ADD PRIMARY KEY (SERVER_ID, RULE_ID) USING INDEX TABLESPACE &ts_pv_ind');

	-- Save and drop SMSC table to create WIRELESS_SERVER replacing it, for Send Enhanced Messages module.

	execute_sql ('CREATE TABLE TEMP_SMSC AS SELECT * FROM SMSC');
	execute_sql ('drop table SMSC');

	execute_sql ('CREATE TABLE WIRELESS_SERVER (SERVER_ID NUMBER(4) NOT NULL, SERVER_NAME VARCHAR2(50) NOT NULL,
    		SERVER_DESC VARCHAR2(300), HOSTNAME VARCHAR2(255), IP_ADDRESS VARCHAR2(15), PROTOCOL_ID NUMBER(2) NOT NULL,
    		DEFAULT_SERVER_FLG NUMBER(1) NOT NULL, OUTB_SERVER_FLG NUMBER(1) NOT NULL, INB_SERVER_FLG NUMBER(1) NOT NULL,
    		PORT NUMBER(8), TIMEOUT NUMBER(8), CONNECT_RETRY NUMBER(2), CONNECT_WAIT NUMBER(4), READ_FLG NUMBER(1) NOT NULL,
    		REPLY_FLG NUMBER(1) NOT NULL, TEST_SEND_FLG NUMBER(1) NOT NULL, TEST_SEND_TO VARCHAR2(50), CREATED_BY VARCHAR2(30) NOT NULL,
    		CREATED_DATE DATE NOT NULL, UPDATED_BY VARCHAR2(30), UPDATED_DATE DATE, TON NUMBER(1), NPI NUMBER(1), SYSTEM_ID VARCHAR2(15),
    		SYSTEM_TYPE VARCHAR2(12), PASSWORD VARCHAR2(8), MAX_CONNECTIONS NUMBER(2) NOT NULL, TEST_SEND_FROM VARCHAR2(50)) 
    		TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKWIRELESS_SERVER ON WIRELESS_SERVER (SERVER_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE WIRELESS_SERVER ADD PRIMARY KEY (SERVER_ID) USING INDEX TABLESPACE &ts_pv_ind' );

	-- Update CHAN_TYPE lookup table with values for Send Enhanced Messages Module

	insert into chan_type values (50, 'MMSC', 1, 1);
	commit;

	-- Update some object types for Send Enhanced Messages
	update obj_type set obj_name = 'Wireless Response Rule' where obj_type_id = 78;
	update obj_type set obj_name = 'Wireless Server' where obj_type_id = 79;
	commit;

	-- Update CONTENT_FORMT lookup table with values for Send Enhanced Messages Module

	insert into content_formt values (15, 'SMS');
	insert into content_formt values (16, 'EMS');
	insert into content_formt values (17, 'Smart Message');
	commit;

	-- Update MESSAGE_TYPE lookup table with values for Send Enhanced Messages Module

	insert into message_type values (3, 'Operator Logo');
	insert into message_type values (4, 'Calling Line Identifier Icon');
	insert into message_type values (5, 'Ring Tone');
	insert into message_type values (6, 'Picture Message');
	commit;

	execute_sql ('CREATE SEQUENCE LOAD_DATA_SEQ START WITH 1 INCREMENT BY 1 NOMINVALUE NOCYCLE NOCACHE');

	update PVDM_UPGRADE set VERSION_ID = '5.5.0.760-';
	COMMIT;

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Build 648 to Build 760 Upgrade is not applicable.');
		dbms_output.put_line('>');
		dbms_output.put_line('>');

	WHEN OTHERS THEN

		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (1) error occurred.' );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;

END;
/


DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;


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
	select 1 into var_count from pvdm_upgrade where version_id = '5.5.0.760-';

	-- Populate new lookup table UPDATE_STATUS for Send Enhanced Messages module.

	insert into update_status values (0, 'Not yet processed');
	insert into update_status values (1, 'Processing');
	insert into update_status values (2, 'Processed successfully');
	insert into update_status values (3, 'Processing failed');
	insert into update_status values (9, 'Data error');
	COMMIT;

	-- Populate new lookup table WIRELESS_PROTOCOL for Send Enhanced Messages module.

	insert into wireless_protocol values (1, 'SMPP', 40);
	insert into wireless_protocol values (2, 'CIMD', 40);
	insert into wireless_protocol values (3, 'EAIF', 50);
	COMMIT;

	-- Add entries to accommodate addition of VERSION_ID to Campaign Reports
	insert into camp_rep_col values ( 60, 'Version ID', 1, 1000, 2, 'VERSION_ID', 1, 1, 60 );
	insert into camp_rep_col values ( 61, 'Version Name', 1, 3000, 1, 'VERSION_NAME', 1, 1, 61 );
	COMMIT;

	-- populate new CAMPAIGN and CAMP_VERSION tables with data saved in TEMP_CAMPAIGN table.

	insert into CAMPAIGN (CAMP_ID, CAMP_NAME, CAMP_DESC, CAMP_OBJECTIVE, CAMP_TEMPL_ID, CAMP_TYPE_ID, CAMP_GRP_ID,
		CAMP_CODE, START_DATE, START_TIME, EST_END_DATE, VIEW_ID, CREATED_DATE, CREATED_BY, UPDATED_DATE, 
		UPDATED_BY, SUBS_CAMP_FLG, CURRENT_VERSION_ID)
	   select CAMP_ID, CAMP_NAME, CAMP_DESC, CAMP_OBJECTIVE, CAMP_TEMPL_ID, CAMP_TYPE_ID, CAMP_GRP_ID,
		CAMP_CODE, START_DATE, START_TIME, EST_END_DATE, VIEW_ID, CREATED_DATE, CREATED_BY, UPDATED_DATE, 
		UPDATED_BY, SUBS_CAMP_FLG, 1  from TEMP_CAMPAIGN;
	commit;

	insert into CAMP_VERSION (CAMP_ID, VERSION_ID, VERSION_NAME, MANAGER_ID, BUDGET_MANAGER_ID, MAILING_DELAY_DAYS,
 		RESTRICT_TYPE_ID, WEB_FILTER_TYPE_ID, WEB_FILTER_ID, PROC_FLG, CREATED_DATE, CREATED_BY)
	   select CAMP_ID, 1, null, MANAGER_ID, BUDGET_MANAGER_ID, MAILING_DELAY_DAYS,  
		RESTRICT_TYPE_ID, WEB_FILTER_TYPE_ID, WEB_FILTER_ID, PROC_FLG, CREATED_DATE, CREATED_BY 
		from TEMP_CAMPAIGN;
	commit;

	execute_sql ('drop table TEMP_CAMPAIGN');

	-- populate new WIRELESS_SERVER table with data saved in TEMP_SMSC table.

	insert into WIRELESS_SERVER (SERVER_ID, SERVER_NAME, SERVER_DESC, HOSTNAME, IP_ADDRESS, PROTOCOL_ID,
    		DEFAULT_SERVER_FLG, OUTB_SERVER_FLG, INB_SERVER_FLG, PORT, TIMEOUT, CONNECT_RETRY, CONNECT_WAIT, READ_FLG,
    		REPLY_FLG, TEST_SEND_FLG, TEST_SEND_TO, CREATED_BY, CREATED_DATE, UPDATED_BY, UPDATED_DATE, TON, NPI, 
    		SYSTEM_ID, SYSTEM_TYPE, PASSWORD, MAX_CONNECTIONS, TEST_SEND_FROM) 
  	  select SMSC_ID, SMSC_NAME, SMSC_DESC, null, IP_ADDRESS, 1, DEFAULT_SMSC_FLG, OUTB_SMSC_FLG, INB_SMSC_FLG,
    		PORT, TIMEOUT, CONNECT_RETRY, CONNECT_WAIT, READ_FLG, REPLY_FLG, TEST_SEND_FLG, TEST_SEND_TO, CREATED_BY,
    		CREATED_DATE, UPDATED_BY, UPDATED_DATE, TON, NPI, SYSTEM_ID, SYSTEM_TYPE, PASSWORD, MAX_CONNECTIONS, 
    		TEST_SEND_FROM from TEMP_SMSC;
	commit;

	execute_sql ('drop table temp_smsc');

	-- populate new WIRELESS_RES_RULE table with data saved in TEMP_SMSC_RES_RULE table.

	insert into WIRELESS_RES_RULE (SERVER_ID, RULE_ID, RULE_SEQ, INSERT_VAL, VANTAGE_ALIAS, COL_NAME)
   		select SMSC_ID, RULE_ID, RULE_SEQ, INSERT_VAL, VANTAGE_ALIAS, COL_NAME from TEMP_SMSC_RES_RULE;
	commit;

	execute_sql ('drop table temp_smsc_res_rule');

	-- amend indexes and re-create communication views to incorporate VERSION_ID

	execute_sql ('drop index xie1camp_det');
	execute_sql ('create index xie1camp_det on camp_det (camp_id asc, version_id asc, par_det_id asc) TABLESPACE &ts_pv_ind' );

	execute_sql ('drop index xie1camp_status_hist');
	execute_sql ('create index xie1camp_status_hist on camp_status_hist (status_setting_id asc, version_id asc) TABLESPACE &ts_pv_ind' ); 

	execute_sql ('create index xie1camp_comm_in_hdr on camp_comm_in_hdr (camp_id asc, version_id asc, par_det_id asc) tablespace &ts_pv_ind');

	execute_sql ('create index xie1camp_comm_out_hdr on camp_comm_out_hdr (camp_id asc, version_id asc, par_det_id asc) tablespace &ts_pv_ind');

	execute_sql ('create or replace view treat_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, 
        camp_type_id, camp_type_name, current_version_id, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id,
        camp_cyc, comm_status_id, sent_date, keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id,
        chan_type_name, email_type_id, email_subject, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id,
        version_id, version_name, manager_id, budget_manager_id)
        as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, 
        camp_comm_out_det.comm_status_id, camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id, treatment.treatment_name,
        treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id,
        treatment.email_subject, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
        camp_comm_in_hdr.run_date, camp_comm_in_det.det_id, camp_version.version_id, camp_version.version_name, camp_version.manager_id,
        camp_version.budget_manager_id 
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET, CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_DET_1.CAMP_ID AND 
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_DET_1.DET_ID AND CAMP_COMM_OUT_HDR.VERSION_ID = CAMP_DET_1.VERSION_ID AND 
        CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND CAMP_DET_2.VERSION_ID = CAMP_DET_1.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID  AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND 
        CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND
        CAMP_COMM_OUT_HDR.PAR_COMM_DET_ID = CAMP_COMM_OUT_DET.PAR_COMM_DET_ID AND
        CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND
        CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND 
        CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND 
        CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
        CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND
        CAMP_COMM_IN_HDR.PAR_COMM_DET_ID (+) = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND 
        CAMP_VERSION.CAMP_ID = CAMP_COMM_OUT_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_OUT_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,	
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND 
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND 
        CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
        CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name,
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id
        from CAMPAIGN CAMPAIGN,	CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND
        CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID AND CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND CAMP_DET_IN_4.VERSION_ID = CAMP_DET_IN_3.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
	RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
	CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
	CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID');

	execute_sql('create or replace view charac_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, 
        camp_type_id, camp_type_name, current_version_id, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id,
        camp_cyc, comm_status_id, sent_date, keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id,
        chan_type_name, email_type_id, email_subject, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id,
        version_id, version_name, manager_id, budget_manager_id, charac_id, charac_grp_id, charac_name)
        as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, 
        camp_comm_out_det.comm_status_id, camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id, treatment.treatment_name,
        treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id,
        treatment.email_subject, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
        camp_comm_in_hdr.run_date, camp_comm_in_det.det_id, camp_version.version_id, camp_version.version_name, camp_version.manager_id,
        camp_version.budget_manager_id, charac.charac_id, charac.charac_grp_id, charac.charac_name 
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET, CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_DET_1.CAMP_ID AND 
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_DET_1.DET_ID AND CAMP_COMM_OUT_HDR.VERSION_ID = CAMP_DET_1.VERSION_ID AND 
        CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND CAMP_DET_2.VERSION_ID = CAMP_DET_1.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID  AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID (+) AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND 
        CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND
        CAMP_COMM_OUT_HDR.PAR_COMM_DET_ID = CAMP_COMM_OUT_DET.PAR_COMM_DET_ID AND
        CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND
        CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND 
        CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND 
        CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
        CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND
        CAMP_COMM_IN_HDR.PAR_COMM_DET_ID (+) = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND 
        CAMP_VERSION.CAMP_ID = CAMP_COMM_OUT_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_OUT_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id,
        charac.charac_id, charac.charac_grp_id, charac.charac_name
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,	
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND 
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND 
        CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID (+) AND
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
        CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name,
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id,
        charac.charac_id, charac.charac_grp_id, charac.charac_name
        from CAMPAIGN CAMPAIGN,	CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND
        CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID AND CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND CAMP_DET_IN_4.VERSION_ID = CAMP_DET_IN_3.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
        TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID (+) AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
	RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
	CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
	CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID');

        execute_sql('create or replace view elem_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, 
        camp_type_id, camp_type_name, current_version_id, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id,
        camp_cyc, comm_status_id, sent_date, keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id,
        chan_type_name, email_type_id, email_subject, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id,
        version_id, version_name, manager_id, budget_manager_id, elem_id, elem_grp_id, elem_name, content, content_filename, content_formt_id, 
	content_length, message_type_id, var_cost, var_cost_qty)
        as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, 
        camp_comm_out_det.comm_status_id, camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id, treatment.treatment_name,
        treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id,
        treatment.email_subject, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
        camp_comm_in_hdr.run_date, camp_comm_in_det.det_id, camp_version.version_id, camp_version.version_name, camp_version.manager_id,
        camp_version.budget_manager_id, elem.elem_id, elem.elem_grp_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, 
	elem.content_length, elem.message_type_id, elem.var_cost, elem.var_cost_qty
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET, CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_DET_1.CAMP_ID AND 
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_DET_1.DET_ID AND CAMP_COMM_OUT_HDR.VERSION_ID = CAMP_DET_1.VERSION_ID AND 
        CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND CAMP_DET_2.VERSION_ID = CAMP_DET_1.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID  AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID (+) AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND
        CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND 
        CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND
        CAMP_COMM_OUT_HDR.PAR_COMM_DET_ID = CAMP_COMM_OUT_DET.PAR_COMM_DET_ID AND
        CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND
        CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND 
        CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND 
        CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
        CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND
        CAMP_COMM_IN_HDR.PAR_COMM_DET_ID (+) = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND 
        CAMP_VERSION.CAMP_ID = CAMP_COMM_OUT_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_OUT_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, 
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id,
        elem.elem_id, elem.elem_grp_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, 
	elem.content_length, elem.message_type_id, elem.var_cost, elem.var_cost_qty 
        from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,	
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION 
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND 
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND 
        CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
        TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID (+) AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
        RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
        CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
        CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID
        union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name,
        campaign.camp_type_id, camp_type.camp_type_name, campaign.current_version_id, campaign.start_date, campaign.start_time, campaign.est_end_date,
        campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
        TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
        treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
        res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id,
        camp_version.version_id, camp_version.version_name, camp_version.manager_id, camp_version.budget_manager_id,
        elem.elem_id, elem.elem_grp_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, 
	elem.content_length, elem.message_type_id, elem.var_cost, elem.var_cost_qty 
        from CAMPAIGN CAMPAIGN,	CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
        TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,
        CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL, CAMP_VERSION CAMP_VERSION
        where CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMP_VERSION.CAMP_ID = CSH.CAMP_ID AND CAMP_VERSION.VERSION_ID = CSH.VERSION_ID AND
        CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMP_VERSION.CAMP_ID AND VERSION_ID = CAMP_VERSION.VERSION_ID) AND 
        STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND 
        CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_HDR.DET_ID AND CAMP_DET_IN_1.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID AND 
        CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND CAMP_DET_IN_2.VERSION_ID = CAMP_DET_IN_1.VERSION_ID AND
        CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.VERSION_ID = CAMP_DET_IN_2.VERSION_ID AND
        CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID AND CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND CAMP_DET_IN_4.VERSION_ID = CAMP_DET_IN_3.VERSION_ID AND
        TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
        TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID (+) AND 
        CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
        CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
        CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
        CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND CAMP_COMM_IN_HDR.PAR_COMM_DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID AND
	RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
	RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID AND
	CAMPAIGN.CAMP_ID = CAMP_VERSION.CAMP_ID AND
	CAMP_VERSION.CAMP_ID = CAMP_COMM_IN_HDR.CAMP_ID AND CAMP_VERSION.VERSION_ID = CAMP_COMM_IN_HDR.VERSION_ID');

	execute_sql ('CREATE OR REPLACE VIEW CAMP_SEG_DET 
	(CAMP_ID, DET_ID, OBJ_TYPE_ID, OBJ_ID, OBJ_SUB_ID, PAR_DET_ID, NAME, VERSION_ID) 
	AS SELECT c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id
	from camp_det c, seg_hdr s where c.obj_type_id = 1 and c.obj_type_id   = s.seg_type_id and c.obj_id = s.seg_id    
	UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id,    c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id    
	from camp_det c, seg_hdr s  where c.obj_type_id = 21 and s.seg_type_id = 1 and c.obj_id = s.seg_id and c.obj_sub_id = 0    
	UNION    select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id,    
	t.tree_name || '' ['' || d.tree_seq || ''] '' || d.node_name, c.version_id    from camp_det c, tree_hdr t, 
	tree_det d  where c.obj_type_id = 4 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and c.obj_sub_id = d.tree_seq 
	UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, 
	t.tree_name || '' ['' || d.tree_seq || ''] '' || d.node_name, c.version_id    
	from camp_det c, tree_hdr t, tree_det d where c.obj_type_id = 21 and c.obj_id = t.tree_id and 
	c.obj_id = d.tree_id and  c.obj_sub_id = d.tree_seq');

	execute_sql ('CREATE OR REPLACE VIEW OUTB_PROJECTION 
	(STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, 
	CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, TREATMENT_ID, TREATMENT_NAME, TREAT_DET_ID, 
	UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_DET_ID, SEG_NAME, SEG_KEYCODE, 
	SEG_CONTROL_FLG, SEG_PROJ_QTY, SEG_PROJ_RES_RATE, SEG_PROJ_RES, SEG_PROJ_VAR_COST, VERSION_ID, VERSION_NAME) 
	AS SELECT max(strat.strategy_id), max(strat.strategy_name), max(camp.camp_grp_id), max(cgrp.camp_grp_name), 
	max(ctdet.camp_id), max(camp.camp_code), max(camp.camp_name), max(dhcs.status_setting_id), max(camp.camp_templ_id), 
	max(ctype.camp_type_name), max(cmgr.manager_name), max(cbmgr.manager_name), max(dhcfc.cost_per_seg), max(camp.start_date), 
	max(ctdet.obj_id), max(treat.treatment_name), max(ctdet.det_id), sum(elem.var_cost/elem.var_cost_qty), 
	max(dhtfc.cost_per_seg), max(chntype.chan_type_id), max(csdet.obj_type_id), max(csdet.obj_id), max(csdet.obj_sub_id), 
	max(csdet.det_id), max(csdet.name), max(cseg.keycode), max(cseg.control_flg), max(cseg.proj_qty), 
	max(cseg.proj_res_rate)/100, max(cseg.proj_res_rate)/100 * max(cseg.proj_qty), 
	sum(elem.var_cost/elem.var_cost_qty) * max(cseg.proj_qty), max(ctdet.version_id), max(campver.version_name)
	from CAMP_GRP cgrp, STRATEGY strat, CAMPAIGN camp, CAMP_VERSION campver, CAMP_TYPE ctype, CAMP_MANAGER cmgr, 
	CAMP_MANAGER cbmgr, CAMP_DET ctdet, CAMP_SEG_DET csdet, TREATMENT treat, TELEM telem, ELEM elem, TREATMENT_GRP tgrp, 
	CHAN_TYPE chntype, SEG_HDR seghd, CAMP_SEG cseg, CAMP_SEG_COST dhcfc, TREAT_SEG_COST dhtfc, CAMP_STATUS dhcs
	where strat.strategy_id = cgrp.strategy_id and camp.camp_grp_id = cgrp.camp_grp_id and camp.camp_id = dhcfc.camp_id (+) 
	and camp.camp_type_id = ctype.camp_type_id (+) and camp.camp_id = csdet.camp_id and camp.camp_id = dhcs.camp_id and
	campver.manager_id = cmgr.manager_id (+) and campver.budget_manager_id = cbmgr.manager_id (+) and
	ctdet.version_id = campver.version_id and csdet.version_id = campver.version_id and
	csdet.par_det_id = ctdet.det_id  and csdet.camp_id = ctdet.camp_id and ctdet.det_id = dhtfc.treat_det_id (+) and 
	ctdet.camp_id = dhtfc.camp_id (+) and treat.treatment_id = ctdet.obj_id and treat.treatment_id = telem.treatment_id (+) 
	and telem.elem_id = elem.elem_id (+) and treat.treatment_grp_id = tgrp.treatment_grp_id
	and tgrp.chan_type_id = chntype.chan_type_id and csdet.obj_type_id = seghd.seg_type_id (+) 
	and csdet.obj_id = seghd.seg_id (+) and csdet.camp_id = cseg.camp_id (+) and csdet.det_id = cseg.det_id (+) 
	and csdet.obj_type_id in (1,4,21) group by csdet.camp_id, csdet.det_id, csdet.version_id');

	execute_sql ('CREATE OR REPLACE VIEW CAMP_ANALYSIS (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, 
	CAMP_ID, CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST,
	CAMP_START_DATE, CAMP_NO_OF_CYCLES, TREATMENT_ID, TREATMENT_NAME, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, 
	SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, PROJ_OUT_CYC_QTY, PROJ_OUT_QTY, 
	PROJ_INB_CYC_QTY, PROJ_INB_QTY, PROJ_RES_RATE, PROJ_OUT_CYC_VCOST, PROJ_OUT_VCOST, PROJ_INB_CYC_VCOST, PROJ_INB_VCOST, 
	PROJ_INB_CYC_REV, PROJ_INB_REV, SEG_ACT_TREAT_QTY, SEG_ACT_OUT_QTY, SEG_ACT_OUT_VCOST, SEG_ACT_INB_QTY, 
	SEG_ACT_INB_VCOST, SEG_ACT_REV, VERSION_ID, VERSION_NAME) 
	AS SELECT outbp.STRATEGY_ID, outbp.STRATEGY_NAME, outbp.CAMP_GRP_ID, outbp.CAMP_GRP_NAME, outbp.CAMP_ID, 
	outbp.CAMP_CODE, outbp.CAMP_NAME, outbp.CAMP_STATUS, outbp.CAMP_TEMPLATE, outbp.CAMP_TYPE, outbp.CAMP_MANAGER, 
	outbp.BUDGET_MANAGER, to_number(decode(outbp.CAMP_FIXED_COST,0,NULL, outbp.CAMP_FIXED_COST)), outbp.CAMP_START_DATE, 
	outbc.CAMP_NO_OF_CYCLES, outbp.TREATMENT_ID, outbp.TREATMENT_NAME, 
	to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)),
	to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), outbp.TREAT_CHAN, outbp.SEG_TYPE_ID, 
	outbp.SEG_ID, outbp.SEG_SUB_ID, outbp.SEG_NAME, outbp.SEG_KEYCODE, outbp.SEG_CONTROL_FLG, 
	to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)),
	to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_qty * outbc.camp_no_of_cycles)),
	to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)),
	to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_res * outbc.camp_no_of_cycles)),
	to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL, outbp.SEG_PROJ_RES_RATE)), 
	to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL, outbp.SEG_PROJ_VAR_COST)),
	to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0, null, outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)),
	to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,null,inbp.avg_cost_per_res * outbp.seg_proj_res)),
	to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,
	(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)),
	to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,null, inbp.avg_rev_per_res * outbp.seg_proj_res)),   
	to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,
	(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)),
	to_number(decode(outbc.SEG_ACT_TREAT_QTY,0,NULL, outbc.SEG_ACT_TREAT_QTY)), 
	to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,  outbc.SEG_ACT_OUTB_QTY)),
	to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL, outbc.SEG_ACT_OUTB_VCOST)),
	to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)),
	to_number(decode(inbc.SEG_ACT_INB_VCOST,0,NULL, inbc.SEG_ACT_INB_VCOST)),
	to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV)),
	outbp.version_id, outbp.version_name
	from OUTB_PROJECTION outbp, INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc 
	where outbp.camp_id = inbp.camp_id (+) and outbp.seg_det_id = inbp.seg_det_id (+) 
	and outbp.camp_id = outbc.camp_id (+) and outbp.seg_det_id = outbc.seg_det_id (+) 
	and outbp.camp_id = inbc.camp_id (+) and outbp.seg_det_id = inbc.seg_det_id (+)'); 

	execute_sql('grant select, insert, delete, update on CAMPAIGN to &v3role');
	execute_sql('grant select, insert, delete, update on CAMP_VERSION to &v3role');
	execute_sql('grant select, insert, delete, update on COMM_NON_CONTACT to &v3role');
	execute_sql('grant select, insert, delete, update on UPDATE_STATUS to &v3role');
	execute_sql('grant select, insert, delete, update on WIRELESS_SERVER to &v3role');
	execute_sql('grant select, insert, delete, update on WIRELESS_RES_RULE to &v3role');
	execute_sql('grant select, insert, delete, update on WIRELESS_PROTOCOL to &v3role');
	execute_sql ('GRANT SELECT ON TREAT_COMM_INFO to &v3role');
	execute_sql ('GRANT SELECT ON CHARAC_COMM_INFO to &v3role');
	execute_sql ('GRANT SELECT ON ELEM_COMM_INFO to &v3role');
	execute_sql ('GRANT SELECT ON CAMP_SEG_DET to &v3role');
	execute_sql ('GRANT SELECT ON OUTB_PROJECTION to &v3role');
	execute_sql ('GRANT SELECT ON CAMP_ANALYSIS to &v3role');

	update cust_tab set vantage_alias = 'WIRELESS_RES', vantage_name = 'Wireless Inbound Communication', db_ent_name = 'WIRELESS_RES' 
		where db_ent_name = 'SMS_RES';
	update cust_tab set par_vantage_alias = 'WIRELESS_RES' where par_vantage_alias = 'SMS_RES';
	COMMIT;

	update pvdm_upgrade set version_id = '5.5.0.760';
	commit;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> V5.2.0 Marketing Director Schema has been upgraded to V5.5.0 build 760');
	dbms_output.put_line( '>' );
	dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (2) error occurred.' );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/

DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;

var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_pv_owner varchar2(128);

var_main_view varchar2(30);
var_dtype varchar2(30);
var_dlen number;
var_dprec number;
var_dscale number;
var_coltype varchar2(40);


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

select 1 into var_count from pvdm_upgrade where version_id = '5.5.0.760';

	dbms_output.put_line( 'Processing Schema Upgrade from V5.5.0 Build 760 to Build 825.3');
	dbms_output.put_line( '-------------------------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '   Change for Monitoring Wireless Delivery Status:-');
	dbms_output.put_line( '      - table CAMP_OUT_DET - add column DELIVERY_FLG');
	dbms_output.put_line( '	  Change for Wireless message validity and priority:- ');
	dbms_output.put_line( '	     - table TREATMENT - add columns DFT_VALID_DATE, DFT_VALID_DAYS, DFT_VALID_TIME, DFT_MESSAGE_PRIO');
	dbms_output.put_line( '	     - table CAMP_TREAT_DET - add columns VALID_DATE, VALID_DAYS, VALID_TIME, MESSAGE_PRIO');
	dbms_output.put_line( '	  Amend system pre-populated values in ERES_RULE_TYPE ');
	dbms_output.put_line( '   Changes to Handle Wireless Campaign responses:- ');
	dbms_output.put_line( '	     - table ERES_RULE_DET - add column PAR_RULE_DET_SEQ ');
	dbms_output.put_line( '	     - new table WIRELESS_INBOX ');
	dbms_output.put_line( '	     - modification to WIRELESS_RES_RULE table');
	dbms_output.put_line( '	     - new tables to handle details of Response Actions: ');
	dbms_output.put_line( '	     RES_RULE_ACTION, RES_ACTION_TYPE, ACTION_FORWARD, ACTION_STORE_VAL, ');
	dbms_output.put_line( '      ACTION_STORE_CAMP, ACTION_CUSTOM, RES_CUSTOM_PARAM, RES_SYS_PARAM');
	dbms_output.put_line( '	     - new triggers on WIRELESS_INBOX, and amended triggers on WIRELESS_RES_RULE');
	dbms_output.put_line( '   Add table DELIVERY_RECEIPT, and lookup table DELIVERY_STATUS');
	dbms_output.put_line( '   Add VERSION_ID and VERSION_NAME entries to CAMP_REP_COL table ');
	dbms_output.put_line(          'for definition of columns for campaign reports');
	dbms_output.put_line( '	     - addition of Wireless Inbox object to OBJ_TYPE');
	dbms_output.put_line( '	     - addition of support RI details into CONSTRAINT_SETTING');
	dbms_output.put_line( '	     - update of details in VANTAGE_ENT');
	dbms_output.put_line( '	  Adding entry for Campaign Schedule Overview module to MODULE_DEFINITION');
	dbms_output.put_line( '   Adding index on SUBS_CAMP_CYC_ORG (CAMP_ID, CAMP_CYC) to aid application SQL');
	dbms_output.put_line( '	  Granting access to the new objects');
        dbms_output.put_line( '   Correction re: triggers on SPI_PROC - addition of RI check for Wireless Inbox');
	dbms_output.put_line( '>');


	execute_sql ('ALTER TABLE CAMP_OUT_DET ADD (DELIVERY_FLG NUMBER(1) DEFAULT 0 NOT NULL)');
	execute_sql ('ALTER TABLE CAMP_OUT_DET MODIFY (DELIVERY_FLG DEFAULT NULL)');

	execute_sql ('ALTER TABLE TREATMENT ADD (DFT_VALID_DATE DATE, DFT_VALID_TIME CHAR(8), DFT_VALID_DAYS NUMBER(3),  
		DFT_MESSAGE_PRIO VARCHAR2(10))');
	execute_sql ('ALTER TABLE CAMP_TREAT_DET ADD (VALID_DATE DATE, VALID_TIME CHAR(8), VALID_DAYS NUMBER(3), 
		MESSAGE_PRIO VARCHAR2(10))');

	update ERES_RULE_TYPE set RULE_TYPE_NAME = 'Inbound Wireless Message Rule' where RULE_TYPE_ID = 3;
	COMMIT;

	execute_sql ('ALTER TABLE ERES_RULE_DET ADD (PAR_RULE_DET_SEQ NUMBER(2))');

	execute_sql ('drop table wireless_res_rule');

	execute_sql ('CREATE TABLE WIRELESS_RES_RULE (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
	    INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, RULE_SEQ NUMBER(2) NOT NULL, GLOBAL_RULE_FLG NUMBER(1) NOT NULL,
	    ACTIVE_FLG NUMBER(1) NOT NULL) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKWIRELESS_RES_RULE ON WIRELESS_RES_RULE (RULE_ID ASC, SERVER_ID ASC, 
	    INBOX_ID ASC, CHAN_TYPE_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE WIRELESS_RES_RULE ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID) 
            USING INDEX TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE TABLE WIRELESS_INBOX (SERVER_ID NUMBER(4) NOT NULL, INBOX_ID NUMBER(4) NOT NULL,
            INBOX_ADDRESS VARCHAR2(100) NOT NULL, INBOX_DESC VARCHAR2(300), TEST_SEND_FLG NUMBER(1) NOT NULL, 
            TEST_MESSAGE_TO VARCHAR2(100), INB_PORT NUMBER(8), CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL, 
            UPDATED_BY VARCHAR2(30), UPDATED_DATE DATE) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKWIRELESS_INBOX ON WIRELESS_INBOX (SERVER_ID ASC, INBOX_ID ASC) TABLESPACE &ts_pv_ind' );
	execute_sql ('ALTER TABLE WIRELESS_INBOX ADD PRIMARY KEY (SERVER_ID, INBOX_ID) USING INDEX TABLESPACE &ts_pv_ind' );

	execute_sql ('CREATE TABLE RES_RULE_ACTION (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, INBOX_ID NUMBER(4) NOT NULL,
            CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, ACTION_TYPE_ID NUMBER(2) NOT NULL) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKRES_RULE_ACTION ON RES_RULE_ACTION (RULE_ID ASC, SERVER_ID ASC, INBOX_ID ASC, 
	    CHAN_TYPE_ID ASC, ACTION_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE RES_RULE_ACTION ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ) 
	    USING INDEX TABLESPACE &ts_pv_ind' );

	execute_sql ('CREATE TABLE RES_ACTION_TYPE (ACTION_TYPE_ID NUMBER(2) NOT NULL, ACTION_TYPE_NAME VARCHAR2(20) NOT NULL)
            TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKRES_ACTION_TYPE ON RES_ACTION_TYPE(ACTION_TYPE_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE RES_ACTION_TYPE ADD PRIMARY KEY (ACTION_TYPE_ID) USING INDEX TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE TABLE ACTION_FORWARD (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
            INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, 
	    FORWARD_TO_MAILBOX VARCHAR2(100) NOT NULL, FORWARD_SERVER_ID NUMBER(4) NOT NULL) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKACTION_FORWARD ON ACTION_FORWARD (RULE_ID ASC, SERVER_ID ASC, INBOX_ID ASC, 
	    CHAN_TYPE_ID ASC, ACTION_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE ACTION_FORWARD ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ) 
	    USING INDEX TABLESPACE &ts_pv_ind' );

	execute_sql ('CREATE TABLE ACTION_STORE_VAL (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
	    INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, 
	    MESSAGE_VAL_FLG NUMBER(1) NOT NULL, INSERT_VAL VARCHAR2(40), VANTAGE_ALIAS VARCHAR2(128) NOT NULL,
	    COL_NAME VARCHAR2(128) NOT NULL) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKACTION_STORE_VAL ON ACTION_STORE_VAL (RULE_ID ASC, SERVER_ID ASC, 
	    INBOX_ID ASC, CHAN_TYPE_ID ASC, ACTION_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE ACTION_STORE_VAL ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ) 
	    USING INDEX TABLESPACE &ts_pv_ind' );
	
	execute_sql ('CREATE TABLE ACTION_STORE_CAMP (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
	    INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, 
	    CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL, DET_ID NUMBER(4))  
	    TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKACTION_STORE_CAMP ON ACTION_STORE_CAMP (RULE_ID ASC, SERVER_ID ASC, 
	    INBOX_ID ASC, CHAN_TYPE_ID ASC, ACTION_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE ACTION_STORE_CAMP ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, 
	    ACTION_SEQ) USING INDEX TABLESPACE &ts_pv_ind' );
	
	execute_sql ('CREATE TABLE ACTION_CUSTOM (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
	    INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, 
            CUSTOM_ACTION_NAME VARCHAR2(50) NOT NULL, CUSTOM_FILENAME VARCHAR2(255) NOT NULL)
	    TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKACTION_CUSTOM ON ACTION_CUSTOM (RULE_ID ASC, SERVER_ID ASC, 
	    INBOX_ID ASC, CHAN_TYPE_ID ASC, ACTION_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE ACTION_CUSTOM ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, 
	    ACTION_SEQ) USING INDEX TABLESPACE &ts_pv_ind' );

	execute_sql ('CREATE TABLE RES_CUSTOM_PARAM (RULE_ID NUMBER(4) NOT NULL, SERVER_ID NUMBER(4) NOT NULL, 
	    INBOX_ID NUMBER(4) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, ACTION_SEQ NUMBER(2) NOT NULL, 
	    PARAM_SEQ NUMBER(2) NOT NULL, SYS_PARAM_FLG NUMBER(1) NOT NULL, RES_SYS_PARAM_ID NUMBER(2),
	    PARAM_NAME VARCHAR2(100), PARAM_VAL VARCHAR2(200)) TABLESPACE &ts_pv_sys' );
	execute_sql ('CREATE UNIQUE INDEX XPKRES_CUSTOM_PARAM ON RES_CUSTOM_PARAM (RULE_ID ASC, SERVER_ID ASC, 
	    INBOX_ID ASC, CHAN_TYPE_ID ASC, ACTION_SEQ ASC, PARAM_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE RES_CUSTOM_PARAM ADD PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, 
	    ACTION_SEQ, PARAM_SEQ) USING INDEX TABLESPACE &ts_pv_ind' );
	
	execute_sql ('CREATE TABLE RES_SYS_PARAM (RES_SYS_PARAM_ID NUMBER(2) NOT NULL, RES_SYS_PARAM_NAME VARCHAR2(50) NOT NULL)
	    TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKRES_SYS_PARAM ON RES_SYS_PARAM (RES_SYS_PARAM_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE RES_SYS_PARAM ADD PRIMARY KEY (RES_SYS_PARAM_ID) USING INDEX TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE TABLE DELIVERY_STATUS (DELIVERY_STATUS_ID NUMBER(2) NOT NULL, 
			STATUS_DESC VARCHAR2(50) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL) tablespace &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKDELIVERY_STATUS ON DELIVERY_STATUS (DELIVERY_STATUS_ID ASC) 
			tablespace &ts_pv_ind');

	execute_sql ('ALTER TABLE DELIVERY_STATUS ADD ( PRIMARY KEY (DELIVERY_STATUS_ID) USING INDEX 
	               TABLESPACE &ts_pv_ind )');

	var_main_view := '&main_view';

	SELECT DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE INTO var_dtype, var_dlen, var_dprec, var_dscale 
	     FROM PV_COLS X WHERE EXISTS (SELECT * FROM CUST_TAB WHERE VIEW_ID = var_main_view AND 
	     VANTAGE_TYPE = 1 AND DB_ENT_OWNER = X.TABLE_OWNER AND DB_ENT_NAME = X.TABLE_NAME AND 
             STD_JOIN_FROM_COL = X.COLUMN_NAME);

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

	execute_sql ('CREATE TABLE DELIVERY_RECEIPT (A1 ' || var_coltype || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL, 
			DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, MESSAGE_ID VARCHAR2(200) NOT NULL,
			MESSAGE_ADDRESS VARCHAR2(100) NOT NULL, CHAN_TYPE_ID NUMBER(3) NOT NULL, 
			DELIVERY_STATUS_ID NUMBER(2), DELIVERY_DATE DATE, DELIVERY_TIME CHAR(8)) tablespace &ts_pv_comm');

	execute_sql ('CREATE UNIQUE INDEX XPKDELIVERY_RECEIPT ON DELIVERY_RECEIPT (MESSAGE_ID ASC) 
			TABLESPACE &ts_pv_cind');

	execute_sql ('ALTER TABLE DELIVERY_RECEIPT ADD PRIMARY KEY (MESSAGE_ID) 
		USING INDEX TABLESPACE &ts_pv_cind');

	execute_sql ('CREATE INDEX XIE1DELIVERY_RECEIPT ON DELIVERY_RECEIPT (A1 ASC, CAMP_ID ASC, DET_ID ASC, 
			CAMP_CYC ASC) tablespace &ts_pv_cind');

	-- adding index on SUBS_CAMP_CYC_ORG to aid application SQL

	execute_sql ('CREATE INDEX XIE4SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (CAMP_ID ASC, CAMP_CYC ASC)
			TABLESPACE &ts_pv_ind');
	
	-- adding indexes on SPI_CAMP_PROC to aid application SQL

	execute_sql ('CREATE INDEX XIE4SPI_CAMP_PROC ON SPI_CAMP_PROC (START_DATE ASC) 
			TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE5SPI_CAMP_PROC ON SPI_CAMP_PROC (START_TIME ASC) 
			TABLESPACE &ts_pv_ind');	

	insert into vantage_ent values ('ACTION_CUSTOM',1,0);
	insert into vantage_ent values ('ACTION_FORWARD',1,0);
	insert into vantage_ent values ('ACTION_STORE_CAMP',1,0);
	insert into vantage_ent values ('ACTION_STORE_VAL',1,0);
	insert into vantage_ent values ('DELIVERY_STATUS',1,0);
	insert into vantage_ent values ('DELIVERY_RECEIPT',1,1);
	insert into vantage_ent values ('RES_ACTION_TYPE',1,1);
	insert into vantage_ent values ('RES_CUSTOM_PARAM',1,0);
	insert into vantage_ent values ('RES_RULE_ACTION',1,0);
	insert into vantage_ent values ('RES_SYS_PARAM',1,1);
	insert into vantage_ent values ('WIRELESS_INBOX',1,0);
	COMMIT;

	insert into obj_type values (97, 'Wireless Inbox', NULL);
	delete from obj_type where obj_type_id = 90 and obj_name = 'Characteristic Group';
	COMMIT;

	update constraint_setting set ref_type_id = 97 where ref_type_id = 79 and obj_type_id = 69;
	insert into constraint_setting values (97, 1, 79, 2);
	COMMIT;

	insert into MODULE_DEFINITION values (18, 'Campaign Schedule Overview','Campaign Schedule Overview',1,4,4,4);
	commit;

	update pvdm_upgrade set version_id = '5.5.0.825.3-';
	commit;

        dbms_output.put_line( '>' );
	dbms_output.put_line( '>' );
	dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (3) error occurred.' );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/


DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;

var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_pv_owner varchar2(128);

var_main_view varchar2(30);
var_dtype varchar2(30);
var_dlen number;
var_dprec number;
var_dscale number;
var_coltype varchar2(40);


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

	select 1 into var_count from pvdm_upgrade where version_id = '5.5.0.825.3-';

	insert into res_action_type values (10, 'Forward');
	insert into res_action_type values (20, 'Store Value');
	insert into res_action_type values (30, 'Store Campaign');
	insert into res_action_type values (40, 'Custom');
	COMMIT;

	insert into res_sys_param values (1, 'Phone Number');
	insert into res_sys_param values (2, 'Message Text');
	insert into res_sys_param values (3, 'Current Date');
	insert into res_sys_param values (4, 'Current Time');
	COMMIT;

	insert into delivery_status values (1, 'Accepted', 40);
	insert into delivery_status values (2, 'Deleted', 40);
	insert into delivery_status values (3, 'Delivered', 40);
	insert into delivery_status values (4, 'Enroute', 40);
	insert into delivery_status values (5, 'Expired', 40);
	insert into delivery_status values (6, 'Rejected', 40);
	insert into delivery_status values (7, 'Undeliverable', 40);
	insert into delivery_status values (8, 'Unknown', 40);
	insert into delivery_status values (9, 'Retrieved', 50);
	insert into delivery_status values (10, 'Expired', 50);
	insert into delivery_status values (11, 'Rejected', 50);
	insert into delivery_status values (12, 'Unrecognised', 50);
	insert into delivery_status values (13, 'Deferred', 50);
	COMMIT;

	insert into proc_control select 'Inbound Wireless', null, 1, 'v_inbound_wirelessproc.bat', 
	 	location, 13 from proc_control where filename = 'v_spiproc';

	insert into proc_param values ('Inbound Wireless',0,'Server executable name','v_inbound_wirelessproc.bat');
	insert into proc_param values ('Inbound Wireless',1,'Call Type','S');
	insert into proc_param values ('Inbound Wireless',2,'RPC Id / SPI Audit Id',null );
	insert into proc_param values ('Inbound Wireless',3,'Process Audit Id',null );
	insert into proc_param values ('Inbound Wireless',4,'Secure Database Account Name',null );
	insert into proc_param values ('Inbound Wireless',5,'Secure Database Password',null );
	insert into proc_param values ('Inbound Wireless',6,'Customer Data View Id',null );
	insert into proc_param values ('Inbound Wireless',7,'User Id',null );
	insert into proc_param values ('Inbound Wireless',8,'Database Vendor Id',null );
	insert into proc_param values ('Inbound Wireless',9,'Database Connection String',null );
	insert into proc_param values ('Inbound Wireless',10,'Language Id',null );
	insert into proc_param values ('Inbound Wireless',11,'Server Id',null );
	insert into proc_param values ('Inbound Wireless',12,'Inbox Id',null );
	COMMIT;	

	update elem x set content_formt_id = 15 where exists (select * from elem_grp
		where chan_type_id = 40 and elem_grp_id = x.elem_grp_id);

	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON WIRELESS_INBOX to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON WIRELESS_RES_RULE to &v3role'); 
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON RES_RULE_ACTION to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON RES_ACTION_TYPE to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON ACTION_FORWARD to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON ACTION_STORE_VAL to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON ACTION_STORE_CAMP to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON ACTION_CUSTOM to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON RES_CUSTOM_PARAM to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON RES_SYS_PARAM to &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DELIVERY_STATUS TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DELIVERY_RECEIPT TO &v3role');

	update pvdm_upgrade set version_id = '5.5.0.825.3';
	commit;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> V5.5.0 Marketing Director Schema has been upgraded to V5.5.0 build 825.3');
	dbms_output.put_line( '>' );
	dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (4) error occurred.' );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/




-- correction for RI to update reference records on update of criteria strings at save time
-- resulting in additional triggers TU_SEG_HDR_CRIT, TU_DERIVED_VAL_HTX, TU_DERIVED_VAL_HGB,
-- TU_DERIVED_VAL_HOB and TU_DERIVED_VAL_HAI

create or replace trigger TU_SEG_HDR_CRIT
  AFTER UPDATE OF 
        SEG_CRITERIA
  on SEG_HDR
  
  for each row
/* ERwin Builtin Thu Jul 19 15:58:10 2001 */
/* default body for TU_SEG_HDR_CRIT */
declare numrows INTEGER;
        var_count INTEGER;

begin
  select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
    ref_id = :old.seg_id and ref_indicator_id = 16;

  if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id 
       and ref_indicator_id = 16;
  end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HTX
  AFTER UPDATE OF 
        DERIVED_VAL_TEXT
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Thu Jul 19 15:58:11 2001 */
/* default body for TU_DERIVED_VAL_HTX */
declare numrows INTEGER;
        var_count INTEGER;

begin
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 16;

  if var_count <> 0 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 16;
  end if;

end;
/



create or replace trigger TU_DERIVED_VAL_HGB
  AFTER UPDATE OF 
        GROUP_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:59:00 2001 */
/* default body for TU_DERIVED_VAL_HGB */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.group_by is not null) then
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 17;

  if var_count <> 0 then
    delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 17;
  end if;
end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HOB
  AFTER UPDATE OF 
        ORDER_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:59:59 2001 */
/* default body for TU_DERIVED_VAL_HOB */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.order_by is not null) then
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 18;

  if var_count <> 0 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 18;
  end if;
end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HAI
  AFTER UPDATE OF 
        ADDL_INFO
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:57:27 2001 */
/* default body for TU_DERIVED_VAL_HAI */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.addl_info is not null) then
   select count(*) into var_count from referenced_obj where ref_type_id = 13 and
      ref_id = :old.derived_val_id and ref_indicator_id = 19;

   if var_count <> 0 then
       delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 19;
   end if;
end if;

end;
/


-- New and Modified TRIGGERS -

-- updated triggers for CAMPAIGN:

create or replace trigger TI_CAMPAIGN
  AFTER INSERT
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Jul 29 13:47:07 2002 */
/* default body for TI_CAMPAIGN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced Campaign Group exists */
select camp_grp_id into var_id from camp_grp where camp_grp_id = :new.camp_grp_id;

/* insert reference to Campaign Group */
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 1, constraint_type_id
from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 33 or obj_type_id is null);

/* insert reference to Campaign Type (optional) */
if (:new.camp_type_id is not null and :new.camp_type_id <> 0) then
    /* check referenced Campaign Type exists */
    select camp_type_id into var_id from camp_type where camp_type_id = :new.camp_type_id;
    
    insert into referenced_obj select 37, :new.camp_type_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 37 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMPAIGN
  AFTER DELETE
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Jul 29 13:45:58 2002 */
/* default body for TD_CAMPAIGN */
declare numrows INTEGER;
begin
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
   and obj_type_id = 33 and obj_id = :old.camp_grp_id and ref_indicator_id = 1; 

if (:old.camp_type_id is not null and :old.camp_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = 37 and obj_id = :old.camp_type_id and ref_indicator_id = 1; 
end if;
end;
/


create or replace trigger TU_CAMPAIGN_GRP
  AFTER UPDATE OF 
        CAMP_GRP_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Jul 29 13:48:01 2002 */
/* default body for TU_CAMPAIGN_GRP */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old campaign group */
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
  and obj_type_id = 33 and obj_id = :old.camp_grp_id and ref_indicator_id = 1; 

/* check new referenced campaign group exists */
select camp_grp_id into var_id from camp_grp where camp_grp_id = :new.camp_grp_id;

/* insert reference to new budget manager */
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null, 
  24,:new.camp_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
  and (obj_type_id = 33 or obj_type_id is null);


EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMPAIGN_TYPE
  AFTER UPDATE OF 
        CAMP_TYPE_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Jul 29 13:49:25 2002 */
/* default body for TU_CAMPAIGN_TYPE */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old campaign type, if given */
if (:old.camp_type_id is not null and :old.camp_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
     and obj_type_id = 37 and obj_id = :old.camp_type_id and ref_indicator_id = 1; 
end if;

/* check new referenced campaign type exists, if given */
if (:new.camp_type_id is not null and :new.camp_type_id <> 0) then
  select camp_type_id into var_id from camp_type where camp_type_id = :new.camp_type_id;

  insert into referenced_obj select 37, :new.camp_type_id, null, null, null, null, null,
    24,:new.camp_id, null, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
    and (obj_type_id = 37 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- new triggers for CAMP_VERSION:

create or replace trigger TI_CAMP_VERSION
  AFTER INSERT
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Jul 29 14:09:41 2002 */
/* default body for TI_CAMP_VERSION */
declare numrows INTEGER;
        var_id INTEGER;
begin

/* insert reference to Manager (optional) */
if (:new.manager_id is not null and :new.manager_id <> 0) then
  /* check referenced Campaign Manager exists */
  select manager_id into var_id from camp_manager where manager_id = :new.manager_id;

  insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1
    and (obj_type_id = 36 or obj_type_id is null);
end if;

/* insert reference to Budget Manager (optional) */

if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
  /* check referenced budget Manager exists */
  select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;

  insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 4, constraint_type_id 
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 
    and (obj_type_id = 36 or obj_type_id is null);
end if;

/* insert reference to segment (optional) */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
   /* check referenced segment exists */
   select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id 
   and seg_id = :new.web_filter_id;

   insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,
     24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
     and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_VERSION
  AFTER DELETE
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Jul 29 14:14:58 2002 */
/* default body for TD_CAMP_VERSION */
declare numrows INTEGER;
        var_id INTEGER;
begin

if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id and ref_indicator_id = 1; 
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_VER_BMAN
  AFTER UPDATE OF 
        BUDGET_MANAGER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Jul 29 14:19:51 2002 */
/* default body for TU_CAMP_VER_BMAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* remove reference to old budget manager, if given */
if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

/* check new referenced budget manager exists, if given */
if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
    select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;

    insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, null, null, 4, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 
      and (obj_type_id = 36 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_VER_CMAN
  AFTER UPDATE OF 
        MANAGER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Jul 29 14:22:57 2002 */
/* default body for TU_CAMP_VER_CMAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* remove reference to old manager, if given */
if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
     and ref_sub_id = :old.version_id and ref_det_id is null
     and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

/* check new referenced manager exists, if given */
if (:new.manager_id is not null and :new.manager_id <> 0) then
  select manager_id into var_id from camp_manager where manager_id = :new.manager_id;

  insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,
     24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
     and (obj_type_id = 36 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_VER_WEBSEG
  AFTER UPDATE OF 
        WEB_FILTER_TYPE_ID,
        WEB_FILTER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Jul 29 14:25:58 2002 */
/* default body for TU_CAMP_VER_WEBSEG */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old web segment, if given */
if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
     and ref_sub_id = :old.version_id and ref_det_id is null 
     and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id 
     and ref_indicator_id = 1; 
end if;

/* check new referenced web segment exists, if given */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
  select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id 
    and seg_id = :new.web_filter_id;

  insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
    and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for TREAT_FIXED_COST:

create or replace trigger TI_TREAT_FIXED_COST
  AFTER INSERT
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Jul 29 12:58:00 2002 */
/* default body for TI_TREAT_FIXED_COST */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced objects still exist */

if :new.fixed_cost_id <> 0 then
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 38 or obj_type_id is null);
end if;

if :new.fixed_cost_area_id <> 0 then
  select fixed_cost_area_id into var_id from fixed_cost_area 
     where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 39 or obj_type_id is null);
end if;

if :new.supplier_id <> 0 then
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 40 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_TREAT_FIXED_COST
  AFTER DELETE
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Jul 29 12:55:24 2002 */
/* default body for TD_TREAT_FIXED_COST */
declare numrows INTEGER;

begin
if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5; 
end if;

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;
end;
/


create or replace trigger TU_TREAT_FIXED_COST_AREA
  AFTER UPDATE OF 
        FIXED_COST_AREA_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Jul 29 12:59:45 2002 */
/* default body for TU_TREAT_FIXED_COST_AREA */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
   and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5;
end if;

if :new.fixed_cost_area_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_area_id into var_id from fixed_cost_area 
    where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 39 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_TREAT_FIXED_COST_FC
  AFTER UPDATE OF 
        FIXED_COST_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Jul 29 13:01:48 2002 */
/* default body for TU_TREAT_FIXED_COST_FC */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
    and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
    and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :new.fixed_cost_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_TREAT_FIXED_COST_SUP
  AFTER UPDATE OF 
        SUPPLIER_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Jul 29 13:03:43 2002 */
/* default body for TU_TREAT_FIXED_COST_SUP */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
    and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
    and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;

if :new.supplier_id <> 0 then
  /* check referenced objects still exist */
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 40 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_DET:

create or replace trigger TI_CAMP_DET
  AFTER INSERT
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Jul 29 12:47:13 2002 */
/* default body for TI_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.obj_type_id in (1,4,17,18,19,20,28,29) and :new.obj_id is not null and :new.obj_id <> 0) then
  /* check if referenced object still exists */
  if :new.obj_type_id = 18 then  /* treatment */
     select treatment_id into var_id from treatment where treatment_id = :new.obj_id;

  elsif :new.obj_type_id = 19 then  /* response model */
     select res_model_id into var_id from res_model_hdr where res_model_id = :new.obj_id;

  elsif :new.obj_type_id = 20 then  /* response stream */
     select res_stream_id into var_id from res_model_stream where res_model_id = :new.obj_id
       and res_stream_id = :new.obj_sub_id;

  elsif :new.obj_type_id = 17 then  /* task group */
     select spi_id into var_id from spi_master where spi_id = :new.obj_id;

  elsif :new.obj_type_id in (1,28,29) then  /* segment, web dynamic criteria or web session criteria */ 
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;

  elsif :new.obj_type_id = 4 then  /* tree segment */
     select tree_id into var_id from tree_det where tree_id = :new.obj_id and tree_seq = :new.obj_sub_id;

  end if;

  /* insert new reference details */
  if (:new.obj_sub_id is null or :new.obj_sub_id = 0) then
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_DET
  AFTER DELETE
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Jul 29 12:45:07 2002 */
/* default body for TD_CAMP_DET */
declare numrows INTEGER;
begin

/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
  end if;
end if;

end;
/


create or replace trigger TU_CAMP_DET
  AFTER UPDATE OF 
        OBJ_TYPE_ID,
        OBJ_ID
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Jul 29 12:50:01 2002 */
/* default body for TU_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
  end if;
end if;

/* check if referenced object still exists */
if :new.obj_type_id in (1,4,17,18,19,20,28,29) then
  /* check if referenced object still exists */
  if :new.obj_type_id = 18 then  /* treatment */
     select treatment_id into var_id from treatment where treatment_id = :new.obj_id;

  elsif :new.obj_type_id = 19 then  /* response model */
     select res_model_id into var_id from res_model_hdr where res_model_id = :new.obj_id;

  elsif :new.obj_type_id = 20 then  /* response stream */
     select res_stream_id into var_id from res_model_stream where res_model_id = :new.obj_id
       and res_stream_id = :new.obj_sub_id;

  elsif :new.obj_type_id = 17 then  /* task group */
     select spi_id into var_id from spi_master where spi_id = :new.obj_id;

  elsif :new.obj_type_id in (1,28,29) then  /* segment, web dynamic criteria or web session criteria */ 
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;

  elsif :new.obj_type_id = 4 then  /* tree segment */
     select tree_id into var_id from tree_det where tree_id = :new.obj_id and tree_seq = :new.obj_sub_id;

  end if;

  /* insert new reference details */
  if (:new.obj_sub_id is null or :new.obj_sub_id = 0) then
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_DDROP:

create or replace trigger TI_CAMP_DDROP
  AFTER INSERT
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Jul 29 10:59:11 2002 */
/* default body for TI_CAMP_DDROP */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 45 or obj_type_id is null);
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 46 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TD_CAMP_DDROP
  AFTER DELETE
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Jul 29 12:06:52 2002 */
/* default body for TD_CAMP_DDROP */
declare numrows INTEGER;
begin

if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_region_id;
end if;

if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

end;
/


create or replace trigger TU_CAMP_DDROP_CARR
  AFTER UPDATE OF 
        DDROP_CARRIER_ID
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Jul 29 12:08:22 2002 */
/* default body for TU_CAMP_DDROP_CARR */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_carrier_id;
end if;

if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 45 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_DDROP_REG
  AFTER UPDATE OF 
        DDROP_REGION_ID
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Jul 29 12:10:00 2002 */
/* default body for TU_CAMP_DDROP_REG */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 46 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_DRTV:

create or replace trigger TI_CAMP_DRTV
  AFTER INSERT
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Jul 29 11:15:11 2002 */
/* default body for TI_CAMP_DRTV */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 47 or obj_type_id is null);
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 48 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_DRTV
  AFTER DELETE
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Jul 29 11:19:19 2002 */
/* default body for TD_CAMP_DRTV */
declare numrows INTEGER;
begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 47 
      and obj_id = :old.drtv_id;
end if;

if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 48 
      and obj_id = :old.drtv_region_id;
end if;
end;
/


create or replace trigger TU_CAMP_DRTV_REG
  AFTER UPDATE OF 
        DRTV_REGION_ID
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Jul 29 11:21:37 2002 */
/* default body for TU_CAMP_DRTV_REG */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 
      and obj_type_id = 48 and obj_id = :old.drtv_region_id;
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 48 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_DRTV_ST
  AFTER UPDATE OF 
        DRTV_ID
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Jul 29 11:24:03 2002 */
/* default body for TU_CAMP_DRTV_ST */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 
      and obj_type_id = 47 and obj_id = :old.drtv_id;
end if;
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 47 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

-- updated triggers for CAMP_LEAF:

create or replace trigger TI_CAMP_LEAF
  AFTER INSERT
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:26:24 2002 */
/* default body for TI_CAMP_LEAF */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 49 or obj_type_id is null);
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 50 or obj_type_id is null);
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 51 or obj_type_id is null);
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 52 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_LEAF
  AFTER DELETE
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:29:25 2002 */
/* default body for TD_CAMP_LEAF */
declare numrows INTEGER;

begin

if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

end;
/


create or replace trigger TU_CAMP_LEAF_CP
  AFTER UPDATE OF 
        COLLECT_POINT_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:31:18 2002 */
/* default body for TU_CAMP_LEAF_CP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 51 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_LEAF_DP
  AFTER UPDATE OF 
        DISTRIB_POINT_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:38:29 2002 */
/* default body for TU_CAMP_LEAF_DP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 52 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_LEAF_LD
  AFTER UPDATE OF 
        LEAF_DISTRIB_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:39:59 2002 */
/* default body for TU_CAMP_LEAF_LD */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 50 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_LEAF_LR
  AFTER UPDATE OF 
        LEAF_REGION_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Jul 29 11:41:26 2002 */
/* default body for TU_CAMP_LEAF_LR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 49 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_POST:

create or replace trigger TI_CAMP_POST
  AFTER INSERT
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Jul 29 11:44:35 2002 */
/* default body for TI_CAMP_POST */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 55 or obj_type_id is null);
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 53 or obj_type_id is null);
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 54 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_POST
  AFTER DELETE
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Jul 29 11:46:19 2002 */
/* default body for TD_CAMP_POST */
declare numrows INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;
end;
/


create or replace trigger TU_CAMP_POST_CO
  AFTER UPDATE OF 
        CONTRACTOR_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Jul 29 11:47:51 2002 */
/* default body for TU_CAMP_POST_CO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 55 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

 
create or replace trigger TU_CAMP_POST_PS
  AFTER UPDATE OF 
        POSTER_SIZE_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Jul 29 11:48:50 2002 */
/* default body for TU_CAMP_POST_PS */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 53 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_POST_PT
  AFTER UPDATE OF 
        POSTER_TYPE_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Tue Jul 30 17:57:38 2002 */
/* default body for TU_CAMP_POST_PT */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 54 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_RADIO:

create or replace trigger TI_CAMP_RADIO
  AFTER INSERT
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Jul 29 11:51:32 2002 */
/* default body for TI_CAMP_RADIO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 56 or obj_type_id is null);
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 57 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_RADIO
  AFTER DELETE
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Jul 29 11:52:50 2002 */
/* default body for TD_CAMP_RADIO */
declare numrows INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;
end;
/


create or replace trigger TU_CAMP_RADIO_RA
  AFTER UPDATE OF 
        RADIO_ID
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Jul 29 11:53:57 2002 */
/* default body for TU_CAMP_RADIO_RA */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 56 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CAMP_RADIO_RR
  AFTER UPDATE OF 
        RADIO_REGION_ID
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Jul 29 11:54:59 2002 */
/* default body for TU_CAMP_RADIO_RR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 57 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- updated triggers for CAMP_PUB:

create or replace trigger TI_CAMP_PUB
  AFTER INSERT
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Jul 29 11:56:30 2002 */
/* default body for TI_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
         from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
         (obj_type_id = 59 or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CAMP_PUB
  AFTER DELETE
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Jul 29 11:59:10 2002 */
/* default body for TD_CAMP_PUB */
declare numrows INTEGER;

begin
if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
     and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
        and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

end;
/


create or replace trigger TU_CAMP_PUB
  AFTER UPDATE OF 
        PUB_ID,
        PUB_SEC_ID
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Jul 29 12:01:24 2002 */
/* default body for TU_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
     and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
        and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
         from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
         (obj_type_id = 59 or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


-- Modified triggers for DELIVERY_SERVER:

create or replace trigger TD_DELIVERY_SERVER
  AFTER DELETE
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Tue Jul 30 14:48:21 2002 */
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
  elsif (var_chan_type in (40,50)) then /* wireless server */
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
/* ERwin Builtin Tue Jul 30 14:48:34 2002 */
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

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
     select server_id into var_id from wireless_server where server_id = :new.server_id;

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
/* ERwin Builtin Tue Jul 30 14:48:44 2002 */
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

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
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

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
     select server_id into var_id from wireless_server where server_id = :new.server_id;

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

create or replace trigger TD_WIRELESS_INBOX
  AFTER DELETE
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Fri Sep 06 15:40:34 2002 */
/* default body for TD_WIRELESS_INBOX */
declare numrows INTEGER;
begin

delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
  ref_sub_id = :old.inbox_id and ref_indicator_id = 1 and obj_type_id = 79 and
  obj_id = :old.server_id;

end;
/


create or replace trigger TI_WIRELESS_INBOX
  AFTER INSERT
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Mon Nov 04 17:45:27 2002 */
/* default body for TI_WIRELESS_INBOX */
declare numrows INTEGER;
        var_id INTEGER;
begin

/* check that referenced wireless_server still exists */
select server_id into var_id from wireless_server where server_id = :new.server_id;

insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
  97, :new.server_id, :new.inbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
  (obj_type_id = 79 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TU_WIRELESS_INBOX
  AFTER UPDATE OF 
        SERVER_ID
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Mon Nov 04 17:45:47 2002 */
/* default body for TU_WIRELESS_INBOX */
declare numrows INTEGER;
        var_id INTEGER;
begin

delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
  ref_sub_id = :old.inbox_id and ref_indicator_id = 1 and obj_type_id = 79 and
  obj_id = :old.server_id;

/* check that referenced wireless server still exists */
select server_id into var_id from wireless_server where server_id = :new.server_id;

insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
  97, :new.server_id, :new.inbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
  (obj_type_id = 79 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create or replace trigger TD_WIRELESS_RES_RULE
  AFTER DELETE
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:43:21 2002 */
/* default body for TD_WIRELESS_RES_RULE */
declare numrows INTEGER;

begin

if :old.rule_id <> 0 then

  if (:old.global_rule_flg = 1) then
    delete from referenced_obj where ref_type_id = 0 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and ref_indicator_id = 1
      and obj_type_id = 69 and obj_id = :old.rule_id;
  else
    delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and ref_indicator_id = 1 
      and obj_type_id = 69 and obj_id = :old.rule_id;
  end if;

end if;

end;
/



create or replace trigger TI_WIRELESS_RES_RULE
  AFTER INSERT
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:43:38 2002 */
/* default body for TI_WIRELESS_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  If ( :new.global_rule_flg = 1) then
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
       0, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id from
       constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
       (obj_type_id = 69 or obj_type_id is null);
  else
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
       97, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id from
       constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
       (obj_type_id = 69 or obj_type_id is null);
  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TU_WIRELESS_RES_RULE
  AFTER UPDATE OF 
        RULE_ID
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:44:04 2002 */
/* default body for TU_WIRELESS_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.rule_id <> 0 then
  if (:old.global_rule_flg = 1) then
    delete from referenced_obj where ref_type_id = 0 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and 
      ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
  else
    delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and
      ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
  end if;
end if;

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  if (:new.global_rule_flg = 1) then
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
      0, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id
      from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
      (obj_type_id = 69 or obj_type_id is null);
  else
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
      97, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id
      from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
      (obj_type_id = 69 or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TD_CAMP_OUT_DET
  AFTER DELETE
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:00:56 2002 */
/* default body for TD_CAMP_OUT_DET */
declare numrows INTEGER;
        var_chan_type_id INTEGER;        

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

select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
    if ( var_chan_type_id = 30 ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id       
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
        obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
        obj_type_id = 97 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
end if;

if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   if ( var_chan_type_id = 30 ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
        obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then 
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
        obj_type_id = 97 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
end if;

end;
/


create or replace trigger TI_CAMP_OUT_DET
  AFTER INSERT
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:01:10 2002 */
/* default body for TI_CAMP_OUT_DET */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
 
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

select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  if ( var_chan_type_id = 30 ) then
     /* check referenced from email mailbox still exists */
     select server_id into var_id from email_mailbox where server_id = :new.from_server_id
       and mailbox_id = :new.from_mailbox_id;

     insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
       and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
     /* check referenced from wireless inbox still exists */
     select server_id into var_id from wireless_inbox where server_id = :new.from_server_id
        and inbox_id = :new.from_mailbox_id;
     
     insert into referenced_obj select 97, :new.from_server_id, :new.from_mailbox_id, null, null, null, null,
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
       and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  /* check referenced reply mailbox still exists */
  if ( var_chan_type_id = 30 ) then
     select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
       and mailbox_id = :new.reply_mailbox_id;

     insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
       and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
     select server_id into var_id from wireless_inbox where server_id = :new.reply_server_id
       and inbox_id = :new.reply_mailbox_id;

     insert into referenced_obj select 97, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null,
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27,
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
       and (obj_type_id = 97 or obj_type_id is null);                
  end if;
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
/* ERwin Builtin Tue Nov 12 17:01:20 2002 */
/* default body for TU_CAMP_OUT_DET_FM */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
begin

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
   select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;

   if (var_chan_type_id = 30 ) then  
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
       obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
   if (var_chan_type_id in (40,50) ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
       obj_type_id = 97 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
end if;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;
  if ( var_chan_type_id = 30 ) then
    /* check referenced from email mailbox still exists */
    select server_id into var_id from email_mailbox where server_id = :new.from_server_id
      and mailbox_id = :new.from_mailbox_id; 

    insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
      and (obj_type_id = 62 or obj_type_id is null);
  end if;

  if ( var_chan_type_id in (40,50) ) then
    /* check referenced from wireless inbox still exists */
    select server_id into var_id from wireless_inbox where server_id = :new.from_server_id
      and inbox_id = :new.from_mailbox_id;

    insert into referenced_obj select 97, :new.from_server_id, :new.from_mailbox_id, null, null, null, null,
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26,
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
      and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

end;
/


create or replace trigger TU_CAMP_OUT_DET_RM
  AFTER UPDATE OF 
        REPLY_SERVER_ID,
        REPLY_MAILBOX_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:01:30 2002 */
/* default body for TU_CAMP_OUT_DET_RM */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
begin
if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;
   if ( var_chan_type_id = 30 ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
       obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id 
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
       obj_type_id = 97 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;
  if ( var_chan_type_id = 30 ) then
    /* check referenced reply email mailbox still exists */
    select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
      and mailbox_id = :new.reply_mailbox_id;

    insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
      and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
    /* check referenced reply wireless inbox still exists */
    select server_id into var_id from wireless_inbox where server_id = :new.reply_server_id
      and inbox_id = :new.reply_mailbox_id;

    insert into referenced_obj select 97, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null,
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27,
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
      and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

end;
/

create or replace trigger TI_STORED_FLD_TMPL
  AFTER INSERT
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_STORED_FLD_TMPL */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create or replace trigger TU_STORED_FLD_TMPL
  AFTER UPDATE OF 
        VANTAGE_ALIAS
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_STORED_FLD_TMPL */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :old.vantage_alias is not null then
   select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
     ref_id = :old.seg_id and ref_sub_id = :old.seq_number and ref_indicator_id = 7;

   if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id and
       ref_sub_id = :old.seq_number and ref_indicator_id = 7;
   end if;
end if;

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create or replace trigger TI_SPI_PROC
  AFTER INSERT
  on SPI_PROC
   
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SPI_PROC */
declare numrows INTEGER;
        var_id INTEGER;
        var_count INTEGER;

begin
/* check that the added process is part of a task group */
select count(*) into var_count from spi_master where spi_id = :new.spi_id and spi_type_id = 4;

if var_count > 0 then
  /* check that the added object still exists */
  if :new.obj_type_id in (1,2) then  /* segment, base segment */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
  elsif :new.obj_type_id = 4 then    /* tree segment */
    select tree_id into var_id from tree_hdr where tree_id = :new.obj_id;
  elsif (:new.obj_type_id = 5 and :new.obj_id <> 0) then    /* data categorisation */
    select data_cat_id into var_id from data_cat_hdr where data_cat_id = :new.obj_id;
  elsif :new.obj_type_id = 7 then    /* data report */
    select data_rep_id into var_id from data_rep_src where data_rep_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0)
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 9 then    /* score model */
    select score_id into var_id from score_src where score_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 13 then   /* derived value */
    select derived_val_id into var_id from derived_val_src where derived_val_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 62 then   /* email mailbox */
    select mailbox_id into var_id from email_mailbox where server_id = :new.src_id and mailbox_id = :new.obj_id;
    /* for mailbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 97 then   /* wireless inbox */
    select inbox_id into var_id from wireless_inbox where server_id = :new.src_id and inbox_id = :new.obj_id;
    /* for wireless inbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id in (62,97) then
    insert into referenced_obj select :new.obj_type_id, :new.src_id, :new.obj_id, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);    
  elsif :new.obj_type_id in (7,9,13) then
    if :new.src_type_id = 4 then
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    else
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, null,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    end if;
  end if;  
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create or replace trigger TU_SPI_PROC
  AFTER UPDATE OF 
        OBJ_TYPE_ID,
        OBJ_ID
  on SPI_PROC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SPI_PROC */
declare numrows INTEGER;
        var_id INTEGER;
        var_count INTEGER;

begin

select count(*) into var_count from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
  ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;

if var_count > 0 then
  delete from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
    ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;
end if;

/* check that the added process is part of a task group */
select count(*) into var_count from spi_master where spi_id = :new.spi_id and spi_type_id = 4;

if var_count > 0 then
  /* check that the added object still exists */
  if :new.obj_type_id in (1,2) then  /* segment, base segment */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
  elsif :new.obj_type_id = 4 then    /* tree segment */
    select tree_id into var_id from tree_hdr where tree_id = :new.obj_id;
  elsif (:new.obj_type_id = 5 and :new.obj_id <> 0) then    /* data categorisation */
    select data_cat_id into var_id from data_cat_hdr where data_cat_id = :new.obj_id;
  elsif :new.obj_type_id = 7 then    /* data report */
    select data_rep_id into var_id from data_rep_src where data_rep_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0)
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 9 then    /* score model */
    select score_id into var_id from score_src where score_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 13 then   /* derived value */
    select derived_val_id into var_id from derived_val_src where derived_val_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 62 then   /* email mailbox */
    select mailbox_id into var_id from email_mailbox where server_id = :new.src_id and mailbox_id = :new.obj_id;
    /* for mailbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 97 then   /* wireless inbox */
    select inbox_id into var_id from wireless_inbox where server_id = :new.src_id and inbox_id = :new.obj_id;
    /* for wireless inbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id in (62,97) then
    insert into referenced_obj select :new.obj_type_id, :new.src_id, :new.obj_id, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);    
  elsif :new.obj_type_id in (7,9,13) then
    if :new.src_type_id = 4 then
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    else
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, null,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    end if;
  end if;  
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


spool off;

set SERVEROUT OFF
exit;
