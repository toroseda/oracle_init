prompt 'This Script creates Partitioned Communication Tables.'
prompt
prompt 'Please note that the existing Communication Tables data must be saved'
prompt 'and the relevant Communication Tables dropped prior to executing this script.'
prompt 'The saved Communication data should be inserted or imported into the new '
prompt 'tables following this script succesfull completion.'
prompt
prompt 'The effected tables are: '
prompt '			CAMP_COMM_OUT_HDR'
prompt '			CAMP_COMM_OUT_DET'
prompt '			CAMP_COMM_IN_HDR'
prompt '			CAMP_COMM_IN_DET'
prompt
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
accept ts_pv_comm prompt 'Enter Tablespace Name for Communication Tables > '
prompt
accept ts_pv_indcomm prompt 'Enter Tablespace Name for Communication Table Indexes > '
prompt
accept pdegree prompt 'Enter number of HASH partitions for Communication Tables > '
prompt
prompt

// $ProjectRevision: 1.18 $

// $Log: V3PVCommTabs.sql $
// Revision 1.3  2000/09/14 12:59:21Z  twilliamson
// Correction: re WEB_IMPRESSION.SESSION_ID modified from
// NUMBER(10) to VARCHAR2(500) omited from build 291
// Revision 1.3  2000/08/22 15:21:34Z  twilliamson
// Correction: call to V32map_camp_comms changed to map_camp_comms
// Revision 1.2  2000/08/17 18:52:40Z  twilliamson
// Entitiy SAS_SCORE_RESULT and mapping into CUST_TAB added 
// for SAS module


spool MDCreatePartCommTabs.log

SET SERVEROUT ON SIZE 20000

DECLARE

var_count 		INTEGER;
var_dtype 		VARCHAR2(30);
var_dlen 		NUMBER;
var_dprec 		NUMBER;
var_dscale 		NUMBER;
var_coltype 		VARCHAR2(40);
var_coltype2 		VARCHAR2(40);
var_main_view 		VARCHAR2(30); 
var_degree_text		VARCHAR2(10);
var_degree 		NUMBER;
var_partition 		INTEGER := 0;

err_num			NUMBER;
err_msg			VARCHAR2(100);

input_number_invalid	EXCEPTION;
comm_tabs_present       EXCEPTION;
comm_inds_present        EXCEPTION;


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

SELECT COUNT(*) into var_count from user_tables where table_name
  in ('CAMP_COMM_OUT_HDR','CAMP_COMM_OUT_DET','CAMP_COMM_IN_HDR','CAMP_COMM_IN_DET');

IF var_count > 0 THEN
   RAISE comm_tabs_present;
END IF;

SELECT COUNT(*) into var_count from user_indexes where index_name
  in ('XPKCAMP_COMM_OUT_HDR','XIE1CAMP_COMM_OUT_HDR','XPKCAMP_COMM_IN_HDR','XIE1CAMP_COMM_IN_HDR',
      'XIE1CAMP_COMM_IN_DET','XIE1CAMP_COMM_OUT_DET','XIE2CAMP_COMM_OUT_DET','XIE2CAMP_COMM_IN_DET');

IF var_count > 0 THEN
   RAISE comm_inds_present;
END IF;

SELECT VIEW_ID into var_main_view from cust_tab where db_ent_name = 'CAMP_COMM_OUT_HDR'
   and rownum = 1;

var_degree_text := '&pdegree';

SELECT DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE INTO var_dtype, var_dlen, var_dprec, var_dscale FROM PV_COLS X WHERE EXISTS (SELECT * FROM CUST_TAB WHERE VIEW_ID = var_main_view AND VANTAGE_TYPE = 1 AND DB_ENT_OWNER = X.TABLE_OWNER AND DB_ENT_NAME = X.TABLE_NAME AND STD_JOIN_FROM_COL = X.COLUMN_NAME);
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

IF ( var_degree_text IS NULL or var_degree_text = '1' ) THEN
   var_degree := 0;
