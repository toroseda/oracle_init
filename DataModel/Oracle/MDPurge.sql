
SET SERVEROUT ON SIZE 20000

--***********************************************************************************

CREATE OR REPLACE PROCEDURE execute_sql (sql_string IN VARCHAR2)
IS
   cid   INTEGER;
BEGIN
   cid := DBMS_SQL.open_cursor;
   /* Parse and immediately execute dynamic SQL statement */
   DBMS_SQL.parse (cid, sql_string, DBMS_SQL.v7);
   DBMS_SQL.close_cursor (cid);
EXCEPTION
   /* If an exception is raised, close cursor before exiting. */
   WHEN OTHERS
   THEN
      DBMS_SQL.close_cursor (cid);
      RAISE;
END execute_sql;
/

-- **********************************************************************************
-- Procedure for removing the stray CS tables 
-- which are not removed once the campaign is completed or cancelled     

CREATE or REPLACE PROCEDURE purge_cstables(exec_type CHAR)
IS
   tab_name          vantage_dyn_tab.db_ent_name%TYPE;
   cid               INTEGER;
   dry_run_flag      SMALLINT;

   CURSOR table_list 
   IS
      SELECT db_ent_name 
        FROM vantage_dyn_tab 
       WHERE db_ent_name LIKE 'CS%_%_%' 
         AND SUBSTR(SUBSTR(db_ent_name, INSTR(db_ent_name, '_') + 1, 8), 1, 
                                        INSTR(SUBSTR(db_ent_name, INSTR(db_ent_name, '_') + 1, 8), '_') - 1)
          IN (SELECT camp_id FROM camp_status_hist WHERE status_setting_id IN (12, 16)) 
      ORDER BY db_ent_name;
BEGIN
   IF ((TRIM(UPPER(exec_type))) = 'PURGE')
   THEN
       dry_run_flag := 0;                   -- Dry_Run_Flag=FALSE,Actual Purging will happen.
   ELSIF((TRIM(UPPER(exec_type))) = 'LIST')
   THEN
       dry_run_flag := 1;                   -- Dry_Run_Flag=TRUE,Only Listing will happen
   ELSE
       DBMS_OUTPUT.put_line ('      Valid Execution types are ''PURGE'' or ''LIST''');
       RETURN;
   END IF;


   OPEN table_list;

   LOOP
      FETCH table_list 
       INTO tab_name;

      EXIT WHEN table_list%NOTFOUND;

      cid := DBMS_SQL.open_cursor;

      IF (dry_run_flag = 0) 			    -- Actual Purging happens.
      THEN
          DBMS_SQL.parse(cid, 'DROP TABLE ' || tab_name, DBMS_SQL.v7);
          DELETE FROM vantage_dyn_tab WHERE db_ent_name = tab_name;
          COMMIT;

	  DBMS_OUTPUT.put_line('CS TABLE DROPPED : ' || tab_name);
      ELSIF (dry_run_flag = 1) 			   -- Only listing purgeable CS tables
      THEN
	    DBMS_OUTPUT.put_line('CS TABLE THAT WILL GET DROPPED : ' || tab_name);
      END IF;

      DBMS_SQL.close_cursor (cid);

   END LOOP;
EXCEPTION
   WHEN OTHERS 
   THEN
      DBMS_SQL.close_cursor (cid);
      RAISE;                                            -- reraise the exception
END purge_cstables;
/

-- ********************************************************************************* 
-- Routine to check if Segment, Base Segment, Campaign or Segmentation Tree is Obsolete, 
-- i.e. not referenced by another 'live' object and last executed prior to purge period

CREATE OR REPLACE FUNCTION is_object_obsolete_check (
   purge_obj_type_id   NUMBER,
   purge_obj_id        NUMBER,
   purge_months        NUMBER
)
   RETURN NUMBER
IS
   var_true          NUMBER (1)     := 0;
   var_obj_type_id   NUMBER (2)     := 0;
   var_obj_id        NUMBER (8)     := 0;
   var_rowid         ROWID          := NULL;
   deadlock_flag     NUMBER         := 1;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);

   CURSOR c20
   IS
      SELECT ref_type_id, ref_id, ROWID 
        FROM referenced_obj
       WHERE obj_id > 0
         AND obj_type_id = purge_obj_type_id
         AND obj_id = purge_obj_id;

   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   var_true := 1;

   OPEN c20;

   LOOP
      FETCH c20
       INTO var_obj_type_id, var_obj_id, var_rowid;

      EXIT WHEN c20%NOTFOUND;

      IF (var_obj_type_id IN (1, 2))
      THEN                                         -- Segment or Base Segment
         SELECT COUNT (*)
           INTO var_true
           FROM seg_hdr
          WHERE seg_type_id = var_obj_type_id
            AND seg_id = var_obj_id
            AND (   (    last_run_date IS NOT NULL
            AND MONTHS_BETWEEN (SYSDATE, last_run_date) > purge_months)
             OR (last_run_date IS NULL AND last_run_qty = -1) );
      ELSIF (var_obj_type_id = 24)
      THEN                                         -- Campaign
         SELECT COUNT (*)
           INTO var_true
           FROM campaign
          WHERE camp_id = var_obj_id AND camp_name LIKE 'PURGED%';

         IF (var_true = 0)
         THEN                                      -- Check if Campaign obsolete
            SELECT COUNT (*)
              INTO var_true
              FROM camp_status_hist x
             WHERE status_setting_id IN (16, 12)
               AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                                      FROM camp_status_hist
                                     WHERE camp_id = x.camp_id)
               AND camp_id = var_obj_id
               AND MONTHS_BETWEEN (SYSDATE, created_date) > purge_months;
         END IF;
      ELSIF (var_obj_type_id = 4)
      THEN                                         -- Segmentation Tree
         SELECT COUNT (*)
           INTO var_true
           FROM tree_hdr
          WHERE tree_id = var_obj_id
            AND (( last_run_date IS NOT NULL AND MONTHS_BETWEEN (SYSDATE, last_run_date) > purge_months)
                                              OR (last_run_date IS NULL AND last_run_dur = -1));
      ELSE
         var_true := 0;
      END IF;

      UPDATE referenced_obj
         SET obj_id = -obj_id
       WHERE ROWID = var_rowid;

      COMMIT;

      IF (var_true > 0)
      THEN
         var_true :=
            is_object_obsolete_check (var_obj_type_id,
                                      var_obj_id,
                                      purge_months
                                     );
      END IF;

      IF (var_true = 0)
      THEN
         EXIT;
      END IF;
   END LOOP;

   CLOSE c20;

   RETURN var_true;
EXCEPTION
   WHEN OTHERS
   THEN
      CLOSE c20;

      var_true := 0;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
      RETURN var_true;
END is_object_obsolete_check;
/


--************************************************************************************

CREATE OR REPLACE FUNCTION is_object_obsolete (
   purge_obj_type_id   NUMBER,
   purge_obj_id        NUMBER,
   purge_months        NUMBER
)
   RETURN NUMBER
IS
   var_true   NUMBER (1)     := 0;
   err_num    NUMBER;
   err_msg    VARCHAR2 (100);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   var_true :=
      is_object_obsolete_check (purge_obj_type_id, purge_obj_id,
                                purge_months);

   UPDATE referenced_obj
   SET obj_id = ABS (obj_id)
   WHERE obj_id < 0;

   COMMIT;
   RETURN var_true;
EXCEPTION
   WHEN OTHERS
   THEN
      var_true := 0;

      UPDATE referenced_obj
         SET obj_id = ABS (obj_id)
       WHERE obj_id < 0;


      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
      RETURN var_true;
END is_object_obsolete;
/



-- *********************************************************************************

-- Routine to Purge Segments and Base Segments
CREATE OR REPLACE PROCEDURE purge_segment (
   var_seg_type_id   NUMBER,
   var_seg_id        NUMBER
)
IS
   var_table_name   VARCHAR2 (50)  := NULL;
   var_view_id      VARCHAR2 (50)  := NULL;
   var_seg_grp_id   NUMBER (4)     := 0;
   var_count        NUMBER         := 0;
   err_num          NUMBER;
   err_msg          VARCHAR2 (100);
BEGIN	
   SELECT COUNT (*)
     INTO var_count
     FROM seg_hdr
    WHERE seg_type_id = var_seg_type_id
      AND seg_id = var_seg_id
      AND last_run_qty = -1 
      AND seg_name like 'PURGED%';

   IF (var_count = 0)
   THEN
      SELECT COUNT (*)
      INTO var_count
      FROM seg_grp
     WHERE seg_grp_name LIKE 'PURGED%'
       AND seg_type_id = var_seg_type_id
       AND view_id = (select view_id FROM SEG_HDR WHERE seg_type_id = var_seg_type_id AND seg_id = var_seg_id);

   IF (var_count = 0)
   THEN
   
     SELECT VIEW_ID 
       INTO var_view_id
       FROM SEG_HDR
      WHERE seg_type_id = var_seg_type_id
        AND seg_id = var_seg_id;
	  
     SELECT MAX (seg_grp_id) + 1
       INTO var_seg_grp_id
       FROM seg_grp
      WHERE seg_type_id = var_seg_type_id
        AND view_id =(SELECT view_id FROM SEG_HDR WHERE seg_type_id = var_seg_type_id AND seg_id = var_seg_id)  ;			
	  
     IF (var_seg_type_id=1) 
     THEN
         INSERT INTO seg_grp
         VALUES (var_seg_grp_id, 1,  'PURGED Segments',var_view_id);
     ELSE
         INSERT INTO seg_grp
         VALUES (var_seg_grp_id, 2,  'PURGED Base Segments',var_view_id);
     END IF;

     COMMIT;
   ELSE
      SELECT seg_grp_id
        INTO var_seg_grp_id
        FROM seg_grp
       WHERE seg_grp_name LIKE 'PURGED%' 
         AND seg_type_id = var_seg_type_id
         AND view_id = (SELECT view_id FROM SEG_HDR WHERE seg_type_id = var_seg_type_id AND seg_id = var_seg_id);
   END IF;
  
      -- Delete associate entries in SEG_SQL table
      DELETE FROM seg_sql
       WHERE seg_type_id = var_seg_type_id AND seg_id = var_seg_id;

      -- Drop associated dynamic tables
      SELECT dyn_tab_name
        INTO var_table_name
        FROM seg_hdr
       WHERE seg_type_id = var_seg_type_id AND seg_id = var_seg_id;
    
      SELECT COUNT (*)
        INTO var_count
        FROM user_tables
       WHERE table_name = var_table_name;

      IF (var_count > 0)
      THEN      	 
      	 execute_sql ('DROP TABLE ' || var_table_name);
      END IF;

      -- Remove respective entries from VANTAGE_DYN_TAB table
      DELETE FROM vantage_dyn_tab
      WHERE db_ent_name = var_table_name;

      -- Update SEG_HDR table Last run details - mark archived Segment by setting last run qty to -1
      UPDATE seg_hdr
         SET last_run_date = NULL,
             seg_name = 'PURGED ' || SUBSTR(seg_name, 1, 93),
             last_run_time = NULL,
             last_run_by = NULL,
             last_run_dur = NULL,
             last_run_qty = -1,
             dyn_tab_name = NULL,                           -- Remove associated Dynamic Table Name 
             updated_date = SYSDATE,
	     updated_by = USER,
	     seg_grp_id = var_seg_grp_id
       WHERE seg_type_id = var_seg_type_id 
         AND seg_id = var_seg_id;

      COMMIT; 

      -- Delete record of references in Criteria string from Referenced Objects table
      -- as this is consistent with setting the segment to the 'definition' state as specified
      SELECT COUNT (*)
        INTO var_count
        FROM referenced_obj
       WHERE ref_type_id = var_seg_type_id
         AND ref_id = var_seg_id
         AND ref_indicator_id = 16;

      IF (var_count > 0)
      THEN
         DELETE FROM referenced_obj
          WHERE ref_type_id = var_seg_type_id
            AND ref_id = var_seg_id
            AND ref_indicator_id = 16;

         COMMIT;
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_segment;
/

