prompt
prompt
prompt 'V3.1.1 Prime@Vantage Schema Upgrade'
prompt '=================================='
prompt
accept ts_pv_sys prompt 'Enter name of tablespace for Prime@Vantage System Tables > '
prompt
accept ts_pv_ind prompt 'Enter name of tablespace for Prime@Vantage System Indexes > '
prompt
accept ts_pv_comm prompt 'Enter Tablespace Name for Communication Tables > '
prompt
accept ts_pv_indcomm prompt 'Enter Tablespace Name for Communication Table Indexes > '
prompt
accept pv_app_role prompt 'Enter name of Prime@Vantage Application Role > '
prompt
prompt
accept sas_use prompt 'Will you be using SAS scores? Answer Y or N > '
prompt

spool DBUpgradeGA311.log
set SERVEROUT ON SIZE 15000

DECLARE

var_version VARCHAR2(10);	
var_build NUMBER(6) :=0;

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
	select substr(version_id,1,instr(version_id,'.',-1)-1) into var_version from pvdm_upgrade;

	if (var_version <> '3.1' and var_version <> '3.1.1') then
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade cannot proceed:'); 
		dbms_output.put_line('> Prime Vantage schema version is not V3.1 - upgrade to V3.1.0 before proceeding');
		dbms_output.put_line('>');	
	else
		@V311UpgradeBL226to278.sql;
		@V311UpgradeBL278to291.sql;
		@V311UpgradeBL291to295.sql;
		@V311UpgradeBL295to296.sql;
	
		dbms_output.put_line('>');	
		dbms_output.put_line('> The Prime@Vantage Schema structure has been upgraded to V3.1.1');
		dbms_output.put_line(' ');
	end if;
END;
/


DECLARE

web_count NUMBER(4) := 0;
var_count NUMBER := 0;

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
	dbms_output.put_line( '>' );
	dbms_output.put_line( 'Converting WDE data to a new format in WEB_IMPRESSION table, if exists');
	dbms_output.put_line( '>' );

	select 1 into var_count from pvdm_upgrade where substr(version_id,1,5) = '3.1.1';

	select 1 into var_count from pvdm_upgrade where to_number(substr(version_id,7,length(version_id)-6)) >= 291;

	update delivery_chan x set view_id = (select view_id from ext_templ_hdr where ext_templ_id = x.dft_ext_templ_id)
		where dft_ext_templ_id <> 0;

	update delivery_chan x set view_id = (select default_view_id from user_definition where user_id = x.created_by) 
		where view_id is null and exists (select * from user_definition where user_id = x.created_by);

	update delivery_chan x set view_id = (select view_id from cdv_hdr where created_date = 
		(select min(created_date) from cdv_hdr) and rownum = 1) where view_id is null;
	COMMIT;

	execute_sql ('ALTER TABLE DELIVERY_CHAN MODIFY (VIEW_ID NOT NULL)');

	select 1 into web_count from pv_tabs where table_name = 'WEB_IMPRESSION' and table_owner = user;

	execute_sql('analyze table web_impression compute statistics');

	select count(*) into web_count from pv_tabs where table_name = 'WEB_IMPRESSION' and table_owner = user
		and num_rows = 0;

	if (web_count = 1) then
		execute_sql ('ALTER TABLE WEB_IMPRESSION MODIFY (SESSION_ID VARCHAR2(500))');
	else
		dbms_output.put_line('>');
		dbms_output.put_line('> The WEB_IMPRESSION table contains data');
		dbms_output.put_line('> - the SESSION_ID in WEB_IMPRESSION table has not been modified to the new format');
		dbms_output.put_line('>');
	end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The WEB_IMPRESSION table is not present in the current schema');
		dbms_output.put_line('> - the SESSION_ID in WEB_IMPRESSION table has not been modified to the new format');
		dbms_output.put_line('>');

END;
/


GRANT select, insert, update, delete on SAS_SCORE_RESULT TO &pv_app_role;

spool off

prompt 'GA311 Upgrade has been completed.'

set SERVEROUT OFF
exit;
