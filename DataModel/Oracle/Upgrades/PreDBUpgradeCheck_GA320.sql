
prompt
prompt
prompt 'V3.2 Prime@Vantage Schema Pre-Upgrade Check'
prompt '==========================================='
prompt
prompt
accept pv_app_role prompt 'Enter name of Prime@Vantage Application Role > '
prompt
prompt
accept sms_alias prompt 'Enter Vantage Alias of the entity containing SMS Telephone Number [Press <ENTER> if not used] > '
prompt
accept sms_col prompt 'Enter Column Name containing SMS Telephone Number [Press <ENTER> if not used ] > '
prompt
prompt

spool PreDBUpgradeCheck_GA320.log
set SERVEROUT ON SIZE 20000


DECLARE

var_count NUMBER:= 0;
var_version_id VARCHAR2(10);
var_ts_pv_sys VARCHAR2(30);
var_ts_pv_ind VARCHAR2(30);
var_ts_pv_comm VARCHAR2(30);
var_ts_pv_cind VARCHAR2(30);
var_camp_id NUMBER:= 0;
var_camp_out_grp_id NUMBER:= 0;
var_camp_out_det_id NUMBER:= 0;
var_split_seq NUMBER:= 0;
var_chan_id NUMBER:= 0;
var_ext_templ_id NUMBER:= 0;
var_bounce_server_id NUMBER:= 0;
var_bounce_mailbox_id NUMBER:= 0;
var_dft_ext_templ_id NUMBER:= 0;
var_server_id NUMBER:= 0;
var_tree_id NUMBER:= 0;
var_tree_seq NUMBER:= 0;
var_origin_type_id NUMBER:= 0;
var_origin_id NUMBER:= 0;
var_origin_sub_id NUMBER:= 0;
var_elem_id NUMBER:= 0;
var_elem_grp_id NUMBER:= 0;

ERROR_ROLE exception;
ERROR_SMS_ALIAS exception;
ERROR_SMS_COL exception;
ERROR_VERSION exception;
ERROR_SYS_TAB exception;
ERROR_SIND_TAB exception;
ERROR_COMM_TAB exception;
ERROR_CIND_TAB exception;
ERROR_RI_ELEM exception;
ERROR_RI_CAMP_OUT_DET_TEMPL exception;
ERROR_RI_CAMP_OUT_DET_CHAN exception;
ERROR_RI_DELIVERY_CHAN_MAIL exception;
ERROR_RI_DELIVERY_CHAN_TEMPL exception;
ERROR_RI_DELIVERY_CHAN_SERVER exception;
ERROR_RI_TREE_DET_TREE exception;
ERROR_RI_TREE_DET_SEG exception;

