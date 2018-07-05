Converting a Non-Partitioned Table to a Partitioned Table along with data in Oracle.

A non-partitioned table can be converted to a partitioned table with a MODIFY clause added to the 
ALTER TABLE SQL statement with ONLINE key word in Oracle 12c Database.

But if we have a question if our Oracle Database has not been upgraded yet then how we can do the same?

Then it is essay way using Oracle inviled package dbms_redefinition.can_redef_table, dbms_redefinition.start_redef_table
and dbms_redefinition.finish_redef_table.

The Oracle online table reorganization package, (dbms_redefinition) is used to reorganize tables while they are accepting updates.
To solve the problem of doing table reorgs while the database accepts updates, Oracle9i has introduced
Online Table Redefinitions using the dbms_redefinition package.

The dbms_redefinition package allows you to copy a table (using CTAS), create a snapshot on the table,
enqueuer changes during the redefinition, and then re-synchronize the restructured table with the changes
that have accumulated during reorganization.

1.dbms_redefinition.can_redef_table is stands for to check the status of object structure.
2.dbms_redefinition.start_redef_table is stands for starts the process.
3.dbms_redefinition.finish_redef_table is stands for end the process.


-- To create bigfile tablespace for Warehouse Database 
CREATE BIGFILE TABLESPACE WAREHOUSE_BIGFILE_DATABASE 
DATAFILE '/u07/WAREHOUSE_BIGFILE_DATABASE.dbf'
SIZE 50g
AUTOEXTEND ON NEXT 500m MAXSIZE UNLIMITED
SEGMENT SPACE MANAGEMENT auto
NOLOGGING;

CREATE TEMPORARY TABLESPACE TEMP_WAREHOUSE_DATABASE 
TEMPFILE '/u07/TEMP_WAREHOUSE_DATABASE.dbf'
SIZE 10g
AUTOEXTEND ON
EXTENT MANAGEMENT LOCAL;

ALTER USER DSHRIVASTAV DEFAULT TABLESPACE WAREHOUSE_BIGFILE_DATABASE;
ALTER USER DSHRIVASTAV TEMPORARY TABLESPACE TEMP_WAREHOUSE_DATABASE;


-- To drop the heap table permanently from database (If the object exists)
DROP TABLE heap_table PURGE;

-- To Creating a heap table
CREATE TABLE heap_table
(
 user_id
)
TABLESPACE WAREHOUSE_DATABASE COMPRESS PARALLEL 
AS 
SELECT
     LEVEL user_id
FROM
     dual
CONNECT BY LEVEL <= 1000000;

BEGIN
   FOR i IN 1..7
   LOOP
      BEGIN 
          EXECUTE IMMEDIATE 'INSERT INTO heap_table
                             SELECT 
                                  (SELECT Max(user_id) FROM heap_table) + ROWNUM 
                             FROM heap_table';
          COMMIT;
      END;
   END LOOP;
END;
/

--Total execution time 03:07.319 (187.319 sec.)
SELECT 
     Count(DISTINCT user_id) distinct_user_id,
     Count(user_id) user_id
FROM 
    heap_table; 
/*
DISTINCT_USER_ID   USER_ID
---------------- --------- 
       128000000 128000000 
*/

-- To add an integrity constants (Required to pass the object status by dbms_redefinition.can_redef_table)
ALTER TABLE heap_table ADD CONSTRAINT heap_table_pk PRIMARY KEY (user_id);
-- Total execution time 06:45.756 (405.756 sec.)
-- To identify the status of Integrity constants which has been added on heap_table 
SELECT 
     owner,
     constraint_name,
     constraint_type,
     table_name,
     validated
FROM 
     all_constraints 
WHERE 
     table_name ='HEAP_TABLE';
/*
OWNER       CONSTRAINT_NAME CONSTRAINT_TYPE TABLE_NAME VALIDATED
----------- --------------- --------------- ---------- ---------
DSHRIVASTAV HEAP_TABLE_PK   P               HEAP_TABLE VALIDATED
*/

-- To identify the status of Index which is added on heap_table because the PK/UK integrity constants is responsible to create same named index as well
SELECT
     owner,
     index_name,
     index_type,
     table_owner,
     table_name,
     table_type,
     tablespace_name,
     status 
FROM 
     all_indexes 
WHERE
     table_name ='HEAP_TABLE';
