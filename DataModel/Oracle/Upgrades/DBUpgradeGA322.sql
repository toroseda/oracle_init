prompt
prompt
prompt 'V3.2.2 Marketing Director Schema Upgrade'
prompt '========================================'
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
accept ts_pv_indcomm prompt 'Enter the name of tablespace for Marketing Director Communication Indexes > '
prompt

spool DBUpgradeGA322.log
set SERVEROUT ON SIZE 20000

DECLARE

var_count  NUMBER(4):= 0;
cid INTEGER;

var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_pv_owner varchar2(128);


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

select 1 into var_count from pvdm_upgrade where version_id = '3.2.379.1';

	dbms_output.put_line( 'Processing Schema Upgrade from V3.2.0 to V3.2.1');
	dbms_output.put_line( '--------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '      - correction: Value CAMP_REP_COL.COL_FORMAT_ID for entries 48,49 changed to 5');
	dbms_output.put_line( '      - correction: SMS_RES.STRING_7 changed to VARCHAR2(40)');
	dbms_output.put_line( '      - correction: pre-populated values in TON_TYPE for entries 1 and 2 swapped');
	dbms_output.put_line( '   Amendments re: new functionality - Treatment Pools:- ' ); 
	dbms_output.put_line( '      - added TREATMENT_POOL_FLG to CAMP_TREAT_DET');
	dbms_output.put_line( '      - added TREAT_QTY to CAMP_COMM_OUT_HDR' );
	dbms_output.put_line( '	     - added POOL_CHAN_TYPE_ID to CAMP_COMM_OUT_DET' );
	dbms_output.put_line( '   Amendment re: new pasword encryption functionality:- ' ); 
	dbms_output.put_line( '      - extend EMAIL_MAILBOX.MAILBOX_PASSWORD size to VARCHAR2(70)');
	dbms_output.put_line( '   Amendments for Campaign Analysis re: Treatment Pool functionality' );
	dbms_output.put_line( '	     	- lookup values in CAMP_REP_COL' ); 
 	dbms_output.put_line( '		- modify table CAMP_REP_COL adding COL_SEQ for display ordering' );
	dbms_output.put_line( '      	- modify views CAMP_COMM_OUT_SUM, CAMP_ANALYSIS' );
	dbms_output.put_line( '	  Additions to Component Type list of values');
	dbms_output.put_line( '	  Addition of Indexes to support Campaign Communication Views ');
	dbms_output.put_line( '	  Addition of Extra Campaign Communication Views allowing ' );
	dbms_output.put_line( '		interrogation through Element, Treatment, Channel and Campaign fields.' );
	dbms_output.put_line( '>');

	--
	-- correction of entries 48, 49 in CAMP_REP_COL
	--
	update CAMP_REP_COL set COL_FORMAT_ID = 5 where CAMP_REP_COL_ID in (48,49);
	COMMIT;

	--
	-- correction of SMS STRING_7 data type length
	--
	execute_sql ('ALTER TABLE SMS_RES MODIFY (STRING_7 VARCHAR2(40))');
	COMMIT;

	--
	-- correction of entries in TON_TYPE - swap of entries 1 and 2
	--
	update TON_TYPE set TON_NAME = 'International' where TON = 1;
	update TON_TYPE set TON_NAME = 'National' where TON = 2;
	COMMIT;

	--
	-- Amendments re: new functionality - Treatment Pools
	--
	execute_sql( 'ALTER TABLE CAMP_TREAT_DET ADD (TREATMENT_POOL_FLG NUMBER(1) DEFAULT 0 NOT NULL)' );
	execute_sql( 'ALTER TABLE CAMP_TREAT_DET MODIFY (TREATMENT_POOL_FLG DEFAULT NULL)' );

	execute_sql( 'ALTER TABLE CAMP_COMM_OUT_HDR ADD (TREAT_QTY NUMBER(10) DEFAULT 0 NOT NULL)' );
	execute_sql( 'ALTER TABLE CAMP_COMM_OUT_HDR MODIFY (TREAT_QTY DEFAULT NULL)' );

	execute_sql( 'ALTER TABLE CAMP_COMM_OUT_DET ADD (POOL_CHAN_TYPE_ID NUMBER(3))' );
	COMMIT;

	--
	-- Amendment re: new functionality for Password encryption
	--
	execute_sql( 'ALTER TABLE EMAIL_MAILBOX MODIFY (MAILBOX_PASSWORD VARCHAR2(70))' );

	--
	-- Further amendments re: Treatment Pools - impact in Campaign Analysis Module
	--
	update CAMP_REP_COL set COL_NAME = 'Actual Outbound Treatment Quantity', COL_SQL = 'SEG_ACT_TREAT_QTY' where CAMP_REP_COL_ID = 38;
	update CAMP_REP_COL set COL_NAME = 'Actual Treatment Response Rate', COL_SQL = '(SEG_ACT_INB_QTY / SEG_ACT_TREAT_QTY) AS ACT_TREAT_RES_RATE' where CAMP_REP_COL_ID = 48;
	COMMIT;
	
	execute_sql ('ALTER TABLE CAMP_REP_COL ADD (COL_SEQ NUMBER(3) DEFAULT 0 NOT NULL)');

	execute_sql ('CREATE INDEX XIE1CAMP_REP_COL ON CAMP_REP_COL(COL_SEQ ASC) tablespace &ts_pv_ind');

	execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_TREAT_QTY, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
       		SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(treat_qty), sum(comm_qty), sum(total_cost), max(camp_cyc)
       		FROM CAMP_COMM_OUT_HDR
       		GROUP BY camp_id, det_id');
	
	execute_sql ('CREATE OR REPLACE VIEW CAMP_ANALYSIS (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, CAMP_NO_OF_CYCLES, TREATMENT_ID, TREATMENT_NAME, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, PROJ_OUT_CYC_QTY, PROJ_OUT_QTY, PROJ_INB_CYC_QTY, PROJ_INB_QTY, PROJ_RES_RATE, PROJ_OUT_CYC_VCOST, PROJ_OUT_VCOST, PROJ_INB_CYC_VCOST, PROJ_INB_VCOST, PROJ_INB_CYC_REV, PROJ_INB_REV, SEG_ACT_TREAT_QTY, SEG_ACT_OUT_QTY, SEG_ACT_OUT_VCOST, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV)  AS
       		SELECT outbp.STRATEGY_ID, outbp.STRATEGY_NAME, outbp.CAMP_GRP_ID, outbp.CAMP_GRP_NAME, outbp.CAMP_ID, outbp.CAMP_CODE, outbp.CAMP_NAME, outbp.CAMP_STATUS, outbp.CAMP_TEMPLATE, outbp.CAMP_TYPE, outbp.CAMP_MANAGER, outbp.BUDGET_MANAGER, to_number(decode(outbp.CAMP_FIXED_COST,0,NULL,outbp.CAMP_FIXED_COST)), outbp.CAMP_START_DATE, outbc.CAMP_NO_OF_CYCLES, outbp.TREATMENT_ID, outbp.TREATMENT_NAME, to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)), to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), outbp.TREAT_CHAN, outbp.SEG_TYPE_ID, outbp.SEG_ID, outbp.SEG_SUB_ID, outbp.SEG_NAME, outbp.SEG_KEYCODE, outbp.SEG_CONTROL_FLG, to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)), to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles, 0, null,outbp.seg_proj_qty * outbc.camp_no_of_cycles)), to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)), to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_res * outbc.camp_no_of_cycles)), to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL,outbp.SEG_PROJ_RES_RATE)), to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL,outbp.SEG_PROJ_VAR_COST)), to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)), to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,null,inbp.avg_cost_per_res * outbp.seg_proj_res)), to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,null,inbp.avg_rev_per_res * outbp.seg_proj_res)), to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), to_number(decode(outbc.SEG_ACT_TREAT_QTY,0,NULL,outbc.SEG_ACT_TREAT_QTY)), to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,outbc.SEG_ACT_OUTB_QTY)), to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL,outbc.SEG_ACT_OUTB_VCOST)), to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)), to_number(decode(inbc.SEG_ACT_INB_VCOST, 0,NULL,inbc.SEG_ACT_INB_VCOST)), to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV))
       		FROM OUTB_PROJECTION outbp, INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc
       		WHERE outbp.camp_id = inbp.camp_id (+)
		and outbp.seg_det_id = inbp.seg_det_id (+)
		and outbp.camp_id = outbc.camp_id (+)
		and outbp.seg_det_id = outbc.seg_det_id (+)
		and outbp.camp_id = inbc.camp_id (+)
		and outbp.seg_det_id = inbc.seg_det_id (+)');

	-- 
	-- Additions to Component Type list of values
	--

        insert into comp_type values (25,'Segment Name');
        insert into comp_type values (26,'Parent Node ID');
        insert into comp_type values (27,'Parent Communication Node ID');
        COMMIT;

	--
	-- Addition of Indexes to support Campaign Communication Views
	--

	execute_sql ('CREATE INDEX XIE1CAMPAIGN ON CAMPAIGN (CAMP_TYPE_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1CAMP_STATUS_HIST ON CAMP_STATUS_HIST (STATUS_SETTING_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE TCHARAC DROP PRIMARY KEY');
	execute_sql ('CREATE UNIQUE INDEX XPKTCHARAC ON TCHARAC (CHARAC_ID ASC, TREATMENT_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE TCHARAC ADD PRIMARY KEY (CHARAC_ID, TREATMENT_ID) USING INDEX');
	execute_sql ('CREATE UNIQUE INDEX XAK1TCHARAC ON TCHARAC (TREATMENT_ID ASC, CHARAC_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE TELEM DROP PRIMARY KEY');
	execute_sql ('CREATE UNIQUE INDEX XPKTELEM ON TELEM (ELEM_ID ASC, TREATMENT_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE TELEM ADD PRIMARY KEY (ELEM_ID, TREATMENT_ID) USING INDEX');
	execute_sql ('CREATE UNIQUE INDEX XAK1TELEM ON TELEM (TREATMENT_ID ASC, ELEM_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1CAMP_DET ON CAMP_DET (CAMP_ID ASC, PAR_DET_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE2CAMP_DET ON CAMP_DET (OBJ_TYPE_ID ASC, OBJ_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE3CAMP_DET ON CAMP_DET (OBJ_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1TREATMENT ON TREATMENT (TREATMENT_GRP_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1TREATMENT_GRP ON TREATMENT_GRP (CHAN_TYPE_ID ASC) TABLESPACE &ts_pv_ind');
	
	execute_sql ('CREATE INDEX XIE2CAMP_COMM_OUT_DET ON CAMP_COMM_OUT_DET ( CAMP_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_indcomm');
        execute_sql ('CREATE INDEX XIE2CAMP_COMM_IN_DET ON CAMP_COMM_IN_DET ( CAMP_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_indcomm');

	execute_sql ('analyze table TREATMENT estimate statistics');
	execute_sql ('analyze table TREATMENT_GRP estimate statistics');
	execute_sql ('analyze table CHARAC estimate statistics');
	execute_sql ('analyze table TCHARAC estimate statistics');
	execute_sql ('analyze table ELEM estimate statistics');
	execute_sql ('analyze table TELEM estimate statistics');
	execute_sql ('analyze table CAMPAIGN estimate statistics');
	execute_sql ('analyze table CAMP_TYPE estimate statistics');
	execute_sql ('analyze table CAMP_DET estimate statistics');
	execute_sql ('analyze table CAMP_STATUS_HIST estimate statistics');
	execute_sql ('analyze table RES_TYPE estimate statistics');
	execute_sql ('analyze table RES_CHANNEL estimate statistics');
	execute_sql ('analyze table RES_CHANNEL estimate statistics');
	execute_sql ('analyze table CAMP_COMM_OUT_DET estimate statistics');
	execute_sql ('analyze table CAMP_COMM_OUT_HDR estimate statistics');
	execute_sql ('analyze table CAMP_COMM_IN_DET estimate statistics');
	execute_sql ('analyze table CAMP_COMM_IN_HDR estimate statistics');

	--
	-- Changes for Extra Campaign Communications
	--

   execute_sql ('create or replace view treat_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, manager_id, budget_manager_id, 
 camp_type_id, camp_type_name, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id,
 camp_cyc, comm_status_id, sent_date, keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id,
 chan_type_name, email_type_id, email_subject, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id)
 as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, 
 camp_comm_out_det.comm_status_id, camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id, treatment.treatment_name,
 treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id,
 treatment.email_subject, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
 camp_comm_in_hdr.run_date, camp_comm_in_det.det_id 
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET, CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR,
 CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL
 where CAMP_COMM_OUT_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_DET_1.CAMP_ID AND 
 CAMP_COMM_OUT_DET.DET_ID = CAMP_DET_1.DET_ID AND CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND
 TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND
 CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND
 CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND 
 CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND
 CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND
 CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND 
 CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
 CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND
 RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID 
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
 treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
 res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id 
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,	
 CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND 
 CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND 
 CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND 
 TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
 CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
 CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
 CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND 
 RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID 
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, 
 treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, camp_comm_in_det.res_type_id, 
 res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id 
 from CAMPAIGN CAMPAIGN,	CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,
 CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND 
 CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID AND 
 CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID 
 AND CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND 
 CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND 
 CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND 
 RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID');
	
   execute_sql ('create or replace view charac_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, manager_id, budget_manager_id, camp_type_id,
 camp_type_name, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id, camp_cyc, comm_status_id, sent_date,
 keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id, chan_type_name, email_type_id, email_subject, charac_id,
 charac_grp_id, charac_name, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id) 
 as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, camp_comm_out_det.comm_status_id,
 camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, 
 treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, charac.charac_id,
 charac.charac_grp_id, charac.charac_name, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, 
 res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET,
 CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR, CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL
 where CAMP_COMM_OUT_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_COMM_OUT_DET.DET_ID = CAMP_DET_1.DET_ID 
 AND CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID AND
 TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND
 TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID AND CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND
 CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND 
 CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND
 CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND
 CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND 
 CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND
 CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND
 RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID	
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, 
 treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject, 
 charac.charac_id, charac.charac_grp_id, charac.charac_name, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, 
 res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, 
 CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID 
 AND CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND
 TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
 CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID AND
 CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND 
 RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID 
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, 
 treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject,
 charac.charac_id, charac.charac_grp_id, charac.charac_name, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id,
 res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id 
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TCHARAC TCHARAC, CHARAC CHARAC, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, 
 CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID 
 AND CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID 
 AND CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND
 TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND
 TREATMENT.TREATMENT_ID = TCHARAC.TREATMENT_ID (+) AND TCHARAC.CHARAC_ID = CHARAC.CHARAC_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND
 CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND
 RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID');

     execute_sql ('create or replace view elem_comm_info (a1, camp_id, camp_code, camp_grp_id, camp_name, manager_id, budget_manager_id,
 camp_type_id, camp_type_name, camp_start_date, camp_start_time, est_end_date, view_id, camp_status_id, camp_status_name, det_id, 
 camp_cyc, comm_status_id, sent_date, keycode, treatment_id, treatment_name, treatment_grp_id, treatment_grp_name, chan_type_id, 
 chan_type_name, email_type_id, email_subject, elem_id, elem_name, content, content_filename, content_formt_id, content_length, 
 elem_grp_id, message_type_id, var_cost, var_cost_qty, res_type_id, res_type_name, res_channel_id, res_channel_name, response_date, res_det_id )
 as select camp_comm_out_det.a1, camp_comm_out_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, camp_comm_out_det.det_id, camp_comm_out_det.camp_cyc, 
 camp_comm_out_det.comm_status_id, camp_comm_out_hdr.run_date, camp_comm_out_det.keycode, treatment.treatment_id,	treatment.treatment_name,
 treatment_grp.treatment_grp_id, treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id,
 treatment.email_subject, elem.elem_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, elem.content_length,
 elem.elem_grp_id, elem.message_type_id, elem.var_cost, elem.var_cost_qty, camp_comm_in_det.res_type_id, res_type.res_type_name, 
 camp_comm_in_det.res_channel_id, res_channel.res_channel_name, camp_comm_in_hdr.run_date, camp_comm_in_det.det_id
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_2, CAMP_DET CAMP_DET_1, CAMP_COMM_OUT_DET CAMP_COMM_OUT_DET, 
 CAMP_COMM_OUT_HDR CAMP_COMM_OUT_HDR, CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, RES_CHANNEL RES_CHANNEL
 where CAMP_COMM_OUT_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND 
 CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_COMM_OUT_DET.CAMP_ID = CAMP_DET_1.CAMP_ID AND 
 CAMP_COMM_OUT_DET.DET_ID = CAMP_DET_1.DET_ID AND CAMP_DET_2.CAMP_ID = CAMP_DET_1.CAMP_ID AND CAMP_DET_2.DET_ID = CAMP_DET_1.PAR_DET_ID AND
 TREATMENT.TREATMENT_ID = CAMP_DET_2.OBJ_ID  AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
 CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID AND
 CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID AND CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID AND 
 CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC AND CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER AND 
 CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID AND CAMP_COMM_OUT_DET.A1 = CAMP_COMM_IN_DET.A1 (+) AND
 CAMP_COMM_OUT_DET.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID (+) AND CAMP_COMM_OUT_DET.DET_ID = CAMP_COMM_IN_DET.PAR_COMM_DET_ID (+) AND 
 CAMP_COMM_OUT_DET.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC (+) AND CAMP_COMM_OUT_DET.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID (+) AND
 RES_TYPE.RES_TYPE_ID(+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND CAMP_COMM_IN_HDR.CAMP_ID (+) = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_COMM_IN_HDR.DET_ID (+)= CAMP_COMM_IN_DET.DET_ID AND CAMP_COMM_IN_HDR.CAMP_CYC (+) = CAMP_COMM_IN_DET.CAMP_CYC AND 
 CAMP_COMM_IN_HDR.PLACEMENT_SEQ (+) = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND CAMP_COMM_IN_HDR.RUN_NUMBER (+) = CAMP_COMM_IN_DET.RUN_NUMBER AND 
 CAMP_COMM_IN_HDR.COMM_STATUS_ID (+)= CAMP_COMM_IN_DET.COMM_STATUS_ID AND RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID	
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER(NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, 
 treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject,
 elem.elem_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, elem.content_length, elem.elem_grp_id, elem.message_type_id,
 elem.var_cost, elem.var_cost_qty, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
 camp_comm_in_hdr.run_date, camp_comm_in_det.det_id
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR,
 CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND
 CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID 
 AND CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_3.OBJ_TYPE_ID = 18 AND
 TREATMENT.TREATMENT_ID = CAMP_DET_IN_3.OBJ_ID AND TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND 
 CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID AND
 CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND
 RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID
 union all select camp_comm_in_det.a1, camp_comm_in_det.camp_id, campaign.camp_code, campaign.camp_grp_id, campaign.camp_name, campaign.manager_id,
 campaign.budget_manager_id, campaign.camp_type_id, camp_type.camp_type_name, campaign.start_date, campaign.start_time, campaign.est_end_date,
 campaign.view_id, csh.status_setting_id, status_setting.status_name, TO_NUMBER (NULL), camp_comm_in_det.camp_cyc, camp_comm_in_det.comm_status_id,
 TO_DATE (NULL), camp_comm_in_det.keycode, treatment.treatment_id, treatment.treatment_name, treatment_grp.treatment_grp_id, 
 treatment_grp.treatment_grp_name, treatment_grp.chan_type_id, chan_type.chan_type_name, treatment.email_type_id, treatment.email_subject,
 elem.elem_id, elem.elem_name, elem.content, elem.content_filename, elem.content_formt_id, elem.content_length, elem.elem_grp_id, elem.message_type_id,
 elem.var_cost, elem.var_cost_qty, camp_comm_in_det.res_type_id, res_type.res_type_name, camp_comm_in_det.res_channel_id, res_channel.res_channel_name,
 camp_comm_in_hdr.run_date, camp_comm_in_det.det_id
 from CAMPAIGN CAMPAIGN, CAMP_TYPE CAMP_TYPE, CAMP_STATUS_HIST CSH, STATUS_SETTING STATUS_SETTING, CHAN_TYPE CHAN_TYPE, TREATMENT_GRP TREATMENT_GRP,
 TREATMENT TREATMENT, TELEM TELEM, ELEM ELEM, CAMP_DET CAMP_DET_IN_4, CAMP_DET CAMP_DET_IN_3, CAMP_DET CAMP_DET_IN_2, CAMP_DET CAMP_DET_IN_1, 
 CAMP_COMM_IN_HDR CAMP_COMM_IN_HDR, CAMP_COMM_IN_DET CAMP_COMM_IN_DET, RES_TYPE RES_TYPE, RES_CHANNEL RES_CHANNEL 
 where CAMP_COMM_IN_DET.CAMP_ID = CAMPAIGN.CAMP_ID AND CAMPAIGN.CAMP_TYPE_ID = CAMP_TYPE.CAMP_TYPE_ID (+) AND CAMPAIGN.CAMP_ID = CSH.CAMP_ID AND 
 CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CAMPAIGN.CAMP_ID) AND 
 STATUS_SETTING.STATUS_SETTING_ID = CSH.STATUS_SETTING_ID AND CAMP_DET_IN_1.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND 
 CAMP_DET_IN_1.DET_ID = CAMP_COMM_IN_DET.DET_ID AND CAMP_DET_IN_2.CAMP_ID = CAMP_DET_IN_1.CAMP_ID AND CAMP_DET_IN_2.DET_ID = CAMP_DET_IN_1.PAR_DET_ID AND 
 CAMP_DET_IN_3.CAMP_ID = CAMP_DET_IN_2.CAMP_ID AND CAMP_DET_IN_3.DET_ID = CAMP_DET_IN_2.PAR_DET_ID AND CAMP_DET_IN_4.CAMP_ID = CAMP_DET_IN_3.CAMP_ID AND 
 CAMP_DET_IN_4.DET_ID = CAMP_DET_IN_3.PAR_DET_ID AND TREATMENT.TREATMENT_ID = CAMP_DET_IN_4.OBJ_ID AND 
 TREATMENT_GRP.TREATMENT_GRP_ID = TREATMENT.TREATMENT_GRP_ID AND CHAN_TYPE.CHAN_TYPE_ID = TREATMENT_GRP.CHAN_TYPE_ID AND
 TREATMENT.TREATMENT_ID = TELEM.TREATMENT_ID (+) AND TELEM.ELEM_ID = ELEM.ELEM_ID AND CAMP_COMM_IN_DET.PAR_COMM_DET_ID = 0 AND
 CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID AND CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID AND 
 CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ AND 
 CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER AND CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID AND
 RES_TYPE.RES_TYPE_ID (+) = CAMP_COMM_IN_DET.RES_TYPE_ID AND RES_CHANNEL.RES_CHANNEL_ID (+) = CAMP_COMM_IN_DET.RES_CHANNEL_ID');

	--
	-- Update of the Marketing Director entity list
	--

	insert into vantage_ent values ('TREAT_COMM_INFO',0,0);
	insert into vantage_ent values ('CHARAC_COMM_INFO',0,0);
	insert into vantage_ent values ('ELEM_COMM_INFO',0,0);
	COMMIT;

	update WEB_STATE_TYPE set state_type_name = 'Web Session' where state_type_id = 3;
	COMMIT;

	select vantage_alias, std_join_from_col into var_type1_alias, var_type1_stdcol from cust_tab where view_id = '&main_view' and vantage_type = 1;
 	select db_ent_owner into var_pv_owner from cust_tab where view_id = '&main_view' and db_ent_name = 'CAMP_COMM_OUT_HDR';

	-- Insert views into CUST_TAB 
	insert into cust_tab values ('&main_view','TREAT_COMM_INFO','Treatment Communication Details',99,100100,NULL,NULL,'TREAT_COMM_INFO', upper(var_pv_owner), NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name',1);
	insert into cust_tab values ('&main_view','CHARAC_COMM_INFO','Characteristic Communication Details',99,100101,NULL,NULL,'CHARAC_COMM_INFO', upper(var_pv_owner), NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name',1);
	insert into cust_tab values ('&main_view','ELEM_COMM_INFO','Element Communication Details',99,100102,NULL,NULL,'ELEM_COMM_INFO', upper(var_pv_owner), NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name',1);

	COMMIT;
	
	execute_sql ('ALTER TABLE PVDM_UPGRADE MODIFY (VERSION_ID VARCHAR2(20))');

	update PVDM_UPGRADE set VERSION_ID = '3.2.1.450.3-';
	COMMIT;

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('>');
		dbms_output.put_line('> The V3.2.0 to V3.2.1 Upgrade is not applicable.');
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
	select 1 into var_count from pvdm_upgrade where version_id = '3.2.1.450.3-';

	--
	-- changes for BL430 - 433
	--
	update camp_comm_out_hdr x set treat_qty = comm_qty; 
	--
	-- changes for BL434 - 439
	--
	insert into CAMP_REP_COL (camp_rep_col_id, col_name, rep_col_grp_id, dft_col_width, col_format_id, col_sql, dft_function_id, grp_by_only_flg) 
     		values (58, 'Actual Outbound Communications Quantity', 5, 1000, 2, 'SEG_ACT_OUT_QTY', 2, 0);

        insert into CAMP_REP_COL (camp_rep_col_id, col_name, rep_col_grp_id, dft_col_width, col_format_id, col_sql, dft_function_id, grp_by_only_flg)
                values (59, 'Actual Communications Response Rate', 7, 1000, 5, '(SEG_ACT_INB_QTY / SEG_ACT_OUT_QTY) AS ACT_RES_RATE', 2, 0);

        COMMIT;

       	execute_sql ('ALTER TABLE CAMP_REP_COL MODIFY (COL_SEQ DEFAULT NULL)');
	--
	update camp_rep_col set col_seq = camp_rep_col_id; 
	update camp_rep_col set col_seq = col_seq + 1 where col_seq > 38; 
	update camp_rep_col set col_seq = col_seq + 1 where col_seq > 49; 
	update camp_rep_col set col_seq = 39 where col_seq = 60;
	update camp_rep_col set col_seq = 50 where col_seq = 61;
	COMMIT;

	execute_sql ('GRANT SELECT ON TREAT_COMM_INFO TO &v3role');
	execute_sql ('GRANT SELECT ON CHARAC_COMM_INFO TO &v3role');
	execute_sql ('GRANT SELECT ON ELEM_COMM_INFO TO &v3role');


	update pvdm_upgrade set version_id = '3.2.1.450.3';
	COMMIT;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> V3.2.1 Marketing Director Schema has been upgraded to Build Level 450.3');
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
	select 1 into var_count from pvdm_upgrade where version_id = '3.2.1.450.3';

	dbms_output.put_line( 'V3.2 Data Model Schema Upgrade to Build Level to V3.2.2.506.2');
	dbms_output.put_line( '-------------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '    - added column AUTO_RESTART_FLG to SPI_TIME_CONTROL table');
	dbms_output.put_line( '    - added column EMPTY_CYC_TYPE_ID to EV_CAMP_DET table');
        dbms_output.put_line( '    - added lookup table EMPTY_CYC_TYPE');
        dbms_output.put_line( '    - added new entries for object types 90 - 96 into OBJ_TYPE');
	dbms_output.put_line( '    - added new entry 28 into COMP_TYPE');
        dbms_output.put_line( '    - added additional entry to ERES_RULE_DET to check messages with Chordiant strings'); 
     	dbms_output.put_line( '      for all defined Email Non-delivery Rules');
	dbms_output.put_line( '>');

	execute_sql ('ALTER TABLE SPI_TIME_CONTROL ADD (AUTO_RESTART_FLG NUMBER(1) DEFAULT 0 NOT NULL)');

	execute_sql ('ALTER TABLE SPI_TIME_CONTROL MODIFY AUTO_RESTART_FLG DEFAULT NULL');

	execute_sql ('CREATE TABLE EMPTY_CYC_TYPE (EMPTY_CYC_TYPE_ID NUMBER(1) NOT NULL, EMPTY_CYC_NAME VARCHAR2(100) NOT NULL) TABLESPACE &ts_pv_sys');
	execute_sql ('CREATE UNIQUE INDEX XPKEMPTY_CYC_TYPE ON EMPTY_CYC_TYPE (EMPTY_CYC_TYPE_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('ALTER TABLE EMPTY_CYC_TYPE ADD PRIMARY KEY (EMPTY_CYC_TYPE_ID) USING INDEX TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE EV_CAMP_DET ADD (EMPTY_CYC_TYPE_ID NUMBER(1) DEFAULT 0 NOT NULL)');
	execute_sql ('ALTER TABLE EV_CAMP_DET MODIFY EMPTY_CYC_TYPE_ID DEFAULT NULL');

	insert into obj_type values ( 90, 'Characteristic Group', null );
	insert into obj_type values ( 91, 'Base Segment Group', null );
	insert into obj_type values ( 92, 'Web Session Group', null );
	insert into obj_type values ( 93, 'Web Dynamic Criteria Group', null );
	insert into obj_type values ( 94, 'Derived Criteria Group', null );
	insert into obj_type values ( 95, 'Score Criteria Group', null );
	insert into obj_type values ( 96, 'Response Criteria Group', null );
	COMMIT;

	insert into comp_type values (28, 'Response Run Number');
	COMMIT;

	insert into vantage_ent values ('EMPTY_CYC_TYPE',1,1);
	COMMIT;

	insert into eres_rule_det select rule_id, 0, '%Chordiant Email Delivery Engine: Message undeliverable: invalid address%',
	   6, null, null, 0, 2 from eres_rule_det x where rule_det_seq = 1 and exists 
              (select * from eres_rule_hdr where rule_id = x.rule_id and rule_type_id = 2);

	update eres_rule_det x set rule_det_seq = (select max(rule_det_seq)+1 from eres_rule_det where rule_id = x.rule_id)
  	   where rule_det_seq = 0;
	COMMIT;

	-- 
	-- Add entries for Admin. Console processes into PROC_CONTROL and PROC_PARAM tables
	--

	insert into proc_control select 'Lock Angel', null, 1, 'v_lpangelproc', location, 4 from proc_control 
		where proc_name = 'Campaign Communication';
	insert into proc_control select 'Connection Pool', null, 1, 'v_cpangelproc', location, 3 from proc_control
		where proc_name = 'Campaign Communication';
	insert into proc_control select 'Java Activator', null, 1, 'v_jaangelproc', location, 4 from proc_control
		where proc_name = 'Campaign Communication';
	COMMIT;

	insert into proc_param values ('Lock Angel',0, 'Server executable name', 'v_lpangelproc');
	insert into proc_param values ('Lock Angel',1, 'Connection String', null);
	insert into proc_param values ('Lock Angel',2, 'Database Vendor Id', null);
	insert into proc_param values ('Lock Angel',3, 'Run Flag', null);
	insert into proc_param values ('Connection Pool', 0, 'Server executable name', 'v_cpangelproc');
	insert into proc_param values ('Connection Pool', 1, 'Connection String', null);
	insert into proc_param values ('Connection Pool', 2, 'Run Flag', null);
	insert into proc_param values ('Java Activator',0, 'Server executable name', 'v_jaangelproc');
	insert into proc_param values ('Java Activator',1, 'Connection String', null);
	insert into proc_param values ('Java Activator',2, 'Database Vendor Id', null);
	insert into proc_param values ('Java Activator',3, 'Run Flag', null);
	COMMIT;

        update PVDM_UPGRADE set VERSION_ID = '3.2.2.506.2-';
        COMMIT;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '>' );

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The upgrade to Build Level 506.2 is not applicable.');
		dbms_output.put_line('>');
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
	select 1 into var_count from pvdm_upgrade where version_id = '3.2.2.506.2-';

	insert into EMPTY_CYC_TYPE select 0, 'Process As Normal' from PVDM_UPGRADE where VERSION_ID like '3.2.2%' 
		and not exists (select * from empty_cyc_type where empty_cyc_type_id = 0);
	insert into EMPTY_CYC_TYPE select 1, 'Skip Empty Cycles' from PVDM_UPGRADE where VERSION_ID like '3.2.2%'
        	and not exists (select * from empty_cyc_type where empty_cyc_type_id = 1);
	insert into EMPTY_CYC_TYPE select 2, 'Delay Empty Cycles' from PVDM_UPGRADE where VERSION_ID like '3.2.2%'
        	and not exists (select * from empty_cyc_type where empty_cyc_type_id = 2);
	COMMIT;

	execute_sql('GRANT SELECT, UPDATE, INSERT, DELETE ON EMPTY_CYC_TYPE TO &v3role');  

	update pvdm_upgrade set version_id = '3.2.2.506.2';
	COMMIT;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> V3.2.2 Marketing Director Schema has been upgraded to Build Level 506.2');
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

spool off;

set SERVEROUT OFF
exit;
