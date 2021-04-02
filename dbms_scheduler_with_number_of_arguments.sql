------------------------------------------------------------
-------------------Dest Database Server---------------------
------------------------------------------------------------
ServerHost   => 192.168.129.1
TcpPort      => 1521
InstanceSid  => orcl

-- System Error Log Table
DROP TABLE webapp.inv_event_error purge;
CREATE TABLE webapp.inv_event_error
(
 sn                        NUMBER,
 object_name               VARCHAR2(100),
 error_date_time           TIMESTAMP,
 errmsg                    VARCHAR2(4000)
)
TABLESPACE tbs_webapp;

-- Process Log Table
DROP TABLE webapp.inv_log purge;
CREATE TABLE webapp.inv_log
(
 sn                        NUMBER,
 fiscalyear                VARCHAR2(100),
 office_branch             VARCHAR2(100),
 office_institution        VARCHAR2(100),
 branch_user               VARCHAR2(100),
 fromdate                  VARCHAR2(20),
 todate                    VARCHAR2(20),
 requested_filename        VARCHAR2(100),
 recived_filename          VARCHAR2(100),
 requested_filerowcount    NUMBER,
 recived_filerowcount      NUMBER,
 requeted_status           VARCHAR2(10),
 recived_status            VARCHAR2(10),
 errmsg                    VARCHAR2(4000),
 import_status             VARCHAR2(10),
 remove_duplicate_status   VARCHAR2(10)

 CONSTRAINT primary_key_sn PRIMARY KEY (sn)
)
TABLESPACE tbs_webapp;

-- File Sequence 
DROP SEQUENCE webapp.sq_sn_inv_log;
CREATE SEQUENCE webapp.sq_sn_inv_log;

-- Current Data Stored Table
DROP TABLE webapp.invoice_data PURGE;
CREATE TABLE webapp.invoice_data 
(
  fiscal_yr         VARCHAR2(20),
  activity_date_bs  VARCHAR2(25),
  activity_date_ad  DATE,
  month_bs          NUMBER(22,0),
  cir_number        VARCHAR2(25),
  request_id        VARCHAR2(25),
  product_id        VARCHAR2(25),
  product_type      VARCHAR2(225),
  no_of_product     VARCHAR2(25),
  charge_amount     VARCHAR2(25),
  discount_amount   NUMBER(22,0),
  user_type         VARCHAR2(25),
  user_code         VARCHAR2(30),
  bank_code         VARCHAR2(25),
  branch_code       VARCHAR2(25),
  subject_name      VARCHAR2(500),
  invoice_fiscal_yr VARCHAR2(7),
  invoice_created   VARCHAR2(1),
  invoice_no        NUMBER(22,0),
  include_invoice   VARCHAR2(20),
  sub_ver_invoice   VARCHAR2(20),
  cat_id            VARCHAR2(20)
)
TABLESPACE tbs_webapp;

-- History Data Stored Table
DROP TABLE webapp.cis_on_rep_bl PURGE;
CREATE TABLE webapp.cis_on_rep_bl 
(
  fiscal_yr         VARCHAR2(20),
  activity_date_bs  VARCHAR2(25),
  activity_date_ad  DATE,
  month_bs          NUMBER(2,0),
  cir_number        VARCHAR2(25),
  request_id        VARCHAR2(25),
  product_id        VARCHAR2(25),
  product_type      VARCHAR2(225),
  no_of_product     VARCHAR2(25),
  charge_amount     VARCHAR2(25),
  discount_amount   NUMBER,
  user_type         VARCHAR2(25),
  user_code         VARCHAR2(30),
  bank_code         VARCHAR2(25),
  branch_code       VARCHAR2(25),
  subject_name      VARCHAR2(500),
  invoice_fiscal_yr VARCHAR2(7),
  invoice_created   VARCHAR2(1),
  invoice_no        NUMBER,
  include_invoice   VARCHAR2(20),
  sub_ver_invoice   VARCHAR2(20),
  cat_id            VARCHAR2(20)
)
  PARTITION BY LIST (fiscal_yr)
  (
    PARTITION p_2074_75 VALUES ('2074/75') TABLESPACE tbs_webapp,
    PARTITION p_2075_76 VALUES ('2075/76') TABLESPACE tbs_webapp,
    PARTITION p_2076_77 VALUES ('2076/77') TABLESPACE tbs_webapp,
    PARTITION p_2077_78 VALUES ('2077/78') TABLESPACE tbs_webapp,
    PARTITION p_2078_79 VALUES ('2078/79') TABLESPACE tbs_webapp,
    PARTITION p_2079_80 VALUES ('2079/80') TABLESPACE tbs_webapp,
    PARTITION p_2080_81 VALUES ('2080/81') TABLESPACE tbs_webapp
  )
;