-- ***************************************************************************************

CREATE OR REPLACE PROCEDURE purge_ref_segments_check (
   var_ref_type_id   NUMBER,
   var_ref_id        NUMBER,
   purge_months      NUMBER,
   dry_run_flag      SMALLINT
)
IS
   var_count         NUMBER         := 0;
   var_seg_type_id   NUMBER (2)     := 0;
   var_seg_id        NUMBER (8)     := 0;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);

   CURSOR c10
   IS
      SELECT DISTINCT obj_type_id, obj_id
        FROM referenced_obj
       WHERE obj_type_id IN (1, 2)
         AND ref_type_id = var_ref_type_id
         AND ref_id = var_ref_id;

   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   OPEN c10;

   LOOP
      FETCH c10
      INTO var_seg_type_id, var_seg_id;

      EXIT WHEN c10%NOTFOUND;

      -- If Object is Segment AND Object is Obsolete then Purge Segment
      SELECT COUNT (*)
        INTO var_count
        FROM seg_hdr
       WHERE seg_type_id = var_seg_type_id
         AND seg_id = var_seg_id
         AND MONTHS_BETWEEN (SYSDATE, last_run_date) > purge_months
         AND seg_name not like 'PURGED%';

      IF (var_count > 0)
      THEN
         IF (is_object_obsolete (var_seg_type_id, var_seg_id, purge_months) > 0)
         THEN
            IF var_seg_type_id=2 
            THEN
            	IF dry_run_flag = 0
            	THEN
               		DBMS_OUTPUT.put_line ('   Purged referenced Base Segment: '||var_seg_id); 
               	ELSE
               		DBMS_OUTPUT.put_line ('   Purging referenced Base Segment: '||var_seg_id||' RefererenceType ID: '||var_ref_type_id); 
               	END IF;
            ELSE
            	IF dry_run_flag = 0
		THEN
		        DBMS_OUTPUT.put_line ('   Purged referenced Segment: '||var_seg_id);
		ELSE
		        DBMS_OUTPUT.put_line ('   Purging referenced Segment: '||var_seg_id||' RefererenceType ID: '||var_ref_type_id);
               	END IF;               
            END IF;

            IF (dry_run_flag = 0)                 -- Purge if dry_run_flag is FALSE
            THEN
               purge_segment (var_seg_type_id, var_seg_id);
	    ELSIF (dry_run_flag = 1)
	    THEN
               DBMS_OUTPUT.put_line ('');
            END IF;

            UPDATE referenced_obj
               SET obj_type_id = -obj_type_id
             WHERE ref_type_id = var_ref_type_id
               AND ref_id = var_ref_id
               AND obj_type_id = var_seg_type_id
               AND obj_id = var_seg_id;

            COMMIT;

            -- Commented to remove listing of child segments recursively 
            -- Only directly referenced objects are purged, per requirement clarification 
            -- purge_ref_segments_check (var_seg_type_id,
            --                           var_seg_id,
            --                           purge_months,
            --                           dry_run_flag
            --                          );            
         END IF;
      END IF;
   END LOOP;

   CLOSE c10;

   UPDATE referenced_obj
   SET obj_type_id = ABS (obj_type_id)
   WHERE obj_type_id < 0;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      CLOSE c10;

      UPDATE referenced_obj
         SET obj_type_id = ABS (obj_type_id)
       WHERE obj_type_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_ref_segments_check;
/


--*****************************************************************************************

CREATE OR REPLACE PROCEDURE purge_ref_segments (
   var_ref_type_id   NUMBER,
   var_ref_id        NUMBER,
   purge_months      NUMBER,
   dry_run_flag      SMALLINT
)
IS
   err_num   NUMBER;
   err_msg   VARCHAR2 (100);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   purge_ref_segments_check (var_ref_type_id,var_ref_id,purge_months,dry_run_flag);

   UPDATE referenced_obj
      SET obj_type_id = ABS (obj_type_id)
    WHERE obj_type_id < 0;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      UPDATE referenced_obj
         SET obj_type_id = ABS (obj_type_id)
       WHERE obj_type_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_ref_segments;
/


--****************************************************************************************
-- Procedure to Purge single Campaign that has been identified as obsolete

CREATE OR REPLACE PROCEDURE purge_campaign (
   purge_camp_id      NUMBER,
   purge_months       NUMBER,
   purge_rollback     VARCHAR2,
   purge_block_rows   NUMBER
)
IS
   var_count         NUMBER         := 0;
   var_count2        NUMBER         := 0;
   var_strategy_id   NUMBER (4)     := 0;
   var_camp_grp_id   NUMBER (4)     := 0;
   var_obj_type_id   NUMBER (2)     := 0;
   var_obj_id        NUMBER (8)     := 0;
   var_table_name    VARCHAR2 (40)  := NULL;
   var_num           NUMBER;
   var_rowid         ROWID;
   deadlock_flag     NUMBER         := 1;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);

   CURSOR c1
   IS
      SELECT db_ent_name
        FROM vantage_dyn_tab
       WHERE db_ent_name = 'SFI' || purge_camp_id;

   CURSOR c2
   IS
      SELECT db_ent_name
        FROM vantage_dyn_tab
       WHERE db_ent_name = 'SFO' || purge_camp_id;

   CURSOR c3
   IS
      SELECT camp_id, det_id, obj_type_id, obj_id, obj_sub_id
        FROM camp_det
       WHERE camp_id = purge_camp_id;
