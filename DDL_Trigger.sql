-- Create a Table tbl_ddl_log to Log DDL data  
DROP TABLE tbl_ddl_log purge;
CREATE TABLE tbl_ddl_log 
(
 ip_address         VARCHAR2(100),
 os_user            VARCHAR2(50),
 session_user       VARCHAR2(50),
 operation          VARCHAR2(30),
 obj_owner          VARCHAR2(30),
 object_name        VARCHAR2(30),
 attempt_by         VARCHAR2(30),
 attempt_dt         DATE,
 operation_time     TIMESTAMP,
 current_schema     VARCHAR2(50),
 db_name            VARCHAR2(50),
 is_dba             VARCHAR2(50),
 server_host        VARCHAR2(50),
 hosts              VARCHAR2(100),
 sql_text           VARCHAR2(4000),
 used_tool          VARCHAR2(500)
);

-- Grant neccesary Privilage to all database users
GRANT SELECT,INSERT ON tbl_ddl_log TO PUBLIC;

-- Create a Trigger trg_tbl_ddl_log to Log DDL data  
DROP TRIGGER trg_tbl_ddl_log;
CREATE OR REPLACE TRIGGER trg_tbl_ddl_log
BEFORE CREATE OR ALTER OR DROP OR TRUNCATE OR RENAME 
ON DATABASE
DECLARE
  oper     tbl_ddl_log.operation%TYPE;
  sql_text ora_name_list_t;
  i        PLS_INTEGER;
BEGIN
  --To Find the User Event
  SELECT ora_sysevent INTO oper FROM DUAL;

  --To Find the Executed Query
  i := sql_txt(sql_text);

  --To Log the DML Data
  INSERT INTO tbl_ddl_log
  SELECT
       SYS_CONTEXT('USERENV', 'IP_ADDRESS')       ip_address,
       SYS_CONTEXT('USERENV', 'OS_USER')          os_user,
       SYS_CONTEXT('USERENV', 'SESSION_USER')     session_user,
       ora_sysevent                               operation,
       ora_dict_obj_owner                         obj_owner,
       ora_dict_obj_name                          object_name,
       USER                                       attempt_by,
       SYSDATE                                    attempt_dt,
       SYSTIMESTAMP                               operation_time,
       SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')   current_schema,
       SYS_CONTEXT('USERENV', 'DB_NAME')          db_name,
       SYS_CONTEXT('USERENV', 'ISDBA')            is_dba,
       SYS_CONTEXT('USERENV', 'SERVER_HOST')      server_host,
       SYS_CONTEXT('USERENV', 'HOST')             hosts,
       sql_text(1)                                sql_text,
       SYS_CONTEXT('USERENV','MODULE')            used_tool
  FROM DUAL;

END trg_tbl_ddl_log;
/

-- To See the DDL Log
SELECT * FROM tbl_ddl_log;