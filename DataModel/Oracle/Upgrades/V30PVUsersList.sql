set heading off
set feedback off
set pages 50
spool V30PVUsersList.log
Prompt 'List of User Identifiers which own objects in V3.0 Prime@Vantage schema:'
prompt
prompt

select unique created_by from campaign union
select unique created_by from campaign union
select unique created_by from camp_grp union
select unique created_by from camp_plan union
select unique created_by from camp_rep_hdr union
select unique created_by from camp_status_hist union
select unique created_by from cdv_hdr union
select unique created_by from charac union
select unique created_by from dataview_templ_hdr union
select unique created_by from data_cat_hdr union
select unique created_by from data_rep_hdr union
select unique created_by from delivery_chan union
select unique created_by from derived_val_hdr union
select unique created_by from elem union
select unique created_by from email_mailbox union
select unique created_by from email_res_rule_hdr union
select unique created_by from email_server union
select unique created_by from ext_templ_hdr union
select unique created_by from lookup_tab_hdr union
select unique created_by from res_model_hdr union
select unique created_by from score_hdr union
select unique created_by from seed_list_hdr union
select unique created_by from seg_hdr union
select unique created_by from strategy union
select unique created_by from treatment union
select unique created_by from tree_hdr union
select unique created_by from web_std_tag union
select unique created_by from web_templ;

spool off 
set feedback on
set heading on
prompt 'List of V3.0 User Identifiers has been generated.'
exit;
