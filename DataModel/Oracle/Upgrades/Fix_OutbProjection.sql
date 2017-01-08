prompt
prompt

spool Fix_OutbProjection.log
set SERVEROUT ON SIZE 20000

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

select 1 into var_count from pvdm_upgrade where version_id = '5.5.0.825.3';

  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Correction to OUTB_PROJECTION view');
  dbms_output.put_line( '>');

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
     max(ctdet.version_id), max(campver.version_name)
   FROM CAMP_GRP cgrp, STRATEGY strat, CAMPAIGN camp, CAMP_VERSION campver, CAMP_TYPE ctype, 
     CAMP_MANAGER cmgr, CAMP_MANAGER cbmgr, CAMP_DET ctdet, CAMP_SEG_DET csdet, TREATMENT treat, 
     TELEM telem, ELEM elem, TREATMENT_GRP tgrp, CHAN_TYPE chntype, SEG_HDR seghd, CAMP_SEG cseg, 
     CAMP_SEG_COST dhcfc, TREAT_SEG_COST dhtfc, CAMP_STATUS dhcs
   WHERE strat.strategy_id = cgrp.strategy_id 
     and cgrp.camp_grp_id = camp.camp_grp_id
     and camp.camp_type_id = ctype.camp_type_id (+) 
     and camp.camp_id = dhcs.camp_id 
     and camp.camp_id = dhcfc.camp_id (+) 
     and camp.camp_id = campver.camp_id
     and campver.manager_id = cmgr.manager_id (+) 
     and campver.budget_manager_id = cbmgr.manager_id (+) 
     and campver.camp_id = ctdet.camp_id
     and campver.version_id = ctdet.version_id
     and csdet.camp_id = ctdet.camp_id
     and csdet.version_id = ctdet.version_id 
     and csdet.par_det_id = ctdet.det_id  
     and csdet.obj_type_id = seghd.seg_type_id (+) 
     and csdet.obj_id = seghd.seg_id (+) 
     and csdet.camp_id = cseg.camp_id (+) 
     and csdet.version_id = cseg.version_id (+)
     and csdet.det_id = cseg.det_id (+) 
     and csdet.obj_type_id in (1,4,21)
     and ctdet.camp_id = dhtfc.camp_id (+) 
     and ctdet.det_id = dhtfc.treat_det_id (+) 
     and ctdet.obj_id = treat.treatment_id
     and treat.treatment_id = telem.treatment_id (+) 
     and telem.elem_id = elem.elem_id (+) 
     and treat.treatment_grp_id = tgrp.treatment_grp_id
     and tgrp.chan_type_id = chntype.chan_type_id 
   GROUP BY csdet.camp_id, csdet.det_id, csdet.version_id ');
 
  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The Outb_Projection view has been corrected');
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