/*
OWNER       INDEX_NAME    INDEX_TYPE TABLE_OWNER TABLE_NAME TABLE_TYPE TABLESPACE_NAME    STATUS
----------- ------------- ---------- ----------- ---------- ---------- ------------------ ------
DSHRIVASTAV HEAP_TABLE_PK NORMAL     DSHRIVASTAV HEAP_TABLE TABLE      WAREHOUSE_DATABASE VALID 
*/

-- To identify the status of integrity constants and Index which has been added on heap_table structure from partition Data Dictionary view
SELECT DISTINCT row_count
FROM (
      SELECT COUNT(*) row_count FROM all_ind_partitions WHERE index_name ='HEAP_TABLE_PK' UNION ALL
      SELECT COUNT(*) row_count FROM all_tab_partitions WHERE TABLE_name ='HEAP_TABLE'
     );
/*
ROW_COUNT
---------
        0
*/

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'HEAP_TABLE', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/
--Total execution time 03:45.957 (225.957 sec.)
-- To fetch the records for the heap table from the data dictionary view (all_tables)
SELECT
     owner,
     table_name,
     tablespace_name,
     status,
     num_rows
FROM 
     all_tables
WHERE
     table_name ='HEAP_TABLE';
/*
OWNER       TABLE_NAME TABLESPACE_NAME    STATUS NUM_ROWS
----------- ---------- ------------------ ------ ---------
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE  VALID 128000000
*/

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE
     table_name ='HEAP_TABLE';
/*
TABLE_OWNER TABLE_NAME TABLESPACE_NAME PARTITION_NAME PARTITION_POSITION NUM_ROWS
----------- ---------- --------------- -------------- ------------------ --------
*/

-- To drop the partition table permanently from database (If the object exists)
DROP table heap_table_temp PURGE;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
CREATE TABLE heap_table_temp
(
 user_id  NUMBER
)
PARTITION BY RANGE (user_id)
(
 PARTITION p_1000000 VALUES LESS THAN (1000000)  TABLESPACE WAREHOUSE_DATABASE,
 PARTITION p_2000000 VALUES LESS THAN (2000000)  TABLESPACE WAREHOUSE_DATABASE,
 PARTITION p_3000000 VALUES LESS THAN (3000000)  TABLESPACE WAREHOUSE_DATABASE,
 PARTITION p_4000000 VALUES LESS THAN (4000000)  TABLESPACE WAREHOUSE_DATABASE,
 PARTITION p_5000000 VALUES LESS THAN (5000000)  TABLESPACE WAREHOUSE_DATABASE,
 PARTITION p_max     VALUES LESS THAN (MAXVALUE) TABLESPACE WAREHOUSE_DATABASE
);
--Total execution time 328 ms

-- To check the staus of object structure.  -- Total execution time 580 ms
EXEC dbms_redefinition.can_redef_table('DSHRIVASTAV', 'HEAP_TABLE');
-- To starts the process of mapping  -- Total execution time 02:51.503 (171.503 sec.)
EXEC dbms_redefinition.start_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');
-- To end the process of mapping -- Total execution time 29.77 sec.
EXEC dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

-- To drop the partition table permanently from database (Because the table structure have been successfully mapped)
-- Total execution time 9.886 sec.
DROP TABLE heap_table_temp PURGE;

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'HEAP_TABLE', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/
--Total execution time 34:42.992 (2082.99 sec.)

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     partition_position,
     num_rows
FROM all_tab_partitions
WHERE table_name ='HEAP_TABLE';
/*
TABLE_OWNER TABLE_NAME TABLESPACE_NAME    PARTITION_NAME PARTITION_POSITION NUM_ROWS
----------- ---------- ------------------ -------------- ------------------ ---------
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_1000000                       1    999999
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_2000000                       2   1000000
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_3000000                       3   1000000
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_4000000                       4   1000000
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_5000000                       5   1000000
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE P_MAX                           6 123000001
*/

-- To identify the status of Integrity constants/Index which has been added on heap_table (Must be removed because that one is created for mapping process)
SELECT DISTINCT row_count
FROM (
      SELECT COUNT(*) row_count FROM all_constraints WHERE table_name ='HEAP_TABLE' UNION ALL
      SELECT COUNT(*) row_count FROM all_indexes WHERE TABLE_name ='HEAP_TABLE'
     );
/*
ROW_COUNT
---------
        0
*/
           
-- To identify the status of Index which has been added on heap_table structure (Not found because we don’t have create an Index on Partition table)
SELECT COUNT(*) row_count FROM all_ind_partitions WHERE index_name ='HEAP_TABLE_PK' ;
/*
ROW_COUNT
---------
        0
*/

