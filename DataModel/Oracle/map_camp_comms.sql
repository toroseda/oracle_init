-- 'This Script maps Marketing Director Campaign Communication tables - excepts parameter: Primary Customer Data View name.'
prompt
prompt 'Note: the Customer Tables Mapping must be completed as a prerequisite.'
prompt
prompt
accept web_use prompt 'Will you be using Web communications? Answer Y or N > '
prompt
prompt
accept email_alias prompt 'Enter Vantage Alias of the entity containing the Email Address [Press <ENTER> if not used] > '
prompt
accept email_col prompt 'Enter Column Name containing the Email Address [Press <ENTER> if not used ] > '
prompt
prompt
accept wireless_alias prompt 'Enter Vantage Alias of the entity containing Wireless phone Number [Press <ENTER> if not used] > '
prompt
accept wireless_col prompt 'Enter Column Name containing Wireless phone Number [Press <ENTER> if not used ] > '
prompt
prompt
accept sas_use prompt 'Will you be using SAS scores? Answer Y or N > '
prompt

DECLARE
var_type1_alias varchar2(128);
var_type1_stdcol varchar2(128);
var_pv_owner varchar2(100);
var_email_alias varchar2(128) := '&email_alias';
var_email_col varchar2(128) := '&email_col';
var_wireless_alias varchar2(128) := '&wireless_alias';
var_wireless_col varchar2(128) := '&wireless_col';

BEGIN
select vantage_alias, std_join_from_col into var_type1_alias, var_type1_stdcol from cust_tab where view_id = '&1' and vantage_type = 1;

insert into cust_tab_grp select 99, 'Campaign Communications' from cust_tab_grp where rownum = 1 and
    not exists (select * from cust_tab_grp where cust_tab_grp_id = 99);

