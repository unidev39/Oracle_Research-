-- To find the free and occupied size by tablespace
WITH tbs_auto AS
(
 SELECT DISTINCT 
      tablespace_name,
      autoextensible
 FROM dba_data_files
 WHERE autoextensible = 'YES'
),
files AS
(
 SELECT 
       tablespace_name,
       COUNT(*)              tbs_files,
       SUM(BYTES/1024/1024)  total_tbs_mb
 FROM dba_data_files
 GROUP BY tablespace_name
),
fragments AS
(
 SELECT
      tablespace_name,
      COUNT(*)               tbs_fragments,
      SUM(bytes)/1024/1024   total_tbs_free_mb,
      MAX(bytes)/1024/1024   max_free_chunk_mb
 FROM dba_free_space
 GROUP BY tablespace_name
),
autoextend AS
(
 SELECT
      tablespace_name,
      SUM(size_to_grow) total_growth_tbs
 FROM (
       SELECT 
            tablespace_name,
            SUM(maxbytes)/1024/1024  size_to_grow
       FROM dba_data_files
       WHERE autoextensible = 'YES'
       GROUP BY tablespace_name
       UNION
       SELECT 
            tablespace_name,
            SUM(bytes)/1024/1024  size_to_grow
       FROM dba_data_files
       WHERE autoextensible = 'NO'
       GROUP BY tablespace_name
     )
 GROUP BY tablespace_name
)
SELECT
     --c.instance_name,
     a.tablespace_name tablespace,
     CASE tbs_auto.autoextensible
          WHEN 'YES' THEN 'YES'
     ELSE 'NO'
     END AS autoextensible,
     files.tbs_files                                                                               files_in_tablespace_count,
     Round(files.total_tbs_mb/(1024),1)                                                            total_tablespace_space_gb,
     Round((files.total_tbs_mb - fragments.total_tbs_free_mb)/(1024),1)                            total_used_space_gb,
     Round(fragments.total_tbs_free_mb/(1024),1)                                                   total_tablespace_free_space_gb
     --round((((files.total_tbs_mb - fragments.total_tbs_free_mb)/files.total_tbs_mb)*100),1)        total_used_pct_mb,
     --round(((fragments.total_tbs_free_mb/files.total_tbs_mb)*100),1)                               total_free_pct_mb
FROM 
    dba_tablespaces a,
    --v$instance c,
    files, 
    fragments, 
    autoextend, 
    tbs_auto
WHERE 
    a.tablespace_name = files.tablespace_name
AND a.tablespace_name = fragments.tablespace_name
AND a.tablespace_name = autoextend.tablespace_name
AND a.tablespace_name = tbs_auto.tablespace_name(+)
--AND (((files.total_tbs_bytes - fragments.total_tbs_free_bytes)/ files.total_tbs_bytes))* 100 > 90
order by 5 desc;


----
SELECT COUNT(*),event FROM gv$session WHERE username IS NOT NULL AND username!='SYS' GROUP BY event;
select count(*),status from gv$session where username is not null and username NOT LIKE '%SYS%' GROUP BY status;
COMMIT;
SELECT * FROM v$flash_recovery_area_usage;

select * from v$asm_diskgroup;

SELECT name,open_mode FROM gv$database;

SELECT
     --'ALTER SYSTEM KILL SESSION '''||ssn.sid||','||ssn.serial#||''''|| ' IMMEDIATE;' " ", 
     --'ALTER SYSTEM KILL SESSION '''||ssn.sid||','||ssn.serial#||',@'||ssn.inst_id||''' IMMEDIATE;' " ",
     ssn.sid,
     ssn.serial#,
     ssn.username,
     ssn.schemaname,
     ssn.osuser,
     TO_CHAR((se1.VALUE/1024)/1024, '999G999G990D00') || ' MB' current_size,
     TO_CHAR((se2.VALUE/1024)/1024, '999G999G990D00') || ' MB' maximum_size,
     ssn.program
FROM 
     v$sesstat se1, v$sesstat se2, gv$session ssn, v$bgprocess bgp, v$process prc, v$instance ins, v$statname stat1, v$statname stat2
WHERE 
     se1.statistic# = stat1.statistic# and stat1.name = 'session pga memory'
