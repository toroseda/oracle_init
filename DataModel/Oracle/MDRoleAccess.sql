prompt 
accept md_role prompt 'Enter Marketing Director Application Role Name >'
prompt
prompt

spool MDRoleAccessSys.log

GRANT SELECT, UPDATE, INSERT, DELETE ON ACCESS_LEVEL TO &md_role;   
GRANT SELECT, UPDATE, INSERT, DELETE ON ACTION_CUSTOM to &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON ACTION_FORWARD to &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ACTION_STORE_CAMP to &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ACTION_STORE_VAL to &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON ATTACHMENT TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON ATTR_DEFINITION TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMPAIGN TO &md_role;                        
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_COMM_IN_DET TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_COMM_IN_HDR TO &md_role;    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_COMM_OUT_DET TO &md_role;   
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_COMM_OUT_HDR TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_CYC_STATUS TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_DDROP TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_DET TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_DET_RUN_HIST TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_DRTV TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_FIXED_COST TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_GRP TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_LEAF TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_MANAGER TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_MAP_SFDYN TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_DET TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_GRP TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_GRP_SPLIT TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_OUT_RESULT TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_PLACEMENT TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_PLAN TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_POST TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_PUB TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_RADIO TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_REP_COL TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_REP_COND TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_REP_DET TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_REP_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_REP_HDR TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_RESULT_PROC TO &md_role;        
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_RES_DET TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_RES_MODEL TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_SEG TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_STATUS_HIST TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_TEMPL TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_TREAT_DET TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_TYPE TO &md_role;    
GRANT SELECT, UPDATE, INSERT, DELETE ON CAMP_VERSION TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON CDV_ACCESS TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON CDV_HDR TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON CHAN_OUT_TYPE TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON CHAN_TYPE TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CHARAC TO &md_role;                       
GRANT SELECT, UPDATE, INSERT, DELETE ON CHARAC_GRP TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON COLLECT_POINT TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON COMM_STATUS TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON COMM_NON_CONTACT TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON COMP_TYPE TO &md_role;        
GRANT SELECT, UPDATE, INSERT, DELETE ON COND_OPERATOR TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON CONSTRAINT_SETTING TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CONSTRAINT_TYPE TO &md_role;          
GRANT SELECT, UPDATE, INSERT, DELETE ON CONS_FLD_DET TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON CONS_FLD_HDR TO &md_role;                         
GRANT SELECT, UPDATE, INSERT, DELETE ON CONTENT_FORMT TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON CUST_JOIN TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON CUST_TAB TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON CUST_TAB_GRP TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON CUSTOM_ATTR TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON CUSTOM_ATTR_VAL TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON DATAVIEW_TEMPL_DET TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON DATAVIEW_TEMPL_HDR TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON DATA_CAT_HDR TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON DATA_REP_DET TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON DATA_REP_HDR TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON DATA_REP_SRC TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON DDROP_CARRIER TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON DDROP_REGION TO &md_role; 
GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_CONFIG TO &md_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_DEDUPE TO &md_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_INPUT TO &md_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_OUTPUT TO &md_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON DECISION_SRC_INPUT TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON DEFINE_TYPE TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_CHAN TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_METHOD TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_RECEIPT TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_SERVER TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON DELIVERY_STATUS TO &md_role;      
GRANT SELECT, UPDATE, INSERT, DELETE ON DERIVED_VAL_HDR TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON DERIVED_VAL_SRC TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON DISTRIB_POINT TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON DUR_UNIT TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON ELEM TO &md_role;                         
GRANT SELECT, UPDATE, INSERT, DELETE ON ELEM_GRP TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON ELEM_WEB_MAP TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_MAILBOX TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_PROTOCOL TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_RES TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_SERVER TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON EMAIL_TYPE TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON EMPTY_CYC_TYPE TO &md_role;     
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_DET TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_HDR TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_GRP TO &md_role;    
GRANT SELECT, UPDATE, INSERT, DELETE ON ERES_RULE_TYPE TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON EV_CAMP_DET TO &md_role;   
GRANT SELECT, UPDATE, INSERT, DELETE ON EXPORT_HDR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_HDR_AND_FTR TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_PROC_CONTROL TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_PROC_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_PROC_PARAM TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_TEMPL_DET TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON EXT_TEMPL_HDR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON FIXED_COST TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON FIXED_COST_AREA TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON GRP_FTR_TYPE TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON GRP_FUNCTION TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON GRP_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_HDR TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_OBJ_MAP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON IMPORT_TYPE TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON INTERVAL_CYC_DET TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON JOIN_OPERATOR TO &md_role;                          
GRANT SELECT, UPDATE, INSERT, DELETE ON LEAF_DISTRIB TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON LEAF_REGION TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON LOCK_CONTROL TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON LOCK_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON LOOKUP_TAB_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON LOOKUP_TAB_HDR TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON MAILBOX_RES_RULE TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON MAIN_SPI_ACTION TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON MESSAGE_SEVER TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON MESSAGE_TYPE TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON MODULE_DEFINITION TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON NODE_TYPE TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON OBJ_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON OUT_CHAN_COMP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON OUT_GRP_NAME_COMP TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON OUT_SEED_MAPPING TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON PAGE_FACING TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON POSTER_CONTRACTOR TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON POSTER_SIZE TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON POSTER_TYPE TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_AUDIT_DET TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_AUDIT_DET_VAR TO &md_role;           
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_AUDIT_HDR TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_AUDIT_PARAM TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_CONTROL TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_PARAM TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON PROC_TYPE TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON PROTOCOL_VERSION TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON PUB TO &md_role;                          
GRANT SELECT, UPDATE, INSERT, DELETE ON PUBSEC TO &md_role;                       
GRANT SELECT, UPDATE, INSERT, DELETE ON PVDM_UPGRADE TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON RADIO TO &md_role;                        
GRANT SELECT, UPDATE, INSERT, DELETE ON RADIO_REGION TO &md_role;     
GRANT SELECT, UPDATE, INSERT, DELETE ON REFERENCED_OBJ TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON REF_INDICATOR TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON REM_ACTION_TYPE TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON REM_CLIENT_DET TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON REM_CLIENT_HDR TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON REP_COL_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON REPLACE_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON RESTRICT_TYPE TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_ACTION_TYPE to &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_CHANNEL TO &md_role;  
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_CUSTOM_PARAM to &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_MODEL_HDR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_MODEL_STREAM TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_RULE_ACTION TO &md_role;                       
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_STREAM_DET TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_SYS_PARAM to &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON RES_TYPE TO &md_role;                          
GRANT SELECT, UPDATE, INSERT, DELETE ON SAMPLE_TYPE TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON SAS_SCORE_RESULT TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON SCORE_DET TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON SCORE_EXTERNAL TO &md_role;  
GRANT SELECT, INSERT, UPDATE, DELETE ON SCORE_GRP TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON SCORE_HDR TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON SCORE_SRC TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON SEARCH_AREA TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON SEED_LIST_DET TO &md_role;   
GRANT SELECT, UPDATE, INSERT, DELETE ON SEED_LIST_GRP TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON SEED_LIST_HDR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON SEG_DEDUPE_PRIO TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON SEG_GRP TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON SEG_HDR TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON SEG_SQL TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_AUDIT_DET TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_AUDIT_DET_VAR TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_AUDIT_HDR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_AUDIT_PARAM TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_CAMP_PROC TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_CAMP_PROC_PAR TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_CAMP_PROC_VAR TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_CONTROL TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_LINK TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_MASTER TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_PROC TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_PROC_VAR TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_TIME_CONTROL TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON SPI_TYPE TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON SPLIT_TYPE TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON STATUS_SETTING TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON STORED_FLD_TEMPL TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON STRATEGY TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON SUBS_CAMPAIGN TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON SUBS_CAMP_CYC TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON SUBS_CAMP_CYC_ORG TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON SUBS_CAMP_ORG_DET TO &md_role; 
GRANT SELECT, UPDATE, INSERT, DELETE ON SUPPLIER TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON SYS_PARAM TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TCHARAC TO &md_role;                      
GRANT SELECT, UPDATE, INSERT, DELETE ON TELEM TO &md_role;                        
GRANT SELECT, UPDATE, INSERT, DELETE ON TEMPL_EMAIL_MAP TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON TEST_TEMPL_MAP TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON TEST_TYPE TO &md_role;       
GRANT SELECT, UPDATE, INSERT, DELETE ON TREATMENT TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON TREATMENT_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TREATMENT_TEST TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON TREAT_FIXED_COST TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_BASE TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_DET TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_GRP TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON TREE_HDR TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON TV_REGION TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON TV_STATION TO &md_role;     
GRANT SELECT, UPDATE, INSERT, DELETE ON UPDATE_STATUS TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_ACCESS_EXCEP TO &md_role;            
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_CDV_EXCEP TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_DEFINITION TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_GRP TO &md_role;                     
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_GRP_ACCESS TO &md_role;              
GRANT SELECT, UPDATE, INSERT, DELETE ON USER_GRP_CDV TO &md_role;                 
GRANT SELECT, UPDATE, INSERT, DELETE ON VANTAGE_DYN_TAB TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON VANTAGE_FUNCTION TO &md_role;             
GRANT SELECT, UPDATE, INSERT, DELETE ON VAR_DATA_TYPE TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_IMPRESSION TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_METHOD TO &md_role;                   
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_STATE_TYPE TO &md_role;               
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_STATE_VAR TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_STD_TAG TO &md_role;                  
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_TEMPL TO &md_role;                    
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_TEMPL_GRP TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_TEMPL_TAG TO &md_role;                
GRANT SELECT, UPDATE, INSERT, DELETE ON WEB_TEMPL_TAG_DET TO &md_role;   
GRANT SELECT, UPDATE, INSERT, DELETE ON TON_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON NPI_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON PORTION_TYPE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_INBOX TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_PROTOCOL TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_RES TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_RES_RULE TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_SERVER TO &md_role;
GRANT SELECT, UPDATE, INSERT, DELETE ON WIRELESS_VENDOR TO &md_role;
GRANT SELECT ON VANTAGE_ENT TO &md_role;                          
GRANT SELECT ON CAMP_ANALYSIS TO &md_role;
GRANT SELECT ON CAMP_COMM_INB_SUM TO &md_role;
GRANT SELECT ON CAMP_COMM_OUT_SUM TO &md_role;
GRANT SELECT ON CAMP_SEG_COST TO &md_role;
GRANT SELECT ON CAMP_SEG_COUNT TO &md_role;
GRANT SELECT ON CAMP_SEG_DET TO &md_role;
GRANT SELECT ON CAMP_STATUS TO &md_role;
GRANT SELECT ON INB_PROJECTION TO &md_role;
GRANT SELECT ON OUTB_PROJECTION TO &md_role;
GRANT SELECT ON PV_COLS TO &md_role;                      
GRANT SELECT ON PV_IND TO &md_role;                       
GRANT SELECT ON PV_IND_COLS TO &md_role;     
GRANT SELECT ON PV_SESSION_ROLES TO &md_role;             
GRANT SELECT ON PV_TABS TO &md_role;                      
GRANT SELECT ON PV_VIEWS TO &md_role;                     
GRANT SELECT ON RES_REV_COST TO &md_role;    
GRANT SELECT ON TREAT_SEG_COST TO &md_role;
GRANT SELECT ON TREAT_SEG_COUNT TO &md_role;
GRANT SELECT ON USER_ACCESS_PROF TO &md_role;       
GRANT SELECT ON VANTAGE_ALL_TAB TO &md_role;  
GRANT SELECT ON WEB_EXPOSURE TO &md_role;                 
GRANT SELECT ON WEB_CLICKTHROUGH TO &md_role;             
GRANT SELECT ON TREAT_COMM_INFO TO &md_role;
GRANT SELECT ON CHARAC_COMM_INFO TO &md_role;
GRANT SELECT ON ELEM_COMM_INFO TO &md_role;

spool off;

prompt 'Adding access to any existing dynamic tables';

set heading off
set feedback off
set lin 100
set pages 1000

spool MDGrantdyntabs.sql

select 'grant select, update, delete, insert on '|| table_name ||' to &md_role;' from pv_tabs x 
  where table_owner = user and not exists (select * from vantage_ent where ent_name = x.table_name);

spool off;

set heading on
set feedback on

spool MDGrantdyntabs.log
start MDGrantdyntabs
spool off;

exit;
