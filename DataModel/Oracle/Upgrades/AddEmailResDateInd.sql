prompt
accept ts_pv_indcomm prompt 'Enter the name of tablespace for Marketing Director Communication Indexes > '
prompt
prompt

spool AddEmailResDateInd.log
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

select 1 into var_count from pvdm_upgrade where version_id = '5.5.0.825.3';

  dbms_output.put_line( 'Adding Index on RES_DATE, RES_TIME in EMAIL_RES table');
  dbms_output.put_line( '-------------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( '     - Add index on EMAIL_RES for RES_DATE, RES_TIME re: CQDB103022357');
  dbms_output.put_line( '>');



  /* check that new index on EMAIL_RES table does not exists already - this has been provided */
  /* as an intermediary fix for specific customers in V5.5 via fix script AddEmailResDateInds.sql */

  select count(*) into var_count from USER_IND_COLUMNS x where table_name = 'EMAIL_RES' 
     and column_position = 1 and column_name = 'RES_DATE' and exists 
     (select * from USER_IND_COLUMNS where table_name = x.table_name and 
      column_position = 2 and column_name = 'RES_TIME');

  if (var_count = 0) then
     select count(*) into var_count from USER_INDEXES where table_name = 'EMAIL_RES'
        and index_name = 'XIE5EMAIL_RES';
  end if;

  if (var_count = 0) then
    execute_sql ('CREATE INDEX XIE5EMAIL_RES ON EMAIL_RES (RES_DATE ASC, RES_TIME ASC) TABLESPACE &ts_pv_indcomm');
  end if;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The index Date and Time in Email Response table has been successfully created');
  dbms_output.put_line( '>' );
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
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

spool off;
exit;
