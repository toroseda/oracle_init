prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

spool MDUpgradeGA570.log
set SERVEROUT ON SIZE 20000


DECLARE

var_count  NUMBER(4):= 0;
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

select 1 into var_count from pvdm_upgrade where version_id = '5.6.3.1206';

  dbms_output.put_line( 'Processing Schema Upgrade from V5.6.3 to V5.7.0');
  dbms_output.put_line( '-----------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Change to Query Designer:');
  dbms_output.put_line( '     - RUN_TIME_VAL_FLG added to SEG_HDR table for Run Time Value functionality');
  dbms_output.put_line( '     - Campaign Analysis views change to include Control Groups re: CQDB04002818');
  dbms_output.put_line( '>');

  
  execute_sql ('ALTER TABLE SEG_HDR ADD (RUN_TIME_VAL_FLG NUMBER(1) DEFAULT 0 NOT NULL
                                   CHECK (RUN_TIME_VAL_FLG BETWEEN 0 AND 1))');

  /* execute_sql ('ALTER TABLE SEG_HDR MODIFY RUN_TIME_VAL_FLG DEFAULT NULL'); */
 
  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_TREAT_QTY, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(treat_qty), sum(comm_qty), sum(total_cost), max(camp_cyc)
       FROM CAMP_COMM_OUT_HDR
       WHERE COMM_STATUS_ID IN (0,1)
       GROUP BY camp_id, det_id');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_INB_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_IN_HDR.CAMP_ID, CAMP_COMM_IN_HDR.PAR_COMM_DET_ID, sum(comm_qty), sum(total_cost), sum(total_revenue), max(camp_cyc)
       FROM CAMP_COMM_IN_HDR
       WHERE COMM_STATUS_ID IN (0,1)
       GROUP BY camp_id, par_comm_det_id');

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

  update pvdm_upgrade set version_id = '5.7.0.1300';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The v5.6.3 Marketing Director schema has been upgraded to V5.7.0');
  dbms_output.put_line( '>' );
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

spool off;
exit;