ELSE
   IF var_degree_text IN ('0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50') THEN
      var_degree := to_number(var_degree_text);
   ELSE
      RAISE input_number_invalid;
   END IF;
END IF;

IF (var_degree > 1 AND var_degree < 50) THEN
	var_partition := 1;
END IF;

IF var_partition = 1 THEN
  /*** CREATE COMM. HEADER TABLES WITH PARTITIONING DEGREE AND LOCAL INDEXES ***/

  execute_sql( 'CREATE TABLE CAMP_COMM_OUT_HDR ( CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL, 
         DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL,
         COMM_STATUS_ID NUMBER(1) NOT NULL, PAR_COMM_DET_ID NUMBER(4) NOT NULL, PAR_DET_ID NUMBER(4) NOT NULL,
         VIEW_ID VARCHAR2(30) NOT NULL, COMM_QTY NUMBER(10) NOT NULL, TOTAL_COST NUMBER(12,3) NULL,
         RUN_DATE DATE NOT NULL, RUN_TIME CHAR(8) NOT NULL, KEYCODE VARCHAR2(30) NULL, 
         TREAT_QTY NUMBER(10) NOT NULL ) partition by hash (CAMP_ID, DET_ID, CAMP_CYC) 
         partitions ' || var_degree || ' TABLESPACE &ts_pv_comm' );

  execute_sql( 'CREATE UNIQUE INDEX XPKCAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR ( CAMP_ID ASC,
         VERSION_ID ASC, DET_ID ASC, CAMP_CYC ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, 
         PAR_COMM_DET_ID ASC ) local TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'CREATE INDEX XIE1CAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR ( CAMP_ID ASC,
         VERSION_ID ASC, PAR_DET_ID ASC ) local TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'ALTER TABLE CAMP_COMM_OUT_HDR ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, 
         CAMP_CYC, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID) 
         USING INDEX TABLESPACE &ts_pv_indcomm )' );

  execute_sql( 'CREATE TABLE CAMP_COMM_IN_HDR ( CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL,
         DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL,
         RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL, PAR_COMM_DET_ID NUMBER(4) NOT NULL,
         PAR_DET_ID NUMBER(4) NOT NULL, VIEW_ID VARCHAR2(30) NOT NULL, COMM_QTY NUMBER(10) NOT NULL,
         TOTAL_COST NUMBER(12,3) NULL, TOTAL_REVENUE NUMBER(12,3) NULL, RUN_DATE DATE NOT NULL, 
         RUN_TIME CHAR(8) NOT NULL, KEYCODE VARCHAR2(30) NULL )
         partition by hash (CAMP_ID, DET_ID, CAMP_CYC) partitions ' || var_degree || ' TABLESPACE &ts_pv_comm' );

  execute_sql( 'CREATE UNIQUE INDEX XPKCAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR ( CAMP_ID ASC, VERSION_ID ASC,
         DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC )
         local TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'CREATE INDEX XIE1CAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR ( CAMP_ID ASC, VERSION_ID ASC,
         PAR_DET_ID ASC ) local TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'ALTER TABLE CAMP_COMM_IN_HDR ADD ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, 
         PLACEMENT_SEQ, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID ) USING INDEX TABLESPACE &ts_pv_indcomm )');

