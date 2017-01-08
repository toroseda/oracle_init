prompt
prompt
prompt 'Marketing Director Schema Upgrade'
prompt '=================================='
prompt
accept main_view prompt 'Enter the VIEW_ID of Primary Customer Data View > '
prompt
accept v3role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt
accept ts_pv_sys prompt 'Enter the tablespace name for Marketing Director System Tables > '
prompt
accept ts_pv_ind prompt 'Enter the name of tablespace for Marketing Director System Indexes > '
prompt
accept ts_pv_indcomm prompt 'Enter the name of tablespace for Marketing Director Communication Indexes > '
prompt

spool MDUpgradeGA520.log
set SERVEROUT ON SIZE 20000



DECLARE
 
var_count  NUMBER(4):= 0;

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
	select 1 into var_count from pvdm_upgrade where version_id = '5.1.0.675';

	dbms_output.put_line( 'V5 Data Model Schema Upgrade to Build Level to V5.2.0.684');
	dbms_output.put_line( '-----------------------------------------------------------');
	dbms_output.put_line( 'Change report:');
	dbms_output.put_line( '    - addition of entities for definition of Subscription Campaigns');
	dbms_output.put_line( '      for Channel Marketing');
	dbms_output.put_line( '	   - ddition of flags to Dataview header for Channel Marketing');
	dbms_output.put_line( '>');

	execute_sql ('ALTER TABLE CAMPAIGN ADD (SUBS_CAMP_FLG NUMBER(1) DEFAULT 0 NOT NULL)');

	execute_sql ('ALTER TABLE CAMPAIGN MODIFY SUBS_CAMP_FLG DEFAULT NULL');


	execute_sql ('CREATE TABLE SUBS_CAMPAIGN (CAMP_ID NUMBER(8) NOT NULL, ORG_TYPE_ID NUMBER(4) NOT NULL, 
           INSTRUCTION VARCHAR2(300) NULL, ALL_ORG_FLG NUMBER(1) NOT NULL, DEFAULT_SUBS_FLG NUMBER(1) NOT NULL, 
           ALLOW_UNSUBS_FLG NUMBER(1) NOT NULL, INPUT_DAYS NUMBER(2) NOT NULL, REVIEW_DAYS NUMBER(2) NOT NULL, 
           AUTO_EXECUTE_FLG NUMBER(1) NOT NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMPAIGN ON SUBS_CAMPAIGN (CAMP_ID ASC)
           TABLESPACE &ts_pv_ind');

        execute_sql ('ALTER TABLE SUBS_CAMPAIGN ADD (PRIMARY KEY (CAMP_ID) 
           USING INDEX TABLESPACE &ts_pv_ind )');


	execute_sql ('CREATE TABLE SUBS_CAMP_CYC (CAMP_ID NUMBER(8) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL,
           DYN_TAB_NAME VARCHAR2(18) NULL) TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC ON SUBS_CAMP_CYC (CAMP_ID ASC, CAMP_CYC ASC) 
           TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_CYC ADD (PRIMARY KEY (CAMP_ID, CAMP_CYC) 
           USING INDEX TABLESPACE &ts_pv_ind )');

	execute_sql ('CREATE TABLE SUBS_CAMP_CYC_ORG (CAMP_ID NUMBER(8) NOT NULL, CAMP_CYC NUMBER(8) NOT NULL,
          ORG_ID VARCHAR2(50) NOT NULL, SUBS_FLG NUMBER(1) NOT NULL, EDIT_COMPLETED_FLG NUMBER(1) NOT NULL) 
          TABLESPACE &ts_pv_sys');

	execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
           ( CAMP_ID ASC, CAMP_CYC ASC, ORG_ID ASC ) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_CYC_ORG ADD ( PRIMARY KEY (CAMP_ID, CAMP_CYC, ORG_ID)
           USING INDEX TABLESPACE &ts_pv_ind )');


	execute_sql ('CREATE TABLE SUBS_CAMP_ORG_DET (CAMP_ID NUMBER(8) NOT NULL,
           CAMP_CYC NUMBER(8) NOT NULL, ORG_ID VARCHAR2(50) NOT NULL, DET_ID NUMBER(4) NOT NULL,
           INITIAL_QTY NUMBER(10) NOT NULL, LOCAL_INC_QTY NUMBER(10) NOT NULL,
           LOCAL_EXC_QTY NUMBER(10) NOT NULL ) TABLESPACE &ts_pv_sys');

        execute_sql ('CREATE UNIQUE INDEX XPKSUBS_CAMP_ORG_DET ON SUBS_CAMP_ORG_DET 
           (CAMP_ID ASC, CAMP_CYC ASC, ORG_ID ASC, DET_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('ALTER TABLE SUBS_CAMP_ORG_DET ADD (PRIMARY KEY (CAMP_ID, CAMP_CYC, ORG_ID, DET_ID) 
           USING INDEX TABLESPACE &ts_pv_ind )');

	--

	execute_sql ('CREATE INDEX XIE3CAMPAIGN ON CAMPAIGN (CAMP_NAME ASC) TABLESPACE &ts_pv_ind');
	
	execute_sql ('CREATE INDEX XIE1SUBS_CAMPAIGN ON SUBS_CAMPAIGN(ORG_TYPE_ID ASC) TABLESPACE &ts_pv_ind');

	execute_sql ('CREATE INDEX XIE1SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (ORG_ID ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE2SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (SUBS_FLG ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE3SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG (EDIT_COMPLETED_FLG ASC) TABLESPACE &ts_pv_ind');
	
	execute_sql ('CREATE INDEX XIE1SPI_CAMP_PROC ON SPI_CAMP_PROC (CAMP_ID ASC, CAMP_CYC ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE2SPI_CAMP_PROC ON SPI_CAMP_PROC (CAMP_PROC_SEQ ASC) TABLESPACE &ts_pv_ind');
	execute_sql ('CREATE INDEX XIE3SPI_CAMP_PROC ON SPI_CAMP_PROC (STATUS_SETTING_ID ASC) TABLESPACE &ts_pv_ind');

	--

	execute_sql ('ALTER TABLE DATAVIEW_TEMPL_HDR ADD (CM_FLG NUMBER(1) DEFAULT 0 NOT NULL, DEFAULT_CM_FLG NUMBER(1) DEFAULT 0 NOT NULL)');
	execute_sql ('ALTER TABLE DATAVIEW_TEMPL_HDR MODIFY (CM_FLG DEFAULT NULL, DEFAULT_CM_FLG DEFAULT NULL)');

	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMPAIGN TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_CYC TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_CYC_ORG TO &v3role');
	execute_sql ('GRANT SELECT, INSERT, UPDATE, DELETE ON SUBS_CAMP_ORG_DET TO &v3role');

	insert into vantage_ent values ('SUBS_CAMPAIGN',1,0);
	insert into vantage_ent values ('SUBS_CAMP_CYC',1,0);
	insert into vantage_ent values ('SUBS_CAMP_CYC_ORG',1,0);
	insert into vantage_ent values ('SUBS_CAMP_ORG_DET',1,0);
	COMMIT;
	
        insert into status_setting values (17, 'X', 'Published', NULL, 'This Subscription Campaign has been published to Local Marketer Organisations - this replaces Scheduled status for all Subscription Campaigns');
	COMMIT;

	insert into proc_control select 'Publish Campaign', null, 1, 'v_pubcampproc', location, 18
		from proc_control where proc_name = 'Segment Processor';
	COMMIT;

	insert into proc_param values ('Publish Campaign',0,'Server executable name','v_pubcampproc');
	insert into proc_param values ('Publish Campaign',1,'Call Type',null );
	insert into proc_param values ('Publish Campaign',2,'RPC Id / SPI Audit Id',null );
	insert into proc_param values ('Publish Campaign',3,'Process Audit Id',null );
	insert into proc_param values ('Publish Campaign',4,'Secure Database Account Name',null );
	insert into proc_param values ('Publish Campaign',5,'Secure Database Password',null );
	insert into proc_param values ('Publish Campaign',6,'Customer Data View Id',null );
	insert into proc_param values ('Publish Campaign',7,'User Id',null );
	insert into proc_param values ('Publish Campaign',8,'Database Vendor Id',null );
	insert into proc_param values ('Publish Campaign',9,'Database Connection String',null );
	insert into proc_param values ('Publish Campaign',10,'Language Id',null );
	insert into proc_param values ('Publish Campaign',11,'Campaign Id',null );
	insert into proc_param values ('Publish Campaign',12,'Campaign Cycle Number',null );
	insert into proc_param values ('Publish Campaign',13,'Segment Id',null );
	insert into proc_param values ('Publish Campaign',14,'Segment Type Id',null );
	insert into proc_param values ('Publish Campaign',15,'Dynamic CS Table Name',null );
	insert into proc_param values ('Publish Campaign',16,'Campaign Process Sequence', null);
	insert into proc_param values ('Publish Campaign',17,'Tree Sequence Number', null);
	COMMIT;

        update PVDM_UPGRADE set VERSION_ID = '5.2.0.684';
        COMMIT;

        dbms_output.put_line( '>' );
        dbms_output.put_line( '> Marketing Director Schema has been upgraded to V5.2.0 Build Level 684');
        dbms_output.put_line( '>' );
        dbms_output.put_line( '>' );

EXCEPTION

	WHEN NO_DATA_FOUND THEN

		dbms_output.put_line('>');
		dbms_output.put_line('> The upgrade to Build Level 5.2.0.684 is not applicable.');
		dbms_output.put_line('>');
		dbms_output.put_line('>');

END;
/




-- correction for RI to update reference records on update of criteria strings at save time
-- resulting in additional triggers TU_SEG_HDR_CRIT, TU_DERIVED_VAL_HTX, TU_DERIVED_VAL_HGB,
-- TU_DERIVED_VAL_HOB and TU_DERIVED_VAL_HAI

create or replace trigger TU_SEG_HDR_CRIT
  AFTER UPDATE OF 
        SEG_CRITERIA
  on SEG_HDR
  
  for each row
/* ERwin Builtin Thu Jul 19 15:58:10 2001 */
/* default body for TU_SEG_HDR_CRIT */
declare numrows INTEGER;
        var_count INTEGER;

begin
  select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
    ref_id = :old.seg_id and ref_indicator_id = 16;

  if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id 
       and ref_indicator_id = 16;
  end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HTX
  AFTER UPDATE OF 
        DERIVED_VAL_TEXT
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Thu Jul 19 15:58:11 2001 */
/* default body for TU_DERIVED_VAL_HTX */
declare numrows INTEGER;
        var_count INTEGER;

begin
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 16;

  if var_count <> 0 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 16;
  end if;

end;
/



create or replace trigger TU_DERIVED_VAL_HGB
  AFTER UPDATE OF 
        GROUP_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:59:00 2001 */
/* default body for TU_DERIVED_VAL_HGB */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.group_by is not null) then
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 17;

  if var_count <> 0 then
    delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 17;
  end if;
end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HOB
  AFTER UPDATE OF 
        ORDER_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:59:59 2001 */
/* default body for TU_DERIVED_VAL_HOB */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.order_by is not null) then
  select count(*) into var_count from referenced_obj where ref_type_id = 13 and
    ref_id = :old.derived_val_id and ref_indicator_id = 18;

  if var_count <> 0 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 18;
  end if;
end if;

end;
/


create or replace trigger TU_DERIVED_VAL_HAI
  AFTER UPDATE OF 
        ADDL_INFO
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed Jul 18 16:57:27 2001 */
/* default body for TU_DERIVED_VAL_HAI */
declare numrows INTEGER;
        var_count INTEGER;

begin
if (:old.addl_info is not null) then
   select count(*) into var_count from referenced_obj where ref_type_id = 13 and
      ref_id = :old.derived_val_id and ref_indicator_id = 19;

   if var_count <> 0 then
       delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 19;
   end if;
end if;

end;
/

spool off;

set SERVEROUT OFF
exit;
