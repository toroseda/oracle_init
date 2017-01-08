
spool MDUpgradeGA63.log

prompt
prompt
prompt 'Marketing Director Schema Upgrade to GA6.3.0 (level 0005')
prompt '============================================================================'
prompt 'Current schema must be V6.2.0 GA'
prompt '--------------------------------'
prompt
accept ts_pv_sys prompt 'Enter the name of tablespace for Marketing Director system tables > '
prompt
accept ts_pv_ind prompt 'Enter the name of tablespace for Marketing Director system indexes > '
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

set SERVEROUT ON SIZE 20000
set VERIFY OFF

DECLARE

var_count  NUMBER(10):= 0;
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

  /* Check for correct schema version */
  select 1 into var_count from pvdm_upgrade where version_id = '6.2.0.1662.GA';

  dbms_output.put_line( '>');
  dbms_output.put_line( '> Processing Schema Upgrade from GA6.2.0 to GA6.3.0');
  dbms_output.put_line( '> -------------------------------------------------');
  dbms_output.put_line( '> Change report:');
  dbms_output.put_line( '> Changes for Lookup Table Grouping enhancement:');
  dbms_output.put_line( '>   - LOOKUP_TAB_GRP table - Create to allow grouping of Lookup tables');
  dbms_output.put_line( '>   - LOOKUP_TAB_HDR table - Add column LOOKUP_TAB_GRP_ID for LookUp Table Group');
  dbms_output.put_line( '>   - Meta data - Add to VANTAGE_ENT, OBJ_TYPE, CONSTRAINT_SETTING tables');
  dbms_output.put_line( '>   - LOOKUP_TAB_HDR Insert/Update/Delete triggers - Create for RI maintenance');
  dbms_output.put_line( '>   - LOOKUP_TAB_HDR existing data rows - Assign to default Lookup Table Group');
  dbms_output.put_line( '> Change in Segmentation Tree Trigger ');
  dbms_output.put_line( '>   - TREE_HDR trigger - Update TU_TREE_HDR trigger for missing clause');  
  dbms_output.put_line( '> Changes for Delivery Channel Output Component Details:');
  dbms_output.put_line( '>   - OUT_CHAN_COMP table - Create to define default file/tablename for a Delivery Channel');
  dbms_output.put_line( '>   - DELIVERY_CHAN table - Add column OUT_NAME_SUFFIX to capture file suffix defined by user');
  dbms_output.put_line( '>   - Meta data - Add to VANTAGE_ENT table');
  dbms_output.put_line( '>   - DELIVERY_CHAN existing data rows - Create default output component entries for type DB/File ');
  dbms_output.put_line( '> Changes to handle a maximum of 20 characters for a wireless password:');
  dbms_output.put_line( '>   - WIRELESS_SERVER table - Extend length of PASSWORD column from 8 to 50 for encrypted password');
  dbms_output.put_line( '> Changes for Re-execution of Segmentation Trees from specific node:');
  dbms_output.put_line( '>   - TREE_HDR table - Add column EXE_FROM_TREE_SEQ to capture tree node from where to re-execute Tree');
  dbms_output.put_line( '> Changes to enter a SPI grace period greater than 2 digits:');
  dbms_output.put_line( '>   - SPI_TIME_CONTROL table - Extend length of GRACE_PERIOD column from 2 to 4');
  dbms_output.put_line( '> Changes for updating SAMPLE_TYPE_NAME in SAMPLE_TYPE table:');
  dbms_output.put_line( '>   - SAMPLE_TYPE table - Update name data of SAMPLE_TYPE_ID 2 and 3');
  dbms_output.put_line( '> -------------------------------------------------');
  dbms_output.put_line( '>');


  /* Changes for Lookup Table Grouping enhancement - Schema */
  execute_sql ('CREATE TABLE LOOKUP_TAB_GRP (LOOKUP_TAB_GRP_ID NUMBER(4) NOT NULL, 
                LOOKUP_TAB_GRP_NAME VARCHAR2(100) NOT NULL, LOOKUP_TAB_GRP_DESC VARCHAR2(300), 
                VIEW_ID VARCHAR2(30) NOT NULL) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKLOOKUP_TAB_GRP ON LOOKUP_TAB_GRP (LOOKUP_TAB_GRP_ID ASC) TABLESPACE &ts_pv_ind' );
  execute_sql ('ALTER TABLE LOOKUP_TAB_GRP ADD PRIMARY KEY (LOOKUP_TAB_GRP_ID) USING INDEX TABLESPACE &ts_pv_ind' );

  execute_sql ('ALTER TABLE LOOKUP_TAB_HDR ADD (LOOKUP_TAB_GRP_ID NUMBER(4))');

  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON LOOKUP_TAB_GRP TO &md_role'); 


  /* Changes for Delivery Channel Output Component Details - Schema */
  execute_sql ('CREATE TABLE OUT_CHAN_COMP (CHAN_ID NUMBER(8) NOT NULL, 
                COMP_SEQ NUMBER(2) NOT NULL, COMP_TYPE_ID NUMBER(2) NOT NULL, OUT_LENGTH NUMBER(4) NOT NULL,
                STRING_VAL VARCHAR2(200)) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKOUT_CHAN_COMP ON OUT_CHAN_COMP (CHAN_ID ASC, COMP_SEQ ASC) TABLESPACE &ts_pv_ind' );
  execute_sql ('ALTER TABLE OUT_CHAN_COMP ADD PRIMARY KEY (CHAN_ID, COMP_SEQ) USING INDEX TABLESPACE &ts_pv_ind' );

  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON OUT_CHAN_COMP TO &md_role'); 

  execute_sql ('ALTER TABLE DELIVERY_CHAN ADD (OUT_NAME_SUFFIX CHAR(3))');
  

  /* Changes to handle a maximum of 20 charactes for a Wireless Password - Schema */
  execute_sql ('ALTER TABLE WIRELESS_SERVER MODIFY PASSWORD VARCHAR2(50)');


  /* Changes for Re-execution of Segmentation Trees from specific node - Schema */
  execute_sql ('ALTER TABLE TREE_HDR ADD (EXE_FROM_TREE_SEQ NUMBER(6))');
  
  
  /* Changes for MD-12922 - Unable to enter a grace greater than 2 digits - Schema */
  execute_sql ('ALTER TABLE SPI_TIME_CONTROL MODIFY GRACE_PERIOD NUMBER(4)');


  /* Schema Version Update - Intermediate stage */  
  update pvdm_upgrade set version_id = '6.3.0.0005.GA-';
  COMMIT;

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('> ');
    dbms_output.put_line('> The Marketing Director schema is NOT at the correct version.');
    dbms_output.put_line('> Please ensure your schema version is 6.2.0.1662.GA before proceeding.');
    dbms_output.put_line('> ');

  WHEN OTHERS THEN
    dbms_output.put_line('> ');
    dbms_output.put_line('> Procedure 1 error occurred.' );
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    dbms_output.put_line('> Oracle Error: '||err_num ||' '|| err_msg );
    dbms_output.put_line('> ');
    dbms_output.put_line('> ');
  RAISE;