insert into cust_tab values ( '&1', 'CAMP_COMM_OUT_HDR', 'Campaign Outbound Communications Header', 99, 99991, NULL, NULL, 'CAMP_COMM_OUT_HDR', user, NULL, NULL, 0, NULL, NULL, 'CAMP_COMM_OUT_DET', 'order by column_name', 1 );
insert into cust_tab values ( '&1', 'CAMP_COMM_OUT_DET', 'Campaign Outbound Communications Details', 99, 99992, NULL, NULL, 'CAMP_COMM_OUT_DET', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
insert into cust_tab values ( '&1', 'COMM_NON_CONTACT', 'Campaign Outbound Non-Contact Details', 99, 99993, NULL, NULL, 'COMM_NON_CONTACT', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
insert into cust_tab values ( '&1', 'CAMP_COMM_IN_HDR', 'Campaign Inbound Communications Header', 99, 99994, NULL, NULL, 'CAMP_COMM_IN_HDR', user,	NULL, NULL, 0, NULL, NULL, 'CAMP_COMM_IN_DET', 'order by column_name', 1 );
insert into cust_tab values ( '&1', 'CAMP_COMM_IN_DET', 'Campaign Inbound Communications Details', 99, 99995, NULL, NULL, 'CAMP_COMM_IN_DET', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );

insert into cust_join values ( '&1', 'CAMP_COMM_OUT_HDR', 1, 'CAMP_COMM_OUT_HDR.CAMP_ID = CAMP_COMM_OUT_DET.CAMP_ID ', 'CAMP_COMM_OUT_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_OUT_HDR', 2, 'AND CAMP_COMM_OUT_HDR.DET_ID = CAMP_COMM_OUT_DET.DET_ID ', 'CAMP_COMM_OUT_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_OUT_HDR', 3, 'AND CAMP_COMM_OUT_HDR.CAMP_CYC = CAMP_COMM_OUT_DET.CAMP_CYC ', 'CAMP_COMM_OUT_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_OUT_HDR', 4, 'AND CAMP_COMM_OUT_HDR.RUN_NUMBER = CAMP_COMM_OUT_DET.RUN_NUMBER ', 'CAMP_COMM_OUT_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_OUT_HDR', 5, 'AND CAMP_COMM_OUT_HDR.COMM_STATUS_ID = CAMP_COMM_OUT_DET.COMM_STATUS_ID', 'CAMP_COMM_OUT_DET' );

insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 1, 'CAMP_COMM_IN_HDR.CAMP_ID = CAMP_COMM_IN_DET.CAMP_ID', 'CAMP_COMM_IN_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 2, 'AND CAMP_COMM_IN_HDR.DET_ID = CAMP_COMM_IN_DET.DET_ID ', 'CAMP_COMM_IN_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 3, 'AND CAMP_COMM_IN_HDR.CAMP_CYC = CAMP_COMM_IN_DET.CAMP_CYC ', 'CAMP_COMM_IN_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 4, 'AND CAMP_COMM_IN_HDR.PLACEMENT_SEQ = CAMP_COMM_IN_DET.PLACEMENT_SEQ ', 'CAMP_COMM_IN_DET' );
insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 5, 'AND CAMP_COMM_IN_HDR.RUN_NUMBER = CAMP_COMM_IN_DET.RUN_NUMBER ', 'CAMP_COMM_IN_DET');
insert into cust_join values ( '&1', 'CAMP_COMM_IN_HDR', 6, 'AND CAMP_COMM_IN_HDR.COMM_STATUS_ID = CAMP_COMM_IN_DET.COMM_STATUS_ID', 'CAMP_COMM_IN_DET' );
COMMIT;

IF ( upper( '&web_use' ) = 'Y' ) THEN
   insert into cust_tab values ( '&1', 'WEB_IMPRESSION', 'Web Communications', 99, 99996, NULL, NULL, 'WEB_IMPRESSION', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
   insert into cust_tab values ( '&1', 'WEB_EXPOSURE', 'Web Exposures', 99, 99997, NULL, NULL, 'WEB_EXPOSURE', user, 'WEB_EXPOSURE', NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
   insert into cust_tab values ( '&1', 'WEB_CLICKTHROUGH', 'Web Clickthroughs', 99, 99998, NULL, NULL, 'WEB_CLICKTHROUGH', user, 'WEB_CLICKTHROUGH', NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
   COMMIT;
END IF;

IF ((var_email_alias IS NOT NULL) AND (var_email_col IS NOT NULL)) THEN
   insert into cust_tab values ( '&1', 'EMAIL_RES', 'Email Inbound Communications', 99, 99999, NULL, NULL, 'EMAIL_RES', user, NULL, NULL, 1, 'EMAIL_ADDRESS', var_email_col, var_email_alias, 'order by column_name', 1 );
   COMMIT;
END IF;

IF ((var_wireless_alias IS NOT NULL) AND (var_wireless_col IS NOT NULL)) THEN
   insert into cust_tab values ( '&1', 'WIRELESS_RES', 'Wireless Inbound Communications', 99, 100000, NULL, NULL, 'WIRELESS_RES', user, NULL, NULL, 1, 'TELEPHONE_NUMBER', var_wireless_col, var_wireless_alias, 'order by column_name', 1 );
   COMMIT;
END IF;

IF ( upper( '&sas_use' ) = 'Y' ) THEN
   insert into cust_tab_grp select 98, 'SAS Score Results' from cust_tab_grp where rownum = 1 and
      not exists (select * from cust_tab_grp where cust_tab_grp_id = 98);
   insert into cust_tab values ( '&1', 'SAS_SCORE_RESULT', 'SAS Score Model Results', 98, 99981, NULL, NULL, 'SAS_SCORE_RESULT', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias, 'order by column_name', 1 );
   COMMIT;
END IF;

-- Insert views into CUST_TAB 
insert into cust_tab values ('&1','TREAT_COMM_INFO','Treatment Communication Details',99,100100,NULL,NULL,'TREAT_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);
insert into cust_tab values ('&1','CHARAC_COMM_INFO','Treatment and Characteristic Communication Details',99,100101,NULL,NULL,'CHARAC_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);
insert into cust_tab values ('&1','ELEM_COMM_INFO','Treatment and Element Communication Details',99,100102,NULL,NULL,'ELEM_COMM_INFO', user, NULL, NULL, 1, 'A1', var_type1_stdcol, var_type1_alias,'order by column_name',1);

COMMIT;

END;
/
prompt 'Campaign Communications have been mapped to Customer Data View '&1' in Customer Tables.'
prompt
exit;
