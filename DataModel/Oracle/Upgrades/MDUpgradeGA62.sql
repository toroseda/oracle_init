
spool MDUpgradeGA62.log

prompt
prompt
prompt 'Marketing Director Build Level Schema Upgrade to GA6.2.0 (build level 1662')
prompt '============================================================================'
prompt 'Current schema must be V6.1.0 GA'
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
  select 1 into var_count from pvdm_upgrade where version_id = '6.1.0.1436.GA';

  dbms_output.put_line( '>');
  dbms_output.put_line( '> Processing Schema Upgrade from GA6.1.0 to GA6.2.0');
  dbms_output.put_line( '> -------------------------------------------------');
  dbms_output.put_line( '> Change report:');
  dbms_output.put_line( '> Change for Inbound SMS Concatenated Messages enhancement:');
  dbms_output.put_line( '>   - WIRELESS_RES table - Extend length of STRING_<n> columns from 160 to 1760');
  dbms_output.put_line( '> Changes for Delivery Time Feature enhancement:');
  dbms_output.put_line( '>   - COMM_STATUS table - Add data for Not Delivered due to DT');
  dbms_output.put_line( '>   - PROC_PRAM table - Add data for SMS Delivery');
  dbms_output.put_line( '>   - PROC_CONTROL table - Update param_count=18 for SMS Delivery entry');
  dbms_output.put_line( '>   - CAMP_OUT_RESULT table - Add column CAMP_DET_ID number(4)');
  dbms_output.put_line( '>   - CAMP_RESULT_PROC table - Add column CAMP_DET_ID number(4)');
  dbms_output.put_line( '>   - EXT_TEMPL_DET triggers - Enhanced for RI when refering Decision within an ExtractTemplate');
  dbms_output.put_line( '>   - SPI_CAMP_PROC_VAR table - Add data for incomplete SMS Campaign cycles in decomposed state');
  dbms_output.put_line( '> Change to prevent Chordiant job from aborting after running 99 times:');
  dbms_output.put_line( '>   - SEG_HDR table - Extend length of VER_NUMBER column from 2 to 4');
  dbms_output.put_line( '> Change for CUST_TAB enhancement:');
  dbms_output.put_line( '>   - CUST_TAB table - Extend length of COL_DISPLAY column from 300 to 1000');
  dbms_output.put_line( '> Changes for Segmentation Tree Folder enhancement:');
  dbms_output.put_line( '>   - TREE_GRP table - Create to allow grouping of segmentation trees ');
  dbms_output.put_line( '>   - TREE_HDR table - Add column TREE_GRP_ID to identify Tree Segment Group ');
  dbms_output.put_line( '>   - Meta data - Add to VANTAGE_ENT, OBJ_TYPE, CONSTRAINT_SETTING tables');
  dbms_output.put_line( '>   - TREE_HDR Insert/Update/Delete triggers - Create for RI with Reference Object details');
  dbms_output.put_line( '> Changes for Constructed fields to support Derived Values, Scores and Decisions:');
  dbms_output.put_line( '>   - CONS_FLD_DET table - Add columns SRC_TYPE_ID, SRC_ID, SRC_SUB_ID, ORIG_COMP_TYPE_ID ');
  dbms_output.put_line( '>   - EXT_TEMPL_DET table - Add column ORIG_COMP_TYPE_ID ');  
  dbms_output.put_line( '>   - CONS_FLD_DET table - Set correct orig_comp_type_id value for existing data');  
  dbms_output.put_line( '>   - EXT_TEMPL_DET table - Set correct orig_comp_type_id value for existing data');  
  dbms_output.put_line( '>   - CONS_FLD_DET triggers - Enhance for RI with Reference Object details');  
  dbms_output.put_line( '> Changes for Parallel Execution in task groups:');
  dbms_output.put_line( '>   - SPI_MASTER table - Add column CONCUR_EXE_FLG ');
  dbms_output.put_line( '>   - SPI_PROC table - Add column CONCUR_EXCEP_FLG ');
  dbms_output.put_line( '>');


  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_1 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_2 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_3 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_4 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_5 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_6 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_7 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_8 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_9 VARCHAR2(1760)');
  execute_sql ('ALTER TABLE WIRELESS_RES MODIFY STRING_10 VARCHAR2(1760)');
  
  execute_sql ('ALTER TABLE CAMP_OUT_RESULT ADD (CAMP_DET_ID NUMBER(4))');
  execute_sql ('ALTER TABLE CAMP_RESULT_PROC ADD (CAMP_DET_ID NUMBER(4))');
          
  execute_sql ('ALTER TABLE SEG_HDR MODIFY VER_NUMBER NUMBER(4)');

  execute_sql ('ALTER TABLE CUST_TAB MODIFY COL_DISPLAY VARCHAR2(1000)');

  execute_sql ('CREATE TABLE TREE_GRP (TREE_GRP_ID NUMBER(4) NOT NULL, 
                TREE_GRP_NAME VARCHAR2(100) NOT NULL, TREE_GRP_DESC VARCHAR2(300)) TABLESPACE &ts_pv_sys');

  execute_sql ('CREATE UNIQUE INDEX XPKTREE_GRP ON TREE_GRP (TREE_GRP_ID ASC) TABLESPACE &ts_pv_ind' );
  execute_sql ('ALTER TABLE TREE_GRP ADD PRIMARY KEY (TREE_GRP_ID) USING INDEX TABLESPACE &ts_pv_ind' );

  execute_sql ('ALTER TABLE TREE_HDR ADD (TREE_GRP_ID NUMBER(4))');

  execute_sql ('ALTER TABLE CONS_FLD_DET ADD (SRC_TYPE_ID NUMBER(3))');
  execute_sql ('ALTER TABLE CONS_FLD_DET ADD (SRC_ID NUMBER(8))');
  execute_sql ('ALTER TABLE CONS_FLD_DET ADD (SRC_SUB_ID NUMBER(6))');
  execute_sql ('ALTER TABLE CONS_FLD_DET ADD (ORIG_COMP_TYPE_ID NUMBER(2))');
  execute_sql ('ALTER TABLE EXT_TEMPL_DET ADD (ORIG_COMP_TYPE_ID NUMBER(2))');
  
  execute_sql ('ALTER TABLE SPI_MASTER ADD (CONCUR_EXE_FLG NUMBER(1))');
  execute_sql ('ALTER TABLE SPI_PROC ADD (CONCUR_EXCEP_FLG NUMBER(1))');
      
  update pvdm_upgrade set version_id = '6.2.0.1662.GA-';
  COMMIT;

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('>');
    dbms_output.put_line('The Marketing Director schema is NOT at the correct version.');
    dbms_output.put_line('Please ensure your schema version is V6.1.0.1436.GA before proceeding.');
    dbms_output.put_line('>');

  WHEN OTHERS THEN
    dbms_output.put_line('>');
    dbms_output.put_line('> Procedure 1 error occurred. Please check log file.' );
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
    dbms_output.put_line('>');
    dbms_output.put_line('>');
  RAISE;