END;
/

DECLARE

var_count  NUMBER(10):= 0;
cid INTEGER;

err_num		NUMBER;
err_msg		VARCHAR2(100);

CURSOR c1 IS
   SELECT chan_id, delivery_method_id 
     FROM delivery_chan
    WHERE delivery_method_id in (1, 2)
    ORDER BY chan_id;
r1 c1%rowtype;

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

  /* Check for intermediate schema version */
  select 1 into var_count from pvdm_upgrade where version_id = '6.3.0.0005.GA-';


  /* Changes for Lookup Table Grouping enhancement - Data */
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('LOOKUP_TAB_GRP',1,0);
  
  insert into OBJ_TYPE (OBJ_TYPE_ID, OBJ_NAME, OBJ_ABBREV) values (102, 'Lookup Table Group', null);
  
  insert into CONSTRAINT_SETTING (REF_TYPE_ID, REF_INDICATOR_ID, OBJ_TYPE_ID, CONSTRAINT_TYPE_ID) 
  values (102, 1, null, 1);
  
  insert into CONSTRAINT_SETTING (REF_TYPE_ID, REF_INDICATOR_ID, OBJ_TYPE_ID, CONSTRAINT_TYPE_ID) 
  values (8, 1, null, 1);

  COMMIT;


  /* Changes for Lookup Table Grouping enhancement - Triggers */
  /* Create Delete Trigger TD_LOOKUP_TAB_HDR */
