LOCKED_MODE

Lock mode. The numeric values for this column map to these text values for the lock modes for table locks:

  0 - NONE: lock requested but not yet obtained
  1 - NULL
  2 - ROWS_S (SS): Row Share Lock
  3 - ROW_X (SX): Row Exclusive Table Lock
  4 - SHARE (S): Share Table Lock
  5 - S/ROW-X (SSX): Share Row Exclusive Table Lock
  6 - Exclusive (X): Exclusive Table Lock
  
Table Locks (TM)
A table lock, also called a TM lock, is acquired by a transaction when a table is modified by an INSERT, UPDATE, DELETE, MERGE, SELECT with the FOR UPDATE 
clause, or LOCK TABLE statement. DML operations require table locks to reserve DML access to the table on behalf of a transaction and to prevent 
DDL operations that would conflict with the transaction.

A table lock can be held in any of the following modes:

2 => Row Share (RS) : This lock, also called a subshare table lock (SS), indicates that the transaction holding the lock on the table has locked rows in 
                      the table and intends to update them. A row share lock is the least restrictive mode of table lock, offering the highest degree of 
                      concurrency for a table.

3 => Row Exclusive Table Lock (RX) : This lock, also called a subexclusive table lock (SX), generally indicates that the transaction holding the lock has 
                                     updated table rows or issued SELECT ... FOR UPDATE. An SX lock allows other transactions to query, insert, update, 
                                     delete, or lock rows concurrently in the same table. Therefore, SX locks allow multiple transactions to obtain 
                                     simultaneous SX and subshare table locks for the same table.

4 => Share Table Lock (S) : A share table lock held by a transaction allows other transactions to query the table (without using SELECT ... FOR UPDATE), 
                            but updates are allowed only if a single transaction holds the share table lock. Because multiple transactions may hold a 
                            share table lock concurrently, holding this lock is not sufficient to ensure that a transaction can modify the table.

5 => Share Row Exclusive Table Lock (SRX) : This lock, also called a share-subexclusive table lock (SSX), is more restrictive than a share table lock. 
                                            Only one transaction at a time can acquire an SSX lock on a given table. An SSX lock held by a transaction 
                                            allows other transactions to query the table (except for SELECT ... FOR UPDATE) but not to update the table.

6 => Exclusive Table Lock (X) : This lock is the most restrictive, prohibiting other transactions from performing any type of DML statement or placing 
                                any type of lock on the table.

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
           v$locked_object a
     ) lo 
     JOIN
     (
      SELECT
           b.object_id,
           b.owner,
           b.object_name,
           b.object_type
      FROM
           dba_objects b
     ) ob
ON (lo.object_id = ob.object_id);
--AND lo.oracle_username = 'HR';

-- OR --

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

SELECT 
     'ALTER SYSTEM KILL SESSION '''||s1.sid||','||s1.serial#||''''|| 'IMMEDIATE;'                                         querytokillsession,
     s1.username||'@'||s1.machine||'(SID='||s1.sid||')  is blocking '||s2.username||'@'||s2.machine||'(SID='||s2.sid||')' blocking_status,
     s1.last_call_et/60,
     s2.last_call_et/60,
     s1.status,
     l1.block,
     l2.request,
     d.object_name
FROM 
     v$lock l1,v$session s1,v$lock l2,v$session s2,dba_objects d
WHERE 
     s1.sid = l1.sid
AND  s2.sid = l2.sid 
AND  l1.block = 1
AND  l2.request > 0
AND  l1.id1 = l2.id1
AND  l2.id2 = l2.id2 
AND  d.object_name = 'EMPLOYEES';

ALTER TABLE hr.employees DISABLE TABLE LOCK;
ALTER TABLE hr.employees ENABLE TABLE LOCK;
LOCK TABLE hr.employees IN EXCLUSIVE MODE WAIT 6000;

-- To find the query process time
SELECT 
     a.* 
FROM 
     v$session a
WHERE 
     a.sql_id IN (
                  SELECT 
                       b.sql_id 
                  FROM 
                       v$sqlarea b
                  WHERE 
                       b.sql_text LIKE '%INSERT%TEST%'
                 );

SELECT
     a.sql_text,
     a.first_load_time,
     a.elapsed_time,
     a.executions,
     a.elapsed_time/executions  averagetime
FROM 
     v$sql a
WHERE 
     a.sql_id IN (
                  SELECT 
                       b.sql_id 
                  FROM 
                       v$sqlarea b
                  WHERE 
                      regexp_like(UPPER(b.sql_text),'(INSERT|TEST)') 
                  AND b.parsing_schema_name = USER
                 );

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