END;
/

DECLARE

var_count  NUMBER(10):= 0;
cid INTEGER;

err_num		NUMBER;
err_msg		VARCHAR2(100);

var_camp_id      camp_status_hist.camp_id%TYPE;

CURSOR c11
IS
   SELECT camp_id, version_id, camp_hist_seq, status_setting_id, spi_id
     FROM camp_status_hist x
    WHERE status_setting_id IN (1, 2, 3, 4, 7, 8, 10, 11, 13, 15)
      AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                             FROM camp_status_hist
                            WHERE camp_id = x.camp_id)
 ORDER BY camp_id, version_id, camp_hist_seq;
 
CURSOR c22
IS
   SELECT scp.camp_id, scp.camp_cyc, scp.spi_id, scp.camp_proc_seq, scp.status_setting_id
     FROM spi_camp_proc scp, spi_camp_proc_var scpv
    WHERE scp.spi_id = scpv.spi_id
      AND scp.camp_proc_seq = scpv.camp_proc_seq
      AND scp.proc_name LIKE '%SMS%'
      AND scp.camp_id = var_camp_id
 GROUP BY scp.camp_id, scp.camp_cyc, scp.spi_id, scp.camp_proc_seq, scp.status_setting_id
   HAVING COUNT (*) = 6;

r2 c22%rowtype;
 
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

  select 1 into var_count from pvdm_upgrade where version_id = '6.2.0.1662.GA-';

  /* Complete data population and post population tasks */
  insert into COMM_STATUS (COMM_STATUS_ID, COMM_STATUS_NAME) 
  values (3, 'Not Delivered due to DT');

  insert into PROC_PARAM (PROC_NAME, PARAM_SEQ, PARAM_NAME, STANDARD_VAL)
  values ('SMS Delivery',17, 'Parent Communication Detail Id', null);

  update PROC_CONTROL set PARAM_COUNT=18 where PROC_NAME='SMS Delivery';

  insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('TREE_GRP',1,0);
  
  insert into OBJ_TYPE (OBJ_TYPE_ID, OBJ_NAME, OBJ_ABBREV) values (101, 'Tree Segment Group', null);
  
  insert into CONSTRAINT_SETTING (REF_TYPE_ID, REF_INDICATOR_ID, OBJ_TYPE_ID, CONSTRAINT_TYPE_ID) 
  values (101, 1, null, 1);
  
  insert into CONSTRAINT_SETTING (REF_TYPE_ID, REF_INDICATOR_ID, OBJ_TYPE_ID, CONSTRAINT_TYPE_ID) 
  values (4, 1, null, 1);

  COMMIT;

  /* Upgrade to v6.2, results in an increase in number of arguments for wireless delivery     */
  /* from 17 to 18 due to new parameter added to PROC_PARAM table. The SPI_CAMP_PROC_VAR      */
  /* table contains 6 (11 thru 16) instead of 7 (11 thru 17) arguments as required by new     */
  /* SMS module.The campaign cycles created in previous CMD versions that are in decomposed   */
  /* state will abort due to mismatch from the missing argument. Thus, check for incomplete   */
  /* SMS campaign cycles having only 6 (instead of 7) arguments and insert missing argument.  */                                                    


  /* Identify campaigns in failed/aborted/running/queued/paused/suspended state */
  FOR c11rec IN c11
  LOOP

     dbms_output.put_line ('------------------------------------------------------------------------------');
     dbms_output.put_line ('> CAMPAIGN[' 
                           || c11rec.camp_id
                           || '] - VERSION_ID['
                           || c11rec.version_id
                           || '],CAMP_HIST_SEQ['
                           || c11rec.camp_hist_seq
                           || '],SPI_ID['
                           || c11rec.spi_id
                           || '], STATUS_SETTING_ID['
                           || c11rec.status_setting_id
                           || ']'
                          );
  
     var_camp_id := c11rec.camp_id;
  
     /* Identify incomplete SMS campaign cycles that have missing argument */
     OPEN c22;
     <<fetch_sms_camp_cyc>>
     LOOP
        FETCH c22 INTO r2; 
        EXIT WHEN c22%NOTFOUND OR c22%NOTFOUND is null;
  
        /* Insert missing argument into SPI_CAMP_PROC_VAR to make the total argument count 18 */
        dbms_output.put_line ('-    Adding missing SPI_CAMP_PROC_VAR record - ('
                              || r2.spi_id
                              || ', '
                              || r2.camp_proc_seq
                              || ', '
                              || 17
                              || ', '
                              || 0
                              || ')'
                             );
  
  
        INSERT INTO spi_camp_proc_var (spi_id, camp_proc_seq, param_seq, var_param_val)
        VALUES (r2.spi_id, r2.camp_proc_seq, 17, '0');
  
     END LOOP fetch_sms_camp_cyc;
     CLOSE c22;
     
     COMMIT;
     
  END LOOP;
   

  /* Check if any data exists in TREE_HDR table */
  select count(*) into var_count from TREE_HDR;

  if (var_count > 0) then

    /* If data rows exist in Tree_Hdr table, assign to Default Tree Segment Group */
    insert into TREE_GRP values (1, 'Default', 'Default Tree Segment Group'); 
    update TREE_HDR set TREE_GRP_ID=1;

  end if;

  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_GRP TO &md_role'); 
  
  /* Set the orig_comp_type_id value for constructed field detail entries */
  update cons_fld_det set ORIG_COMP_TYPE_ID=0;
  
  /* Set the orig_comp_type_id value for extract template detail entries */
  update ext_templ_det set ORIG_COMP_TYPE_ID=4 where COMP_TYPE_ID=4;
  update ext_templ_det set ORIG_COMP_TYPE_ID=5 where COMP_TYPE_ID=5;
  update ext_templ_det set ORIG_COMP_TYPE_ID=0 where COMP_TYPE_ID not in (4,5);
  
  /* Correct orig_comp_type_id value for extract template entries changed */
  /* from original derived value/score model to stored field/data field type */
  update ext_templ_det set ORIG_COMP_TYPE_ID = 4
  where (ext_templ_id, line_seq) in 
  	(select a.ext_templ_id, a.line_seq
  	from ext_templ_det a, vantage_dyn_tab b
  	where a.vantage_alias=b.vantage_alias
  	and b.obj_type_id = 13
  	and a.comp_type_id != 4);
  
  update ext_templ_det set ORIG_COMP_TYPE_ID = 5
  where (ext_templ_id, line_seq) in 
  	(select a.ext_templ_id, a.line_seq
  	from ext_templ_det a, vantage_dyn_tab b
  	where a.vantage_alias=b.vantage_alias
  	and b.obj_type_id = 9
  	and a.comp_type_id != 5);

  COMMIT;

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('> ');

  WHEN OTHERS THEN
  
    CLOSE c22;

    dbms_output.put_line('>');
    dbms_output.put_line('> Procedure 2 error occurred. Please check log file.' );
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
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

  select 1 into var_count from pvdm_upgrade where version_id = '6.2.0.1662.GA-';

  /* Creation of Tree_Grp table results in new triggers TI_TREE_HDR, TU_TREE_HDR, TD_TREE_HDR */ 
  /* Create Delete Trigger TD_TREE_HDR */
