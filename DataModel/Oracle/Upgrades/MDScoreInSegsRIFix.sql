prompt
prompt

spool MDScoreInSegsRIFix.log
set SERVEROUT ON SIZE 20000

DECLARE

var_count  NUMBER(4):= 0;

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

	dbms_output.put_line( 'Marketing Director RI correction re: Defect CQDB101011572');
	dbms_output.put_line( '-------------------------------------------------------------------------');
	dbms_output.put_line( 'Removing erroneous entries in REFERENCED_OBJ table relating to ');
	dbms_output.put_line( '   relating to incorrect records for Stored Fields inserted ');
	dbms_output.put_line( '   during parse of the Segment criteria ');
	dbms_output.put_line( '>');

	select count(*) into var_count from referenced_obj where ref_type_id in (1,2,3,4)
		and ref_indicator_id = 7 and obj_type_id in (9,13) and obj_type_id =
		obj_src_type_id and obj_id = obj_src_id;

	IF (var_count > 0) then
		delete from referenced_obj where ref_type_id in (1,2,3,4) 
			and ref_indicator_id = 7 and obj_type_id in (9,13) 
			and obj_type_id = obj_src_type_id and obj_id = obj_src_id;
		COMMIT;
	END IF;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> Inconsistent RI records re: Segment Score or Derived Value Stored Fields have been removed.');
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
		RAISE;
END;
/


spool off;

set SERVEROUT OFF
exit;

