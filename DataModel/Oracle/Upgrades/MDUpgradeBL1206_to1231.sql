prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
prompt

spool MDUpgradeBL1206to1231.log
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

  dbms_output.put_line( 'Processing Schema Upgrade from V5.6.3 Build 1206 to V6.0 build 1231');
  dbms_output.put_line( '-----------------------------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( '     - RUN_TIME_VAL_FLG added to SEG_HDR table for Run Time Value functionality');
  dbms_output.put_line( '>');

  
  execute_sql ('ALTER TABLE SEG_HDR ADD (RUN_TIME_VAL_FLG     NUMBER(1) DEFAULT 0 NOT NULL
                                   CHECK (RUN_TIME_VAL_FLG BETWEEN 0 AND 1))');
 

  update pvdm_upgrade set version_id = '6.0.1231';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The upgrade to V6.0 build 1231 completed successfully ');
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
/*exit;*/