AND  se2.statistic# = stat2.statistic# and stat2.name = 'session pga memory max'
AND  se1.sid = ssn.sid
AND  se2.sid = ssn.sid
AND  ssn.paddr = bgp.paddr (+)
AND  ssn.paddr = prc.addr (+)
AND  (ssn.username IS NOT NULL AND ssn.username NOT LIKE 'SYS%') 
AND  ssn.status ='INACTIVE' 
AND  regexp_like(ssn.osuser,'^IRD-WKS|^IRD$')
ORDER BY 7 DESC;

--own with details
SELECT
   'ALTER SYSTEM KILL SESSION '''||t.sid||','||s.serial#||',@'||s.inst_id||''' IMMEDIATE;' " ",
   s.machine,
   s.status,
   s.terminal,
   s.prev_exec_start,
   S.MODULE,
   S.LOGON_TIME,
   s.program,
   s.osuser,
   s.username,
   t.sid,
   s.serial#,
   SUM(VALUE/100) as "cpu usage (seconds)"
FROM
   gv$session s,
   gv$sesstat t,
   gv$statname n
WHERE
   t.STATISTIC# = n.STATISTIC#
AND
   MACHINE LIKE '%IRD%91'
AND
   NAME like '%CPU used by this session%'
AND
   t.SID = s.SID
AND
   s.username is not null
GROUP BY s.inst_id,s.machine,s.status,s.terminal,username, s.prev_exec_start,S.MODULE,S.LOGON_TIME,s.program,t.sid,s.serial#,s.osuser
order by "cpu usage (seconds)" desc;

-- To find the locks
SELECT 
     lo.session_id,
     lo.oracle_username,
     lo.os_user_name,
     ob.owner,
     ob.object_name,
     ob.object_type,
     lo.locked_mode
FROM (
      SELECT
           a.object_id,
           a.session_id,
           a.oracle_username,
           a.os_user_name,
           a.locked_mode
      FROM
           gv$locked_object a
     ) lo 
     JOIN
     (
      SELECT
           b.object_id,
           b.owner,
           b.object_name,
           b.object_type
      FROM
           all_objects b
     ) ob
ON (lo.object_id = ob.object_id);

-- The blocking session is:
select
    --'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''''|| ' IMMEDIATE;' " ",
    --'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' " ",
    username,
    blocking_session,
    sid,    serial#,
    wait_class,
    seconds_in_wait 
from
    gv$session 
where
    blocking_session is not NULL
order by
    blocking_session;
	
	
-- To find the current query run time
SELECT 
     l.opname                             opname,
     l.target                             target,
     l.message                            message,
     ROUND((l.sofar/l.totalwork),4) * 100 Percentage_Complete,
     l.start_time                         start_time,
     CEIL(l.time_remaining/60)            Max_Time_Remaining_In_Min,
     l.time_remaining                     time_remaining_in_second,
     FLOOR( l.elapsed_seconds / 60 )      Time_Spent_In_Min,
     ar.sql_fulltext                      sql_fulltext,
     ar.parsing_schema_name               parsing_schema_name,
     ar.module                            Client_Tool
FROM 
     gv$session_longops l, gv$sqlarea ar
WHERE 
     l.sql_id = ar.sql_id
AND  l.totalwork > 0
AND  ar.users_executing > 0
AND  l.sofar != l.totalwork;

-- To find Current running query
SELECT
     --'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||''''|| ' IMMEDIATE;' " ", 
     --'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||',@'||s.inst_id||''' IMMEDIATE;' " ",
     s.status,
     s.username,
     s.osuser,
     s.sid,
     s.serial#,
     t.sql_id,
     t.sql_text
FROM 
     gv$sqlarea t, gv$session s
WHERE 
     t.address = s.sql_address
AND  t.hash_value = s.sql_hash_value
AND  s.status IN  ('ACTIVE')
--AND  s.username IN ('RAS')
AND  s.username NOT IN (USER)
--AND  s.username  IN ('SYSTEM')

ORDER BY 
     s.sid;
                                                             
-- To find the query process time
SELECT
     --a.sql_text
     a.inst_id,
     a.first_load_time,
     a.elapsed_time,
     a.executions
     --,a.elapsed_time/executions  averagetime
FROM 
     gv$sqlarea a
WHERE 
     a.sql_id IN ('dkpwh7qhaxzm1');