BEGIN

	select count(*) into var_count from pv_session_roles where role = upper('&pv_app_role');

	IF (var_count = 0) THEN
		RAISE ERROR_ROLE;
	END IF;

	var_count:= 0;
	select count(*) into var_count from cust_tab where vantage_alias = upper('&sms_alias');

	IF (var_count <> 1) THEN
		RAISE ERROR_SMS_ALIAS;
	END IF;

	var_count:= 0;	
	select count(*) into var_count from pv_cols x where exists (select * from cust_tab where
		vantage_alias = '&sms_alias' and db_ent_name = x.table_name and db_ent_owner = x.table_owner) 
		and column_name = upper('&sms_col');

	IF (var_count = 0) THEN
		RAISE ERROR_SMS_COL;
	END IF;

	select count(*) into var_count from pvdm_upgrade where version_id like '3.1.1%';
	
	IF (var_count = 0) THEN
		select version_id into var_version_id from pvdm_upgrade;
		RAISE ERROR_VERSION;
	END IF;

	select count(tablespace_name) into var_count from user_tables where table_name = 'CUST_TAB';

	IF (var_count = 0) THEN
		RAISE ERROR_SYS_TAB;
	END IF;

	select unique tablespace_name into var_ts_pv_sys from user_tables where table_name = 'CUST_TAB';

	select count(unique tablespace_name) into var_count from user_indexes where table_name = 'CUST_TAB';
	
	IF (var_count = 0) THEN
		RAISE ERROR_SIND_TAB;
	END IF;	

	select unique tablespace_name into var_ts_pv_ind from user_indexes where table_name = 'CUST_TAB';

	select count(tablespace_name) into var_count from user_tables where table_name = 'CAMP_COMM_OUT_DET';

	IF (var_count = 0) THEN
		RAISE ERROR_COMM_TAB;
	END IF;
	
	select tablespace_name into var_ts_pv_comm from user_tables where table_name = 'CAMP_COMM_OUT_DET';

	select count(unique tablespace_name) into var_count from user_indexes where table_name = 'CAMP_COMM_OUT_DET';

	IF (var_count = 0) THEN
		RAISE ERROR_CIND_TAB;
	END IF;

	select count(*) into var_count from elem x where elem_grp_id <> 0 and 
		not exists (select * from elem_grp where elem_grp_id = x.elem_grp_id);

	IF (var_count > 0) THEN	  
		select elem_id, elem_grp_id into var_elem_id, var_elem_grp_id from elem x 
			where elem_grp_id <> 0 and not exists (select * from elem_grp 
			where elem_grp_id = x.elem_grp_id);
		RAISE ERROR_RI_ELEM;
	END IF;

	select count(*) into var_count from camp_out_det x where chan_id <> 0 
		and not exists (select * from delivery_chan where chan_id = x.chan_id);

	IF (var_count > 0) THEN	  
		select camp_id, camp_out_grp_id, camp_out_det_id, split_seq, chan_id into
			var_camp_id, var_camp_out_grp_id, var_camp_out_det_id, var_split_seq, var_chan_id
			from camp_out_det x where chan_id <> 0 and not exists 
			(select * from delivery_chan where chan_id = x.chan_id);
		RAISE ERROR_RI_CAMP_OUT_DET_CHAN;
	END IF;
	
  	select count(*) into var_count from camp_out_det x where ext_templ_id is not null 
		and ext_templ_id <> 0 and not exists 
		(select * from ext_templ_hdr where ext_templ_id = x.ext_templ_id);

	IF (var_count > 0) THEN	  
		select camp_id, camp_out_grp_id, camp_out_det_id, split_seq, ext_templ_id into
			var_camp_id, var_camp_out_grp_id, var_camp_out_det_id, var_split_seq, var_ext_templ_id
			from camp_out_det x where ext_templ_id <> 0 and not exists 
			(select * from ext_templ_hdr where ext_templ_id = x.ext_templ_id);
		RAISE ERROR_RI_CAMP_OUT_DET_TEMPL;
	END IF;

  	select count(*) into var_count from delivery_chan x where 
		bounce_server_id is not null and bounce_mailbox_id is not null 
		and bounce_server_id <> 0 and bounce_mailbox_id <> 0 
		and not exists (select * from email_mailbox where server_id = x.bounce_server_id 
		and mailbox_id = x.bounce_mailbox_id);

	IF (var_count > 0) THEN	  
  		select chan_id, bounce_server_id, bounce_mailbox_id into var_chan_id, 
			var_bounce_server_id, var_bounce_mailbox_id from delivery_chan x 
			where bounce_server_id is not null and bounce_mailbox_id is not null 
			and bounce_server_id <> 0 and bounce_mailbox_id <> 0 
			and not exists (select * from email_mailbox where server_id = x.bounce_server_id 
			and mailbox_id = x.bounce_mailbox_id);

		RAISE ERROR_RI_DELIVERY_CHAN_MAIL;
	END IF;

	select count(*) into var_count from delivery_chan x where dft_ext_templ_id <> 0 
		and not exists (select * from ext_templ_hdr where ext_templ_id = x.dft_ext_templ_id);

	IF (var_count > 0) THEN	  
		select chan_id, dft_ext_templ_id into var_chan_id, var_dft_ext_templ_id 
			from delivery_chan x where dft_ext_templ_id <> 0 and not exists 
			(select * from ext_templ_hdr where ext_templ_id = x.dft_ext_templ_id);
		RAISE ERROR_RI_DELIVERY_CHAN_TEMPL;
	END IF;

  	select count(*) into var_count from delivery_chan x where server_id is not null 
		and server_id <> 0 and not exists 
		(select * from email_server where server_id = x.server_id);

	IF (var_count > 0) THEN	  
  		select chan_id, server_id into var_chan_id, var_server_id from delivery_chan x 
		where server_id is not null and server_id <> 0 and not exists 
		(select * from email_server where server_id = x.server_id);
		RAISE ERROR_RI_DELIVERY_CHAN_SERVER;
	END IF;

  	select count(*) into var_count from tree_det x where origin_type_id is not null 
		and origin_id is not null and origin_type_id = 4 and not exists 
		(select * from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);

	IF (var_count > 0) THEN	  
  		select tree_id, tree_seq, origin_id, origin_sub_id into var_tree_id, var_tree_seq,
			var_origin_id, var_origin_sub_id from tree_det x where origin_type_id is not null 
			and origin_id is not null and origin_type_id = 4 and not exists (select * 
			from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);
		RAISE ERROR_RI_TREE_DET_TREE;
	END IF;

	select count(*) into var_count from tree_det x where origin_type_id is not null and 
	    	origin_id is not null and origin_type_id not in (4,0) and not exists (select * 
		from seg_hdr where seg_type_id = x.origin_type_id and seg_id = x.origin_id);

	IF (var_count > 0) THEN	  
  		select tree_id, tree_seq, origin_type_id, origin_id into var_tree_id, var_tree_seq,
			var_origin_type_id, var_origin_id from tree_det x where 
			origin_type_id is not null and origin_id is not null and origin_type_id 
			not in (4,0) and not exists (select * from seg_hdr 
			where seg_type_id = x.origin_type_id and seg_id = x.origin_id);
		RAISE ERROR_RI_TREE_DET_SEG;
	END IF;

	dbms_output.put_line('>');
	dbms_output.put_line('> Your pre V32 Upgrade schema version is correct - ' || var_version_id );
	dbms_output.put_line('> The tablespace name for system tables is '|| var_ts_pv_sys );
	dbms_output.put_line('> The tablespace name for system indexes is '|| var_ts_pv_ind );
	dbms_output.put_line('> The tablespace name for Communication tables is '|| var_ts_pv_comm );
	dbms_output.put_line('> The tablespace name for Communication indexes is '|| var_ts_pv_cind );
	dbms_output.put_line('>');
	dbms_output.put_line('> Note that the entered parameters have been validated - ');
	dbms_output.put_line('> please pass these to the upgrade script when requested.');
	dbms_output.put_line('>');
	dbms_output.put_line('> The Upgrade V31.1 to V3.2 can proceed.');
	dbms_output.put_line('>');
	dbms_output.put_line('>');