BEGIN
   -- Check, if Purged Campaign Group within the respective Strategy is created, if not create it
   SELECT g.strategy_id
     INTO var_strategy_id
     FROM campaign c, camp_grp g
    WHERE c.camp_id = purge_camp_id AND c.camp_grp_id = g.camp_grp_id;

   SELECT COUNT (*)
     INTO var_count
     FROM camp_grp
    WHERE strategy_id = var_strategy_id AND camp_grp_name LIKE 'PURGED%';

   IF (var_count = 0)
   THEN
      SELECT MAX (camp_grp_id) + 1
        INTO var_camp_grp_id
        FROM camp_grp;

      INSERT INTO camp_grp
      VALUES (var_camp_grp_id, var_strategy_id, 'PURGED Campaigns',
                   'Campaign Group created within this Stragegy for Purged Campaigns',
                   USER, SYSDATE, NULL, NULL);

      COMMIT;
   ELSE
      SELECT camp_grp_id
        INTO var_camp_grp_id
        FROM camp_grp
       WHERE strategy_id = var_strategy_id AND camp_grp_name LIKE 'PURGED%';
   END IF;

   -- Update Campaign Group to Purged Campaign Group and append Campaign name with PURGED
   UPDATE campaign
      SET camp_grp_id = var_camp_grp_id,
          UPDATED_DATE = SYSDATE,
          UPDATED_BY   = USER,
          camp_name = 'PURGED ' || SUBSTR (camp_name, 1, 43)
    WHERE camp_id = purge_camp_id;


   -- Remove all associated records from the communication tables
   -- Note: Allow allocation of special Rollback Segment
   --  Set to NO LOGGING prior to running the block deletes

   -- Clearing entries associated with given campaign from CAMP_COMM_OUT_HDR
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_out_hdr
    WHERE camp_id = purge_camp_id;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR NOLOGGING');

      WHILE (var_count > 0)
      LOOP
         IF (purge_rollback IS NOT NULL)
         THEN
            DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
         END IF;

         DELETE FROM camp_comm_out_hdr
         WHERE camp_id = purge_camp_id AND ROWNUM <= purge_block_rows;

         COMMIT;
         var_count := var_count - purge_block_rows;

         IF (var_count < 0)
         THEN
            var_count := 0;
         END IF;
      END LOOP;

      execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_OUT_DET
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_out_det
    WHERE camp_id = purge_camp_id;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_OUT_DET NOLOGGING');

      WHILE (var_count > 0)
      LOOP
         IF (purge_rollback IS NOT NULL)
         THEN
            DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
         END IF;

         DELETE FROM camp_comm_out_det
               WHERE camp_id = purge_camp_id AND ROWNUM <= purge_block_rows;

         COMMIT;
         var_count := var_count - purge_block_rows;

         IF (var_count < 0)
         THEN
            var_count := 0;
         END IF;
      END LOOP;

      execute_sql ('ALTER TABLE CAMP_COMM_OUT_DET LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_IN_HDR
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_in_hdr
    WHERE camp_id = purge_camp_id;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR NOLOGGING');

      WHILE (var_count > 0)
      LOOP
         IF (purge_rollback IS NOT NULL)
         THEN
            DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
         END IF;

         DELETE FROM camp_comm_in_hdr
               WHERE camp_id = purge_camp_id AND ROWNUM <= purge_block_rows;

         COMMIT;
         var_count := var_count - purge_block_rows;

         IF (var_count < 0)
         THEN
            var_count := 0;
         END IF;
      END LOOP;

      execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_IN_DET
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_in_det
    WHERE camp_id = purge_camp_id;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_IN_DET NOLOGGING');

      WHILE (var_count > 0)
      LOOP
         IF (purge_rollback IS NOT NULL)
         THEN
            DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
         END IF;

         DELETE FROM camp_comm_in_det
               WHERE camp_id = purge_camp_id AND ROWNUM <= purge_block_rows;

         COMMIT;
         var_count := var_count - purge_block_rows;

         IF (var_count < 0)
         THEN
            var_count := 0;
         END IF;
      END LOOP;

      execute_sql ('ALTER TABLE CAMP_COMM_IN_DET LOGGING');
   END IF;
   
     -- Clearing entries associated with given campaign from WIRELESS_RES
         SELECT COUNT (*)
           INTO var_count
           FROM WIRELESS_RES
          WHERE camp_id = purge_camp_id;
      
         IF (var_count > 0)
         THEN
            execute_sql ('ALTER TABLE WIRELESS_RES NOLOGGING');
      
            WHILE (var_count > 0)
            LOOP
               IF (purge_rollback IS NOT NULL)
               THEN
                  DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
               END IF;
      
               DELETE FROM WIRELESS_RES
               WHERE camp_id = purge_camp_id AND ROWNUM <= purge_block_rows;
      
               COMMIT;
               var_count := var_count - purge_block_rows;
      
               IF (var_count < 0)
               THEN
                  var_count := 0;
               END IF;
            END LOOP;
      
            execute_sql ('ALTER TABLE WIRELESS_RES LOGGING');
         END IF;
   
    -- Clearing entries associated with given campaign from EMAIL_RES
         SELECT COUNT (*)
           INTO var_count
           FROM EMAIL_RES
          WHERE camp_id = purge_camp_id;
      
         IF (var_count > 0)
         THEN
            execute_sql ('ALTER TABLE EMAIL_RES NOLOGGING');
      
            WHILE (var_count > 0)
            LOOP
               IF (purge_rollback IS NOT NULL)
               THEN
                  DBMS_TRANSACTION.use_rollback_segment (purge_rollback);
               END IF;
      
               DELETE FROM EMAIL_RES
                WHERE camp_id = purge_camp_id 
		 AND ROWNUM <= purge_block_rows;
      
               COMMIT;
               var_count := var_count - purge_block_rows;
      
               IF (var_count < 0)
               THEN
                  var_count := 0;
               END IF;
            END LOOP;
      
            execute_sql ('ALTER TABLE EMAIL_RES LOGGING');
      END IF;

   -- Drop associated dynamic tables and remove relevant entries from VANTAGE_DYN_TAB

   -- remove associated 'SFI<camp_id>' tables
   FOR c1rec IN c1
   LOOP
      var_table_name := c1rec.db_ent_name;

      SELECT COUNT (*)
        INTO var_count
        FROM user_tables
       WHERE table_name = var_table_name;

      IF (var_count > 0)
      THEN
         execute_sql ('DROP TABLE ' || var_table_name);
      END IF;

      DELETE FROM vantage_dyn_tab
            WHERE db_ent_name = var_table_name;
   END LOOP;

   COMMIT;

   -- remove associated 'SFO<camp_id>' tables
   FOR c2rec IN c2
   LOOP
      var_table_name := c2rec.db_ent_name;

      SELECT COUNT (*)
        INTO var_count
        FROM user_tables
       WHERE table_name = var_table_name;

      IF (var_count > 0)
      THEN
         execute_sql ('DROP TABLE ' || var_table_name);
      END IF;

      DELETE FROM vantage_dyn_tab
       WHERE db_ent_name = var_table_name;
   END LOOP;

   COMMIT;

   -- remove associated 'CS<seg_id>_<camp_id>_<det_id>' tables
   FOR c3rec IN c3
   LOOP
      IF (c3rec.obj_type_id = 4)
      THEN
         -- remove associated 'CS<tree_id>_<tree_seq>_<camp_id>_<det_id>' tables
         SELECT COUNT (*)
           INTO var_count
           FROM vantage_dyn_tab
          WHERE db_ent_name LIKE
                      'CS'
                   || c3rec.obj_id
                   || '\_'
                   || c3rec.obj_sub_id
                   || '\_'
                   || c3rec.camp_id
                   || '\_'
                   || c3rec.det_id
                   || '%' ESCAPE '\';

         IF (var_count > 0)
         THEN
            FOR var_num IN 1 .. var_count
            LOOP
               SELECT db_ent_name
                 INTO var_table_name
                 FROM vantage_dyn_tab
                WHERE db_ent_name LIKE
                            'CS'
                         || c3rec.obj_id
                         || '\_'
                         || c3rec.obj_sub_id
                         || '\_'
                         || c3rec.camp_id
                         || '\_'
                         || c3rec.det_id
                         || '%' ESCAPE '\';

               SELECT COUNT (*)
                 INTO var_count2
                 FROM user_tables
                WHERE table_name = var_table_name;

               IF (var_count2 > 0)
               THEN
                  execute_sql ('DROP TABLE ' || var_table_name);
               END IF;

               DELETE FROM vantage_dyn_tab
                     WHERE db_ent_name = var_table_name;

               COMMIT;
            END LOOP;
         END IF;
      ELSE
         -- remove associated 'CS<seg_id>_<camp_id>_<det_id>' tables
         IF (c3rec.obj_type_id = 1)
         THEN
            SELECT COUNT (*)
              INTO var_count
              FROM vantage_dyn_tab
             WHERE db_ent_name LIKE
                         'CS'
                      || c3rec.obj_id
                      || '\_'
                      || c3rec.camp_id
                      || '\_'
                      || c3rec.det_id
                      || '%' ESCAPE '\';

            IF (var_count > 0)
            THEN
               FOR var_num IN 1 .. var_count
               LOOP
                  SELECT db_ent_name
                    INTO var_table_name
                    FROM vantage_dyn_tab
                   WHERE db_ent_name LIKE
                               'CS'
                            || c3rec.obj_id
                            || '\_'
                            || c3rec.camp_id
                            || '\_'
                            || c3rec.det_id
                            || '%' ESCAPE '\'
                     AND ROWNUM = 1;

                  SELECT COUNT (*)
                    INTO var_count2
                    FROM user_tables
                   WHERE table_name = var_table_name;

                  IF (var_count2 > 0)
                  THEN
                     execute_sql ('DROP TABLE ' || var_table_name);
                  END IF;

                  DELETE FROM vantage_dyn_tab
                   WHERE db_ent_name = var_table_name;

                  COMMIT;
               END LOOP;
            END IF;
         END IF;
      END IF;
   END LOOP;

   -- For each directly referenced object that is a Segment or Base Segment DO
   purge_ref_segments (24, purge_camp_id, purge_months,0); --Passing 0 means ,Actual Purging will happen for the Referenced Segments
-- Note that Segmentation Trees will be processed independently.
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_campaign;
/


-- **************************************************************************************

CREATE OR REPLACE PROCEDURE mdpurge_obsolete_campaigns (
   purge_months       NUMBER,
   exec_type	      CHAR,   
   purge_block_rows   NUMBER, 
   purge_rollback     VARCHAR2 
)
IS
   var_camp_id   NUMBER (8)     := 0;
   var_count     NUMBER         := 0;
   dry_run_flag  SMALLINT;
   err_num       NUMBER;
   err_msg       VARCHAR2 (100);

   CURSOR c9
   IS
      SELECT camp_id FROM campaign;
BEGIN
   -- Exec_type parameter allows a choice on the execution of the Purge procedures.
   -- The exec_type "LIST" only lists the obsolete components that are going to be purged, 
   -- while "PURGE" actually purges the obsolete components.
   -- The dry_run_flag is an internal boolean variable used to capture exec_type input.  

   IF ((TRIM(UPPER(exec_type))) = 'PURGE')
   THEN
       dry_run_flag := 0;                   -- Dry_Run_Flag=FALSE,Actual Purging will happen.
   ELSIF((TRIM(UPPER(exec_type))) = 'LIST')
   THEN
       dry_run_flag := 1;                   -- Dry_Run_Flag=TRUE,Only Listing will happen
   ELSE
       DBMS_OUTPUT.put_line ('      Valid Execution types are ''PURGE'' or ''LIST''');
       RETURN;
   END IF;

   FOR c9rec IN c9
   LOOP
      var_camp_id := c9rec.camp_id;

      -- check if Campaign has been purged already, or has 'Completed' or 'Cancelled' Status
      SELECT COUNT (*)
      INTO var_count
      FROM campaign
      WHERE camp_id = var_camp_id AND camp_name LIKE 'PURGED%';

      IF (var_count = 0)
      THEN 
         SELECT COUNT (*)
           INTO var_count
           FROM camp_status_hist x
          WHERE status_setting_id IN (16, 12)
            AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                                   FROM camp_status_hist
                                  WHERE camp_id = x.camp_id)
         AND camp_id = var_camp_id
         AND months_between (SYSDATE, created_date) > purge_months;

         IF (var_count > 0)
         THEN
            -- If Campaign is Obsolete, i.e. not referenced by another live object
            IF (is_object_obsolete (24, var_camp_id, purge_months) > 0)
            THEN                                         
               IF (dry_run_flag = 0)   -- 0 Means actual purging happens for the campaigns.
               THEN 
                  -- Purge Campaign
                  DBMS_OUTPUT.put_line ('Purged Campaign:' || var_camp_id);
                  purge_campaign (var_camp_id,
                                  purge_months,
                                  purge_rollback,
                                  purge_block_rows
                                 );
               ELSIF (dry_run_flag = 1) 
               THEN 
                  DBMS_OUTPUT.put_line ('Purging Campaign: ' || var_camp_id);
		  purge_ref_segments (24,var_camp_id,purge_months,1); -- call purge_ref_segments to only List out the directly referenced Segs/Base Segs.               		  
               END IF;
            END IF;
         END IF;
      END IF;
   END LOOP;

   -- to remove all the stray 'CS<seg_id>_<camp_id>_0_<camp_cycle>' tables   
   -- Purge cstable procedure call based on exec_type ( i.e. PURGE or LIST )
   -- purge_cstables(exec_type); -- Commented because purging CS tables handled seperately
  
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END mdpurge_obsolete_campaigns;
/


-- **************************************************************************************
-- **************************************************************************************

-- Purge Segmentation Tree