ELSE

  execute_sql( 'CREATE TABLE CAMP_COMM_OUT_HDR ( CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL, 
         DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL,
         COMM_STATUS_ID NUMBER(1) NOT NULL, PAR_COMM_DET_ID NUMBER(4) NOT NULL, PAR_DET_ID NUMBER(4) NOT NULL,
         VIEW_ID VARCHAR2(30) NOT NULL, COMM_QTY NUMBER(10) NOT NULL, TOTAL_COST NUMBER(12,3) NULL,
         RUN_DATE DATE NOT NULL, RUN_TIME CHAR(8) NOT NULL, KEYCODE VARCHAR2(30) NULL, 
         TREAT_QTY NUMBER(10) NOT NULL ) TABLESPACE &ts_pv_comm' );

  execute_sql( 'CREATE UNIQUE INDEX XPKCAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR ( CAMP_ID ASC,
         VERSION_ID ASC, DET_ID ASC, CAMP_CYC ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, 
         PAR_COMM_DET_ID ASC ) TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'CREATE INDEX XIE1CAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR ( CAMP_ID ASC,
         VERSION_ID ASC, PAR_DET_ID ASC ) TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'ALTER TABLE CAMP_COMM_OUT_HDR ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, 
         CAMP_CYC, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID) 
         USING INDEX TABLESPACE &ts_pv_indcomm )' );

  execute_sql( 'CREATE TABLE CAMP_COMM_IN_HDR ( CAMP_ID NUMBER(8) NOT NULL, VERSION_ID NUMBER(3) NOT NULL,
         DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL,
         RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL, PAR_COMM_DET_ID NUMBER(4) NOT NULL,
         PAR_DET_ID NUMBER(4) NOT NULL, VIEW_ID VARCHAR2(30) NOT NULL, COMM_QTY NUMBER(10) NOT NULL,
         TOTAL_COST NUMBER(12,3) NULL, TOTAL_REVENUE NUMBER(12,3) NULL, RUN_DATE DATE NOT NULL, 
         RUN_TIME CHAR(8) NOT NULL, KEYCODE VARCHAR2(30) NULL ) TABLESPACE &ts_pv_comm' );

  execute_sql( 'CREATE UNIQUE INDEX XPKCAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR ( CAMP_ID ASC, VERSION_ID ASC,
         DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC )
         TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'CREATE INDEX XIE1CAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR ( CAMP_ID ASC, VERSION_ID ASC,
         PAR_DET_ID ASC ) TABLESPACE &ts_pv_indcomm' );

  execute_sql( 'ALTER TABLE CAMP_COMM_IN_HDR ADD ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, 
         PLACEMENT_SEQ, RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID ) USING INDEX TABLESPACE &ts_pv_indcomm )');

END IF;

SELECT COUNT(VANTAGE_ALIAS) INTO var_count from CUST_TAB WHERE VANTAGE_TYPE = 2;

IF var_count = 0 THEN 

  IF var_partition = 1 THEN
    /********** CREATE PARTITIONED DETAIL TABLES AND LOCAL INDEXES ***************/

       execute_sql('CREATE TABLE CAMP_COMM_IN_DET (A1 ' || var_coltype || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, COMM_REVENUE NUMBER(12,3) NULL, RES_CHANNEL_ID NUMBER(4) NOT NULL, RES_TYPE_ID NUMBER(4) NOT NULL, 
    KEYCODE VARCHAR2(30) NULL) partition by hash (CAMP_ID, DET_ID, CAMP_CYC) 
    partitions '|| var_degree ||' tablespace &ts_pv_comm');

       execute_sql('CREATE INDEX XIE1CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( A1 ASC, CAMP_ID ASC, DET_ID ASC, 
    CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC ) local TABLESPACE &ts_pv_indcomm');

       execute_sql('CREATE TABLE CAMP_COMM_OUT_DET ( A1 '|| var_coltype || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, KEYCODE VARCHAR2(30) NULL, POOL_CHAN_TYPE_ID NUMBER(3))
    partition by hash (CAMP_ID, DET_ID, CAMP_CYC) partitions '|| var_degree ||' TABLESPACE &ts_pv_comm');

       execute_sql('CREATE INDEX XIE1CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( A1 ASC, CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC,
   RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC) local TABLESPACE &ts_pv_indcomm');

  ELSE	 
       execute_sql('CREATE TABLE CAMP_COMM_IN_DET (A1 ' || var_coltype || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, COMM_REVENUE NUMBER(12,3) NULL, RES_CHANNEL_ID NUMBER(4) NOT NULL, RES_TYPE_ID NUMBER(4) NOT NULL, 
    KEYCODE VARCHAR2(30) NULL) tablespace &ts_pv_comm');

       execute_sql('CREATE INDEX XIE1CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( A1 ASC,
    CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC ) TABLESPACE &ts_pv_indcomm');

       execute_sql('CREATE TABLE CAMP_COMM_OUT_DET ( A1 '|| var_coltype || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
   DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
   PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, KEYCODE VARCHAR2(30) NULL, POOL_CHAN_TYPE_ID NUMBER(3))
   TABLESPACE &ts_pv_comm');

       execute_sql('CREATE INDEX XIE1CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( A1 ASC, CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC,
   RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC) TABLESPACE &ts_pv_indcomm');

 END IF;

