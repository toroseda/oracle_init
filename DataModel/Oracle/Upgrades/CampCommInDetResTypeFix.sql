prompt 
prompt 'This script corrects Response Type entries of Inbound Communications'
prompt '- involving update of RES_TYPE_ID values in CAMP_COMM_IN_DET table.'
prompt

spool CampCommInDetResTypeFix.log

update camp_comm_in_det x set res_type_id = (select min(r.res_type_id) from res_stream_det r,
	camp_det d where r.res_model_id = d.obj_id and r.res_stream_id = d.obj_sub_id and
	d.camp_id = x.camp_id and d.det_id = x.det_id);
COMMIT;

spool off;

exit;



