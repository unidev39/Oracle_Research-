-- Option 1
DROP TABLE test5 PURGE;
CREATE TABLE test5
(
 c1 NUMBER
);

DROP TABLE test6 PURGE;
CREATE TABLE test6
(
   operation_type           VARCHAR2(50),
   object_name              VARCHAR2(50),
   operation                VARCHAR2(4000),
   operation_time           TIMESTAMP,
   session_user             VARCHAR2(50),
   current_schema           VARCHAR2(50),
   instance_name            VARCHAR2(50),
   db_name                  VARCHAR2(50),
   sid                      VARCHAR2(50),
   identification_type      VARCHAR2(50),
   instance                 VARCHAR2(50),
   isdba                    VARCHAR2(50),
   server_host              VARCHAR2(50),
   hosts                    VARCHAR2(50),
   ip_address               VARCHAR2(50),
   os_user                  VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER tr_test 
BEFORE INSERT OR UPDATE OR DELETE ON scott.test5
DECLARE
    l_sql VARCHAR2(32767);
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    l_sql := '      ''TEST5''                                          object_name,
	           		sql_text                                           operation,
                    SYSTIMESTAMP                                       operation_time,
                    SYS_CONTEXT(''USERENV'', ''SESSION_USER'')         session_user,
                    SYS_CONTEXT(''USERENV'', ''CURRENT_SCHEMA'')       current_schema,
                    SYS_CONTEXT(''USERENV'', ''INSTANCE_NAME'')        instance_name,
                    SYS_CONTEXT(''USERENV'', ''DB_NAME'')              db_name,
                    SYS_CONTEXT(''USERENV'', ''SID'')                  sid,
                    SYS_CONTEXT(''USERENV'', ''IDENTIFICATION_TYPE'')  identification_type,
                    SYS_CONTEXT(''USERENV'', ''INSTANCE'')             instance,
                    SYS_CONTEXT(''USERENV'', ''ISDBA'')                isdba,
                    SYS_CONTEXT(''USERENV'', ''SERVER_HOST'')          server_host,
                    SYS_CONTEXT(''USERENV'', ''HOST'')                 hosts,
                    SYS_CONTEXT(''USERENV'', ''IP_ADDRESS'')           ip_address,
                    SYS_CONTEXT(''USERENV'', ''OS_USER'')              os_user
               FROM 
                    sys.gv_$sqltext
               WHERE 
                   regexp_like(UPPER(sql_text),''(TEST5)'')';
    IF INSERTING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''INSERT''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(INSERT)'')';	 
    ELSIF UPDATING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''UPDATE''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(UPDATE)'')';
    ELSIF DELETING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''DELETE''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(DELETE)'')';
    END IF;
    COMMIT;
END tr_test;
/	

INSERT INTO test5 VALUES(1);
SELECT * FROM test5;

SELECT * FROM test6 ORDER BY operation_time DESC;

UPDATE test5 
SET c1 = 5;
SELECT * FROM test5;

SELECT * FROM test6 ORDER BY operation_time DESC;

DELETE FROM test5;
SELECT * FROM test5;

SELECT * FROM test6 ORDER BY operation_time DESC;


-- Option 2
DROP SYNONYM test5;
CREATE SYNONYM test5 for hr.test5;
SELECT * FROM test5;


DROP TABLE test6 PURGE;
CREATE TABLE test6
(
   operation_type           VARCHAR2(50),
   object_name              VARCHAR2(50),
   operation                VARCHAR2(4000),
   operation_time           TIMESTAMP,
   session_user             VARCHAR2(50),
   current_schema           VARCHAR2(50),
   instance_name            VARCHAR2(50),
   db_name                  VARCHAR2(50),
   sid                      VARCHAR2(50),
   identification_type      VARCHAR2(50),
   instance                 VARCHAR2(50),
   isdba                    VARCHAR2(50),
   server_host              VARCHAR2(50),
   hosts                    VARCHAR2(50),
   ip_address               VARCHAR2(50),
   os_user                  VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER tr_test 
BEFORE INSERT OR UPDATE OR DELETE ON test5
DECLARE
    l_sql VARCHAR2(32767);
	  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    l_sql := '      ''TEST5''                                          object_name,
	           		sql_text                                           operation,
                    SYSTIMESTAMP                                       operation_time,
                    SYS_CONTEXT(''USERENV'', ''SESSION_USER'')         session_user,
                    SYS_CONTEXT(''USERENV'', ''CURRENT_SCHEMA'')       current_schema,
                    SYS_CONTEXT(''USERENV'', ''INSTANCE_NAME'')        instance_name,
                    SYS_CONTEXT(''USERENV'', ''DB_NAME'')              db_name,
                    SYS_CONTEXT(''USERENV'', ''SID'')                  sid,
                    SYS_CONTEXT(''USERENV'', ''IDENTIFICATION_TYPE'')  identification_type,
                    SYS_CONTEXT(''USERENV'', ''INSTANCE'')             instance,
                    SYS_CONTEXT(''USERENV'', ''ISDBA'')                isdba,
                    SYS_CONTEXT(''USERENV'', ''SERVER_HOST'')          server_host,
                    SYS_CONTEXT(''USERENV'', ''HOST'')                 hosts,
                    SYS_CONTEXT(''USERENV'', ''IP_ADDRESS'')           ip_address,
                    SYS_CONTEXT(''USERENV'', ''OS_USER'')              os_user
               FROM 
                    sys.gv_$sqltext
               WHERE 
                   regexp_like(UPPER(sql_text),''(TEST5)'')';
    IF INSERTING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''INSERT''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(INSERT)'')';	 
    ELSIF UPDATING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''UPDATE''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(UPDATE)'')';
    ELSIF DELETING THEN
	   EXECUTE IMMEDIATE 'INSERT INTO test6
                          SELECT 
                               ''DELETE''     operation_type,
                               '||l_sql||'
                          AND regexp_like(UPPER(sql_text),''(DELETE)'')';
    END IF;
    COMMIT;
END tr_test;
/	

INSERT INTO hr.test5 VALUES(1);
SELECT * FROM hr.test5;

select * from test6 ORDER BY operation_time DESC;

UPDATE hr.test5 
SET c1 = 5;
SELECT * FROM test5;

select * from test6 ORDER BY operation_time DESC;

DELETE FROM hr.test5;
SELECT * FROM test5;

select * from test6 ORDER BY operation_time DESC;