--   a.sql_id IN (
--                SELECT 
--                     b.sql_id 
--                FROM 
--                     gv$sqlarea b
--                WHERE 
--                    regexp_like(UPPER(b.sql_text),'(INSERT|TEST)') 
--                AND b.parsing_schema_name = USER
--               );

-- To find disk intensive full table scans query
SELECT
     timestamp
     ,parsing_schema_name
	 ,operation
	 ,options 
     ,disk_reads
	 ,executions
     ,cpu_cost     
     ,io_cost
     ,sql_fulltext
	 --,sql_id
     --,inst_id
     --,module 
FROM (
	  SELECT 
	       disk_reads
	      ,executions
	      ,sql_id
	      ,sql_fulltext
	      ,operation
	      ,options
	      ,inst_id  
          ,cpu_cost 
          ,io_cost
          ,timestamp
          ,parsing_schema_name
          ,module
	      ,ROW_NUMBER() OVER (PARTITION BY sql_text ORDER BY disk_reads * executions DESC) keephighsql
	  FROM (
	       SELECT 
                AVG(disk_reads) OVER (PARTITION BY sql_text) disk_reads
	           ,MAX(executions) OVER (PARTITION BY sql_text) executions
	           ,t.sql_id
	           ,sql_text
	           ,sql_fulltext
	           ,p.operation
	           ,p.options
	  	       ,p.inst_id  
               ,p.cpu_cost 
               ,p.io_cost
               ,p.timestamp
               ,t.parsing_schema_name
               ,t.module
	       FROM 
                gv$sqlarea t, gv$sql_plan p
	       WHERE 
                t.hash_value = p.hash_value
	      AND p.operation IN ('TABLE ACCESS')
	      AND p.options = 'FULL'
	      AND NOT regexp_like(p.object_owner, '(^SYSTEM$|^SYSMAN$|^SYS$|^WMSYS$|^DBMS_SPACE$|^DBMS_WORKLOAD_REPOSITORY$|^DBSNMP$)')
	      AND t.executions > 1
          AND TRUNC(TIMESTAMP)=TO_DATE('19.12.2018','dd.mm.yyyy')
	      )
	  ORDER BY (disk_reads * executions) DESC
	   )
WHERE 
     keephighsql = 1
--AND  ROWNUM <= 10 
AND PARSING_SCHEMA_NAME <> 'RAS'
--AND PARSING_SCHEMA_NAME ='CENTRAL'
ORDER BY disk_reads DESC;



SELECT OWNER, JOB_NAME,START_DATE, END_DATE, ENABLED, STATE, RAISE_EVENTS FROM dba_scheduler_jobs WHERE owner = 'RAS' AND Upper(JOB_NAME) LIKE '%%';
SELECT * FROM dba_scheduler_running_jobs WHERE JOB_NAME ='RJB_RPR_SYNC_RAS_EPAYMENT';
SELECT * FROM dba_scheduler_job_run_details WHERE owner = 'RAS' AND job_name LIKE '%RJB_RPR_SYNC_RAS_EPAYMENT%' ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_job_run_details WHERE owner = 'VAT' AND job_name LIKE '%%' ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_job_run_details WHERE owner IN ('CENTRAL','HEALTHTAX','EDUCATIONTAX','VAT','ITAX','EIMSDB','RAS','TDS') AND job_name LIKE '%%' ORDER BY log_date DESC;


SELECT Count(*),owner,DEGREE FROM dba_tables GROUP BY owner,DEGREE ORDER BY 3 desc;
SELECT owner,table_name,DEGREE FROM dba_tables ORDER BY 3 DESC;

SELECT 'ALTER TABLE ras.'||TABLE_NAME||' PARALLEL 8;' " ", OWNER,TABLE_NAME,DEGREE FROM dba_tables WHERE table_name LIKE '%RTB%'
AND owner ='RAS'
AND table_name  IN ('RTB_SEARCH_MASTER','RTB_SEARCH_PARAMETERS','RTB_SEARCH_PARAMETERS_OPTIONS','RTB_CREDIT_DIRTY') 
AND DEGREE < 8;

BEGIN
DBMS_SCHEDULER.DISABLE(RJB_RPR_SYNC_RAS_EPAYMENT); 
END;
/

BEGIN
DBMS_SCHEDULER.STOP_JOB(RJB_RPR_SYNC_RAS_EPAYMENT); 
END;
/