CREATE OR REPLACE PROCEDURE purge_segtree (
   purge_tree_id   NUMBER,
   purge_months    NUMBER,
   dry_run_flag    SMALLINT
)
IS
   var_table_name    VARCHAR2 (50)  := NULL;
   var_count         NUMBER         := 0;
   var_count2        NUMBER         := 0;
   var_obj_type_id   NUMBER (2)     := 0;
   var_obj_id        NUMBER (8)     := 0;
   var_tree_grp_id   NUMBER(8)      := 0;
   var_rowid         ROWID;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);

   CURSOR c20
   IS
      SELECT seg_type_id, seg_id
        FROM tree_base
       WHERE tree_id = purge_tree_id
         AND seg_type_id IS NOT NULL
         AND seg_id IS NOT NULL
         AND seg_type_id <> 0
         AND seg_id <> 0;

   CURSOR c21
   IS
      SELECT seg_type_id, seg_id
        FROM tree_det
       WHERE tree_id = purge_tree_id
         AND seg_type_id IS NOT NULL
         AND seg_id IS NOT NULL
         AND seg_type_id <> 0
         AND seg_id <> 0;

   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT COUNT (*)
     INTO var_count
     FROM tree_hdr
    WHERE tree_id = purge_tree_id AND last_run_dur = -1;

   IF (var_count = 0)
   THEN
      -- process Segmentation Tree Base records
      FOR c20rec IN c20
      LOOP
         -- Get associated Tree Segment dynamic table name from SEG_HDR
         -- Checking it has not been dropped already (there can be duplicated references in tree_base and tree_det)
         SELECT COUNT (*)
           INTO var_count
           FROM seg_hdr
          WHERE seg_type_id = c20rec.seg_type_id AND seg_id = c20rec.seg_id;

         IF (var_count > 0)
         THEN
            SELECT dyn_tab_name
              INTO var_table_name
              FROM seg_hdr
             WHERE seg_type_id = c20rec.seg_type_id AND seg_id = c20rec.seg_id;

            -- Drop associated dynamic table;
            SELECT COUNT (*)
              INTO var_count2
              FROM user_tables
             WHERE table_name = var_table_name;

            IF (var_count2 > 0)
            THEN
               execute_sql ('DROP TABLE ' || var_table_name);
            END IF;

            -- Remove associated entry from VANTAGE_DYN_TAB
            DELETE FROM vantage_dyn_tab
                  WHERE db_ent_name = var_table_name;

            -- Delete associated Tree Segment record from SEG_HDR,
            --     SEG_DEDUPE_PRIO, STORED_FLD_TEMPL, SEG_SQL tables
            SELECT COUNT (*)
              INTO var_count2
              FROM seg_sql
             WHERE seg_type_id = c20rec.seg_type_id AND seg_id = c20rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM seg_sql
                     WHERE seg_type_id = c20rec.seg_type_id
                       AND seg_id = c20rec.seg_id;
            END IF;

            SELECT COUNT (*)
              INTO var_count2
              FROM stored_fld_templ
             WHERE seg_type_id = c20rec.seg_type_id AND seg_id = c20rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM stored_fld_templ
                     WHERE seg_type_id = c20rec.seg_type_id
                       AND seg_id = c20rec.seg_id;
            END IF;

              SELECT COUNT (*)
                INTO var_count2
                FROM seg_dedupe_prio
               WHERE seg_type_id = c20rec.seg_type_id AND seg_id = c20rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM seg_dedupe_prio
                     WHERE seg_type_id = c20rec.seg_type_id
                       AND seg_id = c20rec.seg_id;
            END IF;

            DELETE FROM seg_hdr
                  WHERE seg_type_id = c20rec.seg_type_id
                    AND seg_id = c20rec.seg_id;

            COMMIT;
         END IF;
      END LOOP;

      -- Update TREE_BASE remove SEG_TYPE_ID and SEG_ID details;
      UPDATE tree_base
         SET seg_type_id = NULL,
             seg_id = NULL
       WHERE tree_id = purge_tree_id;

      COMMIT;

      -- Process Segmentation Tree Detail records
      FOR c21rec IN c21
      LOOP
         -- Get associated Tree Segment dynamic table name from SEG_HDR
         -- checking first if it has not been dropped already
         -- (duplicate references can exist in tree_base and tree_det
         SELECT COUNT (*)
           INTO var_count
           FROM seg_hdr
          WHERE seg_type_id = c21rec.seg_type_id AND seg_id = c21rec.seg_id;

         IF (var_count > 0)
         THEN
            SELECT dyn_tab_name
              INTO var_table_name
              FROM seg_hdr
             WHERE seg_type_id = c21rec.seg_type_id AND seg_id = c21rec.seg_id;

            -- Drop associated dynamic table;
            SELECT COUNT (*)
              INTO var_count2
              FROM user_tables
             WHERE table_name = var_table_name;

            IF (var_count2 > 0)
            THEN
               execute_sql ('DROP TABLE ' || var_table_name);
            END IF;

            -- Remove associated entry from VANTAGE_DYN_TAB
            DELETE FROM vantage_dyn_tab
                  WHERE db_ent_name = var_table_name;

            -- Delete associated Tree Segment record from SEG_HDR,
            --     SEG_DEDUPE_PRIO, STORED_FLD_TEMPL, SEG_SQL tables
            SELECT COUNT (*)
              INTO var_count2
              FROM seg_sql
             WHERE seg_type_id = c21rec.seg_type_id AND seg_id = c21rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM seg_sql
                     WHERE seg_type_id = c21rec.seg_type_id
                       AND seg_id = c21rec.seg_id;
            END IF;

            SELECT COUNT (*)
              INTO var_count2
              FROM stored_fld_templ
             WHERE seg_type_id = c21rec.seg_type_id AND seg_id = c21rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM stored_fld_templ
                     WHERE seg_type_id = c21rec.seg_type_id
                       AND seg_id = c21rec.seg_id;
            END IF;

            SELECT COUNT (*)
              INTO var_count2
              FROM seg_dedupe_prio
             WHERE seg_type_id = c21rec.seg_type_id AND seg_id = c21rec.seg_id;

            IF (var_count2 > 0)
            THEN
               DELETE FROM seg_dedupe_prio
                     WHERE seg_type_id = c21rec.seg_type_id
                       AND seg_id = c21rec.seg_id;
            END IF;

            DELETE FROM seg_hdr
                  WHERE seg_type_id = c21rec.seg_type_id
                    AND seg_id = c21rec.seg_id;

            COMMIT;
         END IF;
      END LOOP;

      -- Check all referenced segments and archive if obsolete
      purge_ref_segments (4, purge_tree_id, purge_months,dry_run_flag);
	------------------------------------------------------------
	--FOLLOWING CODE FOR MOVING PURGED SEG TREES TO PURGED FOLDERS
	------------------------------------------------------------
	SELECT COUNT(*)
	  INTO var_count  FROM tree_grp
	 WHERE  tree_grp_name like   'PURGED%';

    	IF (  var_count =  0 ) 
 		THEN
           		SELECT MAX(tree_grp_id) + 1
           	          INTO var_tree_grp_id  FROM     tree_grp ;
			
             INSERT INTO  TREE_GRP (TREE_GRP_ID,TREE_GRP_NAME,TREE_GRP_DESC)
             VALUES( var_tree_grp_id,'PURGED Trees','Group Of Purged Segmentation Trees');
			commit;
       ELSE

             SELECT  tree_grp_id
               INTO var_tree_grp_id  FROM tree_grp
              WHERE  tree_grp_name  like   'PURGED%';
		
       END IF ;
commit;
    ------------------------------------------------------------
    -- END OF CODE FOR MOVING PURGED SEG TREES TO PURGED FOLDERS
    ------------------------------------------------------------

      -- Update TREE_DET remove SEG_TYPE_ID and SEG_ID details;
      UPDATE  TREE_DET   
         SET seg_type_id = null,
             NET_QTY = -1,
             GROSS_QTY=-1,
             seg_id = null 
       WHERE  tree_id  = purge_tree_id ;
      COMMIT;

      -- Update respective TREE_HDR record, set Last run details to null
      UPDATE tree_hdr
         SET 
	     TREE_NAME = 'PURGED ' || SUBSTR(tree_name, 1, 93),
	     last_run_by   = NULL,
             last_run_date = NULL,
             last_run_time = NULL,
             last_run_dur  = -1,
  	     tree_grp_id   = var_tree_grp_id  ,
             updated_by    = USER,
             updated_date  = SYSDATE
       WHERE tree_id = purge_tree_id;

      COMMIT;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      UPDATE referenced_obj
         SET ref_type_id = ABS (ref_type_id)
       WHERE ref_type_id < 0;

      UPDATE referenced_obj
         SET ref_id = ABS (ref_id)
       WHERE ref_id < 0;

      UPDATE referenced_obj
         SET obj_id = ABS (obj_id)
       WHERE obj_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_segtree;
/



-- ****************************************************************************************
-- Purging Segmentation Trees

CREATE OR REPLACE PROCEDURE mdpurge_obsolete_segtrees (purge_months NUMBER,exec_type CHAR)
IS
   var_tree_id   NUMBER (8)     := 0;
   var_count     NUMBER         := 0;   
   dry_run_flag  SMALLINT;
   err_num       NUMBER;
   err_msg       VARCHAR2 (100);

   CURSOR c30
   IS
      SELECT tree_id, last_run_date
        FROM tree_hdr where tree_name not like 'PURGED%';
BEGIN
   -- Exec_type parameter allows a choice on the execution of the Purge procedures.
   -- The exec_type "LIST" only lists the obsolete components that are going to be purged, 
   -- while "PURGE" actually purges the obsolete components.
   -- The dry_run_flag is an internal boolean variable used to capture exec_type input.  
   IF ((TRIM(UPPER(exec_type))) = 'PURGE')
   THEN
       dry_run_flag := 0;                   -- Dry_Run_Flag=FALSE,Actual Purging will happen.
   ELSIF((TRIM(UPPER(exec_type))) = 'LIST')
   THEN
       dry_run_flag := 1;                   -- Dry_Run_Flag=TRUE,Only Listing will happen
   ELSE
       DBMS_OUTPUT.put_line ('      Valid Execution types are ''PURGE'' or ''LIST''');
       RETURN;
   END IF;

	
   -- Process all Segmentation Trees
   FOR c30rec IN c30
   LOOP
      var_tree_id := c30rec.tree_id;

      -- Check if Segmentation Tree is Obsolete
      IF (    c30rec.last_run_date IS NOT NULL
          	AND MONTHS_BETWEEN (SYSDATE, c30rec.last_run_date) > purge_months
         		)
      THEN
         IF (is_object_obsolete (4, var_tree_id, purge_months) > 0)
         THEN       
            IF (dry_run_flag = 0)
            THEN
               DBMS_OUTPUT.put_line ('Purged Segmentation Tree: ' || var_tree_id);
               purge_segtree (var_tree_id, purge_months,0);         -- Calling Purge_segtree , passing 0 to do actual purging.	
            ELSIF (dry_run_flag = 1) 
            THEN 
               DBMS_OUTPUT.put_line ('Purging Segmentation Tree: ' || var_tree_id);
               purge_ref_segments (4, var_tree_id, purge_months,1); -- Calling Purge_ref_segments,passing 1 to list out Segs/Base Segs.
            END IF;
         END IF;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END mdpurge_obsolete_segtrees;
/

--****************************************************************************************
--Reference check for Purging obsolete segments

CREATE OR REPLACE PROCEDURE purge_segments_check (
    var_seg_type_id   NUMBER,
    var_seg_id        NUMBER, 
    purge_months      FLOAT
)
IS
    var_count         NUMBER         := 0;    
    err_num           NUMBER;
    err_msg           VARCHAR2 (100);    
 BEGIN 	
    SELECT COUNT (*) INTO var_count 
      FROM seg_hdr 
     WHERE seg_type_id = var_seg_type_id
       AND seg_id = var_seg_id 
       AND MONTHS_BETWEEN (SYSDATE, last_run_date) > purge_months;
    
    
    IF (var_count > 0)
    THEN  	
    	IF (is_object_obsolete (var_seg_type_id, var_seg_id, purge_months) > 0)
        THEN            
                IF ( var_seg_type_id = 2 )
                THEN
                    DBMS_OUTPUT.put_line ('   Purging Non referenced Base Segment: '|| var_seg_id );
                ELSE
                    DBMS_OUTPUT.put_line ('   Purging Non referenced Segment: '|| var_seg_id );
                END IF;
	END IF;	
    END IF;
END  purge_segments_check;
/
--**************************************************************************************


--**************************************************************************************
--Purge Obselete Segments 

CREATE OR REPLACE PROCEDURE  mdpurge_obsolete_segments(purge_months Float, exec_type char)
IS
    dry_run_flag    	SMALLINT;
    var_ref_type_id 	INTEGER;
    var_ref_id          INTEGER;
    var_seg_type_id     NUMBER (2)  := 0;
    var_seg_id          NUMBER (8)  := 0;
    tmp_seg_id          NUMBER (8)  := 0;
    tmp_seg_type_id     NUMBER (2)  := 0;
   	
    CURSOR c10
    IS
        SELECT DISTINCT ref_type_id,ref_id 
          FROM referenced_obj 
         WHERE obj_type_id in (1,2);                    

    CURSOR c11  
    IS
    	SELECT  DISTINCT SEG_TYPE_ID, SEG_ID 
	  FROM SEG_HDR 
	 WHERE (SEG_ID, SEG_TYPE_ID) NOT IN (	SELECT DISTINCT OBJ_ID, OBJ_TYPE_ID 
						  FROM REFERENCED_OBJ 
	        				 WHERE OBJ_TYPE_ID IN (1,2)
	        		  	   )
	AND SEG_NAME NOT LIKE 'PURGED%'        		  	   
        AND MONTHS_BETWEEN (SYSDATE, LAST_RUN_DATE) > PURGE_MONTHS;        
        
BEGIN
   IF ((TRIM(UPPER(exec_type))) = 'PURGE')
   THEN
       dry_run_flag := 0;                   -- Dry_Run_Flag=FALSE,Actual Purging will happen.
   ELSIF((TRIM(UPPER(exec_type))) = 'LIST')
   THEN
       dry_run_flag := 1;                   -- Dry_Run_Flag=TRUE,Only Listing will happen
   ELSE
       DBMS_OUTPUT.put_line ('      Valid Execution types are ''PURGE'' or ''LIST''');
       RETURN;
   END IF;
 
   FOR  c10rec IN c10 
       LOOP
           var_ref_type_id := c10rec.ref_type_id;
           var_ref_id      := c10rec.ref_id;
 
           purge_ref_segments(var_ref_type_id,var_ref_id,purge_months,dry_run_flag);
       END LOOP;

       tmp_seg_id := 0; 
               
    FOR c11rec IN c11
       LOOP
           var_seg_type_id := c11rec.seg_type_id;
           var_seg_id      := c11rec.seg_id;
                
                        
           IF (dry_run_flag = 0)
           THEN
           	IF var_seg_type_id=2 
		THEN
			DBMS_OUTPUT.put_line ('   Purged referenced Base Segment: '|| var_seg_id);
		ELSE
			DBMS_OUTPUT.put_line ('   Purged referenced Segment: '|| var_seg_id);
            	END IF;
           	
                purge_segment(var_seg_type_id,var_seg_id);
                
           ELSIF (dry_run_flag = 1)
           THEN           		
         	purge_segments_check (var_seg_type_id, var_seg_id, purge_months);           
           END IF;
           
       END LOOP;
END  mdpurge_obsolete_segments;
/

-- *********************************************************************************
--
-- Function: is_object_obsolete_check_byid()
-- 
-- Recursively checks if the Segment, Campaign or Segmentation Tree is 
-- actually Obsolete, i.e. not referenced by any another 'live' object 
--
-- *********************************************************************************

CREATE OR REPLACE FUNCTION is_object_obsolete_check_byid (
   purge_obj_type_id   NUMBER,
   purge_obj_id        NUMBER,
   campaign_id	       NUMBER,	
   given_cycles        NUMBER,   
   dry_run_flag        SMALLINT
)
   RETURN NUMBER
IS
   var_true          NUMBER (1)     := 0;
   var_obj_id        NUMBER (8)     := 0;
   var_ref_id        NUMBER (8)     := 0;
   var_obj_type_id   NUMBER (2)     := 0;
   var_ref_type_id   NUMBER (2)     := 0;
   camp_status       NUMBER (2)     := 0;
   cycle_id          NUMBER         := 0;
   max_cycle_id      NUMBER         := 0;
   cur_version_id    NUMBER   	    := 0;
   var_version_id    NUMBER   	    := 0;
   var_rowid         ROWID          := NULL;
   deadlock_flag     NUMBER         := 1;
   err_num           NUMBER;
   var_counter       NUMBER         :=0;
   var_status        NUMBER;    
   err_msg           VARCHAR2 (100);

   CURSOR c10                                           -- Get the version ID of given campaign
   IS
        SELECT version_id
          FROM CAMP_VERSION
         WHERE camp_id = campaign_id
         ORDER BY version_id;

   CURSOR c20
   IS
      SELECT ref_type_id, ref_id, obj_type_id, obj_id, ROWID
        FROM referenced_obj
       WHERE obj_id > 0
         AND obj_type_id = purge_obj_type_id
         AND obj_id = purge_obj_id;

   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   var_true := 1;                                        -- Indicates Object is obsolete

   OPEN c20;
   LOOP
      FETCH c20
      INTO var_ref_type_id, var_ref_id, var_obj_type_id, var_obj_id, var_rowid;

      EXIT WHEN c20%NOTFOUND;
      IF (var_ref_type_id IN (1, 2))
      THEN                                                -- Segment or Base Segment
         SELECT COUNT (*)
           INTO var_true
           FROM seg_hdr
          WHERE seg_type_id = var_ref_type_id
            AND seg_id = var_ref_id
            AND (   
	        (last_run_date IS NULL ) AND (last_run_qty = -1)
                );
      ELSIF (var_ref_type_id = 24)
      THEN                                                -- Check is Version Campaign obsolete
         IF ( var_ref_id = campaign_id ) 
	 THEN 
	     SELECT status_setting_id
      	       INTO camp_status 
               FROM camp_status_hist x
              WHERE status_setting_id IN ( 10, 12,16 )
                AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                                       FROM camp_status_hist
                                      WHERE camp_id = x.camp_id)
                AND camp_id = campaign_id;
 		
	     -- Get current version id for a given campaign
             SELECT current_version_id
               INTO cur_version_id
               FROM CAMPAIGN
              WHERE camp_id = campaign_id;	
             -- Get the maximum cycles of a given  campaign
             SELECT MAX(camp_cyc) 
               INTO max_cycle_id  
               FROM CAMP_COMM_OUT_HDR
              WHERE camp_id = campaign_id;               
         END IF;

         IF ( (var_ref_id = campaign_id) AND (cur_version_id > 1))  
	 THEN 
	    IF ((camp_status = 12) OR (camp_status=16) OR (camp_status=10))
            THEN
                OPEN c10;
                LOOP
                   FETCH c10
                    INTO var_version_id;
                    EXIT WHEN c10%NOTFOUND;

                    SELECT MAX(camp_cyc)
                      INTO cycle_id
                      FROM CAMP_CYC_STATUS
                     WHERE camp_id = campaign_id
                       AND version_id = var_version_id;

		    IF (
			((given_cycles >= cycle_id) AND (cur_version_id <> var_version_id)) OR 
			(((camp_status = 12) AND (given_cycles >= cycle_id)) OR (camp_status = 16))
		       ) 
		    THEN
		        SELECT COUNT(*) 
			  INTO var_counter  
			  FROM dual 
			 WHERE EXISTS 
			(
				(SELECT OBJ_ID , OBJ_TYPE_ID 
				   FROM CAMP_DET 
				  WHERE CAMP_ID=campaign_id
				    AND VERSION_ID <= var_version_id 
				    AND OBJ_ID=var_obj_id 
				    AND OBJ_TYPE_ID = var_obj_type_id 
				) 
				UNION 
				(SELECT SEG_ID  ,SEG_TYPE_ID   
				   FROM  EV_CAMP_DET 
				  WHERE CAMP_ID=campaign_id 
				    AND SEG_ID=var_obj_id 
				    AND SEG_TYPE_ID= var_obj_type_id 
				)
			) 
			AND NOT EXISTS
			(
			        (SELECT OBJ_ID , OBJ_TYPE_ID
			 	   FROM CAMP_DET 
			 	  WHERE CAMP_ID=campaign_id 
			 	    AND VERSION_ID > var_version_id 
			 	    AND OBJ_Id=var_obj_id  
			 	    AND OBJ_TYPE_ID=var_obj_type_id 
			 	) 
			 	UNION 
			 	(SELECT  SEG_ID   ,SEG_TYPE_ID 
			 	   FROM  EV_CAMP_DET 
			 	  WHERE  CAMP_ID=campaign_id 
			 	    AND  SEG_ID=var_obj_id 
			 	    AND SEG_TYPE_ID=var_obj_type_id 
			 	    AND (((camp_status <> 12) OR (given_cycles < max_cycle_id )) AND (camp_status <> 16)) 
			        )
	                ); 
	             	  	                   
	                IF(var_counter <> 0) 
	                THEN
		            var_true:=1;
			    EXIT;
			ELSE 
		            var_true:=0;
	                END IF;
		    ELSE
                         var_true:=0;
                    END IF;
                END LOOP;
                CLOSE c10;
	    ELSE
                var_true:=0;
            END IF;
        ELSIF (( dry_run_flag =1) AND (campaign_id = var_ref_id ))   
	THEN
	    SELECT status_setting_id INTO var_status
	      FROM camp_status_hist x
	     WHERE camp_hist_seq = (SELECT MAX (camp_hist_seq) FROM camp_status_hist WHERE camp_id = x.camp_id)
	       AND camp_id = var_ref_id ;

	    IF((var_status = 12) OR ( var_status =10) OR ( var_status =16))  
	    THEN
	        var_true:=1 ;
	    ELSE 
	        var_true:=0 ;
	    END IF;
        ELSE						-- Check is given Campaign 'PURGED'
           SELECT COUNT (*)
             INTO var_true
             FROM campaign
            WHERE camp_id = var_ref_id 
	      AND camp_name LIKE 'PURGED%';
        END IF;
      ELSIF (var_ref_type_id = 4)
      THEN                                                -- Check is Segmentation Tree Obsolete
         SELECT COUNT (*)
           INTO var_true
           FROM tree_hdr
          WHERE tree_id = var_obj_id
            AND (   
		(last_run_date IS NOT NULL ) OR (last_run_date IS NULL AND last_run_dur = -1)
                );
      ELSE
         var_true := 0;					 --  Set given Object as not Obsolete
      END IF;

      UPDATE referenced_obj
         SET obj_id = -obj_id
       WHERE ROWID = var_rowid;

      COMMIT;
      IF (var_true > 0)
      THEN						-- check for parent object is Obsolete
         var_true :=						
            is_object_obsolete_check_byid (var_ref_type_id,	
                                      var_ref_id, 
				      campaign_id,	
                                      given_cycles, 
			  	      dry_run_flag		
                                     );
      END IF;

      IF (var_true = 0)
      THEN
         EXIT;
      END IF;
   END LOOP;

   CLOSE c20;

   RETURN var_true;
