prompt
prompt 'This script upgrades Prime@Vantage System Database from V3.0 to V3.1.'
prompt
accept ts_pv_sys prompt 'Enter name of tablespace for Prime@Vantage System Tables > '
prompt
accept ts_pv_ind prompt 'Enter name of tablespace for Prime@Vantage System Indexes > '
prompt
prompt

// $ProjectRevision: 1.189 $

// $Log: V30toV31Upgrade.sql,v $
// Revision 1.3  2000/10/20 18:02:56  twilliamson
// Correction - removed 'exit' command at the end of the script, which
// caused exit from the whole process.  As the script was called from
// the DBUpgradeGA310.sql script the following call to
// V30toV31RIUpgrade.sql was not activated.
//
// Revision 1.2  2000/06/14 10:46:52Z  twilliamson
// Re-check in after discovery of corruption in MKS


SPOOL V30toV31Upgrade.log

      
      /*
      ACTION is CREATE Table GRP_FUNCTION
      */

CREATE TABLE GRP_FUNCTION (
       GRP_FUNCTION_ID      NUMBER(1) NOT NULL,
       GRP_FUNCTION_NAME    VARCHAR2(50) NOT NULL
)
       TABLESPACE &ts_pv_sys
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

      
      /*
      ACTION is CREATE Table REP_COL_GRP
      */

