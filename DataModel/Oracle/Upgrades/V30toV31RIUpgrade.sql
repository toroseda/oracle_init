/* V30 to V31 Referential Integrity Upgrade */

SET FEEDBACK OFF
SET HEADING OFF
SET PAGES 1000
SET LIN 80

spool V30toV31RIError.log

/* clear REFERENCED_OBJ table */

   delete from referenced_obj;
   commit;

   select 'Referential Integrity errors found in the existing data: ' from dual;   
   select '=========================================================' from dual;
   select ' ' from dual;
  
	
/**************/

/* processing table EXT_PROC_CONTROL */

/* If referenced external process group exists, create reference record */

   insert into referenced_obj select 75, x.ext_proc_grp_id, null, null, null, null, null,
     66, x.ext_proc_id, null, null, null, 1, c.constraint_type_id from ext_proc_control x, constraint_setting c 
     where c.ref_type_id = 66 and c.ref_indicator_id = 1 and (c.obj_type_id = 75 or c.obj_type_id is null)
     and x.ext_proc_grp_id is not null and x.ext_proc_grp_id <> 0 and 
     exists (select * from ext_proc_grp where ext_proc_grp_id = x.ext_proc_grp_id);
   
   COMMIT;

/* If referenced external process group does not exist, insert error into log file */
	
   select 'External Process ' || x.ext_proc_id || ' references External Process Group ' || x.ext_proc_grp_id || 'which no longer exists' 
     from ext_proc_control x where x.ext_proc_grp_id is not null and x.ext_proc_grp_id <> 0 and 
     not exists (select * from ext_proc_grp where ext_proc_grp_id = x.ext_proc_grp_id);


/**************/


/* processing table SEG_HDR */
  
/* If referenced segment group exists, create reference record */

  insert into referenced_obj select 73, x.seg_grp_id, x.seg_type_id, null, null, null, null,
    x.seg_type_id, x.seg_id, null, null, null, 1, c.constraint_type_id from seg_hdr x,
    constraint_setting c where c.ref_type_id = x.seg_type_id and c.ref_indicator_id = 1 and
    (c.obj_type_id = 73 or c.obj_type_id is null) and x.seg_grp_id is not null and x.seg_grp_id <> 0 
    and x.seg_type_id not in (0,4) and 
    exists (select * from seg_grp where seg_type_id = x.seg_type_id and seg_grp_id = x.seg_grp_id);
   
   COMMIT;

/* If referenced external process group does not exist, insert error into log file */

  select 'Segment ' || x.seg_type_id || ',' || x.seg_id || ' references Segment Group ' || x.seg_type_id || ',' ||  x.seg_grp_id ||' which no longer exists' 
    from seg_hdr x where x.seg_grp_id is not null and x.seg_grp_id <> 0 and x.seg_type_id not in (0,4) and
    not exists (select * from seg_grp where seg_type_id = x.seg_type_id and seg_grp_id = x.seg_grp_id);


/**************/


/* processing table CAMP_GRP */
  
/* If referenced strategy exists, create reference record */

  insert into referenced_obj select 32, x.strategy_id, null, null, null, null, null, 
    33, x.camp_grp_id, null, null, null, 1, c.constraint_type_id from camp_grp x, 
    constraint_setting c where c.ref_type_id = 33 and c.ref_indicator_id = 1 and 
    (c.obj_type_id = 32 or c.obj_type_id is null) and x.strategy_id is not null and x.strategy_id <> 0 and 
    exists (select * from strategy where strategy_id = x.strategy_id);
   
   COMMIT;

/* If referenced external process group does not exist, insert error into log file */

  select 'Campaign Group ' || x.camp_grp_id || ' references Strategy ' || x.strategy_id || ' which no longer exists'
    from camp_grp x where x.strategy_id is not null and x.strategy_id <> 0 and 
    not exists (select * from strategy where strategy_id = x.strategy_id);

/**************/

/* processing table CAMPAIGN */
  
/* If referenced Campaign Group exists, create reference record */

 insert into referenced_obj select 33, x.camp_grp_id, null, null, null, null, null, 24, x.camp_id, null, null, null, 1, c.constraint_type_id  
   from campaign x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 1 and (c.obj_type_id = 33 or c.obj_type_id is null)
   and camp_grp_id is not null and camp_grp_id <> 0 and 
   exists (select * from camp_grp where camp_grp_id = x.camp_grp_id);

/* If referenced Campaign Manager exists, create reference record */
  
 insert into referenced_obj select 36, x.manager_id, null, null, null, null, null,24, x.camp_id, null, null, null, 1, c.constraint_type_id
   from campaign x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 1 and (c.obj_type_id = 36 or c.obj_type_id is null)
   and x.manager_id is not null and x.manager_id <> 0 and 
   exists (select * from camp_manager where manager_id = x.manager_id);

/* If referenced Budget Manager exists, create reference record */
   
  insert into referenced_obj select 36, x.budget_manager_id, null, null, null, null, null,24, x.camp_id, null, null, null, 4, c.constraint_type_id
    from campaign x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 4 and (c.obj_type_id = 36 or c.obj_type_id is null)
    and x.budget_manager_id is not null and x.budget_manager_id <> 0 and 
    exists (select * from camp_manager where manager_id = x.budget_manager_id);

/* If referenced Campaign Type exists, create reference record */
   
  insert into referenced_obj select 37, x.camp_type_id, null, null, null, null, null, 24, x.camp_id, null, null, null, 1, c.constraint_type_id
    from campaign x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 1 and (c.obj_type_id = 37 or c.obj_type_id is null)
    and x.camp_type_id is not null and x.camp_type_id <> 0 and 
    exists (select * from camp_type where camp_type_id = x.camp_type_id);

/* If referenced Segment (web filter) exists, create reference record */

  insert into referenced_obj select x.web_filter_type_id, x.web_filter_id, null, null, null, null, null, 24, x.camp_id, null, null, null, 1, c.constraint_type_id
    from campaign x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 1 and (c.obj_type_id = x.web_filter_type_id or c.obj_type_id is null)
    and x.web_filter_id is not null and x.web_filter_id <> 0 and 
    exists (select * from seg_hdr where seg_type_id = x.web_filter_type_id and seg_id = x.web_filter_id);
   
   COMMIT;

/* If referenced Campaign group does not exist, insert error into log file */

  select 'Campaign ' || x.camp_id || ' references Campaign Group ' || x.camp_grp_id || ' which no longer exists'
    from campaign x where camp_grp_id is not null and camp_grp_id <> 0 and 
    not exists (select * from camp_grp where camp_grp_id = x.camp_grp_id);

/* If referenced Campaign Manager does not exist, insert error into log file */

  select 'Campaign ' || x.camp_id || ' references Campaign Manager ' || x.manager_id || ' which no longer exists'
    from campaign x where x.manager_id is not null and x.manager_id <> 0 and 
    not exists (select * from camp_manager where manager_id = x.manager_id);

/* If referenced Budget Manager does not exist, insert error into log file */
  
  select 'Campaign ' || x.camp_id || ' references Budget Manager ' || x.budget_manager_id || ' which no longer exists'
    from campaign x where x.budget_manager_id is not null and x.budget_manager_id <> 0 and 
    not exists (select * from camp_manager where manager_id = x.budget_manager_id);

/* If referenced Campaign Type does not exist, insert error into log file */

  select 'Campaign ' || x.camp_id || ' references Campaign Type ' || x.camp_type_id || ' which no longer exists'
    from campaign x where x.camp_type_id is not null and x.camp_type_id <> 0 and 
    not exists (select * from camp_type where camp_type_id = x.camp_type_id);

 /* If referenced Segment (web filter) does not exists, insert error into log file */

  select 'Campaign ' || x.camp_id || ' references Web Filter Segment ' || x.web_filter_type_id || ',' || x.web_filter_id || ' which no longer exists'
    from campaign x where x.web_filter_id is not null and x.web_filter_id <> 0 and 
    not exists (select * from seg_hdr where seg_type_id = x.web_filter_type_id and seg_id = x.web_filter_id);


/**************/


/* processing EMAIL_MAILBOX table */
  
/* If referenced Email Server exists, create reference record */

  insert into referenced_obj select 61, x.server_id, null, null, null, null, null,
    62, x.server_id, x.mailbox_id, null, null, 1, c.constraint_type_id 
    from email_mailbox x, constraint_setting c where c.ref_type_id = 62 and c.ref_indicator_id = 1 and
    (c.obj_type_id = 61 or c.obj_type_id is null) and 
    exists (select * from email_server where server_id = x.server_id);
   
  COMMIT;

/* If referenced Email Server does not exist, insert error into log file */

  select 'Email Mailbox ' || x.server_id ||','|| x.mailbox_id || ' references Email Server ' || x.server_id || ' which no longer exists'
    from email_mailbox x where 
    not exists (select * from email_server where server_id = x.server_id);



/**************/


/* processing DELIVERY_CHAN */
 
/* If referenced Extract Template exists, create reference record */
 
  insert into referenced_obj select 12, x.dft_ext_templ_id, null, null, null, null, null,
    11, x.chan_id, null, null, null, 1, c.constraint_type_id from delivery_chan x, constraint_setting c 
    where c.ref_type_id = 11 and c.ref_indicator_id = 1 and (c.obj_type_id = 12 or c.obj_type_id is null)
    and x.dft_ext_templ_id is not null and x.dft_ext_templ_id <> 0 and 
    exists (select * from ext_templ_hdr where ext_templ_id = x.dft_ext_templ_id);

/* If referenced Email Server exists, create reference record */

  insert into referenced_obj select 61, x.server_id, null, null, null, null, null,
    11, x.chan_id, null, null, null, 1, c.constraint_type_id from delivery_chan x, constraint_setting c 
    where c.ref_type_id = 11 and c.ref_indicator_id = 1 and (c.obj_type_id = 61 or c.obj_type_id is null)
    and x.server_id is not null and x.server_id <> 0 and 
    exists (select * from email_server where server_id = x.server_id);
  
