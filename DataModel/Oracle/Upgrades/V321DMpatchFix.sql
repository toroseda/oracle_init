prompt
prompt
accept ts_pv_sind prompt 'Enter the tablespace name for Prime@Vantage System indexes > '
prompt
accept ts_pv_indcomm prompt 'Enter the tablespace name for the Communications data indexes > '
prompt
accept pv_role prompt 'Enter the name of Prime@Vantage Application Role > '
prompt

spool V321DMpatchFix.log
set SERVEROUT ON SIZE 10000

DECLARE
 
var_count  NUMBER(4):= 0;
var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_view varchar2(128);

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
	select 1 into var_count from pvdm_upgrade where version_id = '3.2.1.450.2';

	dbms_output.put_line( 'V3.2 Data Model Schema Upgrade to Build Level to 450.3');
	dbms_output.put_line( '--------------------------------------------------------');
	dbms_output.put_line( '>');

	execute_sql ('CREATE INDEX XIE1CAMPAIGN ON CAMPAIGN (CAMP_TYPE_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('CREATE INDEX XIE1CAMP_STATUS_HIST ON CAMP_STATUS_HIST (STATUS_SETTING_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('ALTER TABLE TCHARAC DROP PRIMARY KEY');
	execute_sql ('CREATE UNIQUE INDEX XPKTCHARAC ON TCHARAC (CHARAC_ID ASC, TREATMENT_ID ASC) TABLESPACE &ts_pv_sind');
	execute_sql ('ALTER TABLE TCHARAC ADD PRIMARY KEY (CHARAC_ID, TREATMENT_ID) USING INDEX');
	execute_sql ('CREATE UNIQUE INDEX XAK1TCHARAC ON TCHARAC (TREATMENT_ID ASC, CHARAC_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('ALTER TABLE TELEM DROP PRIMARY KEY');
	execute_sql ('CREATE UNIQUE INDEX XPKTELEM ON TELEM (ELEM_ID ASC, TREATMENT_ID ASC) TABLESPACE &ts_pv_sind');
	execute_sql ('ALTER TABLE TELEM ADD PRIMARY KEY (ELEM_ID, TREATMENT_ID) USING INDEX');
	execute_sql ('CREATE UNIQUE INDEX XAK1TELEM ON TELEM (TREATMENT_ID ASC, ELEM_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('CREATE INDEX XIE1CAMP_DET ON CAMP_DET (CAMP_ID ASC, PAR_DET_ID ASC) TABLESPACE &ts_pv_sind');
	execute_sql ('CREATE INDEX XIE2CAMP_DET ON CAMP_DET (OBJ_TYPE_ID ASC, OBJ_ID ASC) TABLESPACE &ts_pv_sind');
	execute_sql ('CREATE INDEX XIE3CAMP_DET ON CAMP_DET (OBJ_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('CREATE INDEX XIE1TREATMENT ON TREATMENT (TREATMENT_GRP_ID ASC) TABLESPACE &ts_pv_sind');

	execute_sql ('CREATE INDEX XIE1TREATMENT_GRP ON TREATMENT_GRP (CHAN_TYPE_ID ASC) TABLESPACE &ts_pv_sind');
	
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

	execute_sql ('drop view TREAT_COMM_INFO');
	execute_sql ('drop view ELEM_COMM_INFO');
	execute_sql ('drop view CHARAC_COMM_INFO');
	execute_sql ('drop view CAMP_COMM_INFO');

	delete from vantage_ent where ent_name = 'CAMP_COMM_INFO';
	COMMIT;

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

       insert into comp_type values (25,'Segment Name');
       insert into comp_type values (26,'Parent Node ID');
       insert into comp_type values (27,'Parent Communication Node ID');
       COMMIT;

       delete from cust_tab where vantage_alias in ('TREAT_COMM_INFO','CAMP_COMM_INFO','CHARAC_COMM_INFO','ELEM_COMM_INFO');
       delete from cust_join where vantage_alias in ('TREAT_COMM_INFO','CAMP_COMM_INFO','CHARAC_COMM_INFO','ELEM_COMM_INFO');
       COMMIT;

       select view_id, vantage_alias, std_join_from_col into var_view, var_type1_alias, var_type1_stdcol from cust_tab
	   where vantage_type = 1 and rowid = (select min(rowid) from cust_tab where vantage_type = 1);   

       insert into cust_tab values (var_view,'TREAT_COMM_INFO','Treatment Communication Details',99,100100,NULL,NULL,'TREAT_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);
       insert into cust_tab values (var_view,'CHARAC_COMM_INFO','Treatment and Characteristic Communication Details',99,100101,NULL,NULL,'CHARAC_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);
       insert into cust_tab values (var_view,'ELEM_COMM_INFO','Treatment and Element Communication Details',99,100102,NULL,NULL,'ELEM_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);
       COMMIT;

       update PVDM_UPGRADE set VERSION_ID = '3.2.1.450.3';
       COMMIT;

       dbms_output.put_line( '>' );
       dbms_output.put_line( '> V3.2 Prime@Vantage Schema has been upgraded to Build Level 450.3');
       dbms_output.put_line( '>' );
       dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('> The upgrade to Build Level 450.3 is not applicable.');
		dbms_output.put_line('>');
		dbms_output.put_line('>');

END;
/

GRANT SELECT ON TREAT_COMM_INFO to &pv_role;
GRANT SELECT ON CHARAC_COMM_INFO to &pv_role;
GRANT SELECT ON ELEM_COMM_INFO to &pv_role;

set SERVEROUT OFF
spool off

exit;
