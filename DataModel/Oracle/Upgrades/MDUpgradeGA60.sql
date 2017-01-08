prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '================================='
prompt
accept ts_pv_sys prompt 'Enter the name of Marketing Director system tables tablespace > '
prompt
accept ts_pv_ind prompt 'Enter the name of Marketing Director system indexes tablespace > '
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

spool MDUpgradeGA60.log
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

select 1 into var_count from pvdm_upgrade where version_id = '5.7.0.1300';

  dbms_output.put_line( 'Processing Schema Upgrade from V5.7.0 to V6.0');
  dbms_output.put_line( '-----------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Changes re: integration with CDM');
  dbms_output.put_line( '     - new tables: DECISION_CONFIG, DECISION_DEDUPE, DECISION_INPUT, DECISION_OUTPUT, DECISION_SRC_INPUT, SCORE_HDR');
  dbms_output.put_line( '     - modified table: SCORE_DET - SCORE_GRP_ID added (and indexed)');
  dbms_output.put_line( '     - addition of new object types in OBJ_TYPE table: Decision Logic Segment (99) and Decision Configuration (100)');
  dbms_output.put_line( '     - addition of new component type in COMP_TYPE lookup table: Decision (33)');
  dbms_output.put_line( '     - addition of new processor entries in PROC_CONTROL and PROC_PARAM for Decision Processor');
  dbms_output.put_line( 'Changed Data type for OBJ_TYPE_ID and all associated columns from NUMBER(2) to NUMBER(3)');
  dbms_output.put_line( 'Conversion of columns with LONG data type to CLOB:  SEG_HDR.SEG_CRITERIA, SEG_SQL.GENERATED_SQL'); 
  dbms_output.put_line( '       DERIVED_VAL_HDR.DERIVED_VAL_TEXT and DERIVED_VAL_SRC.GENERATED_SQL');
  dbms_output.put_line( '     - removed 2 triggers actioned on update of SEG_HDR.SEG_CRITERIA and DERIVED_VAL_HDR.DERIVED_VAL_TEXT (replaced by code)');
  dbms_output.put_line( 'Campaign Analysis views change to include Control Groups re: CQDB04002818');
  dbms_output.put_line( '     - redefinition of CAMP_COMM_OUT_SUM, CAMP_COMM_INB_SUM and CAMP_ANALYSIS');
  dbms_output.put_line( '>');

 
  execute_sql ('CREATE TABLE DECISION_CONFIG (DECISION_CONFIG_ID   NUMBER(8) NOT NULL, CONFIG_NAME VARCHAR2(50) NOT NULL, CONFIG_DESC VARCHAR2(300) NULL,
     LOGIC_NAME VARCHAR2(50) NULL, LOGIC_VERSION VARCHAR2(15) NULL, LOGIC_PATH VARCHAR2(900) NULL, LOGIC_COMP_NAME VARCHAR2(255) NULL,
     DDS_TAB_NAME VARCHAR2(128) NULL, VIEW_ID VARCHAR2(30) NOT NULL, CREATED_BY VARCHAR2(30) NOT NULL, CREATED_DATE DATE NOT NULL )
     TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKDECISION_CONFIG ON DECISION_CONFIG (DECISION_CONFIG_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DECISION_CONFIG ADD (PRIMARY KEY (DECISION_CONFIG_ID) USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE TABLE SCORE_GRP (SCORE_GRP_ID NUMBER(4) NOT NULL, SCORE_GRP_NAME VARCHAR2(50) NOT NULL, SCORE_GRP_DESC VARCHAR2(300) NULL)
     TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKSCORE_GRP ON SCORE_GRP (SCORE_GRP_ID ASC)
     TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE SCORE_GRP ADD (PRIMARY KEY (SCORE_GRP_ID) USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE TABLE DECISION_DEDUPE (SCORE_ID NUMBER(8) NOT NULL, SRC_TYPE_ID NUMBER(3) NOT NULL, SRC_ID NUMBER(8) NOT NULL,
     SRC_SUB_ID NUMBER(6) NOT NULL, PRIO_SEQ_NUMBER NUMBER(4) NOT NULL, VANTAGE_ALIAS VARCHAR2(128) NOT NULL, 
     COL_NAME VARCHAR2(128) NOT NULL, DEDUPE_PRIO_HIGH NUMBER(1) NOT NULL, NULLS_PRIO_HIGH NUMBER(1) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKDECISION_DEDUPE ON DECISION_DEDUPE (SCORE_ID ASC, SRC_TYPE_ID ASC, SRC_ID ASC,
     SRC_SUB_ID ASC, PRIO_SEQ_NUMBER ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DECISION_DEDUPE ADD (PRIMARY KEY (SCORE_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID, PRIO_SEQ_NUMBER) 
     USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE TABLE DECISION_INPUT (DECISION_CONFIG_ID NUMBER(8) NOT NULL, DDS_COL_NAME VARCHAR2(50) NOT NULL,
     INPUT_NAME VARCHAR2(128) NOT NULL, INPUT_DATATYPE VARCHAR2(12) NOT NULL, VANTAGE_ALIAS VARCHAR2(128) NOT NULL,
     COL_NAME VARCHAR2(128) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKDECISION_INPUT ON DECISION_INPUT (DECISION_CONFIG_ID ASC, DDS_COL_NAME ASC)
     TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DECISION_INPUT ADD (PRIMARY KEY (DECISION_CONFIG_ID, DDS_COL_NAME) USING INDEX
     TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE TABLE DECISION_OUTPUT (DECISION_CONFIG_ID NUMBER(8) NOT NULL, COL_NAME VARCHAR2(128) NOT NULL,
     OUTPUT_NAME VARCHAR2(128) NOT NULL, OUTPUT_DATATYPE VARCHAR2(12) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKDECISION_OUTPUT ON DECISION_OUTPUT (DECISION_CONFIG_ID ASC, COL_NAME ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DECISION_OUTPUT ADD (PRIMARY KEY (DECISION_CONFIG_ID, COL_NAME) USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql ('CREATE TABLE DECISION_SRC_INPUT (SCORE_ID NUMBER(8) NOT NULL, SRC_TYPE_ID NUMBER(3) NOT NULL, SRC_ID NUMBER(8) NOT NULL,
     SRC_SUB_ID NUMBER(6) NOT NULL, DECISION_CONFIG_ID NUMBER(8) NOT NULL, DDS_COL_NAME VARCHAR2(50) NOT NULL, DEDUPE_FLG NUMBER(1) NULL,
     STORED_FLD_SEQ NUMBER(4) NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKDECISION_SRC_IN ON DECISION_SRC_INPUT (SCORE_ID	ASC, SRC_TYPE_ID ASC, SRC_ID ASC,
     SRC_SUB_ID ASC, DECISION_CONFIG_ID ASC, DDS_COL_NAME ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DECISION_SRC_INPUT ADD (PRIMARY KEY (SCORE_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID, 
     DECISION_CONFIG_ID, DDS_COL_NAME) USING INDEX TABLESPACE &ts_pv_ind)');

  execute_sql ('ALTER TABLE SCORE_HDR ADD (SCORE_GRP_ID NUMBER(4) NULL)');
  execute_sql ('ALTER TABLE SCORE_HDR ADD (DECISION_CONFIG_ID NUMBER(8) NULL)');

  execute_sql ('CREATE INDEX XIE1SCORE_HDR ON SCORE_HDR (DECISION_CONFIG_ID ASC)
     TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE CAMP_DET MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CAMP_RES_DET MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CAMP_VERSION MODIFY (WEB_FILTER_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CONSTRAINT_SETTING MODIFY (REF_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CONSTRAINT_SETTING MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CUSTOM_ATTR MODIFY (ASSOC_OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CUSTOM_ATTR_VAL MODIFY (ASSOC_OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE DATA_REP_SRC MODIFY (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE DERIVED_VAL_SRC MODIFY (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE EV_CAMP_DET MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE EXT_TEMPL_DET MODIFY (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE LOCK_CONTROL MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE OBJ_TYPE MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE REFERENCED_OBJ MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE REFERENCED_OBJ MODIFY (OBJ_SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE REFERENCED_OBJ MODIFY (REF_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE RES_STREAM_DET MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SCORE_DET MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SCORE_SRC MODIFY (SRC_TYPE_ID NUMBER(3))');      
  execute_sql ('ALTER TABLE SEG_DEDUPE_PRIO MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SEG_GRP MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SEG_HDR MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SEG_SQL MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SPI_CAMP_PROC MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SPI_CAMP_PROC MODIFY (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SPI_PROC MODIFY (OBJ_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE SPI_PROC MODIFY (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE STORED_FLD_TEMPL MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE TREE_BASE MODIFY (ORIGIN_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE TREE_BASE MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE TREE_DET MODIFY (ORIGIN_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE TREE_DET MODIFY (SEG_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE VANTAGE_DYN_TAB MODIFY (OBJ_TYPE_ID NUMBER(3))');

  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SCORE_GRP TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_CONFIG TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_DEDUPE TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_INPUT TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_OUTPUT TO &md_role');
  execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_SRC_INPUT TO &md_role');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_TREAT_QTY, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
     SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(treat_qty), sum(comm_qty), sum(total_cost), max(camp_cyc)
     FROM CAMP_COMM_OUT_HDR WHERE COMM_STATUS_ID IN (0,1) GROUP BY camp_id, det_id');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_INB_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, CAMP_NO_OF_CYCLES)  AS
     SELECT CAMP_COMM_IN_HDR.CAMP_ID, CAMP_COMM_IN_HDR.PAR_COMM_DET_ID, sum(comm_qty), sum(total_cost), sum(total_revenue), max(camp_cyc)
     FROM CAMP_COMM_IN_HDR WHERE COMM_STATUS_ID IN (0,1) GROUP BY camp_id, par_comm_det_id');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_ANALYSIS (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, CAMP_NAME, 
     CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, CAMP_NO_OF_CYCLES, TREATMENT_ID, 
     TREATMENT_NAME, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, 
     PROJ_OUT_CYC_QTY, PROJ_OUT_QTY, PROJ_INB_CYC_QTY, PROJ_INB_QTY, PROJ_RES_RATE, PROJ_OUT_CYC_VCOST, PROJ_OUT_VCOST, PROJ_INB_CYC_VCOST, 
     PROJ_INB_VCOST, PROJ_INB_CYC_REV, PROJ_INB_REV, SEG_ACT_TREAT_QTY, SEG_ACT_OUT_QTY, SEG_ACT_OUT_VCOST, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, 
     SEG_ACT_REV, VERSION_ID, VERSION_NAME)  AS SELECT outbp.STRATEGY_ID, outbp.STRATEGY_NAME, outbp.CAMP_GRP_ID, outbp.CAMP_GRP_NAME, 
     outbp.CAMP_ID, outbp.CAMP_CODE, outbp.CAMP_NAME, outbp.CAMP_STATUS, outbp.CAMP_TEMPLATE, outbp.CAMP_TYPE, outbp.CAMP_MANAGER, 
     outbp.BUDGET_MANAGER, to_number(decode(outbp.CAMP_FIXED_COST,0,NULL,outbp.CAMP_FIXED_COST)), outbp.CAMP_START_DATE, outbc.CAMP_NO_OF_CYCLES, 
     outbp.TREATMENT_ID, outbp.TREATMENT_NAME, to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)), 
     to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), outbp.TREAT_CHAN, outbp.SEG_TYPE_ID, outbp.SEG_ID, 
     outbp.SEG_SUB_ID, outbp.SEG_NAME, outbp.SEG_KEYCODE, outbp.SEG_CONTROL_FLG, to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)), 
     to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles, 0, null,outbp.seg_proj_qty * outbc.camp_no_of_cycles)), 
     to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)), to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_res * outbc.camp_no_of_cycles)), 
     to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL,outbp.SEG_PROJ_RES_RATE)), to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL,outbp.SEG_PROJ_VAR_COST)), 
     to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)), 
     to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,null,inbp.avg_cost_per_res * outbp.seg_proj_res)), 
     to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
     to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,null,inbp.avg_rev_per_res * outbp.seg_proj_res)), 
     to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
     to_number(decode(outbc.SEG_ACT_TREAT_QTY,0,NULL,outbc.SEG_ACT_TREAT_QTY)), 
     to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,outbc.SEG_ACT_OUTB_QTY)), 
     to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL,outbc.SEG_ACT_OUTB_VCOST)), 
     to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)), 
     to_number(decode(inbc.SEG_ACT_INB_VCOST, 0,NULL,inbc.SEG_ACT_INB_VCOST)), 
     to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV)), outbp.VERSION_ID, outbp.VERSION_NAME
     FROM OUTB_PROJECTION outbp, INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc
     WHERE outbp.camp_id = inbp.camp_id (+) and outbp.seg_det_id = inbp.seg_det_id (+) and outbp.camp_id = outbc.camp_id (+)
     and outbp.seg_det_id = outbc.seg_det_id (+) and outbp.camp_id = inbc.camp_id (+) and outbp.seg_det_id = inbc.seg_det_id (+)');

  execute_sql ('GRANT SELECT ON CAMP_COMM_OUT_SUM TO &md_role');
  execute_sql ('GRANT SELECT ON CAMP_COMM_INB_SUM TO &md_role');
  execute_sql ('GRANT SELECT ON CAMP_ANALYSIS TO &md_role');

  execute_sql ('drop trigger TD_DERIVED_VAL_HDR');
  execute_sql ('drop trigger TI_DERIVED_VAL_HDR'); 
  execute_sql ('drop trigger TU_DERIVED_VAL_HAI');
  execute_sql ('drop trigger TU_DERIVED_VAL_HDR');
  execute_sql ('drop trigger TU_DERIVED_VAL_HGB');
  execute_sql ('drop trigger TU_DERIVED_VAL_HOB');
  execute_sql ('drop trigger TU_DERIVED_VAL_HTX');

  execute_sql ('alter table DERIVED_VAL_HDR drop primary key');
  
  select count(index_name) into var_count from user_indexes where index_name = 'XPKDERIVED_VAL_HDR';
  if (var_count = 1) then
	  execute_sql ('drop index xpkderived_val_hdr');
  end if;

  execute_sql ('alter table DERIVED_VAL_HDR nologging');
  execute_sql ('alter table DERIVED_VAL_HDR modify (DERIVED_VAL_TEXT CLOB) lob (DERIVED_VAL_TEXT) STORE AS (NOCACHE NOLOGGING)');
  execute_sql ('alter table DERIVED_VAL_HDR modify LOB (DERIVED_VAL_TEXT) (CACHE)');
  execute_sql ('alter table DERIVED_VAL_HDR logging');

  execute_sql ('create unique index XPKDERIVED_VAL_HDR on DERIVED_VAL_HDR (DERIVED_VAL_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('alter table DERIVED_VAL_HDR ADD (PRIMARY KEY (DERIVED_VAL_ID) USING INDEX TABLESPACE &ts_pv_ind)');

  execute_sql ('drop trigger TD_DERIVED_VAL_SRC');
  execute_sql ('drop trigger TI_DERIVED_VAL_SRC');
  execute_sql ('drop trigger TU_DERIVED_VAL_SRC');

  execute_sql ('alter table DERIVED_VAL_SRC drop primary key');

  select count(index_name) into var_count from user_indexes where index_name = 'XPKDERIVED_VAL_SRC';
  if (var_count = 1) then
	  execute_sql ('drop index xpkderived_val_src');
  end if;

  execute_sql ('alter table DERIVED_VAL_SRC nologging');
  execute_sql ('alter table DERIVED_VAL_SRC modify (GENERATED_SQL CLOB) LOB (GENERATED_SQL) STORE AS (NOCACHE NOLOGGING)');
  execute_sql ('alter table DERIVED_VAL_SRC modify LOB (GENERATED_SQL) (CACHE)');
  execute_sql ('alter table DERIVED_VAL_SRC logging');

  execute_sql ('CREATE UNIQUE INDEX XPKDERIVED_VAL_SRC ON DERIVED_VAL_SRC (DERIVED_VAL_ID ASC, SRC_TYPE_ID ASC,
     SRC_ID ASC, SRC_SUB_ID ASC )  TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE DERIVED_VAL_SRC ADD (PRIMARY KEY (DERIVED_VAL_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID)
     USING INDEX TABLESPACE &ts_pv_ind)');

  execute_sql ('drop trigger TD_SEG_HDR');
  execute_sql ('drop trigger TI_SEG_HDR');
  execute_sql ('drop trigger TU_SEG_HDR');
  execute_sql ('drop trigger TU_SEG_HDR_CRIT');

  execute_sql ('alter table SEG_HDR drop primary key');

  select count(index_name) into var_count from user_indexes where index_name = 'XPKSEG_HDR';
  if (var_count = 1) then
	  execute_sql ('drop index xpkseg_hdr');
  end if;

  execute_sql ('alter table SEG_HDR nologging');
  execute_sql ('alter table SEG_HDR modify (SEG_CRITERIA CLOB) LOB (SEG_CRITERIA) store as (NOCACHE NOLOGGING)');
  execute_sql ('alter table SEG_HDR modify LOB (SEG_CRITERIA) (CACHE)');
  execute_sql ('alter table SEG_HDR logging');

  execute_sql ('CREATE UNIQUE INDEX XPKSEG_HDR ON SEG_HDR (SEG_TYPE_ID ASC, SEG_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE SEG_HDR ADD (PRIMARY KEY (SEG_TYPE_ID, SEG_ID) USING INDEX TABLESPACE &ts_pv_ind)');

  execute_sql ('alter table SEG_SQL drop primary key');

  select count(index_name) into var_count from user_indexes where index_name = 'XPKSEG_SQL';
  if (var_count = 1) then
  	execute_sql ('drop index xpkseg_sql');
  end if;

  execute_sql ('alter table SEG_SQL nologging');
  execute_sql ('alter table SEG_SQL modify (GENERATED_SQL CLOB) LOB (GENERATED_SQL) STORE AS (NOCACHE NOLOGGING)');
  execute_sql ('alter table SEG_SQL modify LOB (GENERATED_SQL) (CACHE)');
  execute_sql ('alter table SEG_SQL LOGGING');

  execute_sql ('CREATE UNIQUE INDEX XPKSEG_SQL ON SEG_SQL (SEG_ID ASC, SEG_TYPE_ID ASC) TABLESPACE &ts_pv_ind');

  execute_sql ('ALTER TABLE SEG_SQL ADD (PRIMARY KEY (SEG_ID, SEG_TYPE_ID)
     USING INDEX TABLESPACE &ts_pv_ind)');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_SEG_DET (CAMP_ID, DET_ID, OBJ_TYPE_ID, OBJ_ID, OBJ_SUB_ID, PAR_DET_ID, NAME, VERSION_ID) 
     AS SELECT c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id
     from camp_det c, seg_hdr s where c.obj_type_id = 1 and c.obj_type_id   = s.seg_type_id and c.obj_id = s.seg_id    
     UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id    
     from camp_det c, seg_hdr s  where c.obj_type_id = 21 and s.seg_type_id = 1 and c.obj_id = s.seg_id and c.obj_sub_id = 0    
     UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id,    
     t.tree_name || ' || ''' [''' || ' || d.tree_seq ||' || '''] ''' || ' || d.node_name, c.version_id from camp_det c, tree_hdr t, 
     tree_det d  where c.obj_type_id = 4 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and c.obj_sub_id = d.tree_seq 
     UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, 
     t.tree_name || ' || ''' [''' || ' || d.tree_seq ||' || '''] ''' || ' || d.node_name, c.version_id from camp_det c, tree_hdr t, 
     tree_det d where c.obj_type_id = 21 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and  c.obj_sub_id = d.tree_seq');

  execute_sql ('CREATE OR REPLACE VIEW OUTB_PROJECTION (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, 
    CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, 
    CAMP_START_DATE, TREATMENT_ID, TREATMENT_NAME, TREAT_DET_ID, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, 
    SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_DET_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, SEG_PROJ_QTY, 
    SEG_PROJ_RES_RATE, SEG_PROJ_RES, SEG_PROJ_VAR_COST, VERSION_ID, VERSION_NAME)  
    AS SELECT max(strat.strategy_id), max(strat.strategy_name), max(camp.camp_grp_id), max(cgrp.camp_grp_name), 
    max(ctdet.camp_id), max(camp.camp_code), max(camp.camp_name), max(dhcs.status_setting_id), 
    max(camp.camp_templ_id), max(ctype.camp_type_name), max(cmgr.manager_name), max(cbmgr.manager_name), 
    max(dhcfc.cost_per_seg), max(camp.start_date), max(ctdet.obj_id), max(treat.treatment_name), max(ctdet.det_id), 
    sum(elem.var_cost/elem.var_cost_qty), max(dhtfc.cost_per_seg), max(chntype.chan_type_id), 
    max(csdet.obj_type_id), max(csdet.obj_id), max(csdet.obj_sub_id), max(csdet.det_id), max(csdet.name), 
    max(cseg.keycode), max(cseg.control_flg), max(cseg.proj_qty), max(cseg.proj_res_rate)/100, 
    max(cseg.proj_res_rate)/100 * max(cseg.proj_qty), sum(elem.var_cost/elem.var_cost_qty) * max(cseg.proj_qty), 
    max(ctdet.version_id), max(campver.version_name) FROM CAMP_GRP cgrp, STRATEGY strat, CAMPAIGN camp, 
    CAMP_VERSION campver, CAMP_TYPE ctype, CAMP_MANAGER cmgr, CAMP_MANAGER cbmgr, CAMP_DET ctdet, CAMP_SEG_DET csdet, 
    TREATMENT treat, TELEM telem, ELEM elem, TREATMENT_GRP tgrp, CHAN_TYPE chntype, SEG_HDR seghd, CAMP_SEG cseg, 
    CAMP_SEG_COST dhcfc, TREAT_SEG_COST dhtfc, CAMP_STATUS dhcs
    WHERE strat.strategy_id = cgrp.strategy_id and cgrp.camp_grp_id = camp.camp_grp_id
    and camp.camp_type_id = ctype.camp_type_id (+) and camp.camp_id = dhcs.camp_id 
    and camp.camp_id = dhcfc.camp_id (+) and camp.camp_id = campver.camp_id
    and campver.manager_id = cmgr.manager_id (+) and campver.budget_manager_id = cbmgr.manager_id (+) 
    and campver.camp_id = ctdet.camp_id and campver.version_id = ctdet.version_id
    and csdet.camp_id = ctdet.camp_id and csdet.version_id = ctdet.version_id 
    and csdet.par_det_id = ctdet.det_id and csdet.obj_type_id = seghd.seg_type_id (+) 
    and csdet.obj_id = seghd.seg_id (+) and csdet.camp_id = cseg.camp_id (+) 
    and csdet.version_id = cseg.version_id (+) and csdet.det_id = cseg.det_id (+) 
    and csdet.obj_type_id in (1,4,21) and ctdet.camp_id = dhtfc.camp_id (+) 
    and ctdet.det_id = dhtfc.treat_det_id (+) and ctdet.obj_id = treat.treatment_id
    and treat.treatment_id = telem.treatment_id (+) and telem.elem_id = elem.elem_id (+) 
    and treat.treatment_grp_id = tgrp.treatment_grp_id and tgrp.chan_type_id = chntype.chan_type_id 
    GROUP BY csdet.camp_id, csdet.det_id, csdet.version_id');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_ANALYSIS (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, 
    CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, 
    CAMP_NO_OF_CYCLES, TREATMENT_ID, TREATMENT_NAME, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, 
    SEG_SUB_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, PROJ_OUT_CYC_QTY, PROJ_OUT_QTY, PROJ_INB_CYC_QTY, PROJ_INB_QTY, 
    PROJ_RES_RATE, PROJ_OUT_CYC_VCOST, PROJ_OUT_VCOST, PROJ_INB_CYC_VCOST, PROJ_INB_VCOST, PROJ_INB_CYC_REV, PROJ_INB_REV, 
    SEG_ACT_TREAT_QTY, SEG_ACT_OUT_QTY, SEG_ACT_OUT_VCOST, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, VERSION_ID, VERSION_NAME) 
    AS SELECT outbp.STRATEGY_ID, outbp.STRATEGY_NAME, outbp.CAMP_GRP_ID, outbp.CAMP_GRP_NAME, outbp.CAMP_ID, outbp.CAMP_CODE, 
    outbp.CAMP_NAME, outbp.CAMP_STATUS, outbp.CAMP_TEMPLATE, outbp.CAMP_TYPE, outbp.CAMP_MANAGER, outbp.BUDGET_MANAGER, 
    to_number(decode(outbp.CAMP_FIXED_COST,0,NULL,outbp.CAMP_FIXED_COST)), outbp.CAMP_START_DATE, outbc.CAMP_NO_OF_CYCLES, 
    outbp.TREATMENT_ID, outbp.TREATMENT_NAME, to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)), 
    to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), outbp.TREAT_CHAN, outbp.SEG_TYPE_ID, 
    outbp.SEG_ID, outbp.SEG_SUB_ID, outbp.SEG_NAME, outbp.SEG_KEYCODE, outbp.SEG_CONTROL_FLG, 
    to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)), 
    to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles, 0, null,outbp.seg_proj_qty * outbc.camp_no_of_cycles)), 
    to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)), 
    to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_res * outbc.camp_no_of_cycles)), 
    to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL,outbp.SEG_PROJ_RES_RATE)), 
    to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL,outbp.SEG_PROJ_VAR_COST)), 
    to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)), 
    to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,null,inbp.avg_cost_per_res * outbp.seg_proj_res)), 
    to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
    to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,null,inbp.avg_rev_per_res * outbp.seg_proj_res)), 
    to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
    to_number(decode(outbc.SEG_ACT_TREAT_QTY,0,NULL,outbc.SEG_ACT_TREAT_QTY)), 
    to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,outbc.SEG_ACT_OUTB_QTY)), 
    to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL,outbc.SEG_ACT_OUTB_VCOST)), 
    to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)), 
    to_number(decode(inbc.SEG_ACT_INB_VCOST, 0,NULL,inbc.SEG_ACT_INB_VCOST)), 
    to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV)), outbp.VERSION_ID, outbp.VERSION_NAME FROM OUTB_PROJECTION outbp, 
    INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc WHERE outbp.camp_id = inbp.camp_id (+)
    and outbp.seg_det_id = inbp.seg_det_id (+) and outbp.camp_id = outbc.camp_id (+) and outbp.seg_det_id = outbc.seg_det_id (+)
    and outbp.camp_id = inbc.camp_id (+) and outbp.seg_det_id = inbc.seg_det_id (+)');

  execute_sql ('grant SELECT on CAMP_SEG_DET to &md_role');
  execute_sql ('grant SELECT on OUTB_PROJECTION to &md_role');
  execute_sql ('grant SELECT on CAMP_ANALYSIS to &md_role');

  insert into obj_type values (99, 'Decision Logic Segment', 'DL');
  insert into obj_type values (100, 'Decision Configuration', NULL);
  COMMIT;

  insert into vantage_ent values ('DECISION_CONFIG',1,0);
  insert into vantage_ent values ('DECISION_DEDUPE',1,0);
  insert into vantage_ent values ('DECISION_INPUT',1,0);
  insert into vantage_ent values ('DECISION_OUTPUT',1,0);
  insert into vantage_ent values ('DECISION_SRC_INPUT',1,0);
  insert into vantage_ent values ('SCORE_GRP',1,0);
  COMMIT;

  insert into proc_control select 'Decision Processor', null, 1, 'v_decisionproc', location, 17 from proc_control
	where proc_name = 'Score Model';

  insert into proc_param values ('Decision Processor',0,'Server executable name','v_decisionproc');
  insert into proc_param values ('Decision Processor',1,'Call Type',null );
  insert into proc_param values ('Decision Processor',2,'RPC Id / SPI Audit Id',null );
  insert into proc_param values ('Decision Processor',3,'Process Audit Id',null );
  insert into proc_param values ('Decision Processor',4,'Secure Database Account Name',null );
  insert into proc_param values ('Decision Processor',5,'Secure Database Password',null );
  insert into proc_param values ('Decision Processor',6,'Customer Data View Id',null );
  insert into proc_param values ('Decision Processor',7,'User Id',null );
  insert into proc_param values ('Decision Processor',8,'Database Vendor Id',null );
  insert into proc_param values ('Decision Processor',9,'Database Connection String',null );
  insert into proc_param values ('Decision Processor',10,'Language Id',null );
  insert into proc_param values ('Decision Processor',11,'Score Model Id',null );
  insert into proc_param values ('Decision Processor',12,'Source Type',null );
  insert into proc_param values ('Decision Processor',13,'Source Id',null );
  insert into proc_param values ('Decision Processor',14,'Tree Sub-Source Id',null );
  insert into proc_param values ('Decision Processor',15,'Decision Logic Operation',null );
  insert into proc_param values ('Decision Processor',16,'Decision Batch Id', null);
  COMMIT;

  insert into comp_type values (35, 'Decision');
  COMMIT;

  update pvdm_upgrade set version_id = '6.0.0.1312';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The V5.7.0 Marketing Director schema has been upgraded to V6.0');
  dbms_output.put_line( '> (Note, that some associated triggers will now be re-applied)' );
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure error occurred.' );
		err_num := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 100);
		dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/


create or replace trigger TD_DERIVED_VAL_HDR
  AFTER DELETE
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DERIVED_VAL_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if ((:old.where_seg_id is not null) and (:old.where_seg_id <> 0)) then
   delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 1 and obj_type_id = 15 and obj_id = :old.where_seg_id;
end if;

/* delete any references in DERIVED_VAL_TEXT, GROUP_BY, ORDER_BY AND ADDL_INFO columns, created by parser */
select count(*) into var_count from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id
   and ref_indicator_id in (16, 17, 18, 19);

if var_count > 0 then
  delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and 
    ref_indicator_id in (16, 17, 18, 19);
end if;

end;
/

create or replace trigger TI_DERIVED_VAL_HDR
  AFTER INSERT
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DERIVED_VAL_HDR */
declare numrows INTEGER;
         var_id INTEGER;

begin

if ((:new.where_seg_id is not null) and (:new.where_seg_id <> 0)) then
   /* check referenced derived value criteria exists */
   select seg_id into var_id from seg_hdr where seg_type_id = 15 and seg_id = :new.where_seg_id;

   insert into referenced_obj select 15, :new.where_seg_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 13 and ref_indicator_id = 1 and (obj_type_id = 13 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_DERIVED_VAL_HAI
  AFTER UPDATE OF 
        ADDL_INFO
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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

create or replace trigger TU_DERIVED_VAL_HDR
  AFTER UPDATE OF 
        WHERE_SEG_ID
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DERIVED_VAL_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if ((:old.where_seg_id is not null) and (:old.where_seg_id <> 0)) then
   delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 1 and obj_type_id = 15 and obj_id = :old.where_seg_id;
end if;

if ((:new.where_seg_id is not null) and (:new.where_seg_id <> 0)) then
   /* check referenced derived value criteria exists */
   select seg_id into var_id from seg_hdr where seg_type_id = 15 and seg_id = :new.where_seg_id;

   insert into referenced_obj select 15, :new.where_seg_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 13 and ref_indicator_id = 1 and (obj_type_id = 13 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create or replace trigger TU_DERIVED_VAL_HGB
  AFTER UPDATE OF 
        GROUP_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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

create or replace trigger TD_DERIVED_VAL_SRC
  AFTER DELETE
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DERIVED_VAL_SRC */
declare numrows INTEGER;
begin
if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;
end;
/


create or replace trigger TI_DERIVED_VAL_SRC
  AFTER INSERT
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DERIVED_VAL_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin
if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_DERIVED_VAL_SRC
  AFTER UPDATE OF 
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DERIVED_VAL_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;

if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_SEG_HDR
  AFTER DELETE
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TD_SEG_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if (:old.seg_grp_id is not null and :old.seg_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id
    and ref_indicator_id = 1 and obj_type_id = 73 and obj_id = :old.seg_grp_id 
    and obj_sub_id = :old.seg_type_id;
end if;   

select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
  ref_id = :old.seg_id and ref_indicator_id = 16;

if var_count > 0 then
   delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id 
     and ref_indicator_id = 16;
end if;

end;
/


create or replace trigger TI_SEG_HDR
  AFTER INSERT
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TI_SEG_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.seg_grp_id is not null and :new.seg_grp_id <> 0) then
  /* check that the referenced segment group still exists */
  select seg_grp_id into var_id from seg_grp where seg_type_id = :new.seg_type_id and
    seg_grp_id = :new.seg_grp_id;

  insert into referenced_obj select 73, :new.seg_grp_id, :new.seg_type_id, null, null, null, null,
    :new.seg_type_id, :new.seg_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = :new.seg_type_id and ref_indicator_id = 1 
    and (obj_type_id = 73 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_SEG_HDR
  AFTER UPDATE OF 
        SEG_GRP_ID
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_SEG_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.seg_grp_id is not null and :old.seg_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id
    and ref_indicator_id = 1 and obj_type_id = 73 and obj_id = :old.seg_grp_id
    and obj_sub_id = :old.seg_type_id;
end if;  

if (:new.seg_grp_id is not null and :new.seg_grp_id <> 0) then
  /* check that the referenced segment group still exists */
  select seg_grp_id into var_id from seg_grp where seg_type_id = :new.seg_type_id and
    seg_grp_id = :new.seg_grp_id;

  insert into referenced_obj select 73, :new.seg_grp_id, :new.seg_type_id, null, null, null, null,
    :new.seg_type_id, :new.seg_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = :new.seg_type_id and ref_indicator_id = 1 
    and (obj_type_id = 73 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


spool off;
exit;