/* If referenced Bounce Email Mailbox exists, create reference record */

  insert into referenced_obj select 62, x.bounce_server_id, x.bounce_mailbox_id, null, null, null, null,
    11, x.chan_id, null, null, null, 1, c.constraint_type_id from delivery_chan x, constraint_setting c
    where c.ref_type_id = 11 and c.ref_indicator_id = 1 and (c.obj_type_id = 62 or c.obj_type_id is null)
    and (x.bounce_server_id is not null and x.bounce_server_id <> 0) 
    and (x.bounce_mailbox_id is not null and x.bounce_mailbox_id <> 0) and 
    exists (select * from email_mailbox where server_id = x.bounce_server_id and mailbox_id = x.bounce_mailbox_id);

/* If referenced Label exists, create reference record */

  insert into referenced_obj select 63, x.label_id, null, null, null, null, null,
    11, x.chan_id, null, null, null, 1, c.constraint_type_id from delivery_chan x, constraint_setting c
    where c.ref_type_id = 11 and c.ref_indicator_id = 1 and (c.obj_type_id = 63 or c.obj_type_id is null)
    and x.label_id is not null and x.label_id <> 0 and 
    exists (select * from label_param where label_id = x.label_id);

  COMMIT;

/* If referenced Extract Template does not exist, insert error into log file */

  select 'Delivery Channel ' || x.chan_id || ' references Extract Template ' || x.dft_ext_templ_id || ' which no longer exists'	
    from delivery_chan x where x.dft_ext_templ_id is not null and x.dft_ext_templ_id <> 0 and 
    not exists (select * from ext_templ_hdr where ext_templ_id = x.dft_ext_templ_id);

/* If referenced Email Server does not exist, insert error into log file */

  select 'Delivery Channel ' || x.chan_id || ' references Email Server ' || x.server_id || ' which no longer exists'	
    from delivery_chan x where x.server_id is not null and x.server_id <> 0 and 
    not exists (select * from email_server where server_id = x.server_id);

/* If referenced Bounce Email Mailbox does not exist, insert error into log file */

  select 'Delivery Channel ' || x.chan_id || ' references Bounce Email Mailbox ' || x.bounce_server_id ||','|| x.bounce_mailbox_id || ' which no longer exists'	
    from delivery_chan x where (x.bounce_server_id is not null and x.bounce_server_id <> 0) 
    and (x.bounce_mailbox_id is not null and x.bounce_mailbox_id <> 0) and 
    not exists (select * from email_mailbox where server_id = x.bounce_server_id and mailbox_id = x.bounce_mailbox_id);

/* If referenced Label does not exist, insert error into log file */

  select 'Delivery Channel ' || x.chan_id || ' references Label ' || x.label_id || ' which no longer exists'	
    from delivery_chan x where x.label_id is not null and x.label_id <> 0 and 
    not exists (select * from label_param where label_id = x.label_id);


/**************/


/* processing CAMP_OUT_DET table */
  
/* If referenced Delivery Channel exists, create reference record */

  insert into referenced_obj select 11, x.chan_id, null, null, null, null, null, 
    24, x.camp_id, x.camp_out_grp_id, x.camp_out_det_id, x.split_seq, 21, 
    c.constraint_type_id from camp_out_det x, constraint_setting c where c.ref_type_id = 24 
    and c.ref_indicator_id = 21 and (c.obj_type_id = 11 or c.obj_type_id is null)
    and x.chan_id is not null and x.chan_id <> 0 and 
    exists (select * from delivery_chan where chan_id = x.chan_id);

/* If referenced Extract Template exists, create reference record */

  insert into referenced_obj select 12, x.ext_templ_id, null, null, null, null, null, 
    24, x.camp_id, x.camp_out_grp_id, x.camp_out_det_id, x.split_seq, 21, 
    c.constraint_type_id from camp_out_det x, constraint_setting c where c.ref_type_id = 24 
    and c.ref_indicator_id = 21 and (c.obj_type_id = 12 or c.obj_type_id is null)
    and x.ext_templ_id is not null and x.ext_templ_id <> 0 and 
    exists (select * from ext_templ_hdr where ext_templ_id = x.ext_templ_id);

  COMMIT;

/* If referenced Delivery Channel does not exist, insert error into log file */

  select 'Campaign Output Detail '|| x.camp_id ||','|| x.camp_out_grp_id ||','|| x.camp_out_det_id ||','|| x.split_seq ||' references Delivery Channel '|| x.chan_id ||' which no longer exists'	
    from camp_out_det x where x.chan_id is not null and x.chan_id <> 0 and 
    not exists (select * from delivery_chan where chan_id = x.chan_id);

/* If referenced Extract Template does not exist, insert error into log file */

  select 'Campaign Output Detail '|| x.camp_id ||','|| x.camp_out_grp_id ||','|| x.camp_out_det_id ||','|| x.split_seq ||' references Extract Template '|| x.ext_templ_id ||' which no longer exists'	
    from camp_out_det x where x.ext_templ_id is not null and x.ext_templ_id <> 0 and 
    not exists (select * from ext_templ_hdr where ext_templ_id = x.ext_templ_id);



/**************/



/* processing TREE_DET table */
  
/* If referenced Segment exists and is a Tree Segment, create reference record */

  insert into referenced_obj select x.origin_type_id, x.origin_id, x.origin_sub_id, null, null, null, null,
    4, x.tree_id, x.tree_seq, null, null, 3, c.constraint_type_id from tree_det x, constraint_setting c
    where c.ref_type_id = 4 and c.ref_indicator_id = 3 and (c.obj_type_id = x.origin_type_id or c.obj_type_id is null)
    and x.origin_type_id = 4 and x.origin_id is not null and x.origin_id <> 0 and 
    x.origin_sub_id is not null and x.origin_sub_id <> 0 and 
    exists (select * from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);

/* If referenced Segment exists and is not a Tree Segment, insert reference record */
 
  insert into referenced_obj select x.origin_type_id, x.origin_id, null, null, null, null, null,
    4, x.tree_id, x.tree_seq, null, null, 3, c.constraint_type_id from tree_det x, constraint_setting c
    where c.ref_type_id = 4 and c.ref_indicator_id = 3 and (c.obj_type_id = x.origin_type_id or c.obj_type_id is null)
    and x.origin_type_id is not null and x.origin_type_id not in (0,4) and x.origin_id is not null and 
    exists (select * from seg_hdr where seg_type_id = x.origin_type_id and seg_id = x.origin_id);

COMMIT;

/* If referenced Tree Segment does not exist, insert error into log file */

  select 'Segmentation Tree ' || x.tree_id ||','|| x.tree_seq || ' references Tree Segment ' || x.origin_id ||','|| x.origin_sub_id || ' which no longer exists'	
    from tree_det x where x.origin_type_id = 4 and x.origin_id is not null and x.origin_sub_id is not null and x.origin_id <> 0 
    and x.origin_sub_id <> 0 and 
    not exists (select * from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);

/* If referenced Segment does not exist, insert error into log file */

  select 'Segmentation Tree ' || x.tree_id ||','|| x.tree_seq || ' references Segment ' || x.origin_type_id ||','|| x.origin_id || ' which no longer exists'	
    from tree_det x where x.origin_type_id is not null and x.origin_type_id not in (0,4) and x.origin_id is not null and 
    not exists (select * from seg_hdr where seg_type_id = x.origin_type_id and seg_id = x.origin_id);



/**************/



/* processing TREATMENT table */
  
/* If referenced Treatment Group exists, create reference record */

  insert into REFERENCED_OBJ select 41, x.treatment_grp_id, null, null, null, null, null, 18, x.treatment_id, null, null, null, 1, constraint_type_id
    from treatment x, constraint_setting c where c.ref_type_id = 18 and c.ref_indicator_id = 1 and (c.obj_type_id = 41 or c.obj_type_id is null)
    and x.treatment_grp_id is not null and x.treatment_grp_id <> 0 and 
    exists (select * from treatment_grp where treatment_grp_id = x.treatment_grp_id);

  COMMIT;

/* If referenced Treatment Group does not exist, insert error into log file */

  select 'Treatment ' || x.treatment_id || ' references Treatment Group ' || x.treatment_grp_id || ' which no longer exists'	
    from treatment x where x.treatment_grp_id is not null and x.treatment_grp_id <> 0 and 
    not exists (select * from treatment_grp where treatment_grp_id = x.treatment_grp_id);



/**************/



/* processing CAMP_DET table */
  
