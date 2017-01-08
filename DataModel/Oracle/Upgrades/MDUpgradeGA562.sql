prompt
prompt
prompt 'Marketing Director Schema Upgrade to V5.6.2'
prompt '==========================================='
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

spool MDUpgradeGA562.log
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

select 1 into var_count from pvdm_upgrade where version_id = '5.6.0.986';

  dbms_output.put_line( 'Processing Schema Upgrade from V5.6.0 to V5.6.2');
  dbms_output.put_line( '-------------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Change to CAMP_COMM_OUT_SUM, CAMP_COMM_INB_SUM views - re: CQDB104000425');
  dbms_output.put_line( '         - CAMP_COMM_OUT_SUM view redefined');
  dbms_output.put_line( '>');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_INB_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_IN_HDR.CAMP_ID, CAMP_COMM_IN_HDR.PAR_COMM_DET_ID, sum(comm_qty), sum(total_cost), sum(total_revenue), max(camp_cyc)
       FROM CAMP_COMM_IN_HDR
       WHERE COMM_STATUS_ID = 0
       GROUP BY camp_id, par_comm_det_id');

  execute_sql ('CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_TREAT_QTY, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(treat_qty), sum(comm_qty), sum(total_cost), max(camp_cyc)
       FROM CAMP_COMM_OUT_HDR
       WHERE COMM_STATUS_ID = 0
       GROUP BY camp_id, det_id');
 
  update pvdm_upgrade set version_id = '5.6.2.1133.12';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> V5.6.0 Marketing Director Schema has been upgraded to V5.6.2');
  dbms_output.put_line( '>' );
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('Your CMD schema is not a correct version to upgrade to V5.6.2.');
                dbms_output.put_line('Please upgrade to V5.6.0 before proceeding with this upgrade');
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

grant SELECT ON CAMP_COMM_OUT_SUM to &md_role;
grant SELECT ON CAMP_COMM_INB_SUM to &md_role;

spool off;
exit;