ELSE
 SELECT DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE INTO var_dtype, var_dlen, var_dprec, var_dscale FROM PV_COLS X WHERE EXISTS (SELECT * FROM CUST_TAB WHERE VIEW_ID = var_main_view AND VANTAGE_TYPE = 2 AND DB_ENT_OWNER = X.TABLE_OWNER AND DB_ENT_NAME = X.TABLE_NAME AND STD_JOIN_FROM_COL = X.COLUMN_NAME);
   IF var_dtype = 'NUMBER' THEN
       IF var_dscale  = 0 THEN
		IF var_dprec = 0 THEN
			var_coltype2:= var_dtype;
		ELSE
			var_coltype2 := var_dtype || '(' || var_dprec || ')';
		END IF;
	ELSE
		var_coltype2 := var_dtype || '(' || var_dprec || ',' || var_dscale || ')';
	END IF;
  ELSE
	var_coltype2 := var_dtype || '(' || var_dlen || ')';
  END IF;

  IF var_partition = 1 THEN
    /*** CREATE PARTITIONED DETAIL TABLES AND LOCAL INDEXES ***/

      execute_sql('CREATE TABLE CAMP_COMM_IN_DET (A1 ' || var_coltype || ' NOT NULL, A2 ' || var_coltype2 || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, COMM_REVENUE NUMBER(12,3) NULL, RES_CHANNEL_ID NUMBER(4) NOT NULL, RES_TYPE_ID NUMBER(4) NOT NULL, 
    KEYCODE VARCHAR2(30) NULL) partition by hash (CAMP_ID, DET_ID, CAMP_CYC)
    partitions '|| var_degree ||' TABLESPACE &ts_pv_comm');

      execute_sql('CREATE INDEX XIE1CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( A1 ASC, A2 ASC,
    CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, 
    PAR_COMM_DET_ID) local TABLESPACE &ts_pv_indcomm');

      execute_sql('CREATE TABLE CAMP_COMM_OUT_DET ( A1 '|| var_coltype || ' NOT NULL, A2 ' || var_coltype2 || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, KEYCODE VARCHAR2(30) NULL, POOL_CHAN_TYPE_ID NUMBER(3))
    partition by hash (CAMP_ID, DET_ID, CAMP_CYC) partitions '|| var_degree ||' TABLESPACE &ts_pv_comm');

      execute_sql('CREATE INDEX XIE1CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( A1 ASC, A2 ASC, CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC,
    RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC ) local TABLESPACE &ts_pv_indcomm');

  ELSE
      execute_sql('CREATE TABLE CAMP_COMM_IN_DET (A1 ' || var_coltype || ' NOT NULL, A2 ' || var_coltype2 || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, PLACEMENT_SEQ NUMBER(4) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, COMM_REVENUE NUMBER(12,3) NULL, RES_CHANNEL_ID NUMBER(4) NOT NULL, RES_TYPE_ID NUMBER(4) NOT NULL, 
    KEYCODE VARCHAR2(30) NULL) tablespace &ts_pv_comm');

      execute_sql('CREATE INDEX XIE1CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( A1 ASC, A2 ASC,
    CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC, PLACEMENT_SEQ ASC, RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID) TABLESPACE &ts_pv_indcomm');

      execute_sql('CREATE TABLE CAMP_COMM_OUT_DET ( A1 '|| var_coltype || ' NOT NULL, A2 ' || var_coltype2 || ' NOT NULL, CAMP_ID NUMBER(8) NOT NULL,
    DET_ID NUMBER(4) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL, RUN_NUMBER VARCHAR2(200) NOT NULL, COMM_STATUS_ID NUMBER(1) NOT NULL,
    PAR_COMM_DET_ID NUMBER(4) NOT NULL, COMM_COST NUMBER(12,3) NULL, KEYCODE VARCHAR2(30) NULL, POOL_CHAN_TYPE_ID NUMBER(3))
    TABLESPACE &ts_pv_comm');

      execute_sql('CREATE INDEX XIE1CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( A1 ASC, A2 ASC, CAMP_ID ASC, DET_ID ASC, CAMP_CYC ASC,
    RUN_NUMBER ASC, COMM_STATUS_ID ASC, PAR_COMM_DET_ID ASC ) TABLESPACE &ts_pv_indcomm');
  END IF;