-- OR --

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
     v$session_longops l, v$sqlarea ar
WHERE 
     l.sql_id = ar.sql_id
AND  l.totalwork > 0
AND  ar.users_executing > 0
AND  l.sofar != l.totalwork;

-- To find Current running query
SELECT 
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
AND  s.status = 'ACTIVE'
AND  s.username NOT IN ('SYSTEM',USER)
ORDER BY 
     s.sid;
     
-- OR --

SELECT 
     s.username,
     s.osuser,
     s.sid,
     s.serial#,
     t.sql_id,
     t.piece,
     t.sql_text
FROM 
     v$sqltext_with_newlines t, v$session s
WHERE 
     t.address = s.sql_address
AND  t.hash_value = s.sql_hash_value
AND  s.status = 'ACTIVE'
AND  s.username NOT IN ('SYSTEM',USER)
ORDER BY 
     s.sid,
     t.piece;
-- OR --
SELECT
     'exec kill_my_session('''||s.sid||''', '''||s.serial#||''', '''||s.inst_id||''') ;' kill_my_session,
     s.inst_id,
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
AND  s.status = 'ACTIVE'
AND  s.username IN ('DSHRIVASTAV') 
--AND t.sql_text NOT LIKE 'SELECT%'
ORDER BY 
     s.sid;

-- To find the blocking session
SELECT
     blocking_session
    ,sid
    ,serial#
    ,wait_class
    ,seconds_in_wait
FROM
    gv$session
WHERE
    blocking_session IS NOT NULL
ORDER BY
    blocking_session;
    
-- To find the degree of table
SELECT 
     a.table_name, 
     a.degree 
FROM 
     dba_tables a 
WHERE
     a.owner = USER
AND  a.table_name = 'EMPLOYEES'; 


--To required degree for a table used while gather stats 
SELECT
     a.value                       orginal_value,
     CASE 
        WHEN a.value/2 < 1 THEN 1 
     ELSE 
        TRUNC(a.value/2) END       degree_for_gather_stats
FROM
     v$parameter a
WHERE
     UPPER(a.name) = 'CPU_COUNT';

-- To gather_table_stats
-- Note: Default => p_estimatepercent value is 0
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => p_owner_name,
     tabname          => p_table_name, 
     estimate_percent => p_estimatepercent,
     cascade          => TRUE,
     degree           => degree_for_gather_stats, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To Create Scheduler Jobs
BEGIN
    dbms_scheduler.create_job(
    job_name        => 'JOB_NAME_ANY',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN PROCEDURE_NAME; END; ',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY; BYHOUR=9; BYMINUTE=0; BYSECOND=0',
    --repeat_interval => 'FREQ=HOURLY; BYMINUTE=0',
    --repeat_interval => 'FREQ=WEEKLY; BYDAY=MON; BYHOUR=9; BYMINUTE=30; BYSECOND=0;'
    --repeat_interval => 'FREQ=MINUTELY; BYSECOND=0',
    --repeat_interval => 'TRUNC(SYSTIMESTAMP,''MI'')+5/24/60',
    enabled         => TRUE,
    comments        => 'Execute The JOB_NAME_ANY.');
END;
/


-- Verification Script
/*
SELECT 
     a.owner,
     a.job_name,
     a.start_date,
     a.enabled, 
     a.state 
FROM 
     dba_scheduler_jobs a
WHERE 
     a.owner = 'HR'
AND  UPPER(a.job_name) = 'JOB_NAME_ANY';

OWNER JOB_NAME     START_DATE                     ENABLED STATE
----- ------------ ------------------------------ ------- ---------
HR    JOB_NAME_ANY 18.06.2015 09:54:53.725 +05:30 TRUE    SCHEDULED


SELECT 
     a.job_name,
     a.status,
     a.error# 
FROM 
     dba_scheduler_job_run_details a
WHERE 
     a.owner = 'HR'
AND UPPER(a.job_name) = 'JOB_NAME_ANY';

JOB_NAME     STATUS    ERROR#
------------ --------- ---------
JOB_NAME_ANY SUCCEEDED 0

*/

-- To Drop Scheduler Jobs
BEGIN
    -- To Stop a Job
    BEGIN
        DBMS_SCHEDULER.STOP_JOB(job_name=>'HR.JOB_NAME_ANY', force=>true);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;

    -- To Drop a Job
    BEGIN
        DBMS_SCHEDULER.DROP_JOB ('HR.JOB_NAME_ANY');
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;

    -- To Empty the Logs
    BEGIN
        DBMS_SCHEDULER.PURGE_LOG(JOB_NAME => 'HR.JOB_NAME_ANY');
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;
END;
/



