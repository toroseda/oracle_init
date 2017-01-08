--
-- CheckEmailCampMailbox.sql
--
spool CheckEmailCampMailbox.log
prompt
prompt The CheckEmailCampMailbox.sql script produces a report of any missing data, 
prompt required for successful upgrade of scheduled or executing email campaigns.
prompt
prompt If there are any items are listed below, please enter the missing data 
prompt using V3.1.1 application, prior to executing the upgrade to V3.2.
prompt
prompt
prompt
prompt REPORT: CheckEmailCampMailbox
prompt =============================
prompt

/* check that all required non-delivery mailboxes are specified, i.e. those linked to active email campaigns */

prompt Delivery Channels associated with schedulled email 
prompt campaigns, which do not have non-delivery mailbox defined:
prompt ----------------------------------------------------------

select unique c.chan_id "Delivery Channel ID:" 
	from delivery_chan c, camp_out_det o, camp_status_hist h
 	where c.chan_id = o.chan_id and o.camp_id = h.camp_id and c.send_email_flg = 1 
	and c.bounce_server_id = 0 and c.bounce_mailbox_id = 0 
	and h.camp_hist_seq = (select max(camp_hist_seq) from camp_status_hist 
		where camp_id = h.camp_id) and status_setting_id not in (11,12,16);


/* check that all required email server hostnames are specified, i.e. those linked to active email campaigns */
prompt
prompt Email Servers associated with non-delivery mailboxes 
prompt of scheduled email campaigns, which have a missing hostname:
prompt ------------------------------------------------------------

select unique e.server_id "Email Server ID:" 
	from email_server e, delivery_chan c, camp_out_det o, camp_status_hist h 
	where e.hostname is null and e.server_id = c.bounce_server_id 
	and c.send_email_flg = 1 and c.chan_id = o.chan_id and o.camp_id = h.camp_id 
	and h.status_setting_id not in (11,12,16) and h.camp_hist_seq = 
		(select max(camp_hist_seq) from camp_status_hist where camp_id = h.camp_id);
prompt
prompt
prompt
prompt Please enter missing details, and run the script again to check all data is in place,
prompt before you proceed with the V3.1.1 to V3.2 Upgrade.
prompt
prompt The execution of DBUpgradeGA320.sql script should only proceed, 
prompt if there are no items present on in the above lists.
prompt
prompt
prompt
spool off;
exit;