EXCEPTION
   WHEN OTHERS
   THEN
      CLOSE c20;

      var_true := 0;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
      RETURN var_true;
END is_object_obsolete_check_byid;
/

-- ************************************************************************************
--
-- Function: is_object_obsolete_byid() 
--
-- Control the check of whether the Segment, Base Segment, Campaign or Segmentation 
-- Tree is Obsolete and update the REFERENCED_OBJ table accordingly. 
--
-- This function calls function is_object_obsolete_check_byid () to perform the actual check.
--
-- ************************************************************************************

CREATE OR REPLACE FUNCTION is_object_obsolete_byid (
   purge_obj_type_id   NUMBER,
   purge_obj_id        NUMBER, 
   campaign_id	       NUMBER,
   given_cycles        NUMBER, 
   dry_run_flag	       SMALLINT	
)
   RETURN NUMBER
IS
   var_true   NUMBER (1)     := 0;
   err_num    NUMBER;
   err_msg    VARCHAR2 (100);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   var_true := 
      is_object_obsolete_check_byid (purge_obj_type_id, purge_obj_id, campaign_id, given_cycles, dry_run_flag);
      
   UPDATE referenced_obj
   SET obj_id = ABS (obj_id)
   WHERE obj_id < 0;

   COMMIT;
   RETURN var_true;