/* If referenced Treatment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null)
    and (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 18 and 
    exists (select * from treatment where treatment_id = x.obj_id);

/* If referenced Response Model exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null)
    and (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 19 and 
    exists (select * from res_model_hdr where res_model_id = x.obj_id);

/* If referenced Response Stream exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, x.obj_sub_id, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null)
    and (x.obj_sub_id is not null and x.obj_sub_id <> 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 20 and 
    exists (select * from res_model_stream where res_model_id = x.obj_id and res_stream_id = x.obj_sub_id);

/* If referenced Task Group exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) 
    and (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 17 and 
    exists (select * from spi_master where spi_id = x.obj_id);

/* If referenced Segment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null)
    and (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id in (1,28,29) and 
    exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);

/* If referenced Tree Segment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, x.obj_sub_id, null, null, null, null, 
    24, x.camp_id, x.det_id, null, null, 3, c.constraint_type_id from camp_det x, constraint_setting c
    where c.ref_type_id = 24 and c.ref_indicator_id = 3 and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null)
    and (x.obj_sub_id is not null and x.obj_sub_id <> 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 4 and 
    exists (select * from tree_det where tree_id = x.obj_id and tree_seq = x.obj_sub_id);

  COMMIT;

/* If referenced Treatment does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id || ' references Treatment ' || x.obj_id || ' which no longer exists'
    from camp_det x where (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 18 and 
    not exists (select * from treatment where treatment_id = x.obj_id);

/* If referenced Response Model does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id || ' references Response Model ' || x.obj_id || ' which no longer exists'
    from camp_det x where (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null 
    and x.obj_id <> 0 and x.obj_type_id = 19 and 
    not exists (select * from res_model_hdr where res_model_id = x.obj_id);

/* If referenced Response Stream does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id || ' references Response Stream ' || x.obj_id ||','|| x.obj_sub_id ||' which no longer exists'
    from camp_det x where (x.obj_sub_id is not null and x.obj_sub_id <> 0) and 
    x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 20 and 
    not exists (select * from res_model_stream where res_model_id = x.obj_id and res_stream_id = x.obj_sub_id);

/* If referenced Task Group does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id || ' references Task Group ' || x.obj_id || ' which no longer exists'
    from camp_det x where (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 17 and 
    not exists (select * from spi_master where spi_id = x.obj_id);

/* If referenced Segment does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id || ' references Segment ' || x.obj_type_id ||','|| x.obj_id || ' which no longer exists'
    from camp_det x where (x.obj_sub_id is null or x.obj_sub_id = 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id in (1,28,29) and 
    not exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);

/* If referenced Tree Segment does not exist, insert error into log file */

  select 'Campaign Detail ' || x.camp_id ||','|| x.det_id ||' references Tree Segment '|| x.obj_id ||','|| x.obj_sub_id ||' which no longer exists'
    from camp_det x where (x.obj_sub_id is not null and x.obj_sub_id <> 0) and x.obj_id is not null and x.obj_id <> 0 and x.obj_type_id = 4 and 
    not exists (select * from tree_det where tree_id = x.obj_id and tree_seq = x.obj_sub_id);


 
/**************/



/* processing WEB_TEMPL table */
  
/* If referenced Web Template Group exists, create reference record */

  insert into referenced_obj select 72, x.web_templ_grp_id, null, null, null, null, null,
    67, x.web_templ_id, null, null, null, 1, c.constraint_type_id from web_templ x, constraint_setting c
    where c.ref_type_id = 67 and c.ref_indicator_id = 1 and (c.obj_type_id = 72 or c.obj_type_id is null)
    and x.web_templ_id is not null and x.web_templ_id <> 0 and 
    exists (select * from web_templ_grp where web_templ_grp_id = x.web_templ_grp_id);

  COMMIT;
 
/* If referenced Web Template Group does not exist, insert error into log file */

  select 'Web Template ' || x.web_templ_id || ' references Web Template Group ' || x.web_templ_grp_id ||' which no longer exists'
    from web_templ x where x.web_templ_id is not null and x.web_templ_id <> 0 and 
    not exists (select * from web_templ_grp where web_templ_grp_id = x.web_templ_grp_id);



/**************/



/* processing WEB_TEMPL_TAG table */
  
/* If referenced default Element exists, create reference record */

  insert into referenced_obj select 44, x.dft_elem_id, null, null, null, null, null,
    68, x.web_templ_id, x.web_tag_id, null, null, 1, c.constraint_type_id from  web_templ_tag x, 
    constraint_setting c where c.ref_type_id = 68 and c.ref_indicator_id = 1 and 
    (c.obj_type_id = 44 or c.obj_type_id is null) and x.dft_elem_id is not null and x.dft_elem_id <> 0 and 
    exists (select * from elem where elem_id = x.dft_elem_id);

  COMMIT;

/* If referenced default Element does not exist, insert error into log file */

  select 'Web Template Tag ' || x.web_templ_id ||','|| x.web_tag_id ||' references Element '|| x.dft_elem_id ||' which no longer exists'
    from  web_templ_tag x where x.dft_elem_id is not null and x.dft_elem_id <> 0 and
    not exists (select * from elem where elem_id = x.dft_elem_id);



/**************/



/* processing WEB_TEMPL_TAG_DET table */
  
/* If referenced Campaign Detail exists, create reference record */

  insert into referenced_obj select 24, x.camp_id, x.det_id, null, null, null, null,
    68, x.web_templ_id, x.web_tag_id, x.camp_id, x.det_id, 3, c.constraint_type_id
    from web_templ_tag_det x, constraint_setting c where c.ref_type_id = 68 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 24 or c.obj_type_id is null) and x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and
    exists (select * from camp_det where camp_id = x.camp_id and det_id = x.det_id);

/* If referenced Treatment-Element link record exists, create reference record */

  insert into referenced_obj select 71, t.treatment_id, x.elem_id, null, null, null, null, 
    68, x.web_templ_id, x.web_tag_id, x.camp_id, x.det_id, 3, c.constraint_type_id 
    from web_templ_tag_det x, telem t, camp_det d, constraint_setting c where t.elem_id = x.elem_id and 
    t.treatment_id = d.obj_id and d.camp_id = x.camp_id and d.det_id = x.det_id and 
    c.ref_type_id = 68 and c.ref_indicator_id = 3 and (c.obj_type_id = 71 or c.obj_type_id is null) and
    x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and 
    exists (select * from telem y, camp_det z where y.elem_id = x.elem_id and 
    y.treatment_id = z.obj_id and z.camp_id = x.camp_id and z.det_id = x.det_id);

/* If referenced Element record exists, create reference record */

  insert into referenced_obj select 44, x.elem_id, null, null, null, null, null, 
    68, x.web_templ_id, x.web_tag_id, x.camp_id, x.det_id, 3, c.constraint_type_id 
    from web_templ_tag_det x, constraint_setting c where c.ref_type_id = 68 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = 44 or c.obj_type_id is null) and x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and
    exists (select * from elem where elem_id = x.elem_id);

  COMMIT;

/* If referenced Campaign Detail does not exist, insert error into log file */

  select 'Web Template Tag Detail '|| x.web_templ_id ||','|| x.web_tag_id ||','|| x.camp_id ||','|| x.det_id ||' references Campaign Detail '|| x.camp_id ||','|| x.det_id ||' which no longer exists'
    from web_templ_tag_det x where x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and
    not exists (select * from camp_det where camp_id = x.camp_id and det_id = x.det_id);

/* If referenced Treatment-Element link record does not exist, insert error into log file */

  select 'Web Template Tag Detail '|| x.web_templ_id ||','|| x.web_tag_id ||','|| x.camp_id ||','|| x.det_id ||' references Treatment-Element link '|| t.treatment_id ||','|| x.elem_id ||' which no longer exists'
    from web_templ_tag_det x, telem t, camp_det d where t.elem_id = x.elem_id and 
    t.treatment_id = d.obj_id and d.camp_id = x.camp_id and d.det_id = x.det_id and 
    x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and 
    not exists (select * from telem y, camp_det z where y.elem_id = x.elem_id and 
    y.treatment_id = z.obj_id and z.camp_id = x.camp_id and z.det_id = x.det_id);

/* If referenced Element record does not exist, insert error into log file */

  select 'Web Template Tag Detail '|| x.web_templ_id ||','|| x.web_tag_id ||','|| x.camp_id ||','|| x.det_id ||' references Element '|| x.elem_id ||' which no longer exists'
    from web_templ_tag_det x where x.camp_id <> 0 and x.det_id <> 0 and x.elem_id <> 0 and
    not exists (select * from elem where elem_id = x.elem_id);



/**************/



/* processing MAILBOX_RES_RULE table */
 
/* If referenced Email Rule exists, create reference record */

  insert into referenced_obj select 69, x.rule_id, null, null, null, null, null,
    62, x.server_id, x.mailbox_id, null, null, 1, c.constraint_type_id from
    mailbox_res_rule x, constraint_setting c where c.ref_type_id = 62 and c.ref_indicator_id = 1 
    and (c.obj_type_id = 69 or c.obj_type_id is null) and x.rule_id <> 0 and 
    exists (select * from email_res_rule_hdr where rule_id = x.rule_id);

  COMMIT;

/* If referenced Email Rule does not exist, insert error into log file */

  select 'Email Mailbox ' || x.server_id ||','|| x.mailbox_id ||' references Email Rule '|| x.rule_id ||' which no longer exists'
    from mailbox_res_rule x where x.rule_id <> 0 and 
    not exists (select * from email_res_rule_hdr where rule_id = x.rule_id);



/**************/



/* processing ELEM table */
  
/* If referenced Element Group exists, create reference record */

  insert into referenced_obj select 43, x.elem_grp_id, null, null, null, null, null, 44, 
    x.elem_id, null, null, null, 1, c.constraint_type_id
    from elem x, constraint_setting c where c.ref_type_id = 44 and c.ref_indicator_id = 1 
    and (c.obj_type_id = 43 or c.obj_type_id is null) and x.elem_grp_id is not null and x.elem_grp_id <> 0 and 
    exists (select * from elem_grp where elem_grp_id = x.elem_grp_id);
  
  COMMIT;

/* If referenced Element Group does not exist, insert error into log file */

  select 'Element ' || x.elem_id ||' references Element Group '|| x.elem_grp_id ||' which no longer exists'
    from elem x where x.elem_grp_id is not null and x.elem_grp_id <> 0 and 
    not exists (select * from elem_grp where elem_grp_id = x.elem_grp_id);



/**************/



/* processing CAMP_POST table */
  
/* If referenced Poster Contractor exists, create reference record */

  insert into referenced_obj select 55, x.contractor_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 12, c.constraint_type_id
    from camp_post x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 12 and
    (c.obj_type_id = 55 or c.obj_type_id is null) and x.contractor_id is not null and x.contractor_id <> 0 and
    exists (select * from poster_contractor where contractor_id = x.contractor_id);

/* If referenced Poster Size record exists, create reference record */

  insert into referenced_obj select 53, x.poster_size_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 12, c.constraint_type_id
    from camp_post x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 12 and
    (c.obj_type_id = 53 or c.obj_type_id is null) and x.poster_size_id is not null and x.poster_size_id <> 0 and
    exists (select * from poster_size where poster_size_id = x.poster_size_id);