-- DML operation over newly mapped object structure (Non-Partitioned/Heap Table to a Partitioned Table)
INSERT INTO HEAP_TABLE
SELECT
     LEVEL user_id
FROM
     dual
CONNECT BY LEVEL <= 10000;
COMMIT;

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'HEAP_TABLE', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions - successfully Conversion of partition table structure)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE 
     table_name ='HEAP_TABLE';
/*
TABLE_OWNER TABLE_NAME TABLESPACE_NAME PARTITION_NAME PARTITION_POSITION NUM_ROWS
----------- ---------- --------------- -------------- ------------------ --------
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE    P_1                             1      198
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE    P_2                             2      200
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE    P_3                             3      200
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE    P_4                             4      200
DSHRIVASTAV HEAP_TABLE WAREHOUSE_DATABASE    P_MAX                           5     1202
*/

-- To fetch the records - partition specific
SELECT 'P_1'   partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_1) UNION ALL
SELECT 'P_2'   partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_3) UNION ALL
SELECT 'P_3'   partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_3) UNION ALL
SELECT 'P_4'   partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_4) UNION ALL
SELECT 'P_MAX' partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_max); 
/*
PARTITION_NAME ROW_COUNT
-------------- ---------
P_1                  198
P_2                  200
P_3                  200
P_4                  200
P_MAX               1202
*/

-------------------------
DECLARE
    l_sql           VARCHAR2(32767) := '';
    l_sql_partitons VARCHAR2(32767) := '';
BEGIN
    l_sql := 'CREATE TABLE heap_table_temp'||Chr(10)||'('||Chr(10)||'user_id  NUMBER'||Chr(10)||')'||Chr(10)||'PARTITION BY RANGE (user_id)'||Chr(10)||'(';

    FOR i_data IN (SELECT 1000000 user_id FROM dual UNION
                   SELECT 2000000 user_id FROM dual UNION
                   SELECT 3000000 user_id FROM dual UNION
                   SELECT 4000000 user_id FROM dual UNION
                   SELECT 5000000 user_id FROM dual)
    LOOP
       BEGIN
           l_sql_partitons := Chr(10)||'PARTITION p_'||i_data.user_id||' VALUES LESS THAN ('||i_data.user_id||')  TABLESPACE WAREHOUSE_DATABASE,'||Chr(10)||'';
           l_sql := l_sql||Chr(10)||l_sql_partitons;
       END;
    END LOOP;
    l_sql := l_sql||Chr(10)||'PARTITION p_max   VALUES LESS THAN (MAXVALUE) TABLESPACE WAREHOUSE_DATABASE'||Chr(10)||')';

    -- To Creating a temporary partition table to mapped the object structure with non-partition table
    EXECUTE IMMEDIATE l_sql;

    -- To check the staus of object structure.
    dbms_redefinition.can_redef_table('DSHRIVASTAV', 'HEAP_TABLE');

    -- To starts the process of mapping
    dbms_redefinition.start_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

    -- To end the process of mapping
    dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

    -- To drop the partition table permanently from database (Because the table structure have been successfully mapped)
    EXECUTE IMMEDIATE 'DROP TABLE dshrivastav.heap_table_temp PURGE';
END;
/

Converting a Partitioned Table to a Non-Partitioned Table in Oracle