EXCEPTION
   WHEN OTHERS
   THEN
      var_true := 0;

      UPDATE referenced_obj
      SET obj_id = ABS (obj_id)
      WHERE obj_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
      RETURN var_true;
END is_object_obsolete_byid;
/


-- ***************************************************************************************
--
-- Procedure: purge_ref_segments_check_byid()
--
-- Recursively check whether the Segment refers to other Segments or 
-- Base-segments until the leaf level is reached. Purging will be started from the 
-- leaf level provided that the object is obsolete and not referenced by any other live 
-- object.
--
-- Calls function is_obsolete_obsolete_byid() to check whether the object is obsolete and
-- function purge_ref_segments_check_byid() to determine all references. Calls function 
-- purge_segment() if required to actually purge the segment. The table REFERENCED_OBJ 
-- is updated accordingly.
--
-- ***************************************************************************************

CREATE OR REPLACE PROCEDURE purge_ref_segments_check_byid (
   var_ref_type_id   NUMBER,
   var_ref_id        NUMBER,
   dry_run_flag      SMALLINT,
   purge_cycle       NUMBER
)
IS
   var_count         NUMBER         := 0;
   var_cycle_count   NUMBER         := 0;
   var_seg_type_id   NUMBER (2)     := 0;
   var_seg_id        NUMBER (8)     := 0;
   cur_version_id    NUMBER   	    := 0;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);

   CURSOR c10
   IS
   SELECT c.obj_type_id, c.obj_id 
     FROM camp_det c 
    WHERE c.camp_id = var_ref_id
      AND c.obj_type_id IN (1, 2);

   PRAGMA AUTONOMOUS_TRANSACTION;
   
BEGIN
   OPEN c10;
   LOOP
      FETCH c10
           INTO var_seg_type_id, var_seg_id;
      EXIT WHEN c10%NOTFOUND;

      -- If Object is Segment AND Object is Obsolete then Purge Segment
      SELECT COUNT (*)
        INTO var_count
        FROM seg_hdr
       WHERE seg_type_id = var_seg_type_id
         AND seg_id = var_seg_id
         AND seg_name NOT LIKE 'PURGED%';

      IF (var_count > 0)
      THEN
	 -- Check refered object is Obsolete and display the purgeable or purged Segment of given Campaign
         IF (is_object_obsolete_byid (var_seg_type_id, var_seg_id, var_ref_id, purge_cycle, dry_run_flag) > 0)
         THEN
             IF (dry_run_flag = 1)  
             THEN					       -- List the referred segment if Obsolete	
               	DBMS_OUTPUT.put_line
                	        (' 	Purging referenced Segments ['
                                || var_seg_id
                                || ']'
                                );
             ELSIF (dry_run_flag = 0)
             THEN
                purge_segment (var_seg_type_id, var_seg_id);   -- Purge the referred segment if Obsolete 

                DBMS_OUTPUT.put_line
                	        (' 	Purged referenced Segments ['
	                            || var_seg_id
	                            || ']'
                       		   );

               	UPDATE referenced_obj
               	SET obj_type_id = -obj_type_id
               	WHERE ref_type_id = var_ref_type_id
               	AND ref_id = var_ref_id
               	AND obj_type_id = var_seg_type_id
               	AND obj_id = var_seg_id;
               
               	COMMIT;
             END IF;   
         END IF;
      END IF;
   END LOOP;

   CLOSE c10;

   UPDATE referenced_obj
   SET obj_type_id = ABS (obj_type_id)
   WHERE obj_type_id < 0;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      CLOSE c10;

      UPDATE referenced_obj
         SET obj_type_id = ABS (obj_type_id)
       WHERE obj_type_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_ref_segments_check_byid;
/


-- *****************************************************************************************
-- 
-- Procedure: purge_ref_segments_byid()
--
-- Control the purging of all referenced segments.
--
-- Calls function purge_ref_segments_check() to retrive all refernced segments and update
-- the table REFERENCED_OBJ accordingly. 
--
-- *****************************************************************************************

CREATE OR REPLACE PROCEDURE purge_ref_segments_byid (
   var_ref_type_id   NUMBER,
   var_ref_id        NUMBER,
   dry_run_flag      SMALLINT,
   purge_cycle       NUMBER
)
IS
   err_num   NUMBER;
   err_msg   VARCHAR2 (100);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 								-- Check references of segment of given campaign

   purge_ref_segments_check_byid (var_ref_type_id,		
                             var_ref_id, 
			     dry_run_flag, 
		             purge_cycle		
                            );

   UPDATE referenced_obj
      SET obj_type_id = ABS (obj_type_id)
    WHERE obj_type_id < 0;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      UPDATE referenced_obj
         SET obj_type_id = ABS (obj_type_id)
       WHERE obj_type_id < 0;

      COMMIT;
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line ('Oracle Error: ' || err_num || ' ' || err_msg);
END purge_ref_segments_byid;
/

-- **************************************************************************************
--
-- Procedure: purge_campaign_cycle()
--
-- Purge given cycles for the given campaign.
--
-- Deletes from tables CAMP_COMM_OUT_HDR, CAMP_COMM_OUT_DET, CAMP_COMM_IN_HDR, 
-- CAMP_COMM_IN_DET and updates CAMP_CYC_STATUS. 
--
-- Deletes all campaign-segments (CS<seg_id>), but will not drop SFO<camp_id> 
-- or SFI<camp_id> tables or update tables CAMPAIGN and CAMP_GRP to 'move' the 
-- given campaign to the 'Purged' group until all cycles of the 
-- campaign have been purged.
--
-- **************************************************************************************

CREATE OR REPLACE PROCEDURE purge_campaign_cycle (
   purge_camp_id      NUMBER,
   purge_cycle        NUMBER,   
   dry_run_flag	      SMALLINT,
   cur_version_id     NUMBER
)
IS
   var_count         NUMBER         := 0;
   var_count1        NUMBER         := 0;
   camp_status       NUMBER         := 0;
   var_count2        NUMBER         := 0;
   var_update        NUMBER         := 0;
   flag              NUMBER         := 0;
   var_strategy_id   NUMBER (4)     := 0;
   var_camp_grp_id   NUMBER (4)     := 0;
   var_obj_type_id   NUMBER (2)     := 0;
   var_obj_id        NUMBER (8)     := 0;
   var_table_name    VARCHAR2 (40)  := NULL;
   var_version_id    NUMBER;
   var_num           NUMBER;
   var_rowid         ROWID;
   deadlock_flag     NUMBER         := 1;
   err_num           NUMBER;
   err_msg           VARCHAR2 (100);
   cycle_id2         NUMBER   	    := 0;

   CURSOR c1
   IS
      SELECT db_ent_name				-- Get campaign associated SFI (dynamic)  table name
        FROM vantage_dyn_tab
       WHERE db_ent_name = 'SFI' || purge_camp_id;

   CURSOR c2
   IS							-- Get campaign associated SFO (dynamic)  table name
      SELECT db_ent_name
        FROM vantage_dyn_tab
       WHERE db_ent_name = 'SFO' || purge_camp_id;

   CURSOR c3						-- Get Campaign related info from camp_det
   IS
      SELECT camp_id, det_id, obj_type_id, obj_id, obj_sub_id
        FROM camp_det
       WHERE camp_id = purge_camp_id;

   CURSOR c10						-- Get version id of given campaign
   IS
      SELECT version_id
        FROM CAMP_VERSION
       WHERE camp_id = purge_camp_id
       ORDER BY version_id;