EXCEPTION
	WHEN ERROR_ROLE THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The entered Application Role name does not exists');
		dbms_output.put_line('>');
		dbms_output.put_line('> Passed parameter is incorrect.');
		dbms_output.put_line('> Please re-run this V320 Upgrade Check with a correct parameter value.');
		dbms_output.put_line('>');

	WHEN ERROR_SMS_ALIAS THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The entered SMS Vantage Alias is not defined.');
		dbms_output.put_line('>');
		dbms_output.put_line('> Passed parameter is incorrect.');
		dbms_output.put_line('> Please re-run this V320 Upgrade Check with a correct parameter value.');
		dbms_output.put_line('>');

	WHEN ERROR_SMS_COL THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The entered SMS column cannot be found.');
		dbms_output.put_line('>');
		dbms_output.put_line('> Passed parameter is incorrect.');
		dbms_output.put_line('> Please re-run this V320 Upgrade Check with a correct parameter value.');
		dbms_output.put_line('>');

	WHEN ERROR_VERSION THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Your schema version is incorrect - ');
		dbms_output.put_line('> the actual schema version found: '|| var_version_id );
		dbms_output.put_line('> the required version should be: 3.1.1.296.');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_SYS_TAB THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Single tablespace name for CUST_TAB Table cannot be established');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_SIND_TAB THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Single tablespace name for CUST_TAB Indexes cannot be established');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_COMM_TAB THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Single tablespace name for CAMP_COMM_OUT_DET Table cannot be established');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_CIND_TAB THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> Single tablespace name for CAMP_COMM_OUT_DET Indexes cannot be established');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_ELEM THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Element '|| var_elem_id ||' is referencing an Element Group '|| var_elem_grp_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_CAMP_OUT_DET_CHAN THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Campaign Output Details '|| var_camp_id ||','|| var_camp_out_grp_id ||','|| var_camp_out_det_id ||','|| var_split_seq ||' is referencing Delivery Channel '|| var_chan_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_CAMP_OUT_DET_TEMPL THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Campaign Output Details '|| var_camp_id ||','|| var_camp_out_grp_id ||','|| var_camp_out_det_id ||','|| var_split_seq ||' is referencing Extract Template '|| var_ext_templ_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_DELIVERY_CHAN_MAIL THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Delivery Channel '|| var_chan_id ||' is referencing Bounce Mailbox '|| var_bounce_server_id ||','|| var_bounce_mailbox_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_DELIVERY_CHAN_TEMPL THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Delivery Channel '|| var_chan_id ||' is referencing Default Extract Template '|| var_dft_ext_templ_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_DELIVERY_CHAN_SERVER THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Delivery Channel '|| var_chan_id ||' is referencing Email Server '|| var_server_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_TREE_DET_TREE THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Tree Node '|| var_tree_id ||','|| var_tree_seq ||' is referencing Origin Tree Node '|| var_origin_id ||','|| var_origin_sub_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN ERROR_RI_TREE_DET_SEG THEN
		dbms_output.put_line('>');
		dbms_output.put_line('> The Tree Node '|| var_tree_id ||','|| var_tree_seq ||' is referencing Origin Segment '|| var_origin_type_id ||','|| var_origin_id ||' that no longer exist:');
		dbms_output.put_line('>');
		dbms_output.put_line('> The Upgrade V31.1 to V3.2 cannot be applied successfully.');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');

	WHEN OTHERS THEN		
		dbms_output.put_line('>');
		dbms_output.put_line('> Procedure error occurred - more than one entry in PVDM_UPGRADE');
		dbms_output.put_line('>');
		dbms_output.put_line('> Please correct the problem and re-run this V320 Upgrade Check');
		dbms_output.put_line('>');
		RAISE;

END;
/

spool off;