-- To drop the partition table permanently from database (If the object exists)
DROP table ra_partition PURGE;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
CREATE TABLE ra_partition
(
 user_id  NUMBER
)
PARTITION BY RANGE (user_id)
(
 PARTITION p_1   VALUES LESS THAN (1000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_2   VALUES LESS THAN (2000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_3   VALUES LESS THAN (3000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_4   VALUES LESS THAN (4000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_5   VALUES LESS THAN (5000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_max VALUES LESS THAN (MAXVALUE) TABLESPACE WAREHOUSE_BIGFILE_DATABASE
);

INSERT INTO ra_partition
SELECT
     LEVEL user_id
FROM
     dual
CONNECT BY LEVEL <= 1000000;
COMMIT;

BEGIN
   FOR i IN 1..7
   LOOP
      BEGIN 
          EXECUTE IMMEDIATE 'INSERT INTO ra_partition
                             SELECT 
                                  (SELECT Max(user_id) FROM ra_partition) + ROWNUM 
                             FROM ra_partition';
          COMMIT;
      END;
   END LOOP;
END;
/
COMMIT;

ALTER TABLE ra_partition ADD CONSTRAINT pk_ra_partition PRIMARY KEY (user_id);

SELECT Count(DISTINCT user_id) user_id FROM ra_partition;
/*
USER_ID
---------
128000000
*/

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RA_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE
     table_name ='RA_PARTITION';
/*
TABLE_OWNER TABLE_NAME   TABLESPACE_NAME            PARTITION_NAME HIGH_VALUE PARTITION_POSITION  NUM_ROWS
----------- ------------ -------------------------- -------------- ---------- ------------------ ---------
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_1            1000000                     1    999999
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_2            2000000                     2   1000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_3            3000000                     3   1000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_4            4000000                     4   1000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_5            5000000                     5   1000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_MAX          MAXVALUE                    6 123000001
*/

DROP TABLE ra_non_partition PURGE;

CREATE TABLE ra_non_partition
(
 user_id NUMBER 
)
TABLESPACE WAREHOUSE_BIGFILE_DATABASE;


EXEC Dbms_Redefinition.Can_Redef_Table('DSHRIVASTAV', 'RA_PARTITION');
--Total execution time 1.424 sec.
exec dbms_redefinition.start_redef_table('DSHRIVASTAV','RA_PARTITION','RA_NON_PARTITION');
--Total execution time 01:24.743 (84.743 sec.)
EXEC dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'RA_PARTITION', 'RA_NON_PARTITION');
--Total execution time 3.891 sec.

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RA_NON_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE
     table_name IN ('RA_PARTITION','RA_NON_PARTITION');
/*
TABLE_OWNER TABLE_NAME       TABLESPACE_NAME            PARTITION_NAME PARTITION_POSITION  NUM_ROWS
----------- ---------------- -------------------------- -------------- ------------------ ---------
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_1                             1    999999
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_2                             2   1000000
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_3                             3   1000000
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_4                             4   1000000
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_5                             5   1000000
DSHRIVASTAV RA_NON_PARTITION WAREHOUSE_BIGFILE_DATABASE P_MAX                           6 123000001
*/

-- To get the number of rows in data dictionary view (all_tables/all_tab_partitions)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RA_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/
--Total execution time 16:43.955 (1003.96 sec.)

Here we can see that the partition table converted into Non - Partition table
SELECT
     owner,
     table_name,
     tablespace_name,
     status,
     num_rows
FROM 
     all_tables
WHERE
     table_name IN ('RA_PARTITION','RA_NON_PARTITION');
/*
OWNER       TABLE_NAME       TABLESPACE_NAME            STATUS  NUM_ROWS
----------- ---------------- -------------------------- ------ ---------
DSHRIVASTAV RA_PARTITION     WAREHOUSE_BIGFILE_DATABASE VALID  128000000
DSHRIVASTAV RA_NON_PARTITION                            VALID  128000000
*/

Hence, we can convert the Improper Partitioned Table to a proper Partitioned Table along with data in Oracle.

Converting a Improper Partitioned Table to a proper Partitioned Table along with data in Oracle.

-- To drop the partition table permanently from database (If the object exists)
DROP TABLE dshrivastav.ra_partition PURGE;

-- Create table, executed in 854 ms
CREATE TABLE dshrivastav.ra_partition
(
 user_id  NUMBER
)
PARTITION BY RANGE (user_id)
(
 PARTITION p_1   VALUES LESS THAN (10000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_2   VALUES LESS THAN (20000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_3   VALUES LESS THAN (30000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_4   VALUES LESS THAN (40000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_5   VALUES LESS THAN (50000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_max VALUES LESS THAN (MAXVALUE) TABLESPACE WAREHOUSE_BIGFILE_DATABASE
);

-- Total execution time 03:47.370 (227.37 sec.)
BEGIN
   EXECUTE IMMEDIATE 'INSERT INTO dshrivastav.ra_partition
                      SELECT
                           LEVEL user_id
                      FROM
                           dual
                      CONNECT BY LEVEL <= 1000000';
   COMMIT;
   FOR i IN 1..7
   LOOP
      BEGIN 
          EXECUTE IMMEDIATE 'INSERT INTO dshrivastav.ra_partition
                             SELECT 
                                  (SELECT Max(user_id) FROM dshrivastav.ra_partition) + ROWNUM 
                             FROM dshrivastav.ra_partition';
          COMMIT;
      END;
   END LOOP;
   COMMIT;
END;
/

--Total execution time 10:43.978 (643.978 sec.)
ALTER TABLE dshrivastav.ra_partition ADD CONSTRAINT pk_ra_partition PRIMARY KEY (user_id);

-- Total execution time 25:55.423 (1555.42 sec.)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RA_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

SELECT COUNT(DISTINCT user_id) user_id FROM dshrivastav.ra_partition;
/*
  USER_ID
---------
128000000
*/

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE
     table_name IN ('RA_PARTITION');
/*
TABLE_OWNER TABLE_NAME   TABLESPACE_NAME            PARTITION_NAME HIGH_VALUE PARTITION_POSITION NUM_ROWS
----------- ------------ -------------------------- -------------- ---------- ------------------ --------
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_1            10000000                    1  9999999
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_2            20000000                    2 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_3            30000000                    3 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_4            40000000                    4 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_5            50000000                    5 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_MAX          MAXVALUE                    6 78000001
*/

-- To Creating a temporary partition table to mapped the object structure with non-partition table
-- Create table, executed in 1.182 sec.
CREATE TABLE dshrivastav.ra_partition_temp
(
 user_id  NUMBER
)
PARTITION BY RANGE (user_id)
(
 PARTITION p_1    VALUES LESS THAN (10000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_2    VALUES LESS THAN (20000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_3    VALUES LESS THAN (30000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_4    VALUES LESS THAN (40000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_5    VALUES LESS THAN (50000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_6    VALUES LESS THAN (60000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_7    VALUES LESS THAN (70000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_8    VALUES LESS THAN (80000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_9    VALUES LESS THAN (90000000)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_10   VALUES LESS THAN (100000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_11   VALUES LESS THAN (110000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_12   VALUES LESS THAN (120000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_13   VALUES LESS THAN (130000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_14   VALUES LESS THAN (140000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_15   VALUES LESS THAN (150000000) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION p_max  VALUES LESS THAN (MAXVALUE)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE
);

-- Total execution time 1.71 sec.
EXEC Dbms_Redefinition.Can_Redef_Table('DSHRIVASTAV', 'RA_PARTITION');

-- Total execution time 02:20.744 (140.744 sec.)
EXEC dbms_redefinition.start_redef_table('DSHRIVASTAV','RA_PARTITION','RA_PARTITION_TEMP');

-- Total execution time 6.34 sec.
EXEC dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'RA_PARTITION', 'RA_PARTITION_TEMP');

ALTER TABLE dshrivastav.ra_partition DROP CONSTRAINT pk_ra_partition;
--ORA-02443: Cannot drop constraint  - nonexistent constraint

-- Total execution time 8.16 sec.
DROP TABLE dshrivastav.ra_partition_temp PURGE; 

-- Total execution time 11:12.354 (672.354 sec.)
ALTER TABLE dshrivastav.ra_partition ADD CONSTRAINT pk_ra_partition PRIMARY KEY (user_id);

-- Total execution time 06:07.500 (367.5 sec.)
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RA_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/
--Total execution time 10.081 sec.

-- To fetch the records for the partition table from the data dictionary view (all_tab_partitions)
SELECT
     table_owner,
     table_name,
     tablespace_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE
     table_name IN ('RA_PARTITION');
/*
TABLE_OWNER TABLE_NAME   TABLESPACE_NAME            PARTITION_NAME HIGH_VALUE PARTITION_POSITION NUM_ROWS
----------- ------------ -------------------------- -------------- ---------- ------------------ --------
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_1            10000000                    1  9999999
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_2            20000000                    2 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_3            30000000                    3 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_4            40000000                    4 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_5            50000000                    5 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_6            60000000                    6 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_7            70000000                    7 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_8            80000000                    8 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_9            90000000                    9 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_10           100000000                  10 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_11           110000000                  11 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_12           120000000                  12 10000000
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_13           130000000                  13  8000001
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_14           140000000                  14        0
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_15           150000000                  15        0
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_MAX          MAXVALUE                   16        0
*/

                                                                                                            
SELECT 'P_1'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_1)  UNION ALL   
SELECT 'P_2'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_2)  UNION ALL   
SELECT 'P_3'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_3)  UNION ALL   
SELECT 'P_4'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_4)  UNION ALL   
SELECT 'P_5'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_5)  UNION ALL   
SELECT 'P_6'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_6)  UNION ALL   
SELECT 'P_7'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_7)  UNION ALL   
SELECT 'P_8'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_8)  UNION ALL   
SELECT 'P_9'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_9)  UNION ALL   
SELECT 'P_10'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_10) UNION ALL 
SELECT 'P_11'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_11) UNION ALL 
SELECT 'P_12'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_12) UNION ALL 
SELECT 'P_13'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_13) UNION ALL 
SELECT 'P_14'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_14) UNION ALL 
SELECT 'P_15'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_15) UNION ALL 
SELECT 'P_MAX' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_MAX); 
/*
PARTITION_NAME DATA_COUNT
-------------- ----------
P_1               9999999
P_2              10000000
P_3              10000000
P_4              10000000
P_5              10000000
P_6              10000000
P_7              10000000
P_8              10000000
P_9              10000000
P_10             10000000
P_11             10000000
P_12             10000000
P_13              8000001
P_14                    0
P_15                    0
P_MAX                   0
*/

SELECT 
     CASE 
        WHEN SUM(a.data_count) =  128000000 THEN 'PASS' 
     ELSE
        'FAIL'
     END data_validation
FROM (
      SELECT 'P_1'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_1)  UNION ALL   
      SELECT 'P_2'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_2)  UNION ALL   
      SELECT 'P_3'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_3)  UNION ALL   
      SELECT 'P_4'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_4)  UNION ALL   
      SELECT 'P_5'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_5)  UNION ALL   
      SELECT 'P_6'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_6)  UNION ALL   
      SELECT 'P_7'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_7)  UNION ALL   
      SELECT 'P_8'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_8)  UNION ALL   
      SELECT 'P_9'   partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_9)  UNION ALL   
      SELECT 'P_10'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_10) UNION ALL 
      SELECT 'P_11'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_11) UNION ALL 
      SELECT 'P_12'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_12) UNION ALL 
      SELECT 'P_13'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_13) UNION ALL 
      SELECT 'P_14'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_14) UNION ALL 
      SELECT 'P_15'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_15) UNION ALL 
      SELECT 'P_MAX' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_MAX)
     ) a; 