execute_sql ('create or replace trigger TD_LOOKUP_TAB_HDR
  AFTER DELETE
  on LOOKUP_TAB_HDR
  
  for each row
/* ERwin Builtin Fri Sep 19 13:20:28 2007 */
/* default body for TD_LOOKUP_TAB_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if (:old.lookup_tab_grp_id is not null and :old.lookup_tab_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 8 and ref_id = :old.lookup_tab_id
    and ref_indicator_id = 1 and obj_type_id = 102 and obj_id = :old.lookup_tab_grp_id;
end if;   

end;');

  /* Create Insert Trigger TI_LOOKUP_TAB_HDR */
execute_sql ('create or replace trigger TI_LOOKUP_TAB_HDR
  AFTER INSERT
  on LOOKUP_TAB_HDR
  
  for each row
/* ERwin Builtin Fri Sep 19 13:20:28 2007 */
/* default body for TI_LOOKUP_TAB_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.lookup_tab_grp_id is not null and :new.lookup_tab_grp_id <> 0) then
  /* check that the referenced lookup table group still exists */
  select lookup_tab_grp_id into var_id from lookup_tab_grp 
  where lookup_tab_grp_id = :new.lookup_tab_grp_id;

  insert into referenced_obj select 102, :new.lookup_tab_grp_id, null, null, null, null, null,
    8, :new.lookup_tab_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = 8 and ref_indicator_id = 1 
    and (obj_type_id = 102 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');

  /* Create Update Trigger TU_LOOKUP_TAB_HDR */
execute_sql ('create or replace trigger TU_LOOKUP_TAB_HDR
  AFTER UPDATE
         OF LOOKUP_TAB_GRP_ID
  on LOOKUP_TAB_HDR
 
  for each row
/* ERwin Builtin Fri Sep 19 13:20:28 2007 */
/* default body for TU_LOOKUP_TAB_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.lookup_tab_grp_id is not null and :old.lookup_tab_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 8 and ref_id = :old.lookup_tab_id
    and ref_indicator_id = 1 and obj_type_id = 102 and obj_id = :old.lookup_tab_grp_id;
end if;  

if (:new.lookup_tab_grp_id is not null and :new.lookup_tab_grp_id <> 0) then
  /* check that the referenced lookup table group still exists */
  select lookup_tab_grp_id into var_id from lookup_tab_grp 
  where lookup_tab_grp_id = :new.lookup_tab_grp_id;

  insert into referenced_obj select 102, :new.lookup_tab_grp_id, null, null, null, null, null,
    8, :new.lookup_tab_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = 8 and ref_indicator_id = 1 
    and (obj_type_id = 102 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');


  /* Changes for Lookup Table Grouping enhancement - Data migration */
  /* Check if any lookup table data exists */
  select count(*) into var_count from LOOKUP_TAB_HDR;
 
  if (var_count > 0) 			
  then								-- data exists

    /* Populate Lookup Table Group Default entries */
    insert into LOOKUP_TAB_GRP 
      select rownum, 'Default', 'Default Lookup Table Group', VIEW_ID 
        from CDV_HDR;

    /* Associate Lookup Table to appropriate Default Group */
    update LOOKUP_TAB_HDR set LOOKUP_TAB_GRP_ID=
      (select LOOKUP_TAB_GRP_ID 
         from LOOKUP_TAB_GRP 
        where LOOKUP_TAB_GRP.VIEW_ID=LOOKUP_TAB_HDR.view_id);
         
  end if;


  /* Changes for Lookup Table Grouping enhancement - Post data migration tasks */
  execute_sql ('ALTER TABLE LOOKUP_TAB_HDR MODIFY LOOKUP_TAB_GRP_ID NOT NULL');


  /* Changes for Delivery Channel Output Component Details - Data */
  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('OUT_CHAN_COMP',1,0);
  
  COMMIT;
  
  
  /* Changes for Delivery Channel Output Component Details - Data migration */
  /* If any delivery channel of type File/Database data exists, add default output components */
  BEGIN
     OPEN c1;
     <<fetch_delivery_chan>>
     LOOP
        FETCH c1 INTO r1;
        EXIT WHEN c1%NOTFOUND OR c1%NOTFOUND is null;

        INSERT INTO out_chan_comp (chan_id, comp_seq, comp_type_id, out_length, string_val)
        VALUES (r1.chan_id, 1, 6, 2, 'MD');
  
        INSERT INTO out_chan_comp (chan_id, comp_seq, comp_type_id, out_length, string_val)
        VALUES (r1.chan_id, 2, 18, 8, null);
   
        INSERT INTO out_chan_comp (chan_id, comp_seq, comp_type_id, out_length, string_val)
        VALUES (r1.chan_id, 3, 23, 8, null);

        INSERT INTO out_chan_comp (chan_id, comp_seq, comp_type_id, out_length, string_val)
        VALUES (r1.chan_id, 4, 24, 4, null);

     END LOOP fetch_delivery_chan;
     CLOSE c1;
  
     COMMIT;
 
  END;


  /* Changes for MD-11257 - SAMPLE_TYPE_NAME in SAMPLE_TYPE table is incorrect - Data */
  update SAMPLE_TYPE set SAMPLE_TYPE_NAME='Lowest'
   where SAMPLE_TYPE_ID=2 and SAMPLE_TYPE_NAME='Highest';

  update SAMPLE_TYPE set SAMPLE_TYPE_NAME='Highest'
   where SAMPLE_TYPE_ID=3 and SAMPLE_TYPE_NAME='Lowest';

  COMMIT;


  /* Schema Version Update - Intermediate stage */  
  update pvdm_upgrade set version_id = '6.3.0.0005.GA--';
  COMMIT;

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('>');

  WHEN OTHERS THEN
  
    CLOSE c1;

    dbms_output.put_line('>');
    dbms_output.put_line('> Procedure 2 error occurred.' );
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    dbms_output.put_line('> Oracle Error: '||err_num ||' '|| err_msg );
    dbms_output.put_line('>');
    dbms_output.put_line('>');
  RAISE;
END;
/


DECLARE

var_count  NUMBER(10):= 0;
cid INTEGER;

err_num         NUMBER;
err_msg         VARCHAR2(100);

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

  /*** Note: The third procedure in this script is required to handle ***/
  /***       display of appropriate messages on exception scenarios.  ***/
  
  /* Check for intermediate schema version */
  select 1 into var_count from pvdm_upgrade where version_id = '6.3.0.0005.GA--';


  /* Create Update Trigger TU_TREE_HDR */
execute_sql ('create or replace trigger TU_TREE_HDR
  AFTER UPDATE
         OF TREE_GRP_ID
  on TREE_HDR
 
  for each row
/* ERwin Builtin Tue Feb 06 16:03:15 2007 */
/* default body for TU_TREE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.tree_grp_id is not null and :old.tree_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id
    and ref_indicator_id = 1 and obj_type_id = 101 and obj_id = :old.tree_grp_id;
end if;  

if (:new.tree_grp_id is not null and :new.tree_grp_id <> 0) then
  /* check that the referenced tree segment group still exists */
  select tree_grp_id into var_id from tree_grp where tree_grp_id = :new.tree_grp_id;

  insert into referenced_obj select 101, :new.tree_grp_id, null, null, null, null, null,
    4, :new.tree_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = 4 and ref_indicator_id = 1 
    and (obj_type_id = 101 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');


  /* Recompile objects made invalid from above schema changes */  
  execute_sql ('ALTER VIEW CAMP_SEG_DET COMPILE');
  execute_sql ('ALTER VIEW OUTB_PROJECTION COMPILE');
  execute_sql ('ALTER VIEW CAMP_ANALYSIS COMPILE');
  
  execute_sql ('ALTER TRIGGER TD_CAMP_OUT_DET COMPILE');
  execute_sql ('ALTER TRIGGER TI_CAMP_OUT_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_CAMP_OUT_DET_DC COMPILE');
  execute_sql ('ALTER TRIGGER TU_CAMP_OUT_DET_FM COMPILE');
  execute_sql ('ALTER TRIGGER TU_CAMP_OUT_DET_RM COMPILE');
  execute_sql ('ALTER TRIGGER TD_DELIVERY_CHAN COMPILE');
  execute_sql ('ALTER TRIGGER TI_DELIVERY_CHAN COMPILE');
  execute_sql ('ALTER TRIGGER TU_DELIVERY_CHAN_E COMPILE');
  execute_sql ('ALTER TRIGGER TU_DELIVERY_CHAN_FS COMPILE');
  execute_sql ('ALTER TRIGGER TD_DELIVERY_SERVER COMPILE');
  execute_sql ('ALTER TRIGGER TI_DELIVERY_SERVER COMPILE');
  execute_sql ('ALTER TRIGGER TU_DELIVERY_SERVER COMPILE');
  execute_sql ('ALTER TRIGGER TD_LOOKUP_TAB_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_LOOKUP_TAB_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TU_LOOKUP_TAB_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_SPI_PROC COMPILE');
  execute_sql ('ALTER TRIGGER TU_SPI_PROC COMPILE');
  execute_sql ('ALTER TRIGGER TD_TREE_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_TREE_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_WIRELESS_INBOX COMPILE');
  execute_sql ('ALTER TRIGGER TU_WIRELESS_INBOX COMPILE');
  

  /* Schema Version Update */  
  update pvdm_upgrade set version_id = '6.3.0.0005.GA';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The V6.2.0 GA Marketing Director schema has been upgraded to V6.3.0 GA');
  dbms_output.put_line( '>' );

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('>');
    dbms_output.put_line('> The Upgrade process to V6.3.0 GA has FAILED.');
    dbms_output.put_line('>');

  WHEN OTHERS THEN
    dbms_output.put_line('>');
    dbms_output.put_line('> Procedure 3 error occurred.' );
    dbms_output.put_line('> The Upgrade process to V6.3.0 GA has FAILED.' );
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    dbms_output.put_line('> Oracle Error: '||err_num ||' '|| err_msg );
    dbms_output.put_line('>');
    dbms_output.put_line('>');
  RAISE;
END;
/

spool off;
exit;