END IF;
   
IF var_partition = 1 THEN
  /*** CREATE PARTITIONED LOCAL INDEXES ***/
  execute_sql ('CREATE INDEX XIE2CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( CAMP_ID ASC, DET_ID ASC) local TABLESPACE &ts_pv_indcomm');
  execute_sql ('CREATE INDEX XIE2CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( CAMP_ID ASC, DET_ID ASC) local TABLESPACE &ts_pv_indcomm');
ELSE
  execute_sql ('CREATE INDEX XIE2CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( CAMP_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_indcomm');
  execute_sql ('CREATE INDEX XIE2CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( CAMP_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_indcomm');
END IF;

   execute_sql('create or replace view treat_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, 
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
      
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON CAMP_COMM_OUT_HDR TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON CAMP_COMM_OUT_DET TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON CAMP_COMM_IN_HDR TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON CAMP_COMM_IN_DET TO &md_role');
  execute_sql ('GRANT SELECT ON treat_comm_info to &md_role');
  execute_sql ('GRANT SELECT ON charac_comm_info to &md_role');
  execute_sql ('GRANT SELECT ON elem_comm_info to &md_role');

  dbms_output.put_line ('>');
  dbms_output.put_line ('Partitioned Communications Tables have been created.');
  dbms_output.put_line ('>');

EXCEPTION

	WHEN input_number_invalid THEN
                dbms_output.put_line ('>');
                dbms_output.put_line ('>');
		dbms_output.put_line ('INPUT ERROR:');
		dbms_output.put_line ('-> The entered Partitioning Degree number is invalid.');
		dbms_output.put_line ('-> The Communication tables creation process has failed.');	
		dbms_output.put_line ('-> Please run again entering a correct numeric value or ENTER for this parameter.');
                dbms_output.put_line ('>');

	WHEN comm_tabs_present THEN
		dbms_output.put_line ('>');
		dbms_output.put_line ('>');
		dbms_output.put_line ('-> Cannot proceed with creation of partitioned Communication Tables');
		dbms_output.put_line ('-> Current communication tables are present - the existing data must be saved');
                dbms_output.put_line ('-> and tables removed, before executing this script - see documentation for details');
                dbms_output.put_line ('>');

	WHEN comm_inds_present THEN
		dbms_output.put_line ('>');
		dbms_output.put_line ('>');
		dbms_output.put_line ('-> Cannot proceed with creation of partitioned Communication Tables');
		dbms_output.put_line ('-> Current communication tables indexes are present - the existing indexes must be');
                dbms_output.put_line ('-> removed, before executing this script - see documentation for details');
                dbms_output.put_line ('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Error occurred during creation of Communication Tables.' );
		err_num := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 100);
		dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/




SPOOL OFF

EXIT;

