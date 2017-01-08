prompt
prompt
prompt 'Marketing Director Build Level Schema Upgrade to V610 build level Release 1'
prompt '==========================================================================='
prompt 'Current schema must be V6.0 GA'
prompt '------------------------------'
prompt
prompt 'This upgrade adds the initial Data Model structures for Components Migration Module'
prompt
prompt 'Extends OBJ_ABBREV column in OBJ_TYPE table from 2 to 30 to accommodate new strings needed for CO processing'	
prompt 'Extends DYN_TAB_NAME length from 18 to 30 re: CQDB104003489'
prompt
accept ts_pv_sys prompt 'Enter the name of Marketing Director system data tablespace > '
prompt
accept ts_pv_ind prompt 'Enter the name of Marketing Director index data tablespace > '
prompt
accept md_role prompt 'Enter the name of Marketing Director Application Role > '
prompt
prompt

spool MDUpgradeV60GA_toV61BL_R1.log
set SERVEROUT ON SIZE 20000

/* New entities for Export and Import */

CREATE TABLE EXPORT_HDR (
       EXPORT_ID            NUMBER(8) NOT NULL,
       FILENAME             VARCHAR2(50) NOT NULL,
       EXPORT_DESC          VARCHAR2(300) NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_SUB_ID	    NUMBER(6) NULL,
       OBJ_NAME             VARCHAR2(100) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CAMP_STATUS_ID       NUMBER(2) NULL,
       INC_DYN_TAB_FLG      NUMBER(1) NOT NULL,
       INC_CAMP_COMM_FLG    NUMBER(1) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       RUN_DATE             DATE NULL,
       RUN_TIME             CHAR(8) NULL
)
    	 TABLESPACE &ts_pv_sys
;


CREATE UNIQUE INDEX XPKEXPORT_HDR ON EXPORT_HDR
(
	EXPORT_ID	ASC
)
	TABLESPACE &ts_pv_ind
;