/* If referenced Poster Type record exists, create reference record */

  insert into referenced_obj select 54, x.poster_type_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 12, c.constraint_type_id
    from camp_post x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 12 and
    (c.obj_type_id = 54 or c.obj_type_id is null) and x.poster_type_id is not null and x.poster_type_id <> 0 and
    exists (select * from poster_type where poster_type_id = x.poster_type_id);

  COMMIT;

/* If referenced Poster Contractor does not exist, insert error into log file */

  select 'Campaign Post Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Poster Contractor '|| x.contractor_id ||' which no longer exists'
    from camp_post x where x.contractor_id is not null and x.contractor_id <> 0 and
    not exists (select * from poster_contractor where contractor_id = x.contractor_id);

/* If referenced Poster Size record does not exist, insert error into log file */

  select 'Campaign Post Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Poster Size '|| x.poster_size_id ||' which no longer exists'
    from camp_post x where x.poster_size_id is not null and x.poster_size_id <> 0 and
    not exists (select * from poster_size where poster_size_id = x.poster_size_id);

/* If referenced Poster Type record does not exist, insert error into log file */

  select 'Campaign Post Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Poster Type '|| x.poster_type_id ||' which no longer exists'
    from camp_post x where x.poster_type_id is not null and x.poster_type_id <> 0 and
    not exists (select * from poster_type where poster_type_id = x.poster_type_id);



/**************/



/* processing DERIVED_VAL_HDR table */
  
/* If referenced Derived Value Criteria exists, create reference record */

  insert into referenced_obj select 15, x.where_seg_id, null, null, null, null, null, 13, 
    x.derived_val_id, null, null, null, 1, c.constraint_type_id from derived_val_hdr x, constraint_setting c
    where c.ref_type_id = 13 and c.ref_indicator_id = 1 and (c.obj_type_id = 13 or c.obj_type_id is null)
    and x.where_seg_id is not null and x.where_seg_id <> 0 and
    exists (select * from seg_hdr where seg_type_id = 15 and seg_id = x.where_seg_id);

/* If referenced Derived Value Criteria does not exist, insert error into log file */

  select 'Derived Value ' || x.derived_val_id ||' references Derived Value Criteria '|| x.where_seg_id ||' which no longer exists'
    from derived_val_hdr x where x.where_seg_id is not null and x.where_seg_id <> 0 and
    not exists (select * from seg_hdr where seg_type_id = 15 and seg_id = x.where_seg_id);



/**************/



/* processing DATA_REP_DET table */
  
/* If referenced Derived Value exists, create reference record */

  insert into referenced_obj select 13, x.comp_id, null, null, null, null, null, 
    7, x.data_rep_id, x.row_flg, x.data_rep_seq, null, 3, c.constraint_type_id
    from data_rep_det x, constraint_setting c where c.ref_type_id = 7 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = 13 or c.obj_type_id is null) and x.comp_type_id = 4 and 
    exists (select * from derived_val_hdr where derived_val_id = x.comp_id);

/* If referenced Score Model exists, create reference record */

  insert into referenced_obj select 9, x.comp_id, null, null, null, null, null, 
    7, x.data_rep_id, x.row_flg, x.data_rep_seq, null, 3, c.constraint_type_id
    from data_rep_det x, constraint_setting c where c.ref_type_id = 7 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = 9 or c.obj_type_id is null) and x.comp_type_id = 5 and 
    exists (select * from score_hdr where score_id = x.comp_id);

/* If referenced Lookup Table exists, create reference record */

  insert into referenced_obj select 8, to_number(substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')-(instr(x.cond_val,' [')+2))),
    null, null, null, null, null, 7, x.data_rep_id, x.row_flg, x.data_rep_seq, null, 20, c.constraint_type_id
    from data_rep_det x, constraint_setting c where c.ref_type_id = 7 and c.ref_indicator_id = 3 and
    (c.obj_type_id = 8 or c.obj_type_id is null) and x.cond_val is not null and x.cond_val like '% [%]%' and
    exists (select * from vantage_dyn_tab where 
    vantage_alias = 'LT'|| substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')- (instr(x.cond_val,' [')+2)));

  COMMIT;

/* If referenced Derived Value does not exist, insert error into log file */

  select 'Data Report Detail ' || x.data_rep_id ||','|| x.row_flg ||','|| x.data_rep_seq ||' references Derived Value '|| x.comp_id ||' which no longer exists'
    from data_rep_det x where x.comp_type_id = 4 and 
    not exists (select * from derived_val_hdr where derived_val_id = x.comp_id);

/* If referenced Score Model does not exist, insert error into log file */

  select 'Data Report Detail ' || x.data_rep_id ||','|| x.row_flg ||','|| x.data_rep_seq ||' references Score Model '|| x.comp_id ||' which no longer exists'
    from data_rep_det x where x.comp_type_id = 5 and 
    not exists (select * from score_hdr where score_id = x.comp_id);

/* If referenced Lookup Table does not exist, insert error into log file */

  select 'Data Report Detail (cond.value) ' || x.data_rep_id ||','|| x.row_flg ||','|| x.data_rep_seq ||' references Lookup Table '|| to_number(substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')-(instr(x.cond_val,' [')+2))) ||' which no longer exists'
    from data_rep_det x where x.cond_val is not null and x.cond_val like '% [%]%' and
    not exists (select * from vantage_dyn_tab where 
    vantage_alias = 'LT'|| substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')- (instr(x.cond_val,' [')+2)));


/**************/


/* processing SCORE_SRC table */
  
/* If referenced Tree Segment exists, create reference record */

   insert into referenced_obj select x.src_type_id, x.src_id, x.src_sub_id, null, null, null, null, 
     9, x.score_id, null, null, null, 2, c.constraint_type_id 
     from score_src x, constraint_setting c where c.ref_type_id = 9 and c.ref_indicator_id = 2 and 
     (c.obj_type_id = 9 or c.obj_type_id is null) and x.src_type_id = 4 and x.src_sub_id <> 0 and 
     exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);

/* If referenced Segment exists, create reference record */

  insert into referenced_obj select x.src_type_id, x.src_id, null, null, null, null, null, 
    9, x.score_id, null, null, null, 2, c.constraint_type_id from score_src x, constraint_setting c 
    where c.ref_type_id = 9 and c.ref_indicator_id = 2 and (c.obj_type_id = 9 or c.obj_type_id is null)
    and x.src_type_id is not null and x.src_type_id not in (0,4) and 
    exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);

  COMMIT;

/* If referenced Tree Segment does not exist, insert error into log file */

  select 'Score Model Source ' || x.score_id ||' references Tree Segment '|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from score_src x where x.src_type_id = 4 and x.src_sub_id <> 0 and 
    not exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);

/* If referenced Segment does not exist, insert error into log file */

  select 'Score Model Source ' || x.score_id ||' references Segment '|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from score_src x where x.src_type_id is not null and x.src_type_id not in (0,4) and 
    not exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);



/**************/



/* processing DERIVED_VAL_SRC table */
  
/* If referenced Tree Segment exists, create reference record */

  insert into referenced_obj select x.src_type_id, x.src_id, x.src_sub_id, null, null, null, null, 13, x.derived_val_id, null, null, 
    null, 2, c.constraint_type_id from derived_val_src x, constraint_setting c where c.ref_type_id = 13 and c.ref_indicator_id = 2 and 
    (c.obj_type_id = x.src_type_id or c.obj_type_id is null) and x.src_type_id =4 and 
    exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);
   
/* If referenced Segment exists, create reference record */

  insert into referenced_obj select x.src_type_id, x.src_id, null, null, null, null, null, 13, x.derived_val_id, null, null, 
    null, 2, c.constraint_type_id from derived_val_src x, constraint_setting c where c.ref_type_id = 13 and c.ref_indicator_id = 2 and 
    (c.obj_type_id = x.src_type_id or c.obj_type_id is null) and x.src_type_id not in (0,4) and 
    exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);
 
  COMMIT;
  
/* If referenced Tree Segment does not exist, insert error into log file */

  select 'Derived Value Source ' || x.derived_val_id ||' references Tree Segment '|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from derived_val_src x where x.src_type_id = 4 and 
    not exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);

/* If referenced Segment does not exist, insert error into log file */

  select 'Derived Value Source ' || x.derived_val_id ||' references Segment '|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from derived_val_src x where x.src_type_id not in (0,4) and 
    not exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);



/**************/



/* processing EXT_TEMPL_DET table */
  
/* if referenced derived value component exists, create reference record */
       
  insert into referenced_obj select 13, x.comp_id, null, null, x.src_type_id, x.src_id, x.src_sub_id, 
    12, x.ext_templ_id, x.line_seq, null, null, 3, c.constraint_type_id
    from ext_templ_det x, constraint_setting c where c.ref_type_id = 12 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = 13 or c.obj_type_id is null) and x.comp_type_id = 4 and 
    exists (select * from derived_val_src where derived_val_id = x.comp_id and src_type_id = x.src_type_id and 
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced score model component exists, create reference record */

  insert into referenced_obj select 9, x.comp_id, null, null, x.src_type_id, x.src_id, x.src_sub_id, 
    12, x.ext_templ_id, x.line_seq, null, null, 3, c.constraint_type_id
    from ext_templ_det x, constraint_setting c where c.ref_type_id = 12 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 9 or c.obj_type_id is null) and x.comp_type_id = 5 and 
    exists (select * from score_src where score_id = x.comp_id and src_type_id = x.src_type_id and 
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced constructed field component exists, create reference record */

  insert into referenced_obj select 31, x.comp_id, null, null, null, null, null,
    12, x.ext_templ_id, x.line_seq, null, null, 3, c.constraint_type_id from 
    ext_templ_det x, constraint_setting c where c.ref_type_id = 12 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 31 or c.obj_type_id is null) and x.comp_type_id = 3 and 
    exists (select * from cons_fld_hdr where cons_id = x.comp_id);

  COMMIT;