-- Mapping Data Table
DROP TABLE webapp.product_mst PURGE;
CREATE TABLE webapp.product_mst 
(
  product_id     VARCHAR2(25),
  product_name   VARCHAR2(225),
  mgr_product_id VARCHAR2(25),
  group_type     VARCHAR2(30)
  disc_alw       CHAR(1) NOT NULL,
  inv_inc        CHAR(1) NOT NULL
) 
TABLESPACE tbs_webapp;

-- Import Directory
DROP DIRECTORY dir_extracts;
CREATE OR REPLACE DIRECTORY dir_extracts AS '/home/oracle/extracts/';                                 
GRANT READ,WRITE ON DIRECTORY dir_extracts TO PUBLIC;

-- INV Engin
CREATE OR REPLACE PACKAGE webapp.pkg_inv
AS
  PROCEDURE sp_call_extract
  (
   p_fiscal_year        VARCHAR2,
   p_office_branch      VARCHAR2,
   p_office_institution VARCHAR2,
   p_branch_user        VARCHAR2,
   p_from_date          VARCHAR2,
   p_to_date            VARCHAR2
  );

  PROCEDURE sp_refresh_status_extract
  (
   p_fiscal_year        VARCHAR2,
   p_office_branch      VARCHAR2,
   p_office_institution VARCHAR2,
   p_branch_user        VARCHAR2,
   p_from_date          VARCHAR2,
   p_to_date            VARCHAR2
  );

  PROCEDURE sp_dump_extract
  (
   p_source_filenames  VARCHAR2,
   P_filerowcount      NUMBER  ,
   p_db_directory_name VARCHAR2
  );

  PROCEDURE sp_delete_history_data;
  PROCEDURE sp_inv_bustup;
END pkg_inv;
/