ALTER TABLE EXPORT_HDR
       ADD  ( PRIMARY KEY (EXPORT_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;


CREATE INDEX XIE1EXPORT_HDR ON EXPORT_HDR
(
	OBJ_TYPE_ID	ASC,
	OBJ_ID		ASC
)
	TABLESPACE &ts_pv_ind
;


CREATE TABLE IMPORT_HDR (
       IMPORT_ID            NUMBER(8) NOT NULL,
       FILENAME             VARCHAR2(50) NOT NULL,
       IMPORT_DESC          VARCHAR2(300) NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_SUB_ID           NUMBER(6) NULL,
       OBJ_NAME             VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       INC_DYN_TAB_FLG      NUMBER(1) NOT NULL,
       INC_COMM_TAB_FLG     NUMBER(1) NOT NULL,
       IMPORT_TYPE_ID       NUMBER(2) NOT NULL,
       REPLACE_TYPE_ID      NUMBER(2) NOT NULL,
       IMPORT_VIEW_ID       VARCHAR2(30) NULL,
       EXPORT_BY            VARCHAR2(30) NULL,
       EXPORT_DATE          DATE NOT NULL,
       EXPORT_TIME          CHAR(8) NULL,
       EXPORT_SERVER_NAME   VARCHAR2(50) NULL,
       EXPORT_CONNECTION    VARCHAR2(50) NULL,
       EXPORT_VIEW_ID       VARCHAR2(30) NULL,
       RUN_DATE             DATE NULL,
       RUN_TIME             CHAR(8) NULL
)
    	 TABLESPACE &ts_pv_sys
;


CREATE UNIQUE INDEX XPKIMPORT_HDR ON IMPORT_HDR
(
	IMPORT_ID	ASC
)
	TABLESPACE &ts_pv_ind
;


ALTER TABLE IMPORT_HDR
       ADD  ( PRIMARY KEY (IMPORT_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;


CREATE INDEX XIE1IMPORT_HDR ON IMPORT_HDR
(
	OBJ_TYPE_ID	ASC,
	OBJ_ID		ASC,
)
	TABLESPACE &ts_pv_ind
;

CREATE TABLE IMPORT_OBJ_MAP (
       IMPORT_ID            NUMBER(8) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_SUB_ID           NUMBER(6) NULL,
       ORIGIN_OBJ_ID        NUMBER(8) NOT NULL,
       ORIGIN_OBJ_SUB_ID    NUMBER(6) NULL
)
    	 TABLESPACE &ts_pv_sys
;


CREATE UNIQUE INDEX XPKIMPORT_OBJ_MAP ON IMPORT_OBJ_MAP
(
	IMPORT_ID	ASC,
	OBJ_TYPE_ID	ASC,
	OBJ_ID		ASC
)
	TABLESPACE &ts_pv_ind
;

ALTER TABLE IMPORT_OBJ_MAP
       ADD  ( PRIMARY KEY (IMPORT_ID, OBJ_TYPE_ID, OBJ_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;


CREATE INDEX XIE1IMPORT_OBJ_MAP ON IMPORT_OBJ_MAP
(
	OBJ_TYPE_ID		ASC,
	ORIGIN_OBJ_ID		ASC
)
	TABLESPACE &ts_pv_ind
;

CREATE TABLE IMPORT_TYPE (
       IMPORT_TYPE_ID       NUMBER(2) NOT NULL,
       IMPORT_TYPE_DESC     VARCHAR2(100) NULL
)
    	 TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKIMPORT_TYPE ON IMPORT_TYPE
(	
	IMPORT_TYPE_ID	ASC
)
	TABLESPACE &ts_pv_ind
;


ALTER TABLE IMPORT_TYPE
       ADD  ( PRIMARY KEY (IMPORT_TYPE_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;

insert into import_type (import_type_id, import_type_desc) values (1, 'Exported ID');
insert into import_type (import_type_id, import_type_desc) values (2, 'Next Available ID');
insert into import_type (import_type_id, import_type_desc) values (3, 'Specific ID');
COMMIT;


CREATE TABLE REPLACE_TYPE (
       REPLACE_TYPE_ID      NUMBER(2) NOT NULL,
       REPLACE_TYPE_DESC    VARCHAR2(100) NULL
)
    	 TABLESPACE &ts_pv_sys
;


CREATE UNIQUE INDEX XPKREPLACE_TYPE ON REPLACE_TYPE
(
	REPLACE_TYPE_ID		ASC
)
	TABLESPACE &ts_pv_ind
;

ALTER TABLE REPLACE_TYPE
       ADD  ( PRIMARY KEY (REPLACE_TYPE_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;

insert into replace_type (replace_type_id, replace_type_desc) values (1, 'Create new version');
insert into replace_type (replace_type_id, replace_type_desc) values (2, 'Overwrite existing component');
insert into replace_type (replace_type_id, replace_type_desc) values (3, 'Exactly replicate');
COMMIT;


/* Extend Object type abbreviation length to 30, to accommodate new strings */

ALTER TABLE OBJ_TYPE MODIFY OBJ_ABBREV VARCHAR2(30);


/* Extend dynamic table name length to 30 re: CQDB104003489 */

ALTER TABLE CAMP_DET MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE SEED_LIST_HDR MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE SCORE_SRC MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE DERIVED_VAL_SRC MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE SUBS_CAMP_CYC MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE DATA_CAT_HDR MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE TREATMENT_TEST MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE SEG_HDR MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE LOOKUP_TAB_HDR MODIFY DYN_TAB_NAME VARCHAR2(30);
ALTER TABLE DATA_REP_SRC MODIFY DYN_TAB_NAME VARCHAR2(30);


/* Add new entity names to Vantage entity list */

insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('EXPORT_HDR', 1, 0);
insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_HDR', 1, 0);
insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_OBJ_MAP', 1, 0);
insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('IMPORT_TYPE', 1, 1);
insert into VANTAGE_ENT (ENT_NAME, TAB_VIEW_FLG, SYSTEM_DATA_FLG) values ('REPLACE_TYPE', 1, 1);
COMMIT;

/* Grant access to new tables */

GRANT SELECT, UPDATE, INSERT, DELETE ON EXPORT_HDR TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_HDR TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_OBJ_MAP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON REPLACE_TYPE TO &md_role;

/* update schema version to internal release R1 */

update pvdm_upgrade set version_id = '6.1.0.BL_R1';
COMMIT;

spool off;