/* if referenced derived value component does not exist, insert error into log file */

  select 'Extract Template Detail ' || x.ext_templ_id ||','|| x.line_seq ||' references Derived Value Source '|| x.comp_id ||','|| x.src_type_id ||','|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from ext_templ_det x where x.comp_type_id = 4 and 
    not exists (select * from derived_val_src where derived_val_id = x.comp_id and src_type_id = x.src_type_id and 
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced score model component does not exist, insert error into log file */

  select 'Extract Template Detail ' || x.ext_templ_id ||','|| x.line_seq ||' references Score Model Source '|| x.comp_id ||','|| x.src_type_id ||','|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from ext_templ_det x where x.comp_type_id = 5 and 
    not exists (select * from score_src where score_id = x.comp_id and src_type_id = x.src_type_id and 
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced constructed field component does not exist, insert error into log file */

  select 'Extract Template Detail ' || x.ext_templ_id ||','|| x.line_seq ||' references Constructed Field '|| x.comp_id ||' which no longer exists'
    from ext_templ_det x where x.comp_type_id = 3 and 
    not exists (select * from cons_fld_hdr where cons_id = x.comp_id);


/**************/


/* processing TELEM table */
 
/* if referenced element exists, create reference record */ 

  insert into referenced_obj select 44, x.elem_id, null, null, null, null, null, 
    18, x.treatment_id, null, null, null, 1, c.constraint_type_id
    from telem x, constraint_setting c where c.ref_type_id = 18 and c.ref_indicator_id = 1 
    and (c.obj_type_id = 44 or c.obj_type_id is null) and
    exists (select * from elem where elem_id = x.elem_id);

  COMMIT;

/* if referenced element does not exist, insert error into log file */

  select 'Treatment ' || x.treatment_id ||' references Element '|| x.elem_id ||' which no longer exists'
    from telem x where  
    not exists (select * from elem where elem_id = x.elem_id);


/**************/


/* processing TCHARAC table */
  
/* if referenced characteristic exists, create reference record */ 

  insert into referenced_obj select 42, x.charac_id, null, null, null, null, null, 
    18, x.treatment_id, null, null, null, 1, c.constraint_type_id
    from tcharac x, constraint_setting c where c.ref_type_id = 18 and c.ref_indicator_id = 1 
    and (c.obj_type_id = 42 or c.obj_type_id is null) and
    exists (select * from charac where charac_id = x.charac_id);

  COMMIT;


/* if referenced characteristic does not exist, insert error into log file */

  select 'Treatment ' || x.treatment_id ||' references Characteristic '|| x.charac_id ||' which no longer exists'
    from tcharac x where  
    not exists (select * from charac where charac_id = x.charac_id);


/**************/


/* processing STORED_FLD_TEMPL table */
  
/* If referenced dynamic Derived value table exists, create reference record */
 
  insert into referenced_obj select 13, d.derived_val_id, null, null, d.src_type_id, d.src_id, d.src_sub_id,
    x.seg_type_id, x.seg_id, x.seq_number, null, null, 7, c.constraint_type_id from stored_fld_templ x, vantage_dyn_tab v,
    derived_val_src d, constraint_setting c where x.vantage_alias = v.vantage_alias and v.obj_type_id = 13 and 
    x.vantage_alias = d.dyn_tab_name and c.ref_type_id = x.seg_type_id and c.ref_indicator_id = 7 and 
    (c.obj_type_id = 13 or c.obj_type_id is null) and 
    exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias and obj_type_id = 13);


/* If referenced dynamic Score table exists, create reference record */
 
  insert into referenced_obj select 9, d.score_id, null, null, d.src_type_id, d.src_id, d.src_sub_id,
    x.seg_type_id, x.seg_id, x.seq_number, null, null, 7, c.constraint_type_id from stored_fld_templ x, vantage_dyn_tab v,
    score_src d, constraint_setting c where x.vantage_alias = v.vantage_alias and v.obj_type_id = 13 and 
    x.vantage_alias = d.dyn_tab_name and c.ref_type_id = x.seg_type_id and c.ref_indicator_id = 7 and 
    (c.obj_type_id = 9 or c.obj_type_id is null) and 
    exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias and obj_type_id = 9);

  COMMIT;

/* If referenced Vantage does not exist, enter error into log file */

  select 'Stored Field Template ' || x.seg_type_id ||','|| x.seg_id ||','|| x.seq_number ||' references Vantage Alias '|| x.vantage_alias ||' which no longer exists'
    from stored_fld_templ x where not exists (select * from cust_tab where vantage_alias = x.vantage_alias) and
    not exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias);


 
/**************/



/* processing CAMP_RADIO table */
  
/* if referenced Radio exists, create reference record */ 

  insert into referenced_obj select 56, x.radio_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 13, c.constraint_type_id
    from camp_radio x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 13 and
    (c.obj_type_id = 56 or c.obj_type_id is null) and x.radio_id is not null and x.radio_id <> 0 and
    exists (select * from radio where radio_id = x.radio_id);

/* if referenced Radio Region exists, create reference record */

  insert into referenced_obj select 57, x.radio_region_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 13, c.constraint_type_id
    from camp_radio x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 13 and
    (c.obj_type_id = 57 or c.obj_type_id is null) and x.radio_region_id is not null and x.radio_region_id <> 0 and 
    exists (select * from radio_region where radio_region_id = x.radio_region_id);

  COMMIT;

/* if referenced Radio does not exist, insert error into log file */

  select 'Campaign Radio Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Radio '|| x.radio_id ||' which no longer exists'
    from camp_radio x where x.radio_id is not null and x.radio_id <> 0 and
    not exists (select * from radio where radio_id = x.radio_id);

/* if referenced Radio Region does not exist, insert error into log file */

  select 'Campaign Radio Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Radio Region '|| x.radio_region_id ||' which no longer exists'
    from camp_radio x where x.radio_region_id is not null and x.radio_region_id <> 0 and 
    not exists (select * from radio_region where radio_region_id = x.radio_region_id);



/**************/



/* processing CAMP_LEAF table */
  
/* if referenced campaing leaflet region exists, create reference record */

  insert into referenced_obj select 49, x.leaf_region_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 11, c.constraint_type_id
    from camp_leaf x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 11 
    and (c.obj_type_id = 49 or c.obj_type_id is null) 
    and x.leaf_region_id is not null and x.leaf_region_id <> 0 and 
    exists (select * from leaf_region where leaf_region_id = x.leaf_region_id);

/* if referenced campaing leaflet distributor exists, create reference record */

  insert into referenced_obj select 50, x.leaf_distrib_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 11, c.constraint_type_id
    from camp_leaf x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 11 
    and (c.obj_type_id = 50 or c.obj_type_id is null) 
    and x.leaf_distrib_id is not null and x.leaf_distrib_id <> 0 and
    exists (select * from leaf_distrib where leaf_distrib_id = x.leaf_distrib_id);

/* if referenced campaing collection point exists, create reference record */

  insert into referenced_obj select 51, x.collect_point_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 11, c.constraint_type_id
    from camp_leaf x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 11 
    and (c.obj_type_id = 51 or c.obj_type_id is null) 
    and (x.collect_point_id is not null and x.collect_point_id <> 0) and
    exists (select * from collect_point where collect_point_id = x.collect_point_id);

/* if referenced campaing distribution point exists, create reference record */

  insert into referenced_obj select 52, x.distrib_point_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 11, c.constraint_type_id
    from camp_leaf x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 11 
    and (c.obj_type_id = 52 or c.obj_type_id is null)
    and (x.distrib_point_id is not null and x.distrib_point_id <> 0) and
    exists (select * from distrib_point where distrib_point_id = x.distrib_point_id);

  COMMIT;

/* if referenced campaing leaflet region does not exist, insert error into log file */

  select 'Campaign Leaflet Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Leaflet Region '|| x.leaf_region_id ||' which no longer exists'
    from camp_leaf x where x.leaf_region_id is not null and x.leaf_region_id <> 0 and 
    not exists (select * from leaf_region where leaf_region_id = x.leaf_region_id);

/* if referenced campaing leaflet distributor does not exist, insert error into log file */

  select 'Campaign Leaflet Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Leaflet Distributor '|| x.leaf_distrib_id ||' which no longer exists'
    from camp_leaf x where x.leaf_distrib_id is not null and x.leaf_distrib_id <> 0 and
    not exists (select * from leaf_distrib where leaf_distrib_id = x.leaf_distrib_id);

/* if referenced campaing collection point does not exist, insert error into log file */

  select 'Campaign Leaflet Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Collection Point '|| x.collect_point_id ||' which no longer exists'
    from camp_leaf x where x.collect_point_id is not null and x.collect_point_id <> 0 and
    not exists (select * from collect_point where collect_point_id = x.collect_point_id);

/* if referenced campaing distribution point does not exist, insert error into log file */

  select 'Campaign Leaflet Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Distribution Point '|| x.distrib_point_id ||' which no longer exists'
    from camp_leaf x where x.distrib_point_id is not null and x.distrib_point_id <> 0 and
    not exists (select * from distrib_point where distrib_point_id = x.distrib_point_id);


/**************/


/* processing SCORE_DET table */

/* if referenced Derived Value exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    9, x.score_id, x.score_seq, null, null, 3, c.constraint_type_id
    from score_det x, constraint_setting c where c.ref_type_id = 9 and c.ref_indicator_id = 3 
    and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 13 and
    exists (select * from derived_val_hdr where derived_val_id = x.obj_id);

/* if referenced Segment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null, 
    9, x.score_id, x.score_seq, null, null, 3, c.constraint_type_id
    from score_det x, constraint_setting c where c.ref_type_id = 9 and c.ref_indicator_id = 3 
    and (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id not in (0,13) and
    exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);

  COMMIT;

/* if referenced Derived Value does not exist, insert error into log file */

  select 'Score Detail ' || x.score_id ||','|| x.score_seq ||' references Derived Value '|| x.obj_id ||' which no longer exists'
    from score_det x where x.obj_type_id = 13 and
    not exists (select * from derived_val_hdr where derived_val_id = x.obj_id);

