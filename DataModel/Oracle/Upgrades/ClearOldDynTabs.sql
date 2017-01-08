prompt
prompt
prompt 'This script is intended to clear out any residual unreferenced Dynamic tables'
prompt 'and is provided as a temporary measure only.'
prompt
prompt 'Note, that this will not effect the Prime@Vantage schema validity.'
prompt

set SERVEROUTPUT ON size 1000000
spool ClearOldDynTabs.log

DECLARE
var_count number:= 0;
var_camp_id number(8):= 0;

	CURSOR c1 IS SELECT table_name from user_tables x where table_name like 'TS%'
		and not exists (select * from seg_hdr where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);

	CURSOR c2 IS SELECT table_name from user_tables x where table_name like 'SE%'
		and not exists (select * from seg_hdr where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);
		
	CURSOR c3 IS SELECT table_name from user_tables x where table_name like 'BS%'
		and not exists (select * from seg_hdr where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);

	CURSOR c4 IS SELECT table_name from user_tables x where table_name like 'SC%'
		and not exists (select * from score_src where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);

	CURSOR c5 IS SELECT table_name from user_tables x where table_name like 'DV%'
		and not exists (select * from derived_val_src where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);

	CURSOR c6 IS SELECT sh.seg_id, sh.seg_type_id, rtrim(sh.dyn_tab_name) dyn_tab_name
		from seg_hdr sh,obj_type ot,tree_det td,tree_base tb,user_tables ut
		where sh.seg_type_id = ot.obj_type_id
		and   sh.seg_type_id = 4
		and  sh.seg_id = td.seg_id(+)
		and  sh.seg_id = tb.seg_id(+)
		and  nvl(td.tree_id,tb.tree_id) is null
		and  sh.DYN_TAB_NAME is not null
		and  trunc(last_run_date) != trunc(sysdate)
		and  ut.table_name = sh.dyn_tab_name ;

	CURSOR c7 IS SELECT table_name from user_tables x where table_name like 'DC%'
		and not exists (select * from data_cat_hdr where dyn_tab_name = x.table_name)
		and not exists (select * from vantage_dyn_tab where db_ent_name = x.table_name);

	CURSOR c8 IS SELECT table_name from user_tables x where table_name like 'CS%' 
		and not exists (select * from camp_det where dyn_tab_name = x.table_name);

	CURSOR c9 IS SELECT table_name from user_tables x where table_name like 'FPV%' and
		instr(table_name,'_') = 4 and substr(table_name,11,1) in ('0','1','2','3','4','5','6','7','8','9');

	CURSOR c10 IS SELECT table_name from user_tables x where table_name like 'TFPV%' and
		instr(table_name,'_') = 5 and substr(table_name,12,1) in ('0','1','2','3','4','5','6','7','8','9');

	CURSOR c11 IS SELECT table_name from user_tables x where table_name like 'ES%' and
		instr(table_name,'_') = 3 and substr(table_name,10,1) in ('0','1','2','3','4','5','6','7','8','9');



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
	/* unreferenced Tree Segment dynamic tables*/

	FOR c1rec IN c1 LOOP
	    IF (substr(c1rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c1rec.table_name );
		dbms_output.put_line ('Unreferenced Tree Segment dynamic table '|| c1rec.table_name ||' has been dropped.');
	    END IF;
	END LOOP;
	
	FOR c6rec IN c6 LOOP
		execute_sql ('delete from seg_hdr where seg_id = '|| c6rec.seg_id ||' and seg_type_id = '|| c6rec.seg_type_id );
		execute_sql ('delete from vantage_dyn_tab where VANTAGE_ALIAS = '''|| c6rec.dyn_tab_name ||'''' ); 
		execute_sql ('drop table '|| c6rec.dyn_tab_name );
		dbms_output.put_line ('Orhan Tree Segment dynamic table and reference '|| c6rec.dyn_tab_name ||' has been dropped and removed.');
	END LOOP;

	dbms_output.put_line ('>');

	/* unreferenced Segment dynamic tables */

        FOR c2rec IN c2 LOOP
	   IF (substr(c2rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c2rec.table_name );
		dbms_output.put_line ('Unreferenced Segment dynamic table '|| c2rec.table_name ||' has been dropped.');
	   END IF;
	END LOOP;

	dbms_output.put_line ('>');

	/* unreferenced Base Segment dynamic tables */

	FOR c3rec IN c3 LOOP
	    IF (substr(c3rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c3rec.table_name );
		dbms_output.put_line ('Unreferenced Base Segment dynamic table '|| c3rec.table_name ||' has been dropped.');
	    END IF;
	END LOOP;

	dbms_output.put_line ('>');

	/* unreferenced Score dynamic tables */

	FOR c4rec IN c4 LOOP
	    IF (substr(c4rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c4rec.table_name );
		dbms_output.put_line ('Unreferenced Score dynamic table '|| c4rec.table_name ||' has been dropped.');
	    END IF;	
	END LOOP;

	dbms_output.put_line ('>');

	/* unreferenced Derived Value dynamic tables */

	FOR c5rec IN c5 LOOP
	    IF (substr(c5rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c5rec.table_name );
		dbms_output.put_line ('Unreferenced Derived Value dynamic table '|| c5rec.table_name ||' has been dropped.');
            END IF;
	END LOOP;

	dbms_output.put_line ('>');

	/* unreferenced Data Category dynamic tables */

	FOR c7rec IN c7 LOOP
	    IF (substr(c7rec.table_name,3,1) IN ('1','2','3','4','5','6','7','8','9')) THEN
		execute_sql ('drop table '|| c7rec.table_name );
		dbms_output.put_line ('Unreferenced Data Categorisation dynamic table '|| c7rec.table_name ||' has been dropped.');
            END IF;
	END LOOP;

	/* residual Campaign Segments for deleted, 'Completed' or 'Cancelled' Campaigns */

	FOR c8rec IN c8 LOOP 

	    /* if the Campaign Segment is a trigger segment */
 	    IF (c8rec.table_name like '%\_0\_%' ESCAPE '\') then

	    	/* Extract Campaign ID from the table name */
		var_camp_id:= to_number(substr(c8rec.table_name, instr(c8rec.table_name,'_')+1, 
			instr(c8rec.table_name,'_0_') - instr(c8rec.table_name,'_')-1));

		dbms_output.put_line ('Checking Trigger Segments for Campaign ID:'|| var_camp_id);
		
		/* If the Campaign ID is NOT IN CAMPAIGN table OR	
	           IS in CAMPAING TABLE and the status is 'Cancelled' or 'Completed' */

		select count(camp_id) into var_count from campaign where camp_id = var_camp_id;
		IF (var_count > 0) then

			select count(camp_id) into var_count FROM camp_status_hist x
				where camp_id = var_camp_id and status_setting_id in (12,16)
				and camp_hist_seq = (select max(camp_hist_seq) from camp_status_hist
					where camp_id = x.camp_id);

			if (var_count > 0) then		
				execute_sql ('drop table '|| c8rec.table_name );
				dbms_output.put_line ('Unreferenced Trigger Segment: '|| c8rec.table_name ||' has been dropped.');
			end if;
		end if;
             else
		dbms_output.put_line ('Unreferenced Campaign Segment: '|| c8rec.table_name ||' has been dropped.');
		execute_sql ('drop table '|| c8rec.table_name );
	     END IF;		
	END LOOP;


	/* Remove all residual output tables, i.e. starting with 'FPV' and not part of running campaign */

	FOR c9rec IN c9 LOOP 	

  		var_camp_id:= to_number(substr(c9rec.table_name, instr(substr(c9rec.table_name,1,11),'_',-1)+1,
				11 - instr(substr(c9rec.table_name,1,11),'_',-1)));
		
		select count(*) into var_count from camp_status_hist x where camp_id = var_camp_id 
			and camp_hist_seq = (select max(camp_hist_seq) from camp_status_hist 
			where camp_id = x.camp_id) and status_setting_id = 4;

		IF (var_count = 0) then
			execute_sql ('drop table '|| c9rec.table_name );
			dbms_output.put_line ('Temporary File Output Table: '|| c9rec.table_name ||' has been dropped.');
		end if;		
	
	END LOOP;
	

	/* Remove all residual temporary output tables, i.e. starting with 'TFPV' and not part of running campaign */

	FOR c10rec IN c10 LOOP 	
 
  		var_camp_id:= to_number(substr(c10rec.table_name, instr(substr(c10rec.table_name,1,12),'_',-1)+1,
				12 - instr(substr(c10rec.table_name,1,12),'_',-1)));
		
		select count(*) into var_count from camp_status_hist x where camp_id = var_camp_id 
			and camp_hist_seq = (select max(camp_hist_seq) from camp_status_hist 
			where camp_id = x.camp_id) and status_setting_id = 4;

		IF (var_count = 0) then
			execute_sql ('drop table '|| c10rec.table_name );
			dbms_output.put_line ('Intermediate File Output Table: '|| c10rec.table_name ||' has been dropped.');
		end if;			

	END LOOP;	

	/* Remove all email output tables, i.e. starting with 'ES' and not part of Running, failed or Aborted Campaign */

	FOR c11rec IN c11 LOOP 

  		var_camp_id:= to_number(substr(c11rec.table_name, instr(substr(c11rec.table_name,1,10),'_',-1)+1,
				10 - instr(substr(c11rec.table_name,1,10),'_',-1)));
		
		select count(*) into var_count from camp_status_hist x where camp_id = var_camp_id 
			and camp_hist_seq = (select max(camp_hist_seq) from camp_status_hist 
			where camp_id = x.camp_id) and status_setting_id in (1,2,3,4);

		IF (var_count = 0) then
			execute_sql ('drop table '|| c11rec.table_name );
			dbms_output.put_line ('Temporary Email Output Table: '|| c11rec.table_name ||' has been dropped.');
		end if;		

	END LOOP;


	dbms_output.put_line ('>');
	dbms_output.put_line ('>');
	dbms_output.put_line ('Unreferrenced Dynamic tables have been successfully removed.');

EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line ('Error:');
		dbms_output.put_line ('Procedure error has occurred.');
		dbms_output.put_line ('Clear-out of unreferrenced Dynamic tables has not been able to complete.');		
		dbms_output.put_line ('Please note, that this does not effect the validity of the schema.');		

END;
/

set SERVEROUTPUT OFF

prompt
prompt
spool off