BEGIN
   -- Check, if Campaign status is within Completed, Cancelled or Suspended state
   SELECT status_setting_id
     INTO camp_status
     FROM camp_status_hist x
    WHERE status_setting_id IN ( 10 , 12 ,16 )
      AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                             FROM camp_status_hist
                            WHERE camp_id = x.camp_id)
      AND camp_id = purge_camp_id;   
	
   SELECT COUNT(*) INTO var_count1 FROM CAMP_COMM_OUT_HDR WHERE CAMP_ID = purge_camp_id;
   IF ( var_count1 >0 )
   THEN 
       -- Get maximum cycles run for a given campaign
       SELECT MAX( camp_cyc ) 				
         INTO cycle_id2 
         FROM CAMP_COMM_OUT_HDR 
        WHERE camp_id= purge_camp_id;
   END IF;

   -- Check, if Purged Campaign Group within the respective Strategy is created, if not create it
   SELECT g.strategy_id
     INTO var_strategy_id
     FROM campaign c, camp_grp g
    WHERE c.camp_id = purge_camp_id AND c.camp_grp_id = g.camp_grp_id;

   SELECT COUNT (*)
     INTO var_count
     FROM camp_grp
    WHERE strategy_id = var_strategy_id AND camp_grp_name LIKE 'PURGED%';

   IF (var_count = 0)
   THEN
      SELECT MAX (camp_grp_id) + 1
        INTO var_camp_grp_id
        FROM camp_grp;

      INSERT INTO camp_grp
      VALUES (var_camp_grp_id, var_strategy_id, 'PURGED Campaigns',
                   'Campaign Group created within this Stragegy for Purged Campaigns',
                   USER, SYSDATE, NULL, NULL);

      COMMIT;
   ELSE
      SELECT camp_grp_id
        INTO var_camp_grp_id
        FROM camp_grp
       WHERE strategy_id = var_strategy_id 
         AND camp_grp_name LIKE 'PURGED%';
   END IF;

   -- Remove all associated records from the communication tables
   -- Note: Allow allocation of special Rollback Segment
   -- Set to NO LOGGING prior to running the block deletes

   -- Clearing entries associated with given campaign from CAMP_COMM_OUT_HDR
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_out_hdr
    WHERE camp_id = purge_camp_id
      AND camp_cyc <= purge_cycle;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR NOLOGGING');
	
	IF (purge_cycle = cycle_id2)
	THEN
             DELETE FROM camp_comm_out_hdr
              WHERE camp_id = purge_camp_id;

             COMMIT;
	ELSE     
          WHILE (var_count > 0)
          LOOP
             DELETE FROM camp_comm_out_hdr
              WHERE camp_id = purge_camp_id
                AND camp_cyc <= purge_cycle;

             COMMIT;
             var_count := var_count - 1;

             IF (var_count < 0)
             THEN
                var_count := 0;
             END IF;
          END LOOP;
	END IF;
	  
        UPDATE camp_cyc_status
           SET proc_removed_flg =1
         WHERE camp_id = purge_camp_id 
           AND camp_cyc <= purge_cycle;

      COMMIT;	  
      execute_sql ('ALTER TABLE CAMP_COMM_OUT_HDR LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_OUT_DET
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_out_det
    WHERE camp_id = purge_camp_id 
      AND camp_cyc <= purge_cycle;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_OUT_DET NOLOGGING');

      IF (purge_cycle = cycle_id2)
      THEN
             DELETE FROM camp_comm_out_det
              WHERE camp_id = purge_camp_id;

             COMMIT;
      ELSE
          WHILE (var_count > 0)
          LOOP
             DELETE FROM camp_comm_out_det
              WHERE camp_id = purge_camp_id
                AND camp_cyc <= purge_cycle;

             COMMIT;
             var_count := var_count - 1;

             IF (var_count < 0)
             THEN
                var_count := 0;
             END IF;
          END LOOP;
      END IF;

      execute_sql ('ALTER TABLE CAMP_COMM_OUT_DET LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_IN_HDR
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_in_hdr
    WHERE camp_id = purge_camp_id 
      AND camp_cyc <= purge_cycle;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR NOLOGGING');

      IF (purge_cycle = cycle_id2)	
      THEN
             DELETE FROM camp_comm_in_hdr
              WHERE camp_id = purge_camp_id;

             COMMIT;
      ELSE
          WHILE (var_count > 0)
          LOOP
             DELETE FROM camp_comm_in_hdr
              WHERE camp_id = purge_camp_id
                AND camp_cyc <= purge_cycle;

             COMMIT;
             var_count := var_count - 1;

             IF (var_count < 0)
             THEN
                var_count := 0;
             END IF;
          END LOOP;
      END IF;

      execute_sql ('ALTER TABLE CAMP_COMM_IN_HDR LOGGING');
   END IF;

   -- Clearing entries associated with given campaign from CAMP_COMM_IN_DET
   SELECT COUNT (*)
     INTO var_count
     FROM camp_comm_in_det
    WHERE camp_id = purge_camp_id 
      AND camp_cyc <= purge_cycle;

   IF (var_count > 0)
   THEN
      execute_sql ('ALTER TABLE CAMP_COMM_IN_DET NOLOGGING');

      IF (purge_cycle = cycle_id2)
      THEN
             DELETE FROM camp_comm_in_det
              WHERE camp_id = purge_camp_id;

             COMMIT;
      ELSE          
          WHILE (var_count > 0)
          LOOP
             DELETE FROM camp_comm_in_det
              WHERE camp_id = purge_camp_id
                AND camp_cyc < purge_cycle;

             COMMIT;
             var_count := var_count - 1;

             IF (var_count < 0)
             THEN
                var_count := 0;
             END IF;
          END LOOP;
      END IF;

      execute_sql ('ALTER TABLE CAMP_COMM_IN_DET LOGGING');
   END IF;

   -- Drop associated dynamic tables and remove relevant entries from VANTAGE_DYN_TAB
   -- remove associated 'SFI<camp_id>' tables
   FOR c1rec IN c1
   LOOP
      var_table_name := c1rec.db_ent_name;

      SELECT COUNT (*)
        INTO var_count
        FROM user_tables
       WHERE table_name = var_table_name;
	   
      flag :=1;
      IF ( (( camp_status = 12) OR ( camp_status =16))  AND (  purge_cycle >= cycle_id2  ) )
      THEN
          flag:=0;
      END IF;

      IF (var_count > 0 and flag = 0)
      THEN
         execute_sql ('	DROP TABLE ' || var_table_name);

	 DELETE FROM vantage_dyn_tab WHERE db_ent_name = var_table_name;
      END IF;

   END LOOP;
   COMMIT;

   -- remove associated 'SFO<camp_id>' tables
   FOR c2rec IN c2
   LOOP
      var_table_name := c2rec.db_ent_name;

      SELECT COUNT (*)
        INTO var_count
        FROM user_tables
       WHERE table_name = var_table_name;
     
      flag :=1;
      IF ( (( camp_status = 12) OR ( camp_status =16))  AND (  purge_cycle >= cycle_id2  ) )
      THEN
          flag:=0;
      END IF;
	  
      IF (var_count > 0 and flag = 0)
      THEN
         execute_sql ('	DROP TABLE ' || var_table_name);

	 DELETE FROM vantage_dyn_tab WHERE db_ent_name = var_table_name;
      END IF;
   END LOOP;
   COMMIT;

   -- remove associated 'CS<seg_id>_<camp_id>_<det_id>' tables
   FOR c3rec IN c3
   LOOP
      IF (c3rec.obj_type_id = 4)
      THEN
         -- remove associated 'CS<tree_id>_<tree_seq>_<camp_id>_<det_id>' tables
         SELECT COUNT (*)
           INTO var_count
           FROM vantage_dyn_tab
          WHERE db_ent_name LIKE
                      'CS'
                   || c3rec.obj_id
                   || '\_'
                   || c3rec.obj_sub_id
                   || '\_'
                   || c3rec.camp_id
                   || '\_'
                   || c3rec.det_id
                   || '%' ESCAPE '\';

         IF (var_count > 0)
         THEN
            FOR var_num IN 1 .. var_count
            LOOP
               SELECT db_ent_name
                 INTO var_table_name
                 FROM vantage_dyn_tab
                WHERE db_ent_name LIKE
                            'CS'
                         || c3rec.obj_id
                         || '\_'
                         || c3rec.obj_sub_id
                         || '\_'
                         || c3rec.camp_id
                         || '\_'
                         || c3rec.det_id
                         || '%' ESCAPE '\';

               SELECT COUNT (*)
                 INTO var_count2
                 FROM user_tables
                WHERE table_name = var_table_name;

               IF (var_count2 > 0)
               THEN
                  execute_sql ('	DROP TABLE ' || var_table_name);
		  dbms_output.put_line('	DROP TABLE ' || var_table_name);
               END IF;

               DELETE FROM vantage_dyn_tab
                WHERE db_ent_name = var_table_name;

               COMMIT;
            END LOOP;
         END IF;
      ELSE
         -- remove associated 'CS<seg_id>_<camp_id>_<det_id>' tables
         IF (c3rec.obj_type_id = 1)
         THEN
            SELECT COUNT (*)
              INTO var_count
              FROM vantage_dyn_tab
             WHERE db_ent_name LIKE
                         'CS'
                      || c3rec.obj_id
                      || '\_'
                      || c3rec.camp_id
                      || '\_'
                      || c3rec.det_id
                      || '%' ESCAPE '\';

            IF (var_count > 0)
            THEN
               FOR var_num IN 1 .. var_count
               LOOP
                  SELECT db_ent_name
                    INTO var_table_name
                    FROM vantage_dyn_tab
                   WHERE db_ent_name LIKE
                               'CS'
                            || c3rec.obj_id
                            || '\_'
                            || c3rec.camp_id
                            || '\_'
                            || c3rec.det_id
                            || '%' ESCAPE '\'
                     AND ROWNUM = 1;

                  SELECT COUNT (*)
                    INTO var_count2
                    FROM user_tables
                   WHERE table_name = var_table_name;

                  IF (var_count2 > 0)
                  THEN
                     execute_sql ('	DROP TABLE ' || var_table_name);
		     dbms_output.put_line('	DROP TABLE ' || var_table_name);
		     
                  END IF;

                  DELETE FROM vantage_dyn_tab
                        WHERE db_ent_name = var_table_name;

                  COMMIT;
               END LOOP;
            END IF;
         END IF;
      END IF;
   END LOOP;

-- do not update campaign as purged until all the campaign cycles are purged
   var_update:=1;
   IF ( (( camp_status = 12) OR (camp_status=16))  AND (  purge_cycle >= cycle_id2  ) )
   THEN
     var_update:=0;
   END IF;  

   IF ((var_update = 0) OR ( cur_version_id > 1 )  )
   THEN 
       -- Check if Campaign is completed or cancelled and given cycle has more than maximum cycle it has run
       IF (var_update = 0)  
       THEN 
           -- Update Campaign Group to Purged Campaign Group
           UPDATE campaign
              SET camp_grp_id = var_camp_grp_id
            WHERE camp_id = purge_camp_id;
           COMMIT;

           -- Update Campaign Name prefixing it with 'PURGED' string;
           UPDATE campaign
              SET camp_name = 'PURGED ' || SUBSTR (camp_name, 1, 43)
            WHERE camp_id = purge_camp_id;

           COMMIT;
	   DBMS_OUTPUT.put_line ('	Purged Campaign [' || purge_camp_id || ']');
       END If; 		

       --For each referenced object that is a Segment or Base Segment DO
       purge_ref_segments_byid(24, purge_camp_id, dry_run_flag, purge_cycle);
   END IF;
   
-- Note that Segmentation Trees will be processed independently.
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
END purge_campaign_cycle;
/


-- **************************************************************************************
--
-- Procedure: mdpurge_obsolete_campaign_cycles_byid ()
--
-- Purge Obsolete Campaign cycles for a given campaign id retaining the cycles up to (and 
-- including) the given cycle number.
--
-- Calls function is_object_obsolete_byid() to determine whether the campaign is referenced 
-- by any other 'live' object' and then function purge_campaign_cycle() to actually 
-- purge the given campaign cycles.
--
-- **************************************************************************************
CREATE OR REPLACE PROCEDURE mdpurge_campaign_cycles_byid (
   given_camp_id      NUMBER,
   given_cycles       NUMBER,
   exec_type 	      CHAR 
)
IS
   var_count    	NUMBER   	 := 0;
   var_count1    	NUMBER   	 := 0;
   var_true    		NUMBER   	 := 0;
   cycle_id1    	NUMBER   	 := 0;
   cycle_id2    	NUMBER   	 := 0;
   version_count    	NUMBER   	 := 0;
   max_cycles_sch    	NUMBER		 := 0;  	 
   given_cycles1    	NUMBER		 := 0;  	 
   cur_version_id       NUMBER   	 := 0; 
   camp_status          NUMBER(2)   	 := 0;
   min_cycle_id         NUMBER           := 0;
   max_cycle_id         NUMBER           := 0;
   interval_cycle_id    NUMBER           := 0;
   indefinite_run_flg   NUMBER           := 0;
   var_version_id    	NUMBER;  	 
   err_num      	NUMBER;      
   dry_run_flag    	SMALLINT;
   run_until_date       VARCHAR2(19) ;
   err_msg      	VARCHAR2(100);


   CURSOR c10						-- Get the version ID of given campaign
   IS
	SELECT version_id 
	  FROM CAMP_VERSION 
	 WHERE camp_id = given_camp_id  
	 ORDER BY version_id;
BEGIN
   IF ((TRIM(UPPER(exec_type))) = 'PURGE')
   THEN
       dry_run_flag := 0;                   -- Dry_Run_Flag=FALSE,Actual Purging will happen.
   ELSIF((TRIM(UPPER(exec_type))) = 'LIST')
   THEN
       dry_run_flag := 1;                   -- Dry_Run_Flag=TRUE,Only Listing will happen
   ELSE
       DBMS_OUTPUT.put_line ('      Valid Execution types are ''PURGE'' or ''LIST''');
       RETURN;
   END IF;

   -- Check is given campaign is already PURGED
   SELECT COUNT (*)
     INTO var_count
     FROM campaign
    WHERE camp_id = given_camp_id 
      AND camp_name LIKE 'PURGED%';

   -- Get current version id for a given campaign 
   SELECT current_version_id 
     INTO cur_version_id 
     FROM CAMPAIGN 
    WHERE camp_id = given_camp_id ;

   -- Get number of versions from current version for a given campaign 
   SELECT count(*) 
     INTO version_count  
     FROM CAMP_VERSION 
    WHERE camp_id = given_camp_id  
      AND version_id <= cur_version_id 
    ORDER BY version_id;

   IF (var_count = 0)
   THEN
      -- Check for Completed, Cancelled or Suspended status of the campaign 
      SELECT COUNT (*)
        INTO var_count
        FROM camp_status_hist x
       WHERE status_setting_id IN (10, 12,16 )
         AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                                FROM camp_status_hist
                               WHERE camp_id = x.camp_id)
      AND camp_id = given_camp_id;
 
      SELECT status_setting_id
        INTO camp_status 
        FROM camp_status_hist x
       WHERE status_setting_id IN ( 10, 12,16 )
         AND camp_hist_seq = (SELECT MAX (camp_hist_seq)
                             FROM camp_status_hist
                            WHERE camp_id = x.camp_id)
         AND camp_id = given_camp_id;

      SELECT MAX( camp_cyc ) 
        INTO cycle_id2 
	FROM CAMP_COMM_OUT_HDR  
       WHERE camp_id = given_camp_id; 

      IF (var_count > 0)
      THEN
      
          SELECT COUNT(*)  INTO var_count1 FROM  CAMP_COMM_OUT_HDR WHERE CAMP_ID = given_camp_id;

          IF ( var_count1 > 0) 
	  THEN
   	      SELECT MIN(CAMP_CYC) INTO min_cycle_id FROM CAMP_COMM_OUT_HDR WHERE CAMP_ID=given_camp_id; 
              SELECT MAX(CAMP_CYC) INTO max_cycle_id FROM CAMP_COMM_OUT_HDR WHERE CAMP_ID=given_camp_id; 
	  END IF;
	    
          IF( camp_status <> 16 ) 
          THEN
	      --Find maximum no of cycles that can be run
              SELECT INTERVAL_CYC_ID 
	        INTO interval_cycle_id 
	        FROM SPI_MASTER 
 	       WHERE SPI_CAMP_ID = given_camp_id;	

              IF(interval_cycle_id <> 0 ) 
              THEN 
                 SELECT INDEFINITE_RUN_FLG, RUN_UNTIL_DATE  
                   INTO indefinite_run_flg, run_until_date 
                   FROM INTERVAL_CYC_DET 
                  WHERE INTERVAL_CYC_ID=interval_cycle_id;
                  
                 IF((indefinite_run_flg = 0) AND (run_until_date IS  NULL))
                 THEN
                   SELECT NUMBER_OF_RUNS  
		     INTO max_cycles_sch 
	 	     FROM INTERVAL_CYC_DET 
	   	    WHERE INTERVAL_CYC_ID = interval_cycle_id;
	   	 ELSE
		     max_cycles_sch:= max_cycle_id;
                 END IF;
              ELSE
                max_cycles_sch:=1;
              END IF;

  	      IF (given_cycles >  max_cycles_sch) 
	      THEN
		  DBMS_OUTPUT.put_line 
			('	Invalid Cycle number: '|| given_cycles || ' Maximum no of cycles is :  ' ||  max_cycles_sch);
                      RETURN ; 
	      END IF;
	  END IF;

	  IF((given_cycles = 0) AND (camp_status <> 16 ))   
 	  THEN
              given_cycles1:= max_cycles_sch;
          END IF;

          IF(given_cycles = 0)
	  THEN 
	      given_cycles1:=cycle_id2;
	  ELSE 
	      given_cycles1:=given_cycles;
	  END IF;


          -- check whether Campaign is Obsolete ( Not referenced by another live object )
          IF (is_object_obsolete_byid (24, given_camp_id, given_camp_id, given_cycles1, dry_run_flag) > 0)
          THEN       
	    IF( ( camp_status = 16 ) AND ( given_cycles = 0 )) 
	    THEN 
             	given_cycles1:=max_cycle_id;
            END IF;

	    IF ((given_cycles <> 0) AND (given_cycles <= max_cycle_id ))
	    THEN 
         	max_cycle_id:=given_cycles;
            END IF;

	    IF(( min_cycle_id = 0 ) OR ( max_cycle_id =0 )OR (given_cycles1 < min_cycle_id ))
	    THEN 
		IF (( camp_status <> 16 ) OR (given_cycles1 < min_cycle_id))
                THEN
		   IF (given_cycles1 < min_cycle_id) 
		   THEN
			DBMS_OUTPUT.put_line (' 	Invalid cycle no - Minimum no of cycles is :  ' ||  min_cycle_id);
		   ELSIF(( min_cycle_id = 0 ) OR ( max_cycle_id =0 ) ) 
		   THEN 
			DBMS_OUTPUT.put_line (' 	There are NO cycles to be Purged');
		   END IF;
		   RETURN ;
	        END IF;
	    END IF;   

            DBMS_OUTPUT.put_line ('******************************************************');
            DBMS_OUTPUT.put_line ('	Purge for Campaign ID :' || given_camp_id);
            DBMS_OUTPUT.put_line ('******************************************************');

            IF (dry_run_flag = 0)
            THEN
                -- Purge Campaign cycles
            	purge_campaign_cycle(given_camp_id, given_cycles1, dry_run_flag, cur_version_id);

		DBMS_OUTPUT.put_line 
			(' 	Purged cycles ' || min_cycle_id || ' to ' ||  max_cycle_id || ' of campaign ' || given_camp_id);
	    ELSIF (dry_run_flag = 1)
            THEN      
                -- List Purgeable Campaign cycles and segments 
		DBMS_OUTPUT.put_line 
			(' 	Purging cycles ' || min_cycle_id || ' to ' ||  max_cycle_id || ' of campaign ' || given_camp_id);

                IF((cur_version_id > 1 ) OR  (((camp_status = 12) AND (given_cycles1 >= cycle_id2))OR (camp_status = 16)))
		THEN
	 	    -- Calling to LIST the purgeable Segments 	
		    purge_ref_segments_byid(24, given_camp_id, dry_run_flag, given_cycles1);
	        END IF; 

		IF ( (( camp_status = 12) OR (camp_status=16))  AND (  given_cycles1 = cycle_id2  ) )
   		THEN
		    DBMS_OUTPUT.put_line (' 	Purging Campaign ['|| given_camp_id||']');
   		END IF;

	    END IF;
         END IF;   	    
      END IF;   	    
   ELSE 
	DBMS_OUTPUT.put_line (' 	Campaign [' || given_camp_id ||'] is already purged ' );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SUBSTR (SQLERRM, 1, 100);
      DBMS_OUTPUT.put_line (   'Oracle Error: '
                            || err_num
                            || ' '
                            || err_msg
                            || ' occurred.'
                           );
END mdpurge_campaign_cycles_byid;
/