CREATE TABLE REP_COL_GRP (
       REP_COL_GRP_ID       NUMBER(2) NOT NULL,
       REP_COL_GRP_NAME     VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
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

      
      /*
      ACTION is CREATE Table CAMP_REP_COL
      */

CREATE TABLE CAMP_REP_COL (
       CAMP_REP_COL_ID      NUMBER(4) NOT NULL,
       COL_NAME             VARCHAR2(100) NOT NULL,
       REP_COL_GRP_ID       NUMBER(2) NOT NULL,
       DFT_COL_WIDTH        NUMBER(4) NOT NULL,
       COL_FORMAT_ID        NUMBER(1) NOT NULL,
       COL_SQL              VARCHAR2(100) NOT NULL,
       DFT_FUNCTION_ID      NUMBER(1) NOT NULL,
       GRP_BY_ONLY_FLG      NUMBER(1) NOT NULL
)
       TABLESPACE &ts_pv_sys
;


ALTER TABLE CAMP_REP_COL
       ADD  ( PRIMARY KEY (CAMP_REP_COL_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

insert into camp_rep_col values ( 1, 'Strategy Code', 1, 1000, 2, 'STRATEGY_ID', 1, 1);
insert into camp_rep_col values ( 2, 'Strategy Name', 1, 3000, 1, 'STRATEGY_NAME', 1, 1);
insert into camp_rep_col values ( 3, 'Campaign Group Code', 1, 1000, 2, 'CAMP_GRP_ID', 1, 1);
insert into camp_rep_col values ( 4, 'Campaign Group Name', 1, 3000, 1, 'CAMP_GRP_NAME', 1, 1);
insert into camp_rep_col values ( 5, 'Campaign ID', 1, 1000, 2, 'CAMP_ID', 1, 1);
insert into camp_rep_col values ( 6, 'Campaign Code', 1, 1000, 1, 'CAMP_CODE', 1, 1);
insert into camp_rep_col values ( 7, 'Campaign Name', 1, 3000, 1, 'CAMP_NAME', 1, 1);
insert into camp_rep_col values ( 8, 'Campaign Status', 1, 2000, 1, 'CAMP_STATUS', 1, 1);
insert into camp_rep_col values ( 9, 'Campaign Template', 1, 2000, 1, 'CAMP_TEMPLATE', 1, 1);
insert into camp_rep_col values ( 13, 'Campaign Type', 1, 3000, 1, 'CAMP_TYPE', 1, 1);
insert into camp_rep_col values ( 10, 'Campaign Manager', 1, 3000, 1, 'CAMP_MANAGER', 1, 1);
insert into camp_rep_col values ( 12, 'Budget Manager', 1, 3000, 1, 'BUDGET_MANAGER', 1, 1);
insert into camp_rep_col values ( 11, 'Campaign Fixed Cost', 1, 3000, 4, 'CAMP_FIXED_COST', 1, 1);
insert into camp_rep_col values ( 14, 'Start Date', 1, 2000, 3, 'CAMP_START_DATE', 1, 1);
insert into camp_rep_col values ( 15, 'Campaign Number of Cycles (to date)', 1, 1000, 2, 'CAMP_NO_OF_CYCLES', 1, 1);
insert into camp_rep_col values ( 16, 'Treatment Code', 2, 1000, 2, 'TREATMENT_ID', 1, 1);
insert into camp_rep_col values ( 17, 'Treatment Name', 2, 3000, 1, 'TREATMENT_NAME', 1, 1);
insert into camp_rep_col values ( 18, 'Treatment Unit Variable Cost', 2, 1000, 4, 'UNIT_VAR_COST', 2, 0);
insert into camp_rep_col values ( 19, 'Treatment Fixed Cost', 2, 1000, 4, 'TREAT_FIXED_COST', 2, 0);
insert into camp_rep_col values ( 20, 'Treatment Channel Type', 2, 2000, 1, 'TREAT_CHAN', 1, 1);
insert into camp_rep_col values ( 24, 'Segment Type', 3, 2000, 1, 'SEG_TYPE_ID', 1, 1);
insert into camp_rep_col values ( 21, 'Segment Code', 3, 1000, 2, 'SEG_ID', 1, 1);
insert into camp_rep_col values ( 22, 'Sub Segment Code', 3, 1000, 2, 'SEG_SUB_ID', 1, 1);
insert into camp_rep_col values ( 23, 'Segment Name', 3, 3000, 1, 'SEG_NAME', 1, 1);
insert into camp_rep_col values ( 25, 'Segment Keycode', 3, 2000, 1, 'SEG_KEYCODE', 1, 1);
insert into camp_rep_col values ( 26, 'Control/Non Control Segment', 3, 1000, 1, 'SEG_CONTROL_FLG', 1, 1);
insert into camp_rep_col values ( 27, 'Projected Outbound Quantity Per Cycle', 4, 1000, 2, 'PROJ_OUT_CYC_QTY', 2, 0);
insert into camp_rep_col values ( 28, 'Projected Outbound Quantity (to date)', 4, 1000, 2, 'PROJ_OUT_QTY', 2, 0);
insert into camp_rep_col values ( 29, 'Projected Inbound Quantity Per Cycle', 4, 1000, 2, 'PROJ_INB_CYC_QTY', 2, 0);
insert into camp_rep_col values ( 30, 'Projected Inbound Quantity (to date)', 4, 1000, 2, 'PROJ_INB_QTY', 2, 0);
insert into camp_rep_col values ( 31, 'Projected Response Rate', 4, 1000, 5, 'PROJ_RES_RATE', 2, 0);
insert into camp_rep_col values ( 32, 'Projected Outbound Variable Cost per Cycle', 4, 1000, 4, 'PROJ_OUT_CYC_VCOST', 2, 0);
insert into camp_rep_col values ( 33, 'Projected Outbound Variable Cost (to date)', 4, 1000, 4, 'PROJ_OUT_VCOST', 2, 0);
insert into camp_rep_col values ( 34, 'Projected Inbound Variable Cost per Cycle', 4, 1000, 4, 'PROJ_INB_CYC_VCOST', 2, 0);
insert into camp_rep_col values ( 35, 'Projected Inbound Variable Cost (to date)', 4, 1000, 4, 'PROJ_INB_VCOST', 2, 0);
insert into camp_rep_col values ( 36, 'Projected Revenue Per Cycle', 4, 1000, 4, 'PROJ_INB_CYC_REV', 2, 0);
insert into camp_rep_col values ( 37, 'Projected Revenue (to date)', 4, 1000, 4, 'PROJ_INB_REV', 2, 0);
insert into camp_rep_col values ( 38, 'Actual Outbound Quantity', 5, 1000, 2, 'SEG_ACT_OUT_QTY', 2, 0);
insert into camp_rep_col values ( 39, 'Actual Inbound Quantity', 5, 1000, 2, 'SEG_ACT_INB_QTY', 2, 0);
insert into camp_rep_col values ( 40, 'Actual Outbound Variable Cost', 5, 1000, 4, 'SEG_ACT_OUT_VCOST', 2, 0);
insert into camp_rep_col values ( 41, 'Actual Inbound Variable Cost', 5, 1000, 4, 'SEG_ACT_INB_VCOST', 2, 0);
insert into camp_rep_col values ( 42, 'Actual Revenue', 5, 1000, 4, 'SEG_ACT_REV', 2, 0);
insert into camp_rep_col values ( 43, 'Outbound Quantity Variance', 6, 1000, 2, '(PROJ_OUT_QTY - SEG_ACT_OUT_QTY) AS OUT_QTY_VAR ', 2, 0);
insert into camp_rep_col values ( 44, 'Inbound Quantity Variance', 6, 1000, 2, '(PROJ_INB_QTY - SEG_ACT_INB_QTY) AS INB_QTY_VAR', 2, 0);
insert into camp_rep_col values ( 45, 'Outbound Variable Cost Variance', 6, 1000, 4, '(PROJ_OUT_VCOST - SEG_ACT_OUT_VCOST) AS OUT_VCOST_VAR', 2, 0);
insert into camp_rep_col values ( 46, 'Inbound Variable Cost Variance', 6, 1000, 4, '(PROJ_INB_VCOST - SEG_ACT_INB_VCOST) AS INB_VCOST_VAR', 2, 0);
insert into camp_rep_col values ( 47, 'Revenue Variance', 6, 1000, 4, '(PROJ_INB_REV - SEG_ACT_REV) AS REV_VAR', 2, 0);
insert into camp_rep_col values ( 48, 'Actual Response Rate', 7, 1000, 2, '(SEG_ACT_INB_QTY/SEG_ACT_OUT_QTY) AS ACT_RES_RATE', 2, 0);
insert into camp_rep_col values ( 49, 'Projected Response Rate', 7, 1000, 2, '(PROJ_INB_QTY/PROJ_OUT_QTY) AS PROJ_RES_RATE', 2, 0);
insert into camp_rep_col values ( 50, 'Actual Cost Per Contact', 7, 1000, 4, '((SEG_ACT_OUT_VCOST + SEG_ACT_INB_VCOST) / SEG_ACT_OUT_QTY) AS ACT_CON_COST', 2, 0);
insert into camp_rep_col values ( 51, 'Projected Cost Per Contact', 7, 1000, 4, '((PROJ_OUT_VCOST + PROJ_INB_VCOST) / PROJ_OUT_QTY) AS PROJ_CON_COST', 2, 0);
insert into camp_rep_col values ( 52, 'Actual Revenue Per Contact', 7, 1000, 4, '(SEG_ACT_REV / SEG_ACT_OUT_QTY) AS ACT_CON_REV', 2, 0);
insert into camp_rep_col values ( 53, 'Projected Revenue Per Contact', 7, 1000, 4, '(PROJ_INB_REV / PROJ_OUT_QTY) AS PROJ_CON_REV', 2, 0);
insert into camp_rep_col values ( 54, 'Actual Cost Per Response', 7, 1000, 4, '((SEG_ACT_OUT_VCOST + SEG_ACT_INB_VCOST) / SEG_ACT_INB_QTY) AS ACT_REV_COST', 2, 0);
insert into camp_rep_col values ( 55, 'Projected Cost Per Response', 7, 1000, 4, '((PROJ_OUT_VCOST + PROJ_INB_VCOST) / PROJ_INB_QTY) AS PROJ_REV_COST', 2, 0);
insert into camp_rep_col values ( 56, 'Actual Revenue Per Response', 7, 1000, 4, '(SEG_ACT_REV / SEG_ACT_INB_QTY) AS ACT_RES_REV', 2, 0);
insert into camp_rep_col values ( 57, 'Projected Revenue Per Response', 7, 1000, 4, '(PROJ_INB_REV / PROJ_INB_QTY) AS PROJ_RES_REV', 2, 0);
COMMIT;


      
      /*
      ACTION is CREATE Table CAMP_REP_GRP
      */

CREATE TABLE CAMP_REP_GRP (
       CAMP_REP_GRP_ID      NUMBER(4) NOT NULL,
       CAMP_REP_GRP_NAME    VARCHAR2(100) NOT NULL
)
       TABLESPACE &ts_pv_sys
;


ALTER TABLE CAMP_REP_GRP
       ADD  ( PRIMARY KEY (CAMP_REP_GRP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table CAMP_REP_HDR
      */

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


ALTER TABLE CAMP_REP_HDR
       ADD  ( PRIMARY KEY (CAMP_REP_ID)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table CAMP_REP_COND
      */

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


ALTER TABLE CAMP_REP_COND
       ADD  ( PRIMARY KEY (CAMP_REP_ID, CAMP_REP_COND_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

      
      /*
      ACTION is CREATE Table CAMP_REP_DET
      */

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


ALTER TABLE CAMP_REP_DET
       ADD  ( PRIMARY KEY (CAMP_REP_ID, CAMP_REP_DET_SEQ)
       USING INDEX
              TABLESPACE &ts_pv_ind ) ;

      
CREATE OR REPLACE VIEW CAMP_COMM_INB_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_INB_QTY, SEG_ACT_INB_VCOST, SEG_ACT_REV, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_IN_HDR.CAMP_ID, CAMP_COMM_IN_HDR.PAR_COMM_DET_ID, sum(comm_qty), sum(total_cost), sum(total_revenue), max(camp_cyc)
       FROM CAMP_COMM_IN_HDR
       GROUP BY camp_id, par_comm_det_id;

CREATE OR REPLACE VIEW CAMP_COMM_OUT_SUM (CAMP_ID, SEG_DET_ID, SEG_ACT_OUTB_QTY, SEG_ACT_OUTB_VCOST, CAMP_NO_OF_CYCLES)  AS
       SELECT CAMP_COMM_OUT_HDR.CAMP_ID, CAMP_COMM_OUT_HDR.DET_ID, sum(comm_qty), sum(total_cost), max(camp_cyc)
       FROM CAMP_COMM_OUT_HDR
       GROUP BY camp_id, det_id;

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

CREATE OR REPLACE VIEW camp_seg_det (camp_id, det_id, obj_type_id, obj_id, obj_sub_id, par_det_id, name)
AS
select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name
from camp_det c, seg_hdr s 
where c.obj_type_id = 1 and c.obj_type_id = s.seg_type_id and c.obj_id = s.seg_id
UNION
select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id, s.seg_name 
from camp_det c, seg_hdr s 
where c.obj_type_id = 21 and s.seg_type_id = 1 and c.obj_id = s.seg_id and c.obj_sub_id = 0
UNION
select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id,
t.tree_name || ' [' || d.tree_seq || '] ' || d.node_name
from camp_det c, tree_hdr t, tree_det d 
where c.obj_type_id = 4 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and c.obj_sub_id = d.tree_seq
UNION
select c.camp_id, c.det_id, c.obj_type_id, c.obj_id, c.obj_sub_id, c.par_det_id,
t.tree_name || ' [' || d.tree_seq || '] ' || d.node_name
from camp_det c, tree_hdr t, tree_det d
where c.obj_type_id = 21 and c.obj_id = t.tree_id and c.obj_id = d.tree_id and c.obj_sub_id = d.tree_seq
;

CREATE OR REPLACE VIEW OUTB_PROJECTION (STRATEGY_ID, STRATEGY_NAME, CAMP_GRP_ID, CAMP_GRP_NAME, CAMP_ID, CAMP_CODE, CAMP_NAME, CAMP_STATUS, CAMP_TEMPLATE, CAMP_TYPE, CAMP_MANAGER, BUDGET_MANAGER, CAMP_FIXED_COST, CAMP_START_DATE, TREATMENT_ID, TREATMENT_NAME, TREAT_DET_ID, UNIT_VAR_COST, TREAT_FIXED_COST, TREAT_CHAN, SEG_TYPE_ID, SEG_ID, SEG_SUB_ID, SEG_DET_ID, SEG_NAME, SEG_KEYCODE, SEG_CONTROL_FLG, SEG_PROJ_QTY, SEG_PROJ_RES_RATE, SEG_PROJ_RES, SEG_PROJ_VAR_COST)  AS
       SELECT max(strat.strategy_id), max(strat.strategy_name), max(camp.camp_grp_id), max(cgrp.camp_grp_name), max(ctdet.camp_id), max(camp.camp_code), max(camp.camp_name), max(dhcs.status_setting_id), max(camp.camp_templ_id), max(ctype.camp_type_name), max(cmgr.manager_name), max(cbmgr.manager_name), max(dhcfc.cost_per_seg), max(camp.start_date), max(ctdet.obj_id), max(treat.treatment_name), max(ctdet.det_id), sum(elem.var_cost/elem.var_cost_qty), max(dhtfc.cost_per_seg), max(chntype.chan_type_id), max(csdet.obj_type_id), max(csdet.obj_id), max(csdet.obj_sub_id), max(csdet.det_id), max(csdet.name), max(cseg.keycode), max(cseg.control_flg), max(cseg.proj_qty), max(cseg.proj_res_rate)/100, max(cseg.proj_res_rate)/100 * max(cseg.proj_qty), sum(elem.var_cost/elem.var_cost_qty) * max(cseg.proj_qty)
       FROM CAMP_GRP cgrp, STRATEGY strat, CAMPAIGN camp, CAMP_TYPE ctype, CAMP_MANAGER cmgr, CAMP_MANAGER cbmgr, CAMP_DET ctdet, CAMP_SEG_DET csdet, TREATMENT treat, TELEM telem, ELEM elem, TREATMENT_GRP tgrp, CHAN_TYPE chntype, SEG_HDR seghd, CAMP_SEG cseg, CAMP_SEG_COST dhcfc, TREAT_SEG_COST dhtfc, CAMP_STATUS dhcs
       WHERE strat.strategy_id = cgrp.strategy_id
and camp.camp_grp_id = cgrp.camp_grp_id
and camp.camp_id = dhcfc.camp_id (+)
and camp.camp_type_id = ctype.camp_type_id (+)
and camp.manager_id = cmgr.manager_id (+)
and camp.budget_manager_id = cbmgr.manager_id (+)
and camp.camp_id = csdet.camp_id
and camp.camp_id = dhcs.camp_id
and csdet.par_det_id = ctdet.det_id
and csdet.camp_id = ctdet.camp_id
and ctdet.det_id = dhtfc.treat_det_id (+)
and ctdet.camp_id = dhtfc.camp_id (+)
and treat.treatment_id = ctdet.obj_id
and treat.treatment_id = telem.treatment_id (+)
and telem.elem_id = elem.elem_id (+)
and treat.treatment_grp_id = tgrp.treatment_grp_id
and tgrp.chan_type_id = chntype.chan_type_id
and csdet.obj_type_id = seghd.seg_type_id (+)
and csdet.obj_id = seghd.seg_id (+)
and csdet.camp_id = cseg.camp_id (+)
and csdet.det_id = cseg.det_id (+)
and csdet.obj_type_id in (1,4,21)
       GROUP BY csdet.camp_id, csdet.det_id;

CREATE OR REPLACE VIEW CAMP_ANALYSIS 
				(STRATEGY_ID, 
				STRATEGY_NAME, 
				CAMP_GRP_ID, 
				CAMP_GRP_NAME, 
				CAMP_ID, 
				CAMP_CODE, 
				CAMP_NAME, 
				CAMP_STATUS, 
				CAMP_TEMPLATE, 
				CAMP_TYPE, 
				CAMP_MANAGER, 
				BUDGET_MANAGER, 
				CAMP_FIXED_COST, 
				CAMP_START_DATE, 
				CAMP_NO_OF_CYCLES, 
				TREATMENT_ID, 
				TREATMENT_NAME, 
				UNIT_VAR_COST, 
				TREAT_FIXED_COST, 
				TREAT_CHAN, 
				SEG_TYPE_ID, 
				SEG_ID, 
				SEG_SUB_ID, 
				SEG_NAME, 
				SEG_KEYCODE, 
				SEG_CONTROL_FLG, 
				PROJ_OUT_CYC_QTY, 
				PROJ_OUT_QTY, 
				PROJ_INB_CYC_QTY, 
				PROJ_INB_QTY, 
				PROJ_RES_RATE, 
				PROJ_OUT_CYC_VCOST, 
				PROJ_OUT_VCOST, 
				PROJ_INB_CYC_VCOST, 
				PROJ_INB_VCOST, 
				PROJ_INB_CYC_REV, 
				PROJ_INB_REV, 
				SEG_ACT_OUT_QTY, 
				SEG_ACT_OUT_VCOST, 
				SEG_ACT_INB_QTY, 
				SEG_ACT_INB_VCOST, 
				SEG_ACT_REV)  
			AS 
			 SELECT outbp.STRATEGY_ID, 
				outbp.STRATEGY_NAME, 
				outbp.CAMP_GRP_ID, 
				outbp.CAMP_GRP_NAME, 
				outbp.CAMP_ID, 
				outbp.CAMP_CODE, 
				outbp.CAMP_NAME, 
				outbp.CAMP_STATUS, 
				outbp.CAMP_TEMPLATE, 
				outbp.CAMP_TYPE, 
				outbp.CAMP_MANAGER, 
				outbp.BUDGET_MANAGER, 
				to_number(decode(outbp.CAMP_FIXED_COST,0,NULL,outbp.CAMP_FIXED_COST)), 
				outbp.CAMP_START_DATE, 
				outbc.CAMP_NO_OF_CYCLES, 
				outbp.TREATMENT_ID, 
				outbp.TREATMENT_NAME, 
				to_number(decode(outbp.UNIT_VAR_COST,0,NULL,outbp.UNIT_VAR_COST)), 
				to_number(decode(outbp.TREAT_FIXED_COST,0,NULL,outbp.TREAT_FIXED_COST)), 
				outbp.TREAT_CHAN, 
				outbp.SEG_TYPE_ID, 
				outbp.SEG_ID, 
				outbp.SEG_SUB_ID, 
				outbp.SEG_NAME, 
				outbp.SEG_KEYCODE, 
				outbp.SEG_CONTROL_FLG, 
				to_number(decode(outbp.SEG_PROJ_QTY,0,NULL,outbp.SEG_PROJ_QTY)), 
				to_number(decode(outbp.seg_proj_qty * outbc.camp_no_of_cycles,0,NULL,outbp.seg_proj_qty * outbc.camp_no_of_cycles)), 
				to_number(decode(outbp.SEG_PROJ_RES,0,NULL,outbp.SEG_PROJ_RES)), 
				to_number(decode(outbp.seg_proj_res * outbc.camp_no_of_cycles,0,NULL,outbp.seg_proj_res * outbc.camp_no_of_cycles)), 
				to_number(decode(outbp.SEG_PROJ_RES_RATE,0,NULL,outbp.SEG_PROJ_RES_RATE)), 
				to_number(decode(outbp.SEG_PROJ_VAR_COST,0,NULL,outbp.SEG_PROJ_VAR_COST)), 
				to_number(decode(outbp.seg_proj_var_cost * outbc.camp_no_of_cycles,0,NULL,outbp.seg_proj_var_cost * outbc.camp_no_of_cycles)), 
				to_number(decode(inbp.avg_cost_per_res * outbp.seg_proj_res,0,NULL,inbp.avg_cost_per_res * outbp.seg_proj_res)), 
				to_number(decode((inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,NULL,(inbp.avg_cost_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
				to_number(decode(inbp.avg_rev_per_res * outbp.seg_proj_res,0,NULL,inbp.avg_rev_per_res * outbp.seg_proj_res)), 
				to_number(decode((inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles,0,null,(inbp.avg_rev_per_res * outbp.seg_proj_res) * outbc.camp_no_of_cycles)), 
				to_number(decode(outbc.SEG_ACT_OUTB_QTY,0,NULL,outbc.SEG_ACT_OUTB_QTY)), 
				to_number(decode(outbc.SEG_ACT_OUTB_VCOST,0,NULL,outbc.SEG_ACT_OUTB_VCOST)), 
				to_number(decode(inbc.SEG_ACT_INB_QTY,0,NULL,inbc.SEG_ACT_INB_QTY)), 
				to_number(decode(inbc.SEG_ACT_INB_VCOST,0,NULL,inbc.SEG_ACT_INB_VCOST)),
				to_number(decode(inbc.SEG_ACT_REV,0,NULL,inbc.SEG_ACT_REV))
			FROM OUTB_PROJECTION outbp, INB_PROJECTION inbp, CAMP_COMM_OUT_SUM outbc, CAMP_COMM_INB_SUM inbc
				WHERE outbp.camp_id = inbp.camp_id (+)
				and outbp.seg_det_id = inbp.seg_det_id (+)
				and outbp.camp_id = outbc.camp_id (+)
				and outbp.seg_det_id = outbc.seg_det_id (+)
				and outbp.camp_id = inbc.camp_id (+)
				and outbp.seg_det_id = inbc.seg_det_id (+);

      
      /*
      ACTION is CREATE View PV_SESSION_ROLES
      */
CREATE VIEW PV_SESSION_ROLES (ROLE) AS
	SELECT ROLE 
	FROM SESSION_ROLES;

      
 create trigger TD_CAMP_DDROP
  AFTER DELETE
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_DDROP */
declare numrows INTEGER;
begin

if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_region_id;
end if;

if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

end;
/









create trigger TI_CAMP_DDROP
  AFTER INSERT
  on CAMP_DDROP
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_DDROP */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.det_id, :new.placement_seq, null, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 45 or obj_type_id is null);
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.det_id, :new.placement_seq, null, 9, constraint_type_id from constraint_setting
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_DDROP_CARR */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_carrier_id is not null and :old.ddrop_carrier_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_indicator_id = 9 
   and obj_type_id = 45 and obj_id = :old.ddrop_carrier_id;
end if;

if (:new.ddrop_carrier_id is not null and :new.ddrop_carrier_id <> 0) then
  /* check referenced carrier record still exists */
  select ddrop_carrier_id into var_id from ddrop_carrier where ddrop_carrier_id = :new.ddrop_carrier_id;

  insert into referenced_obj select 45, :new.ddrop_carrier_id, null, null, null, null, null,
    24, :new.camp_id, :new.det_id, :new.placement_seq, null, 9, constraint_type_id from constraint_setting
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_DDROP_REG */
declare numrows INTEGER;
        var_id INTEGER;
begin
if (:old.ddrop_region_id is not null and :old.ddrop_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_indicator_id = 9 
   and obj_type_id = 46 and obj_id = :old.ddrop_region_id;
end if;

if (:new.ddrop_region_id is not null and :new.ddrop_region_id <> 0) then
  /* check referenced door drop region record still exists */
  select ddrop_region_id into var_id from ddrop_region where ddrop_region_id = :new.ddrop_region_id;

  insert into referenced_obj select 46, :new.ddrop_region_id, null, null, null, null, null,
    24, :new.camp_id, :new.det_id, :new.placement_seq, null, 9, constraint_type_id from constraint_setting
    where ref_type_id = 24 and ref_indicator_id = 9 and (obj_type_id = 46 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_DET */
declare numrows INTEGER;
begin

/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
       and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
       and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
  end if;
end if;

end;
/










create trigger TI_CAMP_DET
  AFTER INSERT
  on CAMP_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
      24, :new.camp_id, :new.det_id, null, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.det_id, null, null, 3, constraint_type_id from constraint_setting
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* remove old reference details */
if (:old.obj_type_id in (1,4,17,18,19,20,28,29) and :old.obj_id is not null and :old.obj_id <> 0) then
  if (:old.obj_sub_id is null or :old.obj_sub_id = 0) then
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
       and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id;
  else
     delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
       and ref_indicator_id = 3 and obj_type_id = :old.obj_type_id and obj_id = :old.obj_id and obj_sub_id = :old.obj_sub_id;
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
      24, :new.camp_id, :new.det_id, null, null, 3, constraint_type_id from constraint_setting
      where ref_type_id = 24 and ref_indicator_id = 3 and (obj_type_id = :new.obj_type_id or obj_type_id is null);
  else 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, :new.obj_sub_id, null, null, null, null, 
      24, :new.camp_id, :new.det_id, null, null, 3, constraint_type_id from constraint_setting
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














create trigger TD_CAMP_DRTV
  AFTER DELETE
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_DRTV */
declare numrows INTEGER;
begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
      and ref_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 47 and obj_id = :old.drtv_id;
end if;

if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
      and ref_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 48 and obj_id = :old.drtv_region_id;
end if;
end;
/





create trigger TI_CAMP_DRTV
  AFTER INSERT
  on CAMP_DRTV
  
  for each row
/* ERwin Builtin Thu Jun 08 12:40:54 2000 */
/* default body for TI_CAMP_DRTV */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 10, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 10 and
      (obj_type_id = 47 or obj_type_id is null);
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 10, constraint_type_id
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
/* ERwin Builtin Thu Jun 08 12:40:54 2000 */
/* default body for TU_CAMP_DRTV_REG */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.drtv_region_id is not null and :old.drtv_region_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
      and ref_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 48 and obj_id = :old.drtv_region_id;
end if;

if (:new.drtv_region_id is not null and :new.drtv_region_id <> 0) then
   /* check referenced TV Region record still exists */
   select tv_region_id into var_id from tv_region where tv_region_id = :new.drtv_region_id;

   insert into referenced_obj select 48, :new.drtv_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 10, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_DRTV_ST */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.drtv_id is not null and :old.drtv_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
      and ref_det_id = :old.placement_seq and ref_indicator_id = 10 and obj_type_id = 47 and obj_id = :old.drtv_id;
end if;
if (:new.drtv_id is not null and :new.drtv_id <> 0) then
   /* check referenced TV Station record still exists */
   select tv_id into var_id from tv_station where tv_id = :new.drtv_id;

   insert into referenced_obj select 47, :new.drtv_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 10, constraint_type_id
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














create trigger TD_CAMP_FIXED_COST
  AFTER DELETE
  on CAMP_FIXED_COST
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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













create trigger TD_CAMP_GRP
  AFTER DELETE
  on CAMP_GRP
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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











create trigger TD_CAMP_LEAF
  AFTER DELETE
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_LEAF */
declare numrows INTEGER;

begin

if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

end;
/
























create trigger TI_CAMP_LEAF
  AFTER INSERT
  on CAMP_LEAF
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_LEAF */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 49 or obj_type_id is null);
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 50 or obj_type_id is null);
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 11 and
      (obj_type_id = 51 or obj_type_id is null);
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_LEAF_CP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.collect_point_id is not null and :old.collect_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 51 and obj_id = :old.collect_point_id;
end if;

if (:new.collect_point_id is not null and :new.collect_point_id <> 0) then
   /* check referenced Collection Point record still exists */
   select collect_point_id into var_id from collect_point where collect_point_id = :new.collect_point_id;

   insert into referenced_obj select 51, :new.collect_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_LEAF_DP */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.distrib_point_id is not null and :old.distrib_point_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 52 and obj_id = :old.distrib_point_id;
end if;

if (:new.distrib_point_id is not null and :new.distrib_point_id <> 0) then
   /* check referenced Distribution Point record still exists */
   select distrib_point_id into var_id from distrib_point where distrib_point_id = :new.distrib_point_id;

   insert into referenced_obj select 52, :new.distrib_point_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_LEAF_LD */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_distrib_id is not null and :old.leaf_distrib_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 50 and obj_id = :old.leaf_distrib_id;
end if;

if (:new.leaf_distrib_id is not null and :new.leaf_distrib_id <> 0) then
   /* check referenced Leaflet distributor record still exists */
   select leaf_distrib_id into var_id from leaf_distrib where leaf_distrib_id = :new.leaf_distrib_id;

   insert into referenced_obj select 50, :new.leaf_distrib_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_LEAF_LR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.leaf_region_id is not null and :old.leaf_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 11
    and obj_type_id = 49 and obj_id = :old.leaf_region_id;
end if;

if (:new.leaf_region_id is not null and :new.leaf_region_id <> 0) then
   /* check referenced Leaflet region record still exists */
   select leaf_region_id into var_id from leaf_region where leaf_region_id = :new.leaf_region_id;

   insert into referenced_obj select 49, :new.leaf_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 11, constraint_type_id
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
























create trigger TD_CAMP_OUT_DET
  AFTER DELETE
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_OUT_DET */
declare numrows INTEGER;

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

end;
/













create trigger TI_CAMP_OUT_DET
  AFTER INSERT
  on CAMP_OUT_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_OUT_DET */
declare numrows INTEGER;
        var_id INTEGER;

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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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







create trigger TD_CAMP_POST
  AFTER DELETE
  on CAMP_POST
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_POST */
declare numrows INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;
end;
/






















create trigger TI_CAMP_POST
  AFTER INSERT
  on CAMP_POST
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_POST */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 55 or obj_type_id is null);
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 12 and
      (obj_type_id = 53 or obj_type_id is null);
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_POST_CO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.contractor_id is not null and :old.contractor_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 55 and obj_id = :old.contractor_id;
end if;

if (:new.contractor_id is not null and :new.contractor_id <> 0) then
   /* check referenced Poster Contractor record still exists */
   select contractor_id into var_id from poster_contractor where contractor_id = :new.contractor_id;

   insert into referenced_obj select 55, :new.contractor_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_POST_PS */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_size_id is not null and :old.poster_size_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 53 and obj_id = :old.poster_size_id;
end if;

if (:new.poster_size_id is not null and :new.poster_size_id <> 0) then
   /* check referenced Poster Size record still exists */
   select poster_size_id into var_id from poster_size where poster_size_id = :new.poster_size_id;

   insert into referenced_obj select 53, :new.poster_size_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_POST_PT */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.poster_type_id is not null and :old.poster_type_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 12
    and obj_type_id = 54 and obj_id = :old.poster_type_id;
end if;

if (:new.poster_type_id is not null and :new.poster_type_id <> 0) then
   /* check referenced Poster Type record still exists */
   select poster_type_id into var_id from poster_type where poster_type_id = :new.poster_type_id;

   insert into referenced_obj select 54, :new.poster_type_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 12, constraint_type_id
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










create trigger TD_CAMP_PUB
  AFTER DELETE
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_PUB */
declare numrows INTEGER;

begin
if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
     and ref_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
        and ref_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

end;
/










create trigger TI_CAMP_PUB
  AFTER INSERT
  on CAMP_PUB
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.det_id, :new.placement_seq, null, 14, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_PUB */
declare numrows INTEGER;
        var_id INTEGER;

begin

if (:old.pub_id is not null and :old.pub_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
     and ref_det_id = :old.placement_seq and ref_indicator_id = 14 
     and obj_type_id = 58 and obj_id = :old.pub_id;
   if (:old.pub_sec_id is not null and :old.pub_sec_id <> 0) then
      delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id
        and ref_det_id = :old.placement_seq and ref_indicator_id = 14 
        and obj_type_id = 59 and obj_id = :old.pub_id and obj_sub_id = :old.pub_sec_id;
   end if;
end if;

if (:new.pub_id is not null and :new.pub_id <> 0) then
   /* check referenced Publication record still exists */
   select pub_id into var_id from pub where pub_id = :new.pub_id;

   insert into referenced_obj select 58, :new.pub_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 14, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 14 and
      (obj_type_id = 58 or obj_type_id is null);

   if (:new.pub_sec_id is not null and :new.pub_sec_id <> 0) then
      /* check referenced Radio Region record still exists */
      select pub_sec_id into var_id from pubsec where pub_id = :new.pub_id and pub_sec_id = :new.pub_sec_id;

      insert into referenced_obj select 59, :new.pub_id, :new.pub_sec_id, null, null, null, null,
         24, :new.camp_id, :new.det_id, :new.placement_seq, null, 14, constraint_type_id
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











create trigger TD_CAMP_RADIO
  AFTER DELETE
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMP_RADIO */
declare numrows INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;
end;
/

















create trigger TI_CAMP_RADIO
  AFTER INSERT
  on CAMP_RADIO
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMP_RADIO */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 13, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 13 and
      (obj_type_id = 56 or obj_type_id is null);
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 13, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_RADIO_RA */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_id is not null and :old.radio_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 56 and obj_id = :old.radio_id;
end if;

if (:new.radio_id is not null and :new.radio_id <> 0) then
   /* check referenced Radio Station record still exists */
   select radio_id into var_id from radio where radio_id = :new.radio_id;

   insert into referenced_obj select 56, :new.radio_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 13, constraint_type_id
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMP_RADIO_RR */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.radio_region_id is not null and :old.radio_region_id <> 0) then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and
    ref_sub_id = :old.det_id and ref_det_id = :old.placement_seq and ref_indicator_id = 13
    and obj_type_id = 57 and obj_id = :old.radio_region_id;
end if;

if (:new.radio_region_id is not null and :new.radio_region_id <> 0) then
   /* check referenced Radio Region record still exists */
   select radio_region_id into var_id from radio_region where radio_region_id = :new.radio_region_id;

   insert into referenced_obj select 57, :new.radio_region_id, null, null, null, null, null,
      24, :new.camp_id, :new.det_id, :new.placement_seq, null, 13, constraint_type_id
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




create trigger TD_CAMP_REP_HDR
  AFTER DELETE
  on CAMP_REP_HDR
  
  for each row
/* ERwin Builtin Tue May 23 15:51:07 2000 */
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
/* ERwin Builtin Tue May 23 15:51:07 2000 */
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
/* ERwin Builtin Tue May 23 15:51:07 2000 */
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






create trigger TD_CAMPAIGN
  AFTER DELETE
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_CAMPAIGN */
declare numrows INTEGER;
begin
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
   and obj_type_id = 33 and obj_id = :old.camp_grp_id and ref_indicator_id = 1; 

if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

if (:old.camp_type_id is not null and :old.camp_type_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = 37 and obj_id = :old.camp_type_id and ref_indicator_id = 1; 
end if;

if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
      and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id and ref_indicator_id = 1; 
end if;
end;
/























create trigger TI_CAMPAIGN
  AFTER INSERT
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_CAMPAIGN */
declare numrows INTEGER;
        var_id INTEGER;

begin

/* check referenced Campaign Group exists */
select camp_grp_id into var_id from camp_grp where camp_grp_id = :new.camp_grp_id;

/* insert reference to Campaign Group */
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 1, constraint_type_id
from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 33 or obj_type_id is null);

/* insert reference to Manager (optional) */
if (:new.manager_id is not null and :new.manager_id <> 0) then
   /* check referenced Campaign Manager exists */
   select manager_id into var_id from camp_manager where manager_id = :new.manager_id;
   
   insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 36 or obj_type_id is null);
 end if;

/* insert reference to Budget Manager (optional) */
if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
    /* check referenced Budget Manager exists */
    select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;
    
    insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 4, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 and (obj_type_id = 36 or obj_type_id is null);
end if;

/* insert reference to Campaign Type (optional) */
if (:new.camp_type_id is not null and :new.camp_type_id <> 0) then
    /* check referenced Campaign Type exists */
    select camp_type_id into var_id from camp_type where camp_type_id = :new.camp_type_id;
    
    insert into referenced_obj select 37, :new.camp_type_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 37 or obj_type_id is null);
end if;

/* insert reference to segment (optional) */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
   /* check referenced segment exists */
   select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id and seg_id = :new.web_filter_id;
   insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
   from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/






























create trigger TU_CAMPAIGN_BMAN
  AFTER UPDATE OF 
        BUDGET_MANAGER_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMPAIGN_BMAN */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old budget manager, if given */
if (:old.budget_manager_id is not null and :old.budget_manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
      and obj_type_id = 36 and obj_id = :old.budget_manager_id and ref_indicator_id = 4; 
end if;

/* check new referenced budget manager exists, if given */
if (:new.budget_manager_id is not null and :new.budget_manager_id <> 0) then
    select manager_id into var_id from camp_manager where manager_id = :new.budget_manager_id;

    insert into referenced_obj select 36, :new.budget_manager_id, null, null, null, null, null, 24, :new.camp_id, null, null, null, 4, constraint_type_id
      from constraint_setting where ref_type_id = 24 and ref_indicator_id = 4 and (obj_type_id = 36 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/























create trigger TU_CAMPAIGN_CMAN
  AFTER UPDATE OF 
        MANAGER_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMPAIGN_CMAN */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old manager, if given */
if (:old.manager_id is not null and :old.manager_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null
     and obj_type_id = 36 and obj_id = :old.manager_id and ref_indicator_id = 1; 
end if;

/* check new referenced manager exists, if given */
if (:new.manager_id is not null and :new.manager_id <> 0) then
  select manager_id into var_id from camp_manager where manager_id = :new.manager_id;

  insert into referenced_obj select 36, :new.manager_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 36 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
insert into referenced_obj select 33, :new.camp_grp_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = 33 or obj_type_id is null);


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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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











create trigger TU_CAMPAIGN_WEBSEG
  AFTER UPDATE OF 
        WEB_FILTER_TYPE_ID,
        WEB_FILTER_ID
  on CAMPAIGN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_CAMPAIGN_WEBSEG */
declare numrows INTEGER;
        var_id INTEGER;
begin
/* remove reference to old web segment, if given */
if (:old.web_filter_id is not null and :old.web_filter_id <> 0) then
   delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id is null 
     and obj_type_id = :old.web_filter_type_id and obj_id = :old.web_filter_id and ref_indicator_id = 1; 
end if;

/* check new referenced web segment exists, if given */
if (:new.web_filter_id is not null and :new.web_filter_id <> 0) then
  select seg_id into var_id from seg_hdr where seg_type_id = :new.web_filter_type_id and seg_id = :new.web_filter_id;

  insert into referenced_obj select :new.web_filter_type_id, :new.web_filter_id, null, null, null, null, null,24,:new.camp_id, null, null, null, 1, constraint_type_id
  from constraint_setting where ref_type_id = 24 and ref_indicator_id = 1 and (obj_type_id = :new.web_filter_type_id or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/











create trigger TD_DATA_REP_DET
  AFTER DELETE
  on DATA_REP_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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













create trigger TD_DATA_REP_SRC
  AFTER DELETE
  on DATA_REP_SRC
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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





create trigger TD_DATAVIEW_TEMPLD
  AFTER DELETE
  on DATAVIEW_TEMPL_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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



















create trigger TD_DELIVERY_CHAN
  AFTER DELETE
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_DELIVERY_CHAN */
declare numrows INTEGER;

begin

if :old.dft_ext_templ_id <> 0 then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 12 and obj_id = :old.dft_ext_templ_id;
end if;

if (:old.server_id is not null and :old.server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.server_id;
end if;
  
if ((:old.bounce_server_id is not null and :old.bounce_server_id <> 0) and
    (:old.bounce_mailbox_id is not null and :old.bounce_mailbox_id <> 0)) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 62 and obj_id = :old.bounce_server_id and obj_sub_id = :old.bounce_mailbox_id;
end if;

if (:old.label_id is not null and :old.label_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 63 and obj_id = :old.label_id;
end if;

end;
/














create trigger TI_DELIVERY_CHAN
  AFTER INSERT
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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

if (:new.server_id is not null and :new.server_id <> 0) then
  /* check that referenced server record still exists */
  select server_id into var_id from email_server where server_id = :new.server_id;

  insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 61 or obj_type_id is null);
end if;
  
if ((:new.bounce_server_id is not null and :new.bounce_server_id <> 0) and
    (:new.bounce_mailbox_id is not null and :new.bounce_mailbox_id <> 0)) then
  /* check that referenced mailbox record still exists */
  select mailbox_id into var_id from email_mailbox where server_id = :new.bounce_server_id
    and mailbox_id = :new.bounce_mailbox_id;

  insert into referenced_obj select 62, :new.bounce_server_id, :new.bounce_mailbox_id, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 62 or obj_type_id is null);
end if;

if (:new.label_id is not null and :new.label_id <> 0) then
  /* check that referenced label record still exists */
  select label_id into var_id from label_param where label_id = :new.label_id;

  insert into referenced_obj select 63, :new.label_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 63 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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






create trigger TU_DELIVERY_CHAN_L
  AFTER UPDATE OF 
        LABEL_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_DELIVERY_CHAN_L */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.label_id is not null and :old.label_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 63 and obj_id = :old.label_id;
end if;

if (:new.label_id is not null and :new.label_id <> 0) then
  /* check that referenced label record still exists */
  select label_id into var_id from label_param where label_id = :new.label_id;

  insert into referenced_obj select 63, :new.label_id, null, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 63 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/





create trigger TU_DELIVERY_CHAN_M
  AFTER UPDATE OF 
        BOUNCE_MAILBOX_ID,
        BOUNCE_SERVER_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_DELIVERY_CHAN_M */
declare numrows INTEGER;
        var_id INTEGER;

begin

if ((:old.bounce_server_id is not null and :old.bounce_server_id <> 0) and
    (:old.bounce_mailbox_id is not null and :old.bounce_mailbox_id <> 0)) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 62 and obj_id = :old.bounce_server_id and obj_sub_id = :old.bounce_mailbox_id;
end if;

if ((:new.bounce_server_id is not null and :new.bounce_server_id <> 0) and
    (:new.bounce_mailbox_id is not null and :new.bounce_mailbox_id <> 0)) then
  /* check that referenced mailbox record still exists */
  select mailbox_id into var_id from email_mailbox where server_id = :new.bounce_server_id
    and mailbox_id = :new.bounce_mailbox_id;

  insert into referenced_obj select 62, :new.bounce_server_id, :new.bounce_mailbox_id, null, null, null, null,
    11, :new.chan_id, null, null, null, 1, constraint_type_id from constraint_setting where 
    ref_type_id = 11 and ref_indicator_id = 1 and (obj_type_id = 62 or obj_type_id is null);
end if;

EXCEPTION
when NO_DATA_FOUND then
   raise_application_error (-20001, 'Referenced object does not exist');
when OTHERS then
   raise_application_error (-20002, 'Trigger error');
end;
/




create trigger TU_DELIVERY_CHAN_S
  AFTER UPDATE OF 
        SERVER_ID
  on DELIVERY_CHAN
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_DELIVERY_CHAN_S */
declare numrows INTEGER;
        var_id INTEGER;

begin
if (:old.server_id is not null and :old.server_id <> 0) then
  delete from referenced_obj where ref_type_id = 11 and ref_id = :old.chan_id and ref_indicator_id = 1 and
    obj_type_id = 61 and obj_id = :old.server_id;
end if;

if (:new.server_id is not null and :new.server_id <> 0) then
  /* check that referenced server record still exists */
  select server_id into var_id from email_server where server_id = :new.server_id;

  insert into referenced_obj select 61, :new.server_id, null, null, null, null, null,
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






create trigger TD_DERIVED_VAL_HDR
  AFTER DELETE
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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




















create trigger TU_DERIVED_VAL_HDR
  AFTER UPDATE OF 
        WHERE_SEG_ID
  on DERIVED_VAL_HDR
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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










create trigger TD_DERIVED_VAL_SRC
  AFTER DELETE
  on DERIVED_VAL_SRC
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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



















create trigger TD_ELEM
  AFTER DELETE
  on ELEM
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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












create trigger TD_EMAIL_MAILBOX
  AFTER DELETE
  on EMAIL_MAILBOX
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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







create trigger TD_EV_CAMP_DET
  AFTER DELETE
  on EV_CAMP_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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




create trigger TD_EXT_PROC_CONTRL
  AFTER DELETE
  on EXT_PROC_CONTROL
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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








create trigger TD_EXT_TEMPL_DET
  AFTER DELETE
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
end if;

end;
/









create trigger TI_EXT_TEMPL_DET
  AFTER INSERT
  on EXT_TEMPL_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_EXT_TEMPL_DET */
declare numrows INTEGER;
        var_id INTEGER;

begin

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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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

end if;


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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_MAILBOX_RES_RUL */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :new.rule_id <> 0 then
  /* check that referenced rule still exists */
  select rule_id into var_id from email_res_rule_hdr where rule_id = :new.rule_id;

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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
  select rule_id into var_id from email_res_rule_hdr where rule_id = :new.rule_id;

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






create trigger TD_RES_STREAM_DET
  AFTER DELETE
  on RES_STREAM_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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







create trigger TD_SCORE_DET
  AFTER DELETE
  on SCORE_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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















create trigger TD_SCORE_SRC
  AFTER DELETE
  on SCORE_SRC
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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






















create trigger TD_SEG_DEDUPE_PRIO
  AFTER DELETE
  on SEG_DEDUPE_PRIO
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Thu Jun 08 12:40:54 2000 */
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
/* ERwin Builtin Thu Jun 08 12:40:54 2000 */
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






create trigger TD_SEG_HDR
  AFTER DELETE
  on SEG_HDR
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
























create trigger TD_SPI_PROC
  AFTER DELETE
  on SPI_PROC
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id =  62 then
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
  elsif :new.obj_type_id = 66 then   /* external process */
    select ext_proc_id into var_id from ext_proc_control where ext_proc_id = :new.obj_id;
  end if;

  if (:new.obj_type_id in (1,2,4,5,66) and :new.obj_id <> 0) then 
    insert into referenced_obj select :new.obj_type_id, :new.obj_id, null, null, null, null, null,
      17, :new.spi_id, :new.proc_seq, :new.camp_proc_seq, null, 3, constraint_type_id from
      constraint_setting where ref_type_id = 17 and ref_indicator_id = 3 and 
      (obj_type_id = :new.obj_type_id or obj_type_id is null);
  elsif :new.obj_type_id =  62 then
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


















create trigger TD_STORED_FLD_TMPL
  AFTER DELETE
  on STORED_FLD_TEMPL
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
         c.ref_type_id = :new.seg_type_id and c.ref_indicator_id = 7 and (c.obj_type_id = 13 or c.obj_type_id is null);
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





create trigger TD_TCHARAC
  AFTER DELETE
  on TCHARAC
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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









create trigger TD_TELEM
  AFTER DELETE
  on TELEM
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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















create trigger TD_TREAT_FIXED_COST
  AFTER DELETE
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TD_TREAT_FIXED_COST */
declare numrows INTEGER;

begin
if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :old.fixed_cost_area_id <> 0 then
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5; 
end if;

if :old.supplier_id <> 0 then
delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;
end;
/







create trigger TI_TREAT_FIXED_COST
  AFTER INSERT
  on TREAT_FIXED_COST
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TI_TREAT_FIXED_COST */
declare numrows INTEGER;
        var_id INTEGER;

begin
/* check referenced objects still exist */

if :new.fixed_cost_id <> 0 then
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
end if;

if :new.fixed_cost_area_id <> 0 then
  select fixed_cost_area_id into var_id from fixed_cost_area where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 39 or obj_type_id is null);
end if;

if :new.supplier_id <> 0 then
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 40 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_TREAT_FIXED_COST_AREA */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.fixed_cost_area_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 39 and obj_id = :old.fixed_cost_area_id and ref_indicator_id = 5;
end if;

if :new.fixed_cost_area_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_area_id into var_id from fixed_cost_area where fixed_cost_area_id = :new.fixed_cost_area_id;

  insert into referenced_obj select 39, :new.fixed_cost_area_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 39 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_TREAT_FIXED_COST_FC */
declare numrows INTEGER;
        var_id INTEGER;
begin

if :old.fixed_cost_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 38 and obj_id = :old.fixed_cost_id and ref_indicator_id = 5; 
end if;

if :new.fixed_cost_id <> 0 then
  /* check referenced objects still exist */
  select fixed_cost_id into var_id from fixed_cost where fixed_cost_id = :new.fixed_cost_id;

  insert into referenced_obj select 38, :new.fixed_cost_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 38 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
/* default body for TU_TREAT_FIXED_COST_SUP */
declare numrows INTEGER;
        var_id INTEGER;

begin

if :old.supplier_id <> 0 then
  delete from referenced_obj where ref_type_id = 24 and ref_id = :old.camp_id and ref_sub_id = :old.det_id and ref_det_id = :old.treat_cost_seq and obj_type_id = 40 and obj_id = :old.supplier_id and ref_indicator_id = 5; 
end if;

if :new.supplier_id <> 0 then
  /* check referenced objects still exist */
  select supplier_id into var_id from supplier where supplier_id = :new.supplier_id;

  insert into referenced_obj select 40, :new.supplier_id, null, null, null, null, null, 24, :new.camp_id, :new.det_id, :new.treat_cost_seq, null, 5, constraint_type_id
    from constraint_setting where ref_type_id = 24 and ref_indicator_id = 5 and (obj_type_id = 40 or obj_type_id is null);
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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











create trigger TD_TREE_BASE
  AFTER DELETE
  on TREE_BASE
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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










create trigger TD_TREE_DET
  AFTER DELETE
  on TREE_DET
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
















create trigger TD_WEB_TEMPL
  AFTER DELETE
  on WEB_TEMPL
  
  for each row
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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
/* ERwin Builtin Wed May 24 10:36:41 2000 */
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

update pvdm_upgrade set version_id = translate(version_id,'.0.','.1.');
COMMIT;

prompt 'V3.0 Prime@Vantage System Schema has been upgraded to V3.1'
spool off;