/* if referenced Segment does not exist, insert error into log file */

  select 'Score Detail ' || x.score_id ||','|| x.score_seq ||' references Segment '|| x.obj_type_id ||','|| x.obj_id ||' which no longer exists'
    from score_det x where x.obj_type_id not in (0,13) and
    not exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);



/**************/



/* processing TREE_BASE table */
 
/* If referenced Tree segment exists, create reference record */
 
  insert into referenced_obj select x.origin_type_id, x.origin_id, x.origin_sub_id, null, null, null, null,
    4, x.tree_id, x.base_seq, null, null, 8, c.constraint_type_id from tree_base x, constraint_setting c
    where c.ref_type_id = 4 and c.ref_indicator_id = 8 and (c.obj_type_id = x.origin_type_id or c.obj_type_id is null)
    and x.origin_type_id = 4 and 
    exists (select * from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);

/* If referenced Segment exists, create reference record */

  insert into referenced_obj select x.origin_type_id, x.origin_id, null, null, null, null, null,
    4, x.tree_id, x.base_seq, null, null, 8, c.constraint_type_id from tree_base x, constraint_setting c
    where c.ref_type_id = 4 and c.ref_indicator_id = 8 and (c.obj_type_id = x.origin_type_id or c.obj_type_id is null)
    and x.origin_type_id is not null and x.origin_type_id not in (0,4) and 
    exists (select * from seg_hdr where seg_type_id = x.origin_type_id and seg_id = x.origin_id);

  COMMIT;

/* If referenced Tree segment does not exist, insert error into log file */

  select 'Tree Base ' || x.tree_id ||','|| x.base_seq ||' references Tree Segment '|| x.origin_id ||','|| x.origin_sub_id ||' which no longer exists'
    from tree_base x where x.origin_type_id = 4 and 
    not exists (select * from tree_det where tree_id = x.origin_id and tree_seq = x.origin_sub_id);

/* If referenced Segment does not exist, insert error into log file */

  select 'Tree Base ' || x.tree_id ||','|| x.base_seq ||' references Segment '|| x.origin_type_id ||','|| x.origin_id ||' which no longer exists'
    from tree_base x where x.origin_type_id is not null and x.origin_type_id not in (0,4) and 
    not exists (select * from seg_hdr where seg_type_id = x.origin_type_id and seg_id = x.origin_id);



/**************/



/* processing CAMP_PUB table */
 
/* If referenced Publication exists, create reference record */

  insert into referenced_obj select 58, x.pub_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 14, c.constraint_type_id
    from camp_pub x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 14 
    and (c.obj_type_id = 58 or c.obj_type_id is null) and x.pub_id is not null and x.pub_id <> 0 and
    exists (select * from pub where pub_id = x.pub_id);

/* If referenced Publication Section exists, create reference record */

  insert into referenced_obj select 59, x.pub_id, x.pub_sec_id, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 14, c.constraint_type_id
    from camp_pub x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 14 and
    (c.obj_type_id = 59 or c.obj_type_id is null) and x.pub_sec_id is not null and x.pub_sec_id <> 0 and
    exists (select * from pubsec where pub_id = x.pub_id and pub_sec_id = x.pub_sec_id);

  COMMIT;

/* if referenced Publication does not exist, insert error into log file */

  select 'Campaign Publication Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Publication '|| x.pub_id ||' which no longer exists'
    from camp_pub x where x.pub_id is not null and x.pub_id <> 0 and
    not exists (select * from pub where pub_id = x.pub_id);

/* If referenced Publication Section does not exist, insert error into log file */

  select 'Campaign Publication Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Publication Section '|| x.pub_id ||','|| x.pub_sec_id ||' which no longer exists'
    from camp_pub x where x.pub_sec_id is not null and x.pub_sec_id <> 0 and
    not exists (select * from pubsec where pub_id = x.pub_id and pub_sec_id = x.pub_sec_id);



/**************/



/* processing SPI_PROC table */
  
/* if referenced Segment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id in (1,2) and
    exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);

/* if referenced Tree segment exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 4 and
    exists (select * from tree_hdr where tree_id = x.obj_id);

/* if referenced Data Categorisation exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 5 and
    exists (select * from data_cat_hdr where data_cat_id = x.obj_id);

/* if referenced External Process exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, null, null, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 66 and
    exists (select * from ext_proc_control where ext_proc_id = x.obj_id);

/* if referenced Data Report with Tree Segment source exists, create reference record */
 
  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 7 and x.src_type_id = 4 and
    exists (select * from data_rep_src where data_rep_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Data Report with Segment source exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 7 and 
    x.src_type_id is not null and x.src_type_id <> 4 and
    exists (select * from data_rep_src where data_rep_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);

/* if referenced Score Model with Tree Segment source exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 9 and x.src_type_id = 4 and
    exists (select * from score_src where score_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Score Model with Segment source exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 9 and 
    x.src_type_id is not null and x.src_type_id <> 4 and
    exists (select * from score_src where score_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);

/* if referenced Derived Value with Tree Segment source exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, x.src_sub_id,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 13 and x.src_type_id = 4 and
    exists (select * from derived_val_src where derived_val_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Derived Value with Segment source exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.obj_id, null, null, x.src_type_id, x.src_id, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 13 and 
    x.src_type_id is not null and x.src_type_id <> 4 and
    exists (select * from derived_val_src where derived_val_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);
   
/* if referenced Email Mailbox exists, create reference record */

  insert into referenced_obj select x.obj_type_id, x.src_id, x.obj_id, null, null, null, null,
    17, x.spi_id, x.proc_seq, x.camp_proc_seq, null, 3, c.constraint_type_id from
    spi_proc x, constraint_setting c where c.ref_type_id = 17 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = x.obj_type_id or c.obj_type_id is null) and x.obj_type_id = 62 and
    exists (select * from email_mailbox where server_id = x.src_id and mailbox_id = x.obj_id);    

  COMMIT;

/* if referenced Segment does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Segment '|| x.obj_type_id ||','|| x.obj_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id in (1,2) and
    not exists (select * from seg_hdr where seg_type_id = x.obj_type_id and seg_id = x.obj_id);

/* if referenced Tree segment does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Tree Segment '|| x.obj_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 4 and
    not exists (select * from tree_hdr where tree_id = x.obj_id);

/* if referenced Data Categorisation does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Data Categorisation '|| x.obj_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 5 and
    not exists (select * from data_cat_hdr where data_cat_id = x.obj_id);

/* if referenced External Process does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references External Process '|| x.obj_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 66 and
    not exists (select * from ext_proc_control where ext_proc_id = x.obj_id);

/* if referenced Data Report with Tree Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Data Report Source '|| x.obj_id || ','|| x.src_type_id ||','|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 7 and x.src_type_id = 4 and
    not exists (select * from data_rep_src where data_rep_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Data Report with Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Data Report Source '|| x.obj_id || ','|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 7 and x.src_type_id is not null and x.src_type_id <> 4 and
    not exists (select * from data_rep_src where data_rep_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);

/* if referenced Score Model with Tree Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Score Model Source '|| x.obj_id || x.src_type_id ||','|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 9 and x.src_type_id = 4 and
    not exists (select * from score_src where score_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Score Model with Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Score Model Source '||  x.obj_id || ','|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 9 and x.src_type_id is not null and x.src_type_id <> 4 and
    not exists (select * from score_src where score_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);

/* if referenced Derived Value with Tree Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Derived Value Source '|| x.obj_id || x.src_type_id ||','|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 13 and x.src_type_id = 4 and
    not exists (select * from derived_val_src where derived_val_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = x.src_sub_id);

/* if referenced Derived Value with Segment source does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Derived Value Source '|| x.obj_id ||','|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 13 and x.src_type_id is not null and x.src_type_id <> 4 and
    not exists (select * from derived_val_src where derived_val_id = x.obj_id and src_type_id = x.src_type_id and
    src_id = x.src_id and src_sub_id = 0);
   
/* if referenced Email Mailbox does not exist, insert error into log file */

  select 'SPI Process ' || x.spi_id ||','|| x.proc_seq ||','|| x.camp_proc_seq ||' references Email Mailbox '||x.src_id ||','|| x.obj_id ||' which no longer exists'
    from spi_proc x where x.obj_type_id = 62 and
    not exists (select * from email_mailbox where server_id = x.src_id and mailbox_id = x.obj_id);    



/*************/



/* processing DATA_REP_SRC table */
  
/* if referenced Tree Segment exists, create reference record */

  insert into referenced_obj select x.src_type_id, x.src_id, x.src_sub_id, null, null, null, null, 
    7, x.data_rep_id, null, null, null, 2, c.constraint_type_id
    from data_rep_src x, constraint_setting c where c.ref_type_id = 7 and c.ref_indicator_id = 2 
    and (c.obj_type_id = x.src_type_id or c.obj_type_id is null) and x.src_type_id = 4 and
    exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);

/* if referenced Segment exists, create reference record */

  insert into referenced_obj select x.src_type_id, x.src_id, null, null, null, null, null, 
    7, x.data_rep_id, null, null, null, 2, c.constraint_type_id
    from data_rep_src x, constraint_setting c where c.ref_type_id = 7 and c.ref_indicator_id = 2 
    and (c.obj_type_id = x.src_type_id or c.obj_type_id is null) and x.src_type_id not in (0,4) and
    exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);

  COMMIT;

/* if referenced Tree Segment does not exist, insert error into log file */

  select 'Data Report Source ' || x.data_rep_id ||' references Tree Segment '|| x.src_id ||','|| x.src_sub_id ||' which no longer exists'
    from data_rep_src x where x.src_type_id = 4 and
    not exists (select * from tree_det where tree_id = x.src_id and tree_seq = x.src_sub_id);