/*
DATA_VALIDATION
---------------
PASS           
*/

SELECT
     owner,
     index_name,
     index_type,
     table_owner,
     table_name,
     table_type,
     uniqueness,
     tablespace_name,
     status,
     num_rows,
     visibility
FROM 
     all_indexes 
WHERE
     table_name = 'RA_PARTITION'
AND  index_name = 'PK_RA_PARTITION';

/*
OWNER       INDEX_NAME      INDEX_TYPE TABLE_OWNER TABLE_NAME   TABLE_TYPE UNIQUENESS TABLESPACE_NAME            STATUS  NUM_ROWS VISIBILITY
----------- --------------- ---------- ----------- ------------ ---------- ---------- -------------------------- ------ --------- ----------
DSHRIVASTAV PK_RA_PARTITION NORMAL     DSHRIVASTAV RA_PARTITION TABLE      UNIQUE     WAREHOUSE_BIGFILE_DATABASE VALID  128000000 VISIBLE   
*/

SELECT
     owner,
     constraint_name,
     constraint_type,
     table_name,
     status,
     validated,
     index_owner,
     index_name
FROM 
     all_constraints 
WHERE
     table_name = 'RA_PARTITION'
AND  index_name = 'PK_RA_PARTITION';
/*
OWNER       CONSTRAINT_NAME CONSTRAINT_TYPE TABLE_NAME   STATUS  VALIDATED INDEX_OWNER INDEX_NAME
----------- --------------- --------------- ------------ ------- --------- ----------- ---------------     
DSHRIVASTAV PK_RA_PARTITION P               RA_PARTITION ENABLED VALIDATED DSHRIVASTAV PK_RA_PARTITION
*/


SELECT DISTINCT 
     CASE 
        WHEN row_count = 0 THEN 'PASS'
     ELSE
        'FAIL'
     END object_validation
FROM 
   (
    SELECT COUNT(*) row_count FROM all_mviews    WHERE (owner = 'DSHRIVASTAV' AND mview_name = 'RA_PARTITION') UNION ALL
    SELECT COUNT(*) row_count FROM all_views     WHERE (owner = 'DSHRIVASTAV' AND view_name  = 'RA_PARTITION') UNION ALL
    SELECT COUNT(*) row_count FROM all_synonyms  WHERE (owner = 'DSHRIVASTAV' AND table_name = 'RA_PARTITION')
    );
/*
OBJECT_VALIDATION
-----------------
PASS             
*/
