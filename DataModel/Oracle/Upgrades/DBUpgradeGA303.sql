prompt
prompt
prompt 'V3.03 Prime@Vantage Schema Upgrade'
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

spool DBUpgradeGA303.log
set SERVEROUT ON SIZE 50000

DECLARE
	
var_version NUMBER(6) :=0;

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
	select to_number(substr(version_id, instr(version_id,'.',-1)+1,
		length(version_id) - instr(version_id,'.',-1)))
		into var_version from pvdm_upgrade;
		
	if (var_version < 107) then
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade cannot proceed:'); 
		dbms_output.put_line('> Prime Vantage schema version is below the the minimum required release level (BL107)');
		dbms_output.put_line('>');	
	else
		@V3UpgradeBL107to124.sql;
		@V3UpgradeBL124to126.sql;
		@V3UpgradeBL126to141.sql;
		@V3UpgradeBL141to150.sql;
		@V3UpgradeBL150to153.sql;
		@V3UpgradeBL153to156.sql;
		@V3UpgradeBL156to157.sql;		
		@V3UpgradeBL157to159.sql;
		@V3UpgradeBL159to162.sql;
		@V3UpgradeBL162to170.sql;
		@V3UpgradeBL170to174.sql;
		@V3UpgradeBL174to180.sql;
		@V3UpgradeBL180to192.sql;
		@V3UpgradeBL192to193.sql;
		@V3UpgradeBL193to205.sql;
		@V3UpgradeBL205to209.sql;
		@V3UpgradeBL209to221.sql;
		@V3UpgradeBL221to226.sql;
	
		dbms_output.put_line('>');
		dbms_output.put_line('> The Prime Vantage Schema Upgrade to GA 3.0.3 has been completed.');
		dbms_output.put_line(' ');
	end if;
END;
/

	insert into sys_param select 1, 'User ID' from dual where not exists 
		(select * from sys_param where sys_param_id = 1);
	insert into sys_param select 2, 'User Name' from dual where not exists
		(select * from sys_param where sys_param_id = 2);
	insert into sys_param select 3, 'Current Date' from dual where not exists
		(select * from sys_param where sys_param_id = 3);
	insert into sys_param select 4, 'Current Time' from dual where not exists
		(select * from sys_param where sys_param_id = 4);
	insert into sys_param select 5, 'Task Group/Campaign ID' from dual where not exists
		(select * from sys_param where sys_param_id = 5);
	insert into sys_param select 6, 'Connect String' from dual where not exists 
		(select * from sys_param where sys_param_id = 6);
	insert into sys_param select 7, 'Vendor Id' from dual where not exists 
		(select * from sys_param where sys_param_id = 7);
	insert into sys_param select 8, 'Process Audit Id' from dual where not exists 
		(select * from sys_param where sys_param_id = 8);
	COMMIT;

	insert into constraint_type select 1, 'Non-critical', 'Warn and Prevent with list of Referrers', 'Allow without warning', 8004, null from dual
		where not exists (select * from constraint_type where constraint_type_id = 1) and exists (select * from pvdm_upgrade where version_id >= '3.0.180');
	insert into constraint_type select 2, 'Standard', 'Warn and Prevent with list of Referrers', 'Warn and Allow with list of direct Referrers', 8004, 8005 from dual
		where not exists (select * from constraint_type where constraint_type_id = 2) and exists (select * from pvdm_upgrade where version_id >= '3.0.180');
	COMMIT;

	insert into constraint_setting select 13,  2, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 13, 16, null, 2 from dual where 57 > (select count(*) from constraint_setting);	
	insert into constraint_setting select 13, 17, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 13, 18, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 13, 19, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 13, 22, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  9,  2, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  9,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  7,  2, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  7,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  7, 20, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  6,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  6, 20, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 12,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1,  1, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,   13, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,    9, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,    1, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,    4, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,    8, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,   32, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,   33, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 16,   24, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1,  7, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  1, 23, null, 2 from dual where 57 > (select count(*) from constraint_setting);		
	insert into constraint_setting select  4,  8, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select  4,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 33,  1, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  4,   36, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  1,   36, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  1,   33, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  5, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  6, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  9, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 10, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 11, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 12, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 13, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 14, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 21, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24, 15, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 18,  1,   41, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 18,  1,   42, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 18,  1,   44, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 18,  5, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 44,  1, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 19,  3,    3, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 19,  3,   35, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 19,  3,   34, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 11,  1, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 62,  1,   61, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 62,  1,   69, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 67,  1, null, 1 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 68,  1, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 68,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	insert into constraint_setting select 17,  3, null, 2 from dual where 57 > (select count(*) from constraint_setting);
	COMMIT;

	delete from constraint_setting x where exists (select * from constraint_setting where
	  ref_type_id = x.ref_type_id and ref_indicator_id = x.ref_indicator_id and obj_type_id =
	  x.obj_type_id and rowid > x.rowid);

	insert into constraint_setting select 18, 1, 44, 2 from dual where not exists (select * from
		constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and obj_type_id = 44);
	COMMIT;

	insert into constraint_setting select 24,  1,   37, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  1,   28, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 24,  1,   29, 2 from dual where 128 > (select count(*) from constraint_setting);
 	insert into constraint_setting select 70,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
        insert into constraint_setting select 66,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  2, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select  3, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 15, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 16, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 28, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29,  1, null, 1 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,   13, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,    9, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,    1, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,    4, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,    8, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,   32, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,   33, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 16,   24, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29,  7, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	insert into constraint_setting select 29, 23, null, 2 from dual where 128 > (select count(*) from constraint_setting);
	COMMIT;

        insert into constraint_setting select  1, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select  2, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select  3, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select 15, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select 16, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select 28, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select 29, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select  4, 16, 1, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select  4, 16, 2, 2 from dual where 138 > (select count(*) from constraint_setting);
        insert into constraint_setting select  4, 16, 4, 2 from dual where 138 > (select count(*) from constraint_setting);
	COMMIT;

	update constraint_setting set constraint_type_id = 2 where
	ref_type_id = 24 and ref_indicator_id = 21 and constraint_type_id = 1;
	COMMIT;

	insert into vantage_ent select 'CONSTRAINT_SETTING', 1, 1 from dual where not exists (select *
		from vantage_ent where ent_name = 'CONSTRAINT_SETTING');
	insert into vantage_ent select 'WEB_EXPOSURE', 0, 0 from dual where not exists (select *
		from vantage_ent where ent_name = 'WEB_EXPOSURE');
	insert into vantage_ent select 'WEB_CLICKTHROUGH', 0, 0 from dual where not exists (select *
		from vantage_ent where ent_name = 'WEB_CLICKTHROUGH');
	COMMIT;

	update spi_proc set src_sub_id = 0 where src_sub_id is null;
	
	update spi_proc x set src_sub_id = (select to_number(var_param_val) from spi_proc_var
		where spi_id = x.spi_id and proc_seq = x.proc_seq and param_seq = 14)
  		where proc_name like '%Tree' and src_sub_id = 0;
	COMMIT;

	update spi_camp_proc set src_sub_id = 0 where src_sub_id is null;
	update spi_camp_proc x set src_sub_id = (select to_number(var_param_val) from spi_camp_proc_var 
  		where spi_id = x.spi_id and camp_proc_seq = x.camp_proc_seq and param_seq = 14) 
  		where proc_name like '%Tree' and src_sub_id = 0;
	COMMIT;


spool off

set SERVEROUT OFF
exit;