/* if referenced Segment does not exist, insert error into log file */

  select 'Data Report Source ' || x.data_rep_id ||' references Segment '|| x.src_type_id ||','|| x.src_id ||' which no longer exists'
    from data_rep_src x where x.src_type_id not in (0,4) and
    not exists (select * from seg_hdr where seg_type_id = x.src_type_id and seg_id = x.src_id);



/*************/



/* processing TREAT_FIXED_COST table */
  
/* if referenced Fixed Cost exists, create reference record */

  insert into referenced_obj select 38, x.fixed_cost_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, x.treat_cost_seq, null, 5, c.constraint_type_id
    from treat_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 38 or c.obj_type_id is null) and x.fixed_cost_id <> 0 and 
    exists (select * from fixed_cost where fixed_cost_id = x.fixed_cost_id);

/* if referenced Fixed Cost Area exists, create reference record */

  insert into referenced_obj select 39, x.fixed_cost_area_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, x.treat_cost_seq, null, 5, c.constraint_type_id
    from treat_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 39 or c.obj_type_id is null) and x.fixed_cost_area_id <> 0 and
    exists (select * from fixed_cost_area where fixed_cost_area_id = x.fixed_cost_area_id);

/* if referenced Supplier exists, create reference record */

  insert into referenced_obj select 40, x.supplier_id, null, null, null, null, null, 
    24, x.camp_id, x.det_id, x.treat_cost_seq, null, 5, c.constraint_type_id
    from treat_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 40 or c.obj_type_id is null) and x.supplier_id <> 0 and
    exists (select * from supplier where supplier_id = x.supplier_id);

  COMMIT;

/* if referenced Fixed Cost does not exist, insert error into log file */

  select 'Campaign Treatment Fixed Cost ' || x.camp_id ||','|| x.det_id ||','|| x.treat_cost_seq ||' references Fixed Cost '|| x.fixed_cost_id ||' which no longer exists'
    from treat_fixed_cost x where x.fixed_cost_id <> 0 and 
    not exists (select * from fixed_cost where fixed_cost_id = x.fixed_cost_id);

/* if referenced Fixed Cost Area does not exist, insert error into log file */

  select 'Campaign Treatment Fixed Cost ' || x.camp_id ||','|| x.det_id ||','|| x.treat_cost_seq ||' references Fixed Cost Area '|| x.fixed_cost_area_id ||' which no longer exists'
    from treat_fixed_cost x where x.fixed_cost_area_id <> 0 and
    not exists (select * from fixed_cost_area where fixed_cost_area_id = x.fixed_cost_area_id);

/* if referenced Supplier does not exist, insert error into log file */

  select 'Campaign Treatment Fixed Cost ' || x.camp_id ||','|| x.det_id ||','|| x.treat_cost_seq ||' references Supplier '|| x.supplier_id ||' which no longer exists'
    from treat_fixed_cost x where x.supplier_id <> 0 and
    not exists (select * from supplier where supplier_id = x.supplier_id);



/*************/



/* processing SEG_DEDUPE_PRIO table */

/* If referenced dynamic Derived value table exists, create reference record */
 
  insert into referenced_obj select 13, d.derived_val_id, null, null, d.src_type_id, d.src_id, d.src_sub_id,
    x.seg_type_id, x.seg_id, x.seq_number, null, null, 23, c.constraint_type_id from seg_dedupe_prio x, vantage_dyn_tab v,
    derived_val_src d, constraint_setting c where x.vantage_alias = v.vantage_alias and v.obj_type_id = 13 and 
    x.vantage_alias = d.dyn_tab_name and c.ref_type_id = x.seg_type_id and c.ref_indicator_id = 23 and 
    (c.obj_type_id = 13 or c.obj_type_id is null) and
    exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias and obj_type_id = 13);

/* If referenced dynamic Score table exists, create reference record */
 
  insert into referenced_obj select 9, d.score_id, null, null, d.src_type_id, d.src_id, d.src_sub_id,
    x.seg_type_id, x.seg_id, x.seq_number, null, null, 23, c.constraint_type_id from stored_fld_templ x, vantage_dyn_tab v,
    score_src d, constraint_setting c where x.vantage_alias = v.vantage_alias and v.obj_type_id = 13 and 
    x.vantage_alias = d.dyn_tab_name and c.ref_type_id = x.seg_type_id and c.ref_indicator_id = 23 and 
    (c.obj_type_id = 9 or c.obj_type_id is null) and
    exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias and obj_type_id = 9);

  COMMIT;

/* If referenced Vantage does not exist, enter error into log file */

  select 'Segment Dedupe Priority Detail ' || x.seg_type_id ||','|| x.seg_id ||','|| x.seq_number ||' references Vantage Alias '|| x.vantage_alias ||' which no longer exists'
    from stored_fld_templ x where not exists (select * from cust_tab where vantage_alias = x.vantage_alias) and
    not exists (select * from vantage_dyn_tab where vantage_alias = x.vantage_alias);



/*************/



/* processing EV_CAMP_DET table */
  
/* if referenced Segment exists, create reference record */

  insert into referenced_obj select x.seg_type_id, x.seg_id, null, null, null, null, null, 
    24, x.camp_id, null, null, null, 6, c.constraint_type_id
    from ev_camp_det x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 6 
    and (c.obj_type_id = x.seg_type_id or c.obj_type_id is null) and x.seg_type_id is not null and x.seg_type_id <> 0 and
    exists (select * from seg_hdr where seg_type_id = x.seg_type_id and seg_id = x.seg_id);

  COMMIT;

/* if referenced Segment does not exist, enter error into log file */

  select 'Campaign Event Detail ' || x.camp_id ||' references Segment '|| x.seg_type_id ||','|| x.seg_id ||' which no longer exists'
    from ev_camp_det x where x.seg_type_id is not null and x.seg_type_id <> 0 and
    not exists (select * from seg_hdr where seg_type_id = x.seg_type_id and seg_id = x.seg_id);



/*************/



/* processing CAMP_FIXED_COST table */
   
/* If referenced Fixed Cost exists, create reference record */

  insert into referenced_obj select 38, x.fixed_cost_id, null, null, null, null, null, 
    24, x.camp_id, x.camp_cost_seq, null, null, 5, c.constraint_type_id
    from camp_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 38 or c.obj_type_id is null) and x.fixed_cost_id <> 0 and
    exists (select * from fixed_cost where fixed_cost_id = x.fixed_cost_id);

/* If referenced Fixed Cost Area exists, create reference record */

  insert into referenced_obj select 39, x.fixed_cost_area_id, null, null, null, null, null, 
    24, x.camp_id, x.camp_cost_seq, null, null, 5, c.constraint_type_id
    from camp_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 38 or c.obj_type_id is null) and x.fixed_cost_area_id <> 0 and
    exists (select * from fixed_cost_area where fixed_cost_area_id = x.fixed_cost_area_id);

/* If referenced Supplier exists, create reference record */

  insert into referenced_obj select 40, x.supplier_id, null, null, null, null, null, 
    24, x.camp_id, x.camp_cost_seq, null, null, 5, c.constraint_type_id
    from camp_fixed_cost x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 5 
    and (c.obj_type_id = 38 or c.obj_type_id is null) and x.supplier_id <> 0 and
    exists (select * from supplier where supplier_id = x.supplier_id);

  COMMIT;

/* If referenced Fixed Cost does not exist, enter error into log file */

  select 'Campaign Fixed Cost ' || x.camp_id ||','|| x.camp_cost_seq ||' references Fixed Cost '|| x.fixed_cost_id ||' which no longer exists'
    from camp_fixed_cost x where x.fixed_cost_id <> 0 and
    not exists (select * from fixed_cost where fixed_cost_id = x.fixed_cost_id);

/* If referenced Fixed Cost Area does not exist, enter error into log file */

  select 'Campaign Fixed Cost ' || x.camp_id ||','|| x.camp_cost_seq ||' references Fixed Cost Area '|| x.fixed_cost_area_id ||' which no longer exists'
    from camp_fixed_cost x where x.fixed_cost_area_id <> 0 and
    not exists (select * from fixed_cost_area where fixed_cost_area_id = x.fixed_cost_area_id);

/* If referenced Supplier does not exist, enter error into log file */

  select 'Campaign Fixed Cost ' || x.camp_id ||','|| x.camp_cost_seq ||' references Supplier '|| x.supplier_id ||' which no longer exists'
    from camp_fixed_cost x where x.supplier_id <> 0 and
    not exists (select * from supplier where supplier_id = x.supplier_id);



/*************/



/* processing CAMP_DRTV table */

/* if referenced TV station exists, create reference record */

  insert into referenced_obj select 47, x.drtv_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 10, c.constraint_type_id
    from camp_drtv x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 10 and
    (c.obj_type_id = 47 or c.obj_type_id is null) and x.drtv_id is not null and x.drtv_id <> 0 and
    exists (select * from tv_station where tv_id = x.drtv_id);

/* if referenced TV Region exists, create reference record */

  insert into referenced_obj select 48, x.drtv_region_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 10, c.constraint_type_id
    from camp_drtv x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 10 and
    (c.obj_type_id = 48 or c.obj_type_id is null) and x.drtv_region_id is not null and x.drtv_region_id <> 0 and
    exists (select * from tv_region where tv_region_id = x.drtv_region_id);

  COMMIT;

/* If referenced TV Station does not exist, enter error into log file */

  select 'Campaign TV Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references TV Station '|| x.drtv_id ||' which no longer exists'
    from camp_drtv x where x.drtv_id is not null and x.drtv_id <> 0 and
    not exists (select * from tv_station where tv_id = x.drtv_id);