execute_sql ('create or replace trigger TD_TREE_HDR
  AFTER DELETE
  on TREE_HDR
  
  for each row
/* ERwin Builtin Tue Feb 06 16:03:15 2007 */
/* default body for TD_TREE_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if (:old.tree_grp_id is not null and :old.tree_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id
    and ref_indicator_id = 1 and obj_type_id = 101 and obj_id = :old.tree_grp_id;
end if;   

end;');

  /* Create Insert Trigger TI_TREE_HDR */
execute_sql ('create or replace trigger TI_TREE_HDR
  AFTER INSERT
  on TREE_HDR
  
  for each row
/* ERwin Builtin Tue Feb 06 16:03:15 2007 */
/* default body for TI_TREE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

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
  delete from referenced_obj where ref_id = :old.tree_id
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


  /* Delivery Feature results in existing trigger updates - TD_EXT_TEMPL_DET, TI_EXT_TEMPL_DET, TU_EXT_TEMPL_DET */
  /* Create Delete Trigger TD_EXT_TEMPL_DET */
execute_sql ('create or replace trigger TD_EXT_TEMPL_DET
  AFTER DELETE
  on EXT_TEMPL_DET
 
  for each row
/* ERwin Builtin Wed Mar 14 19:32:20 2007 */
/* default body for TD_EXT_TEMPL_DET */
declare numrows INTEGER;

begin

if :old.comp_type_id = 4 then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 13 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 5 then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 9 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 3 then   /* old linked component is constructed field */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 31 and obj_id = :old.comp_id;

elsif :old.comp_type_id in (31,32,33) then  /* old linked component is custom attribute */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;

elsif :old.comp_type_id = 35 then   /* old linked component is decision */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 99 and obj_id = :old.comp_id;

end if;

end;');

  /* Create Insert Trigger TI_EXT_TEMPL_DET */
execute_sql ('create or replace trigger TI_EXT_TEMPL_DET
  AFTER INSERT
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Wed Mar 14 19:32:20 2007 */
/* default body for TI_EXT_TEMPL_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.comp_type_id = 4 then   /* new linked component is derived value */
  /* check this derived value source exists */
  select derived_val_id into var_id from derived_val_src where derived_val_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id; 

  /* Obj_type 13 = Derived Values, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 13, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and 
    (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* new linked component is score model */
  /* check that referenced score model source (tree segment) still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  /* Obj_type 9 = Score, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 9, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and 
    (obj_type_id = 9 or obj_type_id is null);

elsif :new.comp_type_id = 3 then   /* new linked component is constructed field */
  /* check that referenced constructed field still exists */
  select cons_id into var_id from cons_fld_hdr where cons_id = :new.comp_id;

  /* Obj_type 31 = Constructed Field, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 31, :new.comp_id, null, null, null, null, null,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 31 or obj_type_id is null);

elsif :new.comp_type_id in (31,32,33) then /* new linked component is custom attribute */
  /* check that referenced custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  /* Obj_type 98 = Custom Attribute, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 98 or obj_type_id is null);

elsif :new.comp_type_id = 35 then /* new linked component is decision */
  /* check that referenced decision still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  /* Obj_type 99 = Decision Logic Segment, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 99, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 99 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');

  /* Create Update Trigger TU_EXT_TEMPL_DET */
execute_sql ('create or replace trigger TU_EXT_TEMPL_DET
  AFTER UPDATE OF 
        COMP_TYPE_ID,
        COMP_ID,
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Wed Mar 14 19:32:20 2007 */
/* default body for TU_EXT_TEMPL_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
  
if :old.comp_type_id = 4 then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 13 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 5 then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 9 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 3 then   /* old linked component is constructed field */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 31 and obj_id = :old.comp_id;

elsif :old.comp_type_id in (31,32,33) then  /* old linked component is custom attribute */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;

elsif :old.comp_type_id = 35 then   /* old linked component is decision */
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id and ref_sub_id = :old.line_seq
    and ref_indicator_id = 3 and obj_type_id = 99 and obj_id = :old.comp_id;

end if;

if :new.comp_type_id = 4 then   /* new linked component is derived value */
  /* check this derived value source exists */
  select derived_val_id into var_id from derived_val_src where derived_val_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id; 

  insert into referenced_obj select 13, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and 
    (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* new linked component is score model */
  /* check that referenced score model source (tree segment) still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  insert into referenced_obj select 9, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and 
    (obj_type_id = 9 or obj_type_id is null);

elsif :new.comp_type_id = 3 then   /* new linked component is constructed field */
  /* check that referenced constructed field still exists */
  select cons_id into var_id from cons_fld_hdr where cons_id = :new.comp_id;

  insert into referenced_obj select 31, :new.comp_id, null, null, null, null, null,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 31 or obj_type_id is null);

elsif :new.comp_type_id in (31,32,33) then /* new linked component is custom attribute */
  /* check that referenced custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 98 or obj_type_id is null);

elsif :new.comp_type_id = 35 then /* new linked component is decision */
  /* check that referenced decision still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  insert into referenced_obj select 99, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 99 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');


  /* Constructed fields support for Derived Values, Scores and Decisions results in existing trigger */
  /* updates - TD_CONS_FLD_DET, TI_CONS_FLD_DET, TU_CONS_FLD_DET */
  /* Create Delete Trigger TD_CONS_FLD_DET */
execute_sql ('create or replace trigger TD_CONS_FLD_DET
  AFTER DELETE
  on CONS_FLD_DET

  for each row
/* ERwin Builtin Thu Mar 29 15:05:26 2007 */
/* default body for TD_CONS_FLD_DET */
declare numrows INTEGER;

begin

if :old.comp_type_id in (31,32,33) and :old.comp_id is not null then   /* old linked component is custom attribute */
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;

elsif :old.comp_type_id = 4 and :old.comp_id is not null then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id 
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 13 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 5 and :old.comp_id is not null then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos
    and ref_indicator_id = 3 and obj_type_id = 9 and obj_id = :old.comp_id; 

elsif :old.comp_type_id = 35 and :old.comp_id is not null then   /* old linked component is decision */
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos
    and ref_indicator_id = 3 and obj_type_id = 99 and obj_id = :old.comp_id;

end if;

end;');

  /* Create Insert Trigger TI_CONS_FLD_DET */
execute_sql ('create  or replace trigger TI_CONS_FLD_DET
  AFTER INSERT
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Mar 29 15:05:42 2007 */
/* default body for TI_CONS_FLD_DET */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :new.comp_type_id in (31,32,33) and :new.comp_id is not null then
  /* check associated custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;
  
  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
    (obj_type_id = 98 or obj_type_id is null);

elsif :new.comp_type_id = 4 and :new.comp_id is not null then   /* new linked component is derived value */
  /* check that referenced derived value source still exists */
  select derived_val_id into var_id from derived_val_src where derived_val_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id; 
  
  insert into referenced_obj select 13, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and 
    (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 and :new.comp_id is not null then   /* new linked component is score model */
  /* check that referenced score model source still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  insert into referenced_obj select 9, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and 
    (obj_type_id = 9 or obj_type_id is null);

elsif :new.comp_type_id =35 and :new.comp_id is not null then   /* new linked component is decision */
  /* check that referenced decision still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;
  
  insert into referenced_obj select 99, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and 
    (obj_type_id = 99 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, ''Referenced object does not exist'');
when OTHERS then
   raise_application_error (-20002, ''Trigger error'');
end;');  
  

  /* Create Update Trigger TU_CONS_FLD_DET */
execute_sql ('create  or replace trigger TU_CONS_FLD_DET
  AFTER UPDATE OF 
        CONS_ID,
        CONS_FLD_SEQ,
        BLOCK_POS,
        COMP_TYPE_ID,
        COMP_ID
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Mar 29 15:05:58 2007 */
/* default body for TU_CONS_FLD_DET */
declare numrows INTEGER;
        var_id INTEGER;
begin
  
if :old.comp_type_id in (31,32,33) and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;

elsif :old.comp_type_id =4 and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 13 and obj_id = :old.comp_id;

elsif :old.comp_type_id =5 and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 9 and obj_id = :old.comp_id;

elsif :old.comp_type_id =35 and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 99 and obj_id = :old.comp_id;

end if;

if :new.comp_type_id in (31,32,33) then
  /* check associated custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
    (obj_type_id = 98 or obj_type_id is null);

elsif :new.comp_type_id = 4 then
  /* check associated derived value still exists */
  select derived_val_id into var_id from derived_val_src where derived_val_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id; 
  
  insert into referenced_obj select 13, :new.comp_id, null, null, null, null, null, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
    (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then
  /* check associated score model still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  insert into referenced_obj select 9, :new.comp_id, null, null, null, null, null, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
    (obj_type_id = 9 or obj_type_id is null);

elsif :new.comp_type_id = 35 then
  /* check associated decision still exists */
  select score_id into var_id from score_src where score_id = :new.comp_id
    and src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  insert into referenced_obj select 99, :new.comp_id, null, null, null, null, null, 
    31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
    (obj_type_id = 99 or obj_type_id is null);

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
  execute_sql ('ALTER VIEW VANTAGE_ALL_TAB COMPILE');
  
  execute_sql ('ALTER TRIGGER TI_CAMP_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_CAMP_DET COMPILE');
  execute_sql ('ALTER TRIGGER TI_CAMP_VERSION COMPILE');
  execute_sql ('ALTER TRIGGER TU_CAMP_VER_WEBSEG COMPILE');
  execute_sql ('ALTER TRIGGER TI_DATA_REP_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TU_DATA_REP_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TI_DERIVED_VAL_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TU_DERIVED_VAL_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_DERIVED_VAL_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TU_DERIVED_VAL_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TI_EV_CAMP_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_EV_CAMP_DET COMPILE');
  execute_sql ('ALTER TRIGGER TI_RES_STREAM_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_RES_STREAM_DETS COMPILE');
  execute_sql ('ALTER TRIGGER TI_SEG_DEDUPE_PRIO COMPILE');
  execute_sql ('ALTER TRIGGER TU_SEG_DEDUPE_PRIO COMPILE');
  execute_sql ('ALTER TRIGGER TD_SEG_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TI_SCORE_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_SCORE_DET COMPILE');
  execute_sql ('ALTER TRIGGER TI_SCORE_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TU_SCORE_SRC COMPILE');
  execute_sql ('ALTER TRIGGER TI_SEG_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TU_SEG_HDR COMPILE');
  execute_sql ('ALTER TRIGGER TD_SPI_PROC COMPILE');
  execute_sql ('ALTER TRIGGER TI_SPI_PROC COMPILE');
  execute_sql ('ALTER TRIGGER TU_SPI_PROC COMPILE');
  execute_sql ('ALTER TRIGGER TI_STORED_FLD_TMPL COMPILE');
  execute_sql ('ALTER TRIGGER TU_STORED_FLD_TMPL COMPILE');
  execute_sql ('ALTER TRIGGER TI_TREE_BASE COMPILE');
  execute_sql ('ALTER TRIGGER TU_TREE_BASE COMPILE');
  execute_sql ('ALTER TRIGGER TI_TREE_DET COMPILE');
  execute_sql ('ALTER TRIGGER TU_TREE_DET COMPILE');
  

  update pvdm_upgrade set version_id = '6.2.0.1662.GA';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> The V6.1.0 GA Marketing Director schema has been upgraded to V6.2.0 GA');
  dbms_output.put_line( '>' );

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('>');
    dbms_output.put_line('The Upgrade process to V6.2.0 GA has FAILED.');
    dbms_output.put_line('>');

  WHEN OTHERS THEN
    dbms_output.put_line('>');
    dbms_output.put_line('> Procedure 3 error occurred. Please check log file.' );
    dbms_output.put_line('> The Upgrade process to V6.2.0 GA has FAILED.' );
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

