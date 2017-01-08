-- This Script will resolve the issue of Campaign being mapped to Delivery Channel with conflicting view_id's 
-- should be run when all P&V Application sessions have been closed

spool CampDelChanViewFix.log

/* create temporary table to hold maximum chan_id issued so far in delivery_chan table */

create table temp_max_chan (max_chan_id number(8));

insert into temp_max_chan select max(chan_id) from delivery_chan;


/* create temporary table to hold mapping between the old and new channel - view pairs */
/* for those channels that have to be replicated with new VIEW_ID */

create table temp_chan_map (old_chan_id number(8), new_view_id varchar2(30), 
	new_chan_id number(8));

insert into temp_chan_map select unique d.chan_id, c.view_id, null
from campaign c, camp_out_det o, delivery_chan d where
c.camp_id = o.camp_id and o.chan_id = d.chan_id and c.view_id <> d.view_id;

update temp_chan_map set new_chan_id = rownum;

update temp_chan_map x set new_chan_id = (select x.new_chan_id + max_chan_id
from temp_max_chan);

commit;


/* replicate delivery channel definitions for channels linked to campaigns with 
/* confilicting view_id's by copying the old delivery_chan records assigning 
/* them new identifiers as established in temp_chan_map table */

insert into delivery_chan select unique m.new_chan_id, c.chan_type_id, 
c.delivery_method_id, c.chan_out_type_id, c.dft_ext_templ_id, 
c.chan_name, c.chan_desc, c.label_id, c.record_delimiter, c.fld_delimiter, 
c.enclose_delimiter, c.append_flg, c.delivery_func_id, c.server_id, 
c.inc_keycode_flg, c.custom_length_flg, c.vantage_alias, c.col_name, 
c.forward_file_to, c.send_email_flg, c.bounce_mailbox_id, 
c.bounce_server_id, c.created_by, sysdate, c.updated_by, null, m.new_view_id
from temp_chan_map m, delivery_chan c where c.chan_id = m.old_chan_id; 

COMMIT;



/* if the default extract template is defined, it will now belong to a different */
/* view_id then the 'new' delivery channel it is associated with.  Those extract */
/* templates will also be replicated */


/* create temporary table to hold maximum ext_templ_id issued so far */

create table temp_max_templ (max_templ_id number(8));

insert into temp_max_templ select max(ext_templ_id) from ext_templ_hdr;


/* create temporary work table to hold mapping between the old and new extract template */
/* identifiers for those extract templates that have to be replicated with new VIEW_ID */

create table temp_templ_map (old_templ_id number(8), new_view_id varchar2(30), 
new_templ_id number(8));

insert into temp_templ_map select unique x.dft_ext_templ_id, x.view_id, null 
from temp_chan_map m, delivery_chan x, ext_templ_hdr e where m.new_chan_id = x.chan_id 
and x.dft_ext_templ_id = e.ext_templ_id and e.view_id <> x.view_id;

update temp_templ_map set new_templ_id = rownum;

update temp_templ_map x set new_templ_id = (select x.new_templ_id + max_templ_id 
from temp_max_templ);

COMMIT;


/* replicate extract template definitions with conflicting view_id's */
/* by copying the old extract template detail records assigning them new identifiers */
/* as established in temp_templ_map */

insert into ext_templ_hdr select unique m.new_templ_id, e.ext_templ_name,
e.outrec_size, m.new_view_id, e.created_by, e.created_date, e.updated_by, e.updated_date
from temp_templ_map m, ext_templ_hdr e where m.old_templ_id = e.ext_templ_id;

insert into ext_templ_det select unique m.new_templ_id, d.line_seq, d.comp_type_id,
d.comp_id, d.src_type_id, d.src_id, d.src_sub_id, d.string_val, d.vantage_alias, 
d.col_name, d.mixed_case_flg, d.shuffle_flg, d.sample_val, d.sort_order, d.sort_descend_flg,
d.out_length, d.justification, d.pad_char, d.dyn_col_name, d.col_format
from temp_templ_map m, ext_templ_det d where m.old_templ_id = d.ext_templ_id and
not exists (select * from ext_templ_det where ext_templ_id = m.new_templ_id
and line_seq = d.line_seq);

insert into ext_hdr_and_ftr select m.new_templ_id, e.record_type, e.seq_number,
e.comp_type_id, e.string_val, e.out_length from ext_hdr_and_ftr e, temp_templ_map m
where m.old_templ_id = e.ext_templ_id and not exists (select * from ext_hdr_and_ftr
where ext_templ_id = m.new_templ_id and record_type = e.record_type 
and seq_number = e.seq_number);

/* update previous 'old' default extract template in the re-mapped delivery channel */
/* records with equivalent 'new' default extract template belonging to the same CDV */
/* as the delivery_channel */

update delivery_chan x set dft_ext_templ_id = (select new_templ_id from temp_templ_map
where old_templ_id = x.dft_ext_templ_id and new_view_id = x.view_id) where exists 
(select * from temp_templ_map where old_templ_id = x.dft_ext_templ_id and new_view_id =
x.view_id) and exists (select * from temp_chan_map where new_chan_id = x.chan_id and
new_view_id = x.view_id);

COMMIT;

/* update previous 'old channel' campaign links with the equivalent 'new channel' */
/* identifiers with view_id's same as the linked campaign */

update camp_out_det x set chan_id = (select new_chan_id from temp_chan_map m, campaign c
where x.camp_id = c.camp_id and x.chan_id = m.old_chan_id and c.view_id = m.new_view_id) 
where exists (select * from temp_chan_map m, campaign c where x.chan_id = m.old_chan_id
and x.camp_id = c.camp_id and c.view_id = m.new_view_id);

COMMIT;

set heading off
set lin 90

spool CampDelChanViewFix.rep

prompt
prompt Report on re-mapping of Delivery Channels and associated Extract Templates
prompt mapped to Campaigns with conflicting Customer Data Views.
prompt ==========================================================================
prompt
prompt Re-mapped Delivery Channels linked to Campaigns:
prompt ------------------------------------------------
                                                            
prompt

select 'Delivery Channel ' || m.old_chan_id || ' under CDV: '|| d.view_id ||
' has been re-mapped to the replicated '||'Delivery Channel ' || m.new_chan_id || 
' under CDV: '|| m.new_view_id || ' for Campaign ' || c.camp_id 
from temp_chan_map m, delivery_chan d, camp_out_det o, campaign c 
where m.old_chan_id = d.chan_id 
and m.new_chan_id = o.chan_id and o.camp_id = c.camp_id 
and c.view_id = m.new_view_id;

prompt
prompt Re-mapped Extract Templates linked to re-mapped Delivery Channels:
prompt ------------------------------------------------------------------
                                                               
prompt

select 'Extract Template ' || m.old_templ_id || ' under CDV: ' || e.view_id || 
' has been re-mapped to the replicated '||'Extract Template ' || m.new_templ_id || 
' under CDV: ' || m.new_view_id || ' for new Delivery Channel ' || d.chan_id 
from temp_templ_map m, ext_templ_hdr e, delivery_chan d 
where m.old_templ_id = e.ext_templ_id and m.new_templ_id = d.dft_ext_templ_id;

spool off;
set heading on
set feedback on

drop table temp_max_chan;
drop table temp_chan_map;
drop table temp_max_templ;
drop table temp_templ_map;


prompt 'Campaign Communications have been mapped to Customer Tables.'
prompt
spool off;
exit;
