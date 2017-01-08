prompt
prompt 'This script creates Marketing Director System Database.'
prompt
accept ts_pv_sys prompt 'Enter name of tablespace for Marketing Director System Tables > '
prompt
accept ts_pv_ind prompt 'Enter name of tablespace for Marketing Director System Indexes > '
prompt
accept bin_location prompt 'Enter the path name of the Marketing Director Binaries Location > '
prompt
prompt


SPOOL MDCreate.log

CREATE SEQUENCE LOAD_DATA_SEQ 
	START WITH 1 
	INCREMENT BY 1 
	NOMINVALUE 
	NOCYCLE 
	NOCACHE;


CREATE TABLE WIRELESS_PROTOCOL (
       PROTOCOL_ID          NUMBER(2) NOT NULL,
       PROTOCOL_NAME        VARCHAR2(50) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL
)       
	TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWIRELESS_PROTOCOL ON WIRELESS_PROTOCOL
(
       PROTOCOL_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WIRELESS_PROTOCOL
       ADD  ( PRIMARY KEY (PROTOCOL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into wireless_protocol values (1, 'SMPP', 40);
insert into wireless_protocol values (2, 'CIMD', 40);
insert into wireless_protocol values (3, 'EAIF', 50);
insert into wireless_protocol values (4, 'UCP', 40);
insert into wireless_protocol values (5, 'MM7', 50);
COMMIT;


CREATE TABLE RESTRICT_TYPE (
       RESTRICT_TYPE_ID     NUMBER(1) NOT NULL,
       RESTRICT_TYPE_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRESTRICT_TYPE ON RESTRICT_TYPE
(
       RESTRICT_TYPE_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RESTRICT_TYPE
       ADD  ( PRIMARY KEY (RESTRICT_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into restrict_type values (0, 'None');
insert into restrict_type values (1, 'Make treatments mutually exclusive');
insert into restrict_type values (2, 'Ensure an individual is only in a treatment once');
COMMIT;


CREATE TABLE CDV_HDR (
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CDV_NAME             VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NULL,
       CREATED_DATE         DATE NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCDV_HDR ON CDV_HDR
(
       VIEW_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CDV_HDR
       ADD  ( PRIMARY KEY (VIEW_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE OBJ_TYPE (
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_NAME             VARCHAR2(100) NOT NULL,
       OBJ_ABBREV           VARCHAR2(2) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKOBJ_TYPE ON OBJ_TYPE
(
       OBJ_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE OBJ_TYPE
       ADD  ( PRIMARY KEY (OBJ_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into obj_type values (0, 'Whole Database', NULL);
insert into obj_type values (1, 'Segment', 'SE');
insert into obj_type values (2, 'Base Segment', 'BS');
insert into obj_type values (3, 'Response Criteria', 'RC');
insert into obj_type values (4, 'Tree Segment','TS');
insert into obj_type values (5, 'Data Categorisation', 'DC');
insert into obj_type values (6, 'Data View', 'DA');
insert into obj_type values (7, 'Data Report', 'DR');
insert into obj_type values (8, 'Lookup Table', 'LT');
insert into obj_type values (9, 'Score', 'SC');
insert into obj_type values (10, 'Versioned Base Segment', 'VB');
insert into obj_type values (11, 'Delivery Channel', 'DE');
insert into obj_type values (12, 'Extract Template', 'ET');
insert into obj_type values (13, 'Derived Values', 'DV');
insert into obj_type values (14, 'Seed List', 'SL');
insert into obj_type values (15, 'Derived Value Criteria','DS');
insert into obj_type values (16, 'Score Criteria', 'SS');
insert into obj_type values (17, 'Task Group', 'TG');
insert into obj_type values (18, 'Treatment', NULL);
insert into obj_type values (19, 'Response Model', NULL);
insert into obj_type values (20, 'Response Stream', NULL);
insert into obj_type values (21, 'Campaign Communication', NULL);
insert into obj_type values (22, 'Campaign Characteristics',NULL);
insert into obj_type values (23, 'Campaign Elements', NULL);
insert into obj_type values (24, 'Campaign', NULL);
insert into obj_type values (25, 'Scheduled Campaign', NULL);
insert into obj_type values (26, 'Batch', NULL);
insert into obj_type values (27, 'Campaign Segment', 'CS');
insert into obj_type values (28, 'Web Dynamic Criteria', NULL);
insert into obj_type values (29, 'Web Session Criteria', NULL);
insert into obj_type values (30, 'Non-responder Stream', NULL);
insert into obj_type values (31, 'Constructed Field', NULL);
insert into obj_type values (32, 'Strategy', NULL);
insert into obj_type values (33, 'Campaign Group', NULL);
insert into obj_type values (34, 'Response Type', NULL);
insert into obj_type values (35, 'Response Channel', NULL);
insert into obj_type values (36, 'Campaign Manager', NULL);
insert into obj_type values (37, 'Campaign Type', NULL);
insert into obj_type values (38, 'Fixed Costs', NULL);
insert into obj_type values (39, 'Fixed Cost Area', NULL);
insert into obj_type values (40, 'Supplier', NULL);
insert into obj_type values (41, 'Treatment Group', NULL);
insert into obj_type values (42, 'Characteristic', NULL);
insert into obj_type values (43, 'Element Group', NULL);
insert into obj_type values (44, 'Element', NULL);
insert into obj_type values (45, 'Door Drop Carrier', NULL);
insert into obj_type values (46, 'Door Drop Region', NULL);
insert into obj_type values (47, 'TV Station', NULL);
insert into obj_type values (48, 'TV Region', NULL);
insert into obj_type values (49, 'Leaflet Region', NULL);
insert into obj_type values (50, 'Leaflet Distributor', NULL);
insert into obj_type values (51, 'Collection Point', NULL);
insert into obj_type values (52, 'Distribution Point', NULL);
insert into obj_type values (53, 'Poster Size', NULL);
insert into obj_type values (54, 'Poster Type', NULL);
insert into obj_type values (55, 'Poster Contractor', NULL);
insert into obj_type values (56, 'Radio', NULL);
insert into obj_type values (57, 'Radio Region', NULL);
insert into obj_type values (58, 'Publication', NULL);
insert into obj_type values (59, 'Publication Section', NULL);
insert into obj_type values (60, 'Campaign Output', NULL);
insert into obj_type values (61, 'Email Server', NULL);
insert into obj_type values (62, 'Email Mailbox', NULL);
insert into obj_type values (63, 'Label', NULL);
insert into obj_type values (64, 'Email Delivery', NULL);
insert into obj_type values (65, 'Campaign Communication Stored Fields', NULL); 
insert into obj_type values (66, 'External Process', NULL);
insert into obj_type values (67, 'Web Template', NULL);
insert into obj_type values (68, 'Web Tag', NULL);
insert into obj_type values (69, 'Email Rule', NULL);
insert into obj_type values (70, 'Campaign Report', NULL);
insert into obj_type values (71, 'Treatment Element', NULL);
insert into obj_type values (72, 'Web Template Group', NULL);
insert into obj_type values (73, 'Segment Group', NULL);
insert into obj_type values (74, 'Campaign Report Group', NULL);
insert into obj_type values (75, 'External Process Group', null);
insert into obj_type values (76, 'Seed List Group', null);
insert into obj_type values (77, 'Undelivered Email Rule', NULL);
insert into obj_type values (78, 'Wireless Response Rule', NULL);
insert into obj_type values (79, 'Wireless Server', NULL);
insert into obj_type values (80, 'Characteristic Group', NULL);
insert into obj_type values (81, 'Response Rule Group', NULL);
insert into obj_type values (82, 'Optimised Segment', NULL);
insert into obj_type values (83, 'Optimised Treatment Result', 'TO');
insert into obj_type values (84, 'SMS Delivery Engine', NULL);
insert into obj_type values (85, 'User Group', NULL);
insert into obj_type values (86, 'User', NULL);
insert into obj_type values (87, 'CDV', NULL);
insert into obj_type values (88, 'Module', NULL);
insert into obj_type values (89, 'Placement', NULL);
insert into obj_type values (91, 'Base Segment Group', NULL);
insert into obj_type values (92, 'Web Session Group', NULL);
insert into obj_type values (93, 'Web Dynamic Criteria Group', NULL);
insert into obj_type values (94, 'Derived Criteria Group', NULL);
insert into obj_type values (95, 'Score Criteria Group', NULL);
insert into obj_type values (96, 'Response Criteria Group', NULL);
insert into obj_type values (97, 'Wireless Inbox', NULL);
insert into obj_type values (98, 'Custom Attribute', NULL);
insert into obj_type values (99, 'Decision Logic Segment', 'DL');
insert into obj_type values (100, 'Decision Configuration', NULL);
insert into obj_type values (101, 'Tree Segment Group', NULL);
insert into obj_type values (102, 'Lookup Table Group', null);
COMMIT;

CREATE TABLE SEG_GRP (
       SEG_GRP_ID           NUMBER(4) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       SEG_GRP_NAME         VARCHAR2(100) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEG_GRP ON SEG_GRP
(
       SEG_GRP_ID                     ASC,
       SEG_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEG_GRP
       ADD  ( PRIMARY KEY (SEG_GRP_ID, SEG_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEG_HDR (
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       SEG_ID               NUMBER(8) NOT NULL,
       SEG_GRP_ID           NUMBER(4) NULL,
       SEG_NAME             VARCHAR2(100) NOT NULL,
       LAST_RUN_QTY         NUMBER(10) NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       MAX_VERS             NUMBER(4) NOT NULL,
       VER_NUMBER           NUMBER(4) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       LAST_COUNT_DATE      DATE NULL,
       LAST_COUNT_TIME      CHAR(8) NULL,
       LAST_COUNT_DUR       NUMBER(8) NULL,
       LAST_COUNT_BY        VARCHAR2(30) NULL,
       LAST_COUNT_QTY       NUMBER(10) NULL,
       SEG_CRITERIA         CLOB NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL,
       PAR_BASE_SEG_ID      NUMBER(8) NULL,
       OPTIMISE_CLAUSE      VARCHAR2(300) NULL,
       OPTIMISE_FLG         NUMBER(1) NOT NULL,
       RUN_TIME_VAL_FLG	    NUMBER(1) DEFAULT 0 NOT NULL
				CHECK (RUN_TIME_VAL_FLG BETWEEN 0 AND 1)
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEG_HDR ON SEG_HDR
(
       SEG_TYPE_ID                    ASC,
       SEG_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEG_HDR
       ADD  ( PRIMARY KEY (SEG_TYPE_ID, SEG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_MANAGER (
       MANAGER_ID           NUMBER(4) NOT NULL,
       MANAGER_NAME         VARCHAR2(100) NOT NULL,
       CAMP_MANAGER_FLG     NUMBER(1) NOT NULL,
       BUDGET_MANAGER_FLG   NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_MANAGER ON CAMP_MANAGER
(
       MANAGER_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_MANAGER
       ADD  ( PRIMARY KEY (MANAGER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_TEMPL (
       CAMP_TEMPL_ID        NUMBER(2) NOT NULL,
       CAMP_TEMPL_NAME      VARCHAR2(50) NOT NULL,
       CAMP_TEMPL_DESC      VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_TEMPL ON CAMP_TEMPL
(
       CAMP_TEMPL_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_TEMPL
       ADD  ( PRIMARY KEY (CAMP_TEMPL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into camp_templ values (5, 'Web', 'Single Channel Web Campaign');
insert into camp_templ values (10, 'One-Off', 'Single Cycle Campaign supporting Single Channel,  Multi-Channel, Single Stage and Multi-Stage campaign types');
insert into camp_templ values (15, 'One-Off with Web', 'Single Cycle Campaign with Web Treatments supporting Web enabled Multi-Channel, Single Stage and Multi-Stage campaign types');
insert into camp_templ values (20, 'Recurring', 'Multiple Cycle Campaign supporting Recurring, Repeat, Single Channel, Multi-Channel, single Stage, Multi-Stage, Scheduled campaign types');
insert into camp_templ values (25, 'Recurring with Web', 'Multiple Cycle Campaign with Web Treatments supporting WEb enabled Recurring, Repeat, Multi-Channel, Single Channel and Multi-Stage campaign types');
COMMIT;


CREATE TABLE STRATEGY (
       STRATEGY_ID          NUMBER(4) NOT NULL,
       STRATEGY_NAME        VARCHAR2(50) NOT NULL,
       STRATEGY_DESC        VARCHAR2(300) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSTRATEGY ON STRATEGY
(
       STRATEGY_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE STRATEGY
       ADD  ( PRIMARY KEY (STRATEGY_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_GRP (
       CAMP_GRP_ID          NUMBER(4) NOT NULL,
       STRATEGY_ID          NUMBER(4) NOT NULL,
       CAMP_GRP_NAME        VARCHAR2(50) NOT NULL,
       CAMP_GRP_DESC        VARCHAR2(300) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_GRP ON CAMP_GRP
(
       CAMP_GRP_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_GRP
       ADD  ( PRIMARY KEY (CAMP_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_TYPE (
       CAMP_TYPE_ID         NUMBER(4) NOT NULL,
       CAMP_TYPE_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_TYPE ON CAMP_TYPE
(
       CAMP_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_TYPE
       ADD  ( PRIMARY KEY (CAMP_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMPAIGN (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_NAME            VARCHAR2(50) NOT NULL,
       CAMP_DESC            VARCHAR2(300) NULL,
       CAMP_OBJECTIVE       VARCHAR2(300) NULL,
       CAMP_TEMPL_ID        NUMBER(2) NOT NULL,
       CAMP_TYPE_ID         NUMBER(4) NULL,
       CAMP_GRP_ID          NUMBER(4) NOT NULL,
       CAMP_CODE            VARCHAR2(10) NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       EST_END_DATE         DATE NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       UPDATED_DATE         DATE NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       SUBS_CAMP_FLG        NUMBER(1) NOT NULL,
       CURRENT_VERSION_ID   NUMBER(3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMPAIGN ON CAMPAIGN
(
       CAMP_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMPAIGN ON CAMPAIGN
(
       CAMP_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE2CAMPAIGN ON CAMPAIGN
(
       CAMP_ID                        ASC,
       CURRENT_VERSION_ID             ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE3CAMPAIGN ON CAMPAIGN
(
       CAMP_NAME                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMPAIGN
       ADD  ( PRIMARY KEY (CAMP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_VERSION (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       VERSION_NAME         VARCHAR2(50) NULL,
       MANAGER_ID           NUMBER(4) NULL,
       BUDGET_MANAGER_ID    NUMBER(4) NULL,
       MAILING_DELAY_DAYS   NUMBER(3) NULL,
       RESTRICT_TYPE_ID     NUMBER(1) NOT NULL,
       WEB_FILTER_TYPE_ID   NUMBER(3) NULL,
       WEB_FILTER_ID        NUMBER(8) NULL,
       PROC_FLG             NUMBER(1) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_VERSION ON CAMP_VERSION
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_VERSION
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SUBS_CAMPAIGN (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       ORG_TYPE_ID          NUMBER(4) NOT NULL,
       INSTRUCTION          VARCHAR2(300) NULL,
       ALL_ORG_FLG          NUMBER(1) NOT NULL,
       DEFAULT_SUBS_FLG     NUMBER(1) NOT NULL,
       ALLOW_UNSUBS_FLG     NUMBER(1) NOT NULL,
       INPUT_DAYS           NUMBER(2) NOT NULL,
       REVIEW_DAYS          NUMBER(2) NOT NULL,
       AUTO_EXECUTE_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSUBS_CAMPAIGN ON SUBS_CAMPAIGN
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1SUBS_CAMPAIGN ON SUBS_CAMPAIGN
(
       ORG_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SUBS_CAMPAIGN
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SUBS_CAMP_CYC (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC ON SUBS_CAMP_CYC
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       CAMP_CYC                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SUBS_CAMP_CYC
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SUBS_CAMP_CYC_ORG (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       ORG_ID               VARCHAR2(50) NOT NULL,
       SUBS_FLG             NUMBER(1) NOT NULL,
       EDIT_COMPLETED_FLG   NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       CAMP_CYC                       ASC,
       ORG_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
(
       ORG_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE2SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
(
       SUBS_FLG                       ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE3SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
(
       EDIT_COMPLETED_FLG             ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE4SUBS_CAMP_CYC_ORG ON SUBS_CAMP_CYC_ORG
(
       CAMP_ID             ASC,
       CAMP_CYC		   ASC	
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SUBS_CAMP_CYC_ORG
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC, ORG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SUBS_CAMP_ORG_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       ORG_ID               VARCHAR2(50) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       INITIAL_QTY          NUMBER(10) NOT NULL,
       LOCAL_INC_QTY        NUMBER(10) NOT NULL,
       LOCAL_EXC_QTY        NUMBER(10) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSUBS_CAMP_ORG_DET ON SUBS_CAMP_ORG_DET
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       CAMP_CYC                       ASC,
       ORG_ID                         ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SUBS_CAMP_ORG_DET
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_CYC, ORG_ID, 
              DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE STATUS_SETTING (
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       STATUS_CHAR          CHAR(1) NOT NULL,
       STATUS_NAME          VARCHAR2(12) NOT NULL,
       STATUS_COLOUR        VARCHAR2(12) NULL,
       STATUS_DESC          VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSTATUS_SETTING ON STATUS_SETTING
(
       STATUS_SETTING_ID              ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE STATUS_SETTING
       ADD  ( PRIMARY KEY (STATUS_SETTING_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into status_setting values (1, 'F', 'Failed', 'Red', '(i) Indicates an unexpected, uncontrolled exit occurred; (ii) Campaign processing aborted or failed');
insert into status_setting values (2, 'A', 'Aborted', 'Red', 'Process made controlled exit after an error was found');
insert into status_setting values (3, 'B', 'Aborted', 'Red', 'Group has been aborted by the user');
insert into status_setting values (4, 'R', 'Running', 'Green', '(i) Scheduled Group or Process is executing; (ii) Campaign is currently processing');
insert into status_setting values (5, 'N', 'Pending', 'Orange', 'Group ready to start, but there are no SPI streams free');
insert into status_setting values (6, 'H', 'Held', 'Orange', 'Group processing IN-PROGRESS, waiting resumption');
insert into status_setting values (7, 'Q', 'Queued', 'Orange', 'Group or Process is ready to run');
insert into status_setting values (8, 'P', 'Paused', 'White', '(i) Process and master group has been PAUSED by the SPI; (ii) Campaigns next Process has a PAUSED status');
insert into status_setting values (9, 'K', 'Skipped', 'Purple', 'Process will be ignored during current run cycle (only)');
insert into status_setting values (10, 'S', 'Suspended', 'Beige', 'A QUEUED/HELD/SCHEDULED entry is in an editable state');
insert into status_setting values (11, 'D', 'Definition', 'Grey', 'Campaign or Task Group is being (or has been) set-up');
insert into status_setting values (12, 'C', 'Completed', 'Blue', '(i) Process has completed successfully; (ii) Group has completed the required number of cycles; (iii) Campaign has finished');
insert into status_setting values (13, 'L', 'Scheduled', NULL, '(i) Approved Campaign has been submitted to run (Campaign Builder only); (ii) Campaign is in progress, but not currently processing');
insert into status_setting values (14, 'E', 'Decomposing', NULL, 'An Approved Campaign is in the progress of being Scheduled');
insert into status_setting values (15, 'V', 'Approved', NULL, 'A defined Campaign has been given approval (Campaign Builder only)');
insert into status_setting values (16, 'Z', 'Cancelled', NULL, 'This Campaign has been withdrawn from use (Campaign Builder only)');
insert into status_setting values (17, 'X', 'Published', NULL, 'This Subscription Campaign has been published to Local Marketer Organisations - this replaces Scheduled status for all subscription campaigns');
COMMIT;


CREATE TABLE CAMP_CYC_STATUS (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       CYC_START_DATE       DATE NOT NULL,
       CYC_START_TIME       CHAR(8) NOT NULL,
       START_DATE           DATE NOT NULL,
       START_TIME           CHAR(8) NOT NULL,
       END_DATE             DATE NULL,
       END_TIME             CHAR(8) NULL,
       PROC_REMOVED_FLG     NUMBER(1) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_CYC_STATUS ON CAMP_CYC_STATUS
(
       CAMP_ID                        ASC,
       CAMP_CYC                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_CYC_STATUS
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_CYC)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEED_LIST_GRP (
       SEED_LIST_GRP_ID     NUMBER(4) NOT NULL,
       SEED_LIST_GRP_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEED_LIST_GRP ON SEED_LIST_GRP
(
       SEED_LIST_GRP_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEED_LIST_GRP
       ADD  ( PRIMARY KEY (SEED_LIST_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEED_LIST_HDR (
       SEED_LIST_ID         NUMBER(4) NOT NULL,
       SEED_LIST_GRP_ID     NUMBER(4) NOT NULL,
       SEED_LIST_NAME       VARCHAR2(50) NOT NULL,
       SEED_LIST_DESC       VARCHAR2(300) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEED_LIST_HDR ON SEED_LIST_HDR
(
       SEED_LIST_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEED_LIST_HDR
       ADD  ( PRIMARY KEY (SEED_LIST_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE GRP_TYPE (
       GRP_TYPE_ID          NUMBER(1) NOT NULL,
       GRP_TYPE_NAME        VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKGRP_TYPE ON GRP_TYPE
(
       GRP_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE GRP_TYPE
       ADD  ( PRIMARY KEY (GRP_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into grp_type values (0, 'Ungrouped');
insert into grp_type values (1, 'Grouped');
insert into grp_type values (2, 'Combined');
COMMIT;


CREATE TABLE SPLIT_TYPE (
       SPLIT_TYPE_ID        NUMBER(1) NOT NULL,
       SPLIT_TYPE_NAME      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPLIT_TYPE ON SPLIT_TYPE
(
       SPLIT_TYPE_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPLIT_TYPE
       ADD  ( PRIMARY KEY (SPLIT_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into split_type values (0, 'None');
insert into split_type values (1, 'Percentage');
insert into split_type values (2, 'By Stored Field');
COMMIT;


CREATE TABLE CAMP_OUT_GRP (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       SPLIT_TYPE_ID        NUMBER(1) NOT NULL,
       SPLIT_FLD_ALIAS      VARCHAR2(128) NULL,
       SPLIT_FLD_COL        VARCHAR2(128) NULL,
       GRP_TYPE_ID          NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_OUT_GRP ON CAMP_OUT_GRP
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_OUT_GRP
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_OUT_GRP_SPLIT (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       SPLIT_PCTG           NUMBER(5,3) NOT NULL,
       SPLIT_FLD_VAL        VARCHAR2(255) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_OUT_GRP_SPLIT ON CAMP_OUT_GRP_SPLIT
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       SPLIT_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_OUT_GRP_SPLIT
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, SPLIT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EXT_TEMPL_HDR (
       EXT_TEMPL_ID         NUMBER(8) NOT NULL,
       EXT_TEMPL_NAME       VARCHAR2(100) NOT NULL,
       OUTREC_SIZE          NUMBER(6) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_TEMPL_HDR ON EXT_TEMPL_HDR
(
       EXT_TEMPL_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_TEMPL_HDR
       ADD  ( PRIMARY KEY (EXT_TEMPL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CHAN_OUT_TYPE (
       CHAN_OUT_TYPE_ID     NUMBER(2) NOT NULL,
       CHAN_OUT_TYPE_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCHAN_OUT_TYPE ON CHAN_OUT_TYPE
(
       CHAN_OUT_TYPE_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CHAN_OUT_TYPE
       ADD  ( PRIMARY KEY (CHAN_OUT_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into chan_out_type values (1, 'Delimited');
insert into chan_out_type values (2, 'Continuous');
insert into chan_out_type values (3, 'Data Dump');
insert into chan_out_type values (4, 'MS-Word');
insert into chan_out_type values (5, 'Custom');
COMMIT;

CREATE TABLE DEFINE_TYPE (
       DEFINE_TYPE_ID	    NUMBER(2) NOT NULL,
       DEFINE_TYPE_NAME     VARCHAR2(100) NOT NULL 
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDEFINE_TYPE ON DEFINE_TYPE
(
       DEFINE_TYPE_ID             ASC
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE DEFINE_TYPE 
       ADD ( PRIMARY KEY ( DEFINE_TYPE_ID )
       USING INDEX
             TABLESPACE &ts_pv_ind );

insert into define_type values (1, 'Define List');
insert into define_type values (2, 'Lookup List');
insert into define_type values (3, 'Free Text');
COMMIT;


CREATE TABLE DELIVERY_METHOD (
       DELIVERY_METHOD_ID   NUMBER(1) NOT NULL,
       DELIVERY_METHOD      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDELIVERY_METHOD ON DELIVERY_METHOD
(
       DELIVERY_METHOD_ID             ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DELIVERY_METHOD
       ADD  ( PRIMARY KEY (DELIVERY_METHOD_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into delivery_method values (1, 'File');
insert into delivery_method values (2, 'Database');
insert into delivery_method values (3, 'Prime@Vantage Email Delivery Engine');
insert into delivery_method values (4, 'Prime@Vantage SMS Delivery Engine');
COMMIT;


CREATE TABLE CHAN_TYPE (
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       CHAN_TYPE_NAME       VARCHAR2(100) NOT NULL,
       OUTB_CHAN_FLG        NUMBER(1) NOT NULL,
       INB_CHAN_FLG         NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCHAN_TYPE ON CHAN_TYPE
(
       CHAN_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CHAN_TYPE
       ADD  ( PRIMARY KEY (CHAN_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into chan_type values (10, 'Direct Mail', 1, 1);
insert into chan_type values (20, 'Call Centre', 1,1);
insert into chan_type values (30, 'Email', 1,1);
insert into chan_type values (40, 'SMS', 1,1);
insert into chan_type values (50, 'MMS', 1,1);
insert into chan_type values (100, 'Web',0,1);
insert into chan_type values (110, 'Press Off Page',0,0);
insert into chan_type values (120, 'Press Insert',0,0);
insert into chan_type values (130, 'TV',0,0);
insert into chan_type values (140, 'Radio',0,0);
insert into chan_type values (150, 'Poster',0,0);
insert into chan_type values (160, 'Door Drop',0,0);
insert into chan_type values (170, 'Leaflet',0,0);
insert into chan_type values (200, 'Analysis Only',1,0);
COMMIT;


CREATE TABLE DELIVERY_CHAN (
       CHAN_ID              NUMBER(8) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       DELIVERY_METHOD_ID   NUMBER(1) NOT NULL,
       CHAN_OUT_TYPE_ID     NUMBER(2) NOT NULL,
       DFT_EXT_TEMPL_ID     NUMBER(8) NOT NULL,
       CHAN_NAME            VARCHAR2(50) NOT NULL,
       CHAN_DESC            VARCHAR2(300) NULL,
       RECORD_DELIMITER     CHAR(5) NULL,
       FLD_DELIMITER        CHAR(5) NULL,
       ENCLOSE_DELIMITER    CHAR(5) NULL,
       APPEND_FLG           NUMBER(1) NOT NULL,
       DELIVERY_FUNC_ID     NUMBER(6) NOT NULL,
       INC_CAMP_KEYS_FLG    NUMBER(1) NOT NULL,
       ENCRYPT_FLG          NUMBER(1) NOT NULL,
       CUSTOM_LENGTH_FLG    NUMBER(1) NOT NULL,
       FORWARD_FILE_TO      VARCHAR2(100) NULL,
       FORWARD_SERVER_ID    NUMBER(4) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       OUT_NAME_SUFFIX      CHAR(3)
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDELIVERY_CHAN ON DELIVERY_CHAN
(
       CHAN_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DELIVERY_CHAN
       ADD  ( PRIMARY KEY (CHAN_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_OUT_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       CHAN_ID              NUMBER(8) NOT NULL,
       ALT_EXT_TEMPL_FLG    NUMBER(1) NOT NULL,
       EXT_TEMPL_ID         NUMBER(8) NULL,
       USE_TEMPL_SEQ_FLG    NUMBER(1) NOT NULL,
       NUMBER_OF_SAMPLES    NUMBER(4) NOT NULL,
       FROM_ALIAS           VARCHAR2(100) NULL,
       REPLY_ALIAS          VARCHAR2(100) NULL,
       OUT_NAME_SUFFIX      CHAR(3) NULL,
       FROM_SERVER_ID       NUMBER(4) NULL,
       FROM_MAILBOX_ID      NUMBER(4) NULL,
       REPLY_SERVER_ID      NUMBER(4) NULL,
       REPLY_MAILBOX_ID     NUMBER(4) NULL,
       SEED_LIST_ID         NUMBER(4) NULL,
       DELIVERY_FLG         NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_OUT_DET ON CAMP_OUT_DET
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_OUT_DET
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_OUT_RESULT (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       OUT_NAME             VARCHAR2(255) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NOT NULL,
       OUT_PATH             VARCHAR2(255) NULL,
       OUT_DATE             DATE NULL,
       OUT_TIME             CHAR(8) NULL,
       OUT_QTY              NUMBER(10) NULL,
       APPEND_FLG           NUMBER(1) NOT NULL,
       SENT_STARTED_FLG     NUMBER(1) NULL,
       SENT_QTY             NUMBER(10) NULL,
       CHILD_PROC_COUNT     NUMBER(4) NULL,
       CAMP_DET_ID          NUMBER(4)
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_OUT_RESULT ON CAMP_OUT_RESULT
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC,
       CAMP_CYC                       ASC,
       OUT_NAME                       ASC,
       RUN_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_OUT_RESULT
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ, CAMP_CYC, OUT_NAME, RUN_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_RESULT_PROC (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       OUT_NAME             VARCHAR2(255) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NOT NULL,
       CHILD_PROC_ID        NUMBER(4) NOT NULL,
       FROM_SEL_ORDER       NUMBER NOT NULL,
       TO_SEL_ORDER         NUMBER NOT NULL,
       LAST_SEL_ORDER       NUMBER NOT NULL,
       CAMP_DET_ID          NUMBER(4)
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_RESULT_PROC ON CAMP_RESULT_PROC
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC,
       CAMP_CYC                       ASC,
       OUT_NAME                       ASC,
       RUN_NUMBER                     ASC,
       CHILD_PROC_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_RESULT_PROC
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ, CAMP_CYC, OUT_NAME, RUN_NUMBER, 
              CHILD_PROC_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TEST_TYPE (
       TEST_TYPE_ID         NUMBER(1) NOT NULL,
       TEST_TYPE_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTEST_TYPE ON TEST_TYPE
(
       TEST_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TEST_TYPE
       ADD  ( PRIMARY KEY (TEST_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into test_type values (1, 'Samples');
insert into test_type values (2, 'Segment');
insert into test_type values (3, 'Seed List');
COMMIT;


CREATE TABLE EMAIL_TYPE (
       EMAIL_TYPE_ID        NUMBER(1) NOT NULL,
       EMAIL_TYPE_NAME      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEMAIL_TYPE ON EMAIL_TYPE
(
       EMAIL_TYPE_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EMAIL_TYPE
       ADD  ( PRIMARY KEY (EMAIL_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into email_type values (1, 'Text');
insert into email_type values (2, 'HTML');
insert into email_type values (3, 'Choose Best');
COMMIT;


CREATE TABLE TREATMENT_GRP (
       TREATMENT_GRP_ID     NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       TREATMENT_GRP_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREATMENT_GRP ON TREATMENT_GRP
(
       TREATMENT_GRP_ID               ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1TREATMENT_GRP ON TREATMENT_GRP
(
       CHAN_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREATMENT_GRP
       ADD  ( PRIMARY KEY (TREATMENT_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TREATMENT (
       TREATMENT_ID         NUMBER(8) NOT NULL,
       TREATMENT_GRP_ID     NUMBER(4) NOT NULL,
       TREATMENT_NAME       VARCHAR2(50) NOT NULL,
       TREATMENT_DESC       VARCHAR2(300) NULL,
       EMAIL_TYPE_ID        NUMBER(1) NULL,
       EMAIL_SUBJECT        VARCHAR2(100) NULL,
       TOTAL_PLACEHOLDERS   NUMBER(3) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       DFT_VALID_DATE       DATE NULL,
       DFT_VALID_TIME	    CHAR(8) NULL,
       DFT_VALID_DAYS       NUMBER(3) NULL,
       DFT_MESSAGE_PRIO     VARCHAR2(10) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREATMENT ON TREATMENT
(
       TREATMENT_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1TREATMENT ON TREATMENT
(
       TREATMENT_GRP_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREATMENT
       ADD  ( PRIMARY KEY (TREATMENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TREATMENT_TEST (
       TREATMENT_ID         NUMBER(8) NOT NULL,
       TEST_TYPE_ID         NUMBER(1) NOT NULL,
       FROM_SERVER_ID       NUMBER(4) NULL,
       FROM_MAILBOX_ID      NUMBER(4) NULL,
       REPLY_SERVER_ID      NUMBER(4) NULL,
       REPLY_MAILBOX_ID     NUMBER(4) NULL,
       FROM_ALIAS           VARCHAR2(100) NULL,
       REPLY_ALIAS          VARCHAR2(100) NULL,
       CHAN_ID              NUMBER(8) NULL,
       SEG_TYPE_ID          NUMBER(2) NULL,
       SEG_ID               NUMBER(8) NULL,
       SEG_SUB_ID           NUMBER(6) NULL,
       SEED_LIST_ID         NUMBER(4) NULL,
       SEG_COUNT_FLG        NUMBER(1) NOT NULL,
       SEG_COUNT            NUMBER(4) NULL,
       SAMPLE_COUNT         NUMBER(4) NULL,
       SEND_TO              VARCHAR2(200) NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREATMENT_TEST ON TREATMENT_TEST
(
       TREATMENT_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREATMENT_TEST
       ADD  ( PRIMARY KEY (TREATMENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EMAIL_PROTOCOL (
       PROTOCOL_ID          NUMBER(2) NOT NULL,
       PROTOCOL_NAME        VARCHAR2(20) NOT NULL,
       OUTB_PROTOCOL_FLG    NUMBER(1) NOT NULL,
       INB_PROTOCOL_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEMAIL_PROTOCOL ON EMAIL_PROTOCOL
(
       PROTOCOL_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EMAIL_PROTOCOL
       ADD  ( PRIMARY KEY (PROTOCOL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into email_protocol values (1, 'SMTP', 1, 0);
insert into email_protocol values (2, 'POP3', 0, 1);
COMMIT;


CREATE TABLE EMAIL_SERVER (
       SERVER_ID            NUMBER(4) NOT NULL,
       SERVER_NAME          VARCHAR2(50) NOT NULL,
       SERVER_DESC          VARCHAR2(300) NULL,
       HOSTNAME             VARCHAR2(255) NULL,
       IP_ADDRESS           VARCHAR2(15) NULL,
       DEFAULT_SERVER_FLG   NUMBER(1) NOT NULL,
       OUTB_SERVER_FLG      NUMBER(1) NOT NULL,
       OUTB_PROTOCOL_ID     NUMBER(2) NULL,
       INB_SERVER_FLG       NUMBER(1) NOT NULL,
       INB_PROTOCOL_ID      NUMBER(2) NULL,
       OUTB_PORT            NUMBER(8) NULL,
       INB_PORT             NUMBER(8) NULL,
       OUTB_TIMEOUT         NUMBER(8) NULL,
       INB_TIMEOUT          NUMBER(8) NULL,
       OUTB_RESEND          NUMBER(2) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       DOMAIN_NAME          VARCHAR2(255) NULL,
       OUTB_CONNECT_RETRY   NUMBER(2) NOT NULL,
       OUTB_CONNECT_WAIT    NUMBER(4) NOT NULL,
       TEST_SEND_FLG        NUMBER(1) NOT NULL,
       TEST_SEND_TO         VARCHAR2(100) NULL,
       MAX_CONNECTIONS      NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEMAIL_SERVER ON EMAIL_SERVER
(
       SERVER_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EMAIL_SERVER
       ADD  ( PRIMARY KEY (SERVER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE NPI_TYPE (
       NPI                  NUMBER(1) NOT NULL,
       NPI_NAME             VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKNPI_TYPE ON NPI_TYPE
(
       NPI                            ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE NPI_TYPE
       ADD  ( PRIMARY KEY (NPI)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into NPI_TYPE values (0, 'Unknown');
insert into NPI_TYPE values (1, 'ISDN / telephone numbering plan (CCITT Rec.E.164/E.163)');
insert into NPI_TYPE values (3, 'Data numbering plan (CCITT Rec.x.121)');
insert into NPI_TYPE values (4, 'Telex numbering plan');

insert into NPI_TYPE values (8, 'National numbering plan');
insert into NPI_TYPE values (9, 'Private numbering plan');
insert into NPI_TYPE values (5, 'Centre Specific Plan (5)');
insert into NPI_TYPE values (6, 'Centre Specific Plan (6)');
COMMIT;


CREATE TABLE TON_TYPE (
       TON                  NUMBER(1) NOT NULL,
       TON_NAME             VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTON_TYPE ON TON_TYPE
(
       TON                            ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TON_TYPE
       ADD  ( PRIMARY KEY (TON)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into ton_type values (0, 'Unknown');
insert into ton_type values (1, 'International');
insert into ton_type values (2, 'National');
insert into ton_type values (3, 'Network specific');
insert into ton_type values (4, 'Short');
insert into ton_type values (5,'Alphanumeric');
insert into ton_type values (6,'Abbreviated number');
COMMIT;

CREATE TABLE WIRELESS_VENDOR (
       VENDOR_ID            NUMBER(3) NOT NULL,
       VENDOR_NAME             VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWIRELESS_VENDOR ON WIRELESS_VENDOR
(
       VENDOR_ID            ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WIRELESS_VENDOR
       ADD  ( PRIMARY KEY (VENDOR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into wireless_vendor values (1, 'Nokia');
insert into wireless_vendor values (2, 'Ericsson');
COMMIT;

CREATE TABLE PROTOCOL_VERSION (
       PROTOCOL_VER_ID            NUMBER(3) NOT NULL,
       PROTOCOL_VER_NAME          VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROTOCOL_VERSION ON PROTOCOL_VERSION
(
       PROTOCOL_VER_ID        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROTOCOL_VERSION
       ADD  ( PRIMARY KEY (PROTOCOL_VER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into protocol_version values (1, 'V530');
insert into protocol_version values (2, 'V630');
COMMIT;


CREATE TABLE WIRELESS_SERVER (
       SERVER_ID            NUMBER(4) NOT NULL,
       SERVER_NAME          VARCHAR2(50) NOT NULL,
       SERVER_DESC          VARCHAR2(300) NULL,
       HOSTNAME             VARCHAR2(255) NULL,
       IP_ADDRESS           VARCHAR2(15) NULL,
       PROTOCOL_ID          NUMBER(2) NOT NULL,
       DEFAULT_SERVER_FLG   NUMBER(1) NOT NULL,
       OUTB_SERVER_FLG      NUMBER(1) NOT NULL,
       INB_SERVER_FLG       NUMBER(1) NOT NULL,
       PORT                 NUMBER(8) NULL,
       TIMEOUT              NUMBER(8) NULL,
       CONNECT_RETRY        NUMBER(2) NULL,
       CONNECT_WAIT         NUMBER(4) NULL,
       READ_FLG             NUMBER(1) NOT NULL,
       REPLY_FLG            NUMBER(1) NOT NULL,
       TEST_SEND_FLG        NUMBER(1) NOT NULL,
       TEST_SEND_TO         VARCHAR2(50) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       TON                  NUMBER(1) NULL,
       NPI                  NUMBER(1) NULL,
       SYSTEM_ID            VARCHAR2(15) NULL,
       SYSTEM_TYPE          VARCHAR2(12) NULL,
       PASSWORD             VARCHAR2(50) NULL,
       MAX_CONNECTIONS      NUMBER(2) NOT NULL,
       TEST_SEND_FROM       VARCHAR2(50) NULL,
       VENDOR_ID	    NUMBER(3) NULL,
       PROTOCOL_VER_ID      NUMBER(3) NULL,
       VASPID               VARCHAR2(50) NULL,
       VASID                VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWIRELESS_SERVER ON WIRELESS_SERVER
(
       SERVER_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WIRELESS_SERVER
       ADD  ( PRIMARY KEY (SERVER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DELIVERY_SERVER (
       SERVER_ID            NUMBER(4) NOT NULL,
       CHAN_ID              NUMBER(8) NOT NULL,
       SERVER_PCTG          NUMBER(3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDELIVERY_SERVER ON DELIVERY_SERVER
(
       SERVER_ID                      ASC,
       CHAN_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DELIVERY_SERVER
       ADD  ( PRIMARY KEY (SERVER_ID, CHAN_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ERES_RULE_TYPE (
       RULE_TYPE_ID         NUMBER(1) NOT NULL,
       RULE_TYPE_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKERES_RULE_TYPE ON ERES_RULE_TYPE
(
       RULE_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ERES_RULE_TYPE
       ADD  ( PRIMARY KEY (RULE_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into eres_rule_type values (1, 'Email Response Rule');
insert into eres_rule_type values (2, 'Email Non Delivery Rule');
insert into eres_rule_type values (3, 'Inbound Wireless Message Rule');
COMMIT;


CREATE TABLE ERES_RULE_GRP (
       RES_RULE_GRP_ID      NUMBER(4) NOT NULL,
       RULE_TYPE_ID         NUMBER(1) NOT NULL,
       RES_RULE_GRP_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKERES_RULE_GRP ON ERES_RULE_GRP
(
       RES_RULE_GRP_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ERES_RULE_GRP
       ADD  ( PRIMARY KEY (RES_RULE_GRP_ID) 
       USING INDEX
	      TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ERES_RULE_HDR (
       RULE_ID              NUMBER(4) NOT NULL,
       RES_RULE_GRP_ID      NUMBER(4) NOT NULL,
       RULE_TYPE_ID         NUMBER(1) NOT NULL,
       RULE_NAME            VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKERES_RULE_HDR ON ERES_RULE_HDR
(
       RULE_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ERES_RULE_HDR
       ADD  ( PRIMARY KEY (RULE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WIRELESS_RES_RULE (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID	    NUMBER(3) NOT NULL,
       RULE_SEQ             NUMBER(2) NOT NULL,
       GLOBAL_RULE_FLG      NUMBER(1) NOT NULL,
       ACTIVE_FLG           NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWIRELESS_RES_RULE ON WIRELESS_RES_RULE
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WIRELESS_RES_RULE
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID )
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SAMPLE_TYPE (
       SAMPLE_TYPE_ID       NUMBER(1) NOT NULL,
       SAMPLE_TYPE_NAME     VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSAMPLE_TYPE ON SAMPLE_TYPE
(
       SAMPLE_TYPE_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SAMPLE_TYPE
       ADD  ( PRIMARY KEY (SAMPLE_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into sample_type values (1, 'Random');
insert into sample_type values (2, 'Lowest');
insert into sample_type values (3, 'Highest');
COMMIT;


CREATE TABLE TREE_GRP (
       TREE_GRP_ID           NUMBER(4) NOT NULL,
       TREE_GRP_NAME         VARCHAR2(100) NOT NULL,
       TREE_GRP_DESC         VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREE_GRP ON TREE_GRP
(
       TREE_GRP_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREE_GRP
       ADD  ( PRIMARY KEY (TREE_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TREE_HDR (
       TREE_ID              NUMBER(8) NOT NULL,
       TREE_NAME            VARCHAR2(100) NOT NULL,
       TREE_DESC            VARCHAR2(300) NULL,
       TEST_FLG             NUMBER(1) NOT NULL,
       TEST_PCTG            NUMBER(5,3) NULL,
       DEDUPE_BASE_BY       VARCHAR2(257) NOT NULL,
       DEDUPE_TREE_BY       VARCHAR2(257) NULL,
       DEDUPE_TREE_FLG      NUMBER(1) NOT NULL,
       BASE_IN_ALL_FLG      NUMBER(1) NOT NULL,
       BASE_ACCESS_FLG      NUMBER(1) NOT NULL,
       BASE_STATIC_FLG      NUMBER(1) NULL,
       BASE_NO_COUNTS_FLG   NUMBER(1) NOT NULL,
       BASE_OPTIMISE_FLG    NUMBER(1) NOT NULL,
       BASE_OPTIMISE_CL     VARCHAR2(300),
       TREE_ACCESS_FLG      NUMBER(1) NOT NULL,
       TREE_STATIC_FLG      NUMBER(1) NULL,
       SET_TREE_EXC_FLG     NUMBER(1) NOT NULL,
       TREE_NOT_EXC_FLG     NUMBER(1) NULL,
       EXC_TREE_BY          VARCHAR2(257) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       NO_GROSS_QTY_FLG     NUMBER(1) NOT NULL,
       NO_REMAINDER_FLG     NUMBER(1) NOT NULL,
       IN_ANY_FLG           NUMBER(1) NOT NULL,
       NOT_IN_ANY_FLG       NUMBER(1) NOT NULL,
       EXE_FROM             NUMBER(1) NOT NULL,
       EXE_STARTED_FLG      NUMBER(1) NOT NULL,
       SUBSTITUTION_FLG     NUMBER(1) NOT NULL,
       TREE_OPTIMISE_FLG    NUMBER(1) NOT NULL,
       TREE_OPTIMISE_CL     VARCHAR2(300) NULL,
       TREE_GRP_ID          NUMBER(4) NULL,
       EXE_FROM_TREE_SEQ    NUMBER(6) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREE_HDR ON TREE_HDR
(
       TREE_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREE_HDR
       ADD  ( PRIMARY KEY (TREE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE NODE_TYPE (
       NODE_TYPE_ID         NUMBER(1) NOT NULL,
       NODE_TYPE_NAME       VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKNODE_TYPE ON NODE_TYPE
(
       NODE_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE NODE_TYPE
       ADD  ( PRIMARY KEY (NODE_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into node_type values (1, 'Root');
insert into node_type values (2, 'Criteria');
insert into node_type values (3, 'Split');
insert into node_type values (4, 'Sample');
insert into node_type values (5, 'Remainder');
COMMIT;


CREATE TABLE TREE_DET (
       TREE_ID              NUMBER(8) NOT NULL,
       TREE_SEQ             NUMBER(6) NOT NULL,
       ORIGIN_TYPE_ID       NUMBER(3) NULL,
       ORIGIN_ID            NUMBER(8) NULL,
       ORIGIN_SUB_ID        NUMBER(6) NULL,
       SEG_TYPE_ID          NUMBER(3) NULL,
       SEG_ID               NUMBER(8) NULL,
       STATIC_FLG           NUMBER(1) NOT NULL,
       EXC_FLG              NUMBER(1) NOT NULL,
       EXC_BY               VARCHAR2(257) NULL,
       NODE_SEQ             NUMBER(6) NOT NULL,
       PAR_SEQ              NUMBER(6) NOT NULL,
       NODE_TYPE_ID         NUMBER(1) NOT NULL,
       NODE_NAME            VARCHAR2(100) NOT NULL,
       NODE_DESC            VARCHAR2(300) NULL,
       SAMPLE_TYPE_ID       NUMBER(1) NULL,
       SAMPLE_QTY_FLG       NUMBER(1) NULL,
       SAMPLE_MAX_QTY       NUMBER(8) NULL,
       SAMPLE_PCTG          NUMBER(5,3) NULL,
       SAMPLE_ORDER_BY      VARCHAR2(257) NULL,
       CHILD_SPLIT_FLG      NUMBER(1) NOT NULL,
       CHILD_FLD_FLG        NUMBER(1) NULL,
       CHILD_SPLIT_BY       VARCHAR2(257) NULL,
       SPLIT_PCTG           NUMBER(5,3) NULL,
       SPLIT_FLD_VAL        VARCHAR2(255) NULL,
       GROSS_QTY            NUMBER(10) NULL,
       NET_QTY              NUMBER(10) NULL,
       UPDATED_BY           VARCHAR2(30) NOT NULL,
       UPDATED_DATE         DATE NOT NULL,
       SUBSTITUTION_FLG     NUMBER(1) NOT NULL,
       OPTIMISE_FLG         NUMBER(1) NOT NULL,
       OPTIMISE_CLAUSE      VARCHAR2(300)
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREE_DET ON TREE_DET
(
       TREE_ID                        ASC,
       TREE_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREE_DET
       ADD  ( PRIMARY KEY (TREE_ID, TREE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_MODEL_HDR (
       RES_MODEL_ID         NUMBER(4) NOT NULL,
       RES_MODEL_NAME       VARCHAR2(50) NOT NULL,
       RES_MODEL_DESC       VARCHAR2(300) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       MULTI_STREAM_FLG     NUMBER(1) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_MODEL_HDR ON RES_MODEL_HDR
(
       RES_MODEL_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_MODEL_HDR
       ADD  ( PRIMARY KEY (RES_MODEL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_MODEL_STREAM (
       RES_MODEL_ID         NUMBER(4) NOT NULL,
       RES_STREAM_ID        NUMBER(2) NOT NULL,
       RES_STREAM_SEQ       NUMBER(2) NOT NULL,
       RES_STREAM_NAME      VARCHAR2(50) NOT NULL,
       RES_STREAM_DESC      VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_MODEL_STREAM ON RES_MODEL_STREAM
(
       RES_MODEL_ID                   ASC,
       RES_STREAM_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_MODEL_STREAM
       ADD  ( PRIMARY KEY (RES_MODEL_ID, RES_STREAM_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_TYPE (
       SPI_TYPE_ID          NUMBER(1) NOT NULL,
       SPI_TYPE_CHAR        CHAR(1) NOT NULL,
       SPI_TYPE_DESC        VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_TYPE ON SPI_TYPE
(
       SPI_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_TYPE
       ADD  ( PRIMARY KEY (SPI_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into spi_type values (1, 'B', 'Client Batch');
insert into spi_type values (2, 'E', 'Campaign (Recurring or One-Off)' );
insert into spi_type values (3, 'M', 'Main SPI');
insert into spi_type values (4, 'T', 'Task Group');
COMMIT;


CREATE TABLE DUR_UNIT (
       DUR_UNIT_ID          NUMBER(2) NOT NULL,
       DUR_NAME             VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDUR_UNIT ON DUR_UNIT
(
       DUR_UNIT_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DUR_UNIT
       ADD  ( PRIMARY KEY (DUR_UNIT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into dur_unit values (1, 'Second');
insert into dur_unit values (2, 'Minute');
insert into dur_unit values (3, 'Hour');
insert into dur_unit values (4, 'Day');
insert into dur_unit values (5, 'Week');
insert into dur_unit values (6, 'Month');
insert into dur_unit values (7, 'Year');
COMMIT;


CREATE TABLE INTERVAL_CYC_DET (
       INTERVAL_CYC_ID      NUMBER(8) NOT NULL,
       INTERVAL_UNIT_ID     NUMBER(2) NOT NULL,
       INTERVAL_NUMBER      NUMBER(3) NOT NULL,
       MONTH_NUMBER         NUMBER(2) NOT NULL,
       WEEK_NUMBER          NUMBER(2) NOT NULL,
       DAY_NUMBER           NUMBER(3) NOT NULL,
       EXC_WEEKEND_FLG      NUMBER(1) NOT NULL,
       NUMBER_OF_RUNS       NUMBER(9) NULL,
       RUN_UNTIL_DATE       DATE NULL,
       BETWEEN_TIMES_FLG    NUMBER(1) NOT NULL,
       BETWEEN_START_TIME   CHAR(8) NULL,
       BETWEEN_END_TIME     CHAR(8) NULL,
       INDEFINITE_RUN_FLG   NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKINTERVAL_CYC_DET ON INTERVAL_CYC_DET
(
       INTERVAL_CYC_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE INTERVAL_CYC_DET
       ADD  ( PRIMARY KEY (INTERVAL_CYC_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_MASTER (
       SPI_ID               NUMBER(8) NOT NULL,
       SPI_TYPE_ID          NUMBER(1) NOT NULL,
       SPI_GRP_NAME         VARCHAR2(50) NOT NULL,
       SPI_CAMP_ID          NUMBER(8) NOT NULL,
       START_DATE           DATE NOT NULL,
       START_TIME           CHAR(8) NOT NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       NEXT_RUN_DATE        DATE NOT NULL,
       NEXT_RUN_TIME        CHAR(8) NOT NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       NUMBER_OF_RUNS       NUMBER(9) NOT NULL,
       COMPLETED_RUNS       NUMBER(9) NOT NULL,
       INTERVAL_CYC_ID      NUMBER(8) NULL,
       SPI_ACTIVE_GRP_FLG   NUMBER(1) NOT NULL,
       USER_ABORT_REQ_FLG   NUMBER(1) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       USER_ID              VARCHAR2(30) NOT NULL,
       FREQ_OVERRIDE_FLG    NUMBER(1) NOT NULL,
       CONCUR_EXE_FLG       NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_MASTER ON SPI_MASTER
(
       SPI_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_MASTER
       ADD  ( PRIMARY KEY (SPI_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NULL,
       OBJ_SUB_ID           NUMBER(6) NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NULL,
       CHILD_SEQ            NUMBER(4) NOT NULL,
       PAR_DET_ID           NUMBER(4) NOT NULL,
       OUT_DAY              NUMBER(3) NULL,
       OUT_TIME             CHAR(8) NULL,
       OPTIMISED_FLG        NUMBER(1) NOT NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_DET ON CAMP_DET
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMP_DET ON CAMP_DET
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       PAR_DET_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE2CAMP_DET ON CAMP_DET
(
       OBJ_TYPE_ID                    ASC,
       OBJ_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE3CAMP_DET ON CAMP_DET
(
       OBJ_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_DET
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_RES_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       SEG_ID               NUMBER(8) NOT NULL,
       PROJ_PCTG_OF_RES     NUMBER(6,3) NULL,
       PROJ_REV_PER_RES     NUMBER(12,3) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_RES_DET ON CAMP_RES_DET
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       SEG_TYPE_ID                    ASC,
       SEG_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_RES_DET
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, SEG_TYPE_ID, 
              SEG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_CHANNEL (
       RES_CHANNEL_ID       NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NULL,
       RES_CHANNEL_NAME     VARCHAR2(100) NOT NULL,
       INB_VAR_COST         NUMBER(12,3) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_CHANNEL ON RES_CHANNEL
(
       RES_CHANNEL_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_CHANNEL
       ADD  ( PRIMARY KEY (RES_CHANNEL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_TYPE (
       RES_TYPE_ID          NUMBER(4) NOT NULL,
       RES_TYPE_NAME        VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_TYPE ON RES_TYPE
(
       RES_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_TYPE
       ADD  ( PRIMARY KEY (RES_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_STREAM_DET (
       RES_MODEL_ID         NUMBER(4) NOT NULL,
       RES_STREAM_ID        NUMBER(2) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       SEG_ID               NUMBER(8) NOT NULL,
       RES_CHANNEL_ID       NUMBER(4) NOT NULL,
       RES_TYPE_ID          NUMBER(4) NOT NULL,
       REVENUE_VAL_FLG      NUMBER(1) NOT NULL,
       RES_REVENUE          NUMBER(12,3) NULL,
       REVENUE_FLD_SEQ      NUMBER(4) NULL,
       NON_OUTB_FLG         NUMBER(1) NULL,
       NON_OUTB_FLD_SEQ     NUMBER(4) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_STREAM_DET ON RES_STREAM_DET
(
       RES_MODEL_ID                   ASC,
       RES_STREAM_ID                  ASC,
       SEG_TYPE_ID                    ASC,
       SEG_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_STREAM_DET
       ADD  ( PRIMARY KEY (RES_MODEL_ID, RES_STREAM_ID, SEG_TYPE_ID, 
              SEG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_STATUS_HIST (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       CAMP_HIST_SEQ        NUMBER(6) NOT NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       SPI_ID               NUMBER(8) NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_TIME         CHAR(8) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_STATUS_HIST ON CAMP_STATUS_HIST
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       CAMP_HIST_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMP_STATUS_HIST ON CAMP_STATUS_HIST
(
       STATUS_SETTING_ID              ASC,
       VERSION_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_STATUS_HIST
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, CAMP_HIST_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SUPPLIER (
       SUPPLIER_ID          NUMBER(4) NOT NULL,
       SUPPLIER_NAME        VARCHAR2(100) NOT NULL,
       SUPPLIER_REF         VARCHAR2(20) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSUPPLIER ON SUPPLIER
(
       SUPPLIER_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SUPPLIER
       ADD  ( PRIMARY KEY (SUPPLIER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE FIXED_COST_AREA (
       FIXED_COST_AREA_ID   NUMBER(4) NOT NULL,
       COST_AREA_NAME       VARCHAR2(100) NOT NULL,
       COST_AREA_REF        VARCHAR2(20) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKFIXED_COST_AREA ON FIXED_COST_AREA
(
       FIXED_COST_AREA_ID             ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE FIXED_COST_AREA
       ADD  ( PRIMARY KEY (FIXED_COST_AREA_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE FIXED_COST (
       FIXED_COST_ID        NUMBER(4) NOT NULL,
       FIXED_COST_NAME      VARCHAR2(100) NOT NULL,
       FIXED_COST_REF       VARCHAR2(20) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKFIXED_COST ON FIXED_COST
(
       FIXED_COST_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE FIXED_COST
       ADD  ( PRIMARY KEY (FIXED_COST_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TREAT_FIXED_COST (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       TREAT_COST_SEQ       NUMBER(2) NOT NULL,
       FIXED_COST_ID        NUMBER(4) NOT NULL,
       FIXED_COST_AREA_ID   NUMBER(4) NOT NULL,
       SUPPLIER_ID          NUMBER(4) NOT NULL,
       FIXED_COST           NUMBER(12,3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREAT_FIXED_COST ON TREAT_FIXED_COST
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       TREAT_COST_SEQ                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREAT_FIXED_COST
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, 
              TREAT_COST_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_FIXED_COST (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_COST_SEQ        NUMBER(2) NOT NULL,
       FIXED_COST_ID        NUMBER(4) NOT NULL,
       FIXED_COST_AREA_ID   NUMBER(4) NOT NULL,
       SUPPLIER_ID          NUMBER(4) NOT NULL,
       FIXED_COST           NUMBER(12,3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_FIXED_COST ON CAMP_FIXED_COST
(
       CAMP_ID                        ASC,
       CAMP_COST_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_FIXED_COST
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_COST_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_SEG (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       EXECUTE_FLG          NUMBER(1) NOT NULL,
       PROJ_QTY             NUMBER(10) NULL,
       PROJ_RES_RATE        NUMBER(6,3) NULL,
       KEYCODE              VARCHAR2(30) NULL,
       CONTROL_FLG          NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_SEG ON CAMP_SEG
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_SEG
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE MESSAGE_TYPE (
       MESSAGE_TYPE_ID      NUMBER(1) NOT NULL,
       MESSAGE_TYPE_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKMESSAGE_TYPE ON MESSAGE_TYPE
(
       MESSAGE_TYPE_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE MESSAGE_TYPE
       ADD  ( PRIMARY KEY (MESSAGE_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_METHOD (
       WEB_METHOD_ID        NUMBER(1) NOT NULL,
       WEB_METHOD_NAME      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_METHOD ON WEB_METHOD
(
       WEB_METHOD_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_METHOD
       ADD  ( PRIMARY KEY (WEB_METHOD_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into web_method values (1, 'Include Content');
insert into web_method values (2, 'Redirect');
COMMIT;


CREATE TABLE ELEM_GRP (
       ELEM_GRP_ID          NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       ELEM_GRP_NAME        VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKELEM_GRP ON ELEM_GRP
(
       ELEM_GRP_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ELEM_GRP
       ADD  ( PRIMARY KEY (ELEM_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CONTENT_FORMT (
       CONTENT_FORMT_ID     NUMBER(2) NOT NULL,
       CONTENT_FORMT_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCONTENT_FORMT ON CONTENT_FORMT
(
       CONTENT_FORMT_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CONTENT_FORMT
       ADD  ( PRIMARY KEY (CONTENT_FORMT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into content_formt values (1, 'MPEG Video');
insert into content_formt values (2, 'MPG AUDIO');
insert into content_formt values (3, 'AVI Video');
insert into content_formt values (4, 'QUICKTIME Video');
insert into content_formt values (5, 'WAV Audio');
insert into content_formt values (6, 'AU Audio');
insert into content_formt values (7, 'AIFF Audio');
insert into content_formt values (8, 'GIF Image');
insert into content_formt values (9 , 'JPG Image');
insert into content_formt values (10, 'BMP Image');
insert into content_formt values (11, 'HTML Document');
insert into content_formt values (12, 'ADOBE ACROBAT Document');
insert into content_formt values (13, 'Text');
insert into content_formt values (14, 'Rich Text');
insert into content_formt values (15, 'SMS');
insert into content_formt values (16, 'EMS');
insert into content_formt values (17, 'Smart Message');
COMMIT;



CREATE TABLE ELEM (
       ELEM_ID              NUMBER(8) NOT NULL,
       ELEM_GRP_ID          NUMBER(4) NOT NULL,
       ELEM_NAME            VARCHAR2(50) NOT NULL,
       ELEM_DESC            VARCHAR2(300) NULL,
       VAR_COST             NUMBER(12,3) NOT NULL,
       VAR_COST_QTY         NUMBER(8) NOT NULL,
       CONTENT_FILENAME     VARCHAR2(255) NULL,
       CONTENT_FORMT_ID     NUMBER(2) NULL,
       DYN_CONTENT_FLG      NUMBER(1) NOT NULL,
       CONTENT_LENGTH       NUMBER(4) NULL,
       CONTENT              VARCHAR2(2000) NULL,
       DYN_PLACEHOLDERS     NUMBER(2) NULL,
       WEB_METHOD_ID        NUMBER(1) NULL,
       MESSAGE_TYPE_ID      NUMBER(1) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKELEM ON ELEM
(
       ELEM_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ELEM
       ADD  ( PRIMARY KEY (ELEM_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TELEM (
       ELEM_ID              NUMBER(8) NOT NULL,
       TREATMENT_ID         NUMBER(8) NOT NULL,
       ELEM_SEQ             NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTELEM ON TELEM
(
       ELEM_ID                        ASC,
       TREATMENT_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE UNIQUE INDEX XAK1TELEM ON TELEM
(
       TREATMENT_ID                   ASC,
       ELEM_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TELEM
       ADD  ( PRIMARY KEY (ELEM_ID, TREATMENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SYS_PARAM (
       SYS_PARAM_ID         NUMBER(2) NOT NULL,
       SYS_PARAM_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSYS_PARAM ON SYS_PARAM
(
       SYS_PARAM_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SYS_PARAM
       ADD  ( PRIMARY KEY (SYS_PARAM_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into sys_param values ( 1, 'User ID' );
insert into sys_param values ( 2, 'User Name' );
insert into sys_param values ( 3, 'Current Date' );
insert into sys_param values ( 4, 'Current Time' );
insert into sys_param values ( 5, 'Scheduled Activity Code'  );
insert into sys_param values ( 6, 'Customer Data View');
insert into sys_param values ( 7, 'Connection String' );
insert into sys_param values ( 8, 'Vendor Id' );
insert into sys_param values ( 9, 'Process Audit Id' );
insert into sys_param values (10, 'Campaign Id');
insert into sys_param values (11, 'Campaign Cycle Number');
COMMIT;


CREATE TABLE PROC_TYPE (
       PROC_TYPE_ID         NUMBER(1) NOT NULL,
       PROC_TYPE_CHAR       CHAR(1) NOT NULL,
       PROC_TYPE_DESC       VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_TYPE ON PROC_TYPE
(
       PROC_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_TYPE
       ADD  ( PRIMARY KEY (PROC_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into proc_type values (1, 'C', 'Compiled (C) Program');
insert into proc_type values (2, 'Q', 'SQL Routine');
insert into proc_type values (3, 'S', 'Shell Script');
insert into proc_type values (4, 'T', 'External Process');
insert into proc_type values (5, 'A', 'External Process With Auditing');
COMMIT;


CREATE TABLE EXT_PROC_GRP (
       EXT_PROC_GRP_ID      NUMBER(2) NOT NULL,
       EXT_PROC_GRP_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_PROC_GRP ON EXT_PROC_GRP
(
       EXT_PROC_GRP_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_PROC_GRP
       ADD  ( PRIMARY KEY (EXT_PROC_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EXT_PROC_CONTROL (
       EXT_PROC_ID          NUMBER(4) NOT NULL,
       PROC_TYPE_ID         NUMBER(1) NOT NULL,
       EXT_PROC_GRP_ID      NUMBER(2) NOT NULL,
       EXT_PROC_NAME        VARCHAR2(50) NOT NULL,
       EXT_PROC_DESC        VARCHAR2(300) NULL,
       EXT_PROC_FILENAME    VARCHAR2(300) NULL,
       EXT_PARAM_COUNT      NUMBER(2) NULL,
       USES_AUDITING_FLG    NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_PROC_CONTROL ON EXT_PROC_CONTROL
(
       EXT_PROC_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_PROC_CONTROL
       ADD  ( PRIMARY KEY (EXT_PROC_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EXT_PROC_PARAM (
       EXT_PROC_ID          NUMBER(4) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       PARAM_NAME           VARCHAR2(100) NULL,
       SYS_PARAM_FLG        NUMBER(1) NOT NULL,
       SYS_PARAM_ID         NUMBER(2) NULL,
       PARAM_VAL            VARCHAR2(200) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_PROC_PARAM ON EXT_PROC_PARAM
(
       EXT_PROC_ID                    ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_PROC_PARAM
       ADD  ( PRIMARY KEY (EXT_PROC_ID, PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE VAR_DATA_TYPE (
       VAR_DATA_TYPE_ID     NUMBER(1) NOT NULL,
       VAR_DATA_TYPE_NAME   VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKVAR_DATA_TYPE ON VAR_DATA_TYPE
(
       VAR_DATA_TYPE_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE VAR_DATA_TYPE
       ADD  ( PRIMARY KEY (VAR_DATA_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into var_data_type values (1, 'Character');
insert into var_data_type values (2, 'Numeric');
insert into var_data_type values (3, 'Date');
insert into var_data_type values (4, 'Currency');
insert into var_data_type values (5, 'Percent');
COMMIT;


CREATE TABLE PVDM_UPGRADE (
       VERSION_ID           VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

insert into PVDM_UPGRADE values ('6.3.0.0005.GA');
COMMIT;


CREATE TABLE TEMPL_EMAIL_MAP (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       PLACEHOLDER          VARCHAR2(50) NOT NULL,
       TEMPL_LINE_SEQ       NUMBER(4) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTEMPL_EMAIL_MAP ON TEMPL_EMAIL_MAP
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC,
       PLACEHOLDER                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TEMPL_EMAIL_MAP
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ, PLACEHOLDER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_TREAT_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PROC_DELAY           NUMBER(3) NOT NULL,
       PROC_DELAY_UNIT_ID   NUMBER(2) NOT NULL,
       IN_ALL_FLG           NUMBER(1) NOT NULL,
       TREATMENT_POOL_FLG   NUMBER(1) NOT NULL,
       VALID_DATE           DATE NULL,
       VALID_TIME	    CHAR(8) NULL,
       VALID_DAYS           NUMBER(3) NULL,
       MESSAGE_PRIO         VARCHAR2(10) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_TREAT_DET ON CAMP_TREAT_DET
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_TREAT_DET
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ELEM_WEB_MAP (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       ELEM_ID              NUMBER(8) NOT NULL,
       PLACEHOLDER          VARCHAR2(50) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKELEM_WEB_MAP ON ELEM_WEB_MAP
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       ELEM_ID                        ASC,
       PLACEHOLDER                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ELEM_WEB_MAP
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, ELEM_ID, 
              PLACEHOLDER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE JOIN_OPERATOR (
       JOIN_OPERATOR_ID     NUMBER(1) NOT NULL,
       JOIN_OPERATOR_TEXT   VARCHAR2(3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKJOIN_OPERATOR ON JOIN_OPERATOR
(
       JOIN_OPERATOR_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE JOIN_OPERATOR
       ADD  ( PRIMARY KEY (JOIN_OPERATOR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into join_operator values (1, 'AND');
insert into join_operator values (0, 'OR');
COMMIT;


CREATE TABLE WEB_STATE_TYPE (
       STATE_TYPE_ID        NUMBER(1) NOT NULL,
       STATE_TYPE_NAME      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_STATE_TYPE ON WEB_STATE_TYPE
(
       STATE_TYPE_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_STATE_TYPE
       ADD  ( PRIMARY KEY (STATE_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into web_state_type values (1, 'Request (GET)' );
insert into web_state_type values (2, 'Request (POST)' );
insert into web_state_type values (3, 'Web Session' );
insert into web_state_type values (4, 'Cookie');
COMMIT;


CREATE TABLE WEB_STATE_VAR (
       STATE_VAR_ID         NUMBER(8) NOT NULL,
       STATE_VAR_NAME       VARCHAR2(50) NOT NULL,
       STATE_VAR_DESC       VARCHAR2(300) NULL,
       VAR_DATA_TYPE_ID     NUMBER(1) NOT NULL,
       STATE_TYPE_ID        NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_STATE_VAR ON WEB_STATE_VAR
(
       STATE_VAR_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_STATE_VAR
       ADD  ( PRIMARY KEY (STATE_VAR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_TEMPL_GRP (
       WEB_TEMPL_GRP_ID     NUMBER(4) NOT NULL,
       WEB_TEMPL_GRP_NAME   VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_TEMPL_GRP ON WEB_TEMPL_GRP
(
       WEB_TEMPL_GRP_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_TEMPL_GRP
       ADD  ( PRIMARY KEY (WEB_TEMPL_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_TEMPL (
       WEB_TEMPL_ID         NUMBER(8) NOT NULL,
       WEB_TEMPL_GRP_ID     NUMBER(4) NOT NULL,
       WEB_TEMPL_NAME       VARCHAR2(100) NOT NULL,
       WEB_TEMPL_DESC       VARCHAR2(300) NULL,
       WEB_TEMPL_HEIGHT     NUMBER(8) NOT NULL,
       WEB_TEMPL_WIDTH      NUMBER(8) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_TEMPL ON WEB_TEMPL
(
       WEB_TEMPL_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_TEMPL
       ADD  ( PRIMARY KEY (WEB_TEMPL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_TEMPL_TAG (
       WEB_TEMPL_ID         NUMBER(8) NOT NULL,
       WEB_TAG_ID           NUMBER(2) NOT NULL,
       STD_WEB_TAG_FLG      NUMBER(1) NOT NULL,
       WEB_TAG_TOP          NUMBER(8) NOT NULL,
       WEB_TAG_LEFT         NUMBER(8) NOT NULL,
       WEB_TAG_HEIGHT       NUMBER(8) NOT NULL,
       WEB_TAG_WIDTH        NUMBER(8) NOT NULL,
       DFT_ELEM_ID          NUMBER(8) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_TEMPL_TAG ON WEB_TEMPL_TAG
(
       WEB_TEMPL_ID                   ASC,
       WEB_TAG_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_TEMPL_TAG
       ADD  ( PRIMARY KEY (WEB_TEMPL_ID, WEB_TAG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_TEMPL_TAG_DET (
       WEB_TEMPL_ID         NUMBER(8) NOT NULL,
       WEB_TAG_ID           NUMBER(2) NOT NULL,
       CAMP_ID              NUMBER(8) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       ELEM_ID              NUMBER(8) NOT NULL,
       CAMP_TAG_SEQ         NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_TEMPL_TAG_DET ON WEB_TEMPL_TAG_DET
(
       WEB_TEMPL_ID                   ASC,
       WEB_TAG_ID                     ASC,
       CAMP_ID                        ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_TEMPL_TAG_DET
       ADD  ( PRIMARY KEY (WEB_TEMPL_ID, WEB_TAG_ID, CAMP_ID, DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE WEB_STD_TAG (
       WEB_STD_TAG_ID       NUMBER(8) NOT NULL,
       WEB_STD_TAG_NAME     VARCHAR2(100) NOT NULL,
       WEB_STD_TAG_HEIGHT   NUMBER(8) NOT NULL,
       WEB_STD_TAG_WIDTH    NUMBER(8) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWEB_STD_TAG ON WEB_STD_TAG
(
       WEB_STD_TAG_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WEB_STD_TAG
       ADD  ( PRIMARY KEY (WEB_STD_TAG_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EMAIL_MAILBOX (
       SERVER_ID            NUMBER(4) NOT NULL,
       MAILBOX_ID           NUMBER(4) NOT NULL,
       MAILBOX_NAME         VARCHAR2(100) NOT NULL,
       MAILBOX_PASSWORD     VARCHAR2(70) NULL,
       MAILBOX_DESC         VARCHAR2(300) NULL,
       FORWARD_NONE_FLG     NUMBER(1) NOT NULL,
       FORWARD_NONE_EMAIL   VARCHAR2(100) NULL,
       FORWARD_ANY_FLG      NUMBER(1) NOT NULL,
       FORWARD_ANY_EMAIL    VARCHAR2(100) NULL,
       FORWARD_KEY_FLG      NUMBER(1) NOT NULL,
       FORWARD_KEY_EMAIL    VARCHAR2(100) NULL,
       FORWARD_SERVER_ID    NUMBER(4) NULL,
       DELETE_FLG           NUMBER(1) NOT NULL,
       BOUNCE_ONLY_FLG      NUMBER(1) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       PASSWORD_FLG         NUMBER(1) NOT NULL,
       TEST_SEND_FLG        NUMBER(1) NOT NULL,
       FORWARD_BOUNCE_FLG   NUMBER(1) NOT NULL,
       FORWARD_BOUNCE_TO    VARCHAR2(100) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEMAIL_MAILBOX ON EMAIL_MAILBOX
(
       SERVER_ID                      ASC,
       MAILBOX_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EMAIL_MAILBOX
       ADD  ( PRIMARY KEY (SERVER_ID, MAILBOX_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE MAILBOX_RES_RULE (
       SERVER_ID            NUMBER(4) NOT NULL,
       MAILBOX_ID           NUMBER(4) NOT NULL,
       RULE_ID              NUMBER(4) NOT NULL,
       RULE_SEQ             NUMBER(2) NULL,
       INSERT_VAL           VARCHAR2(160) NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL,
       FORWARD_EMAIL        VARCHAR2(100) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKMAILBOX_RES_RULE ON MAILBOX_RES_RULE
(
       SERVER_ID                      ASC,
       MAILBOX_ID                     ASC,
       RULE_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE MAILBOX_RES_RULE
       ADD  ( PRIMARY KEY (SERVER_ID, MAILBOX_ID, RULE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE LOCK_TYPE (
       LOCK_TYPE_ID         NUMBER(1) NOT NULL,
       LOCK_TYPE_NAME       VARCHAR2(50) NULL,
       LOCK_TYPE_DESC       VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLOCK_TYPE ON LOCK_TYPE
(
       LOCK_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LOCK_TYPE
       ADD  ( PRIMARY KEY (LOCK_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into lock_type values (1, 'Scheduled Lock', 'This object has been scheduled as an Adhock Batch entry; duplicate Adhoc Batch submissions are not permitted.');
insert into lock_type values (2, 'Reference Lock', 'The results table for this source object is being used by another object, and thus this source object cannot execute while the referencing entity is itself executing.  The source criteria can be edited, and the results table can be referenced by other entities.');
insert into lock_type values (3, 'Shared Lock', 'This (source) entity is being used by another entity, and thus cannot be edited or executed, but can be referenced as a source by a third object if required.');
insert into lock_type values (4, 'Exclusive Lock', 'No other User can edit, execute or reference as source this object (will be read-only).');
insert into lock_type values (5, 'Executing Lock', 'This object is currently being run, and cannot be edited or executed by another User.');
COMMIT;


CREATE TABLE USER_GRP (
       USER_GRP_ID          NUMBER(4) NOT NULL,
       USER_GRP_NAME        VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       DEFAULT_VIEW_ID      VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_GRP ON USER_GRP
(
       USER_GRP_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_GRP
       ADD  ( PRIMARY KEY (USER_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE USER_DEFINITION (
       USER_ID              VARCHAR2(30) NOT NULL,
       USER_GRP_ID          NUMBER(4) NOT NULL,
       USER_NAME            VARCHAR2(100) NOT NULL,
       USER_CODE            NUMBER(4) NOT NULL,
       DB_ACCOUNT           VARCHAR2(100) NULL,
       OS_ACCOUNT           VARCHAR2(100) NULL,
       DEFAULT_VIEW_ID      VARCHAR2(30) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       ENABLED_FLG          NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_DEFINITION ON USER_DEFINITION
(
       USER_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_DEFINITION
       ADD  ( PRIMARY KEY (USER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ACCESS_LEVEL (
       ACCESS_LEVEL_ID      NUMBER(1) NOT NULL,
       ACCESS_LEVEL_VAL     VARCHAR2(10) NOT NULL,
       ACCESS_LEVEL_DESC    VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKACCESS_LEVEL ON ACCESS_LEVEL
(
       ACCESS_LEVEL_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ACCESS_LEVEL
       ADD  ( PRIMARY KEY (ACCESS_LEVEL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into access_level values (0, 'None', 'This Module cannot be entered for the given User/CDV combination');
insert into access_level values (1, 'Read', 'Objects/results can be displayed within this Module for this User/CDV combination');
insert into access_level values (2, 'Execute', '(I) Results can be generated for existing objects within this Module for this User/CDV combination; (ii) Scheduled groups can be started and/or stopped for this User/CDV combination');
insert into access_level values (3, 'Save', '(I) New objects can be created within this Module for this User/CDV combination; (ii) Existing objects can be amended within this Module for this User/CDV combination');
insert into access_level values (4, 'Delete', 'Existing objects can be deleted within this Module for this User/CDV combination');
COMMIT;


CREATE TABLE MODULE_DEFINITION (
       MODULE_ID            NUMBER(4) NOT NULL,
       MODULE_NAME          VARCHAR2(50) NOT NULL,
       MODULE_DESC          VARCHAR2(300) NOT NULL,
       COPY_OBJ_FLG         NUMBER(1) NOT NULL,
       ALL_ACCESS_ID        NUMBER(1) NOT NULL,
       GRP_ACCESS_ID        NUMBER(1) NOT NULL,
       USER_ACCESS_ID       NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKMODULE_DEFINITION ON MODULE_DEFINITION
(
       MODULE_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE MODULE_DEFINITION
       ADD  ( PRIMARY KEY (MODULE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into MODULE_DEFINITION values ( 5, 'Attributes','Attributes',1,4,4,4);
insert into MODULE_DEFINITION values (10, 'Campaign Analysis','Campaign Analysis',1,4,4,4);
insert into MODULE_DEFINITION values (15, 'Campaign Builder','Campaign Builder',1,4,4,4);
insert into MODULE_DEFINITION values (18, 'Campaign Schedule Overview','Campaign Schedule Overview',1,4,4,4);
insert into MODULE_DEFINITION values (20, 'Data Analysis','Data Analysis',1,4,4,4);
insert into MODULE_DEFINITION values (25, 'Data Categorisation','Data Categorisation',1,4,4,4);
insert into MODULE_DEFINITION values (30, 'Data View','Data View',1,4,4,4);
insert into MODULE_DEFINITION values (35, 'Delivery Channels','Delivery Channels',1,4,4,4);
insert into MODULE_DEFINITION values (40, 'Derived Values','Derived Values',1,4,4,4);
insert into MODULE_DEFINITION values (45, 'Email Settings','Email Settings',1,4,4,4);
insert into MODULE_DEFINITION values (50, 'Extract Templates','Extract Templates',1,4,4,4);
insert into MODULE_DEFINITION values (55, 'Lookup Tables','Lookup Tables',1,4,4,4);
insert into MODULE_DEFINITION values (57, 'Outbound Optimizer', 'Outbound Optimizer',1,4,4,4);
insert into MODULE_DEFINITION values (60, 'Query Designer','Query Designer',1,4,4,4);
insert into MODULE_DEFINITION values (65, 'Response Models','Response Models',1,4,4,4);
insert into MODULE_DEFINITION values (70, 'Schedule Manager','Schedule Manager',1,4,4,4);
insert into MODULE_DEFINITION values (75, 'Score Models','Score Models',1,4,4,4);
insert into MODULE_DEFINITION values (77, 'Seed Lists','Seed Lists',1,4,4,4);
insert into MODULE_DEFINITION values (80, 'Segmentation Manager','Segmentation Manager',1,4,4,4);
insert into MODULE_DEFINITION values (85, 'Treatments','Treatments',1,4,4,4);
insert into MODULE_DEFINITION values (90, 'Web Templates','Web Templates',1,4,4,4);
insert into MODULE_DEFINITION values (92, 'Migrate Objects', 'Migrate Objects', 1,4,4,4);
COMMIT;


CREATE TABLE LOCK_CONTROL (
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       LOCK_TYPE_ID         NUMBER(1) NOT NULL,
       CLIENT_FLG           NUMBER(1) NOT NULL,
       SCHEDULED_FLG        NUMBER(1) NOT NULL,
       USER_ID              VARCHAR2(30) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       MODULE_ID            NUMBER(4) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_TIME         CHAR(8) NOT NULL,
       AUDIT_ID             NUMBER(8) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLOCK_CONTROL ON LOCK_CONTROL
(
       OBJ_ID                         ASC,
       OBJ_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LOCK_CONTROL
       ADD  ( PRIMARY KEY (OBJ_ID, OBJ_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE POSTER_SIZE (
       POSTER_SIZE_ID       NUMBER(4) NOT NULL,
       POSTER_SIZE_NAME     VARCHAR2(50) NOT NULL,
       POSTER_SIZE_DESC     VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPOSTER_SIZE ON POSTER_SIZE
(
       POSTER_SIZE_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE POSTER_SIZE
       ADD  ( PRIMARY KEY (POSTER_SIZE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE POSTER_TYPE (
       POSTER_TYPE_ID       NUMBER(4) NOT NULL,
       POSTER_TYPE_NAME     VARCHAR2(50) NOT NULL,
       POSTER_TYPE_DESC     VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPOSTER_TYPE ON POSTER_TYPE
(
       POSTER_TYPE_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE POSTER_TYPE
       ADD  ( PRIMARY KEY (POSTER_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE POSTER_CONTRACTOR (
       CONTRACTOR_ID        NUMBER(4) NOT NULL,
       CONTRACTOR_NAME      VARCHAR2(50) NOT NULL,
       CONTRACTOR_DESC      VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPOSTER_CONTRACTOR ON POSTER_CONTRACTOR
(
       CONTRACTOR_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE POSTER_CONTRACTOR
       ADD  ( PRIMARY KEY (CONTRACTOR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_PLACEMENT (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       DUR                  NUMBER(8) NULL,
       DUR_UNIT_ID          NUMBER(2) NULL,
       FIXED_COST           NUMBER(12,3) NULL,
       PROJ_QTY             NUMBER(10) NULL,
       PROJ_RES_RATE        NUMBER(6,3) NULL,
       KEYCODE              VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_PLACEMENT ON CAMP_PLACEMENT
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_PLACEMENT
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_POST (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       POSTER_SIZE_ID       NUMBER(4) NULL,
       POSTER_TYPE_ID       NUMBER(4) NULL,
       CONTRACTOR_ID        NUMBER(4) NULL,
       QTY_OF_SITES         NUMBER(9) NULL,
       COVERAGE             VARCHAR2(100) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_POST ON CAMP_POST
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_POST
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE COMP_TYPE (
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_TYPE_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCOMP_TYPE ON COMP_TYPE
(
       COMP_TYPE_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE COMP_TYPE
       ADD  ( PRIMARY KEY (COMP_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into comp_type values (1, 'Data Field');
insert into comp_type values (2, 'Stored Field');
insert into comp_type values (3, 'Constructed Field');
insert into comp_type values (4, 'Derived Value');
insert into comp_type values (5, 'Score Model');
insert into comp_type values (6, 'Text');
insert into comp_type values (7, 'Number');
insert into comp_type values (8, 'Date');
insert into comp_type values (9, 'Filename');
insert into comp_type values (10, 'Date-time Stamp');
insert into comp_type values (11, 'Record Count');
insert into comp_type values (12, 'Strategy Code');
insert into comp_type values (13, 'Strategy Name');
insert into comp_type values (14, 'Group Code');
insert into comp_type values (15, 'Group Name');
insert into comp_type values (16, 'Campaign Code');
insert into comp_type values (17, 'Campaign Name');
insert into comp_type values (18, 'Campaign ID');
insert into comp_type values (19, 'Treatment Code');
insert into comp_type values (20, 'Treatment Name');
insert into comp_type values (21, 'Segment Code');
insert into comp_type values (22, 'Keycode');
insert into comp_type values (23, 'Campaign Cycle');
insert into comp_type values (24, 'Campaign Node ID');
insert into comp_type values (25, 'Segment Name');
insert into comp_type values (26, 'Parent Node ID');
insert into comp_type values (27, 'Parent Communication Node ID');
insert into comp_type values (28, 'Response Run Number');
insert into comp_type values (29, 'Integer');
insert into comp_type values (30, 'Decimal');
insert into comp_type values (31, 'Campaign Custom Attribute');
insert into comp_type values (32, 'Treatment Custom Attribute');
insert into comp_type values (33, 'Delivery Channel Custom Attribute');
insert into comp_type values (34, 'Version ID');
insert into comp_type values (35, 'Decision');
COMMIT;


CREATE TABLE SEED_LIST_DET (
       SEED_LIST_ID         NUMBER(4) NOT NULL,
       SEED_COL_SEQ         NUMBER(4) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       DYN_COL_NAME         VARCHAR2(18) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEED_LIST_DET ON SEED_LIST_DET
(
       SEED_LIST_ID                   ASC,
       SEED_COL_SEQ                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEED_LIST_DET
       ADD  ( PRIMARY KEY (SEED_LIST_ID, SEED_COL_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE OUT_SEED_MAPPING (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       TEMPL_LINE_SEQ       NUMBER(4) NOT NULL,
       SEED_LIST_ID         NUMBER(4) NULL,
       SEED_COL_SEQ         NUMBER(4) NULL,
       DEFAULT_VAL          VARCHAR2(100) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKOUT_SEED_MAPPING ON OUT_SEED_MAPPING
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC,
       TEMPL_LINE_SEQ                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE OUT_SEED_MAPPING
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ, TEMPL_LINE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

CREATE TABLE SCORE_GRP (
       SCORE_GRP_ID         NUMBER(4) NOT NULL,
       SCORE_GRP_NAME       VARCHAR2(50) NOT NULL,
       SCORE_GRP_DESC       VARCHAR2(300) NULL
)
    	 TABLESPACE &ts_pv_sys
 ;


CREATE UNIQUE INDEX XPKSCORE_GRP ON SCORE_GRP 
(
	SCORE_GRP_ID	ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SCORE_GRP
       ADD  ( PRIMARY KEY (SCORE_GRP_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind )
;


CREATE TABLE SCORE_HDR (
       SCORE_ID             NUMBER(8) NOT NULL,
       SCORE_NAME           VARCHAR2(50) NOT NULL,
       SCORE_DESC           VARCHAR2(300) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       SCORE_TYPE           NUMBER(1) NOT NULL,
       USE_OPTION           NUMBER(1) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       TEXT_FLG             NUMBER(1) NULL,
       MULTI_RESULT_FLG     NUMBER(1) NULL,
       SCORE_GRP_ID	    NUMBER(4) NULL,
       DECISION_CONFIG_ID   NUMBER(8) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSCORE_HDR ON SCORE_HDR
(
       SCORE_ID                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SCORE_HDR
       ADD  ( PRIMARY KEY (SCORE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE INDEX XIE1SCORE_HDR ON SCORE_HDR
(
       DECISION_CONFIG_ID             ASC
)
    	 TABLESPACE &ts_pv_ind
;


CREATE TABLE DECISION_CONFIG (
       DECISION_CONFIG_ID   NUMBER(8) NOT NULL,
       CONFIG_NAME          VARCHAR2(50) NOT NULL,
       CONFIG_DESC          VARCHAR2(300) NULL,
       LOGIC_NAME           VARCHAR2(50) NULL,
       LOGIC_VERSION        VARCHAR2(15) NULL,
       LOGIC_PATH           VARCHAR2(900) NULL,
       LOGIC_COMP_NAME      VARCHAR2(255) NULL,
       DDS_TAB_NAME         VARCHAR2(128) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CREATED_BY	    VARCHAR2(30) NOT NULL,
       CREATED_DATE	    DATE NOT NULL
)
    	 TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDECISION_CONFIG ON DECISION_CONFIG
(
	DECISION_CONFIG_ID	ASC
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE DECISION_CONFIG
       ADD  ( PRIMARY KEY (DECISION_CONFIG_ID)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) 
;


CREATE TABLE CUST_TAB_GRP (
       CUST_TAB_GRP_ID      NUMBER(2) NOT NULL,
       CUST_TAB_GRP_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCUST_TAB_GRP ON CUST_TAB_GRP
(
       CUST_TAB_GRP_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CUST_TAB_GRP
       ADD  ( PRIMARY KEY (CUST_TAB_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CUST_TAB (
       VIEW_ID              VARCHAR2(30) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       VANTAGE_NAME         VARCHAR2(100) NOT NULL,
       CUST_TAB_GRP_ID      NUMBER(2) NOT NULL,
       TAB_DISPLAY_SEQ      NUMBER(8) NULL,
       VANTAGE_TYPE         NUMBER(1) NULL
                                   CHECK (VANTAGE_TYPE BETWEEN 1 AND 2),
       ALT_JOIN_SRC         VARCHAR2(128) NULL,
       DB_ENT_NAME          VARCHAR2(128) NOT NULL,
       DB_ENT_OWNER         VARCHAR2(128) NOT NULL,
       DB_VIEW_BASE_TAB     VARCHAR2(257) NULL,
       DB_REMOTE_STRING     VARCHAR2(128) NULL,
       STD_JOIN_FLG         NUMBER(1) NOT NULL,
       STD_JOIN_FROM_COL    VARCHAR2(128) NULL,
       STD_JOIN_TO_COL      VARCHAR2(128) NULL,
       PAR_VANTAGE_ALIAS    VARCHAR2(128) NULL,
       COL_DISPLAY          VARCHAR2(1000) NULL,
       DISPLAY_FLG          NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCUST_TAB ON CUST_TAB
(
       VIEW_ID                        ASC,
       VANTAGE_ALIAS                  ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE UNIQUE INDEX XAK1CUST_TAB ON CUST_TAB
(
       VIEW_ID                        ASC,
       TAB_DISPLAY_SEQ                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CUST_TAB
       ADD  ( PRIMARY KEY (VIEW_ID, VANTAGE_ALIAS)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CUSTOM_ATTR (
       ATTR_ID 			NUMBER(8) NOT NULL, 
       ATTR_NAME 		VARCHAR2(50) NOT NULL, 
       ATTR_DESC 		VARCHAR2(300) NULL, 
       DEFINE_TYPE_ID 		NUMBER(2) NOT NULL, 
       COMP_TYPE_ID 		NUMBER(2) NOT NULL, 
       ASSOC_OBJ_TYPE_ID 	NUMBER(3) NOT NULL, 
       LOOKUP_ENT_OWNER 	VARCHAR2(128) NULL, 
       LOOKUP_ENT 		VARCHAR2(128) NULL,
       LOOKUP_VAL_COL 		VARCHAR2(128) NULL,
       WHERE_FLG		NUMBER(1) NULL, 
       WHERE_COL 		VARCHAR2(128) NULL,
       WHERE_VAL		VARCHAR2(100) NULL
) 
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCUSTOM_ATTR ON CUSTOM_ATTR 
( 
       ATTR_ID ASC 
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE CUSTOM_ATTR 
       ADD  ( PRIMARY KEY ( ATTR_ID ) 
       USING INDEX 
              TABLESPACE &ts_pv_ind )
;


CREATE TABLE CUSTOM_ATTR_VAL ( 
       ASSOC_OBJ_TYPE_ID 	NUMBER(3) NOT NULL, 
       ASSOC_OBJ_ID 		NUMBER(8) NOT NULL,
       ASSOC_OBJ_SUB_ID 	NUMBER(8) NOT NULL, 
       ATTR_ID 			NUMBER(8) NOT NULL, 
       ATTR_SEQ 		NUMBER(4) NOT NULL,
       VAL_TEXT 		VARCHAR2(1000) NULL, 
       VAL_INTEGER 		NUMBER(10) NULL, 
       VAL_DECIMAL 		NUMBER(12,3) NULL, 
       VAL_DATE 		DATE NULL
) 
     TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCUSTOM_ATTR_VAL ON CUSTOM_ATTR_VAL 
( 
       ASSOC_OBJ_TYPE_ID 	ASC, 
       ASSOC_OBJ_ID 		ASC, 
       ASSOC_OBJ_SUB_ID 	ASC, 
       ATTR_ID 			ASC, 
       ATTR_SEQ 		ASC 
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE CUSTOM_ATTR_VAL 
       ADD ( PRIMARY KEY (ASSOC_OBJ_TYPE_ID, ASSOC_OBJ_ID, ASSOC_OBJ_SUB_ID, ATTR_ID, ATTR_SEQ) 
       USING INDEX 
              TABLESPACE &ts_pv_ind )
;


CREATE TABLE ATTR_DEFINITION ( 
       ATTR_ID 		NUMBER(8) NOT NULL, 
       VAL_ID 		NUMBER(4) NOT NULL,
       VAL_TEXT 	VARCHAR2(1000) NULL, 
       VAL_INTEGER 	NUMBER(10) NULL, 
       VAL_DECIMAL 	NUMBER(12,3) NULL,
       VAL_DATE DATE NULL 
) 
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKATTR_DEFINITION ON ATTR_DEFINITION 
( 
       ATTR_ID 		ASC, 
       VAL_ID 		ASC 
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE ATTR_DEFINITION 
       ADD ( PRIMARY KEY ( ATTR_ID, VAL_ID ) 
       USING INDEX 
             TABLESPACE &ts_pv_ind )
;


CREATE TABLE VANTAGE_FUNCTION (
       FUNCTION_ID          NUMBER(2) NOT NULL,
       FUNCTION_NAME        VARCHAR2(10) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKVANTAGE_FUNCTION ON VANTAGE_FUNCTION
(
       FUNCTION_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE VANTAGE_FUNCTION
       ADD  ( PRIMARY KEY (FUNCTION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into vantage_function values (0, 'None');
insert into vantage_function values (1, 'Sum');
insert into vantage_function values (2, 'Average');
insert into vantage_function values (3, 'Maximum');
insert into vantage_function values (4, 'Minimum');
insert into vantage_function values (5, 'Count');
insert into vantage_function values (6, 'First');
insert into vantage_function values (7, 'Last');
insert into vantage_function values (8, 'Rank');
insert into vantage_function values (9, 'Dates');
COMMIT;


CREATE TABLE DERIVED_VAL_HDR (
       DERIVED_VAL_ID       NUMBER(8) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       DERIVED_VAL_NAME     VARCHAR2(100) NOT NULL,
       DERIVED_VAL_TEXT     CLOB NOT NULL,
       BASE_VANTAGE_ALIAS   VARCHAR2(128) NOT NULL,
       BASE_COL_NAME        VARCHAR2(128) NOT NULL,
       FUNCTION_ID          NUMBER(2) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       UPDATED_DATE         DATE NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       WHERE_FLG            NUMBER(1) NULL,
       WHERE_SEG_ID         NUMBER(8) NULL,
       GROUP_BY_FLG         NUMBER(1) NULL,
       GROUP_BY             VARCHAR2(2000) NULL,
       ORDER_BY             VARCHAR2(2000) NULL,
       PRECISION_FLG        NUMBER(1) NULL,
       DATA_PRECISION       NUMBER(4) NULL,
       OPTIMISE_CLAUSE      VARCHAR2(300) NULL,
       OPTIMISE_FLG         NUMBER(1) NOT NULL,
       ADDL_INFO_FLG        NUMBER(1) NULL,
       ADDL_INFO            VARCHAR2(2000) NULL,
       DATE_ADD_FLG         NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDERIVED_VAL_HDR ON DERIVED_VAL_HDR
(
       DERIVED_VAL_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DERIVED_VAL_HDR
       ADD  ( PRIMARY KEY (DERIVED_VAL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE COND_OPERATOR (
       COND_OPERATOR_ID     NUMBER(2) NOT NULL,
       COND_OPERATOR_NAME   VARCHAR2(11) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCOND_OPERATOR ON COND_OPERATOR
(
       COND_OPERATOR_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE COND_OPERATOR
       ADD  ( PRIMARY KEY (COND_OPERATOR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into cond_operator values (0, '<none>');
insert into cond_operator values (1, '=');
insert into cond_operator values (2, '!=');
insert into cond_operator values (3, '>');
insert into cond_operator values (4, '<');
insert into cond_operator values (5, '>=');
insert into cond_operator values (6, '<=');
insert into cond_operator values (7, 'Between');
insert into cond_operator values (8, 'Not Between');
insert into cond_operator values (9, 'Like');
insert into cond_operator values (10, 'Not Like');
insert into cond_operator values (11, 'In');
insert into cond_operator values (12, 'Not In');
COMMIT;


CREATE TABLE GRP_FTR_TYPE (
       GRP_FTR_TYPE_ID      NUMBER(1) NOT NULL,
       GRP_FTR_TYPE_NAME    VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKGRP_FTR_TYPE ON GRP_FTR_TYPE
(
       GRP_FTR_TYPE_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE GRP_FTR_TYPE
       ADD  ( PRIMARY KEY (GRP_FTR_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into grp_ftr_type values (0, 'None');
insert into grp_ftr_type values (1, 'Sum');
insert into grp_ftr_type values (2, 'Average');
COMMIT;


CREATE TABLE DATA_REP_HDR (
       DATA_REP_ID          NUMBER(6) NOT NULL,
       DATA_REP_NAME        VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       VAL_VANTAGE_ALIAS    VARCHAR2(128) NOT NULL,
       VAL_COL_NAME         VARCHAR2(128) NOT NULL,
       CONTENT_COUNT_FLG    NUMBER(1) NOT NULL,
       USE_COND_FLG         NUMBER(1) NOT NULL,
       GRP_FTR_TYPE_ID      NUMBER(1) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       GRAPH_CAPTION        VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATA_REP_HDR ON DATA_REP_HDR
(
       DATA_REP_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATA_REP_HDR
       ADD  ( PRIMARY KEY (DATA_REP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DATA_REP_DET (
       DATA_REP_ID          NUMBER(6) NOT NULL,
       ROW_FLG              NUMBER(1) NOT NULL,
       DATA_REP_SEQ         NUMBER(3) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_ID              NUMBER(8) NULL,
       DISPLAY_NAME         VARCHAR2(50) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL,
       COND_OPERATOR_ID     NUMBER(2) NOT NULL,
       COND_VAL             VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATA_REP_DET ON DATA_REP_DET
(
       DATA_REP_ID                    ASC,
       ROW_FLG                        ASC,
       DATA_REP_SEQ                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATA_REP_DET
       ADD  ( PRIMARY KEY (DATA_REP_ID, ROW_FLG, DATA_REP_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SCORE_SRC (
       SCORE_ID             NUMBER(8) NOT NULL,
       SRC_TYPE_ID          NUMBER(3) NOT NULL,
       SRC_ID               NUMBER(8) NOT NULL,
       SRC_SUB_ID           NUMBER(6) NOT NULL,
       SRC_NAME             VARCHAR2(100) NULL,
       SRC_SUB_NAME         VARCHAR2(100) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       LAST_RUN_QTY         NUMBER(10) NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSCORE_SRC ON SCORE_SRC
(
       SCORE_ID                       ASC,
       SRC_TYPE_ID                    ASC,
       SRC_ID                         ASC,
       SRC_SUB_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SCORE_SRC
       ADD  ( PRIMARY KEY (SCORE_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DECISION_DEDUPE (
       SCORE_ID             NUMBER(8) NOT NULL,
       SRC_TYPE_ID          NUMBER(3) NOT NULL,
       SRC_ID               NUMBER(8) NOT NULL,
       SRC_SUB_ID           NUMBER(6) NOT NULL,
       PRIO_SEQ_NUMBER      NUMBER(4) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       DEDUPE_PRIO_HIGH     NUMBER(1) NOT NULL,
       NULLS_PRIO_HIGH      NUMBER(1) NOT NULL
)
    	 TABLESPACE &ts_pv_sys
 ;


CREATE UNIQUE INDEX XPKDECISION_DEDUPE ON DECISION_DEDUPE 
(
	SCORE_ID	ASC,
	SRC_TYPE_ID	ASC,
	SRC_ID		ASC,
	SRC_SUB_ID	ASC,
	PRIO_SEQ_NUMBER	ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DECISION_DEDUPE
       ADD  ( PRIMARY KEY (SCORE_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID, 
              PRIO_SEQ_NUMBER)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table DECISION_INPUT
      */

CREATE TABLE DECISION_INPUT (
       DECISION_CONFIG_ID   NUMBER(8) NOT NULL,
       DDS_COL_NAME         VARCHAR2(50) NOT NULL,
       INPUT_NAME           VARCHAR2(128) NOT NULL,
       INPUT_DATATYPE       VARCHAR2(12) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL
)
    	 TABLESPACE &ts_pv_sys
 ;


CREATE UNIQUE INDEX XPKDECISION_INPUT ON DECISION_INPUT 
(
	DECISION_CONFIG_ID	ASC,
	DDS_COL_NAME		ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DECISION_INPUT
       ADD  ( PRIMARY KEY (DECISION_CONFIG_ID, DDS_COL_NAME)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table DECISION_OUTPUT
      */

CREATE TABLE DECISION_OUTPUT (
       DECISION_CONFIG_ID   NUMBER(8) NOT NULL,
       COL_NAME		    VARCHAR2(128) NOT NULL,
       OUTPUT_NAME          VARCHAR2(128) NOT NULL,
       OUTPUT_DATATYPE      VARCHAR2(12) NOT NULL
)
    	 TABLESPACE &ts_pv_sys
 ;


CREATE UNIQUE INDEX XPKDECISION_OUTPUT ON DECISION_OUTPUT 
(
	DECISION_CONFIG_ID	ASC,
	COL_NAME		ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DECISION_OUTPUT
       ADD  ( PRIMARY KEY (DECISION_CONFIG_ID, COL_NAME)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table DECISION_SRC_INPUT
      */

CREATE TABLE DECISION_SRC_INPUT (
       SCORE_ID             NUMBER(8) NOT NULL,
       SRC_TYPE_ID          NUMBER(3) NOT NULL,
       SRC_ID               NUMBER(8) NOT NULL,
       SRC_SUB_ID           NUMBER(6) NOT NULL,
       DECISION_CONFIG_ID   NUMBER(8) NOT NULL,
       DDS_COL_NAME         VARCHAR2(50) NOT NULL,
       DEDUPE_FLG           NUMBER(1) NULL,
       STORED_FLD_SEQ       NUMBER(4) NULL
)
    	 TABLESPACE &ts_pv_sys
 ;


CREATE UNIQUE INDEX XPKDECISION_SRC_IN ON DECISION_SRC_INPUT 
(
	SCORE_ID		ASC,
	SRC_TYPE_ID		ASC,
	SRC_ID			ASC,
	SRC_SUB_ID		ASC,
	DECISION_CONFIG_ID	ASC,
	DDS_COL_NAME		ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DECISION_SRC_INPUT
       ADD  ( PRIMARY KEY (SCORE_ID, SRC_TYPE_ID, SRC_ID, SRC_SUB_ID, 
              DECISION_CONFIG_ID, DDS_COL_NAME)
       USING INDEX
    	 TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DERIVED_VAL_SRC (
       DERIVED_VAL_ID       NUMBER(8) NOT NULL,
       SRC_TYPE_ID          NUMBER(3) NOT NULL,
       SRC_ID               NUMBER(8) NOT NULL,
       SRC_SUB_ID           NUMBER(6) NOT NULL,
       SRC_NAME             VARCHAR2(100) NULL,
       SRC_SUB_NAME         VARCHAR2(100) NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       LAST_QTY             NUMBER(10) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL,
       GENERATED_SQL        CLOB NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDERIVED_VAL_SRC ON DERIVED_VAL_SRC
(
       DERIVED_VAL_ID                 ASC,
       SRC_TYPE_ID                    ASC,
       SRC_ID                         ASC,
       SRC_SUB_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DERIVED_VAL_SRC
       ADD  ( PRIMARY KEY (DERIVED_VAL_ID, SRC_TYPE_ID, SRC_ID, 
              SRC_SUB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CONS_FLD_HDR (
       CONS_ID              NUMBER(4) NOT NULL,
       CONS_TYPE            NUMBER(1) NOT NULL,
       CONS_NAME            VARCHAR2(100) NOT NULL,
       CONS_LINE_LEN        NUMBER(6) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCONS_FLD_HDR ON CONS_FLD_HDR
(
       CONS_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CONS_FLD_HDR
       ADD  ( PRIMARY KEY (CONS_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EXT_TEMPL_DET (
       EXT_TEMPL_ID         NUMBER(8) NOT NULL,
       LINE_SEQ             NUMBER(4) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_ID              NUMBER(8) NULL,
       SRC_TYPE_ID          NUMBER(3) NULL,
       SRC_ID               NUMBER(8) NULL,
       SRC_SUB_ID           NUMBER(6) NULL,
       STRING_VAL           VARCHAR2(200) NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL,
       MIXED_CASE_FLG       NUMBER(1) NOT NULL,
       SHUFFLE_FLG          NUMBER(1) NOT NULL,
       SAMPLE_VAL           VARCHAR2(200) NULL,
       SORT_ORDER           NUMBER(1) NULL,
       SORT_DESCEND_FLG     NUMBER(1) NULL,
       OUT_LENGTH           NUMBER(4) NOT NULL,
       JUSTIFICATION        CHAR(1) NOT NULL,
       PAD_CHAR             CHAR(5) NOT NULL,
       DYN_COL_NAME         VARCHAR2(128) NOT NULL,
       COL_FORMAT           VARCHAR2(50) NULL,
       INC_EMAIL_FLG	    NUMBER(1) NOT NULL,
       ORIG_COMP_TYPE_ID    NUMBER(2) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_TEMPL_DET ON EXT_TEMPL_DET
(
       EXT_TEMPL_ID                   ASC,
       LINE_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_TEMPL_DET
       ADD  ( PRIMARY KEY (EXT_TEMPL_ID, LINE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EXT_HDR_AND_FTR (
       EXT_TEMPL_ID         NUMBER(8) NOT NULL,
       RECORD_TYPE          NUMBER(1) NOT NULL,
       SEQ_NUMBER           NUMBER(4) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_ID		    NUMBER(8) NULL,
       STRING_VAL           VARCHAR2(200) NULL,
       OUT_LENGTH           NUMBER(4) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEXT_HDR_AND_FTR ON EXT_HDR_AND_FTR
(
       EXT_TEMPL_ID                   ASC,
       RECORD_TYPE                    ASC,
       SEQ_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EXT_HDR_AND_FTR
       ADD  ( PRIMARY KEY (EXT_TEMPL_ID, RECORD_TYPE, SEQ_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE COMM_STATUS (
       COMM_STATUS_ID       NUMBER(1) NOT NULL,
       COMM_STATUS_NAME     VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCOMM_STATUS ON COMM_STATUS
(
       COMM_STATUS_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE COMM_STATUS
       ADD  ( PRIMARY KEY (COMM_STATUS_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into comm_status values (0, 'Standard Communication');
insert into comm_status values (1, 'Control Group');
insert into comm_status values (2, 'Not Delivered');
insert into comm_status values (3, 'Not Delivered due to DT');
COMMIT;


CREATE TABLE CAMP_COMM_OUT_HDR (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NOT NULL,
       COMM_STATUS_ID       NUMBER(1) NOT NULL,
       PAR_COMM_DET_ID      NUMBER(4) NOT NULL,
       PAR_DET_ID           NUMBER(4) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       COMM_QTY             NUMBER(10) NOT NULL,
       TOTAL_COST           NUMBER(12,3) NULL,
       RUN_DATE             DATE NOT NULL,
       RUN_TIME             CHAR(8) NOT NULL,
       KEYCODE              VARCHAR2(30) NULL,
       TREAT_QTY            NUMBER(10) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       CAMP_CYC                       ASC,
       RUN_NUMBER                     ASC,
       COMM_STATUS_ID                 ASC,
       PAR_COMM_DET_ID                ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMP_COMM_OUT_HDR ON CAMP_COMM_OUT_HDR
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       PAR_DET_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_COMM_OUT_HDR
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, 
              RUN_NUMBER, COMM_STATUS_ID, PAR_COMM_DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CHARAC_GRP (
       CHARAC_GRP_ID        NUMBER(4) NOT NULL,
       CHARAC_GRP_NAME      VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCHARAC_GRP ON CHARAC_GRP
(
       CHARAC_GRP_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CHARAC_GRP
       ADD  ( PRIMARY KEY (CHARAC_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CHARAC (
       CHARAC_ID            NUMBER(4) NOT NULL,
       CHARAC_GRP_ID        NUMBER(4) NOT NULL,
       CHARAC_NAME          VARCHAR2(50) NOT NULL,
       CHARAC_DESC          VARCHAR2(300) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCHARAC ON CHARAC
(
       CHARAC_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CHARAC
       ADD  ( PRIMARY KEY (CHARAC_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TCHARAC (
       CHARAC_ID            NUMBER(4) NOT NULL,
       TREATMENT_ID         NUMBER(8) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTCHARAC ON TCHARAC
(
       CHARAC_ID                      ASC,
       TREATMENT_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE UNIQUE INDEX XAK1TCHARAC ON TCHARAC
(
       TREATMENT_ID                   ASC,
       CHARAC_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TCHARAC
       ADD  ( PRIMARY KEY (CHARAC_ID, TREATMENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE STORED_FLD_TEMPL (
       SEG_ID               NUMBER(8) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NOT NULL, 
       SEQ_NUMBER           NUMBER(4) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       DEDUPE_FLG           NUMBER(1) NOT NULL,
       DEDUPE_SEQ           NUMBER(2) NOT NULL,
       DIRECT_JOIN_FLG      NUMBER(1) NOT NULL,
       SUBSTITUTION_FLG	    NUMBER(1) NOT NULL,
       DYN_COL_NAME         VARCHAR2(18) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSTORED_FLD_TEMPL ON STORED_FLD_TEMPL
(
       SEG_ID                         ASC,
       SEG_TYPE_ID                    ASC,
       SEQ_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE STORED_FLD_TEMPL
       ADD  ( PRIMARY KEY (SEG_ID, SEG_TYPE_ID, SEQ_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_RES_MODEL (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       RES_RUNS             NUMBER(8) NOT NULL,
       RES_DELAY            NUMBER(8) NOT NULL,
       RES_DELAY_UNIT_ID    NUMBER(2) NOT NULL,
       RES_INT_DELAY        NUMBER(8) NULL,
       RES_INT_DELAY_UNIT   NUMBER(2) NULL,
       RES_START_TIME       CHAR(8) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_RES_MODEL ON CAMP_RES_MODEL
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_RES_MODEL
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RADIO_REGION (
       RADIO_REGION_ID      NUMBER(4) NOT NULL,
       RADIO_REGION_NAME    VARCHAR2(50) NOT NULL,
       RADIO_REGION_DESC    VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRADIO_REGION ON RADIO_REGION
(
       RADIO_REGION_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RADIO_REGION
       ADD  ( PRIMARY KEY (RADIO_REGION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE LEAF_REGION (
       LEAF_REGION_ID       NUMBER(4) NOT NULL,
       LEAF_REGION_NAME     VARCHAR2(50) NOT NULL,
       LEAF_REGION_DESC     VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLEAF_REGION ON LEAF_REGION
(
       LEAF_REGION_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LEAF_REGION
       ADD  ( PRIMARY KEY (LEAF_REGION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CDV_ACCESS (
       VIEW_ID              VARCHAR2(30) NOT NULL,
       COPY_FROM_CDV_FLG    NUMBER(1) NOT NULL,
       COPY_TO_CDV_FLG      NUMBER(1) NOT NULL,
       ALL_ACCESS_ID        NUMBER(1) NOT NULL,
       GRP_ACCESS_ID        NUMBER(1) NOT NULL,
       USER_ACCESS_ID       NUMBER(1) NOT NULL,
       RUN_BATCH_FLG        NUMBER(1) NOT NULL,
       RUN_CAMPAIGN_FLG     NUMBER(1) NOT NULL,
       RUN_TASK_GRP_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCDV_ACCESS ON CDV_ACCESS
(
       VIEW_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CDV_ACCESS
       ADD  ( PRIMARY KEY (VIEW_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE USER_CDV_EXCEP (
       USER_ID              VARCHAR2(30) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       APPROVE_CAMP_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_CDV_EXCEP ON USER_CDV_EXCEP
(
       USER_ID                        ASC,
       VIEW_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_CDV_EXCEP
       ADD  ( PRIMARY KEY (USER_ID, VIEW_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE USER_ACCESS_EXCEP (
       USER_ID              VARCHAR2(30) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       MODULE_ID            NUMBER(4) NOT NULL,
       COPY_OBJ_FLG         NUMBER(1) NOT NULL,
       ALL_ACCESS_ID        NUMBER(1) NOT NULL,
       GRP_ACCESS_ID        NUMBER(1) NOT NULL,
       USER_ACCESS_ID       NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_ACCESS_EXCEP ON USER_ACCESS_EXCEP
(
       USER_ID                        ASC,
       VIEW_ID                        ASC,
       MODULE_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_ACCESS_EXCEP
       ADD  ( PRIMARY KEY (USER_ID, VIEW_ID, MODULE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE USER_GRP_CDV (
       USER_GRP_ID          NUMBER(4) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       APPROVE_CAMP_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_GRP_CDV ON USER_GRP_CDV
(
       USER_GRP_ID                    ASC,
       VIEW_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_GRP_CDV
       ADD  ( PRIMARY KEY (USER_GRP_ID, VIEW_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE USER_GRP_ACCESS (
       USER_GRP_ID          NUMBER(4) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       MODULE_ID            NUMBER(4) NOT NULL,
       COPY_OBJ_FLG         NUMBER(1) NOT NULL,
       ALL_ACCESS_ID        NUMBER(1) NOT NULL,
       GRP_ACCESS_ID        NUMBER(1) NOT NULL,
       USER_ACCESS_ID       NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUSER_GRP_ACCESS ON USER_GRP_ACCESS
(
       USER_GRP_ID                    ASC,
       VIEW_ID                        ASC,
       MODULE_ID                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE USER_GRP_ACCESS
       ADD  ( PRIMARY KEY (USER_GRP_ID, VIEW_ID, MODULE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE VANTAGE_ENT (
       ENT_NAME             VARCHAR2(30) NOT NULL,
       TAB_VIEW_FLG         NUMBER(1) NULL,
       SYSTEM_DATA_FLG      NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKVANTAGE_ENT ON VANTAGE_ENT
(
       ENT_NAME                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE VANTAGE_ENT
       ADD  ( PRIMARY KEY (ENT_NAME)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into vantage_ent values ('ACCESS_LEVEL',1,1);
insert into vantage_ent values ('ACTION_CUSTOM',1,0);
insert into vantage_ent values ('ACTION_FORWARD',1,0);
insert into vantage_ent values ('ACTION_STORE_CAMP',1,0);
insert into vantage_ent values ('ACTION_STORE_VAL',1,0);
insert into vantage_ent values ('ATTACHMENT',1,0);
insert into vantage_ent values ('ATTR_DEFINITION',1,0);
insert into vantage_ent values ('CAMPAIGN',1,0);
insert into vantage_ent values ('CAMP_COMM_IN_DET',1,0);
insert into vantage_ent values ('CAMP_COMM_IN_HDR',1,0);
insert into vantage_ent values ('CAMP_COMM_OUT_DET',1,0);
insert into vantage_ent values ('CAMP_COMM_OUT_HDR',1,0);
insert into vantage_ent values ('CAMP_CYC_STATUS',1,0);
insert into vantage_ent values ('CAMP_DDROP',1,0);
insert into vantage_ent values ('CAMP_DET',1,0);
insert into vantage_ent values ('CAMP_DET_RUN_HIST',1,0);
insert into vantage_ent values ('CAMP_DRTV',1,0);
insert into vantage_ent values ('CAMP_FIXED_COST',1,0);
insert into vantage_ent values ('CAMP_GRP',1,0);
insert into vantage_ent values ('CAMP_LEAF',1,0);
insert into vantage_ent values ('CAMP_MANAGER',1,0);
insert into vantage_ent values ('CAMP_MAP_SFDYN',1,0);
insert into vantage_ent values ('CAMP_OUT_DET',1,0);
insert into vantage_ent values ('CAMP_OUT_GRP',1,0);
insert into vantage_ent values ('CAMP_OUT_GRP_SPLIT',1,0);
insert into vantage_ent values ('CAMP_OUT_RESULT',1,0);
insert into vantage_ent values ('CAMP_PLACEMENT',1,0);
insert into vantage_ent values ('CAMP_PLAN',1,0);
insert into vantage_ent values ('CAMP_POST',1,0);
insert into vantage_ent values ('CAMP_PUB',1,0);
insert into vantage_ent values ('CAMP_RADIO',1,0);
insert into vantage_ent values ('CAMP_REP_COL',1,1);
insert into vantage_ent values ('CAMP_REP_COND',1,0);
insert into vantage_ent values ('CAMP_REP_DET',1,0);
insert into vantage_ent values ('CAMP_REP_GRP',1,0);
insert into vantage_ent values ('CAMP_REP_HDR',1,0);
insert into vantage_ent values ('CAMP_RES_DET',1,0);
insert into vantage_ent values ('CAMP_RES_MODEL',1,0);
insert into vantage_ent values ('CAMP_RESULT_PROC',1,0);
insert into vantage_ent values ('CAMP_SEG',1,0);
insert into vantage_ent values ('CAMP_STATUS_HIST',1,0);
insert into vantage_ent values ('CAMP_TEMPL',1,1);
insert into vantage_ent values ('CAMP_TREAT_DET',1,0);
insert into vantage_ent values ('CAMP_TYPE',1,0);
insert into vantage_ent values ('CAMP_VERSION',1,0);
insert into vantage_ent values ('CDV_ACCESS',1,0);
insert into vantage_ent values ('CDV_HDR',1,0);
insert into vantage_ent values ('CHAN_OUT_TYPE',1,1);
insert into vantage_ent values ('CHAN_TYPE',1,1);
insert into vantage_ent values ('CHARAC',1,0);
insert into vantage_ent values ('CHARAC_GRP',1,0);
insert into vantage_ent values ('COLLECT_POINT',1,0);
insert into vantage_ent values ('COMM_NON_CONTACT', 1, 0);
insert into vantage_ent values ('COMM_STATUS',1,1);
insert into vantage_ent values ('COMP_TYPE',1,1);
insert into vantage_ent values ('COND_OPERATOR',1,1);
insert into vantage_ent values ('CONS_FLD_DET',1,0);
insert into vantage_ent values ('CONS_FLD_HDR',1,0);
insert into vantage_ent values ('CONSTRAINT_SETTING',1,1);
insert into vantage_ent values ('CONSTRAINT_TYPE',1,1);
insert into vantage_ent values ('CONTENT_FORMT',1,1);
insert into vantage_ent values ('CUST_JOIN',1,0);
insert into vantage_ent values ('CUST_TAB',1,0);
insert into vantage_ent values ('CUST_TAB_GRP',1,0);
insert into vantage_ent values ('CUSTOM_ATTR',1,0);
insert into vantage_ent values ('CUSTOM_ATTR_VAL',1,0);
insert into vantage_ent values ('DATAVIEW_TEMPL_DET',1,0);
insert into vantage_ent values ('DATAVIEW_TEMPL_HDR',1,0);
insert into vantage_ent values ('DATA_CAT_HDR',1,0);
insert into vantage_ent values ('DATA_REP_DET',1,0);
insert into vantage_ent values ('DATA_REP_HDR',1,0);
insert into vantage_ent values ('DATA_REP_SRC',1,0);
insert into vantage_ent values ('DDROP_CARRIER',1,0);
insert into vantage_ent values ('DDROP_REGION',1,0);
insert into vantage_ent values ('DECISION_CONFIG',1,0);
insert into vantage_ent values ('DECISION_DEDUPE',1,0);
insert into vantage_ent values ('DECISION_INPUT',1,0);
insert into vantage_ent values ('DECISION_OUTPUT',1,0);
insert into vantage_ent values ('DECISION_SRC_INPUT',1,0);
insert into vantage_ent values ('DEFINE_TYPE',1,1);
insert into vantage_ent values ('DELIVERY_CHAN',1,0);
insert into vantage_ent values ('DELIVERY_METHOD',1,1);
insert into vantage_ent values ('DELIVERY_RECEIPT',1,0);
insert into vantage_ent values ('DELIVERY_SERVER',1,0);
insert into vantage_ent values ('DELIVERY_STATUS',1,1);
insert into vantage_ent values ('DERIVED_VAL_HDR',1,0);
insert into vantage_ent values ('DERIVED_VAL_SRC',1,0);
insert into vantage_ent values ('DISTRIB_POINT',1,0);
insert into vantage_ent values ('DUR_UNIT',1,1);
insert into vantage_ent values ('ELEM',1,0);
insert into vantage_ent values ('ELEM_GRP',1,0);
insert into vantage_ent values ('ELEM_WEB_MAP',1,0);
insert into vantage_ent values ('EMAIL_MAILBOX',1,0);
insert into vantage_ent values ('EMAIL_PROTOCOL',1,1);
insert into vantage_ent values ('EMAIL_RES',1,0);
insert into vantage_ent values ('EMAIL_SERVER',1,0);
insert into vantage_ent values ('EMAIL_TYPE',1,1);
insert into vantage_ent values ('EMPTY_CYC_TYPE',1,1);
insert into vantage_ent values ('ERES_RULE_DET',1,0);
insert into vantage_ent values ('ERES_RULE_GRP',1,0);
insert into vantage_ent values ('ERES_RULE_HDR',1,0);
insert into vantage_ent values ('ERES_RULE_TYPE',1,1);
insert into vantage_ent values ('EV_CAMP_DET',1,0);
insert into vantage_ent values ('EXT_HDR_AND_FTR',1,0);
insert into vantage_ent values ('EXT_PROC_CONTROL',1,0);
insert into vantage_ent values ('EXT_PROC_GRP',1,0);
insert into vantage_ent values ('EXT_PROC_PARAM',1,0);
insert into vantage_ent values ('EXT_TEMPL_DET',1,0);
insert into vantage_ent values ('EXT_TEMPL_HDR',1,0);
insert into vantage_ent values ('FIXED_COST',1,0);
insert into vantage_ent values ('FIXED_COST_AREA',1,0);
insert into vantage_ent values ('GRP_FTR_TYPE',1,1);
insert into vantage_ent values ('GRP_FUNCTION',1,1);
insert into vantage_ent values ('GRP_TYPE',1,1);
insert into vantage_ent values ('INTERVAL_CYC_DET',1,0);
insert into vantage_ent values ('JOIN_OPERATOR',1,1);
insert into vantage_ent values ('LEAF_DISTRIB',1,0);
insert into vantage_ent values ('LEAF_REGION',1,0);
insert into vantage_ent values ('LOCK_CONTROL',1,0);
insert into vantage_ent values ('LOCK_TYPE',1,1);
insert into vantage_ent values ('LOOKUP_TAB_GRP',1,0);
insert into vantage_ent values ('LOOKUP_TAB_HDR',1,0);
insert into vantage_ent values ('MAILBOX_RES_RULE',1,0);
insert into vantage_ent values ('MAIN_SPI_ACTION',1,1);
insert into vantage_ent values ('MESSAGE_SEVER',1,1);
insert into vantage_ent values ('MESSAGE_TYPE',1,1);
insert into vantage_ent values ('MODULE_DEFINITION',1,1);
insert into vantage_ent values ('NODE_TYPE',1,1);
insert into vantage_ent values ('NPI_TYPE',1,1);
insert into vantage_ent values ('OBJ_TYPE',1,1);
insert into vantage_ent values ('OUT_CHAN_COMP',1,0);
insert into vantage_ent values ('OUT_GRP_NAME_COMP',1,0);
insert into vantage_ent values ('OUT_SEED_MAPPING',1,0);
insert into vantage_ent values ('PAGE_FACING',1,1);
insert into vantage_ent values ('PORTION_TYPE',1,1);
insert into vantage_ent values ('POSTER_CONTRACTOR',1,0);
insert into vantage_ent values ('POSTER_SIZE',1,0);
insert into vantage_ent values ('POSTER_TYPE',1,0);
insert into vantage_ent values ('PROC_AUDIT_DET',1,0);
insert into vantage_ent values ('PROC_AUDIT_DET_VAR',1,0);
insert into vantage_ent values ('PROC_AUDIT_HDR',1,0);
insert into vantage_ent values ('PROC_AUDIT_PARAM',1,0);
insert into vantage_ent values ('PROC_CONTROL',1,1);
insert into vantage_ent values ('PROC_PARAM',1,1);
insert into vantage_ent values ('PROC_TYPE',1,1);
insert into vantage_ent values ('PROTOCOL_VERSION',1,1);
insert into vantage_ent values ('PUB',1,0);
insert into vantage_ent values ('PUBSEC',1,0);
insert into vantage_ent values ('PVDM_UPGRADE',1,1);
insert into vantage_ent values ('RADIO',1,0);
insert into vantage_ent values ('RADIO_REGION',1,0);
insert into vantage_ent values ('REF_INDICATOR',1,1);
insert into vantage_ent values ('REFERENCED_OBJ',1,0);
insert into vantage_ent values ('REM_ACTION_TYPE',1,1);
insert into vantage_ent values ('REM_CLIENT_DET',1,0);
insert into vantage_ent values ('REM_CLIENT_HDR',1,0);
insert into vantage_ent values ('REP_COL_GRP',1,1);
insert into vantage_ent values ('RESTRICT_TYPE',1,1);
insert into vantage_ent values ('RES_ACTION_TYPE',1,1);
insert into vantage_ent values ('RES_CHANNEL',1,0);
insert into vantage_ent values ('RES_CUSTOM_PARAM',1,0);
insert into vantage_ent values ('RES_SYS_PARAM',1,1);
insert into vantage_ent values ('RES_MODEL_HDR',1,0);
insert into vantage_ent values ('RES_MODEL_STREAM',1,0);
insert into vantage_ent values ('RES_RULE_ACTION',1,0);
insert into vantage_ent values ('RES_STREAM_DET',1,0);
insert into vantage_ent values ('RES_TYPE',1,0);
insert into vantage_ent values ('SAMPLE_TYPE',1,1);
insert into vantage_ent values ('SAS_SCORE_RESULT',1,0);
insert into vantage_ent values ('SCORE_DET',1,0);
insert into vantage_ent values ('SCORE_EXTERNAL',1,0);
insert into vantage_ent values ('SCORE_GRP',1,0);
insert into vantage_ent values ('SCORE_HDR',1,0);
insert into vantage_ent values ('SCORE_SRC',1,0);
insert into vantage_ent values ('SEARCH_AREA',1,1);
insert into vantage_ent values ('SEED_LIST_DET',1,0);
insert into vantage_ent values ('SEED_LIST_GRP',1,0);
insert into vantage_ent values ('SEED_LIST_HDR',1,0);
insert into vantage_ent values ('SEG_DEDUPE_PRIO',1,0);
insert into vantage_ent values ('SEG_GRP',1,0);
insert into vantage_ent values ('SEG_HDR',1,0);
insert into vantage_ent values ('SEG_SQL',1,0);
insert into vantage_ent values ('SPI_AUDIT_DET',1,0);
insert into vantage_ent values ('SPI_AUDIT_DET_VAR',1,0);
insert into vantage_ent values ('SPI_AUDIT_HDR',1,0);
insert into vantage_ent values ('SPI_AUDIT_PARAM',1,0);
insert into vantage_ent values ('SPI_CAMP_PROC',1,0);
insert into vantage_ent values ('SPI_CAMP_PROC_PAR',1,0);
insert into vantage_ent values ('SPI_CAMP_PROC_VAR',1,0);
insert into vantage_ent values ('SPI_CONTROL',1,1);
insert into vantage_ent values ('SPI_LINK',1,0);
insert into vantage_ent values ('SPI_MASTER',1,0);
insert into vantage_ent values ('SPI_PROC',1,0); 
insert into vantage_ent values ('SPI_PROC_VAR',1,0);
insert into vantage_ent values ('SPI_TIME_CONTROL',1,0);
insert into vantage_ent values ('SPI_TYPE',1,1);
insert into vantage_ent values ('SPLIT_TYPE',1,1);
insert into vantage_ent values ('STATUS_SETTING',1,1);
insert into vantage_ent values ('STORED_FLD_TEMPL',1,0);
insert into vantage_ent values ('STRATEGY',1,0);
insert into vantage_ent values ('SUBS_CAMPAIGN',1,0);
insert into vantage_ent values ('SUBS_CAMP_CYC',1,0);
insert into vantage_ent values ('SUBS_CAMP_CYC_ORG',1,0);
insert into vantage_ent values ('SUBS_CAMP_ORG_DET',1,0);
insert into vantage_ent values ('SUPPLIER',1,0);
insert into vantage_ent values ('SYS_PARAM',1,1);
insert into vantage_ent values ('TCHARAC',1,0);
insert into vantage_ent values ('TELEM',1,0);
insert into vantage_ent values ('TEMPL_EMAIL_MAP',1,0);
insert into vantage_ent values ('TEST_TEMPL_MAP',1,0);
insert into vantage_ent values ('TEST_TYPE',1,1);
insert into vantage_ent values ('TON_TYPE',1,1);
insert into vantage_ent values ('TREATMENT',1,0);
insert into vantage_ent values ('TREATMENT_GRP',1,0);
insert into vantage_ent values ('TREATMENT_TEST',1,0);
insert into vantage_ent values ('TREAT_FIXED_COST',1,0);
insert into vantage_ent values ('TREE_BASE',1,0);
insert into vantage_ent values ('TREE_DET',1,0);
insert into vantage_ent values ('TREE_GRP',1,0);
insert into vantage_ent values ('TREE_HDR',1,0);
insert into vantage_ent values ('TV_REGION',1,0);
insert into vantage_ent values ('TV_STATION',1,0);
insert into vantage_ent values ('UPDATE_STATUS',1,1);
insert into vantage_ent values ('USER_ACCESS_EXCEP',1,0);
insert into vantage_ent values ('USER_CDV_EXCEP',1,0);
insert into vantage_ent values ('USER_DEFINITION',1,0);
insert into vantage_ent values ('USER_GRP',1,0);
insert into vantage_ent values ('USER_GRP_ACCESS',1,0);
insert into vantage_ent values ('USER_GRP_CDV',1,0);
insert into vantage_ent values ('VANTAGE_DYN_TAB',1,0);
insert into vantage_ent values ('VANTAGE_ENT',1,1);
insert into vantage_ent values ('VANTAGE_FUNCTION',1,1);
insert into vantage_ent values ('VAR_DATA_TYPE',1,1);
insert into vantage_ent values ('WEB_IMPRESSION',1,0);
insert into vantage_ent values ('WEB_METHOD',1,1);
insert into vantage_ent values ('WEB_STATE_TYPE',1,1);
insert into vantage_ent values ('WEB_STATE_VAR',1,0);
insert into vantage_ent values ('WEB_STD_TAG',1,0);
insert into vantage_ent values ('WEB_TEMPL',1,0);
insert into vantage_ent values ('WEB_TEMPL_GRP',1,0);
insert into vantage_ent values ('WEB_TEMPL_TAG',1,0);
insert into vantage_ent values ('WEB_TEMPL_TAG_DET',1,0);
insert into vantage_ent values ('WIRELESS_PROTOCOL',1,1);
insert into vantage_ent values ('WIRELESS_INBOX',1,0);
insert into vantage_ent values ('WIRELESS_RES', 1, 0);
insert into vantage_ent values ('WIRELESS_RES_RULE', 1, 0);
insert into vantage_ent values ('WIRELESS_SERVER', 1, 0);
insert into vantage_ent values ('WIRELESS_VENDOR',1,1);
insert into vantage_ent values ('CAMP_ANALYSIS',0,0);
insert into vantage_ent values ('CAMP_COMM_INB_SUM',0,0);
insert into vantage_ent values ('CAMP_COMM_OUT_SUM',0,0);
insert into vantage_ent values ('CAMP_SEG_COST',0,0);
insert into vantage_ent values ('CAMP_SEG_COUNT',0,0);
insert into vantage_ent values ('CAMP_SEG_DET',0,0);
insert into vantage_ent values ('CAMP_STATUS',0,0);
insert into vantage_ent values ('CHARAC_COMM_INFO',0,0);
insert into vantage_ent values ('ELEM_COMM_INFO',0,0);
insert into vantage_ent values ('INB_PROJECTION',0,0);
insert into vantage_ent values ('OUTB_PROJECTION',0,0);
insert into vantage_ent values ('PV_COLS',0,0);
insert into vantage_ent values ('PV_IND',0,0);
insert into vantage_ent values ('PV_IND_COLS',0,0);
insert into vantage_ent values ('PV_SESSION_ROLES',0,0);
insert into vantage_ent values ('PV_TABS',0,0);
insert into vantage_ent values ('PV_VIEWS',0,0);
insert into vantage_ent values ('RES_REV_COST',0,0);
insert into vantage_ent values ('TREAT_COMM_INFO',0,0);
insert into vantage_ent values ('TREAT_SEG_COST',0,0);
insert into vantage_ent values ('TREAT_SEG_COUNT',0,0);
insert into vantage_ent values ('USER_ACCESS_PROF',0,0);
insert into vantage_ent values ('VANTAGE_ALL_TAB',0,0);
insert into vantage_ent values ('WEB_EXPOSURE',0,0);
insert into vantage_ent values ('WEB_CLICKTHROUGH',0,0);
insert into VANTAGE_ENT values ('EXPORT_HDR', 1, 0);
insert into VANTAGE_ENT values ('IMPORT_HDR', 1, 0);
insert into VANTAGE_ENT values ('IMPORT_OBJ_MAP', 1, 0);
insert into VANTAGE_ENT values ('IMPORT_TYPE', 1, 1);
insert into VANTAGE_ENT values ('REPLACE_TYPE', 1, 1);
COMMIT;



CREATE TABLE DATA_CAT_HDR (
       DATA_CAT_ID          NUMBER(8) NOT NULL,
       BUSINESS_NAME        VARCHAR2(50) NULL,
       BUSINESS_DESC        VARCHAR2(300) NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       COL_DATA_TYPE        NUMBER(1) NOT NULL,
       LOOKUP_ENT           VARCHAR2(128) NULL,
       LOOKUP_ENT_OWNER     VARCHAR2(128) NULL,
       LOOKUP_VAL_COL       VARCHAR2(128) NULL,
       LOOKUP_DESC_COL      VARCHAR2(128) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL,
       USE_LOOKUP_FLG       NUMBER(1) NOT NULL,
       WHERE_FLG            NUMBER(1) NULL,
       WHERE_COL            VARCHAR2(128) NULL,
       WHERE_VAL            VARCHAR2(100) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATA_CAT_HDR ON DATA_CAT_HDR
(
       DATA_CAT_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATA_CAT_HDR
       ADD  ( PRIMARY KEY (DATA_CAT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TV_STATION (
       TV_ID                NUMBER(4) NOT NULL,
       TV_NAME              VARCHAR2(50) NOT NULL,
       TV_DESC              VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTV_STATION ON TV_STATION
(
       TV_ID                          ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TV_STATION
       ADD  ( PRIMARY KEY (TV_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RADIO (
       RADIO_ID             NUMBER(4) NOT NULL,
       RADIO_NAME           VARCHAR2(50) NOT NULL,
       RADIO_DESC           VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRADIO ON RADIO
(
       RADIO_ID                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RADIO
       ADD  ( PRIMARY KEY (RADIO_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_RADIO (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       RADIO_REGION_ID      NUMBER(4) NULL,
       RADIO_ID             NUMBER(4) NULL,
       PROGRAMME_IN         VARCHAR2(50) NULL,
       PROGRAMME_OUT        VARCHAR2(50) NULL,
       AUDIENCE_DESC        VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_RADIO ON CAMP_RADIO
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_RADIO
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE LEAF_DISTRIB (
       LEAF_DISTRIB_ID      NUMBER(4) NOT NULL,
       LEAF_DISTRIB_NAME    VARCHAR2(50) NOT NULL,
       LEAF_DISTRIB_DESC    VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLEAF_DISTRIB ON LEAF_DISTRIB
(
       LEAF_DISTRIB_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LEAF_DISTRIB
       ADD  ( PRIMARY KEY (LEAF_DISTRIB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE COLLECT_POINT (
       COLLECT_POINT_ID     NUMBER(4) NOT NULL,
       COLLECT_POINT_NAME   VARCHAR2(50) NOT NULL,
       COLLECT_POINT_DESC   VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCOLLECT_POINT ON COLLECT_POINT
(
       COLLECT_POINT_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE COLLECT_POINT
       ADD  ( PRIMARY KEY (COLLECT_POINT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DISTRIB_POINT (
       DISTRIB_POINT_ID     NUMBER(4) NOT NULL,
       DISTRIB_POINT_NAME   VARCHAR2(50) NOT NULL,
       DISTRIB_POINT_DESC   VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDISTRIB_POINT ON DISTRIB_POINT
(
       DISTRIB_POINT_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DISTRIB_POINT
       ADD  ( PRIMARY KEY (DISTRIB_POINT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_LEAF (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       LEAF_REGION_ID       NUMBER(4) NULL,
       LEAF_DISTRIB_ID      NUMBER(4) NULL,
       COLLECT_POINT_ID     NUMBER(4) NULL,
       DISTRIB_POINT_ID     NUMBER(4) NULL,
       RET_QTY              NUMBER(10) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_LEAF ON CAMP_LEAF
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_LEAF
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SCORE_DET (
       SCORE_ID             NUMBER(8) NOT NULL,
       SCORE_SEQ            NUMBER(4) NOT NULL,
       OBJ_ID               NUMBER(8) NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       SCORE_VAL_NUMBER     NUMBER(12,3) NULL,
       SCORE_VAL_TEXT       VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSCORE_DET ON SCORE_DET
(
       SCORE_ID                       ASC,
       SCORE_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SCORE_DET
       ADD  ( PRIMARY KEY (SCORE_ID, SCORE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PROC_CONTROL (
       PROC_NAME            VARCHAR2(100) NOT NULL,
       PROC_DESC            VARCHAR2(300) NULL,
       PROC_TYPE_ID         NUMBER(1) NOT NULL,
       FILENAME             VARCHAR2(50) NULL,
       LOCATION             VARCHAR2(255) NULL,
       PARAM_COUNT          NUMBER(2) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_CONTROL ON PROC_CONTROL
(
       PROC_NAME                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_CONTROL
       ADD  ( PRIMARY KEY (PROC_NAME)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into proc_control values ('Data Analysis Tree', null, 1, 'v_dataanalysisproc', '&bin_location', 15);
insert into proc_control values ('Data Analysis', null, 1, 'v_dataanalysisproc', '&bin_location', 14);
insert into proc_control values ('Data Categorisation Header', null, 1, 'v_data_catproc', '&bin_location', 16);
insert into proc_control values ('Data Categorisation', null, 1, 'v_data_catproc', '&bin_location', 15);
insert into proc_control values ('Lock Process', null, 1, 'Lock Process', null, 0);
insert into proc_control values ('Score Model Tree', null, 1, 'v_scoreproc', '&bin_location', 15);
insert into proc_control values ('Score Model', null, 1, 'v_scoreproc', '&bin_location', 14);
insert into proc_control values ('Derived Value Tree', null, 1, 'v_derived_valueproc', '&bin_location', 16);
insert into proc_control values ('Derived Value', null, 1, 'v_derived_valueproc', '&bin_location', 15);
insert into proc_control values ('Segment Processor', null, 1, 'v_segproc', '&bin_location', 14);
insert into proc_control values ('Segment Processor Campaign', null, 1, 'v_segproc', '&bin_location', 18);
insert into proc_control values ('Segmentation Manager', null, 1, 'v_segment_manproc', '&bin_location', 12);
insert into proc_control values ('Data View Tree', null, 1, 'v_dataviewproc', '&bin_location', 15);
insert into proc_control values ('Data View', null, 1, 'v_dataviewproc', '&bin_location', 14);
insert into proc_control values ('Scheduled Process Initiator', null, 1, 'v_spiproc', '&bin_location', 13);
insert into proc_control values ('Scheduled Process Manager', null, 1, 'v_spmproc', '&bin_location', 13);
insert into proc_control values ('Email Delivery', null, 1, 'v_emaildelivery_proc', '&bin_location', 17);
insert into proc_control values ('Inbound Email', null, 1, 'v_inechannelproc', '&bin_location', 13);
insert into proc_control values ('Outputs', null, 1, 'v_outputproc', '&bin_location', 13);
insert into proc_control values ('Campaign Communication', null, 1, 'v_campaign_commproc', '&bin_location', 24);
insert into proc_control values ('Lookup Tables', null, 1, 'v_lookup_tablesproc', '&bin_location', 14);
insert into proc_control values ('Seed Lists', null, 1, 'v_seedlistsproc', '&bin_location', 12);
insert into proc_control values ('SMS Delivery', null, 1, 'v_sms_proc', '&bin_location', 18);
insert into proc_control values ('Test Treatment', null, 1, 'v_treatmenttest_proc', '&bin_location', 13);
insert into proc_control values ('Lock Angel', null, 1, 'v_lpangelproc', '&bin_location', 4);
insert into proc_control values ('Connection Pool', null, 1, 'v_cpangelproc', '&bin_location', 3);
insert into proc_control values ('Java Activator', null, 1, 'v_jaangelproc', '&bin_location', 4);
insert into proc_control values ('Publish Campaign', null, 1, 'v_pubcampproc', '&bin_location', 18);
insert into proc_control values ('Inbound Wireless', null, 1, 'v_inbound_wirelessproc.bat', '&bin_location', 13);
insert into proc_control values ('Decision Processor', null, 1, 'v_decisionproc', '&bin_location', 17);
insert into proc_control values ('Migration Batch', 'Migration Batch Processing', 1,'RunMigration.cmd', '&bin_location', 8);
COMMIT;


CREATE TABLE SPI_CAMP_PROC (
       SPI_ID               NUMBER(8) NOT NULL,
       CAMP_PROC_SEQ        NUMBER(6) NOT NULL,
       CAMP_ID              NUMBER(8) NOT NULL,
       DET_ID               NUMBER(4) NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       PAR_DET_ID           NUMBER(4) NULL,
       PAR_COMM_DET_ID      NUMBER(4) NULL,
       DIRECTION_TYPE       CHAR(1) NOT NULL,
       PROC_NAME            VARCHAR2(100) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_DESC             VARCHAR2(300) NULL,
       SRC_TYPE_ID          NUMBER(3) NULL,
       SRC_ID               NUMBER(8) NULL,
       START_DATE           DATE NOT NULL,
       START_TIME           CHAR(8) NOT NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       PREVIOUS_SQL_TEXT    VARCHAR2(2000) NULL,
       ADDL_CRITERIA        VARCHAR2(2000) NULL,
       NON_OUTB_FLG         NUMBER(1) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NULL,
       FIRST_CRITERIA_FLG   NUMBER(1) NOT NULL,
       EXT_PROC_ID          NUMBER(4) NULL,
       SRC_SUB_ID           NUMBER(6) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_CAMP_PROC ON SPI_CAMP_PROC
(
       SPI_ID                         ASC,
       CAMP_PROC_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       CAMP_ID                        ASC,
       CAMP_CYC                       ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE2SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       CAMP_PROC_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE3SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       STATUS_SETTING_ID              ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE4SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       START_DATE		      ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE5SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       START_TIME	              ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE6SPI_CAMP_PROC ON SPI_CAMP_PROC
(
       SPI_ID	              ASC,
       DET_ID		      ASC
)
       TABLESPACE &ts_pv_ind
;

ALTER TABLE SPI_CAMP_PROC
       ADD  ( PRIMARY KEY (SPI_ID, CAMP_PROC_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_LINK (
       SPI_ID               NUMBER(8) NOT NULL,
       MASTER_SPI_ID        NUMBER(8) NOT NULL,
       LINK_COMPLETED_FLG   NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_LINK ON SPI_LINK
(
       SPI_ID                         ASC,
       MASTER_SPI_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_LINK
       ADD  ( PRIMARY KEY (SPI_ID, MASTER_SPI_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE MAIN_SPI_ACTION (
       MAIN_SPI_ACTION_ID   NUMBER(1) NOT NULL,
       SPI_ACTION_CHAR      CHAR(1) NOT NULL,
       SPI_ACTION_DESC      VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKMAIN_SPI_ACTION ON MAIN_SPI_ACTION
(
       MAIN_SPI_ACTION_ID             ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE MAIN_SPI_ACTION
       ADD  ( PRIMARY KEY (MAIN_SPI_ACTION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into main_spi_action values (1, 'C', 'Close - will disconnect, sleep while scheduling is down, then re-connect');
insert into main_spi_action values (2, 'E', 'End - will disconnect and shutdown completely');
insert into main_spi_action values (3, 'S', 'Sleep - will sleep while scheduling is down, remaining connected throughout');
COMMIT;


CREATE TABLE SPI_TIME_CONTROL (
       MAIN_SPI_ACTION_ID   NUMBER(1) NOT NULL,
       DOWN_TIME_DAY        NUMBER(1) NOT NULL,
       DOWN_TIME_START      CHAR(8) NOT NULL,
       UP_TIME_START        CHAR(8) NOT NULL,
       GRACE_PERIOD         NUMBER(4) NULL,
       AUTO_RESTART_FLG     NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;


CREATE TABLE SPI_AUDIT_HDR (
       SPI_AUDIT_ID         NUMBER(8) NOT NULL,
       SPI_ID               NUMBER(8) NOT NULL,
       SPI_TYPE_ID          NUMBER(1) NOT NULL,
       SYSTEM_PROC_ID       NUMBER(8) NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       END_DATE             DATE NULL,
       END_TIME             CHAR(8) NULL,
       ACTUAL_RUN_DUR       NUMBER(8) NULL,
       SOFTWARE_VER         VARCHAR2(128) NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       PROC_COUNT           NUMBER(6) NOT NULL,
       COMPLETED_COUNT      NUMBER(6) NOT NULL,
       PARAM_COUNT          NUMBER(2) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       USER_ID              VARCHAR2(30) NOT NULL,
       RUN_CYC_NUMBER       NUMBER(8) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_AUDIT_HDR ON SPI_AUDIT_HDR
(
       SPI_AUDIT_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_AUDIT_HDR
       ADD  ( PRIMARY KEY (SPI_AUDIT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into spi_audit_hdr values (1,0,0,0,SYSDATE, to_char(SYSDATE,'HH24:MM:SS'),NULL, NULL,0,NULL,4,0,0,0,'BASE_VIEW','v3spi',NULL);
COMMIT;


CREATE TABLE PROC_AUDIT_HDR (
       PROC_AUDIT_ID        NUMBER(8) NOT NULL,
       PROC_NAME            VARCHAR2(100) NOT NULL,
       SPI_AUDIT_ID         NUMBER(8) NOT NULL,
       SYSTEM_PROC_ID       NUMBER(8) NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       END_DATE             DATE NULL,
       END_TIME             CHAR(8) NULL,
       ACTUAL_RUN_DUR       NUMBER(8) NULL,
       SOFTWARE_VER         VARCHAR2(128) NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       RECORD_COUNT         NUMBER(9) NULL,
       PARAM_COUNT          NUMBER(2) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       USER_ID              VARCHAR2(30) NOT NULL,
       SPI_PROC_SEQ         NUMBER(6) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_AUDIT_HDR ON PROC_AUDIT_HDR
(
       PROC_AUDIT_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_AUDIT_HDR
       ADD  ( PRIMARY KEY (PROC_AUDIT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TREE_BASE (
       TREE_ID              NUMBER(8) NOT NULL,
       BASE_SEQ             NUMBER(6) NOT NULL,
       ORIGIN_TYPE_ID       NUMBER(3) NOT NULL,
       ORIGIN_ID            NUMBER(8) NULL,
       ORIGIN_SUB_ID        NUMBER(6) NULL,
       STATIC_FLG           NUMBER(1) NOT NULL,
       NODE_SEQ             NUMBER(4) NOT NULL,
       NOT_IN_FLG           NUMBER(1) NOT NULL,
       USE_BY               NUMBER(4) NOT NULL,
       NET_QTY              NUMBER(10) NULL,
       GROSS_QTY            NUMBER(10) NULL,
       CUMULATIVE_QTY       NUMBER(10) NULL,
       UPDATED_BY           VARCHAR2(30) NOT NULL,
       UPDATED_DATE         DATE NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NULL,
       SEG_ID               NUMBER(8) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTREE_BASE ON TREE_BASE
(
       TREE_ID                        ASC,
       BASE_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TREE_BASE
       ADD  ( PRIMARY KEY (TREE_ID, BASE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PAGE_FACING (
       PAGE_FACING_ID       NUMBER(1) NOT NULL,
       PAGE_FACING_NAME     VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPAGE_FACING ON PAGE_FACING
(
       PAGE_FACING_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PAGE_FACING
       ADD  ( PRIMARY KEY (PAGE_FACING_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into page_facing values (1, 'Back Page');
insert into page_facing values (2, 'Centre Page');
insert into page_facing values (3, 'Front Page');
insert into page_facing values (4, 'Left Page');
insert into page_facing values (5, 'Right Page');
COMMIT;


CREATE TABLE PUB (
       PUB_ID               NUMBER(4) NOT NULL,
       PUB_NAME             VARCHAR2(50) NOT NULL,
       PUB_DESC             VARCHAR2(300) NULL,
       CIRCULATION          NUMBER(10) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPUB ON PUB
(
       PUB_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PUB
       ADD  ( PRIMARY KEY (PUB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PUBSEC (
       PUB_ID               NUMBER(4) NOT NULL,
       PUB_SEC_ID           NUMBER(4) NOT NULL,
       PUB_SEC_NAME         VARCHAR2(50) NOT NULL,
       PUB_SEC_DESC         VARCHAR2(300) NULL,
       NUMBER_OF_PAGES      NUMBER(3) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPUBSEC ON PUBSEC
(
       PUB_ID                         ASC,
       PUB_SEC_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PUBSEC
       ADD  ( PRIMARY KEY (PUB_ID, PUB_SEC_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_PUB (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       PUB_ID               NUMBER(4) NULL,
       PUB_SEC_ID           NUMBER(4) NULL,
       PAGE_FACING_ID       NUMBER(1) NULL,
       PAGE_POSITION        VARCHAR2(18) NULL,
       PAGE_NUMBER          NUMBER(4) NULL,
       ADD_SIZE             VARCHAR2(30) NULL,
       VOUCHERED_FLG        NUMBER(1) NULL,
       ENVIRONMENT          VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_PUB ON CAMP_PUB
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_PUB
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE MESSAGE_SEVER (
       MESSAGE_SEVER_ID     NUMBER(1) NOT NULL,
       MESSAGE_SEVER_DESC   VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKMESSAGE_SEVER ON MESSAGE_SEVER
(
       MESSAGE_SEVER_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE MESSAGE_SEVER
       ADD  ( PRIMARY KEY (MESSAGE_SEVER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into message_sever values (1, 'Process abort');
insert into message_sever values (2, 'Process start and end');
insert into message_sever values (3, 'Critical error message');
insert into message_sever values (4, 'Database error message');
insert into message_sever values (5, 'Processing error message');
insert into message_sever values (6, 'Warning message');
insert into message_sever values (7, 'Critical information message');
insert into message_sever values (8, 'General progress information message');
insert into message_sever values (9, 'Additional information message');
COMMIT;


CREATE TABLE SPI_CONTROL (
       SPI_PARAM            VARCHAR2(24) NOT NULL,
       SPI_PARAM_VAL        VARCHAR2(30) NOT NULL,
       SPI_PARAM_DESC       VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_CONTROL ON SPI_CONTROL
(
       SPI_PARAM                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_CONTROL
       ADD  ( PRIMARY KEY (SPI_PARAM)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into spi_control values ('DOWN_TIME_DEFINED', 'N', 'Indicates if any down-time periods are defined');
insert into spi_control values ('MAIN_SPI_SUSPENDED', 'N', 'Indicates if the main SPI has been suspended (while set, the main SPI cannot be started');
COMMIT;


CREATE TABLE OUT_CHAN_COMP (
       CHAN_ID              NUMBER(8) NOT NULL,
       COMP_SEQ             NUMBER(2) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       OUT_LENGTH           NUMBER(4) NOT NULL,
       STRING_VAL           VARCHAR2(200) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKOUT_CHAN_COMP ON OUT_CHAN_COMP
(
       CHAN_ID                        ASC,
       COMP_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE OUT_CHAN_COMP
       ADD  ( PRIMARY KEY (CHAN_ID, COMP_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE OUT_GRP_NAME_COMP (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_OUT_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_OUT_DET_ID      NUMBER(8) NOT NULL,
       SPLIT_SEQ            NUMBER(3) NOT NULL,
       COMP_SEQ             NUMBER(2) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       OUT_LENGTH           NUMBER(4) NOT NULL,
       STRING_VAL           VARCHAR2(200) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKOUT_GRP_NAME_COMP ON OUT_GRP_NAME_COMP
(
       CAMP_ID                        ASC,
       CAMP_OUT_GRP_ID                ASC,
       CAMP_OUT_DET_ID                ASC,
       SPLIT_SEQ                      ASC,
       COMP_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE OUT_GRP_NAME_COMP
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_OUT_GRP_ID, CAMP_OUT_DET_ID, 
              SPLIT_SEQ, COMP_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_CAMP_PROC_PAR (
       SPI_ID               NUMBER(8) NOT NULL,
       CAMP_PROC_SEQ        NUMBER(6) NOT NULL,
       PAR_CAMP_PROC_SEQ    NUMBER(6) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_CAMP_PROC_PAR ON SPI_CAMP_PROC_PAR
(
       SPI_ID                         ASC,
       CAMP_PROC_SEQ                  ASC,
       PAR_CAMP_PROC_SEQ              ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_CAMP_PROC_PAR
       ADD  ( PRIMARY KEY (SPI_ID, CAMP_PROC_SEQ, PAR_CAMP_PROC_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_PROC (
       SPI_ID               NUMBER(8) NOT NULL,
       PROC_SEQ             NUMBER(6) NOT NULL,
       CAMP_PROC_SEQ        NUMBER(6) NOT NULL,
       PROC_NAME            VARCHAR2(100) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_DESC             VARCHAR2(300) NULL,
       SRC_TYPE_ID          NUMBER(3) NULL,
       SRC_ID               NUMBER(8) NULL,
       EST_RUN_DUR          NUMBER(8) NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL,
       EXT_PROC_ID          NUMBER(4) NULL,
       SRC_SUB_ID           NUMBER(6) NULL,
       CONCUR_EXCEP_FLG     NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_PROC ON SPI_PROC
(
       SPI_ID                         ASC,
       PROC_SEQ                       ASC,
       CAMP_PROC_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_PROC
       ADD  ( PRIMARY KEY (SPI_ID, PROC_SEQ, CAMP_PROC_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_PROC_VAR (
       SPI_ID               NUMBER(8) NOT NULL,
       PROC_SEQ             NUMBER(6) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       CAMP_PROC_SEQ        NUMBER(6) NOT NULL,
       VAR_PARAM_VAL        VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_PROC_VAR ON SPI_PROC_VAR
(
       SPI_ID                         ASC,
       PROC_SEQ                       ASC,
       PARAM_SEQ                      ASC,
       CAMP_PROC_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_PROC_VAR
       ADD  ( PRIMARY KEY (SPI_ID, PROC_SEQ, PARAM_SEQ, CAMP_PROC_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_CAMP_PROC_VAR (
       SPI_ID               NUMBER(8) NOT NULL,
       CAMP_PROC_SEQ        NUMBER(6) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       VAR_PARAM_VAL        VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_CAMP_PROC_VAR ON SPI_CAMP_PROC_VAR
(
       SPI_ID                         ASC,
       CAMP_PROC_SEQ                  ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_CAMP_PROC_VAR
       ADD  ( PRIMARY KEY (SPI_ID, CAMP_PROC_SEQ, PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_AUDIT_DET (
       SPI_AUDIT_ID         NUMBER(8) NOT NULL,
       MESSAGE_SEQ          NUMBER(6) NOT NULL,
       MESSAGE_SEVER_ID     NUMBER(1) NOT NULL,
       SYSTEM_PROC_ID       NUMBER(8) NULL,
       MESSAGE_DATE         DATE NOT NULL,
       MESSAGE_TIME         CHAR(8) NOT NULL,
       MESSAGE_ID           NUMBER(8) NOT NULL,
       MESSAGE_VAR_COUNT    NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_AUDIT_DET ON SPI_AUDIT_DET
(
       SPI_AUDIT_ID                   ASC,
       MESSAGE_SEQ                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_AUDIT_DET
       ADD  ( PRIMARY KEY (SPI_AUDIT_ID, MESSAGE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_AUDIT_DET_VAR (
       SPI_AUDIT_ID         NUMBER(8) NOT NULL,
       MESSAGE_SEQ          NUMBER(6) NOT NULL,
       VAR_SEQ              NUMBER(2) NOT NULL,
       VAR_VAL              VARCHAR2(4000) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_AUDIT_DET_VAR ON SPI_AUDIT_DET_VAR
(
       SPI_AUDIT_ID                   ASC,
       MESSAGE_SEQ                    ASC,
       VAR_SEQ                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_AUDIT_DET_VAR
       ADD  ( PRIMARY KEY (SPI_AUDIT_ID, MESSAGE_SEQ, VAR_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PROC_AUDIT_DET (
       PROC_AUDIT_ID        NUMBER(8) NOT NULL,
       MESSAGE_SEQ          NUMBER(6) NOT NULL,
       MESSAGE_SEVER_ID     NUMBER(1) NOT NULL,
       SYSTEM_PROC_ID       NUMBER(8) NULL,
       MESSAGE_DATE         DATE NOT NULL,
       MESSAGE_TIME         CHAR(8) NOT NULL,
       MESSAGE_ID           NUMBER(8) NOT NULL,
       MESSAGE_VAR_COUNT    NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_AUDIT_DET ON PROC_AUDIT_DET
(
       PROC_AUDIT_ID                  ASC,
       MESSAGE_SEQ                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_AUDIT_DET
       ADD  ( PRIMARY KEY (PROC_AUDIT_ID, MESSAGE_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PROC_AUDIT_DET_VAR (
       PROC_AUDIT_ID        NUMBER(8) NOT NULL,
       MESSAGE_SEQ          NUMBER(6) NOT NULL,
       VAR_SEQ              NUMBER(2) NOT NULL,
       VAR_VAL              VARCHAR2(4000) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_AUDIT_DET_VAR ON PROC_AUDIT_DET_VAR
(
       PROC_AUDIT_ID                  ASC,
       MESSAGE_SEQ                    ASC,
       VAR_SEQ                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_AUDIT_DET_VAR
       ADD  ( PRIMARY KEY (PROC_AUDIT_ID, MESSAGE_SEQ, VAR_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_DET_RUN_HIST (
       CAMP_ID              NUMBER(8) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NOT NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       END_DATE             DATE NULL,
       END_TIME             CHAR(8) NULL,
       DIRECTION_TYPE       CHAR(1) NOT NULL,
       STATUS_SETTING_ID    NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_DET_RUN_HIST ON CAMP_DET_RUN_HIST
(
       CAMP_ID                        ASC,
       CAMP_CYC                       ASC,
       DET_ID                         ASC,
       RUN_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_DET_RUN_HIST
       ADD  ( PRIMARY KEY (CAMP_ID, CAMP_CYC, DET_ID, RUN_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PORTION_TYPE (
       PORTION_TYPE_ID      NUMBER NOT NULL,
       PORTION_NAME         VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPORTION_TYPE ON PORTION_TYPE
(
       PORTION_TYPE_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PORTION_TYPE
       ADD  ( PRIMARY KEY (PORTION_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into portion_type values (1, 'Information Portion');
insert into portion_type values (2, 'Message Portion');
COMMIT;


CREATE TABLE REM_ACTION_TYPE (
       REM_ACTION_TYPE_ID   NUMBER(1) NOT NULL,
       REM_ACTION_CHAR      CHAR(1) NOT NULL,
       REM_ACTION_DESC      VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKREM_ACTION_TYPE ON REM_ACTION_TYPE
(
       REM_ACTION_TYPE_ID             ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE REM_ACTION_TYPE
       ADD  ( PRIMARY KEY (REM_ACTION_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into rem_action_type values (1,'-','-');
COMMIT;


CREATE TABLE REM_CLIENT_HDR (
       REM_CLIENT_ID        NUMBER(8) NOT NULL,
       PROC_NAME            VARCHAR2(100) NULL,
       REM_ACTION_TYPE_ID   NUMBER(1) NULL,
       SYSTEM_PROC_ID       NUMBER(8) NULL,
       START_DATE           DATE NULL,
       START_TIME           CHAR(8) NULL,
       END_DATE             DATE NULL,
       END_TIME             CHAR(8) NULL,
       STATUS_SETTING_ID    NUMBER(2) NULL,
       C_TO_S_INFO          VARCHAR2(2000) NULL,
       S_TO_C_INFO          VARCHAR2(2000) NULL,
       PARAM_COUNT          NUMBER(2) NULL,
       VIEW_ID              VARCHAR2(30) NULL,
       USER_ID              VARCHAR2(30) NULL,
       ERROR_TEXT           VARCHAR2(2000) NULL,
       MESSAGE_COUNT        NUMBER(4) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKREM_CLIENT_HDR ON REM_CLIENT_HDR
(
       REM_CLIENT_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE REM_CLIENT_HDR
       ADD  ( PRIMARY KEY (REM_CLIENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE REM_CLIENT_DET (
       REM_CLIENT_ID        NUMBER(8) NOT NULL,
       PORTION_SEQ          NUMBER(6) NOT NULL,
       C_TO_S_PORTION       VARCHAR2(200) NULL,
       S_TO_C_PORTION       VARCHAR2(200) NULL,
       PORTION_TYPE_ID      NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKREM_CLIENT_DET ON REM_CLIENT_DET
(
       REM_CLIENT_ID                  ASC,
       PORTION_SEQ                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE REM_CLIENT_DET
       ADD  ( PRIMARY KEY (REM_CLIENT_ID, PORTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SPI_AUDIT_PARAM (
       SPI_AUDIT_ID         NUMBER(8) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       PARAM_VAL            VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSPI_AUDIT_PARAM ON SPI_AUDIT_PARAM
(
       SPI_AUDIT_ID                   ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SPI_AUDIT_PARAM
       ADD  ( PRIMARY KEY (SPI_AUDIT_ID, PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PROC_AUDIT_PARAM (
       PROC_AUDIT_ID        NUMBER(8) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       PARAM_VAL            VARCHAR2(300) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_AUDIT_PARAM ON PROC_AUDIT_PARAM
(
       PROC_AUDIT_ID                  ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_AUDIT_PARAM
       ADD  ( PRIMARY KEY (PROC_AUDIT_ID, PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE VANTAGE_DYN_TAB (
       VIEW_ID              VARCHAR2(30) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       VANTAGE_NAME         VARCHAR2(100) NULL,
       CUST_TAB_GRP_ID      NUMBER(2) NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       VANTAGE_TYPE         NUMBER(1) NULL,
       ALT_JOIN_SRC         VARCHAR2(128) NULL,
       DB_ENT_NAME          VARCHAR2(128) NOT NULL,
       DB_ENT_OWNER         VARCHAR2(128) NOT NULL,
       DB_VIEW_BASE_TAB     VARCHAR2(257) NULL,
       DB_REMOTE_STRING     VARCHAR2(128) NULL,
       STD_JOIN_FLG         NUMBER(1) NOT NULL,
       STD_JOIN_FROM_COL    VARCHAR2(128) NOT NULL,
       STD_JOIN_TO_COL      VARCHAR2(128) NOT NULL,
       PAR_VANTAGE_ALIAS    VARCHAR2(128) NOT NULL,
       COL_DISPLAY          VARCHAR2(300) NULL,
       DISPLAY_FLG          NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKVANTAGE_DYN_TAB ON VANTAGE_DYN_TAB
(
       VIEW_ID                        ASC,
       VANTAGE_ALIAS                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE VANTAGE_DYN_TAB
       ADD  ( PRIMARY KEY (VIEW_ID, VANTAGE_ALIAS)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE TV_REGION (
       TV_REGION_ID         NUMBER(4) NOT NULL,
       TV_REGION_NAME       VARCHAR2(50) NOT NULL,
       TV_REGION_DESC       VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTV_REGION ON TV_REGION
(
       TV_REGION_ID                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TV_REGION
       ADD  ( PRIMARY KEY (TV_REGION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE LOOKUP_TAB_GRP (
       LOOKUP_TAB_GRP_ID           NUMBER(4) NOT NULL,
       LOOKUP_TAB_GRP_NAME         VARCHAR2(100) NOT NULL,
       LOOKUP_TAB_GRP_DESC         VARCHAR2(300),
       VIEW_ID                     VARCHAR2(30) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLOOKUP_TAB_GRP ON LOOKUP_TAB_GRP
(
       LOOKUP_TAB_GRP_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LOOKUP_TAB_GRP
       ADD  ( PRIMARY KEY (LOOKUP_TAB_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE LOOKUP_TAB_HDR (
       LOOKUP_TAB_ID        NUMBER(6) NOT NULL,
       LOOKUP_TAB_NAME      VARCHAR2(100) NOT NULL,
       UPDATED_DATE         DATE NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       ASS_VANTAGE_ALIAS    VARCHAR2(128) NOT NULL,
       ASS_COL              VARCHAR2(128) NOT NULL,
       DYN_TAB_NAME         VARCHAR2(30) NOT NULL,
       LOOKUP_TAB_GRP_ID    NUMBER(4) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKLOOKUP_TAB_HDR ON LOOKUP_TAB_HDR
(
       LOOKUP_TAB_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE LOOKUP_TAB_HDR
       ADD  ( PRIMARY KEY (LOOKUP_TAB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DATA_REP_SRC (
       DATA_REP_ID          NUMBER(6) NOT NULL,
       SRC_TYPE_ID          NUMBER(3) NOT NULL,
       SRC_ID               NUMBER(8) NOT NULL,
       SRC_SUB_ID           NUMBER(6) NOT NULL,
       SRC_NAME             VARCHAR2(100) NULL,
       SRC_SUB_NAME         VARCHAR2(100) NULL,
       LAST_RUN_DATE        DATE NULL,
       LAST_RUN_TIME        CHAR(8) NULL,
       LAST_RUN_BY          VARCHAR2(30) NULL,
       LAST_RUN_DUR         NUMBER(8) NULL,
       DYN_TAB_NAME         VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATA_REP_SRC ON DATA_REP_SRC
(
       DATA_REP_ID                    ASC,
       SRC_TYPE_ID                    ASC,
       SRC_ID                         ASC,
       SRC_SUB_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATA_REP_SRC
       ADD  ( PRIMARY KEY (DATA_REP_ID, SRC_TYPE_ID, SRC_ID, 
              SRC_SUB_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEG_DEDUPE_PRIO (
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       SEG_ID               NUMBER(8) NOT NULL,
       SEQ_NUMBER           NUMBER(4) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       DEDUPE_PRIO_HIGH     NUMBER(1) NOT NULL,
       NULLS_PRIO_HIGH      NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEG_DEDUPE_PRIO ON SEG_DEDUPE_PRIO
(
       SEG_TYPE_ID                    ASC,
       SEG_ID                         ASC,
       SEQ_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEG_DEDUPE_PRIO
       ADD  ( PRIMARY KEY (SEG_TYPE_ID, SEG_ID, SEQ_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_PLAN (
       CAMP_ID              NUMBER(8) NOT NULL,
       PLAN_START_DATE      DATE NULL,
       PLAN_END_DATE        DATE NULL,
       PLAN_CHAN_TYPE_ID    NUMBER(4) NULL,
       PLAN_QTY             NUMBER(12) NULL,
       PLAN_RES_RATE        NUMBER(4,2) NULL,
       PLAN_EXPENSES        NUMBER(12,3) NULL,
       PLAN_REVENUE         NUMBER(12,3) NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_PLAN ON CAMP_PLAN
(
       CAMP_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_PLAN
       ADD  ( PRIMARY KEY (CAMP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEG_SQL (
       SEG_ID               NUMBER(8) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NOT NULL,
       GENERATED_SQL        CLOB NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEG_SQL ON SEG_SQL
(
       SEG_ID                         ASC,
       SEG_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEG_SQL
       ADD  ( PRIMARY KEY (SEG_ID, SEG_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE PROC_PARAM (
       PROC_NAME            VARCHAR2(100) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       PARAM_NAME           VARCHAR2(100) NOT NULL,
       STANDARD_VAL         VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKPROC_PARAM ON PROC_PARAM
(
       PROC_NAME                      ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE PROC_PARAM
       ADD  ( PRIMARY KEY (PROC_NAME, PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into proc_param values ('Campaign Communication',0,'Server executable name','v_campaign_commproc');
insert into proc_param values ('Campaign Communication',1,'Call Type','S');
insert into proc_param values ('Campaign Communication',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Campaign Communication',3,'Process Audit Id',null );
insert into proc_param values ('Campaign Communication',4,'Secure Database Account Name',null );
insert into proc_param values ('Campaign Communication',5,'Secure Database Password',null );
insert into proc_param values ('Campaign Communication',6,'Customer Data View Id',null );
insert into proc_param values ('Campaign Communication',7,'User Id',null );
insert into proc_param values ('Campaign Communication',8,'Database Vendor Id',null );
insert into proc_param values ('Campaign Communication',9,'Database Connection String',null );
insert into proc_param values ('Campaign Communication',10,'Language Id',null );
insert into proc_param values ('Campaign Communication',11,'SPI Id',null );
insert into proc_param values ('Campaign Communication',12,'Campaign Id',null );
insert into proc_param values ('Campaign Communication',13,'Campaign Cycle Number',null );
insert into proc_param values ('Campaign Communication',14,'Detail Id',null );
insert into proc_param values ('Campaign Communication',15,'Run Number',null );
insert into proc_param values ('Campaign Communication',16,'Parent Communication Detail Id',null );
insert into proc_param values ('Campaign Communication',17,'Segment Id',null );
insert into proc_param values ('Campaign Communication',18,'Tree Sequence Number',null );
insert into proc_param values ('Campaign Communication',19,'Response Criteria Id',null );
insert into proc_param values ('Campaign Communication',20,'Response Criteria Type Id',null );
insert into proc_param values ('Campaign Communication',21,'Response Channel Id',null );
insert into proc_param values ('Campaign Communication',22,'Response Stream Id',null );
insert into proc_param values ('Campaign Communication',23,'Response Model Id',null );
insert into proc_param values ('Data Analysis Tree',0,'Server executable name','v_dataanalysisproc');
insert into proc_param values ('Data Analysis Tree',1,'Call Type',null );
insert into proc_param values ('Data Analysis Tree',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data Analysis Tree',3,'Process Audit Id',null );
insert into proc_param values ('Data Analysis Tree',4,'Secure Database Account Name',null );
insert into proc_param values ('Data Analysis Tree',5,'Secure Database Password',null );
insert into proc_param values ('Data Analysis Tree',6,'Customer Data View Id',null );
insert into proc_param values ('Data Analysis Tree',7,'User Id',null );
insert into proc_param values ('Data Analysis Tree',8,'Database Vendor Id',null );
insert into proc_param values ('Data Analysis Tree',9,'Database Connection String',null );
insert into proc_param values ('Data Analysis Tree',10,'Language Id',null );
insert into proc_param values ('Data Analysis Tree',11,'Data Rep Id',null );
insert into proc_param values ('Data Analysis Tree',12,'Source Type',null );
insert into proc_param values ('Data Analysis Tree',13,'Source Id',null );
insert into proc_param values ('Data Analysis Tree',14,'Tree Sub-Source Id',null );
insert into proc_param values ('Data Analysis',0,'Server executable name','v_dataanalysisproc');
insert into proc_param values ('Data Analysis',1,'Call Type',null );
insert into proc_param values ('Data Analysis',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data Analysis',3,'Process Audit Id',null );
insert into proc_param values ('Data Analysis',4,'Secure Database Account Name',null );
insert into proc_param values ('Data Analysis',5,'Secure Database Password',null );
insert into proc_param values ('Data Analysis',6,'Customer Data View Id',null );
insert into proc_param values ('Data Analysis',7,'User Id',null );
insert into proc_param values ('Data Analysis',8,'Database Vendor Id',null );
insert into proc_param values ('Data Analysis',9,'Database Connection String',null );
insert into proc_param values ('Data Analysis',10,'Language Id',null );
insert into proc_param values ('Data Analysis',11,'Data Rep Id',null );
insert into proc_param values ('Data Analysis',12,'Source Type',null );
insert into proc_param values ('Data Analysis',13,'Source Id',null );
insert into proc_param values ('Data Categorisation Header',0,'Server executable name','v_data_catproc');
insert into proc_param values ('Data Categorisation Header',1,'Call Type',null );
insert into proc_param values ('Data Categorisation Header',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data Categorisation Header',3,'Process Audit Id',null );
insert into proc_param values ('Data Categorisation Header',4,'Secure Database Account Name',null );
insert into proc_param values ('Data Categorisation Header',5,'Secure Database Password',null );
insert into proc_param values ('Data Categorisation Header',6,'Customer Data View Id',null );
insert into proc_param values ('Data Categorisation Header',7,'User Id',null );
insert into proc_param values ('Data Categorisation Header',8,'Database Vendor Id',null );
insert into proc_param values ('Data Categorisation Header',9,'Database Connection String',null );
insert into proc_param values ('Data Categorisation Header',10,'Language Id',null );
insert into proc_param values ('Data Categorisation Header',11,'Categorisation Type',null );
insert into proc_param values ('Data Categorisation Header',12,'Target Table Name',null );
insert into proc_param values ('Data Categorisation Header',13,'Target Column Name',null );
insert into proc_param values ('Data Categorisation Header',14,'Drop Status',null );
insert into proc_param values ('Data Categorisation Header',15,'Header Record Flag',null );
insert into proc_param values ('Data Categorisation',0,'Server executable name','v_data_catproc');
insert into proc_param values ('Data Categorisation',1,'Call Type',null );
insert into proc_param values ('Data Categorisation',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data Categorisation',3,'Process Audit Id',null );
insert into proc_param values ('Data Categorisation',4,'Secure Database Account Name',null );
insert into proc_param values ('Data Categorisation',5,'Secure Database Password',null );
insert into proc_param values ('Data Categorisation',6,'Customer Data View Id',null );
insert into proc_param values ('Data Categorisation',7,'User Id',null );
insert into proc_param values ('Data Categorisation',8,'Database Vendor Id',null );
insert into proc_param values ('Data Categorisation',9,'Database Connection String',null );
insert into proc_param values ('Data Categorisation',10,'Language Id',null );
insert into proc_param values ('Data Categorisation',11,'Categorisation Type',null );
insert into proc_param values ('Data Categorisation',12,'Target Table Name',null );
insert into proc_param values ('Data Categorisation',13,'Target Column Name',null );
insert into proc_param values ('Data Categorisation',14,'Drop Status',null );
insert into proc_param values ('Data View Tree',0,'Server executable name','v_data_viewproc');
insert into proc_param values ('Data View Tree',1,'Call Type',null );
insert into proc_param values ('Data View Tree',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data View Tree',3,'Process Audit Id',null );
insert into proc_param values ('Data View Tree',4,'Secure Database Account Name',null );
insert into proc_param values ('Data View Tree',5,'Secure Database Password',null );
insert into proc_param values ('Data View Tree',6,'Customer Data View Id',null );
insert into proc_param values ('Data View Tree',7,'User Id',null );
insert into proc_param values ('Data View Tree',8,'Database Vendor Id',null );
insert into proc_param values ('Data View Tree',9,'Database Connection String',null );
insert into proc_param values ('Data View Tree',10,'Language Id',null );
insert into proc_param values ('Data View Tree',11,'Data View Id',null );
insert into proc_param values ('Data View Tree',12,'Source Type',null );
insert into proc_param values ('Data View Tree',13,'Source Id',null );
insert into proc_param values ('Data View Tree',14,'Tree Sub-Source Id',null );
insert into proc_param values ('Data View',0,'Server executable name','v_data_viewproc');
insert into proc_param values ('Data View',1,'Call Type',null );
insert into proc_param values ('Data View',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Data View',3,'Process Audit Id',null );
insert into proc_param values ('Data View',4,'Secure Database Account Name',null );
insert into proc_param values ('Data View',5,'Secure Database Password',null );
insert into proc_param values ('Data View',6,'Customer Data View Id',null );
insert into proc_param values ('Data View',7,'User Id',null );
insert into proc_param values ('Data View',8,'Database Vendor Id',null );
insert into proc_param values ('Data View',9,'Database Connection String',null );
insert into proc_param values ('Data View',10,'Language Id',null );
insert into proc_param values ('Data View',11,'Data View Id',null );
insert into proc_param values ('Data View',12,'Source Type',null );
insert into proc_param values ('Data View',13,'Source Id',null );
insert into proc_param values ('Derived Value Tree',0,'Server executable name','v_derived_valueproc');
insert into proc_param values ('Derived Value Tree',1,'Call Type',null );
insert into proc_param values ('Derived Value Tree',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Derived Value Tree',3,'Process Audit Id',null );
insert into proc_param values ('Derived Value Tree',4,'Secure Database Account Name',null );
insert into proc_param values ('Derived Value Tree',5,'Secure Database Password',null );
insert into proc_param values ('Derived Value Tree',6,'Customer Data View Id',null );
insert into proc_param values ('Derived Value Tree',7,'User Id',null );
insert into proc_param values ('Derived Value Tree',8,'Database Vendor Id',null );
insert into proc_param values ('Derived Value Tree',9,'Database Connection String',null );
insert into proc_param values ('Derived Value Tree',10,'Language Id',null );
insert into proc_param values ('Derived Value Tree',11,'Derived Value Id',null );
insert into proc_param values ('Derived Value Tree',12,'Source Type',null );
insert into proc_param values ('Derived Value Tree',13,'Source Id',null );
insert into proc_param values ('Derived Value Tree',14,'Tree Sub-Source Id',null );
insert into proc_param values ('Derived Value Tree',15,'Processing Mode',null );
insert into proc_param values ('Derived Value',0,'Server executable name','v_derived_valueproc');
insert into proc_param values ('Derived Value',1,'Call Type',null );
insert into proc_param values ('Derived Value',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Derived Value',3,'Process Audit Id',null );
insert into proc_param values ('Derived Value',4,'Secure Database Account Name',null );
insert into proc_param values ('Derived Value',5,'Secure Database Password',null );
insert into proc_param values ('Derived Value',6,'Customer Data View Id',null );
insert into proc_param values ('Derived Value',7,'User Id',null );
insert into proc_param values ('Derived Value',8,'Database Vendor Id',null );
insert into proc_param values ('Derived Value',9,'Database Connection String',null );
insert into proc_param values ('Derived Value',10,'Language Id',null );
insert into proc_param values ('Derived Value',11,'Derived Value Id',null );
insert into proc_param values ('Derived Value',12,'Source Type',null );
insert into proc_param values ('Derived Value',13,'Source Id',null );
insert into proc_param values ('Derived Value',14,'Processing Mode',null );
insert into proc_param values ('Email Delivery',0,'Server executable name','v_emaildelivery_proc');
insert into proc_param values ('Email Delivery',1,'Call Type','S');
insert into proc_param values ('Email Delivery',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Email Delivery',3,'Process Audit Id',null );
insert into proc_param values ('Email Delivery',4,'Secure Database Account Name',null );
insert into proc_param values ('Email Delivery',5,'Secure Database Password',null );
insert into proc_param values ('Email Delivery',6,'Customer Data View Id',null );
insert into proc_param values ('Email Delivery',7,'User Id',null );
insert into proc_param values ('Email Delivery',8,'Database Vendor Id',null );
insert into proc_param values ('Email Delivery',9,'Database Connection String',null );
insert into proc_param values ('Email Delivery',10,'Language Id',null );
insert into proc_param values ('Email Delivery',11,'Campaign Id',null );
insert into proc_param values ('Email Delivery',12,'Campaign Output Group Id',null );
insert into proc_param values ('Email Delivery',13,'Campaign Output Detail Id',null );
insert into proc_param values ('Email Delivery',14,'Split Sequence',null );
insert into proc_param values ('Email Delivery',15,'Campaign Cycle Number',null ) ;
insert into proc_param values ('Email Delivery',16,'Run Number',null );
insert into proc_param values ('Inbound Email',0,'Server executable name','v_inechannelproc');
insert into proc_param values ('Inbound Email',1,'Call Type','S');
insert into proc_param values ('Inbound Email',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Inbound Email',3,'Process Audit Id',null );
insert into proc_param values ('Inbound Email',4,'Secure Database Account Name',null );
insert into proc_param values ('Inbound Email',5,'Secure Database Password',null );
insert into proc_param values ('Inbound Email',6,'Customer Data View Id',null );
insert into proc_param values ('Inbound Email',7,'User Id',null );
insert into proc_param values ('Inbound Email',8,'Database Vendor Id',null );
insert into proc_param values ('Inbound Email',9,'Database Connection String',null );
insert into proc_param values ('Inbound Email',10,'Language Id',null );
insert into proc_param values ('Inbound Email',11,'Server Id',null );
insert into proc_param values ('Inbound Email',12,'Mail Box Id',null );
insert into proc_param values ('Outputs',0,'Server executable name','v_outputproc');
insert into proc_param values ('Outputs',1,'Call Type','S');
insert into proc_param values ('Outputs',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Outputs',3,'Process Audit Id',null );
insert into proc_param values ('Outputs',4,'Secure Database Account Name',null );
insert into proc_param values ('Outputs',5,'Secure Database Password',null );
insert into proc_param values ('Outputs',6,'Customer Data View Id',null );
insert into proc_param values ('Outputs',7,'User Id',null );
insert into proc_param values ('Outputs',8,'Database Vendor Id',null );
insert into proc_param values ('Outputs',9,'Database Connection String',null );
insert into proc_param values ('Outputs',10,'Language Id',null );
insert into proc_param values ('Outputs',11,'Campaign Id',null );
insert into proc_param values ('Outputs',12,'Campaign Output Group Id',null );
insert into proc_param values ('Scheduled Process Initiator',0,'Server executable name','v_spiproc');
insert into proc_param values ('Scheduled Process Initiator',1,'Call Type','S');
insert into proc_param values ('Scheduled Process Initiator',2,'RPC Id / SPI Audit Id','1');
insert into proc_param values ('Scheduled Process Initiator',3,'Process Audit Id','0');
insert into proc_param values ('Scheduled Process Initiator',4,'Secure Database Account Name',null );
insert into proc_param values ('Scheduled Process Initiator',5,'Secure Database Password',null );
insert into proc_param values ('Scheduled Process Initiator',6,'Customer Data View Id',null );
insert into proc_param values ('Scheduled Process Initiator',7,'User Id',null );
insert into proc_param values ('Scheduled Process Initiator',8,'Database Vendor Id',null );
insert into proc_param values ('Scheduled Process Initiator',9,'Database Connection String',null );
insert into proc_param values ('Scheduled Process Initiator',10,'Language Id',null );
insert into proc_param values ('Scheduled Process Initiator',11,'SPI Id','0');
insert into proc_param values ('Scheduled Process Initiator',12,'SPI Type Id','3');
insert into proc_param values ('Scheduled Process Manager',0,'Server executable name','v_spmproc');
insert into proc_param values ('Scheduled Process Manager',1,'Call Type','R');
insert into proc_param values ('Scheduled Process Manager',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Scheduled Process Manager',3,'Process Audit Id',null );
insert into proc_param values ('Scheduled Process Manager',4,'Secure Database Account Name',null );
insert into proc_param values ('Scheduled Process Manager',5,'Secure Database Password',null );
insert into proc_param values ('Scheduled Process Manager',6,'Customer Data View Id',null );
insert into proc_param values ('Scheduled Process Manager',7,'User Id',null );
insert into proc_param values ('Scheduled Process Manager',8,'Database Vendor Id',null );
insert into proc_param values ('Scheduled Process Manager',9,'Database Connection String',null );
insert into proc_param values ('Scheduled Process Manager',10,'Language Id',null );
insert into proc_param values ('Scheduled Process Manager',11,'SPI Id',null );
insert into proc_param values ('Scheduled Process Manager',12,'SPI Type Id',null );
insert into proc_param values ('Score Model Tree',0,'Server executable name','v_scoreproc');
insert into proc_param values ('Score Model Tree',1,'Call Type',null );
insert into proc_param values ('Score Model Tree',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Score Model Tree',3,'Process Audit Id',null );
insert into proc_param values ('Score Model Tree',4,'Secure Database Account Name',null );
insert into proc_param values ('Score Model Tree',5,'Secure Database Password',null );
insert into proc_param values ('Score Model Tree',6,'Customer Data View Id',null );
insert into proc_param values ('Score Model Tree',7,'User Id',null );
insert into proc_param values ('Score Model Tree',8,'Database Vendor Id',null );
insert into proc_param values ('Score Model Tree',9,'Database Connection String',null );
insert into proc_param values ('Score Model Tree',10,'Language Id',null );
insert into proc_param values ('Score Model Tree',11,'Score Model Id',null );
insert into proc_param values ('Score Model Tree',12,'Source Type',null );
insert into proc_param values ('Score Model Tree',13,'Source Id',null );
insert into proc_param values ('Score Model Tree',14,'Tree Sub-Source Id',null );
insert into proc_param values ('Score Model',0,'Server executable name','v_scoreproc');
insert into proc_param values ('Score Model',1,'Call Type',null );
insert into proc_param values ('Score Model',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Score Model',3,'Process Audit Id',null );
insert into proc_param values ('Score Model',4,'Secure Database Account Name',null );
insert into proc_param values ('Score Model',5,'Secure Database Password',null );
insert into proc_param values ('Score Model',6,'Customer Data View Id',null );
insert into proc_param values ('Score Model',7,'User Id',null );
insert into proc_param values ('Score Model',8,'Database Vendor Id',null );
insert into proc_param values ('Score Model',9,'Database Connection String',null );
insert into proc_param values ('Score Model',10,'Language Id',null );
insert into proc_param values ('Score Model',11,'Score Model Id',null );
insert into proc_param values ('Score Model',12,'Source Type',null );
insert into proc_param values ('Score Model',13,'Source Id',null );
insert into proc_param values ('Segment Processor',0,'Server executable name','v_segproc');
insert into proc_param values ('Segment Processor',1,'Call Type',null );
insert into proc_param values ('Segment Processor',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Segment Processor',3,'Process Audit Id',null );
insert into proc_param values ('Segment Processor',4,'Secure Database Account Name',null );
insert into proc_param values ('Segment Processor',5,'Secure Database Password',null );
insert into proc_param values ('Segment Processor',6,'Customer Data View Id',null );
insert into proc_param values ('Segment Processor',7,'User Id',null );
insert into proc_param values ('Segment Processor',8,'Database Vendor Id',null );
insert into proc_param values ('Segment Processor',9,'Database Connection String',null );
insert into proc_param values ('Segment Processor',10,'Language Id',null );
insert into proc_param values ('Segment Processor',11,'Segment Id',null );
insert into proc_param values ('Segment Processor',12,'Segment Type',null );
insert into proc_param values ('Segment Processor',13,'Processing Mode',null );
insert into proc_param values ('Segment Processor Campaign',0,'Server executable name','v_segproc');
insert into proc_param values ('Segment Processor Campaign',1,'Call Type',null );
insert into proc_param values ('Segment Processor Campaign',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Segment Processor Campaign',3,'Process Audit Id',null );
insert into proc_param values ('Segment Processor Campaign',4,'Secure Database Account Name',null );
insert into proc_param values ('Segment Processor Campaign',5,'Secure Database Password',null );
insert into proc_param values ('Segment Processor Campaign',6,'Customer Data View Id',null );
insert into proc_param values ('Segment Processor Campaign',7,'User Id',null );
insert into proc_param values ('Segment Processor Campaign',8,'Database Vendor Id',null );
insert into proc_param values ('Segment Processor Campaign',9,'Database Connection String',null );
insert into proc_param values ('Segment Processor Campaign',10,'Language Id',null );
insert into proc_param values ('Segment Processor Campaign',11,'Segment Id',null );
insert into proc_param values ('Segment Processor Campaign',12,'Segment Type',null );
insert into proc_param values ('Segment Processor Campaign',13,'Processing Mode',null );
insert into proc_param values ('Segment Processor Campaign',14,'Dynamic CS Table Name',null );
insert into proc_param values ('Segment Processor Campaign',15,'Campaign Process Sequence',null );
insert into proc_param values ('Segment Processor Campaign',16,'Tree Sequence Number', null);
insert into proc_param values ('Segment Processor Campaign',17,'Dynamic Segment Flag', null);
insert into proc_param values ('Segmentation Manager',0,'Server executable name','v_segment_manproc');
insert into proc_param values ('Segmentation Manager',1,'Call Type',null );
insert into proc_param values ('Segmentation Manager',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Segmentation Manager',3,'Process Audit Id',null );
insert into proc_param values ('Segmentation Manager',4,'Secure Database Account Name',null );
insert into proc_param values ('Segmentation Manager',5,'Secure Database Password',null );
insert into proc_param values ('Segmentation Manager',6,'Customer Data View Id',null );
insert into proc_param values ('Segmentation Manager',7,'User Id',null );
insert into proc_param values ('Segmentation Manager',8,'Database Vendor Id',null );
insert into proc_param values ('Segmentation Manager',9,'Database Connection String',null );
insert into proc_param values ('Segmentation Manager',10,'Language Id',null );
insert into proc_param values ('Segmentation Manager',11,'Tree Segment Id',null );
insert into proc_param values ('Lookup Tables', 0,'Server executable name', 'v_lookup_tablesproc');
insert into proc_param values ('Lookup Tables', 1, 'Call Type', null );
insert into proc_param values ('Lookup Tables', 2, 'RPC Id / SPI Audit Id', null );
insert into proc_param values ('Lookup Tables', 3, 'Process Audit Id', null );
insert into proc_param values ('Lookup Tables', 4, 'Secure Database Account Name', null );
insert into proc_param values ('Lookup Tables', 5, 'Secure Database Password', null );
insert into proc_param values ('Lookup Tables', 6, 'Customer Data View Id', null );
insert into proc_param values ('Lookup Tables', 7, 'User Id', null );
insert into proc_param values ('Lookup Tables', 8, 'Database Vendor Id', null );
insert into proc_param values ('Lookup Tables', 9, 'Database Connection String', null );
insert into proc_param values ('Lookup Tables',10, 'Language Id', null );
insert into proc_param values ('Lookup Tables',11, 'Lookup Tables Id', null );
insert into proc_param values ('Lookup Tables',12, 'Vantage Alias', null );
insert into proc_param values ('Lookup Tables',13, 'Column Name', null );
insert into proc_param values ('Seed Lists', 0, 'Server executable name', 'v_seedlistsproc');
insert into proc_param values ('Seed Lists', 1, 'Call Type', null );
insert into proc_param values ('Seed Lists', 2, 'RPC Id / SPI Audit Id', null );
insert into proc_param values ('Seed Lists', 3, 'Process Audit Id', null );
insert into proc_param values ('Seed Lists', 4, 'Secure Database Account Name', null );
insert into proc_param values ('Seed Lists', 5, 'Secure Database Password', null );
insert into proc_param values ('Seed Lists', 6, 'Customer Data View Id', null );
insert into proc_param values ('Seed Lists', 7, 'User Id', null );
insert into proc_param values ('Seed Lists', 8,  'Database Vendor Id', null );
insert into proc_param values ('Seed Lists', 9, 'Database Connection String', null );
insert into proc_param values ('Seed Lists', 10, 'Language Id', null );
insert into proc_param values ('Seed Lists', 11, 'Seed List Id', null );
insert into proc_param values ('SMS Delivery', 0, 'Server executable name', 'v_sms_proc');
insert into proc_param values ('SMS Delivery', 1, 'Call Type', 'S' );
insert into proc_param values ('SMS Delivery', 2, 'RPC Id / SPI Audit Id', null );
insert into proc_param values ('SMS Delivery', 3, 'Process Audit Id', null );
insert into proc_param values ('SMS Delivery', 4, 'Secure Database Account Name', null );
insert into proc_param values ('SMS Delivery', 5, 'Secure Database Password', null );
insert into proc_param values ('SMS Delivery', 6, 'Customer Data View Id', null );
insert into proc_param values ('SMS Delivery', 7, 'User Id', null );
insert into proc_param values ('SMS Delivery', 8, 'Database Vendor Id', null );
insert into proc_param values ('SMS Delivery', 9, 'Database Connection String', null );
insert into proc_param values ('SMS Delivery', 10, 'Language Id', null );
insert into proc_param values ('SMS Delivery', 11, 'Campaign Id', null );
insert into proc_param values ('SMS Delivery', 12, 'Campaign Output Group Id', null );
insert into proc_param values ('SMS Delivery', 13, 'Campaign Output Detail Id', null );
insert into proc_param values ('SMS Delivery', 14, 'Split Sequence', null );
insert into proc_param values ('SMS Delivery', 15, 'Campaign Cycle Number', null );
insert into proc_param values ('SMS Delivery', 16, 'Run Number', null );
insert into proc_param values ('SMS Delivery', 17, 'Parent Communication Detail Id', null);
insert into proc_param values ('Test Treatment', 0, 'Server executable name', 'v_treatmenttest_proc');
insert into proc_param values ('Test Treatment', 1, 'Call Type', 'S' );
insert into proc_param values ('Test Treatment', 2, 'RPC Id / SPI Audit Id', null );
insert into proc_param values ('Test Treatment', 3, 'Process Audit Id', null );
insert into proc_param values ('Test Treatment', 4, 'Secure Database Account Name', null );
insert into proc_param values ('Test Treatment', 5, 'Secure Database Password', null );
insert into proc_param values ('Test Treatment', 6, 'Customer Data View Id', null );
insert into proc_param values ('Test Treatment', 7, 'User Id', null );
insert into proc_param values ('Test Treatment', 8, 'Database Vendor Id', null );
insert into proc_param values ('Test Treatment', 9, 'Database Connection String', null );
insert into proc_param values ('Test Treatment', 10, 'Language Id', null );
insert into proc_param values ('Test Treatment', 11, 'Treatment Type Id', null );
insert into proc_param values ('Test Treatment', 12, 'Treatment Id', null );
insert into proc_param values ('Lock Angel',0, 'Server executable name', 'v_lpangelproc');
insert into proc_param values ('Lock Angel',1, 'Connection String', null);
insert into proc_param values ('Lock Angel',2, 'Database Vendor Id', null);
insert into proc_param values ('Lock Angel',3, 'Run Flag', null);
insert into proc_param values ('Connection Pool', 0, 'Server executable name', 'v_cpangelproc');
insert into proc_param values ('Connection Pool', 1, 'Connection String', null);
insert into proc_param values ('Connection Pool', 2, 'Run Flag', null);
insert into proc_param values ('Java Activator',0, 'Server executable name', 'v_jaangelproc');
insert into proc_param values ('Java Activator',1, 'Connection String', null);
insert into proc_param values ('Java Activator',2, 'Database Vendor Id', null);
insert into proc_param values ('Java Activator',3, 'Run Flag', null);
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
insert into proc_param values ('Inbound Wireless',0,'Server executable name','v_inbound_wirelessproc.bat');
insert into proc_param values ('Inbound Wireless',1,'Call Type','S');
insert into proc_param values ('Inbound Wireless',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Inbound Wireless',3,'Process Audit Id',null );
insert into proc_param values ('Inbound Wireless',4,'Secure Database Account Name',null );
insert into proc_param values ('Inbound Wireless',5,'Secure Database Password',null );
insert into proc_param values ('Inbound Wireless',6,'Customer Data View Id',null );
insert into proc_param values ('Inbound Wireless',7,'User Id',null );
insert into proc_param values ('Inbound Wireless',8,'Database Vendor Id',null );
insert into proc_param values ('Inbound Wireless',9,'Database Connection String',null );
insert into proc_param values ('Inbound Wireless',10,'Language Id',null );
insert into proc_param values ('Inbound Wireless',11,'Server Id',null );
insert into proc_param values ('Inbound Wireless',12,'Inbox Id',null );
insert into proc_param values ('Decision Processor',0,'Server executable name','v_decisionproc');
insert into proc_param values ('Decision Processor',1,'Call Type',null );
insert into proc_param values ('Decision Processor',2,'RPC Id / SPI Audit Id',null );
insert into proc_param values ('Decision Processor',3,'Process Audit Id',null );
insert into proc_param values ('Decision Processor',4,'Secure Database Account Name',null );
insert into proc_param values ('Decision Processor',5,'Secure Database Password',null );
insert into proc_param values ('Decision Processor',6,'Customer Data View Id',null );
insert into proc_param values ('Decision Processor',7,'User Id',null );
insert into proc_param values ('Decision Processor',8,'Database Vendor Id',null );
insert into proc_param values ('Decision Processor',9,'Database Connection String',null );
insert into proc_param values ('Decision Processor',10,'Language Id',null );
insert into proc_param values ('Decision Processor',11,'Score Model Id',null );
insert into proc_param values ('Decision Processor',12,'Source Type',null );
insert into proc_param values ('Decision Processor',13,'Source Id',null );
insert into proc_param values ('Decision Processor',14,'Tree Sub-Source Id',null );
insert into proc_param values ('Decision Processor',15,'Decision Logic Operation',null );
insert into proc_param values ('Decision Processor',16,'Decision Batch Id', null);
insert into proc_param values ('Migration Batch',0,'Server Script', 'RunMigration.cmd');
insert into proc_param values ('Migration Batch',1,'User Id', null);
insert into proc_param values ('Migration Batch',2,'Connection', null);
insert into proc_param values ('Migration Batch',3,'Database Vendor', null);
insert into proc_param values ('Migration Batch',4,'Process audit ID', null);
insert into proc_param values ('Migration Batch',5,'Command Name', null);
insert into proc_param values ('Migration Batch',6,'Import or Export ID', null);
insert into proc_param values ('Migration Batch',7,'Debug', 'd');

COMMIT;



CREATE TABLE SCORE_EXTERNAL (
       SCORE_ID             NUMBER(8) NOT NULL,
       MODEL_COMMAND        VARCHAR2(500) NOT NULL,
       EXT_TEMPL_ID         NUMBER(8) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSCORE_EXTERNAL ON SCORE_EXTERNAL
(
       SCORE_ID                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SCORE_EXTERNAL
       ADD  ( PRIMARY KEY (SCORE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE EMPTY_CYC_TYPE (
       EMPTY_CYC_TYPE_ID    NUMBER(1) NOT NULL,
       EMPTY_CYC_NAME       VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEMPTY_CYC_TYPE ON EMPTY_CYC_TYPE
(
       EMPTY_CYC_TYPE_ID              ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EMPTY_CYC_TYPE
       ADD  ( PRIMARY KEY (EMPTY_CYC_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into empty_cyc_type values (0, 'Process As Normal');
insert into empty_cyc_type values (1, 'Skip Empty Cycles');
insert into empty_cyc_type values (2, 'Delay Empty Cycles');
COMMIT;



CREATE TABLE EV_CAMP_DET (
       CAMP_ID              NUMBER(8) NOT NULL,
       EMPTY_CYC_TYPE_ID    NUMBER(1) NOT NULL,
       INTERVAL_CYC_ID      NUMBER(8) NOT NULL,
       SEG_TYPE_ID          NUMBER(3) NULL,
       SEG_ID               NUMBER(8) NULL,
       EXC_PREV_TYPE        NUMBER(1) NOT NULL,
       EXC_PREV_CYC         NUMBER(2) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKEV_CAMP_DET ON EV_CAMP_DET
(
       CAMP_ID                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE EV_CAMP_DET
       ADD  ( PRIMARY KEY (CAMP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CUST_JOIN (
       VIEW_ID              VARCHAR2(30) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       JOIN_SEQ             NUMBER(1) NOT NULL,
       JOIN_CONDITION       VARCHAR2(300) NOT NULL,
       JOIN_TO_ENT          VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCUST_JOIN ON CUST_JOIN
(
       VIEW_ID                        ASC,
       VANTAGE_ALIAS                  ASC,
       JOIN_SEQ                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CUST_JOIN
       ADD  ( PRIMARY KEY (VIEW_ID, VANTAGE_ALIAS, JOIN_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CONS_FLD_DET (
       CONS_ID              NUMBER(4) NOT NULL,
       CONS_FLD_SEQ         NUMBER(2) NOT NULL,
       BLOCK_POS            CHAR(1) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_ID              NUMBER(8) NULL,
       STRING_VAL           VARCHAR2(200) NULL,
       OUT_LENGTH           NUMBER(4) NOT NULL,
       SRC_TYPE_ID 	    NUMBER(3),
       SRC_ID 	    	    NUMBER(8),
       SRC_SUB_ID 	    NUMBER(6),
       ORIG_COMP_TYPE_ID       NUMBER(2) NULL 		 
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCONS_FLD_DET ON CONS_FLD_DET
(
       CONS_ID                        ASC,
       CONS_FLD_SEQ                   ASC,
       BLOCK_POS                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CONS_FLD_DET
       ADD  ( PRIMARY KEY (CONS_ID, CONS_FLD_SEQ, BLOCK_POS)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_DRTV (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       DRTV_REGION_ID       NUMBER(4) NULL,
       DRTV_ID              NUMBER(4) NULL,
       PROGRAMME_IN         VARCHAR2(50) NULL,
       PROGRAMME_OUT        VARCHAR2(50) NULL,
       AUDIENCE_DESC        VARCHAR2(50) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_DRTV ON CAMP_DRTV
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_DRTV
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_COMM_IN_HDR (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       CAMP_CYC             NUMBER(8) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       RUN_NUMBER           VARCHAR2(200) NOT NULL,
       COMM_STATUS_ID       NUMBER(1) NOT NULL,
       PAR_COMM_DET_ID      NUMBER(4) NOT NULL,
       PAR_DET_ID           NUMBER(4) NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       COMM_QTY             NUMBER(10) NOT NULL,
       TOTAL_COST           NUMBER(12,3) NULL,
       TOTAL_REVENUE        NUMBER(12,3) NULL,
       RUN_DATE             DATE NOT NULL,
       RUN_TIME             CHAR(8) NOT NULL,
       KEYCODE              VARCHAR2(30) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       CAMP_CYC                       ASC,
       PLACEMENT_SEQ                  ASC,
       RUN_NUMBER                     ASC,
       COMM_STATUS_ID                 ASC,
       PAR_COMM_DET_ID                ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMP_COMM_IN_HDR ON CAMP_COMM_IN_HDR
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       PAR_DET_ID                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_COMM_IN_HDR
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, CAMP_CYC, 
              PLACEMENT_SEQ, RUN_NUMBER, COMM_STATUS_ID, 
              PAR_COMM_DET_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DDROP_CARRIER (
       DDROP_CARRIER_ID     NUMBER(4) NOT NULL,
       DDROP_CARRIER_NAME   VARCHAR2(50) NOT NULL,
       DDROP_CARRIER_DESC   VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDDROP_CARRIER ON DDROP_CARRIER
(
       DDROP_CARRIER_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DDROP_CARRIER
       ADD  ( PRIMARY KEY (DDROP_CARRIER_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DDROP_REGION (
       DDROP_REGION_ID      NUMBER(4) NOT NULL,
       DDROP_REGION_NAME    VARCHAR2(50) NOT NULL,
       DDROP_REGION_DESC    VARCHAR2(300) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDDROP_REGION ON DDROP_REGION
(
       DDROP_REGION_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DDROP_REGION
       ADD  ( PRIMARY KEY (DDROP_REGION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_DDROP (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NOT NULL,
       PLACEMENT_SEQ        NUMBER(4) NOT NULL,
       DDROP_REGION_ID      NUMBER(4) NULL,
       DDROP_CARRIER_ID     NUMBER(4) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_DDROP ON CAMP_DDROP
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DET_ID                         ASC,
       PLACEMENT_SEQ                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_DDROP
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DET_ID, PLACEMENT_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DATAVIEW_TEMPL_HDR (
       DATAVIEW_ID          NUMBER(6) NOT NULL,
       DATAVIEW_NAME        VARCHAR2(100) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       VIEW_ID              VARCHAR2(30) NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL,
       USE_COND_FLG         NUMBER(1) NOT NULL,
       USE_SORT_FLG         NUMBER(1) NOT NULL,
       DEFAULT_VIEW_FLG     NUMBER(1) NOT NULL,
       CM_FLG               NUMBER(1) NOT NULL,
       DEFAULT_CM_FLG       NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATAVIEW_TEMPL_HDR ON DATAVIEW_TEMPL_HDR
(
       DATAVIEW_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATAVIEW_TEMPL_HDR
       ADD  ( PRIMARY KEY (DATAVIEW_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DATAVIEW_TEMPL_DET (
       DATAVIEW_ID          NUMBER(6) NOT NULL,
       SEQ_NUMBER           NUMBER(4) NOT NULL,
       COMP_TYPE_ID         NUMBER(2) NOT NULL,
       COMP_ID              NUMBER(8) NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL,
       COND_OPERATOR_ID     NUMBER(2) NOT NULL,
       COND_VAL             VARCHAR2(300) NULL,
       SORT_DESCEND_FLG     NUMBER(1) NULL,
       SORT_ORDER           NUMBER(1) NULL,
       DISPLAY_NAME         VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDATAVIEW_TEMPL_DET ON DATAVIEW_TEMPL_DET
(
       DATAVIEW_ID                    ASC,
       SEQ_NUMBER                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE DATAVIEW_TEMPL_DET
       ADD  ( PRIMARY KEY (DATAVIEW_ID, SEQ_NUMBER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_MAP_SFDYN (
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DIRECTION_TYPE       CHAR(1) NOT NULL,
       DYN_COL_NAME         VARCHAR2(18) NOT NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NULL,
       COL_NAME             VARCHAR2(128) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_MAP_SFDYN ON CAMP_MAP_SFDYN
(
       CAMP_ID                        ASC,
       VERSION_ID                     ASC,
       DIRECTION_TYPE                 ASC,
       DYN_COL_NAME                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_MAP_SFDYN
       ADD  ( PRIMARY KEY (CAMP_ID, VERSION_ID, DIRECTION_TYPE, 
              DYN_COL_NAME)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE SEARCH_AREA (
       SEARCH_AREA_ID       NUMBER(2) NOT NULL,
       SEARCH_AREA_NAME     VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKSEARCH_AREA ON SEARCH_AREA
(
       SEARCH_AREA_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE SEARCH_AREA
       ADD  ( PRIMARY KEY (SEARCH_AREA_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into search_area values (1, 'Header (All)' );
insert into search_area values (2, 'Header (Subject)' );
insert into search_area values (3, 'Header (From)' );
insert into search_area values (4, 'Header (To)' );
insert into search_area values (5, 'Header (Date)' );
insert into search_area values (6, 'Message Text' );
insert into search_area values (7, 'Message (All)' );
COMMIT;


CREATE TABLE ERES_RULE_DET (
       RULE_ID              NUMBER(4) NOT NULL,
       RULE_DET_SEQ         NUMBER(2) NOT NULL,
       STRING_VAL           VARCHAR2(200) NOT NULL,
       SEARCH_AREA_ID       NUMBER(2) NOT NULL,
       START_AFTER_STRING   VARCHAR2(100) NULL,
       END_BEFORE_STRING    VARCHAR2(100) NULL,
       CASE_SENSITIVE_FLG   NUMBER(1) NOT NULL,
       JOIN_OPERATOR_ID     NUMBER(1) NULL,
       PAR_RULE_DET_SEQ     NUMBER(2) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKERES_RULE_DET ON ERES_RULE_DET
(
       RULE_ID                        ASC,
       RULE_DET_SEQ                   ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ERES_RULE_DET
       ADD  ( PRIMARY KEY (RULE_ID, RULE_DET_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CONSTRAINT_TYPE (
       CONSTRAINT_TYPE_ID   NUMBER(1) NOT NULL,
       CONSTRAINT_NAME      VARCHAR2(50) NULL,
       CONSTRAINT_DELETE    VARCHAR2(100) NOT NULL,
       CONSTRAINT_UPDATE    VARCHAR2(100) NOT NULL,
       MESSAGE_ON_DELETE    NUMBER(6) NULL,
       MESSAGE_ON_UPDATE    NUMBER(6) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCONSTRAINT_TYPE ON CONSTRAINT_TYPE
(
       CONSTRAINT_TYPE_ID             ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CONSTRAINT_TYPE
       ADD  ( PRIMARY KEY (CONSTRAINT_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into constraint_type values ( 1, 'Non-critical', 'Warn and Prevent with list of Referrers', 'Allow without warning', 8004, null );
insert into constraint_type values ( 2, 'Standard', 'Warn and Prevent with list of Referrers', 'Warn and Allow with list of direct Referrers', 8004, 8005 );
COMMIT;


CREATE TABLE REF_INDICATOR (
       REF_INDICATOR_ID     NUMBER(2) NOT NULL,
       REF_INDICATOR_NAME   VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKREF_INDICATOR ON REF_INDICATOR
(
       REF_INDICATOR_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE REF_INDICATOR
       ADD  ( PRIMARY KEY (REF_INDICATOR_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into ref_indicator values (1, 'Header');
insert into ref_indicator values (2, 'Source');
insert into ref_indicator values (3, 'Detail');
insert into ref_indicator values (4, 'Budget Manager');
insert into ref_indicator values (5, 'Fixed Cost');
insert into ref_indicator values (6, 'Event');
insert into ref_indicator values (7, 'Stored Field');
insert into ref_indicator values (8, 'Base');
insert into ref_indicator values (9, 'Door Drop');
insert into ref_indicator values (10, 'TV');
insert into ref_indicator values (11, 'Leaflet');
insert into ref_indicator values (12, 'Poster');
insert into ref_indicator values (13, 'Radio');
insert into ref_indicator values (14, 'Publication');
insert into ref_indicator values (15, 'Seed Map');
insert into ref_indicator values (16, 'Criteria');
insert into ref_indicator values (17, 'Group By');
insert into ref_indicator values (18, 'Order By');
insert into ref_indicator values (19, 'Additional Info');
insert into ref_indicator values (20, 'Conditional Value');
insert into ref_indicator values (21, 'Output');
insert into ref_indicator values (22, 'Where');
insert into ref_indicator values (23, 'Dedupe By');
insert into ref_indicator values (24, 'From');
insert into ref_indicator values (25, 'Reply');
insert into ref_indicator values (26, 'Output From');
insert into ref_indicator values (27, 'Output Reply');
insert into ref_indicator values (28, 'Delivery');
insert into ref_indicator values (29, 'Header and Footer');
COMMIT;


CREATE TABLE REFERENCED_OBJ (
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_SUB_ID           NUMBER(8) NULL,
       OBJ_SUB_DET_ID       NUMBER(8) NULL,
       OBJ_SRC_TYPE_ID      NUMBER(3) NULL,
       OBJ_SRC_ID           NUMBER(8) NULL,
       OBJ_SRC_SUB_ID       NUMBER(8) NULL,
       REF_TYPE_ID          NUMBER(3) NOT NULL,
       REF_ID               NUMBER(8) NOT NULL,
       REF_SUB_ID           NUMBER(8) NULL,
       REF_DET_ID           NUMBER(8) NULL,
       REF_SUB_DET_ID       NUMBER(8) NULL,
       REF_INDICATOR_ID     NUMBER(2) NOT NULL,
       CONSTRAINT_TYPE_ID   NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE INDEX XIE1REFERENCED_OBJ ON REFERENCED_OBJ
(
       OBJ_TYPE_ID                    ASC,
       OBJ_ID                         ASC,
       OBJ_SUB_ID                     ASC,
       OBJ_SUB_DET_ID                 ASC,
       OBJ_SRC_TYPE_ID                ASC,
       OBJ_SRC_ID                     ASC,
       OBJ_SRC_SUB_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE2REFERENCED_OBJ ON REFERENCED_OBJ
(
       REF_TYPE_ID                    ASC,
       REF_ID                         ASC,
       REF_DET_ID                     ASC,
       REF_SUB_ID                     ASC,
       REF_SUB_DET_ID                 ASC,
       REF_INDICATOR_ID               ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE3REFERENCED_OBJ ON REFERENCED_OBJ
(
       OBJ_TYPE_ID                    ASC,
       OBJ_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE4REFERENCED_OBJ ON REFERENCED_OBJ
(
       REF_TYPE_ID                    ASC,
       REF_ID                         ASC
)
       TABLESPACE &ts_pv_ind
;


CREATE TABLE CAMP_REP_GRP (
       CAMP_REP_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_REP_GRP_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_REP_GRP ON CAMP_REP_GRP
(
       CAMP_REP_GRP_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_REP_GRP
       ADD  ( PRIMARY KEY (CAMP_REP_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_REP_HDR (
       CAMP_REP_ID          NUMBER(8) NOT NULL,
       CAMP_REP_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_REP_NAME        VARCHAR2(100) NOT NULL,
       GROUPED_REP_FLG      NUMBER(1) NOT NULL,
       PRINT_PORTRAIT_FLG   NUMBER(1) NOT NULL,
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_REP_HDR ON CAMP_REP_HDR
(
       CAMP_REP_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_REP_HDR
       ADD  ( PRIMARY KEY (CAMP_REP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE GRP_FUNCTION (
       GRP_FUNCTION_ID      NUMBER(2) NOT NULL,
       GRP_FUNCTION_NAME    VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKGRP_FUNCTION ON GRP_FUNCTION
(
       GRP_FUNCTION_ID                ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE GRP_FUNCTION
       ADD  ( PRIMARY KEY (GRP_FUNCTION_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into grp_function values (1, 'Group By');
insert into grp_function values (2, 'Sum');
insert into grp_function values (3, 'Average');
insert into grp_function values (4, 'Maximum');
insert into grp_function values (5, 'Minimum');
COMMIT;


CREATE TABLE REP_COL_GRP (
       REP_COL_GRP_ID       NUMBER(2) NOT NULL,
       REP_COL_GRP_NAME     VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKREP_COL_GRP ON REP_COL_GRP
(
       REP_COL_GRP_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE REP_COL_GRP
       ADD  ( PRIMARY KEY (REP_COL_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into rep_col_grp values (1, 'Campaign Information');
insert into rep_col_grp values (2, 'Treatment Information');
insert into rep_col_grp values (3, 'Segment Information');
insert into rep_col_grp values (4, 'Projection');
insert into rep_col_grp values (5, 'Actual');
insert into rep_col_grp values (6, 'Variance');
insert into rep_col_grp values (7, 'Metrics');
COMMIT;


CREATE TABLE CAMP_REP_COL (
       CAMP_REP_COL_ID      NUMBER(4) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL,
       REP_COL_GRP_ID       NUMBER(2) NOT NULL,
       DFT_COL_WIDTH        NUMBER(4) NOT NULL,
       COL_FORMAT_ID        NUMBER(1) NOT NULL,
       COL_SQL              VARCHAR2(100) NOT NULL,
       DFT_FUNCTION_ID      NUMBER(2) NOT NULL,
       GRP_BY_ONLY_FLG      NUMBER(1) NOT NULL,
       COL_SEQ              NUMBER(3) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_REP_COL ON CAMP_REP_COL
(
       CAMP_REP_COL_ID                ASC
)
       TABLESPACE &ts_pv_ind
;

CREATE INDEX XIE1CAMP_REP_COL ON CAMP_REP_COL
(
       COL_SEQ                        ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_REP_COL
       ADD  ( PRIMARY KEY (CAMP_REP_COL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into camp_rep_col values ( 1, 'Strategy Code', 1, 1000, 2, 'STRATEGY_ID', 1, 1, 1);
insert into camp_rep_col values ( 2, 'Strategy Name', 1, 3000, 1, 'STRATEGY_NAME', 1, 1, 2);
insert into camp_rep_col values ( 3, 'Campaign Group Code', 1, 1000, 2, 'CAMP_GRP_ID', 1, 1, 3);
insert into camp_rep_col values ( 4, 'Campaign Group Name', 1, 3000, 1, 'CAMP_GRP_NAME', 1, 1, 4);
insert into camp_rep_col values ( 5, 'Campaign ID', 1, 1000, 2, 'CAMP_ID', 1, 1, 5);
insert into camp_rep_col values ( 6, 'Campaign Code', 1, 1000, 1, 'CAMP_CODE', 1, 1, 6);
insert into camp_rep_col values ( 7, 'Campaign Name', 1, 3000, 1, 'CAMP_NAME', 1, 1, 7);
insert into camp_rep_col values ( 8, 'Campaign Status', 1, 2000, 1, 'CAMP_STATUS', 1, 1, 8);
insert into camp_rep_col values ( 9, 'Campaign Template', 1, 2000, 1, 'CAMP_TEMPLATE', 1, 1, 9);
insert into camp_rep_col values ( 10, 'Campaign Manager', 1, 3000, 1, 'CAMP_MANAGER', 1, 1, 10);
insert into camp_rep_col values ( 11, 'Campaign Fixed Cost', 1, 3000, 4, 'CAMP_FIXED_COST', 1, 1, 11);
insert into camp_rep_col values ( 12, 'Budget Manager', 1, 3000, 1, 'BUDGET_MANAGER', 1, 1, 12);
insert into camp_rep_col values ( 13, 'Campaign Type', 1, 3000, 1, 'CAMP_TYPE', 1, 1, 13);
insert into camp_rep_col values ( 14, 'Start Date', 1, 2000, 3, 'CAMP_START_DATE', 1, 1, 14);
insert into camp_rep_col values ( 15, 'Campaign Number of Cycles (to date)', 1, 1000, 2, 'CAMP_NO_OF_CYCLES', 1, 1, 15);
insert into camp_rep_col values ( 16, 'Treatment Code', 2, 1000, 2, 'TREATMENT_ID', 1, 1, 16);
insert into camp_rep_col values ( 17, 'Treatment Name', 2, 3000, 1, 'TREATMENT_NAME', 1, 1, 17);
insert into camp_rep_col values ( 18, 'Treatment Unit Variable Cost', 2, 1000, 4, 'UNIT_VAR_COST', 2, 0, 18);
insert into camp_rep_col values ( 19, 'Treatment Fixed Cost', 2, 1000, 4, 'TREAT_FIXED_COST', 2, 0, 19);
insert into camp_rep_col values ( 20, 'Treatment Channel Type', 2, 2000, 1, 'TREAT_CHAN', 1, 1, 20);
insert into camp_rep_col values ( 21, 'Segment Code', 3, 1000, 2, 'SEG_ID', 1, 1, 21);
insert into camp_rep_col values ( 22, 'Sub Segment Code', 3, 1000, 2, 'SEG_SUB_ID', 1, 1, 22);
insert into camp_rep_col values ( 23, 'Segment Name', 3, 3000, 1, 'SEG_NAME', 1, 1, 23);
insert into camp_rep_col values ( 24, 'Segment Type', 3, 2000, 1, 'SEG_TYPE_ID', 1, 1, 24);
insert into camp_rep_col values ( 25, 'Segment Keycode', 3, 2000, 1, 'SEG_KEYCODE', 1, 1, 25);
insert into camp_rep_col values ( 26, 'Control/Non Control Segment', 3, 1000, 1, 'SEG_CONTROL_FLG', 1, 1, 26);
insert into camp_rep_col values ( 27, 'Projected Outbound Quantity Per Cycle', 4, 1000, 2, 'PROJ_OUT_CYC_QTY', 2, 0, 27);
insert into camp_rep_col values ( 28, 'Projected Outbound Quantity (to date)', 4, 1000, 2, 'PROJ_OUT_QTY', 2, 0, 28);
insert into camp_rep_col values ( 29, 'Projected Inbound Quantity Per Cycle', 4, 1000, 2, 'PROJ_INB_CYC_QTY', 2, 0, 29);
insert into camp_rep_col values ( 30, 'Projected Inbound Quantity (to date)', 4, 1000, 2, 'PROJ_INB_QTY', 2, 0, 30);
insert into camp_rep_col values ( 31, 'Projected Response Rate', 4, 1000, 5, 'PROJ_RES_RATE', 2, 0, 31);
insert into camp_rep_col values ( 32, 'Projected Outbound Variable Cost per Cycle', 4, 1000, 4, 'PROJ_OUT_CYC_VCOST', 2, 0, 32);
insert into camp_rep_col values ( 33, 'Projected Outbound Variable Cost (to date)', 4, 1000, 4, 'PROJ_OUT_VCOST', 2, 0, 33);
insert into camp_rep_col values ( 34, 'Projected Inbound Variable Cost per Cycle', 4, 1000, 4, 'PROJ_INB_CYC_VCOST', 2, 0, 34);
insert into camp_rep_col values ( 35, 'Projected Inbound Variable Cost (to date)', 4, 1000, 4, 'PROJ_INB_VCOST', 2, 0, 35);
insert into camp_rep_col values ( 36, 'Projected Revenue Per Cycle', 4, 1000, 4, 'PROJ_INB_CYC_REV', 2, 0, 36);
insert into camp_rep_col values ( 37, 'Projected Revenue (to date)', 4, 1000, 4, 'PROJ_INB_REV', 2, 0, 37);
insert into camp_rep_col values ( 38, 'Actual Outbound Treatment Quantity', 5, 1000, 2, 'SEG_ACT_TREAT_QTY', 2, 0, 38);
insert into camp_rep_col values ( 39, 'Actual Inbound Quantity', 5, 1000, 2, 'SEG_ACT_INB_QTY', 2, 0, 40);
insert into camp_rep_col values ( 40, 'Actual Outbound Variable Cost', 5, 1000, 4, 'SEG_ACT_OUT_VCOST', 2, 0, 41);
insert into camp_rep_col values ( 41, 'Actual Inbound Variable Cost', 5, 1000, 4, 'SEG_ACT_INB_VCOST', 2, 0, 42);
insert into camp_rep_col values ( 42, 'Actual Revenue', 5, 1000, 4, 'SEG_ACT_REV', 2, 0, 43);
insert into camp_rep_col values ( 43, 'Outbound Quantity Variance', 6, 1000, 2, '(PROJ_OUT_QTY - SEG_ACT_OUT_QTY) AS OUT_QTY_VAR ', 2, 0, 44);
insert into camp_rep_col values ( 44, 'Inbound Quantity Variance', 6, 1000, 2, '(PROJ_INB_QTY - SEG_ACT_INB_QTY) AS INB_QTY_VAR', 2, 0, 45);
insert into camp_rep_col values ( 45, 'Outbound Variable Cost Variance', 6, 1000, 4, '(PROJ_OUT_VCOST - SEG_ACT_OUT_VCOST) AS OUT_VCOST_VAR', 2, 0, 46);
insert into camp_rep_col values ( 46, 'Inbound Variable Cost Variance', 6, 1000, 4, '(PROJ_INB_VCOST - SEG_ACT_INB_VCOST) AS INB_VCOST_VAR', 2, 0, 47);
insert into camp_rep_col values ( 47, 'Revenue Variance', 6, 1000, 4, '(PROJ_INB_REV - SEG_ACT_REV) AS REV_VAR', 2, 0, 48);
insert into camp_rep_col values ( 48, 'Actual Treatment Response Rate', 7, 1000, 5, '(SEG_ACT_INB_QTY/SEG_ACT_TREAT_QTY) AS ACT_TREAT_RES_RATE', 2, 0, 49);
insert into camp_rep_col values ( 49, 'Projected Response Rate', 7, 1000, 5, '(PROJ_INB_QTY/PROJ_OUT_QTY) AS PROJ_RES_RATE', 2, 0, 51);
insert into camp_rep_col values ( 50, 'Actual Cost Per Contact', 7, 1000, 4, '((SEG_ACT_OUT_VCOST + SEG_ACT_INB_VCOST) / SEG_ACT_OUT_QTY) AS ACT_CON_COST', 2, 0, 52);
insert into camp_rep_col values ( 51, 'Projected Cost Per Contact', 7, 1000, 4, '((PROJ_OUT_VCOST + PROJ_INB_VCOST) / PROJ_OUT_QTY) AS PROJ_CON_COST', 2, 0, 53);
insert into camp_rep_col values ( 52, 'Actual Revenue Per Contact', 7, 1000, 4, '(SEG_ACT_REV / SEG_ACT_OUT_QTY) AS ACT_CON_REV', 2, 0, 54);
insert into camp_rep_col values ( 53, 'Projected Revenue Per Contact', 7, 1000, 4, '(PROJ_INB_REV / PROJ_OUT_QTY) AS PROJ_CON_REV', 2, 0, 55);
insert into camp_rep_col values ( 54, 'Actual Cost Per Response', 7, 1000, 4, '((SEG_ACT_OUT_VCOST + SEG_ACT_INB_VCOST) / SEG_ACT_INB_QTY) AS ACT_REV_COST', 2, 0, 56);
insert into camp_rep_col values ( 55, 'Projected Cost Per Response', 7, 1000, 4, '((PROJ_OUT_VCOST + PROJ_INB_VCOST) / PROJ_INB_QTY) AS PROJ_REV_COST', 2, 0, 57);
insert into camp_rep_col values ( 56, 'Actual Revenue Per Response', 7, 1000, 4, '(SEG_ACT_REV / SEG_ACT_INB_QTY) AS ACT_RES_REV', 2, 0, 58);
insert into camp_rep_col values ( 57, 'Projected Revenue Per Response', 7, 1000, 4, '(PROJ_INB_REV / PROJ_INB_QTY) AS PROJ_RES_REV', 2, 0, 59);
insert into camp_rep_col values ( 58, 'Actual Outbound Communications Quantity', 5, 1000, 2, 'SEG_ACT_OUT_QTY', 2, 0, 39);
insert into camp_rep_col values ( 59, 'Actual Communications Response Rate', 7, 1000, 5, '(SEG_ACT_INB_QTY / SEG_ACT_OUT_QTY) AS ACT_RES_RATE', 2, 0, 50);
insert into camp_rep_col values ( 60, 'Version ID', 1, 1000, 2, 'VERSION_ID', 1, 1, 60 );
insert into camp_rep_col values ( 61, 'Version Name', 1, 3000, 1, 'VERSION_NAME', 1, 1, 61 );
COMMIT;



CREATE TABLE CAMP_REP_DET (
       CAMP_REP_ID          NUMBER(8) NOT NULL,
       CAMP_REP_DET_SEQ     NUMBER(4) NOT NULL,
       CAMP_REP_COL_ID      NUMBER(4) NOT NULL,
       COL_DISPLAY_NAME     VARCHAR2(100) NULL,
       COL_DISPLAY_WIDTH    NUMBER(4) NOT NULL,
       GRP_FUNCTION_ID      NUMBER(2) NULL,
       SORT_ORDER           NUMBER(1) NOT NULL,
       SORT_DESCEND_FLG     NUMBER(1) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_REP_DET ON CAMP_REP_DET
(
       CAMP_REP_ID                    ASC,
       CAMP_REP_DET_SEQ               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_REP_DET
       ADD  ( PRIMARY KEY (CAMP_REP_ID, CAMP_REP_DET_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CAMP_REP_COND (
       CAMP_REP_ID          NUMBER(8) NOT NULL,
       CAMP_REP_COND_SEQ    NUMBER(2) NOT NULL,
       JOIN_OPERATOR_ID     NUMBER(1) NULL,
       OPEN_BRACKET_FLG     NUMBER(1) NOT NULL,
       CAMP_REP_COL_ID      NUMBER(4) NOT NULL,
       COND_OPERATOR_ID     NUMBER(2) NOT NULL,
       COND_VALUE           VARCHAR2(300) NULL,
       CLOSE_BRACKET_FLG    NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKCAMP_REP_COND ON CAMP_REP_COND
(
       CAMP_REP_ID                    ASC,
       CAMP_REP_COND_SEQ              ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE CAMP_REP_COND
       ADD  ( PRIMARY KEY (CAMP_REP_ID, CAMP_REP_COND_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE CONSTRAINT_SETTING (
       REF_TYPE_ID          NUMBER(3) NOT NULL,
       REF_INDICATOR_ID     NUMBER(2) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NULL,
       CONSTRAINT_TYPE_ID   NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE INDEX XIE1CONSTRAINT_SETTING ON CONSTRAINT_SETTING
(
       REF_TYPE_ID                    ASC,
       REF_INDICATOR_ID               ASC,
       OBJ_TYPE_ID                    ASC
)
       TABLESPACE &ts_pv_ind
;

insert into constraint_setting values ( 13, 1, null, 2 );
insert into constraint_setting values ( 13,  2, null, 2 );
insert into constraint_setting values ( 13, 16, null, 2 );	
insert into constraint_setting values ( 13, 17, null, 2 );
insert into constraint_setting values ( 13, 18, null, 2 );
insert into constraint_setting values ( 13, 19, null, 2 );
insert into constraint_setting values ( 13, 22, null, 2 );
insert into constraint_setting values (  9,  2, null, 2 );
insert into constraint_setting values (  9,  3, null, 2 );
insert into constraint_setting values (  7,  2, null, 2 );
insert into constraint_setting values (  7,  3, null, 2 );
insert into constraint_setting values (  7, 20, null, 2 );
insert into constraint_setting values (  6,  3, null, 2 );
insert into constraint_setting values (  6, 20, null, 2 );
insert into constraint_setting values ( 12,  3, null, 2 );
insert into constraint_setting values ( 12, 29, null, 2 );
insert into constraint_setting values ( 31,  3, null, 2 );
insert into constraint_setting values (  1,  1, null, 1 );
insert into constraint_setting values (  1, 16,   13, 2 );
insert into constraint_setting values (  1, 16,    9, 2 );
insert into constraint_setting values (  1, 16,    1, 2 );
insert into constraint_setting values (  1, 16,    2, 2 );
insert into constraint_setting values (  1, 16,    4, 2 );
insert into constraint_setting values (  1, 16,    8, 2 );
insert into constraint_setting values (  1, 16,   32, 2 );
insert into constraint_setting values (  1, 16,   33, 2 );
insert into constraint_setting values (  1, 16,   24, 2 );
insert into constraint_setting values (  1,  7, null, 2 );
insert into constraint_setting values (  1, 23, null, 2 );	
insert into constraint_setting values (  2,  1, null, 1 );
insert into constraint_setting values (  2, 16,   13, 2 );
insert into constraint_setting values (  2, 16,    9, 2 );
insert into constraint_setting values (  2, 16,    1, 2 );
insert into constraint_setting values (  2, 16,    2, 2 );
insert into constraint_setting values (  2, 16,    4, 2 );
insert into constraint_setting values (  2, 16,    8, 2 );
insert into constraint_setting values (  2, 16,   32, 2 );
insert into constraint_setting values (  2, 16,   33, 2 );
insert into constraint_setting values (  2, 16,   24, 2 );
insert into constraint_setting values (  2,  7, null, 2 );
insert into constraint_setting values (  2, 23, null, 2 );
insert into constraint_setting values (  3,  1, null, 1 );
insert into constraint_setting values (  3, 16,   13, 2 );
insert into constraint_setting values (  3, 16,    9, 2 );
insert into constraint_setting values (  3, 16,    1, 2 );
insert into constraint_setting values (  3, 16,    2, 2 );
insert into constraint_setting values (  3, 16,    4, 2 );
insert into constraint_setting values (  3, 16,    8, 2 );
insert into constraint_setting values (  3, 16,   32, 2 );
insert into constraint_setting values (  3, 16,   33, 2 );
insert into constraint_setting values (  3, 16,   24, 2 );
insert into constraint_setting values (  3,  7, null, 2 );
insert into constraint_setting values (  3, 23, null, 2 );
insert into constraint_setting values (  15,  1, null, 1 );
insert into constraint_setting values (  15, 16,   13, 2 );
insert into constraint_setting values (  15, 16,    9, 2 );
insert into constraint_setting values (  15, 16,    1, 2 );
insert into constraint_setting values (  15, 16,    2, 2 );
insert into constraint_setting values (  15, 16,    4, 2 );
insert into constraint_setting values (  15, 16,    8, 2 );
insert into constraint_setting values (  15, 16,   32, 2 );
insert into constraint_setting values (  15, 16,   33, 2 );
insert into constraint_setting values (  15, 16,   24, 2 );
insert into constraint_setting values (  15,  7, null, 2 );
insert into constraint_setting values (  15, 23, null, 2 );
insert into constraint_setting values (  16,  1, null, 1 );
insert into constraint_setting values (  16, 16,   13, 2 );
insert into constraint_setting values (  16, 16,    9, 2 );
insert into constraint_setting values (  16, 16,    1, 2 );
insert into constraint_setting values (  16, 16,    2, 2 );
insert into constraint_setting values (  16, 16,    4, 2 );
insert into constraint_setting values (  16, 16,    8, 2 );
insert into constraint_setting values (  16, 16,   32, 2 );
insert into constraint_setting values (  16, 16,   33, 2 );
insert into constraint_setting values (  16, 16,   24, 2 );
insert into constraint_setting values (  16,  7, null, 2 );
insert into constraint_setting values (  16, 23, null, 2 );
insert into constraint_setting values (  28,  1, null, 1 );
insert into constraint_setting values (  28, 16,   13, 2 );
insert into constraint_setting values (  28, 16,    9, 2 );
insert into constraint_setting values (  28, 16,    1, 2 );
insert into constraint_setting values (  28, 16,    2, 2 );
insert into constraint_setting values (  28, 16,    4, 2 );
insert into constraint_setting values (  28, 16,    8, 2 );
insert into constraint_setting values (  28, 16,   32, 2 );
insert into constraint_setting values (  28, 16,   33, 2 );
insert into constraint_setting values (  28, 16,   24, 2 );
insert into constraint_setting values (  28,  7, null, 2 );
insert into constraint_setting values (  28, 23, null, 2 );
insert into constraint_setting values (  29,  1, null, 1 );
insert into constraint_setting values (  29, 16,   13, 2 );
insert into constraint_setting values (  29, 16,    9, 2 );
insert into constraint_setting values (  29, 16,    1, 2 );
insert into constraint_setting values (  29, 16,    2, 2 );
insert into constraint_setting values (  29, 16,    4, 2 );
insert into constraint_setting values (  29, 16,    8, 2 );
insert into constraint_setting values (  29, 16,   32, 2 );
insert into constraint_setting values (  29, 16,   33, 2 );
insert into constraint_setting values (  29, 16,   24, 2 );
insert into constraint_setting values (  29,  7, null, 2 );
insert into constraint_setting values (  29, 23, null, 2 );
insert into constraint_setting values (  4,  8, null, 2 );
insert into constraint_setting values (  4,  3, null, 2 );
insert into constraint_setting values (  4,  16,   1, 2 );
insert into constraint_setting values (  4,  16,   2, 2 );
insert into constraint_setting values (  4,  16,   4, 2 );
insert into constraint_setting values ( 33,  1, null, 1 );
insert into constraint_setting values ( 24,  4,   36, 1 );
insert into constraint_setting values ( 24,  1,   36, 1 );
insert into constraint_setting values ( 24,  1,   33, 1 );
insert into constraint_setting values ( 24,  1,   37, 1 );
insert into constraint_setting values ( 24,  1,   28, 2 );
insert into constraint_setting values ( 24,  1,   29, 2 );
insert into constraint_setting values ( 24,  1,   98, 2 );
insert into constraint_setting values ( 24,  5, null, 2 );
insert into constraint_setting values ( 24,  6, null, 2 );
insert into constraint_setting values ( 24,  3, null, 2 );
insert into constraint_setting values ( 24,  9, null, 1 );
insert into constraint_setting values ( 24, 10, null, 1 );
insert into constraint_setting values ( 24, 11, null, 1 );
insert into constraint_setting values ( 24, 12, null, 1 );
insert into constraint_setting values ( 24, 13, null, 1 );
insert into constraint_setting values ( 24, 14, null, 1 );
insert into constraint_setting values ( 24, 21, 11, 2 );
insert into constraint_setting values ( 24, 21, 12, 2 );
insert into constraint_setting values ( 24, 21, 14, 2 );	
insert into constraint_setting values ( 24, 26, 62, 2 );
insert into constraint_setting values ( 24, 27, 62, 2 );
insert into constraint_setting values ( 42,  1,   80, 1 );  
insert into constraint_setting values ( 18,  1,   41, 1 );
insert into constraint_setting values ( 18,  1,   42, 2 );
insert into constraint_setting values ( 18,  1,   44, 2 );
insert into constraint_setting values ( 18,  1,   98, 2 );
insert into constraint_setting values ( 18,  5, null, 2 );
insert into constraint_setting values ( 44,  1, null, 1 );
insert into constraint_setting values ( 19,  3,   3, 2 );
insert into constraint_setting values ( 19,  3,  35, 1 );
insert into constraint_setting values ( 19,  3,  34, 1 );
insert into constraint_setting values ( 11,  1,  12, 2 );
insert into constraint_setting values ( 11,  1,  61, 2 );
insert into constraint_setting values ( 11,  1,  98, 2 );
insert into constraint_setting values ( 11, 28, null, 2 );
insert into constraint_setting values ( 14,  1, null, 1 );
insert into constraint_setting values ( 62,  1,  61, 2 );
insert into constraint_setting values ( 62,  1,  69, 2 );
insert into constraint_setting values ( 97,  1,  69, 2 );
insert into constraint_setting values ( 97,  1,  79, 2 );
insert into constraint_setting values ( 67,  1, null, 1 );
insert into constraint_setting values ( 69,  1, null, 1 );
insert into constraint_setting values ( 68,  1, null, 2 );
insert into constraint_setting values ( 68,  3, null, 2 );
insert into constraint_setting values ( 17,  3, null, 2 );
insert into constraint_setting values ( 70,  1, null, 1 );
insert into constraint_setting values ( 66,  1, null, 1 );
insert into constraint_setting values (101,  1, null, 1 );
insert into constraint_setting values (  4,  1, null, 1 );
insert into constraint_setting values (102,  1, null, 1 );
insert into constraint_setting values (  8,  1, null, 1 );
COMMIT;


CREATE TABLE TEST_TEMPL_MAP (
       TREATMENT_ID         NUMBER(8) NOT NULL,
       PLACEHOLDER          VARCHAR2(50) NOT NULL,
       TEMPL_LINE_SEQ       NUMBER(4) NOT NULL,
       OUT_LINE_SEQ         NUMBER(4) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKTEST_TEMPL_MAP ON TEST_TEMPL_MAP
(
       TREATMENT_ID                   ASC,
       PLACEHOLDER                    ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE TEST_TEMPL_MAP
       ADD  ( PRIMARY KEY (TREATMENT_ID, PLACEHOLDER)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ATTACHMENT (
       TREATMENT_ID         NUMBER(8) NOT NULL,
       ATTACHMENT_ID        NUMBER(2) NOT NULL,
       PATH_FILENAME        VARCHAR2(255) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKATTACHMENT ON ATTACHMENT
(
       TREATMENT_ID                   ASC,
       ATTACHMENT_ID                  ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ATTACHMENT
       ADD  ( PRIMARY KEY (TREATMENT_ID, ATTACHMENT_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE UPDATE_STATUS (
       UPDATE_STATUS_ID     NUMBER(2) NOT NULL,
       UPDATE_STATUS_NAME   VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKUPDATE_STATUS ON UPDATE_STATUS
(
       UPDATE_STATUS_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE UPDATE_STATUS
       ADD  ( PRIMARY KEY (UPDATE_STATUS_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into update_status values (0, 'Not yet processed');
insert into update_status values (1, 'Processing');
insert into update_status values (2, 'Processed successfully');
insert into update_status values (3, 'Processing failed');
insert into update_status values (9, 'Data error');
COMMIT;



CREATE TABLE WIRELESS_INBOX (
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       INBOX_ADDRESS        VARCHAR2(100) NOT NULL,
       INBOX_DESC           VARCHAR2(300) NULL,
       TEST_SEND_FLG        NUMBER(1) NOT NULL,
       TEST_MESSAGE_TO      VARCHAR2(100) NULL,
       INB_PORT		    NUMBER(8),
       CREATED_BY           VARCHAR2(30) NOT NULL,
       CREATED_DATE         DATE NOT NULL,
       UPDATED_BY           VARCHAR2(30) NULL,
       UPDATED_DATE         DATE NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKWIRELESS_INBOX ON WIRELESS_INBOX
(
       SERVER_ID                      ASC,
       INBOX_ID                       ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE WIRELESS_INBOX
       ADD  ( PRIMARY KEY (SERVER_ID, INBOX_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_ACTION_TYPE (
       ACTION_TYPE_ID       NUMBER(2) NOT NULL,
       ACTION_TYPE_NAME     VARCHAR2(20) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_ACTION_TYPE ON RES_ACTION_TYPE
(
       ACTION_TYPE_ID                 ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_ACTION_TYPE
       ADD  ( PRIMARY KEY (ACTION_TYPE_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into res_action_type values (10, 'Forward');
insert into res_action_type values (20, 'Store Value');
insert into res_action_type values (30, 'Store Campaign');
insert into res_action_type values (40, 'Custom');
COMMIT;


CREATE TABLE RES_RULE_ACTION (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID	    NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       ACTION_TYPE_ID       NUMBER(2) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_RULE_ACTION ON RES_RULE_ACTION
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC,
       ACTION_SEQ                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_RULE_ACTION
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ACTION_FORWARD (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       FORWARD_TO_MAILBOX   VARCHAR2(100) NOT NULL,
       FORWARD_SERVER_ID    NUMBER(4) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKACTION_FORWARD ON ACTION_FORWARD
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC,
       ACTION_SEQ                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ACTION_FORWARD
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ACTION_STORE_VAL (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       MESSAGE_VAL_FLG      NUMBER(1) NOT NULL,
       INSERT_VAL           VARCHAR2(160) NULL,
       VANTAGE_ALIAS        VARCHAR2(128) NOT NULL,
       COL_NAME             VARCHAR2(128) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKACTION_STORE_VAL ON ACTION_STORE_VAL
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC,
       ACTION_SEQ                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ACTION_STORE_VAL
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ACTION_STORE_CAMP (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       CAMP_ID              NUMBER(8) NOT NULL,
       VERSION_ID           NUMBER(3) NOT NULL,
       DET_ID               NUMBER(4) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKACTION_STORE_CAMP ON ACTION_STORE_CAMP
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC,
       ACTION_SEQ                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ACTION_STORE_CAMP
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE ACTION_CUSTOM (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID         NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       CUSTOM_ACTION_NAME   VARCHAR2(50) NOT NULL,
       CUSTOM_FILENAME      VARCHAR2(255) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKACTION_CUSTOM ON ACTION_CUSTOM
(
       RULE_ID                        ASC, 
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID		      ASC,
       ACTION_SEQ                     ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE ACTION_CUSTOM
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE RES_SYS_PARAM (
       RES_SYS_PARAM_ID     NUMBER(2) NOT NULL,
       RES_SYS_PARAM_NAME   VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_SYS_PARAM ON RES_SYS_PARAM
(
       RES_SYS_PARAM_ID               ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_SYS_PARAM
       ADD  ( PRIMARY KEY (RES_SYS_PARAM_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into res_sys_param values (1, 'Phone Number');
insert into res_sys_param values (2, 'Message Text');
insert into res_sys_param values (3, 'Current Date');
insert into res_sys_param values (4, 'Current Time');
COMMIT;


CREATE TABLE RES_CUSTOM_PARAM (
       RULE_ID              NUMBER(4) NOT NULL,
       SERVER_ID            NUMBER(4) NOT NULL,
       INBOX_ID             NUMBER(4) NOT NULL,
       CHAN_TYPE_ID	    NUMBER(3) NOT NULL,
       ACTION_SEQ           NUMBER(2) NOT NULL,
       PARAM_SEQ            NUMBER(2) NOT NULL,
       SYS_PARAM_FLG        NUMBER(1) NOT NULL,
       RES_SYS_PARAM_ID     NUMBER(2) NULL,
       PARAM_NAME           VARCHAR2(100) NULL,
       PARAM_VAL            VARCHAR2(200) NULL
)
       TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKRES_CUSTOM_PARAM ON RES_CUSTOM_PARAM
(
       RULE_ID                        ASC,
       SERVER_ID                      ASC,
       INBOX_ID                       ASC,
       CHAN_TYPE_ID	              ASC,
       ACTION_SEQ                     ASC,
       PARAM_SEQ                      ASC
)
       TABLESPACE &ts_pv_ind
;


ALTER TABLE RES_CUSTOM_PARAM
       ADD  ( PRIMARY KEY (RULE_ID, SERVER_ID, INBOX_ID, CHAN_TYPE_ID, ACTION_SEQ, 
              PARAM_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;


CREATE TABLE DELIVERY_STATUS (
	DELIVERY_STATUS_ID	NUMBER(2) NOT NULL,
	STATUS_DESC		VARCHAR2(50) NOT NULL,
	CHAN_TYPE_ID		NUMBER(3) NOT NULL
)
	TABLESPACE &ts_pv_sys
;

CREATE UNIQUE INDEX XPKDELIVERY_STATUS ON DELIVERY_STATUS 
(
	DELIVERY_STATUS_ID 	ASC
)
	TABLESPACE &ts_pv_ind
;

ALTER TABLE DELIVERY_STATUS
	ADD (PRIMARY KEY (DELIVERY_STATUS_ID )
	USING INDEX
		TABLESPACE &ts_pv_ind );

insert into delivery_status values (1, 'Accepted', 40);
insert into delivery_status values (2, 'Deleted', 40);
insert into delivery_status values (3, 'Delivered', 40);
insert into delivery_status values (4, 'Enroute', 40);
insert into delivery_status values (5, 'Expired', 40);
insert into delivery_status values (6, 'Rejected', 40);
insert into delivery_status values (7, 'Undeliverable', 40);
insert into delivery_status values (8, 'Unknown', 40);
insert into delivery_status values (9, 'Retrieved', 50);
insert into delivery_status values (10, 'Expired', 50);
insert into delivery_status values (11, 'Rejected', 50);
insert into delivery_status values (12, 'Unrecognised', 50);
insert into delivery_status values (13, 'Deferred', 50);
COMMIT;


CREATE TABLE EXPORT_HDR (
       EXPORT_ID            NUMBER(8) NOT NULL,
       FILENAME             VARCHAR2(255) NOT NULL,
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
       FILENAME             VARCHAR2(255) NOT NULL,
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
	OBJ_ID		ASC
)
	TABLESPACE &ts_pv_ind
;

CREATE TABLE IMPORT_OBJ_MAP (
       IMPORT_ID            NUMBER(8) NOT NULL,
       OBJ_TYPE_ID          NUMBER(3) NOT NULL,
       OBJ_ID               NUMBER(8) NOT NULL,
       OBJ_SUB_ID           NUMBER(6) NOT NULL,
       ORIGIN_OBJ_ID        NUMBER(8) NOT NULL,
       ORIGIN_OBJ_SUB_ID    NUMBER(6) NULL
)
    	 TABLESPACE &ts_pv_sys
;


CREATE UNIQUE INDEX XPKIMPORT_OBJ_MAP ON IMPORT_OBJ_MAP
(
	IMPORT_ID	ASC,
	OBJ_TYPE_ID	ASC,
	OBJ_ID		ASC,
	OBJ_SUB_ID	ASC
)
	TABLESPACE &ts_pv_ind
;

ALTER TABLE IMPORT_OBJ_MAP
       ADD  ( PRIMARY KEY (IMPORT_ID, OBJ_TYPE_ID, OBJ_ID, OBJ_SUB_ID)
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



CREATE OR REPLACE VIEW PV_SESSION_ROLES (ROLE) AS
	SELECT ROLE 
	FROM SESSION_ROLES;

CREATE OR REPLACE VIEW RES_REV_COST (CAMP_ID, RES_MODEL_DET_ID, RES_MODEL_ID, PAR_DET_ID, PAR_OBJ_TYPE_ID, PAR_OBJ_ID, PAR_OBJ_SUB_ID, NO_STREAMS, AVG_REV_PER_RES, AVG_COST_PER_RES)  AS
       SELECT max(crmpardet.camp_id), max(crmdet.det_id), max(crmdet.obj_id), max(crmpardet.det_id), max(crmpardet.obj_type_id), max(crmpardet.obj_id), max(crmpardet.obj_sub_id), max(rsd.res_stream_id), sum((campresdet.proj_rev_per_res * (campresdet.proj_pctg_of_res/100))), sum((rc.inb_var_cost * (campresdet.proj_pctg_of_res/100)))
       FROM CAMP_DET crmdet, CAMP_DET crmpardet, CAMP_DET crsdet, RES_STREAM_DET rsd, RES_CHANNEL rc, CAMP_RES_DET campresdet
       WHERE crmdet.camp_id = crmpardet.camp_id
and crmdet.par_det_id = crmpardet.det_id
and crsdet.camp_id = crmdet.camp_id
and crsdet.par_det_id = crmdet.det_id
and campresdet.camp_id = crsdet.camp_id
and campresdet.det_id = crsdet.det_id
and rsd.res_model_id = crsdet.obj_id
and rsd.res_stream_id = crsdet.obj_sub_id
and rsd.seg_type_id = campresdet.seg_type_id
and rsd.seg_id = campresdet.seg_id
and rsd.res_channel_id = rc.res_channel_id (+)
and crmdet.obj_type_id = 19
       GROUP BY crmpardet.camp_id, crmpardet.det_id;

CREATE OR REPLACE VIEW CAMP_STATUS (CAMP_ID, STATUS_SETTING_ID, STATUS_NAME)  AS
       SELECT CSH.CAMP_ID, SS.STATUS_SETTING_ID, SS.STATUS_NAME
       FROM CAMP_STATUS_HIST CSH, STATUS_SETTING SS
       WHERE CSH.STATUS_SETTING_ID = SS.STATUS_SETTING_ID AND CSH.CAMP_HIST_SEQ = (SELECT MAX(CAMP_HIST_SEQ) FROM CAMP_STATUS_HIST WHERE CAMP_ID = CSH.CAMP_ID);

CREATE OR REPLACE VIEW TREAT_SEG_COUNT (CAMP_ID, PAR_DET_ID, SEG_COUNT)  AS
       SELECT CAMP_DET.CAMP_ID, CAMP_DET.PAR_DET_ID, COUNT(CAMP_ID)
       FROM CAMP_DET
       WHERE OBJ_TYPE_ID IN (1, 2, 4, 27, 28, 29)
       GROUP BY CAMP_ID, PAR_DET_ID;

CREATE OR REPLACE VIEW TREAT_SEG_COST (CAMP_ID, TREAT_DET_ID, TREAT_FIXED_COST, TREAT_SEG_COUNT, COST_PER_SEG)  AS
       SELECT DISTINCT TREAT_FIXED_COST.CAMP_ID, TREAT_FIXED_COST.DET_ID, SUM(TREAT_FIXED_COST.FIXED_COST), MAX(TREAT_SEG_COUNT.SEG_COUNT), SUM(TREAT_FIXED_COST.FIXED_COST)/MAX(TREAT_SEG_COUNT.SEG_COUNT)
       FROM TREAT_FIXED_COST, TREAT_SEG_COUNT
       WHERE TREAT_FIXED_COST.CAMP_ID = TREAT_SEG_COUNT.CAMP_ID AND
TREAT_FIXED_COST.DET_ID = TREAT_SEG_COUNT.PAR_DET_ID
       GROUP BY TREAT_FIXED_COST.CAMP_ID, TREAT_FIXED_COST.DET_ID;

CREATE OR REPLACE VIEW CAMP_SEG_COUNT (CAMP_ID, SEG_COUNT)  AS
       SELECT DISTINCT CAMP_DET.CAMP_ID, COUNT(OBJ_ID)
       FROM CAMP_DET
       WHERE OBJ_TYPE_ID IN (1, 2, 4, 27, 28, 29, 21)
       GROUP BY CAMP_ID;

CREATE OR REPLACE VIEW CAMP_SEG_COST (CAMP_ID, CAMP_FIXED_COST, CAMP_SEG_COUNT, COST_PER_SEG)  AS
       SELECT DISTINCT CAMP_FIXED_COST.CAMP_ID, SUM(CAMP_FIXED_COST.FIXED_COST), MAX(CAMP_SEG_COUNT.SEG_COUNT), SUM(CAMP_FIXED_COST.FIXED_COST)/MAX(CAMP_SEG_COUNT.SEG_COUNT)
       FROM CAMP_FIXED_COST, CAMP_SEG_COUNT
       WHERE CAMP_FIXED_COST.CAMP_ID = CAMP_SEG_COUNT.CAMP_ID
       GROUP BY CAMP_FIXED_COST.CAMP_ID;

CREATE OR REPLACE VIEW CAMP_SEG_DET 
(CAMP_ID, DET_ID, OBJ_TYPE_ID, OBJ_ID, OBJ_SUB_ID, PAR_DET_ID, NAME, VERSION_ID) 
AS SELECT c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id
from camp_det c, seg_hdr s where c.obj_type_id = 1 and c.obj_type_id   = s.seg_type_id and c.obj_id = s.seg_id    
UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id,    c.obj_sub_id, c.par_det_id, s.seg_name, c.version_id    
from camp_det c, seg_hdr s  where c.obj_type_id = 21 and s.seg_type_id = 1 and c.obj_id = s.seg_id and c.obj_sub_id = 0    
UNION    select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id,    
t.tree_name || ' [' || d.tree_seq || '] ' || d.node_name, c.version_id    from camp_det c, tree_hdr t, 
tree_det d  where c.obj_type_id = 4 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and c.obj_sub_id = d.tree_seq 
UNION select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, 
t.tree_name || ' [' || d.tree_seq || '] ' || d.node_name, c.version_id    
from camp_det c, tree_hdr t, tree_det d where c.obj_type_id = 21 and c.obj_id = t.tree_id and 
c.obj_id = d.tree_id and  c.obj_sub_id = d.tree_seq;

CREATE OR REPLACE VIEW OUTB_PROJECTION (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, 
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
 GROUP BY csdet.camp_id, csdet.det_id, csdet.version_id;

CREATE OR REPLACE VIEW USER_ACCESS_PROF (USER_ID, VIEW_ID, MODULE_ID, USER_GRP_ID,
ALL_ACCESS_ID, GRP_ACCESS_ID, USER_ACCESS_ID, COPY_OBJ_FLG, 
COPY_FROM_CDV_FLG, COPY_TO_CDV_FLG) AS SELECT U.USER_ID, X.VIEW_ID,
X.MODULE_ID, X.USER_GRP_ID, X.ALL_ACCESS_ID, X.GRP_ACCESS_ID, 
X.USER_ACCESS_ID, X.COPY_OBJ_FLG, V.COPY_FROM_CDV_FLG, V.COPY_TO_CDV_FLG FROM USER_DEFINITION U, USER_GRP_ACCESS X, 
CDV_ACCESS V WHERE X.VIEW_ID = V.VIEW_ID AND X.USER_GRP_ID = U.USER_GRP_ID AND U.USER_ID NOT IN (SELECT E.USER_ID FROM USER_ACCESS_EXCEP E WHERE VIEW_ID = X.VIEW_ID AND MODULE_ID = X.MODULE_ID) 
UNION SELECT E.USER_ID, E.VIEW_ID, E.MODULE_ID, U.USER_GRP_ID, E.ALL_ACCESS_ID, E.GRP_ACCESS_ID, E.USER_ACCESS_ID, E.COPY_OBJ_FLG, V.COPY_FROM_CDV_FLG, V.COPY_TO_CDV_FLG FROM USER_ACCESS_EXCEP E, USER_DEFINITION U, CDV_ACCESS V WHERE E.USER_ID = U.USER_ID AND E.VIEW_ID = V.VIEW_ID
;

CREATE OR REPLACE VIEW VANTAGE_ALL_TAB (VIEW_ID, VANTAGE_ALIAS, VANTAGE_NAME, CUST_TAB_GRP_ID, TAB_DISPLAY_SEQ,  OBJ_TYPE_ID, VANTAGE_TYPE, ALT_JOIN_SRC, DB_ENT_NAME, DB_ENT_OWNER, DB_VIEW_BASE_TAB, DB_REMOTE_STRING, STD_JOIN_FLG, STD_JOIN_FROM_COL, STD_JOIN_TO_COL, PAR_VANTAGE_ALIAS, COL_DISPLAY, DISPLAY_FLG ) AS
	SELECT CUST_TAB.VIEW_ID, CUST_TAB.VANTAGE_ALIAS, CUST_TAB.VANTAGE_NAME, CUST_TAB.CUST_TAB_GRP_ID, CUST_TAB.TAB_DISPLAY_SEQ, 0 OBJ_TYPE_ID, CUST_TAB.VANTAGE_TYPE, CUST_TAB.ALT_JOIN_SRC, CUST_TAB.DB_ENT_NAME, CUST_TAB.DB_ENT_OWNER, CUST_TAB.DB_VIEW_BASE_TAB, CUST_TAB.DB_REMOTE_STRING, CUST_TAB.STD_JOIN_FLG, CUST_TAB.STD_JOIN_FROM_COL, CUST_TAB.STD_JOIN_TO_COL, CUST_TAB.PAR_VANTAGE_ALIAS, CUST_TAB.COL_DISPLAY, CUST_TAB.DISPLAY_FLG
	FROM CUST_TAB 
UNION SELECT VANTAGE_DYN_TAB.VIEW_ID, VANTAGE_DYN_TAB.VANTAGE_ALIAS, VANTAGE_DYN_TAB.VANTAGE_NAME, VANTAGE_DYN_TAB.CUST_TAB_GRP_ID, 0 TAB_DISPLAY_SEQ, VANTAGE_DYN_TAB.OBJ_TYPE_ID, VANTAGE_DYN_TAB.VANTAGE_TYPE, VANTAGE_DYN_TAB.ALT_JOIN_SRC,  VANTAGE_DYN_TAB.DB_ENT_NAME, VANTAGE_DYN_TAB.DB_ENT_OWNER, VANTAGE_DYN_TAB.DB_VIEW_BASE_TAB,VANTAGE_DYN_TAB.DB_REMOTE_STRING, VANTAGE_DYN_TAB.STD_JOIN_FLG, VANTAGE_DYN_TAB.STD_JOIN_FROM_COL,  VANTAGE_DYN_TAB.STD_JOIN_TO_COL,  VANTAGE_DYN_TAB.PAR_VANTAGE_ALIAS, VANTAGE_DYN_TAB.COL_DISPLAY, VANTAGE_DYN_TAB.DISPLAY_FLG
	FROM VANTAGE_DYN_TAB;

CREATE OR REPLACE VIEW PV_COLS ( TABLE_OWNER, COLUMN_NAME,TABLE_NAME, DATA_TYPE, DATA_SCALE, DATA_PRECISION, DATA_LENGTH, COLUMN_ID, EQUIV_TYPE, DEFINED_PRECISION, NULLABLE) AS
	SELECT OWNER, COLUMN_NAME, TABLE_NAME, DATA_TYPE, NVL( DATA_SCALE,0 ), NVL( DATA_PRECISION,0 ), DATA_LENGTH, COLUMN_ID, DECODE( DATA_TYPE, 'VARCHAR2', 'CHAR', DATA_TYPE), DECODE( DATA_SCALE, NULL, 'N', 'Y' ), NULLABLE 
	FROM ALL_TAB_COLUMNS;

CREATE OR REPLACE VIEW PV_TABS ( TABLE_OWNER, TABLE_NAME, NUM_ROWS ) AS
	SELECT OWNER, TABLE_NAME, NUM_ROWS
	FROM ALL_TABLES;

CREATE OR REPLACE VIEW PV_IND (TABLE_OWNER, INDEX_OWNER, TABLE_NAME, INDEX_NAME, IS_UNIQUE, LAST_ANALYZED) AS
        SELECT TABLE_OWNER, OWNER, TABLE_NAME, INDEX_NAME, DECODE( UNIQUENESS, 'UNIQUE', 'Y', 'N' ), LAST_ANALYZED
        FROM ALL_INDEXES;

CREATE OR REPLACE VIEW PV_IND_COLS ( TABLE_OWNER, INDEX_OWNER, TABLE_NAME, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION ) AS
	SELECT TABLE_OWNER, INDEX_OWNER, TABLE_NAME, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION
	FROM ALL_IND_COLUMNS;

CREATE OR REPLACE  VIEW PV_VIEWS (VIEW_OWNER, VIEW_NAME)  AS
	SELECT OWNER, VIEW_NAME
	FROM ALL_VIEWS;

CREATE OR REPLACE VIEW inb_projection 
(camp_id, seg_det_id, seg_type_id, seg_id, seg_sub_id, avg_rev_per_res, avg_cost_per_res) 
AS SELECT camp_id, 
par_det_id,
par_obj_type_id,
par_obj_id,
par_obj_sub_id,
avg_rev_per_res,
avg_cost_per_res
FROM res_rev_cost
WHERE par_obj_type_id in (1,4)
UNION
SELECT
rrc.camp_id,
cseg.det_id,
cseg.obj_type_id,
cseg.obj_id,
cseg.obj_sub_id,
rrc.avg_rev_per_res,
rrc.avg_cost_per_res
FROM res_rev_cost rrc, camp_det cseg
WHERE rrc.par_det_id = cseg.par_det_id (+)
and rrc.camp_id = cseg.camp_id (+)
and rrc.par_obj_type_id = 18
and cseg.obj_type_id in (1,4)
;

CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_TREAT_QTY, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(treat_qty), sum(comm_qty), sum(total_cost), max(camp_cyc)
       FROM CAMP_COMM_OUT_HDR
       WHERE COMM_STATUS_ID in (0,1)
       GROUP BY camp_id, det_id;

CREATE OR REPLACE VIEW CAMP_COMM_INB_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_IN_HDR.CAMP_ID, CAMP_COMM_IN_HDR.PAR_COMM_DET_ID, sum(comm_qty), sum(total_cost), sum(total_revenue), max(camp_cyc)
       FROM CAMP_COMM_IN_HDR
       WHERE COMM_STATUS_ID in (0,1)
       GROUP BY camp_id, par_comm_det_id;

CREATE OR REPLACE VIEW CAMP_ANALYSIS (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, CAMP_NO_OF_CYCLES, TREATMENT_ID, TREATMENT_NAME, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, PROJ_OUT_CYC_QTY, PROJ_OUT_QTY, PROJ_INB_CYC_QTY, PROJ_INB_QTY, PROJ_RES_RATE, PROJ_OUT_CYC_VCOST, PROJ_OUT_VCOST, PROJ_INB_CYC_VCOST, PROJ_INB_VCOST, PROJ_INB_CYC_REV, PROJ_INB_REV, SEG_ACT_TREAT_QTY, SEG_ACT_OUT_QTY, SEG_ACT_OUT_VCOST, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, VERSION_ID, VERSION_NAME)  AS
       SELECT outbp.STRATEGY_ID, outbp.STRATEGY_NAME, outbp.CAMP_GRP_ID, outbp.CAMP_GRP_NAME, outbp.CAMP_ID, outbp.CAMP_CODE, outbp.CAMP_NAME, outbp.CAMP_STATUS, outbp.CAMP_TEMPLATE, outbp.CAMP_TYPE, outbp.CAMP_MANAGER, outbp.BUDGET_MANAGER, to_number(decode(outbp.CAMP_FIXED_COST,0,NULL,outbp.CAMP_FIXED_COST)), outbp.CAMP_START_DATE, outbc.CAMP_NO_OF_CYCLES, outbp.TREATMENT_ID, outbp.TREATMENT_NAME, to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)), to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), outbp.TREAT_CHAN, outbp.SEG_TYPE_ID, outbp.SEG_ID, outbp.SEG_SUB_ID, outbp.SEG_NAME, outbp.SEG_KEYCODE, outbp.SEG_CONTROL_FLG, to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)), to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles, 0, null,outbp.seg_proj_qty * outbc.camp_no_of_cycles)), to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)), to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_res * outbc.camp_no_of_cycles)), to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL,outbp.SEG_PROJ_RES_RATE)), to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL,outbp.SEG_PROJ_VAR_COST)), to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0,null,outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)), to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,null,inbp.avg_cost_per_res * outbp.seg_proj_res)), to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,null,inbp.avg_rev_per_res * outbp.seg_proj_res)), to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), to_number(decode(outbc.SEG_ACT_TREAT_QTY,0,NULL,outbc.SEG_ACT_TREAT_QTY)), to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,outbc.SEG_ACT_OUTB_QTY)), to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL,outbc.SEG_ACT_OUTB_VCOST)), to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)), to_number(decode(inbc.SEG_ACT_INB_VCOST, 0,NULL,inbc.SEG_ACT_INB_VCOST)), to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV)), outbp.VERSION_ID, outbp.VERSION_NAME
       FROM OUTB_PROJECTION outbp, INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc
       WHERE outbp.camp_id = inbp.camp_id (+)
and outbp.seg_det_id = inbp.seg_det_id (+)
and outbp.camp_id = outbc.camp_id (+)
and outbp.seg_det_id = outbc.seg_det_id (+)
and outbp.camp_id = inbc.camp_id (+)
and outbp.seg_det_id = inbc.seg_det_id (+);




create trigger TD_SEG_HDR
  AFTER DELETE
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TD_SEG_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if (:old.seg_grp_id is not null and :old.seg_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id
    and ref_indicator_id = 1 and obj_type_id = 73 and obj_id = :old.seg_grp_id 
    and obj_sub_id = :old.seg_type_id;
end if;   

select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
  ref_id = :old.seg_id and ref_indicator_id = 16;

if var_count > 0 then
   delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id 
     and ref_indicator_id = 16;
end if;

end;
/




create trigger TI_SEG_HDR
  AFTER INSERT
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TI_SEG_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.seg_grp_id is not null and :new.seg_grp_id <> 0) then
  /* check that the referenced segment group still exists */
  select seg_grp_id into var_id from seg_grp where seg_type_id = :new.seg_type_id and
    seg_grp_id = :new.seg_grp_id;

  insert into referenced_obj select 73, :new.seg_grp_id, :new.seg_type_id, null, null, null, null,
    :new.seg_type_id, :new.seg_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = :new.seg_type_id and ref_indicator_id = 1 
    and (obj_type_id = 73 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_SEG_HDR
  AFTER UPDATE OF 
        SEG_GRP_ID
  on SEG_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_SEG_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.seg_grp_id is not null and :old.seg_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id
    and ref_indicator_id = 1 and obj_type_id = 73 and obj_id = :old.seg_grp_id
    and obj_sub_id = :old.seg_type_id;
end if;  

if (:new.seg_grp_id is not null and :new.seg_grp_id <> 0) then
  /* check that the referenced segment group still exists */
  select seg_grp_id into var_id from seg_grp where seg_type_id = :new.seg_type_id and
    seg_grp_id = :new.seg_grp_id;

  insert into referenced_obj select 73, :new.seg_grp_id, :new.seg_type_id, null, null, null, null,
    :new.seg_type_id, :new.seg_id, null, null, null, 1, constraint_type_id from 
    constraint_setting where ref_type_id = :new.seg_type_id and ref_indicator_id = 1 
    and (obj_type_id = 73 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_GRP
  AFTER DELETE
  on CAMP_GRP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TD_CAMP_GRP */
declare numrows INTEGER;
begin
delete from referenced_obj where ref_type_id = 33 and ref_id = :old.camp_grp_id 
  and obj_type_id = 32 and obj_id = :old.strategy_id;
end;
/




create trigger TI_CAMP_GRP
  AFTER INSERT
  on CAMP_GRP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TI_CAMP_GRP */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* check referenced strategy exists */
select strategy_id into var_id from strategy where strategy_id = :new.strategy_id;

/* insert strategy reference */
insert into referenced_obj select 32, :new.strategy_id, null, null, null, null, null, 33, :new.camp_grp_id, null, null, null, 1, constraint_type_id
from constraint_setting where ref_type_id = 33 and ref_indicator_id = 1 and (obj_type_id = 32 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_GRP
  AFTER UPDATE OF 
        STRATEGY_ID
  on CAMP_GRP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMP_GRP */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* remove reference to old strategy */
delete from referenced_obj where ref_type_id = 33 and ref_id = :old.camp_grp_id 
  and obj_type_id = 32 and obj_id = :old.strategy_id;

/* check new strategy exists */
select strategy_id into var_id from strategy where strategy_id = :new.strategy_id;

/* insert reference to new strategy */
insert into referenced_obj select 32, :new.strategy_id, null, null, null, null, null, 33, :new.camp_grp_id, null, null, null, 1, constraint_type_id
from constraint_setting where ref_type_id = 33 and ref_indicator_id = 1 and (obj_type_id = 32 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMPAIGN
  AFTER DELETE
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TD_CAMPAIGN */
declare numrows INTEGER;
begin
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
   and obj_type_id = 33 and obj_id = :old.camp_grp_id and ref_indicator_id = 1; 

if (:old.camp_type_id is not null and :old.camp_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = 37 and obj_id = :old.camp_type_id and ref_indicator_id = 1; 
end if;
end;
/



create trigger TI_CAMPAIGN
  AFTER INSERT
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TI_CAMPAIGN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced Campaign Group exists */
select camp_grp_id into var_id from camp_grp where camp_grp_id = :new.camp_grp_id;

/* insert reference to Campaign Group */
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 1, constraint_type_id
from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 33 or obj_type_id is null);

/* insert reference to Campaign Type (optional) */
if (:new.camp_type_id is not null and :new.camp_type_id <> 0) then
    /* check referenced Campaign Type exists */
    select camp_type_id into var_id from camp_type where camp_type_id = :new.camp_type_id;
    
    insert into referenced_obj select 37, :new.camp_type_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 37 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMPAIGN_GRP
  AFTER UPDATE OF 
        CAMP_GRP_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMPAIGN_GRP */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old campaign group */
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
  and obj_type_id = 33 and obj_id = :old.camp_grp_id and ref_indicator_id = 1; 

/* check new referenced campaign group exists */
select camp_grp_id into var_id from camp_grp where camp_grp_id = :new.camp_grp_id;

/* insert reference to new budget manager */
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null, 
  24,:new.camp_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
  and (obj_type_id = 33 or obj_type_id is null);


EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMPAIGN_TYPE
  AFTER UPDATE OF 
        CAMP_TYPE_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMPAIGN_TYPE */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old campaign type, if given */
if (:old.camp_type_id is not null and :old.camp_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
     and obj_type_id = 37 and obj_id = :old.camp_type_id and ref_indicator_id = 1; 
end if;

/* check new referenced campaign type exists, if given */
if (:new.camp_type_id is not null and :new.camp_type_id <> 0) then
  select camp_type_id into var_id from camp_type where camp_type_id = :new.camp_type_id;

  insert into referenced_obj select 37, :new.camp_type_id, null, null, null, null, null,
    24,:new.camp_id, null, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
    and (obj_type_id = 37 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_VERSION
  AFTER DELETE
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TD_CAMP_VERSION */
declare numrows INTEGER;
        var_id INTEGER;
begin

if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id and ref_indicator_id = 1; 
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TI_CAMP_VERSION
  AFTER INSERT
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TI_CAMP_VERSION */
declare numrows INTEGER;
        var_id INTEGER;
begin

/* insert reference to Manager (optional) */
if (:new.manager_id is not null and :new.manager_id <> 0) then
  /* check referenced Campaign Manager exists */
  select manager_id into var_id from camp_manager where manager_id = :new.manager_id;

  insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1
    and (obj_type_id = 36 or obj_type_id is null);
end if;

/* insert reference to Budget Manager (optional) */

if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
  /* check referenced budget Manager exists */
  select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;

  insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 4, constraint_type_id 
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 
    and (obj_type_id = 36 or obj_type_id is null);
end if;

/* insert reference to segment (optional) */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
   /* check referenced segment exists */
   select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id 
   and seg_id = :new.web_filter_id;

   insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,
     24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
     and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_VER_BMAN
  AFTER UPDATE OF 
        BUDGET_MANAGER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMP_VER_BMAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* remove reference to old budget manager, if given */
if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
      and ref_sub_id = :old.version_id and ref_det_id is null
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

/* check new referenced budget manager exists, if given */
if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
    select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;

    insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, null, null, 4, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 
      and (obj_type_id = 36 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_VER_CMAN
  AFTER UPDATE OF 
        MANAGER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMP_VER_CMAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* remove reference to old manager, if given */
if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
     and ref_sub_id = :old.version_id and ref_det_id is null
     and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

/* check new referenced manager exists, if given */
if (:new.manager_id is not null and :new.manager_id <> 0) then
  select manager_id into var_id from camp_manager where manager_id = :new.manager_id;

  insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,
     24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
     and (obj_type_id = 36 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_VER_WEBSEG
  AFTER UPDATE OF 
        WEB_FILTER_TYPE_ID,
        WEB_FILTER_ID
  on CAMP_VERSION
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:15 2002 */
/* default body for TU_CAMP_VER_WEBSEG */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old web segment, if given */
if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
     and ref_sub_id = :old.version_id and ref_det_id is null 
     and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id 
     and ref_indicator_id = 1; 
end if;

/* check new referenced web segment exists, if given */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
  select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id 
    and seg_id = :new.web_filter_id;

  insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 
    and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_SEED_LIST_HDR
  AFTER DELETE
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_SEED_LIST_HDR */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 14 and ref_id = :old.seed_list_id 
  and ref_indicator_id = 1 and obj_type_id = 76 and obj_id = :old.seed_list_grp_id; 

end;
/




create trigger TI_SEED_LIST_HDR
  AFTER INSERT
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SEED_LIST_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select seed_list_grp_id into var_id from seed_list_grp where seed_list_grp_id = :new.seed_list_grp_id;

insert into referenced_obj select 76, :new.seed_list_grp_id, null, null, null, null, null, 
  14, :new.seed_list_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 14 and ref_indicator_id = 1 and 
  (obj_type_id = 76 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_SEED_LIST_HDR
  AFTER UPDATE OF 
        SEED_LIST_GRP_ID
  on SEED_LIST_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SEED_LIST_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 14 and ref_id = :old.seed_list_id 
  and ref_indicator_id = 1 and obj_type_id = 76 and obj_id = :old.seed_list_grp_id; 

/* check referenced object still exists */
select seed_list_grp_id into var_id from seed_list_grp where seed_list_grp_id = :new.seed_list_grp_id;

insert into referenced_obj select 76, :new.seed_list_grp_id, null, null, null, null, null, 14, :new.seed_list_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 14 and ref_indicator_id = 1 and (obj_type_id = 76 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TD_DELIVERY_CHAN
  AFTER DELETE
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DELIVERY_CHAN */
declare numrows INTEGER;

begin

if :old.dft_ext_templ_id <> 0 then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 12 and obj_id = :old.dft_ext_templ_id;
end if;

if (:old.forward_server_id is not null and :old.forward_server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.forward_server_id;
end if;

end;
/



create trigger TI_DELIVERY_CHAN
  AFTER INSERT
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DELIVERY_CHAN */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.dft_ext_templ_id <> 0 then
  /* check that referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.dft_ext_templ_id;
  
  insert into referenced_obj select 12, :new.dft_ext_templ_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 12 or obj_type_id is null);
end if;

if (:new.forward_server_id is not null and :new.forward_server_id <> 0) then
  /* check that referenced FORWARD EMAIL SERVER still exists */
  select server_id into var_id from email_server where server_id = :new.forward_server_id;
  
  insert into referenced_obj select 61, :new.forward_server_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 61 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_DELIVERY_CHAN_E
  AFTER UPDATE OF 
        DFT_EXT_TEMPL_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DELIVERY_CHAN_E */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.dft_ext_templ_id <> 0 then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 12 and obj_id = :old.dft_ext_templ_id;
end if;

if :new.dft_ext_templ_id <> 0 then
  /* check that referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.dft_ext_templ_id;
  
  insert into referenced_obj select 12, :new.dft_ext_templ_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 12 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DELIVERY_CHAN_FS
  AFTER UPDATE OF 
        FORWARD_SERVER_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DELIVERY_CHAN_FS */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.forward_server_id is not null and :old.forward_server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.forward_server_id;
end if;

if (:new.forward_server_id is not null and :new.forward_server_id <> 0) then
  /* check that referenced FORWARD EMAIL SERVER still exists */
  select server_id into var_id from email_server where server_id = :new.forward_server_id;
  
  insert into referenced_obj select 61, :new.forward_server_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 61 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TD_CAMP_OUT_DET
  AFTER DELETE
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:00:56 2002 */
/* default body for TD_CAMP_OUT_DET */
declare numrows INTEGER;
        var_chan_type_id INTEGER;        

begin

if :old.chan_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
    and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
    obj_type_id = 11 and obj_id = :old.chan_id;
end if;

if (:old.ext_templ_id is not null and :old.ext_templ_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 12 and obj_id = :old.ext_templ_id;
end if;

if (:old.seed_list_id is not null and :old.seed_list_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 14 and obj_id = :old.seed_list_id;
end if;

select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
    if ( var_chan_type_id = 30 ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id       
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
        obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
        obj_type_id = 97 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
end if;

if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   if ( var_chan_type_id = 30 ) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
        obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then 
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
        and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
        obj_type_id = 97 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
end if;

end;
/



create trigger TI_CAMP_OUT_DET
  AFTER INSERT
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:01:10 2002 */
/* default body for TI_CAMP_OUT_DET */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
 
begin

if :new.chan_id <> 0 then
  /* check referenced delivery channel still exists */
  select chan_id into var_id from delivery_chan where chan_id = :new.chan_id;

  insert into referenced_obj select 11, :new.chan_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 11 or obj_type_id is null);
end if;

if (:new.ext_templ_id is not null and :new.ext_templ_id <> 0) then
  /* check referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.ext_templ_id;

  insert into referenced_obj select 12, :new.ext_templ_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 12 or obj_type_id is null);
end if;

if (:new.seed_list_id is not null and :new.seed_list_id <> 0) then
  /* check referenced seed list still exists */
  select seed_list_id into var_id from seed_list_hdr where seed_list_id = :new.seed_list_id;

  insert into referenced_obj select 14, :new.seed_list_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 14 or obj_type_id is null);
end if;

select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  if ( var_chan_type_id = 30 ) then
     /* check referenced from email mailbox still exists */
     select server_id into var_id from email_mailbox where server_id = :new.from_server_id
       and mailbox_id = :new.from_mailbox_id;

     insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
       and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
     /* check referenced from wireless inbox still exists */
     select server_id into var_id from wireless_inbox where server_id = :new.from_server_id
        and inbox_id = :new.from_mailbox_id;
     
     insert into referenced_obj select 97, :new.from_server_id, :new.from_mailbox_id, null, null, null, null,
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
       and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  /* check referenced reply mailbox still exists */
  if ( var_chan_type_id = 30 ) then
     select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
       and mailbox_id = :new.reply_mailbox_id;

     insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
       and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
     select server_id into var_id from wireless_inbox where server_id = :new.reply_server_id
       and inbox_id = :new.reply_mailbox_id;

     insert into referenced_obj select 97, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null,
       24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27,
       constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
       and (obj_type_id = 97 or obj_type_id is null);                
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/





create trigger TU_CAMP_OUT_DET_DC
  AFTER UPDATE OF 
        CHAN_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_OUT_DET_DC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.chan_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
    and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
    obj_type_id = 11 and obj_id = :old.chan_id;
end if;

if :new.chan_id <> 0 then
  /* check referenced delivery channel still exists */
  select chan_id into var_id from delivery_chan where chan_id = :new.chan_id;

  insert into referenced_obj select 11, :new.chan_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 11 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_OUT_DET_ET
  AFTER UPDATE OF 
        EXT_TEMPL_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_OUT_DET_ET */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.ext_templ_id is not null and :old.ext_templ_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 12 and obj_id = :old.ext_templ_id;
end if;

if (:new.ext_templ_id is not null and :new.ext_templ_id <> 0) then
  /* check referenced extract template still exists */
  select ext_templ_id into var_id from ext_templ_hdr where ext_templ_id = :new.ext_templ_id;

  insert into referenced_obj select 12, :new.ext_templ_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 12 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_OUT_DET_FM
  AFTER UPDATE OF 
        FROM_SERVER_ID,
        FROM_MAILBOX_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:01:20 2002 */
/* default body for TU_CAMP_OUT_DET_FM */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
begin

if ((:old.from_server_id is not null and :old.from_mailbox_id is not null) and 
    (:old.from_server_id <> 0 and :old.from_mailbox_id <> 0 )) then
   select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;

   if (var_chan_type_id = 30 ) then  
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
       obj_type_id = 62 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
   if (var_chan_type_id in (40,50) ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 26 and
       obj_type_id = 97 and obj_id = :old.from_server_id and obj_sub_id = :old.from_mailbox_id;
   end if;
end if;

if ((:new.from_server_id is not null and :new.from_mailbox_id is not null) and 
    (:new.from_server_id <> 0 and :new.from_mailbox_id <> 0)) then
  select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;
  if ( var_chan_type_id = 30 ) then
    /* check referenced from email mailbox still exists */
    select server_id into var_id from email_mailbox where server_id = :new.from_server_id
      and mailbox_id = :new.from_mailbox_id; 

    insert into referenced_obj select 62, :new.from_server_id, :new.from_mailbox_id, null, null, null, null, 
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26, 
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
      and (obj_type_id = 62 or obj_type_id is null);
  end if;

  if ( var_chan_type_id in (40,50) ) then
    /* check referenced from wireless inbox still exists */
    select server_id into var_id from wireless_inbox where server_id = :new.from_server_id
      and inbox_id = :new.from_mailbox_id;

    insert into referenced_obj select 97, :new.from_server_id, :new.from_mailbox_id, null, null, null, null,
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 26,
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 26
      and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

end;
/



create trigger TU_CAMP_OUT_DET_RM
  AFTER UPDATE OF 
        REPLY_SERVER_ID,
        REPLY_MAILBOX_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Tue Nov 12 17:01:30 2002 */
/* default body for TU_CAMP_OUT_DET_RM */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type_id INTEGER;
begin
if ((:old.reply_server_id is not null and :old.reply_mailbox_id is not null) and 
    (:old.reply_server_id <> 0 and :old.reply_mailbox_id <> 0 )) then
   select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :old.chan_id;
   if ( var_chan_type_id = 30 ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
       obj_type_id = 62 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
   if ( var_chan_type_id in (40,50) ) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id 
       and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 27 and
       obj_type_id = 97 and obj_id = :old.reply_server_id and obj_sub_id = :old.reply_mailbox_id;
   end if;
end if;

if ((:new.reply_server_id is not null and :new.reply_mailbox_id is not null) and 
    (:new.reply_server_id <> 0 and :new.reply_mailbox_id <> 0)) then
  select chan_type_id into var_chan_type_id from delivery_chan where chan_id = :new.chan_id;
  if ( var_chan_type_id = 30 ) then
    /* check referenced reply email mailbox still exists */
    select server_id into var_id from email_mailbox where server_id = :new.reply_server_id
      and mailbox_id = :new.reply_mailbox_id;

    insert into referenced_obj select 62, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null, 
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27, 
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
      and (obj_type_id = 62 or obj_type_id is null);
  end if;
  if ( var_chan_type_id in (40,50) ) then
    /* check referenced reply wireless inbox still exists */
    select server_id into var_id from wireless_inbox where server_id = :new.reply_server_id
      and inbox_id = :new.reply_mailbox_id;

    insert into referenced_obj select 97, :new.reply_server_id, :new.reply_mailbox_id, null, null, null, null,
      24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 27,
      constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 27
      and (obj_type_id = 97 or obj_type_id is null);
  end if;
end if;

end;
/



create trigger TU_CAMP_OUT_DET_SL
  AFTER UPDATE OF 
        SEED_LIST_ID
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_OUT_DET_SL */
declare numrows INTEGER;
        var_id INTEGER;
begin

if (:old.seed_list_id is not null and :old.seed_list_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_out_grp_id
     and ref_det_id = :old.camp_out_det_id and ref_sub_det_id = :old.split_seq and ref_indicator_id = 21 and
     obj_type_id = 14 and obj_id = :old.seed_list_id;
end if;

if (:new.seed_list_id is not null and :new.seed_list_id <> 0) then
  /* check referenced delivery channel still exists */
  select seed_list_id into var_id from seed_list_hdr where seed_list_id = :new.seed_list_id;

  insert into referenced_obj select 14, :new.seed_list_id, null, null, null, null, null, 
    24, :new.camp_id, :new.camp_out_grp_id, :new.camp_out_det_id, :new.split_seq, 21, 
    constraint_type_id from constraint_setting where ref_type_id = 24 and ref_indicator_id = 21
    and (obj_type_id = 14 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_TREATMENT
  AFTER DELETE
  on TREATMENT
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TREATMENT */
declare numrows INTEGER;

begin
delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and obj_type_id = 41 and obj_id = :old.treatment_grp_id;
end;
/




create trigger TI_TREATMENT
  AFTER INSERT
  on TREATMENT
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TREATMENT */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check that referenced object still exists */
select treatment_grp_id into var_id from treatment_grp where treatment_grp_id = :new.treatment_grp_id;

insert into REFERENCED_OBJ select 41, :new.treatment_grp_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 41 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_TREATMENT
  AFTER UPDATE OF 
        TREATMENT_GRP_ID
  on TREATMENT
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREATMENT */
declare numrows INTEGER;
        var_id INTEGER; 
 
begin
delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and obj_type_id = 41 and obj_id = :old.treatment_grp_id;

/* check that referenced object still exists */
select treatment_grp_id into var_id from treatment_grp where treatment_grp_id = :new.treatment_grp_id;

insert into REFERENCED_OBJ select 41, :new.treatment_grp_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 41 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_DELIVERY_SERVER
  AFTER DELETE
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DELIVERY_SERVER */
declare numrows INTEGER;
        var_chan_type INTEGER;
begin

if (:old.server_id is not null and :old.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :old.chan_id;

  if (var_chan_type = 30) then /* Email Server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 61 and obj_id = :old.server_id;
  elsif (var_chan_type in (40,50)) then /* wireless server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 79 and obj_id = :old.server_id;
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TI_DELIVERY_SERVER
  AFTER INSERT
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DELIVERY_SERVER */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type INTEGER;
begin

if (:new.server_id is not null and :new.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :new.chan_id;

  if (var_chan_type = 30) then /* Email Server */
     select server_id into var_id from email_server where server_id = :new.server_id;

     insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 61 or obj_type_id is null);

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
     select server_id into var_id from wireless_server where server_id = :new.server_id;

     insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 79 or obj_type_id is null);   
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_DELIVERY_SERVER
  AFTER UPDATE OF 
        SERVER_ID
  on DELIVERY_SERVER
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DELIVERY_SERVER */
declare numrows INTEGER;
        var_id INTEGER;
        var_chan_type INTEGER;
begin

if (:old.server_id is not null and :old.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :old.chan_id;

  if (var_chan_type = 30) then /* Email Server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 61 and obj_id = :old.server_id;

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
    delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 28 and
      obj_type_id = 79 and obj_id = :old.server_id;
  end if;
end if;

if (:new.server_id is not null and :new.server_id <> 0) then
  /* find delivery server type */
  select chan_type_id into var_chan_type from delivery_chan where chan_id = :new.chan_id;

  if (var_chan_type = 30) then /* Email Server */
     select server_id into var_id from email_server where server_id = :new.server_id;

     insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 61 or obj_type_id is null);

  elsif (var_chan_type in (40,50)) then /* Wireless Server */
     select server_id into var_id from wireless_server where server_id = :new.server_id;

     insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
     11, :new.chan_id, null, null, null, 28, constraint_type_id from constraint_setting where 
     ref_type_id = 11 and ref_indicator_id = 28 and (obj_type_id = 79 or obj_type_id is null);   
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TD_ERES_RULE_HDR
  AFTER DELETE
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_ERES_RULE_HDR */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 69 and ref_id = :old.rule_id 
  and ref_indicator_id = 1 and obj_type_id = 81 and obj_id = :old.res_rule_grp_id; 

end;
/



create trigger TI_ERES_RULE_HDR
  AFTER INSERT
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_ERES_RULE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select res_rule_grp_id into var_id from eres_rule_grp where res_rule_grp_id = :new.res_rule_grp_id;

insert into referenced_obj select 81, :new.res_rule_grp_id, null, null, null, null, null, 
  69, :new.rule_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 69 and ref_indicator_id = 1 and 
  (obj_type_id = 81 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_ERES_RULE_HDR
  AFTER UPDATE OF 
        RES_RULE_GRP_ID
  on ERES_RULE_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_ERES_RULE_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 69 and ref_id = :old.rule_id 
  and ref_indicator_id = 1 and obj_type_id = 81 and obj_id = :old.res_rule_grp_id; 

/* check referenced object still exists */
select res_rule_grp_id into var_id from eres_rule_grp where res_rule_grp_id = :new.res_rule_grp_id;

insert into referenced_obj select 81, :new.res_rule_grp_id, null, null, null, null, null, 69, :new.rule_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 69 and ref_indicator_id = 1 and (obj_type_id = 81 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TD_WIRELESS_RES_RULE
  AFTER DELETE
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:43:21 2002 */
/* default body for TD_WIRELESS_RES_RULE */
declare numrows INTEGER;

begin

if :old.rule_id <> 0 then

  if (:old.global_rule_flg = 1) then
    delete from referenced_obj where ref_type_id = 0 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and ref_indicator_id = 1
      and obj_type_id = 69 and obj_id = :old.rule_id;
  else
    delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and ref_indicator_id = 1 
      and obj_type_id = 69 and obj_id = :old.rule_id;
  end if;

end if;

end;
/



create trigger TI_WIRELESS_RES_RULE
  AFTER INSERT
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:43:38 2002 */
/* default body for TI_WIRELESS_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  If ( :new.global_rule_flg = 1) then
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
       0, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id from
       constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
       (obj_type_id = 69 or obj_type_id is null);
  else
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
       97, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id from
       constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
       (obj_type_id = 69 or obj_type_id is null);
  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_WIRELESS_RES_RULE
  AFTER UPDATE OF 
        RULE_ID
  on WIRELESS_RES_RULE
  
  for each row
/* ERwin Builtin Wed Oct 23 15:44:04 2002 */
/* default body for TU_WIRELESS_RES_RULE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.rule_id <> 0 then
  if (:old.global_rule_flg = 1) then
    delete from referenced_obj where ref_type_id = 0 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and 
      ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
  else
    delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
      ref_sub_id = :old.inbox_id and ref_det_id = :old.chan_type_id and
      ref_indicator_id = 1 and obj_type_id = 69 and obj_id = :old.rule_id;
  end if;
end if;

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  if (:new.global_rule_flg = 1) then
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
      0, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id
      from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
      (obj_type_id = 69 or obj_type_id is null);
  else
    insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
      97, :new.server_id, :new.inbox_id, :new.chan_type_id, null, 1, constraint_type_id
      from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
      (obj_type_id = 69 or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_TREE_DET
  AFTER DELETE
  on TREE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TREE_DET */
declare numrows INTEGER;

begin

if (:old.origin_type_id is not null and :old.origin_type_id <> 0) then
  if :old.origin_type_id = 4 then   /* old linked object is a tree segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.tree_seq
       and ref_indicator_id = 3 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id and 
       obj_sub_id = :old.origin_sub_id;

  else   /* old linked object is a segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.tree_seq
       and ref_indicator_id = 3 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id;
  end if;
end if;

end;
/



create trigger TI_TREE_DET
  AFTER INSERT
  on TREE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TREE_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.origin_type_id is not null and :new.origin_type_id <> 0) then
  if :new.origin_type_id = 4 then   /* new linked object is tree segment */
    /* check that the referenced tree segment still exists */ 
    /* select tree_id into var_id from tree_det where tree_id = :new.origin_id and tree_seq = :new.origin_sub_id; */

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, :new.origin_sub_id, null, null, null, null,
      4, :new.tree_id, :new.tree_seq, null, null, 3, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 3 and (obj_type_id = :new.origin_type_id or obj_type_id is null);

  else   /* new linked object is a segment */
    /* check that the referenced segment still exists */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.origin_type_id and seg_id = :new.origin_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, null, null, null, null, null,
      4, :new.tree_id, :new.tree_seq, null, null, 3, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 3 and (obj_type_id = :new.origin_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_TREE_DET
  AFTER UPDATE OF 
        ORIGIN_TYPE_ID,
        ORIGIN_ID,
        ORIGIN_SUB_ID
  on TREE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREE_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.origin_type_id is not null and :old.origin_type_id <> 0) then
  if :old.origin_type_id = 4 then   /* old linked object is a tree segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.tree_seq
       and ref_indicator_id = 3 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id and 
       obj_sub_id = :old.origin_sub_id;

  else  /* old linked object is a segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.tree_seq
       and ref_indicator_id = 3 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id;
  end if;
end if;

if (:new.origin_type_id is not null and :new.origin_type_id <> 0) then
  if :new.origin_type_id = 4 then   /* new linked object is tree segment */
    /* check that the referenced tree segment still exists */ 
    /* select tree_id into var_id from tree_det where tree_id = :new.origin_id and tree_seq = :new.origin_sub_id; */

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, :new.origin_sub_id, null, null, null, null,
      4, :new.tree_id, :new.tree_seq, null, null, 3, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 3 and (obj_type_id = :new.origin_type_id or obj_type_id is null);

  else   /* new linked object is a segment */
    /* check that the referenced segment still exists */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.origin_type_id and seg_id = :new.origin_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, null, null, null, null, null,
      4, :new.tree_id, :new.tree_seq, null, null, 3, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 3 and (obj_type_id = :new.origin_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_CAMP_DET
  AFTER DELETE
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_DET */
declare numrows INTEGER;
begin

/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
  end if;
end if;

end;
/



create trigger TI_CAMP_DET
  AFTER INSERT
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.obj_type_id in (1,4,17,18,19,20,28,29) and :new.obj_id is not null and :new.obj_id <> 0) then
  /* check if referenced object still exists */
  if :new.obj_type_id = 18 then  /* treatment */
     select treatment_id into var_id from treatment where treatment_id = :new.obj_id;

  elsif :new.obj_type_id = 19 then  /* response model */
     select res_model_id into var_id from res_model_hdr where res_model_id = :new.obj_id;

  elsif :new.obj_type_id = 20 then  /* response stream */
     select res_stream_id into var_id from res_model_stream where res_model_id = :new.obj_id
       and res_stream_id = :new.obj_sub_id;

  elsif :new.obj_type_id = 17 then  /* task group */
     select spi_id into var_id from spi_master where spi_id = :new.obj_id;

  elsif :new.obj_type_id in (1,28,29) then  /* segment, web dynamic criteria or web session criteria */ 
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;

  elsif :new.obj_type_id = 4 then  /* tree segment */
     select tree_id into var_id from tree_det where tree_id = :new.obj_id and tree_seq = :new.obj_sub_id;

  end if;

  /* insert new reference details */
  if (:new.obj_sub_id is null or :new.obj_sub_id = 0) then
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_DET
  AFTER UPDATE OF 
        OBJ_TYPE_ID,
        OBJ_ID
  on CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
       and ref_det_id = :old.det_id and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id 
       and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
  end if;
end if;

/* check if referenced object still exists */
if :new.obj_type_id in (1,4,17,18,19,20,28,29) then
  /* check if referenced object still exists */
  if :new.obj_type_id = 18 then  /* treatment */
     select treatment_id into var_id from treatment where treatment_id = :new.obj_id;

  elsif :new.obj_type_id = 19 then  /* response model */
     select res_model_id into var_id from res_model_hdr where res_model_id = :new.obj_id;

  elsif :new.obj_type_id = 20 then  /* response stream */
     select res_stream_id into var_id from res_model_stream where res_model_id = :new.obj_id
       and res_stream_id = :new.obj_sub_id;

  elsif :new.obj_type_id = 17 then  /* task group */
     select spi_id into var_id from spi_master where spi_id = :new.obj_id;

  elsif :new.obj_type_id in (1,28,29) then  /* segment, web dynamic criteria or web session criteria */ 
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;

  elsif :new.obj_type_id = 4 then  /* tree segment */
     select tree_id into var_id from tree_det where tree_id = :new.obj_id and tree_seq = :new.obj_sub_id;

  end if;

  /* insert new reference details */
  if (:new.obj_sub_id is null or :new.obj_sub_id = 0) then
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.version_id, :new.det_id, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_RES_STREAM_DET
  AFTER DELETE
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_RES_STREAM_DET */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
  and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
  obj_type_id = :old.seg_type_id and obj_id = :old.seg_id;

if :old.res_channel_id <> 0 then
  delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
    and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
    obj_type_id = 35 and obj_id = :old.res_channel_id;
end if; 

if :old.res_type_id <> 0 then
  delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
    and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
    obj_type_id = 34 and obj_id = :old.res_type_id;
end if; 

end;
/




create trigger TI_RES_STREAM_DET
  AFTER INSERT
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_RES_STREAM_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check that referenced segment still exists */
select seg_id into var_id from seg_hdr where seg_type_id = :new.seg_type_id and seg_id = :new.seg_id;

insert into referenced_obj select :new.seg_type_id, :new.seg_id, null, null, null, null, null,
  19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
  from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and 
  (obj_type_id = 3 or obj_type_id is null);

if :new.res_channel_id <> 0 then
  /* check that referenced response channel still exists */
  select res_channel_id into var_id from res_channel where res_channel_id = :new.res_channel_id;

  insert into referenced_obj select 35, :new.res_channel_id, null, null, null, null, null,
    19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and
    (obj_type_id = 35 or obj_type_id is null);
end if; 

if :new.res_type_id <> 0 then
  /* check that referenced response type still exists */
  select res_type_id into var_id from res_type where res_type_id = :new.res_type_id;

  insert into referenced_obj select 34, :new.res_type_id, null, null, null, null, null,
    19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and
    (obj_type_id = 34 or obj_type_id is null);
end if; 

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_RES_STREAM_DETC
  AFTER UPDATE OF 
        RES_CHANNEL_ID
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_RES_STREAM_DETC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.res_channel_id <> 0 then
  delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
    and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
    obj_type_id = 35 and obj_id = :old.res_channel_id;
end if; 

if :new.res_channel_id <> 0 then
  /* check that referenced response channel still exists */
  select res_channel_id into var_id from res_channel where res_channel_id = :new.res_channel_id;

  insert into referenced_obj select 35, :new.res_channel_id, null, null, null, null, null,
    19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and
    (obj_type_id = 35 or obj_type_id is null);
end if; 

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_RES_STREAM_DETS
  AFTER UPDATE OF 
        SEG_TYPE_ID,
        SEG_ID
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_RES_STREAM_DETS */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
  and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
  obj_type_id = :old.seg_type_id and obj_id = :old.seg_id;

/* check that referenced segment still exists */
select seg_id into var_id from seg_hdr where seg_type_id = :new.seg_type_id and seg_id = :new.seg_id;

insert into referenced_obj select :new.seg_type_id, :new.seg_id, null, null, null, null, null,
  19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
  from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and 
  (obj_type_id = 3 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_RES_STREAM_DETT
  AFTER UPDATE OF 
        RES_TYPE_ID
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_RES_STREAM_DETT */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.res_type_id <> 0 then
  delete from referenced_obj where ref_type_id = 19 and ref_id = :old.res_model_id and ref_sub_id = :old.res_stream_id
    and ref_det_id = :old.seg_type_id and ref_sub_det_id = :old.seg_id and ref_indicator_id = 3 and
    obj_type_id = 34 and obj_id = :old.res_type_id;
end if; 

if :new.res_type_id <> 0 then
  /* check that referenced response type still exists */
  select res_type_id into var_id from res_type where res_type_id = :new.res_type_id;

  insert into referenced_obj select 34, :new.res_type_id, null, null, null, null, null,
    19, :new.res_model_id, :new.res_stream_id, :new.seg_type_id, :new.seg_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 19 and ref_indicator_id = 3 and
    (obj_type_id = 34 or obj_type_id is null);
end if; 

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_TREAT_FIXED_COST
  AFTER DELETE
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TREAT_FIXED_COST */
declare numrows INTEGER;

begin
if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5; 
end if;

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
  and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
  and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;
end;
/



create trigger TI_TREAT_FIXED_COST
  AFTER INSERT
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TREAT_FIXED_COST */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced objects still exist */

if :new.fixed_cost_id <> 0 then
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 38 or obj_type_id is null);
end if;

if :new.fixed_cost_area_id <> 0 then
  select fixed_cost_area_id into var_id from fixed_cost_area 
     where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 39 or obj_type_id is null);
end if;

if :new.supplier_id <> 0 then
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 40 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_TREAT_FIXED_COST_AREA
  AFTER UPDATE OF 
        FIXED_COST_AREA_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREAT_FIXED_COST_AREA */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
   and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5;
end if;

if :new.fixed_cost_area_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_area_id into var_id from fixed_cost_area 
    where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 39 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_TREAT_FIXED_COST_FC
  AFTER UPDATE OF 
        FIXED_COST_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREAT_FIXED_COST_FC */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
    and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
    and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :new.fixed_cost_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_TREAT_FIXED_COST_SUP
  AFTER UPDATE OF 
        SUPPLIER_ID
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREAT_FIXED_COST_SUP */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
    and ref_sub_id = :old.version_id and ref_det_id = :old.det_id and ref_sub_det_id = :old.treat_cost_seq 
    and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;

if :new.supplier_id <> 0 then
  /* check referenced objects still exist */
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 
    24, :new.camp_id, :new.version_id, :new.det_id, :new.treat_cost_seq, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 
    and (obj_type_id = 40 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_FIXED_COST
  AFTER DELETE
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_FIXED_COST */
declare numrows INTEGER;
begin

if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5; 
end if;

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;

end;
/




create trigger TI_CAMP_FIXED_COST
  AFTER INSERT
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_FIXED_COST */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced objects still exist */
if :new.fixed_cost_id <> 0 then
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

if :new.fixed_cost_area_id <> 0 then
  select fixed_cost_area_id into var_id from fixed_cost_area where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

if :new.supplier_id <> 0 then
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_FIXED_COST_AREA
  AFTER UPDATE OF 
        FIXED_COST_AREA_ID
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_FIXED_COST_AREA */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5; 
end if;

if :new.fixed_cost_area_id <> 0 then
  /* check referenced fixed cost area record still exist and insert reference */
  select fixed_cost_area_id into var_id from fixed_cost_area where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_FIXED_COST_FC
  AFTER UPDATE OF 
        FIXED_COST_ID
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_FIXED_COST_FC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :new.fixed_cost_id <> 0 then
  /* check referenced fixed cost record still exist and insert reference */
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_FIXED_COST_SUP
  AFTER UPDATE OF 
        SUPPLIER_ID
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_FIXED_COST_SUP */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.camp_cost_seq and ref_det_id is null 
    and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;

if :new.supplier_id <> 0 then
  /* check referenced supplier record still exist and insert reference */
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 24, :new.camp_id, :new.camp_cost_seq, null, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_ELEM
  AFTER DELETE
  on ELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_ELEM */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 44 and ref_id = :old.elem_id 
  and ref_indicator_id = 1 and obj_type_id = 43 and obj_id = :old.elem_grp_id; 

end;
/




create trigger TI_ELEM
  AFTER INSERT
  on ELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_ELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced object still exists */
select elem_grp_id into var_id from elem_grp where elem_grp_id = :new.elem_grp_id;

insert into referenced_obj select 43, :new.elem_grp_id, null, null, null, null, null, 44, :new.elem_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 44 and ref_indicator_id = 1 and (obj_type_id = 43 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_ELEM
  AFTER UPDATE OF 
        ELEM_GRP_ID
  on ELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_ELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 44 and ref_id = :old.elem_id 
  and ref_indicator_id = 1 and obj_type_id = 43 and obj_id = :old.elem_grp_id; 

/* check referenced object still exists */
select elem_grp_id into var_id from elem_grp where elem_grp_id = :new.elem_grp_id;

insert into referenced_obj select 43, :new.elem_grp_id, null, null, null, null, null, 44, :new.elem_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 44 and ref_indicator_id = 1 and (obj_type_id = 43 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_TELEM
  AFTER DELETE
  on TELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TELEM */
declare numrows INTEGER;

begin
delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and ref_indicator_id = 1 and obj_type_id = 44 and obj_id = :old.elem_id; 
end;
/



create trigger TI_TELEM
  AFTER INSERT
  on TELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check that referenced object still exists */
select elem_id into var_id from elem where elem_id = :new.elem_id;

insert into referenced_obj select 44, :new.elem_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 44 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_TELEM
  AFTER UPDATE OF 
        ELEM_ID
  on TELEM
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TELEM */
declare numrows INTEGER;
        var_id INTEGER;

begin
delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and ref_indicator_id = 1 and obj_type_id = 44 and obj_id = :old.elem_id; 

/* check that referenced object still exists */
select elem_id into var_id from elem where elem_id = :new.elem_id;

insert into referenced_obj select 44, :new.elem_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 44 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_EXT_PROC_CONTRL
  AFTER DELETE
  on EXT_PROC_CONTROL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_EXT_PROC_CONTRL */
declare numrows INTEGER;

begin

if (:old.ext_proc_grp_id is not null and :old.ext_proc_grp_id <> 0) then
   delete from referenced_obj where ref_type_id = 66 and ref_id = :old.ext_proc_id and ref_indicator_id = 1
     and obj_type_id = 75 and obj_id = :old.ext_proc_grp_id;
end if;

end;
/




create trigger TI_EXT_PROC_CONTRL
  AFTER INSERT
  on EXT_PROC_CONTROL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_EXT_PROC_CONTRL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.ext_proc_grp_id is not null and :new.ext_proc_grp_id <> 0) then
   /* check that referenced external process group still exists */
   select ext_proc_grp_id into var_id from ext_proc_grp where ext_proc_grp_id = :new.ext_proc_grp_id;

   insert into referenced_obj select 75, :new.ext_proc_grp_id, null, null, null, null, null,
     66, :new.ext_proc_id, null, null, null, 1, constraint_type_id from constraint_setting where
     ref_type_id = 66 and ref_indicator_id = 1 and (obj_type_id = 75 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_EXT_PROC_CONTRL
  AFTER UPDATE OF 
        EXT_PROC_GRP_ID
  on EXT_PROC_CONTROL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_EXT_PROC_CONTRL */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.ext_proc_grp_id is not null and :old.ext_proc_grp_id <> 0) then
   delete from referenced_obj where ref_type_id = 66 and ref_id = :old.ext_proc_id and ref_indicator_id = 1
     and obj_type_id = 75 and obj_id = :old.ext_proc_grp_id;
end if;

if (:new.ext_proc_grp_id is not null and :new.ext_proc_grp_id <> 0) then
   /* check that referenced external process group still exists */
   select ext_proc_grp_id into var_id from ext_proc_grp where ext_proc_grp_id = :new.ext_proc_grp_id;

   insert into referenced_obj select 75, :new.ext_proc_grp_id, null, null, null, null, null,
     66, :new.ext_proc_id, null, null, null, 1, constraint_type_id from constraint_setting where
     ref_type_id = 66 and ref_indicator_id = 1 and (obj_type_id = 75 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_WEB_TEMPL
  AFTER DELETE
  on WEB_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_WEB_TEMPL */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 67 and ref_id = :old.web_templ_id and
  ref_indicator_id = 1 and obj_type_id = 72 and obj_id = :old.web_templ_grp_id;

end;
/



create trigger TI_WEB_TEMPL
  AFTER INSERT
  on WEB_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_WEB_TEMPL */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check that referenced template group still exists */
select web_templ_grp_id into var_id from web_templ_grp where web_templ_grp_id = :new.web_templ_grp_id;

insert into referenced_obj select 72, :new.web_templ_grp_id, null, null, null, null, null,
  67, :new.web_templ_id, null, null, null, 1, constraint_type_id from constraint_setting
  where ref_type_id = 67 and ref_indicator_id = 1 and (obj_type_id = 72 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_WEB_TEMPL
  AFTER UPDATE OF 
        WEB_TEMPL_GRP_ID
  on WEB_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_WEB_TEMPL */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 67 and ref_id = :old.web_templ_id and
  ref_indicator_id = 1 and obj_type_id = 72 and obj_id = :old.web_templ_grp_id;

/* check that referenced template group still exists */
select web_templ_grp_id into var_id from web_templ_grp where web_templ_grp_id = :new.web_templ_grp_id;

insert into referenced_obj select 72, :new.web_templ_grp_id, null, null, null, null, null,
  67, :new.web_templ_id, null, null, null, 1, constraint_type_id from constraint_setting
  where ref_type_id = 67 and ref_indicator_id = 1 and (obj_type_id = 72 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_WEB_TEMPL_TAG
  AFTER DELETE
  on WEB_TEMPL_TAG
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_WEB_TEMPL_TAG */
declare numrows INTEGER;

begin

if :old.dft_elem_id <> 0 then
  delete from referenced_obj where ref_type_id = 68 and ref_id = :old.web_templ_id and ref_sub_id = :old.web_tag_id
    and ref_indicator_id = 1 and obj_type_id = 44 and obj_id = :old.dft_elem_id;
end if;

end;
/



create trigger TI_WEB_TEMPL_TAG
  AFTER INSERT
  on WEB_TEMPL_TAG
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_WEB_TEMPL_TAG */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.dft_elem_id <> 0 then
  /* check that referenced element still exists */
  select elem_id into var_id from elem where elem_id = :new.dft_elem_id;

  insert into referenced_obj select 44, :new.dft_elem_id, null, null, null, null, null,
    68, :new.web_templ_id, :new.web_tag_id, null, null, 1, constraint_type_id from constraint_setting
    where ref_type_id = 68 and ref_indicator_id = 1 and (obj_type_id = 44 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_WEB_TEMPL_TAG
  AFTER UPDATE OF 
        DFT_ELEM_ID
  on WEB_TEMPL_TAG
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_WEB_TEMPL_TAG */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.dft_elem_id <> 0 then
  delete from referenced_obj where ref_type_id = 68 and ref_id = :old.web_templ_id and ref_sub_id = :old.web_tag_id
    and ref_indicator_id = 1 and obj_type_id = 44 and obj_id = :old.dft_elem_id;
end if;

if :new.dft_elem_id <> 0 then
  /* check that referenced element still exists */
  select elem_id into var_id from elem where elem_id = :new.dft_elem_id;

  insert into referenced_obj select 44, :new.dft_elem_id, null, null, null, null, null,
    68, :new.web_templ_id, :new.web_tag_id, null, null, 1, constraint_type_id from constraint_setting
    where ref_type_id = 68 and ref_indicator_id = 1 and (obj_type_id = 44 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_WEB_TEMPL_T_D
  AFTER DELETE
  on WEB_TEMPL_TAG_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_WEB_TEMPL_T_D */
declare numrows INTEGER;

begin

if (:old.camp_id <> 0 and :old.det_id <> 0 and :old.elem_id <> 0) then
  delete from referenced_obj where ref_type_id = 68 and ref_id = :old.web_templ_id and
  ref_sub_id = :old.web_tag_id and ref_det_id = :old.camp_id and ref_sub_det_id = :old.det_id
  and ref_indicator_id = 3; 

end if;

end;
/



create trigger TI_WEB_TEMPL_T_D
  AFTER INSERT
  on WEB_TEMPL_TAG_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_WEB_TEMPL_T_D */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.camp_id <> 0 and :new.det_id <> 0 and :new.elem_id <> 0) then
  /* check that referenced campaign treatment element still exists */
  select elem_id into var_id from telem x, camp_det c where x.elem_id = :new.elem_id and x.treatment_id =
    c.obj_id and c.camp_id = :new.camp_id and c.det_id = :new.det_id;

  /* insert reference to campaign node */
  insert into referenced_obj select 24, :new.camp_id, :new.det_id, null, null, null, null,
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 68 and ref_indicator_id = 3 and (obj_type_id = 24 
    or obj_type_id is null);

  /* insert reference to treatment element link */
  insert into referenced_obj select 71, t.treatment_id, :new.elem_id, null, null, null, null, 
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, x.constraint_type_id 
    from telem t, camp_det c, constraint_setting x where t.elem_id = :new.elem_id and t.treatment_id =
    c.obj_id and c.camp_id = :new.camp_id and c.det_id = :new.det_id and 
    x.ref_type_id = 68 and x.ref_indicator_id = 3 and (x.obj_type_id = 71 or x.obj_type_id is null);

  /* insert reference to element */
  insert into referenced_obj select 44, :new.elem_id, null, null, null, null, null, 
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, constraint_type_id 
    from constraint_setting x where ref_type_id = 68 and x.ref_indicator_id = 3 and 
    (x.obj_type_id = 44 or x.obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_WEB_TEMPL_T_D
  AFTER UPDATE OF 
        CAMP_ID,
        DET_ID,
        ELEM_ID
  on WEB_TEMPL_TAG_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_WEB_TEMPL_T_D */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.camp_id <> 0 and (:old.det_id <> 0 and :old.elem_id <> 0)) then
  delete from referenced_obj where ref_type_id = 68 and ref_id = :old.web_templ_id and 
  ref_sub_id = :old.web_tag_id and ref_det_id = :old.camp_id and ref_sub_det_id = :old.det_id
  and ref_indicator_id = 3; 
end if;

if (:new.camp_id <> 0 and :new.det_id <> 0 and :new.elem_id <> 0) then
  /* check that referenced campaign treatment element still exists */
  select elem_id into var_id from telem x, camp_det c where x.elem_id = :new.elem_id and x.treatment_id =
    c.obj_id and c.camp_id = :new.camp_id and c.det_id = :new.det_id;

  /* insert reference to campaign node */
  insert into referenced_obj select 24, :new.camp_id, :new.det_id, null, null, null, null,
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, constraint_type_id
    from constraint_setting where ref_type_id = 68 and ref_indicator_id = 3 and (obj_type_id = 24 
    or obj_type_id is null);

  /* insert reference to treatment element link */
  insert into referenced_obj select 71, t.treatment_id, :new.elem_id, null, null, null, null, 
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, x.constraint_type_id 
    from telem t, camp_det c, constraint_setting x where t.elem_id = :new.elem_id and t.treatment_id =
    c.obj_id and c.camp_id = :new.camp_id and c.det_id = :new.det_id and 
    x.ref_type_id = 68 and x.ref_indicator_id = 3 and (x.obj_type_id = 71 or x.obj_type_id is null);

  /* insert reference to element */
  insert into referenced_obj select 44, :new.elem_id, null, null, null, null, null, 
    68, :new.web_templ_id, :new.web_tag_id, :new.camp_id, :new.det_id, 3, constraint_type_id 
    from constraint_setting x where ref_type_id = 68 and x.ref_indicator_id = 3 and 
    (x.obj_type_id = 44 or x.obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_EMAIL_MAILBOX
  AFTER DELETE
  on EMAIL_MAILBOX
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_EMAIL_MAILBOX */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
  ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 61 and
  obj_id = :old.server_id;

end;
/



create trigger TI_EMAIL_MAILBOX
  AFTER INSERT
  on EMAIL_MAILBOX
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_EMAIL_MAILBOX */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check that referenced email_mailbox still exists */
select server_id into var_id from email_server where server_id = :new.server_id;

insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
  62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
  (obj_type_id = 61 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_EMAIL_MAILBOX
  AFTER UPDATE OF 
        SERVER_ID
  on EMAIL_MAILBOX
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_EMAIL_MAILBOX */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
  ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 61 and
  obj_id = :old.server_id;

/* check that referenced email_mailbox still exists */
select server_id into var_id from email_server where server_id = :new.server_id;

insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
  62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
  (obj_type_id = 61 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_MAILBOX_RES_RUL
  AFTER DELETE
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_MAILBOX_RES_RUL */
declare numrows INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
    ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 69 and
    obj_id = :old.rule_id;
end if;

end;
/



create trigger TI_MAILBOX_RES_RUL
  AFTER INSERT
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_MAILBOX_RES_RUL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/





create trigger TU_MAILBOX_RES_RUL
  AFTER UPDATE OF 
        RULE_ID
  on MAILBOX_RES_RULE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_MAILBOX_RES_RUL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.rule_id <> 0 then
  delete from referenced_obj where ref_type_id = 62 and ref_id = :old.server_id and
    ref_sub_id = :old.mailbox_id and ref_indicator_id = 1 and obj_type_id = 69 and
    obj_id = :old.rule_id;
end if;

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from eres_rule_hdr where rule_id = :new.rule_id;

  insert into referenced_obj select 69, :new.rule_id, null, null, null, null, null,
    62, :new.server_id, :new.mailbox_id, null, null, 1, constraint_type_id from
    constraint_setting where ref_type_id = 62 and ref_indicator_id = 1 and
    (obj_type_id = 69 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_CAMP_POST
  AFTER DELETE
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_POST */
declare numrows INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;
end;
/



create trigger TI_CAMP_POST
  AFTER INSERT
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_POST */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 55 or obj_type_id is null);
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 53 or obj_type_id is null);
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 54 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_POST_CO
  AFTER UPDATE OF 
        CONTRACTOR_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_POST_CO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 55 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_POST_PS
  AFTER UPDATE OF 
        POSTER_SIZE_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_POST_PS */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 53 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_POST_PT
  AFTER UPDATE OF 
        POSTER_TYPE_ID
  on CAMP_POST
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_POST_PT */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 54 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_DERIVED_VAL_HDR
  AFTER DELETE
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DERIVED_VAL_HDR */
declare numrows INTEGER;
        var_count INTEGER;

begin

if ((:old.where_seg_id is not null) and (:old.where_seg_id <> 0)) then
   delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 1 and obj_type_id = 15 and obj_id = :old.where_seg_id;
end if;

/* delete any references in DERIVED_VAL_TEXT, GROUP_BY, ORDER_BY AND ADDL_INFO columns, created by parser */
select count(*) into var_count from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id
   and ref_indicator_id in (16, 17, 18, 19);

if var_count > 0 then
  delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and 
    ref_indicator_id in (16, 17, 18, 19);
end if;

end;
/



create trigger TI_DERIVED_VAL_HDR
  AFTER INSERT
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DERIVED_VAL_HDR */
declare numrows INTEGER;
         var_id INTEGER;

begin

if ((:new.where_seg_id is not null) and (:new.where_seg_id <> 0)) then
   /* check referenced derived value criteria exists */
   select seg_id into var_id from seg_hdr where seg_type_id = 15 and seg_id = :new.where_seg_id;

   insert into referenced_obj select 15, :new.where_seg_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 13 and ref_indicator_id = 1 and (obj_type_id = 13 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DERIVED_VAL_HAI
  AFTER UPDATE OF 
        ADDL_INFO
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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




create trigger TU_DERIVED_VAL_HDR
  AFTER UPDATE OF 
        WHERE_SEG_ID
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DERIVED_VAL_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if ((:old.where_seg_id is not null) and (:old.where_seg_id <> 0)) then
   delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 1 and obj_type_id = 15 and obj_id = :old.where_seg_id;
end if;

if ((:new.where_seg_id is not null) and (:new.where_seg_id <> 0)) then
   /* check referenced derived value criteria exists */
   select seg_id into var_id from seg_hdr where seg_type_id = 15 and seg_id = :new.where_seg_id;

   insert into referenced_obj select 15, :new.where_seg_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 13 and ref_indicator_id = 1 and (obj_type_id = 13 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_DERIVED_VAL_HGB
  AFTER UPDATE OF 
        GROUP_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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




create trigger TU_DERIVED_VAL_HOB
  AFTER UPDATE OF 
        ORDER_BY
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
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




create trigger TD_DATA_REP_DET
  AFTER DELETE
  on DATA_REP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DATA_REP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
select count(*) into var_id from referenced_obj where ref_type_id = 7 and
  ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg and ref_det_id = :old.data_rep_seq;

if var_id > 0 then
  delete from referenced_obj where ref_type_id = 7 and
    ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg and ref_det_id = :old.data_rep_seq;
end if;

end;
/



create trigger TI_DATA_REP_DET
  AFTER INSERT
  on DATA_REP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DATA_REP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
if :new.comp_type_id = 4 then   /* linked component is derived value */
   /* check that referenced derived value still exists */
   select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.comp_id;

   insert into referenced_obj select 13, :new.comp_id, null, null, null, null, null, 
     7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and 
     (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* linked component is score model */
   /* check that referenced score model still exists */
   select score_id into var_id from score_hdr where score_id = :new.comp_id;

   insert into referenced_obj select 9, :new.comp_id, null, null, null, null, null, 
     7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and 
     (obj_type_id = 9 or obj_type_id is null);

end if;

if (:new.cond_val is not null and :new.cond_val like '% [%]%') then
  select obj_type_id into var_id from vantage_dyn_tab where vantage_alias =
    'LT'|| substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')- (instr(:new.cond_val,' [')+2));

  insert into referenced_obj select 8, to_number(substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')-(instr(:new.cond_val,' [')+2))),
     null, null, null, null, null, 7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 20, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and
     (obj_type_id = 8 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DATA_REP_DETC
  AFTER UPDATE OF 
        COND_VAL
  on DATA_REP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DATA_REP_DETC */
declare numrows INTEGER;
        var_id INTEGER;

begin

select count(*) into var_id from referenced_obj where ref_type_id = 7 and
  ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg and ref_det_id = :old.data_rep_seq 
  and ref_indicator_id = 20;

if var_id > 0 then
  delete from referenced_obj where ref_type_id = 7 and
    ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg and ref_det_id = :old.data_rep_seq and ref_indicator_id = 20;
end if;

if (:new.cond_val is not null and :new.cond_val like '% [%]%') then
  select obj_type_id into var_id from vantage_dyn_tab where vantage_alias =
    'LT'|| substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')- (instr(:new.cond_val,' [')+2));

  insert into referenced_obj select 8, to_number(substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')-(instr(:new.cond_val,' [')+2))),
     null, null, null, null, null, 7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 20, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and
     (obj_type_id = 8 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DATA_REP_DETT
  AFTER UPDATE OF 
        COMP_TYPE_ID,
        COMP_ID
  on DATA_REP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DATA_REP_DETT */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.comp_type_id = 4 then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg
    and ref_det_id = :old.data_rep_seq and obj_type_id = 13 and obj_id = :old.comp_id and ref_indicator_id = 3;

elsif :old.comp_type_id = 5 then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_sub_id = :old.row_flg
    and ref_det_id = :old.data_rep_seq and obj_type_id = 9 and obj_id = :old.comp_id and ref_indicator_id = 3;
end if;

if :new.comp_type_id = 4 then   /* new linked component is derived value */
   /* check that referenced derived value still exists */
   select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.comp_id;

   insert into referenced_obj select 13, :new.comp_id, null, null, null, null, null, 
     7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and 
     (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* new linked component is score model */
   /* check that referenced score model still exists */
   select score_id into var_id from score_hdr where score_id = :new.comp_id;

   insert into referenced_obj select 9, :new.comp_id, null, null, null, null, null, 
     7, :new.data_rep_id, :new.row_flg, :new.data_rep_seq, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 7 and ref_indicator_id = 3 and 
     (obj_type_id = 9 or obj_type_id is null);

end if;


EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_SCORE_SRC
  AFTER DELETE
  on SCORE_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_SCORE_SRC */
declare numrows INTEGER;
begin

if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id;
   end if;
end if;

end;
/



create trigger TI_SCORE_SRC
  AFTER INSERT
  on SCORE_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SCORE_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.src_type_id <> 0 then
   /* check that referenced object still exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 
       9, :new.score_id, null, null, null, 2, constraint_type_id 
       from constraint_setting where ref_type_id = 9 and ref_indicator_id = 2 and (obj_type_id = 9 or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 
       9, :new.score_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 9 and ref_indicator_id = 2 and (obj_type_id = 9 or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_SCORE_SRC
  AFTER UPDATE OF 
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on SCORE_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SCORE_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id;
   end if;
end if;

if :new.src_type_id <> 0 then
   /* check that referenced object still exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 9, :new.score_id, null, null, null, 2, constraint_type_id 
       from constraint_setting where ref_type_id = 9 and ref_indicator_id = 2 and (obj_type_id = 9 or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 9, :new.score_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 9 and ref_indicator_id = 2 and (obj_type_id = 9 or obj_type_id is null);
   end if;
end if;


EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_DERIVED_VAL_SRC
  AFTER DELETE
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DERIVED_VAL_SRC */
declare numrows INTEGER;
begin
if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;
end;
/



create trigger TI_DERIVED_VAL_SRC
  AFTER INSERT
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DERIVED_VAL_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin
if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DERIVED_VAL_SRC
  AFTER UPDATE OF 
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DERIVED_VAL_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 13 and ref_id = :old.derived_val_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;

if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 13, :new.derived_val_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 13 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_EXT_TEMPL_DET
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

end;
/



create trigger TI_EXT_TEMPL_DET
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
  select score_id into var_id from score_src where score_id = :new.comp_id and 
    src_type_id = :new.src_type_id and src_id = :new.src_id and src_sub_id = :new.src_sub_id;

  /* Obj_type 99 = Decision Logic Segment, 12 = Extract Template; Ref_Indicator 3 = Detail */
  insert into referenced_obj select 99, :new.comp_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
    12, :new.ext_templ_id, :new.line_seq, null, null, 3, constraint_type_id
    from constraint_setting where ref_type_id = 12 and ref_indicator_id = 3 and
    (obj_type_id = 99 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create trigger TU_EXT_TEMPL_DET
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create trigger TD_EXT_HDR_AND_FTR
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


create trigger TI_EXT_HDR_AND_FTR
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


create trigger TU_EXT_HDR_AND_FTR
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

create trigger TD_CONS_FLD_DET
  AFTER DELETE
  on CONS_FLD_DET
  
  for each row
/* ERwin Builtin Thu Jun 26 12:36:18 2003 */
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

end;
/



create trigger TI_CONS_FLD_DET
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create trigger TU_CONS_FLD_DET
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/

create trigger TD_CHARAC
  AFTER DELETE
  on CHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CHARAC */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 42 and ref_id = :old.charac_id 
  and ref_indicator_id = 1 and obj_type_id = 80 and obj_id = :old.charac_grp_id; 

end;
/


create trigger TI_CHARAC
  AFTER INSERT
  on CHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced object still exists */
select charac_grp_id into var_id from charac_grp where charac_grp_id = :new.charac_grp_id;

insert into referenced_obj select 80, :new.charac_grp_id, null, null, null, null, null, 
  42, :new.charac_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 42 and ref_indicator_id = 1 and 
  (obj_type_id = 80 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/







create trigger TU_CHARAC
  AFTER UPDATE OF 
        CHARAC_GRP_ID
  on CHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 42 and ref_id = :old.charac_id 
  and ref_indicator_id = 1 and obj_type_id = 80 and obj_id = :old.charac_grp_id; 

/* check referenced object still exists */
select charac_grp_id into var_id from charac_grp where charac_grp_id = :new.charac_grp_id;

insert into referenced_obj select 80, :new.charac_grp_id, null, null, null, null, null, 42, :new.charac_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 42 and ref_indicator_id = 1 and (obj_type_id = 80 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/








create trigger TD_TCHARAC
  AFTER DELETE
  on TCHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TCHARAC */
declare numrows INTEGER;

begin

delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and ref_indicator_id = 1 and obj_type_id = 42 and obj_id = :old.charac_id; 

end;
/








create trigger TI_TCHARAC
  AFTER INSERT
  on TCHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TCHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check that referenced object still exists */
select charac_id into var_id from charac where charac_id = :new.charac_id;

insert into referenced_obj select 42, :new.charac_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
 from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 42 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/










create trigger TU_TCHARAC
  AFTER UPDATE OF 
        CHARAC_ID
  on TCHARAC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TCHARAC */
declare numrows INTEGER;
        var_id INTEGER;

begin

delete from referenced_obj where ref_type_id = 18 and ref_id = :old.treatment_id 
  and ref_indicator_id = 1 and obj_type_id = 42 and obj_id = :old.charac_id; 

/* check that referenced object still exists */
select charac_id into var_id from charac where charac_id = :new.charac_id;

insert into referenced_obj select 42, :new.charac_id, null, null, null, null, null, 18, :new.treatment_id, null, null, null, 1, constraint_type_id
 from constraint_setting where ref_type_id = 18 and ref_indicator_id = 1 and (obj_type_id = 42 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/









create trigger TD_STORED_FLD_TMPL
  AFTER DELETE
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_STORED_FLD_TMPL */
declare numrows INTEGER;
        var_count INTEGER;
begin

if :old.vantage_alias is not null then
   select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
     ref_id = :old.seg_id and ref_sub_id = :old.seq_number and ref_indicator_id = 7;

   if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id and
       ref_sub_id = :old.seq_number and ref_indicator_id = 7;
   end if;
end if;

end;
/




create trigger TI_STORED_FLD_TMPL
  AFTER INSERT
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_STORED_FLD_TMPL */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


















create trigger TU_STORED_FLD_TMPL
  AFTER UPDATE OF 
        VANTAGE_ALIAS
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_STORED_FLD_TMPL */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :old.vantage_alias is not null then
   select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
     ref_id = :old.seg_id and ref_sub_id = :old.seq_number and ref_indicator_id = 7;

   if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id and
       ref_sub_id = :old.seq_number and ref_indicator_id = 7;
   end if;
end if;

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 7, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/





create trigger TD_CAMP_RADIO
  AFTER DELETE
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_RADIO */
declare numrows INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;
end;
/



















create trigger TI_CAMP_RADIO
  AFTER INSERT
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_RADIO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 56 or obj_type_id is null);
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 57 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/












create trigger TU_CAMP_RADIO_RA
  AFTER UPDATE OF 
        RADIO_ID
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_RADIO_RA */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 56 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/










create trigger TU_CAMP_RADIO_RR
  AFTER UPDATE OF 
        RADIO_REGION_ID
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_RADIO_RR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 57 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_LEAF
  AFTER DELETE
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_LEAF */
declare numrows INTEGER;

begin

if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

end;
/




create trigger TI_CAMP_LEAF
  AFTER INSERT
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_LEAF */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 49 or obj_type_id is null);
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 50 or obj_type_id is null);
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 51 or obj_type_id is null);
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 52 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_LEAF_CP
  AFTER UPDATE OF 
        COLLECT_POINT_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_LEAF_CP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 51 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_LEAF_DP
  AFTER UPDATE OF 
        DISTRIB_POINT_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_LEAF_DP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 52 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_LEAF_LD
  AFTER UPDATE OF 
        LEAF_DISTRIB_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_LEAF_LD */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 50 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_CAMP_LEAF_LR
  AFTER UPDATE OF 
        LEAF_REGION_ID
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_LEAF_LR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.version_id and ref_det_id = :old.det_id and 
    ref_sub_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 49 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_SCORE_DET
  AFTER DELETE
  on SCORE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_SCORE_DET */
declare numrows INTEGER;

begin

if ((:old.obj_type_id <> 0)) then
   delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_sub_id = :old.score_seq 
     and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id;
end if;

end;
/



create trigger TI_SCORE_DET
  AFTER INSERT
  on SCORE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SCORE_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if ((:new.obj_type_id <> 0)) then
   if :new.obj_type_id = 13 then
     /* check that referenced object still exists */
     select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.obj_id;
   else
      /* check that referenced object still exists */
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
   end if;
   
   insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
     9, :new.score_id, :new.score_seq, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 9 and ref_indicator_id = 3 and 
     (obj_type_id = :new.obj_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_SCORE_DET
  AFTER UPDATE OF 
        OBJ_ID,
        OBJ_TYPE_ID
  on SCORE_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SCORE_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if ((:old.obj_type_id <> 0)) then
   delete from referenced_obj where ref_type_id = 9 and ref_id = :old.score_id and ref_sub_id = :old.score_seq 
     and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id;
end if;

if ((:new.obj_type_id <> 0)) then
   if :new.obj_type_id = 13 then
     /* check that referenced object still exists */
     select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.obj_id;
   else
      /* check that referenced object still exists */
     select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
   end if;
   
   insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null, 
     9, :new.score_id, :new.score_seq, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 9 and ref_indicator_id = 3 and 
     (obj_type_id = :new.obj_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_TREE_BASE
  AFTER DELETE
  on TREE_BASE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_TREE_BASE */
declare numrows INTEGER;

begin

if (:old.origin_type_id is not null and :old.origin_type_id <> 0) then
  if :old.origin_type_id = 4 then   /* old linked object is a tree segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.base_seq
       and ref_indicator_id = 8 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id and 
       obj_sub_id = :old.origin_sub_id;

  else   /* old linked object is a segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.base_seq
       and ref_indicator_id = 8 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id;
  end if;
end if;

end;
/



create trigger TI_TREE_BASE
  AFTER INSERT
  on TREE_BASE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_TREE_BASE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.origin_type_id is not null and :new.origin_type_id <> 0) then
  if :new.origin_type_id = 4 then   /* new linked object is tree segment */
    /* check that the referenced tree segment still exists */ 
    select tree_id into var_id from tree_det where tree_id = :new.origin_id and tree_seq = :new.origin_sub_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, :new.origin_sub_id, null, null, null, null,
      4, :new.tree_id, :new.base_seq, null, null, 8, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 8 and (obj_type_id = :new.origin_type_id or obj_type_id is null);

  else    /* new linked object is a segment */
    /* check that the referenced segment still exists */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.origin_type_id and seg_id = :new.origin_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, null, null, null, null, null,
      4, :new.tree_id, :new.base_seq, null, null, 8, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 8 and (obj_type_id = :new.origin_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_TREE_BASE
  AFTER UPDATE OF 
        ORIGIN_TYPE_ID,
        ORIGIN_ID,
        ORIGIN_SUB_ID
  on TREE_BASE
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_TREE_BASE */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.origin_type_id is not null and :old.origin_type_id <> 0) then
  if :old.origin_type_id = 4 then   /* old linked object is a tree segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.base_seq
       and ref_indicator_id = 8 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id and 
       obj_sub_id = :old.origin_sub_id;

  else   /* old linked object is a segment */
     delete from referenced_obj where ref_type_id = 4 and ref_id = :old.tree_id and ref_sub_id = :old.base_seq
       and ref_indicator_id = 8 and obj_type_id = :old.origin_type_id and obj_id = :old.origin_id;
  end if;
end if;

if (:new.origin_type_id is not null and :new.origin_type_id <> 0) then
  if :new.origin_type_id = 4 then   /* new linked object is tree segment */
    /* check that the referenced tree segment still exists */ 
    select tree_id into var_id from tree_det where tree_id = :new.origin_id and tree_seq = :new.origin_sub_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, :new.origin_sub_id, null, null, null, null,
      4, :new.tree_id, :new.base_seq, null, null, 8, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 8 and (obj_type_id = :new.origin_type_id or obj_type_id is null);

  else    /* new linked object is a segment */
    /* check that the referenced segment still exists */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.origin_type_id and seg_id = :new.origin_id;

    insert into referenced_obj select :new.origin_type_id, :new.origin_id, null, null, null, null, null,
      4, :new.tree_id, :new.base_seq, null, null, 8, constraint_type_id from constraint_setting 
      where ref_type_id = 4 and ref_indicator_id = 8 and (obj_type_id = :new.origin_type_id or obj_type_id is null);
  end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_PUB
  AFTER DELETE
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_PUB */
declare numrows INTEGER;

begin
if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
     and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
        and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

end;
/




create trigger TI_CAMP_PUB
  AFTER INSERT
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
         from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
         (obj_type_id = 59 or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_PUB
  AFTER UPDATE OF 
        PUB_ID,
        PUB_SEC_ID
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
     and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
        and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 14, constraint_type_id
         from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
         (obj_type_id = 59 or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_SPI_PROC
  AFTER DELETE
  on SPI_PROC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_SPI_PROC */
declare numrows INTEGER;
        var_count INTEGER;

begin
select count(*) into var_count from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
  ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;

if var_count > 0 then
  delete from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
    ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;
end if;
end;
/



create trigger TI_SPI_PROC
  AFTER INSERT
  on SPI_PROC
   
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SPI_PROC */
declare numrows INTEGER;
        var_id INTEGER;
        var_count INTEGER;

begin
/* check that the added process is part of a task group */
select count(*) into var_count from spi_master where spi_id = :new.spi_id and spi_type_id = 4;

if var_count > 0 then
  /* check that the added object still exists */
  if :new.obj_type_id in (1,2) then  /* segment, base segment */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
  elsif :new.obj_type_id = 4 then    /* tree segment */
    select tree_id into var_id from tree_hdr where tree_id = :new.obj_id;
  elsif (:new.obj_type_id = 5 and :new.obj_id <> 0) then    /* data categorisation */
    select data_cat_id into var_id from data_cat_hdr where data_cat_id = :new.obj_id;
  elsif :new.obj_type_id = 7 then    /* data report */
    select data_rep_id into var_id from data_rep_src where data_rep_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0)
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 9 then    /* score model */
    select score_id into var_id from score_src where score_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 13 then   /* derived value */
    select derived_val_id into var_id from derived_val_src where derived_val_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 62 then   /* email mailbox */
    select mailbox_id into var_id from email_mailbox where server_id = :new.src_id and mailbox_id = :new.obj_id;
    /* for mailbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 97 then   /* wireless inbox */
    select inbox_id into var_id from wireless_inbox where server_id = :new.src_id and inbox_id = :new.obj_id;
    /* for wireless inbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id in (62,97) then
    insert into referenced_obj select :new.obj_type_id, :new.src_id, :new.obj_id, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);    
  elsif :new.obj_type_id in (7,9,13) then
    if :new.src_type_id = 4 then
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    else
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, null,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    end if;
  end if;  
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_SPI_PROC
  AFTER UPDATE OF 
        OBJ_TYPE_ID,
        OBJ_ID
  on SPI_PROC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SPI_PROC */
declare numrows INTEGER;
        var_id INTEGER;
        var_count INTEGER;

begin

select count(*) into var_count from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
  ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;

if var_count > 0 then
  delete from referenced_obj where ref_type_id = 17 and ref_id = :old.spi_id and
    ref_sub_id = :old.proc_seq and ref_det_id = :old.camp_proc_seq and ref_indicator_id = 3;
end if;

/* check that the added process is part of a task group */
select count(*) into var_count from spi_master where spi_id = :new.spi_id and spi_type_id = 4;

if var_count > 0 then
  /* check that the added object still exists */
  if :new.obj_type_id in (1,2) then  /* segment, base segment */
    select seg_id into var_id from seg_hdr where seg_type_id = :new.obj_type_id and seg_id = :new.obj_id;
  elsif :new.obj_type_id = 4 then    /* tree segment */
    select tree_id into var_id from tree_hdr where tree_id = :new.obj_id;
  elsif (:new.obj_type_id = 5 and :new.obj_id <> 0) then    /* data categorisation */
    select data_cat_id into var_id from data_cat_hdr where data_cat_id = :new.obj_id;
  elsif :new.obj_type_id = 7 then    /* data report */
    select data_rep_id into var_id from data_rep_src where data_rep_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0)
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 9 then    /* score model */
    select score_id into var_id from score_src where score_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 13 then   /* derived value */
    select derived_val_id into var_id from derived_val_src where derived_val_id = :new.obj_id and src_type_id =
      :new.src_type_id and src_id = :new.src_id and ((src_type_id <> 4 and src_sub_id = 0) 
      or (src_type_id = 4 and src_sub_id = :new.src_sub_id));
  elsif :new.obj_type_id = 62 then   /* email mailbox */
    select mailbox_id into var_id from email_mailbox where server_id = :new.src_id and mailbox_id = :new.obj_id;
    /* for mailbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 97 then   /* wireless inbox */
    select inbox_id into var_id from wireless_inbox where server_id = :new.src_id and inbox_id = :new.obj_id;
    /* for wireless inbox, the server type and server id is stored in source fields */
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id in (62,97) then
    insert into referenced_obj select :new.obj_type_id, :new.src_id, :new.obj_id, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);    
  elsif :new.obj_type_id in (7,9,13) then
    if :new.src_type_id = 4 then
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, :new.src_sub_id,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    else
      insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, :new.src_type_id, :new.src_id, null,
        17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
        constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
        (obj_type_id = :new.obj_type_id or obj_type_id is null);
    end if;
  end if;  
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_DATA_REP_SRC
  AFTER DELETE
  on DATA_REP_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DATA_REP_SRC */
declare numrows INTEGER;
begin
if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;
end;
/



create trigger TI_DATA_REP_SRC
  AFTER INSERT
  on DATA_REP_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DATA_REP_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin
if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 7, :new.data_rep_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 7 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 7, :new.data_rep_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 7 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DATA_REP_SRC
  AFTER UPDATE OF 
        SRC_TYPE_ID,
        SRC_ID,
        SRC_SUB_ID
  on DATA_REP_SRC
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DATA_REP_SRC */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.src_type_id <> 0 then
   if :old.src_type_id = 4 then
     delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id = :old.src_sub_id;
   else
     delete from referenced_obj where ref_type_id = 7 and ref_id = :old.data_rep_id and ref_indicator_id = 2 
       and obj_type_id = :old.src_type_id and obj_id = :old.src_id and obj_sub_id is null;
   end if;
end if;

if :new.src_type_id <> 0 then
   /* check that the referenced object exists */
   if :new.src_type_id = 4 then
     select tree_id into var_id from tree_det where tree_id = :new.src_id and tree_seq = :new.src_sub_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, :new.src_sub_id, null, null, null, null, 7, :new.data_rep_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 7 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   else
     select seg_id into var_id from seg_hdr where seg_type_id = :new.src_type_id and seg_id = :new.src_id;

     insert into referenced_obj select :new.src_type_id, :new.src_id, null, null, null, null, null, 7, :new.data_rep_id, null, null, null, 2, constraint_type_id
       from constraint_setting where ref_type_id = 7 and ref_indicator_id = 2 and (obj_type_id = :new.src_type_id or obj_type_id is null);
   end if;
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_SEG_DEDUPE_PRIO
  AFTER DELETE
  on SEG_DEDUPE_PRIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_SEG_DEDUPE_PRIO */
declare numrows INTEGER;
        var_count INTEGER;

begin
if :old.vantage_alias is not null then
   select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
     ref_id = :old.seg_id and ref_sub_id = :old.seq_number and ref_indicator_id = 23;

   if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id and
       ref_sub_id = :old.seq_number and ref_indicator_id = 23;
   end if;
end if;

end;
/



create trigger TI_SEG_DEDUPE_PRIO
  AFTER INSERT
  on SEG_DEDUPE_PRIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_SEG_DEDUPE_PRIO */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 23, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 23 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 23, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 23 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_SEG_DEDUPE_PRIO
  AFTER UPDATE OF 
        VANTAGE_ALIAS
  on SEG_DEDUPE_PRIO
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_SEG_DEDUPE_PRIO */
declare numrows INTEGER;
        var_id INTEGER;
        var_obj_id INTEGER;
        var_count INTEGER;

begin

if :old.vantage_alias is not null then
   select count(*) into var_count from referenced_obj where ref_type_id = :old.seg_type_id and
     ref_id = :old.seg_id and ref_sub_id = :old.seq_number and ref_indicator_id = 23;

   if var_count > 0 then
     delete from referenced_obj where ref_type_id = :old.seg_type_id and ref_id = :old.seg_id and
       ref_sub_id = :old.seq_number and ref_indicator_id = 23;
   end if;
end if;

if :new.vantage_alias is not null then

  select count(*) into var_count from cust_tab where vantage_alias = :new.vantage_alias;

  if var_count = 0 then
    /* obtain object type of the referenced object */
    select obj_type_id into var_id from vantage_dyn_tab where vantage_alias = :new.vantage_alias;
    
    if var_id = 13 then    /* if derived value, get appropriate record from derived value sources */
       select derived_val_id into var_obj_id from derived_val_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 13, x.derived_val_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 23, c.constraint_type_id from derived_val_src x,
         constraint_setting c where x.derived_val_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 23 and (c.obj_type_id = 13 or c.obj_type_id is null);
         
    elsif var_id = 9 then   /* if score, get appropriate record from score sources */
       select score_id into var_obj_id from score_src where dyn_tab_name = :new.vantage_alias;

       insert into referenced_obj select 9, x.score_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
         :new.seg_type_id, :new.seg_id, :new.seq_number, null, null, 23, c.constraint_type_id from score_src x,
         constraint_setting c where x.score_id = var_obj_id and x.dyn_tab_name = :new.vantage_alias and
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 23 and (c.obj_type_id = 9 or c.obj_type_id is null);
    end if;

  end if;

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_EV_CAMP_DET
  AFTER DELETE
  on EV_CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_EV_CAMP_DET */
declare numrows INTEGER;

begin

if (:old.seg_type_id is not null and :old.seg_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_indicator_id = 6 and obj_type_id = :old.seg_type_id and obj_id = :old.seg_id;
end if;

end;
/



create trigger TI_EV_CAMP_DET
  AFTER INSERT
  on EV_CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_EV_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.seg_type_id is not null and :new.seg_type_id <> 0) then
   /* check referenced object still exists */
   select seg_id into var_id from seg_hdr where seg_type_id = :new.seg_type_id and seg_id = :new.seg_id;

   insert into referenced_obj select :new.seg_type_id, :new.seg_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 6, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 6 and (obj_type_id = :new.seg_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_EV_CAMP_DET
  AFTER UPDATE OF 
        SEG_TYPE_ID,
        SEG_ID
  on EV_CAMP_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_EV_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.seg_type_id is not null and :old.seg_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_indicator_id = 6 and obj_type_id = :old.seg_type_id and obj_id = :old.seg_id;
end if;

if (:new.seg_type_id is not null and :new.seg_type_id <> 0) then
   /* check referenced object still exists */
   select seg_id into var_id from seg_hdr where seg_type_id = :new.seg_type_id and seg_id = :new.seg_id;

   insert into referenced_obj select :new.seg_type_id, :new.seg_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 6, constraint_type_id
     from constraint_setting where ref_type_id = 24 and ref_indicator_id = 6 and (obj_type_id = :new.seg_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TD_CAMP_DRTV
  AFTER DELETE
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_DRTV */
declare numrows INTEGER;
begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 47 
      and obj_id = :old.drtv_id;
end if;

if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 48 
      and obj_id = :old.drtv_region_id;
end if;
end;
/



create trigger TI_CAMP_DRTV
  AFTER INSERT
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_DRTV */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 47 or obj_type_id is null);
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 48 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_DRTV_REG
  AFTER UPDATE OF 
        DRTV_REGION_ID
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_DRTV_REG */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 
      and obj_type_id = 48 and obj_id = :old.drtv_region_id;
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 48 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_DRTV_ST
  AFTER UPDATE OF 
        DRTV_ID
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_DRTV_ST */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.version_id 
      and ref_det_id = :old.det_id and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 10 
      and obj_type_id = 47 and obj_id = :old.drtv_id;
end if;
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 47 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_DDROP
  AFTER DELETE
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_DDROP */
declare numrows INTEGER;
begin

if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_region_id;
end if;

if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

end;
/



create trigger TI_CAMP_DDROP
  AFTER INSERT
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_DDROP */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 45 or obj_type_id is null);
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 46 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_DDROP_CARR
  AFTER UPDATE OF 
        DDROP_CARRIER_ID
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_DDROP_CARR */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id 
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_carrier_id;
end if;

if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 45 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_DDROP_REG
  AFTER UPDATE OF 
        DDROP_REGION_ID
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_DDROP_REG */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id 
   and ref_sub_id = :old.version_id and ref_det_id = :old.det_id
   and ref_sub_det_id = :old.placement_seq and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.version_id, :new.det_id, :new.placement_seq, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 46 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_DATAVIEW_TEMPLD
  AFTER DELETE
  on DATAVIEW_TEMPL_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_DATAVIEW_TEMPLD */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.comp_type_id = 4 then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 6 and ref_id = :old.dataview_id and 
    ref_sub_id = :old.seq_number and obj_type_id = 13 and obj_id = :old.comp_id and ref_indicator_id = 3;

elsif :old.comp_type_id = 5 then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 6 and ref_id = :old.dataview_id and 
    ref_sub_id = :old.seq_number and obj_type_id = 9 and obj_id = :old.comp_id and ref_indicator_id = 3;
end if;

select count(*) into var_id from referenced_obj where ref_type_id = 6 and
  ref_id = :old.dataview_id and ref_sub_id = :old.seq_number and ref_indicator_id = 20;

if var_id > 0 then
  delete from referenced_obj where ref_type_id = 6 and
    ref_id = :old.dataview_id and ref_sub_id = :old.seq_number and ref_indicator_id = 20;
end if;

end;
/



create trigger TI_DATAVIEW_TEMPLD
  AFTER INSERT
  on DATAVIEW_TEMPL_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_DATAVIEW_TEMPLD */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.comp_type_id = 4 then   /* new linked component is derived value */
   /* check that referenced derived value still exists */
   select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.comp_id;

   insert into referenced_obj select 13, :new.comp_id, null, null, null, null, null, 
     6, :new.dataview_id, :new.seq_number, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and 
     (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* new linked component is score model */
   /* check that referenced score model still exists */
   select score_id into var_id from score_hdr where score_id = :new.comp_id;

   insert into referenced_obj select 9, :new.comp_id, null, null, null, null, null, 
     6, :new.dataview_id, :new.seq_number, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and 
     (obj_type_id = 9 or obj_type_id is null);

end if;

if (:new.cond_val is not null and :new.cond_val like '% [%]%') then
  select obj_type_id into var_id from vantage_dyn_tab where vantage_alias =
    'LT'|| substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')- (instr(:new.cond_val,' [')+2));

  insert into referenced_obj select 8, to_number(substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')-(instr(:new.cond_val,' [')+2))),
     null, null, null, null, null, 6, :new.dataview_id, :new.seq_number, null, null, 20, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and
     (obj_type_id = 8 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DATAVIEW_TEMPLDT
  AFTER UPDATE OF 
        COMP_TYPE_ID,
        COMP_ID
  on DATAVIEW_TEMPL_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DATAVIEW_TEMPLDT */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.comp_type_id = 4 then   /* old linked component is derived value */
  delete from referenced_obj where ref_type_id = 6 and ref_id = :old.dataview_id and 
    ref_sub_id = :old.seq_number and obj_type_id = 13 and obj_id = :old.comp_id and ref_indicator_id = 3;

elsif :old.comp_type_id = 5 then   /* old linked component is score model */
  delete from referenced_obj where ref_type_id = 6 and ref_id = :old.dataview_id and 
    ref_sub_id = :old.seq_number and obj_type_id = 9 and obj_id = :old.comp_id and ref_indicator_id = 3;
end if;

if :new.comp_type_id = 4 then   /* new linked component is derived value */
   /* check that referenced derived value still exists */
   select derived_val_id into var_id from derived_val_hdr where derived_val_id = :new.comp_id;

   insert into referenced_obj select 13, :new.comp_id, null, null, null, null, null, 
     6, :new.dataview_id, :new.seq_number, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and 
     (obj_type_id = 13 or obj_type_id is null);

elsif :new.comp_type_id = 5 then   /* new linked component is score model */
   /* check that referenced score model still exists */
   select score_id into var_id from score_hdr where score_id = :new.comp_id;

   insert into referenced_obj select 9, :new.comp_id, null, null, null, null, null, 
     6, :new.dataview_id, :new.seq_number, null, null, 3, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and 
     (obj_type_id = 9 or obj_type_id is null);

end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_DATAVIEW_TEMPLDV
  AFTER UPDATE OF 
        COND_VAL
  on DATAVIEW_TEMPL_DET
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_DATAVIEW_TEMPLDV */
declare numrows INTEGER;
        var_id INTEGER;

begin

select count(*) into var_id from referenced_obj where ref_type_id = 6 and
  ref_id = :old.dataview_id and ref_sub_id = :old.seq_number and ref_indicator_id = 20;

if var_id > 0 then
  delete from referenced_obj where ref_type_id = 6 and
    ref_id = :old.dataview_id and ref_sub_id = :old.seq_number and ref_indicator_id = 20;
end if;

if (:new.cond_val is not null and :new.cond_val like '% [%]%') then
  select obj_type_id into var_id from vantage_dyn_tab where vantage_alias =
    'LT'|| substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')- (instr(:new.cond_val,' [')+2));

  insert into referenced_obj select 8, to_number(substr(:new.cond_val, instr(:new.cond_val,' [')+2, instr(:new.cond_val,']')-(instr(:new.cond_val,' [')+2))),
     null, null, null, null, null, 6, :new.dataview_id, :new.seq_number, null, null, 20, constraint_type_id
     from constraint_setting where ref_type_id = 6 and ref_indicator_id = 3 and
     (obj_type_id = 8 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_CAMP_REP_HDR
  AFTER DELETE
  on CAMP_REP_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_CAMP_REP_HDR */
declare numrows INTEGER;

begin

if (:old.camp_rep_grp_id is not null and :old.camp_rep_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 70 and ref_id = :old.camp_rep_id and
     ref_indicator_id = 1 and obj_type_id = 74 and obj_id = :old.camp_rep_grp_id;
end if;

end;
/



create trigger TI_CAMP_REP_HDR
  AFTER INSERT
  on CAMP_REP_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TI_CAMP_REP_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:new.camp_rep_grp_id is not null and :new.camp_rep_grp_id <> 0) then
  /* check that referenced campaign report group still exists */
  select camp_rep_grp_id into var_id from camp_rep_grp where camp_rep_grp_id = :new.camp_rep_grp_id;

  insert into referenced_obj select 74, :new.camp_rep_grp_id, null, null, null, null, null,
    70, :new.camp_rep_id, null, null, null, 1, constraint_type_id from constraint_setting
    where ref_type_id = 70 and ref_indicator_id = 1 and (obj_type_id = 74 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TU_CAMP_REP_HDR
  AFTER UPDATE OF 
        CAMP_REP_GRP_ID
  on CAMP_REP_HDR
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TU_CAMP_REP_HDR */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.camp_rep_grp_id is not null and :old.camp_rep_grp_id <> 0) then
  delete from referenced_obj where ref_type_id = 70 and ref_id = :old.camp_rep_id and
     ref_indicator_id = 1 and obj_type_id = 74 and obj_id = :old.camp_rep_grp_id;
end if;

if (:new.camp_rep_grp_id is not null and :new.camp_rep_grp_id <> 0) then
  /* check that referenced campaign report group still exists */
  select camp_rep_grp_id into var_id from camp_rep_grp where camp_rep_grp_id = :new.camp_rep_grp_id;

  insert into referenced_obj select 74, :new.camp_rep_grp_id, null, null, null, null, null,
    70, :new.camp_rep_id, null, null, null, 1, constraint_type_id from constraint_setting
    where ref_type_id = 70 and ref_indicator_id = 1 and (obj_type_id = 74 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/



create trigger TD_WIRELESS_INBOX
  AFTER DELETE
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Mon Sep 09 16:03:16 2002 */
/* default body for TD_WIRELESS_INBOX */
declare numrows INTEGER;
begin

delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
  ref_sub_id = :old.inbox_id and ref_indicator_id = 1 and obj_type_id = 79 and
  obj_id = :old.server_id;

end;
/



create trigger TI_WIRELESS_INBOX
  AFTER INSERT
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Mon Nov 04 17:45:27 2002 */
/* default body for TI_WIRELESS_INBOX */
declare numrows INTEGER;
        var_id INTEGER;
begin

/* check that referenced wireless_server still exists */
select server_id into var_id from wireless_server where server_id = :new.server_id;

insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
  97, :new.server_id, :new.inbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
  (obj_type_id = 79 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TU_WIRELESS_INBOX
  AFTER UPDATE OF 
        SERVER_ID
  on WIRELESS_INBOX
  
  for each row
/* ERwin Builtin Mon Nov 04 17:45:47 2002 */
/* default body for TU_WIRELESS_INBOX */
declare numrows INTEGER;
        var_id INTEGER;
begin

delete from referenced_obj where ref_type_id = 97 and ref_id = :old.server_id and
  ref_sub_id = :old.inbox_id and ref_indicator_id = 1 and obj_type_id = 79 and
  obj_id = :old.server_id;

/* check that referenced wireless server still exists */
select server_id into var_id from wireless_server where server_id = :new.server_id;

insert into referenced_obj select 79, :new.server_id, null, null, null, null, null,
  97, :new.server_id, :new.inbox_id, null, null, 1, constraint_type_id 
  from constraint_setting where ref_type_id = 97 and ref_indicator_id = 1 and
  (obj_type_id = 79 or obj_type_id is null);

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');

end;
/



create trigger TD_CUSTOM_ATTR_VAL
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


create trigger TI_CUSTOM_ATTR_VAL
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


create trigger TU_CUSTOM_ATTR_VAL
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


create trigger TD_TREE_HDR
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

end;
/


create trigger TI_TREE_HDR
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create trigger TU_TREE_HDR
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create trigger TD_LOOKUP_TAB_HDR
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

end;
/


create trigger TI_LOOKUP_TAB_HDR
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


create trigger TU_LOOKUP_TAB_HDR
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
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/


prompt 'Marketing Director System Schema has been created'
spool off
exit