CREATE OR REPLACE PACKAGE BODY webapp.pkg_inv
AS
  PROCEDURE sp_call_extract
  (
   p_fiscal_year        VARCHAR2,
   p_office_branch      VARCHAR2,
   p_office_institution VARCHAR2,
   p_branch_user        VARCHAR2,
   p_from_date          VARCHAR2,
   p_to_date            VARCHAR2
  )
  AS
       l_fiscal_year        VARCHAR2(100);
       l_office_branch      VARCHAR2(100);
       l_office_institution VARCHAR2(100);
       l_branch_user        VARCHAR2(100);
       l_from_date          VARCHAR2(20);
       l_to_date            VARCHAR2(20);
       l_dest_user          VARCHAR2(100);
       l_dest_ip            VARCHAR2(100);
       l_dest_password      VARCHAR2(100);
       l_sh_job             VARCHAR2(100);
       l_sql                VARCHAR2(32767) := '';
       l_sn                 NUMBER;
       l_timestamp          TIMESTAMP;
  BEGIN
      -- Check The Parameters to Request Send
      IF (p_fiscal_year IS NOT NULL AND p_office_branch IS NOT NULL AND p_office_institution IS NOT NULL AND p_branch_user IS NOT NULL AND p_from_date IS NOT NULL AND p_to_date IS NOT NULL)
      THEN
         -- Input Parameters to Call the Shell Script
         l_sql := 'SELECT '''||p_fiscal_year||'''                                                   fiscal_year,
                          '''||p_office_branch||'''                                                 office_branch,
                          '''||p_office_institution||'''                                            office_institution,
                          '''||p_branch_user||'''                                                   branch_user,
                          '''||p_from_date||'''                                                     fromdate,
                          '''||p_to_date||'''                                                       todate,
                          ''root|DIR_EXTRACTS|extracts|Extr1c#t5!|/home/oracle/extracts/script''    dest_user,
                          ''192.168.1.63''                                                           dest_ip,
                          ''DmB@K5kL''                                                              dest_password,
                          ''/home/oracle/extracts/script/call_extract.sh''                          sh_job
                   FROM dual';

          EXECUTE IMMEDIATE (l_sql) INTO l_fiscal_year, l_office_branch, l_office_institution, l_branch_user, l_from_date, l_to_date, l_dest_user, l_dest_ip, l_dest_password, l_sh_job;
          BEGIN
              -- Call the Shell Script
              BEGIN
                  -- To Stop a Job
                  BEGIN
                      DBMS_SCHEDULER.STOP_JOB(job_name=>'WEBAPP.CALLEXTRACT', force=>true);
                  EXCEPTION WHEN OTHERS THEN
                      NULL;
                  END;
                  -- To Drop a Job
                  BEGIN
                      DBMS_SCHEDULER.DROP_JOB ('WEBAPP.CALLEXTRACT');
                  EXCEPTION WHEN OTHERS THEN
                      NULL;
                  END;
                  -- To Empty the Logs
                  BEGIN
                      DBMS_SCHEDULER.PURGE_LOG(JOB_NAME => 'WEBAPP.CALLEXTRACT');
                  EXCEPTION WHEN OTHERS THEN
                      NULL;
                  END;
              END;

              -- To Call a Job From Database With Parameters
              BEGIN
                  DBMS_SCHEDULER.CREATE_JOB(
                    job_name             => 'CALLEXTRACT',
                    job_type             => 'EXECUTABLE',
                    number_of_arguments  => 9,
                    job_action           => l_sh_job,
                    auto_drop            => false);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',1,l_fiscal_year);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',2,l_office_branch);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',3,l_office_institution);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',4,l_branch_user);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',5,l_from_date);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',6,l_to_date);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',7,l_dest_user);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',8,l_dest_ip);
                  DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('CALLEXTRACT',9,l_dest_password);
                  DBMS_SCHEDULER.ENABLE('CALLEXTRACT');
              END;
         END;
         -- Request Send
         EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_log (sn, fiscalyear, office_branch, office_institution, branch_user, fromdate, todate, requested_filename)
                 SELECT
                   webapp.sq_sn_inv_log.NEXTVAL                     sn,
                   '''||p_fiscal_year||'''                          fiscal_year,
                   '''||p_office_branch||'''                        office_branch,
                   '''||p_office_institution||'''                   office_institution,
                   '''||p_branch_user||'''                          branch_user,
                   '''||p_from_date||'''                            fromdate,
                   '''||p_to_date||'''                              todate,
                   ''IVC_'||p_from_date||'_'||p_to_date||'.txt''    requested_filename
                 FROM DUAL';
         COMMIT;
      ELSE
         -- Request Failed
         EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_log (sn, fiscalyear, office_branch, office_institution, branch_user, fromdate, todate, requested_filename,requeted_status,errmsg)
                            SELECT
                              webapp.sq_sn_inv_log.NEXTVAL                     sn,
                              '''||p_fiscal_year||'''                          fiscal_year,
                              '''||p_office_branch||'''                        office_branch,
                              '''||p_office_institution||'''                   office_institution,
                              '''||p_branch_user||'''                          branch_user,
                              '''||p_from_date||'''                            fromdate,
                              '''||p_to_date||'''                              todate,
                              ''IVC_'||p_from_date||'_'||p_to_date||'.txt''    requested_filename,
                              ''FAILED''                                       requeted_status,
                              ''Requested With Null Filed''                    errmsg
                            FROM DUAL';
         COMMIT;
      END IF;
    EXCEPTION WHEN OTHERS THEN
        l_timestamp := SYSTIMESTAMP;
        EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (1,''webapp.pkg_inv.sp_call_extract'','''||l_timestamp||''','''||SQLERRM||''')';
        COMMIT;
  END sp_call_extract;

  PROCEDURE sp_refresh_status_extract
  (
   p_fiscal_year        VARCHAR2,
   p_office_branch      VARCHAR2,
   p_office_institution VARCHAR2,
   p_branch_user        VARCHAR2,
   p_from_date          VARCHAR2,
   p_to_date            VARCHAR2
  )
  AS
       l_timestamp      TIMESTAMP;
  BEGIN
      IF (p_fiscal_year IS NOT NULL AND p_office_branch IS NOT NULL AND p_office_institution IS NOT NULL AND p_branch_user IS NOT NULL AND p_from_date IS NOT NULL AND p_to_date IS NOT NULL)
      THEN
         -- Reqest Send Status
         EXECUTE IMMEDIATE 'UPDATE webapp.inv_log a
                            SET (a.requeted_status,a.errmsg) = (SELECT
                                                                      b.status,b.additional_info FROM dba_scheduler_job_run_details b
                                                                WHERE b.owner = ''WEBAPP''
                                                                AND UPPER(b.job_name) = ''CALLEXTRACT'')
                            WHERE a.sn = (SELECT MAX(b.sn) FROM webapp.inv_log b)
                            AND   a.fiscalyear         = '''||p_fiscal_year||'''
                            AND   a.office_branch      = '''||p_office_branch||'''
                            AND   a.office_institution = '''||p_office_institution||'''
                            AND   a.branch_user        = '''||p_branch_user||'''
                            AND   a.fromdate           = '''||p_from_date||'''
                            AND   a.todate             = '''||p_to_date||'''
                            AND   a.requested_filename = ''IVC_'||p_from_date||'_'||p_to_date||'.txt''';
         COMMIT;
      END IF;
  EXCEPTION WHEN OTHERS THEN
      l_timestamp := SYSTIMESTAMP;
      EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (2,''webapp.pkg_inv.sp_refresh_status_extract'','''||l_timestamp||''','''||SQLERRM||''')';
      COMMIT;
  END sp_refresh_status_extract;

  PROCEDURE sp_dump_extract
  (
   p_source_filenames  VARCHAR2,
   p_filerowcount      NUMBER,
   p_db_directory_name VARCHAR2
  )
  AS
      l_filerowcount    NUMBER := 0;
      l_timestamp       TIMESTAMP;
      c_limit           CONSTANT PLS_INTEGER DEFAULT 500;
      CURSOR inv_cur IS SELECT * FROM webapp.invoice_data;
      TYPE inv_cur_at   IS TABLE OF inv_cur%ROWTYPE INDEX BY BINARY_INTEGER;
      l_inv_cur         inv_cur_at;
      l_partition_name  VARCHAR2(30);
      l_fiscal_yr       VARCHAR2(50);
  BEGIN
       -- To Drop The External Table
       BEGIN
           EXECUTE IMMEDIATE 'DROP TABLE webapp.tmp_invoice_data purge';
       EXCEPTION WHEN OTHERS THEN
          NULL;
       END;
       -- Step 3
       -- To Create The External Table
       BEGIN
           EXECUTE IMMEDIATE 'CREATE TABLE webapp.tmp_invoice_data
                              (
                               fiscal_yr             VARCHAR2(4000),
                               cir_number            VARCHAR2(4000),
                               subject_name          VARCHAR2(4000),
                               request_id            VARCHAR2(4000),
                               product_id            VARCHAR2(4000),
                               product_type_id       VARCHAR2(4000),
                               no_of_product         VARCHAR2(4000),
                               charge_amount         VARCHAR2(4000),
                               user_type             VARCHAR2(4000),
                               user_code             VARCHAR2(4000),
                               bank_code             VARCHAR2(4000),
                               branch_code           VARCHAR2(4000),
                               activity_date_bs      VARCHAR2(4000),
                               activity_date_ad      DATE
                             )
                             ORGANIZATION external
                             (
                               TYPE ORACLE_LOADER
                               DEFAULT DIRECTORY '||p_db_directory_name||'
                               ACCESS PARAMETERS
                               (
                                 RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
                                 SKIP 1
                                 READSIZE 1048576
                                 FIELDS TERMINATED BY ''|''
                                 OPTIONALLY ENCLOSED BY ''"'' LDRTRIM
                                 REJECT ROWS WITH ALL NULL FIELDS
                               )
                               LOCATION ('''||p_source_filenames||''')
                             )
                             REJECT LIMIT UNLIMITED';
           -- Verify The Recived File Count
           EXECUTE IMMEDIATE 'SELECT Count(*) FROM webapp.tmp_invoice_data' INTO l_filerowcount;
           -- Recived File Count Status
           EXECUTE IMMEDIATE 'UPDATE webapp.inv_log a
                              SET a.recived_filename       = '''||p_source_filenames||''',
                                  a.requested_filerowcount = '||p_filerowcount||',
                                  a.recived_filerowcount   = '||l_filerowcount||',
                                  a.recived_status         = ''SUCCEEDED'',
                                  a.requeted_status        = ''SUCCEEDED''
                              WHERE a.sn = (SELECT MAX(b.sn) FROM webapp.inv_log b)
                              AND   a.requested_filename = '''||p_source_filenames||'''';
           COMMIT;
           -- To Populate The Current Table
           EXECUTE IMMEDIATE 'TRUNCATE TABLE webapp.invoice_data DROP STORAGE';
           EXECUTE IMMEDIATE 'INSERT INTO webapp.invoice_data
                              SELECT
                                   TRIM(a.fiscal_yr)                                       fiscal_yr,
                                   TRIM(a.activity_date_bs)                                activity_date_bs,
                                   a.activity_date_ad                                      activity_date_ad,
                                   LTRIM(SUBSTR(a.activity_date_bs,REGEXP_INSTR(a.activity_date_bs,''-'',1,1,0,''i'')+1,(REGEXP_INSTR(a.activity_date_bs,''-'',1,2,0,''i'')-1)-REGEXP_INSTR(a.activity_date_bs,''-'',1,1,0,''i'')),0) month_bs,
                                   TRIM(a.cir_number)                                      cir_number,
                                   TRIM(a.request_id)                                      request_id,
                                   TRIM(a.product_id)                                      product_id,
                                   TRIM(a.product_type_id)                                 product_type,
                                   TRIM(a.no_of_product)                                   no_of_product,
                                   TRIM(a.charge_amount)                                   charge_amount,
                                   0                                                       discount_amount,
                                   TRIM(a.user_type)                                       user_type,
                                   TRIM(a.user_code)                                       user_code,
                                   TRIM(a.bank_code)                                       bank_code,
                                   TRIM(a.branch_code)                                     branch_code,
                                   REGEXP_REPLACE(TRIM(a.subject_name),''( ){2,}'','' '')  subject_name,
                                   TRIM(fiscal_yr)                                         invoice_fiscal_yr,
                                   ''N''                                                   invoice_created,
                                   NULL                                                    invoice_no,
                                   ''N''                                                   include_invoice,
                                   ''P''                                                   sub_ver_invoice,
                                   NULL                                                    cat_id
                              FROM webapp.tmp_invoice_data a';
           COMMIT;
           -- To Drop The External Table
           BEGIN
               EXECUTE IMMEDIATE 'DROP TABLE webapp.tmp_invoice_data purge';
           EXCEPTION WHEN OTHERS THEN
               NULL;
           END;
     EXCEPTION WHEN OTHERS THEN
          l_timestamp := SYSTIMESTAMP;
          EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (3,''webapp.pkg_inv.sp_dump_extract'','''||l_timestamp||''','''||SQLERRM||''')';
          COMMIT;
     END;

	 -- Step 4
     -- To Populate The History Table
     BEGIN
          BEGIN
            SELECT
                 MAX(fiscal_yr) fiscal_yr
                 INTO l_fiscal_yr
            FROM webapp.invoice_data ;

            l_partition_name := 'PARTITION ( p_'||REPLACE(l_fiscal_yr,'/','_')||' ) ';

            -- To Insert the New Records
            OPEN inv_cur;
            LOOP
               FETCH inv_cur BULK COLLECT INTO l_inv_cur LIMIT c_limit;
               FORALL l_i IN 1..l_inv_cur.COUNT
               INSERT INTO webapp.cis_on_rep_bl l_partition_name VALUES l_inv_cur(l_i);
               EXIT WHEN inv_cur%NOTFOUND;
               COMMIT;
            END LOOP;
            CLOSE inv_cur;
            COMMIT;
         END;
         -- The New Records Status
         EXECUTE IMMEDIATE 'UPDATE webapp.inv_log a
                            SET a.import_status = ''SUCCEEDED''
                            WHERE a.sn = (SELECT MAX(b.sn) FROM webapp.inv_log b)
                            AND   a.requested_filename = '''||p_source_filenames||'''';
         COMMIT;
     EXCEPTION WHEN OTHERS THEN
          l_timestamp := SYSTIMESTAMP;
          EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (4,''webapp.pkg_inv.sp_dump_extract'','''||l_timestamp||''','''||SQLERRM||''')';
          COMMIT;
     END;

	 -- Step 5
     BEGIN
        -- To Find The Duplicate Recordes To Merge With History Table
        EXECUTE IMMEDIATE 'MERGE INTO webapp.cis_on_rep_bl '||l_partition_name||' a
                           USING (
                                  SELECT
                                       a.fiscal_yr,a.subject_name,a.bank_code,a.product_id,a.activity_date_ad,a.cir_number,a.charge_amount,''Y'' invoice_created, ''Y'' include_invoice
                                  FROM (
                                        SELECT
                                             a.fiscal_yr,a.subject_name,a.bank_code,a.product_id,a.activity_date_ad,a.cir_number,a.charge_amount,
                                             ROW_NUMBER() OVER (PARTITION BY a.product_rank,a.fiscal_yr,a.subject_name,a.bank_code,a.activity_date_ad ORDER BY a.product_id DESC) row_num
                                        FROM (
                                              SELECT
                                                  a.fiscal_yr,a.subject_name,a.bank_code,a.product_id,a.activity_date_ad,a.cir_number,a.charge_amount,
                                                  DENSE_RANK() OVER (PARTITION BY a.fiscal_yr,a.subject_name,a.bank_code,a.activity_date_ad ORDER BY a.product_id DESC, a.activity_date_ad DESC) product_rank
                                              FROM
                                                  webapp.invoice_data a, webapp.product_mst b
                                              WHERE
                                                  a.product_id=b.product_id
                                              AND a.fiscal_yr='''||l_fiscal_yr||'''
                                            ) a
                                       ) a
                                  WHERE a.row_num=1
                                 ) b
                           ON (a.fiscal_yr=b.fiscal_yr AND a.bank_code=b.bank_code AND a.cir_number=b.cir_number AND a.product_id=b.product_id AND a.subject_name=b.subject_name AND a.activity_date_ad=b.activity_date_ad)
                           WHEN matched THEN
                           UPDATE SET a.invoice_created = ''Y'', a.include_invoice = ''Y''';
        COMMIT;
        -- The Duplicate Recordes Status
        EXECUTE IMMEDIATE 'UPDATE webapp.inv_log a
                           SET a.remove_duplicate_status = ''SUCCEEDED''
                           WHERE a.sn = (SELECT MAX(b.sn) FROM webapp.inv_log b)
                           AND   a.requested_filename = '''||p_source_filenames||'''';
        COMMIT;
     EXCEPTION WHEN OTHERS THEN
        l_timestamp := SYSTIMESTAMP;
        EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (5,''webapp.pkg_inv.sp_dump_extract'','''||l_timestamp||''','''||SQLERRM||''')';
        COMMIT;
     END;
  END sp_dump_extract;

 PROCEDURE sp_delete_history_data
 AS
    c_limit                    CONSTANT PLS_INTEGER DEFAULT 500;
    CURSOR inv_cur IS          SELECT * FROM webapp.invoice_data;
    TYPE inv_cur_at            IS TABLE OF inv_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    l_inv_cur                  inv_cur_at;
    l_partition_name           VARCHAR2(30);
    l_start_activity_date_ad   VARCHAR2(50);
    l_end_activity_date_ad     VARCHAR2(50);
    l_month_bs                 VARCHAR2(50);
    l_fiscal_yr                VARCHAR2(50);
    l_timestamp                TIMESTAMP;
 BEGIN
    -- Step 6
    -- To Remove The Existing Recordes From The History Table
    -- DELETE FROM webapp.cis_on_rep_bl PARTITION (P_2077_78) WHERE activity_date_ad >= '16-NOV-20' AND activity_date_ad <= '15-DEC-20' and month_bs=8 AND fiscal_yr='2077/78';
    SELECT
         TO_CHAR(MIN(activity_date_ad),'DD-MON-YY') start_activity_date_ad,
         TO_CHAR(MAX(activity_date_ad),'DD-MON-YY') end_activity_date_ad,
         MAX(month_bs)  month_bs,
         MAX(fiscal_yr) fiscal_yr
         INTO l_start_activity_date_ad,l_end_activity_date_ad,l_month_bs,l_fiscal_yr
    FROM webapp.invoice_data ;

    l_partition_name := 'PARTITION ( p_'||REPLACE(l_fiscal_yr,'/','_')||' ) ';

    OPEN inv_cur;
       FETCH inv_cur BULK COLLECT INTO l_inv_cur LIMIT c_limit;
       FOR l_i IN 1..l_inv_cur.COUNT
    LOOP
       DELETE FROM webapp.cis_on_rep_bl l_partition_name
       WHERE fiscal_yr = l_fiscal_yr
       AND   month_bs  = l_month_bs
       AND   activity_date_ad >= l_start_activity_date_ad AND activity_date_ad <= l_end_activity_date_ad;
       COMMIT;
    END LOOP;
    CLOSE inv_cur;
    COMMIT;
 EXCEPTION WHEN OTHERS THEN
    l_timestamp := SYSTIMESTAMP;
    EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (6,''webapp.pkg_inv.sp_delete_history_data'','''||l_timestamp||''','''||SQLERRM||''')';
    COMMIT;
 END sp_delete_history_data;

 PROCEDURE sp_inv_bustup
 AS
     l_owners         VARCHAR2(500) := '''WEBAPP''';
     TYPE cursor_rc   IS REF cursor;
     l_cursor         cursor_rc;
     l_sql            VARCHAR2(32767);
     l_query          VARCHAR2(4000);
     l_index_name     VARCHAR2(50);
     l_owner          VARCHAR2(30);
     l_timestamp      TIMESTAMP;
 BEGIN
    -- Step 7
    -- To Bust The Relevant Table (Collect The Gather Stats)
    BEGIN
        l_sql := 'SELECT DISTINCT
                       ''BEGIN
                           dbms_stats.gather_table_stats
                           (
                            ownname          => ''''''||OWNER||'''''',
                            tabname          => ''''''||TABLE_NAME||'''''',
                            estimate_percent => 100,
                            cascade          => TRUE,
                            degree           => 8,
                            method_opt       =>''''FOR ALL COLUMNS SIZE AUTO''''
                           );
                       END; '' gather_table_stats
                  FROM dba_tables
                  WHERE UPPER(owner) IN ('||l_owners||')
                  AND NOT REGEXP_LIKE(table_name,''(BIN|BK)'')
                  ORDER BY 1';
        OPEN l_cursor FOR l_sql;
        LOOP
            FETCH l_cursor INTO l_query;
            EXIT WHEN l_cursor%NOTFOUND;
            BEGIN
                EXECUTE IMMEDIATE l_query;
            EXCEPTION WHEN OTHERS THEN
                l_timestamp := SYSTIMESTAMP;
                EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (7,''webapp.pkg_inv.sp_inv_bustup'','''||l_timestamp||''','''||SQLERRM||''')';
                COMMIT;
            END;
        END LOOP;
        CLOSE l_cursor;
    END;

    -- Step 8
    -- To Bust The Relevant Table (Rebuild The Indexes)
     BEGIN
         l_sql := 'SELECT ''ALTER INDEX ''||owner||''.''||index_name||'' REBUILD'' query,index_name,owner
                   FROM dba_indexes
                   WHERE UPPER(owner) IN ('||l_owners||')
                   ORDER BY index_name';
         OPEN l_cursor FOR l_sql;
         LOOP
             FETCH l_cursor INTO l_query,l_index_name,l_owner;
             EXIT WHEN l_cursor%NOTFOUND;
             BEGIN
                 EXECUTE IMMEDIATE l_query;
             EXCEPTION WHEN OTHERS THEN
                IF (SQLCODE = -14086) THEN
                     FOR i IN (SELECT partition_name
                               FROM dba_ind_partitions a
                               WHERE index_name =l_index_name AND index_owner = l_owner)
                     LOOP
                        BEGIN
                            EXECUTE IMMEDIATE 'ALTER INDEX '||l_owner||'.'||l_index_name||' REBUILD PARTITION '||i.partition_name||' ';
                        EXCEPTION WHEN OTHERS THEN
                            l_timestamp := SYSTIMESTAMP;
                            EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (8,''webapp.pkg_inv.sp_inv_bustup'','''||l_timestamp||''','''||SQLERRM||''')';
                            COMMIT;
                        END;
                     END LOOP;
                 ELSE
                     l_timestamp := SYSTIMESTAMP;
                     EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (9,''webapp.pkg_inv.sp_inv_bustup'','''||l_timestamp||''','''||SQLERRM||''')';
                     COMMIT;
                 END IF;
           END;
        END LOOP;
        CLOSE l_cursor;
     END;
 EXCEPTION WHEN OTHERS THEN
     l_timestamp := SYSTIMESTAMP;
     EXECUTE IMMEDIATE 'INSERT INTO webapp.inv_event_error VALUES (10,''webapp.pkg_inv.sp_inv_bustup'','''||l_timestamp||''','''||SQLERRM||''')';
     COMMIT;
 END sp_inv_bustup;
END pkg_inv;
/
/*                                  
EXECUTE pkg_inv.sp_delete_history_data;
EXECUTE pkg_inv.sp_inv_bustup;
EXECUTE webapp.pkg_inv.sp_call_extract('2077/78','ALL','All','All','01-11-2021','31-11-2021');
EXECUTE webapp.pkg_inv.sp_refresh_status_extract('2077/78','ALL','All','All','01-11-2021','31-11-2021');
EXECUTE webapp.pkg_inv.sp_dump_extract('IVC_01-11-2021_31-11-2021.txt',463663,'DIR_EXTRACTS');

SELECT * FROM webapp.inv_log;
SELECT * FROM webapp.inv_event_error;

SELECT owner,job_name,start_date,enabled, state FROM dba_scheduler_jobs a
WHERE a.owner = 'WEBAPP'
AND  UPPER(a.job_name) = 'CALLEXTRACT';

SELECT job_name,status,error#, destination, additional_info FROM dba_scheduler_job_run_details a
WHERE a.owner = 'WEBAPP'
AND UPPER(a.job_name) = 'CALLEXTRACT';
*/

------------------------------------------------------------
-----------------Source Database Server---------------------
------------------------------------------------------------
ServerHost   => 192.168.1.63
TcpPort      => 1521
InstanceSid  => orcl

-- The Process Log Table
DROP TABLE extracts.inv_log purge;
CREATE TABLE extracts.inv_log
(
 sn              NUMBER,
 fiscalyear      VARCHAR2(100),
 fromdate        VARCHAR2(20),
 todate          VARCHAR2(20),
 filename        VARCHAR2(100),
 filerowcount    NUMBER,
 status          VARCHAR2(10),
 errmsg          VARCHAR2(4000),
 CONSTRAINT primary_key_sn PRIMARY KEY (sn)
)
TABLESPACE tbs_extracts;

-- Unique Sequence For Each Process
DROP SEQUENCE extracts.sq_sn_inv_log;
CREATE SEQUENCE extracts.sq_sn_inv_log;

-- To Create Current table
DROP TABLE extracts.invoice_data purge;
CREATE TABLE extracts.invoice_data (
  fiscal_yr             VARCHAR2(20),
  cir_number            VARCHAR2(25),
  subject_name          VARCHAR2(500),
  request_id            VARCHAR2(25),
  product_id            VARCHAR2(25),
  product_type_id       VARCHAR2(225),
  no_of_product         VARCHAR2(25),
  charge_amount         VARCHAR2(25),
  user_type             VARCHAR2(25),
  user_code             VARCHAR2(30),
  bank_code             VARCHAR2(25),
  branch_code           VARCHAR2(25),
  activity_date_bs      VARCHAR2(25),
  activity_date_ad      DATE
)
  TABLESPACE tbs_extracts
;

-- Import Directory
DROP DIRECTORY dir_extracts;
CREATE OR REPLACE DIRECTORY dir_extracts AS '/home/oracle/extracts/';
GRANT READ,WRITE ON DIRECTORY dir_extracts TO PUBLIC;

-- To Create external table
DROP TABLE extracts.tmp_invoice_data purge;
CREATE TABLE extracts.tmp_invoice_data (
  fiscal_yr             VARCHAR2(4000),
  cir_number            VARCHAR2(4000),
  subject_name          VARCHAR2(4000),
  request_id            VARCHAR2(4000),
  product_id            VARCHAR2(4000),
  product_type_id       VARCHAR2(4000),
  no_of_product         VARCHAR2(4000),
  charge_amount         VARCHAR2(4000),
  user_type             VARCHAR2(4000),
  user_code             VARCHAR2(4000),
  bank_code             VARCHAR2(4000),
  branch_code           VARCHAR2(4000),
  activity_date_bs      VARCHAR2(4000),
  activity_date_ad      DATE
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_EXTRACTS
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 1
    READSIZE 1048576
    FIELDS TERMINATED BY '|' 
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('INVOICE_1474_2077-09-01_1583.TXT')
)
REJECT LIMIT UNLIMITED;

-- To Populate the Source Table
INSERT INTO extracts.invoice_data
SELECT 
     TRIM(fiscal_yr)                                  fiscal_yr,
     TRIM(cir_number)                                 cir_number,
     REGEXP_REPLACE(TRIM(subject_name),'( ){2,}',' ') subject_name,
     TRIM(request_id)                                 request_id,
     TRIM(product_id)                                 product_id,
     TRIM(product_type_id)                            product_type_id,
     TRIM(no_of_product)                              no_of_product,
     TRIM(charge_amount)                              charge_amount,
     TRIM(user_type)                                  user_type,
     TRIM(user_code)                                  user_code,
     TRIM(bank_code)                                  bank_code,
     TRIM(branch_code)                                branch_code,
     TRIM(activity_date_bs)                           activity_date_bs,
     activity_date_ad                                 activity_date_ad
FROM extracts.tmp_invoice_data;
COMMIT;

-- To Drop the External Table
DROP TABLE extracts.tmp_invoice_data PURGE;

-- Collect the Gather Stats
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'EXTRACTS',
     tabname          => 'INVOICE_DATA', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 8, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- Trigger to Call The Shell Script with Parameters
CREATE OR REPLACE TRIGGER extracts.tr_inv_log
AFTER INSERT ON extracts.inv_log
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
     l_source_filename   VARCHAR2(100);
     l_source_path       VARCHAR2(100);
     l_dest_user         VARCHAR2(100);
     l_dest_ip           VARCHAR2(100);
     l_dest_path         VARCHAR2(100);
     l_dest_password     VARCHAR2(100);
     l_db_directory_name VARCHAR2(100);
     l_db_password       VARCHAR2(100);
     l_sh_job            VARCHAR2(100);
     l_filerowcount      NUMBER;
     l_sql               VARCHAR2(32767) := '';
     l_filename_n        VARCHAR2(100);
     l_filerowcount_n    NUMBER;
     PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    IF INSERTING THEN
        l_filename_n := :new.filename;
        l_filerowcount_n := :new.filerowcount;

        IF (:new.status = 'SUCCEEDED' AND :new.errmsg IS NULL) THEN
           l_sql := 'SELECT '''||l_filename_n||'''                           source_filename,
                            ''/home/oracle/extracts''                        source_path,
                            ''root''                                         dest_user,
                            ''192.168.129.1''                                dest_ip,
                            ''/home/oracle/extracts''                        dest_path,
                            ''2ksKl@26B''                                    dest_password,
		      			    '''||l_filerowcount_n||'''                       filerowcount,
                            ''DIR_EXTRACTS|webapp''                          db_directory_name,
                            ''W5b#ApPL!c1t90N''                              db_password,
                            ''/home/oracle/extracts/script/send_extract.sh'' sh_job
                     FROM dual';

           EXECUTE IMMEDIATE (l_sql) INTO l_source_filename, l_source_path, l_dest_user, l_dest_ip, l_dest_path, l_dest_password, l_filerowcount, l_db_directory_name, l_db_password, l_sh_job;

           BEGIN
               FOR i IN 1..2
               LOOP
                  BEGIN
                      -- To Stop a Job
                      BEGIN
                          DBMS_SCHEDULER.STOP_JOB(job_name=>'EXTRACTS.SENDEXTRACT', force=>true);
                      EXCEPTION WHEN OTHERS THEN
                          NULL;
                      END;

                      -- To Drop a Job
                      BEGIN
                          DBMS_SCHEDULER.DROP_JOB ('EXTRACTS.SENDEXTRACT');
                      EXCEPTION WHEN OTHERS THEN
                          NULL;
                      END;

                      -- To Empty the Logs
                      BEGIN
                          DBMS_SCHEDULER.PURGE_LOG(JOB_NAME => 'EXTRACTS.SENDEXTRACT');
                      EXCEPTION WHEN OTHERS THEN
                          NULL;
                      END;
      	          END;

                  -- To Call a Job
                  BEGIN
                      DBMS_SCHEDULER.CREATE_JOB(
                        job_name             => 'SENDEXTRACT',
                        job_type             => 'EXECUTABLE',
                        number_of_arguments  => 9,
                        job_action           => l_sh_job,
                        auto_drop            => false);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',1,l_source_filename);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',2,l_source_path);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',3,l_dest_user);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',4,l_dest_ip);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',5,l_dest_path);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',6,l_dest_password);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',7,''||l_filerowcount||'');
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',8,l_db_directory_name);
                      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('SENDEXTRACT',9,l_db_password);
                      DBMS_SCHEDULER.ENABLE('SENDEXTRACT');
                  END;
               END LOOP;
           END;
        END IF;
    END IF;
END tr_inv_log;
/