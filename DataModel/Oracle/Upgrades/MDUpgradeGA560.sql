prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt
accept ts_pv_sys prompt 'Enter the tablespace name for Marketing Director System Tables > '
prompt
accept ts_pv_ind prompt 'Enter the name of tablespace for Marketing Director System Indexes > '
prompt
accept ts_pv_indcomm prompt 'Enter the name of tablespace for Marketing Director Communication Indexes > '
prompt
prompt

spool MDUpgradeGA560.log
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

  dbms_output.put_line( 'Processing Schema Upgrade from V5.5.0 to V5.6.0');
  dbms_output.put_line( '-------------------------------------------------');
  dbms_output.put_line( 'Change report:');
  dbms_output.put_line( 'Correction to OUTB_PROJECTION view - re: CQDB103021853');
  dbms_output.put_line( 'Changes for Additional Fields Module:');
  dbms_output.put_line( '     - New entities: CUSTOM_ATTR, ATTR_DEFINITION, CUSTOM_ATTR_VAL ');
  dbms_output.put_line( '     - Additions to COMP_TYPE list of values');
  dbms_output.put_line( '     - New entry in OBJ_TYPE for Custom Attribute object type ');
  dbms_output.put_line( '     - New entries into CONSTRAINT_SETTING table to aid RI for Custom Attributes');
  dbms_output.put_line( '     - New Triggers on CUSTOM_ATTR_VAL table to implement RI ');
  dbms_output.put_line( '       for Custom Attributes associated with other objects' );
  dbms_output.put_line( '     - Add new column INC_EMAIL_FLG to EXT_TEMPL_DET table' );
  dbms_output.put_line( '     - Add new entry for Custom Attribute into COMP_TYPE lookup table ');
  dbms_output.put_line( '     - Add new entry for UCP protocol into WIRELESS_PROTOCOL lookup table ');
  dbms_output.put_line( '     - Alter the OUT_LENGTH column size in EXT_TEMPL_DET, EXT_HDR_AND_FTR,'); 
  dbms_output.put_line( '       CONS_FLD_DET and 0UT_GRP_NAME_COMP tables to accommodate value up to 1000');
  dbms_output.put_line( '     - Add COMP_ID attribute to CONS_FLD_DET and EXT_HDR_AND_FTR tables ');
  dbms_output.put_line( '       for associated custom attribute');
  dbms_output.put_line( '     - Add index on EMAIL_RES for RES_DATE, RES_TIME re: CQDB103022357');
  dbms_output.put_line( 'Security Data Correction re: access to Email Settings Module,');
  dbms_output.put_line( '      where access to Campaign Builder exists already - re: CQDB103020972');
  dbms_output.put_line( 'Correction: added entries in NPI_TYPE and TON_TYPE lookup tables');
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
 

  execute_sql( 'CREATE TABLE DEFINE_TYPE ( DEFINE_TYPE_ID NUMBER(2) NOT NULL, 
     DEFINE_TYPE_NAME VARCHAR2(100) NOT NULL ) TABLESPACE &ts_pv_sys');

  execute_sql ( 'CREATE UNIQUE INDEX XPKDEFINE_TYPE ON DEFINE_TYPE ( DEFINE_TYPE_ID ASC )
     TABLESPACE &ts_pv_ind' );

  execute_sql( 'ALTER TABLE DEFINE_TYPE ADD ( PRIMARY KEY (DEFINE_TYPE_ID)
     USING INDEX TABLESPACE &ts_pv_ind )' );

  execute_sql( 'CREATE TABLE CUSTOM_ATTR (ATTR_ID NUMBER(8) NOT NULL, ATTR_NAME VARCHAR2(50) NOT NULL, 
     ATTR_DESC VARCHAR2(300) NULL, DEFINE_TYPE_ID NUMBER(2) NOT NULL, COMP_TYPE_ID NUMBER(2) NOT NULL, 
     ASSOC_OBJ_TYPE_ID NUMBER(2) NOT NULL, LOOKUP_ENT_OWNER VARCHAR2(128) NULL, LOOKUP_ENT VARCHAR2(128) NULL,
     LOOKUP_VAL_COL VARCHAR2(128) NULL, WHERE_FLG NUMBER(1) NULL, WHERE_COL VARCHAR2(128) NULL,
     WHERE_VAL VARCHAR2(100) NULL) TABLESPACE &ts_pv_sys' );

  execute_sql ( 'CREATE UNIQUE INDEX XPKCUSTOM_ATTR ON CUSTOM_ATTR ( ATTR_ID ASC )
     TABLESPACE &ts_pv_ind' );

  execute_sql( 'ALTER TABLE CUSTOM_ATTR ADD (PRIMARY KEY (ATTR_ID) USING INDEX TABLESPACE &ts_pv_ind )' );

  execute_sql( 'CREATE TABLE CUSTOM_ATTR_VAL ( ASSOC_OBJ_TYPE_ID NUMBER(2) NOT NULL, ASSOC_OBJ_ID NUMBER(8) NOT NULL,
     ASSOC_OBJ_SUB_ID NUMBER(8) NOT NULL, ATTR_ID NUMBER(8) NOT NULL, ATTR_SEQ NUMBER(4) NOT NULL,
     VAL_TEXT VARCHAR2(1000) NULL, VAL_INTEGER NUMBER(10) NULL, VAL_DECIMAL NUMBER(12,3) NULL, VAL_DATE DATE NULL) 
     TABLESPACE &ts_pv_sys' );

  execute_sql ( 'CREATE UNIQUE INDEX XPKCUSTOM_ATTR_VAL ON CUSTOM_ATTR_VAL ( ASSOC_OBJ_TYPE_ID ASC, 
     ASSOC_OBJ_ID ASC, ASSOC_OBJ_SUB_ID ASC, ATTR_ID ASC, ATTR_SEQ ASC )
     TABLESPACE &ts_pv_ind' );

  execute_sql( 'ALTER TABLE CUSTOM_ATTR_VAL ADD ( PRIMARY KEY (ASSOC_OBJ_TYPE_ID, ASSOC_OBJ_ID, 
     ASSOC_OBJ_SUB_ID, ATTR_ID, ATTR_SEQ) USING INDEX TABLESPACE &ts_pv_ind )' );

  execute_sql( 'CREATE TABLE ATTR_DEFINITION ( ATTR_ID NUMBER(8) NOT NULL, VAL_ID NUMBER(4) NOT NULL,
     VAL_TEXT VARCHAR2(1000) NULL, VAL_INTEGER NUMBER(10) NULL, VAL_DECIMAL NUMBER(12,3) NULL,
     VAL_DATE DATE NULL ) TABLESPACE &ts_pv_sys' );

  execute_sql ( 'CREATE UNIQUE INDEX XPKATTR_DEFINITION ON ATTR_DEFINITION ( ATTR_ID ASC, VAL_ID ASC )
     TABLESPACE &ts_pv_ind' );

  execute_sql( 'ALTER TABLE ATTR_DEFINITION ADD ( PRIMARY KEY (ATTR_ID, VAL_ID) 
     USING INDEX TABLESPACE &ts_pv_ind )');

  execute_sql( 'ALTER TABLE EXT_TEMPL_DET ADD (INC_EMAIL_FLG NUMBER(1) DEFAULT 0 NOT NULL)');
  execute_sql( 'ALTER TABLE EXT_TEMPL_DET MODIFY (OUT_LENGTH NUMBER(4))');
  execute_sql( 'ALTER TABLE EXT_HDR_AND_FTR MODIFY (OUT_LENGTH NUMBER(4))');
  execute_sql( 'ALTER TABLE CONS_FLD_DET MODIFY (OUT_LENGTH NUMBER(4))');
  execute_sql( 'ALTER TABLE OUT_GRP_NAME_COMP MODIFY (OUT_LENGTH NUMBER(4))');
  execute_sql( 'ALTER TABLE CONS_FLD_DET ADD (COMP_ID NUMBER(8) NULL)');
  execute_sql( 'ALTER TABLE EXT_HDR_AND_FTR ADD (COMP_ID NUMBER(8) NULL)');
	
  /* check that new index on EMAIL_RES table does not exists already - this has been provided */
  /* as an intermediary fix for specific customers in V5.5 via fix script AddEmailResDateInd.sql */

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

  insert into vantage_ent values ('ATTR_DEFINITION',1,0);
  insert into vantage_ent values ('CUSTOM_ATTR',1,0);
  insert into vantage_ent values ('CUSTOM_ATTR_VAL',1,0);
  insert into vantage_ent values ('DEFINE_TYPE',1,1);
  COMMIT;

  insert into comp_type values (29, 'Integer');
  insert into comp_type values (30, 'Decimal');
  insert into comp_type values (31, 'Campaign Custom Attribute');
  insert into comp_type values (32, 'Treatment Custom Attribute');
  insert into comp_type values (33, 'Delivery Channel Custom Attribute');
  insert into comp_type values (34, 'Version ID');
  COMMIT;
	
  insert into obj_type values (98, 'Custom Attribute', NULL);
  COMMIT;

  insert into ref_indicator values (29, 'Header and Footer');
  COMMIT;

  insert into constraint_setting (ref_type_id, ref_indicator_id, obj_type_id, constraint_type_id)
    values (24, 1, 98, 2);
  insert into constraint_setting (ref_type_id, ref_indicator_id, obj_type_id, constraint_type_id)
    values (11, 1, 98, 2);
  insert into constraint_setting (ref_type_id, ref_indicator_id, obj_type_id, constraint_type_id)
    values (18, 1, 98, 2);
  insert into constraint_setting (ref_type_id, ref_indicator_id, obj_type_id, constraint_type_id)
    values (12, 29, null, 2);
  insert into constraint_setting (ref_type_id, ref_indicator_id, obj_type_id, constraint_type_id)
    values (31, 3, null, 2);
  COMMIT;

  insert into wireless_protocol values (4, 'UCP', 40);
  COMMIT;

  insert into TON_TYPE values (5,'Alphanumeric');
  insert into TON_TYPE values (6,'Abbreviated number');
  COMMIT;

  insert into NPI_TYPE values (5,'Centre Specific Plan (5)');
  insert into NPI_TYPE values (6,'Centre Specific Plan (6)');
  COMMIT;

  update pvdm_upgrade set version_id = '5.6.0.986-';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> First part of the upgrade completed successfully (1)');
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

select 1 into var_count from pvdm_upgrade where version_id = '5.6.0.986-';

  insert into define_type values (1, 'Define List');
  insert into define_type values (2, 'Lookup List');
  insert into define_type values (3, 'Free Text');
  COMMIT;

  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON DEFINE_TYPE TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON CUSTOM_ATTR TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON CUSTOM_ATTR_VAL TO &md_role');
  execute_sql ('GRANT SELECT, UPDATE, INSERT, DELETE ON ATTR_DEFINITION TO &md_role');
  

  select count(user_grp_id) into var_count from user_grp_access x where module_id = 15 
    and user_access_id > 0 and not exists (select * from user_grp_access 
    where user_grp_id = x.user_grp_id and view_id = x.view_id and module_id = 45);

  if (var_count > 0) then
 
    insert into user_grp_access select user_grp_id, view_id, 45, 0, 1, 1, 1 
       from user_grp_access x where module_id = 15 and user_access_id > 0  
       and not exists (select * from user_grp_access where user_grp_id = x.user_grp_id
       and view_id = x.view_id and module_id = 45);
    COMMIT;
 
  else

    select count(user_grp_id) into var_count from user_grp_access x where module_id = 45
	and (all_access_id = 0 or (grp_access_id = 0 or user_access_id = 0)) 
        and exists (select * from user_grp_access where user_grp_id = x.user_grp_id 
        and view_id = x.view_id and module_id = 15 and user_access_id > 0);

    if (var_count > 0) then

	update user_grp_access x set all_access_id = 1, grp_access_id = 1, 
	  user_access_id = 1 where module_id = 45  
          and (all_access_id = 0 or (grp_access_id = 0 or user_access_id = 0)) 
          and exists (select * from user_grp_access where user_grp_id = x.user_grp_id
	  and view_id = x.view_id and module_id = 15 and user_access_id > 0);         
        COMMIT;
    end if;
    
  end if;

  select count(user_id) into var_count from user_access_excep x where module_id = 15
    and user_access_id > 0 and not exists (select * from user_access_excep 
    where user_id = x.user_id and view_id = x.view_id and module_id = 45);

  if (var_count > 0) then
   
     insert into user_access_excep (user_id, view_id, module_id, copy_obj_flg,
       all_access_id, grp_access_id, user_access_id) select user_id, view_id, 
       45, 0,1,1,1 from user_access_excep x where module_id = 15 and user_access_id > 0  
       and not exists (select * from user_access_excep where user_id = x.user_id
       and view_id = x.view_id and module_id = 45);
     COMMIT;

  else

     select count(user_id) into var_count from user_access_excep x where module_id = 45
       and (all_access_id = 0 or (grp_access_id = 0 or user_access_id = 0))
       and exists (select * from user_access_excep where user_id = x.user_id 
       and view_id = x.view_id and module_id = 15 and user_access_id > 0);

     if (var_count > 0) then

	update user_access_excep x set all_access_id = 1, grp_access_id = 1,
	   user_access_id = 1 where module_id = 45 
           and (all_access_id = 0 or (grp_access_id = 0 or user_access_id = 0)) 
           and exists (select * from user_access_excep where user_id = x.user_id 
           and view_id = x.view_id and module_id = 15 and user_access_id > 0) ;
        COMMIT;

    end if;  
  end if;  

  update pvdm_upgrade set version_id = '5.6.0.986';
  COMMIT;

  dbms_output.put_line( '>' );
  dbms_output.put_line( '> V5.5.0 Marketing Director Schema has been upgraded to V5.6.0 build 986');
  dbms_output.put_line( '>' );
  dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('>');

	WHEN OTHERS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure (2) error occurred.' );
		err_num := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 100);
		dbms_output.put_line ('Oracle Error: '||err_num ||' '|| err_msg );
		dbms_output.put_line('>');
		dbms_output.put_line('>');
		RAISE;
END;
/

-- Triggers for RI on Custom Attributes associated with Campaign, Treatment or Delivery Channel

create or replace trigger TD_CUSTOM_ATTR_VAL
  AFTER DELETE
  on CUSTOM_ATTR_VAL
  
  for each row
/* ERwin Builtin Tue May 13 17:51:05 2003 */
/* default body for TD_CUSTOM_ATTR_VAL */
declare numrows INTEGER;

begin

  delete from referenced_obj where ref_type_id = :old.assoc_obj_type_id and
    ref_id = :old.assoc_obj_id and ( ref_sub_id = :old.assoc_obj_sub_id or
    (:old.assoc_obj_sub_id = 0 and ref_sub_id is null) ) and obj_type_id = 98 
    and obj_id = :old.attr_id and obj_sub_id = :old.attr_seq;

end;
/


create or replace trigger TI_CUSTOM_ATTR_VAL
  AFTER INSERT
  on CUSTOM_ATTR_VAL
  
  for each row
/* ERwin Builtin Tue May 13 17:51:17 2003 */
/* default body for TI_CUSTOM_ATTR_VAL */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check that the referenced custom attribute still exists */
select attr_id into var_id from custom_attr where attr_id = :new.attr_id;  

insert into referenced_obj select 98, :new.attr_id, :new.attr_seq,
  null, null, null, null, :new.assoc_obj_type_id, :new.assoc_obj_id, 
  decode( :new.assoc_obj_sub_id, 0, null, :new.assoc_obj_sub_id), 
  null, null, 1, constraint_type_id from constraint_setting
  where ref_type_id = :new.assoc_obj_type_id and ref_indicator_id = 1 and 
  (obj_type_id = 98 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
  raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
  raise_application_error (-20002, 'Trigger error');

end;
/


create or replace trigger TU_CUSTOM_ATTR_VAL
  AFTER UPDATE
  on CUSTOM_ATTR_VAL
  
  for each row
/* ERwin Builtin Tue May 13 17:51:29 2003 */
/* default body for TU_CUSTOM_ATTR_VAL */
declare numrows INTEGER;
        var_id INTEGER;

begin

  delete from referenced_obj where ref_type_id = :old.assoc_obj_type_id and
    ref_id = :old.assoc_obj_id and ( ref_sub_id = :old.assoc_obj_sub_id or
    (:old.assoc_obj_sub_id = 0 and ref_sub_id is null) ) and obj_type_id = 98 
    and obj_id = :old.attr_id and obj_sub_id = :old.attr_seq;

/* check that the referenced custom attribute still exists */
select attr_id into var_id from custom_attr where attr_id = :new.attr_id;  

insert into referenced_obj select 98, :new.attr_id, :new.attr_seq,
  null, null, null, null, :new.assoc_obj_type_id, :new.assoc_obj_id, 
  decode( :new.assoc_obj_sub_id, 0, null, :new.assoc_obj_sub_id), 
  null, null, 1, constraint_type_id from constraint_setting
  where ref_type_id = :new.assoc_obj_type_id and ref_indicator_id = 1 and 
  (obj_type_id = 98 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
  raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
  raise_application_error (-20002, 'Trigger error');

end;
/

/* New or modified triggers for RI on Custom Attributes associated with Extract Templates and Constructed Fields */

create or replace trigger TD_EXT_TEMPL_DET
  AFTER DELETE
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:31:55 2003 */
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
end if;

end;
/

create or replace trigger TI_EXT_TEMPL_DET
  AFTER INSERT
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:32:23 2003 */
/* default body for TI_EXT_TEMPL_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

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

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create or replace trigger TU_EXT_TEMPL_DET
  AFTER UPDATE OF 
        COMP_TYPE_ID,
        COMP_ID,
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:32:36 2003 */
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
end if;


EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_EXT_HDR_AND_FTR
  AFTER DELETE
  on EXT_HDR_AND_FTR
  
  for each row
/* ERwin Builtin Thu Jun 26 12:33:59 2003 */
/* default body for TD_EXT_HDR_AND_FTR */
declare numrows INTEGER;

begin

if :old.comp_type_id in (31,32,33) then
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id
    and ref_sub_id = :old.record_type and ref_det_id = :old.seq_number 
    and ref_indicator_id = 29 and obj_type_id = 98 and obj_id = :old.comp_id;
end if;

end;
/


create or replace trigger TI_EXT_HDR_AND_FTR
  AFTER INSERT
  on EXT_HDR_AND_FTR
  
  for each row
/* ERwin Builtin Thu Jun 26 12:34:16 2003 */
/* default body for TI_EXT_HDR_AND_FTR */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :new.comp_type_id in (31,32,33) then

  /* check associated custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null, 
     12, :new.ext_templ_id, :new.record_type, :new.seq_number, null, 29, constraint_type_id
     from constraint_setting where ref_type_id = 12 and ref_indicator_id = 29 and
     (obj_type_id = 98 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_EXT_HDR_AND_FTR
  AFTER UPDATE OF 
        EXT_TEMPL_ID,
        RECORD_TYPE,
        SEQ_NUMBER,
        COMP_TYPE_ID,
        COMP_ID
  on EXT_HDR_AND_FTR
  
  for each row
/* ERwin Builtin Thu Jun 26 12:34:26 2003 */
/* default body for TU_EXT_HDR_AND_FTR */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :old.comp_type_id in (31,32,33) and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 12 and ref_id = :old.ext_templ_id
    and ref_sub_id = :old.record_type and ref_det_id = :old.seq_number 
    and ref_indicator_id = 29 and obj_type_id = 98 and obj_id = :old.comp_id;
end if;

if :new.comp_type_id in (31,32,33) then
  /* check associated custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null, 
     12, :new.ext_templ_id, :new.record_type, :new.seq_number, null, 29, constraint_type_id
     from constraint_setting where ref_type_id = 12 and ref_indicator_id = 29 and
     (obj_type_id = 98 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TD_CONS_FLD_DET
  AFTER DELETE
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:36:18 2003 */
/* default body for TD_CONS_FLD_DET */
declare numrows INTEGER;

begin

if :old.comp_type_id in (31,32,33) and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;
end if;

end;
/


create or replace trigger TI_CONS_FLD_DET
  AFTER INSERT
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:36:39 2003 */
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
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create or replace trigger TU_CONS_FLD_DET
  AFTER UPDATE OF 
        CONS_ID,
        CONS_FLD_SEQ,
        BLOCK_POS,
        COMP_TYPE_ID,
        COMP_ID
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:36:49 2003 */
/* default body for TU_CONS_FLD_DET */
declare numrows INTEGER;
        var_id INTEGER;
begin
if :old.comp_type_id in (31,32,33) and :old.comp_id is not null then
  delete from referenced_obj where ref_type_id = 31 and ref_id = :old.cons_id
    and ref_sub_id = :old.cons_fld_seq and ref_det_id = :old.block_pos 
    and ref_indicator_id = 3 and obj_type_id = 98 and obj_id = :old.comp_id;
end if;

if :new.comp_type_id in (31,32,33) then
  /* check associated custom attribute still exists */
  select attr_id into var_id from custom_attr where attr_id = :new.comp_id;

  insert into referenced_obj select 98, :new.comp_id, null, null, null, null, null, 
     31, :new.cons_id, :new.cons_fld_seq, :new.block_pos, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 31 and ref_indicator_id = 3 and
     (obj_type_id = 98 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

spool off;
exit;