BEGIN
    FOR i IN (SELECT 
                   'ALTER SYSTEM KILL SESSION '''||a.sid||','||a.serial#||''' IMMEDIATE;' col_1
              FROM 
                   v$session a
              WHERE 
                   UPPER(a.username) IN ('HR','SCOTT'))
    LOOP
       BEGIN
           EXECUTE IMMEDIATE (i.col_1);
           COMMIT;
       EXCEPTION WHEN OTHERS THEN
           EXECUTE IMMEDIATE (i.col_1);
           COMMIT;
       END;
    END LOOP;
END;
/

explain plan for select * from dual;
select * from table(dbms_xplan.display);

ALTER USER radm IDENTIFIED BY <<New_Password>> REPLACE <<Old_Password>>;

1. scp /home/oracle/dumps/hr_20120418.dmp oracle@127.1.1.0:/home/oracle/dumps/
2. scp /home/oracle/dumps/scott_20120418.dmp oracle@127.1.1.0:/home/oracle/dumps/

-- Improt
1.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr_20120418.dmp logfile=hr_20120418.log
2.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr_09042013.dmp logfile=hr_09042013.log remap_schema=hr:hr remap_tablespace=hr:hr
3.
impdp sys/oracle TABLES=hr.employees directory=DUMP_DIR dumpfile=hr_09042013.dmp logfile=hr_09042013_1.log remap_schema=hr:hr remap_tablespace=hr:hr
4.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr_09042013.dmp logfile=hr1_09042013.log remap_schema=hr:hr1 remap_tablespace=hr:hr1
5.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr1.dmp logfile=hr1.log remap_schema=hr:hr1 remap_tablespace=hr:hr1 CONTENT=ALL
6.
impdp hr/oracle directory = DIR_EXPORT dumpfile = ORACLE_0.DMP logfile= implog.log remap_schema = ORACLE:hr remap_tablespace = ORACLE:ORACLE 
7.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr.dmp logfile=hr.log remap_schema=scott:hr remap_tablespace=scott:hr INCLUDE=VIEW,PACKAGE,PACKAGE BODY,FUNCTION,PROCEDURE,TRIGGER,INDEX,TABLE,LOB,DATABASE LINK,JAVA CLASS,JAVA SOURCE,JOB,MATERIALIZED VIEW,SCHEDULE,SEQUENCE,SYNONYM,TYPE,TYPE BODY 
8.
impdp sys/oracle directory=DUMP_DIR dumpfile=hr.dmp logfile=hr.log remap_schema=scott:hr remap_tablespace=scott:hr INCLUDE=TYPE,TYPE BODY

--Exprot
1.
expdp hr/oracle schemas=hr directory=DUMP_DIR dumpfile=hr.dmp logfile=hr.Log
2.
expdp hr/oracle schemas=hr directory=dumps_dir dumpfile=hr_04_05_2013.dmp logfile=hr_04_05_2013.log version=11.2 content=all
3.
expdp scott/oracle schemas=scott directory=DUMP_DIR dumpfile=hr.dmp logfile=hr.Log CONTENT=ALL
4.
expdp sys/oracle DIRECTORY=dump_dir DUMPFILE=sys.dmp logfile=sys.log INCLUDE=VIEW,PACKAGE,PACKAGE BODY,FUNCTION,PROCEDURE,TRIGGER,INDEX
5.
expdp sys/oracle schemas=hr include=TABLE:"like ('EMP%', 'DPT%')" directory=TEST_DIR dumpfile=hr.dmp logfile=expdpscott.log
6.
expdp scott/tiger@db10g schemas=SCOTT exclude=TABLE:"= 'BONUS'" directory=TEST_DIR dumpfile=SCOTT.dmp logfile=expdpscott.log
7.
expdp test/test@db10g tables=SCOTT.EMP network_link=REMOTE_SCOTT directory=TEST_DIR dumpfile=EMP.dmp logfile=expdpEMP.log
8. 
expdp sys/oracle DIRECTORY=pm_data_dump DUMPFILE=pm_tables_exp_071411.dmp SCHEMAS=hr INCLUDE=TABLE:\"like \'PM%\'\" INCLUDE=SEQUENCE:\"like\'PM%\'\" INCLUDE=PROCEDURE logfile=pm_tables_exp_071411.log