/* if referenced TV Region does not exist, enter error into log file */

  select 'Campaign TV Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references TV Region '|| x.drtv_region_id ||' which no longer exists'
    from camp_drtv x where x.drtv_region_id is not null and x.drtv_region_id <> 0 and
    not exists (select * from tv_region where tv_region_id = x.drtv_region_id);



/*************/



/* processing RES_STREAM_DET table */
  
/* If referenced Segment exists, create reference record */

  insert into referenced_obj select x.seg_type_id, x.seg_id, null, null, null, null, null,
    19, x.res_model_id, x.res_stream_id, x.seg_type_id, x.seg_id, 3, c.constraint_type_id
    from res_stream_det x, constraint_setting c where c.ref_type_id = 19 and c.ref_indicator_id = 3 and 
    (c.obj_type_id = 3 or c.obj_type_id is null) and x.seg_type_id <> 0 and x.seg_id <> 0 and
    exists (select * from seg_hdr where seg_type_id = x.seg_type_id and seg_id = x.seg_id);

/* If referenced Response Channel exists, create reference record */

  insert into referenced_obj select 35, x.res_channel_id, null, null, null, null, null,
    19, x.res_model_id, x.res_stream_id, x.seg_type_id, x.seg_id, 3, c.constraint_type_id
    from res_stream_det x, constraint_setting c where c.ref_type_id = 19 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 35 or c.obj_type_id is null) and x.res_channel_id <> 0 and 
    exists (select * from res_channel where res_channel_id = x.res_channel_id);

/* If referenced Response type exists, create reference record */

  insert into referenced_obj select 34, x.res_type_id, null, null, null, null, null,
    19, x.res_model_id, x.res_stream_id, x.seg_type_id, x.seg_id, 3, c.constraint_type_id
    from res_stream_det x, constraint_setting c where c.ref_type_id = 19 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 34 or c.obj_type_id is null) and x.res_type_id <> 0 and
    exists (select * from res_type where res_type_id = x.res_type_id);
  
  COMMIT;

/* if referenced Segment does not exist, enter error into log file */

  select 'Response Stream Detail ' || x.res_model_id ||','|| x.res_stream_id ||','|| x.seg_type_id ||','|| x.seg_id ||' references Segment '|| x.seg_type_id ||','|| x.seg_id ||' which no longer exists'
    from res_stream_det x where x.seg_type_id <> 0 and x.seg_id <> 0 and
    not exists (select * from seg_hdr where seg_type_id = x.seg_type_id and seg_id = x.seg_id);

/* if referenced Response Channel does not exist, enter error into log file */

  select 'Response Stream Detail ' || x.res_model_id ||','|| x.res_stream_id ||','|| x.seg_type_id ||','|| x.seg_id ||' references Response Channel '|| x.res_channel_id ||' which no longer exists'
    from res_stream_det x where x.res_channel_id <> 0 and 
    not exists (select * from res_channel where res_channel_id = x.res_channel_id);

/* if referenced Response Type does not exist, enter error into log file */

  select 'Response Stream Detail ' || x.res_model_id ||','|| x.res_stream_id ||','|| x.seg_type_id ||','|| x.seg_id ||' references Response Type '|| x.res_type_id ||' which no longer exists'
    from res_stream_det x where x.res_type_id <> 0 and
    not exists (select * from res_type where res_type_id = x.res_type_id);
  


/*************/



/* processing CAMP_DDROP table */
  
/* If referenced Door Drop Carrier exists, create reference record */

  insert into referenced_obj select 45, x.ddrop_carrier_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 9, c.constraint_type_id 
    from camp_ddrop x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 9 and
    (c.obj_type_id = 45 or c.obj_type_id is null) and x.ddrop_carrier_id is not null and x.ddrop_carrier_id <> 0 and
    exists (select * from ddrop_carrier where ddrop_carrier_id = x.ddrop_carrier_id);

/* If referenced Door Drop Region exists, create reference record */

  insert into referenced_obj select 46, x.ddrop_region_id, null, null, null, null, null,
    24, x.camp_id, x.det_id, x.placement_seq, null, 9, c.constraint_type_id 
    from camp_ddrop x, constraint_setting c where c.ref_type_id = 24 and c.ref_indicator_id = 9 and 
    (c.obj_type_id = 46 or c.obj_type_id is null) and x.ddrop_region_id is not null and x.ddrop_region_id <> 0 and
    exists (select * from ddrop_region where ddrop_region_id = x.ddrop_region_id);
  
  COMMIT;

/* If referenced Door Drop Carrier does not exist, enter error into log file */

  select 'Campaign Door Drop Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Door Drop Carrier '|| x.ddrop_carrier_id ||' which no longer exists'
    from camp_ddrop x where x.ddrop_carrier_id is not null and x.ddrop_carrier_id <> 0 and
    not exists (select * from ddrop_carrier where ddrop_carrier_id = x.ddrop_carrier_id);

/* If referenced Door Drop Carrier does not exist, enter error into log file */

  select 'Campaign Door Drop Placement ' || x.camp_id ||','|| x.det_id ||','|| x.placement_seq ||' references Door Drop Region '|| x.ddrop_region_id ||' which no longer exists'
    from camp_ddrop x where x.ddrop_region_id is not null and x.ddrop_region_id <> 0 and
    not exists (select * from ddrop_region where ddrop_region_id = x.ddrop_region_id);



/*************/



/* processing DATAVIEW_TEMPL_DET table */
  
/* If linked component referenced Derived Value exists, create reference record */

  insert into referenced_obj select 13, x.comp_id, null, null, null, null, null, 
    6, x.dataview_id, x.seq_number, null, null, 3, c.constraint_type_id
    from dataview_templ_det x, constraint_setting c where c.ref_type_id = 6 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 13 or c.obj_type_id is null) and x.comp_type_id = 4 and
    exists (select * from derived_val_hdr where derived_val_id = x.comp_id);

/* If linked component referenced Score Model exists, create reference record */

  insert into referenced_obj select 9, x.comp_id, null, null, null, null, null, 
    6, x.dataview_id, x.seq_number, null, null, 3, c.constraint_type_id
    from dataview_templ_det x, constraint_setting c where c.ref_type_id = 6 and c.ref_indicator_id = 3 
    and (c.obj_type_id = 9 or c.obj_type_id is null) and x.comp_type_id = 5 and
    exists (select * from score_hdr where score_id = x.comp_id);

/* If conditional value referenced Lookup table exists, create reference record */

  insert into referenced_obj select 8, to_number(substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')-(instr(x.cond_val,' [')+2))),
     null, null, null, null, null, 6, x.dataview_id, x.seq_number, null, null, 20, c.constraint_type_id
     from dataview_templ_det x, constraint_setting c where c.ref_type_id = 6 and c.ref_indicator_id = 3 and
     (c.obj_type_id = 8 or c.obj_type_id is null) and x.cond_val is not null and x.cond_val like '% [%]%' and
     exists (select * from vantage_dyn_tab where 
     vantage_alias = 'LT'|| substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')- (instr(x.cond_val,' [')+2)) );

  COMMIT;

/* If linked component referenced Derived Value does not exist, enter error into log file */

  select 'Data View Detail (component) ' || x.dataview_id ||','|| x.seq_number ||' references Derived Value '|| x.comp_id ||' which no longer exists'
    from dataview_templ_det x where x.comp_type_id = 4 and
    not exists (select * from derived_val_hdr where derived_val_id = x.comp_id);

/* If linked component referenced Score Model does not exist, enter error into log file */

  select 'Data View Detail (component) ' || x.dataview_id ||','|| x.seq_number ||' references Score Model '|| x.comp_id ||' which no longer exists'
    from dataview_templ_det x where x.comp_type_id = 5 and
    not exists (select * from score_hdr where score_id = x.comp_id);

/* If conditional value referenced Lookup table does not exist, enter error into log file */

  select 'Data View Detail (conditional value) ' || x.dataview_id ||','|| x.seq_number ||' references Lookup Table '|| to_number(substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')-(instr(x.cond_val,' [')+2))) ||' which no longer exists'
    from dataview_templ_det x where x.cond_val is not null and x.cond_val like '% [%]%' and
    not exists (select * from vantage_dyn_tab where 
    vantage_alias = 'LT'|| substr(x.cond_val, instr(x.cond_val,' [')+2, instr(x.cond_val,']')- (instr(x.cond_val,' [')+2)) );



/*************/



/* processing CAMP_REP_HDR table */
  
/* if referenced Campaign Report Group exists, create reference record */

  insert into referenced_obj select 74, x.camp_rep_grp_id, null, null, null, null, null,
    70, x.camp_rep_id, null, null, null, 1, c.constraint_type_id 
    from camp_rep_hdr x, constraint_setting c where c.ref_type_id = 70 and c.ref_indicator_id = 1 and 
    (c.obj_type_id = 74 or c.obj_type_id is null) and x.camp_rep_grp_id is not null and x.camp_rep_grp_id <> 0 and
    exists (select * from camp_rep_grp where camp_rep_grp_id = x.camp_rep_grp_id);

  COMMIT;

/* If referenced Campaign Report Group does not exist, enter error into log file */

  select 'Campaign Report ' || x.camp_rep_id ||' references Campaign Report Group '|| x.camp_rep_grp_id ||' which no longer exists'
    from camp_rep_hdr x where x.camp_rep_grp_id is not null and x.camp_rep_grp_id <> 0 and
    not exists (select * from camp_rep_grp where camp_rep_grp_id = x.camp_rep_grp_id);



/*************/



select 'Referential Integrity Upgrade Client generation has been completed.' from dual;
select ' ' from dual;
select ' ' from dual;

spool off;

accept location prompt 'Enter Location of Vantage Executables >'
accept database_account prompt 'Enter Database Account >'
accept database_password prompt 'Enter Database Password >'
accept connectString prompt 'Enter Database Connect String >'

host  &location/v_riupgrade_proc D &database_account &database_password MASTERUSER 1 &connectString 1 

exit;
