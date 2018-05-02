--Converting a Non-Partitioned Table to a Partitioned Table in Oracle

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

-- To drop the heap table permanently from database (If the object exists)
DROP TABLE heap_table PURGE;

-- To Creating a heap table
CREATE TABLE heap_table
(
 user_id
) 
AS 
SELECT
     LEVEL user_id
FROM
     dual
CONNECT BY LEVEL <= 1000;

-- To add an integrity constants (Required to pass the object status by dbms_redefinition.can_redef_table)
ALTER TABLE heap_table ADD CONSTRAINT heap_table_pk PRIMARY KEY (user_id);

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
OWNER       INDEX_NAME    INDEX_TYPE TABLE_OWNER TABLE_NAME TABLE_TYPE TABLESPACE_NAME STATUS
----------- ------------- ---------- ----------- ---------- ---------- --------------- ------
DSHRIVASTAV HEAP_TABLE_PK NORMAL     DSHRIVASTAV HEAP_TABLE TABLE      TABLE_BACKUP    VALID 
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
OWNER       TABLE_NAME TABLESPACE_NAME STATUS NUM_ROWS
----------- ---------- --------------- ------ --------
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    VALID      1000
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
DROP table heap_table_temp purge;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
CREATE TABLE heap_table_temp
(
 user_id  NUMBER
)
PARTITION BY RANGE (user_id)
(
 PARTITION p_1     VALUES LESS THAN (100),
 PARTITION p_2     VALUES LESS THAN (200),
 PARTITION p_3     VALUES LESS THAN (300),
 PARTITION p_4     VALUES LESS THAN (400),
 PARTITION p_max   VALUES LESS THAN (MAXVALUE)
);

-- To check the staus of object structure.
EXEC dbms_redefinition.can_redef_table('DSHRIVASTAV', 'HEAP_TABLE');
-- To starts the process of mapping
EXEC dbms_redefinition.start_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');
-- To end the process of mapping
EXEC dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

-- To drop the partition table permanently from database (Because the table structure have been successfully mapped)
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

-- To fetch the records for the heap table from the data dictionary view (all_tables)
SELECT
     owner,
     table_name,
     tablespace_name,
     status,
     num_rows
FROM all_tables
WHERE table_name ='HEAP_TABLE';
/*
OWNER       TABLE_NAME TABLESPACE_NAME STATUS NUM_ROWS
----------- ---------- --------------- ------ --------
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    VALID      1000
*/

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
TABLE_OWNER TABLE_NAME TABLESPACE_NAME PARTITION_NAME PARTITION_POSITION NUM_ROWS
----------- ---------- --------------- -------------- ------------------ --------
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_1                             1       99
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_2                             2      100
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_3                             3      100
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_4                             4      100
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_MAX                           5      601
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
SELECT COUNT(*) row_count FROM all_ind_partitions WHERE index_name ='HEAP_TABLE_PK'
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
CONNECT BY LEVEL <= 1000;
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

-- To fetch the records for the heap table from the data dictionary view (This one is still exists in all_tables like as metalized views)
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
OWNER       TABLE_NAME TABLESPACE_NAME STATUS NUM_ROWS
----------- ---------- --------------- ------ --------
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    VALID      2000
*/

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
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_1                             1      198
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_2                             2      200
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_3                             3      200
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_4                             4      200
DSHRIVASTAV HEAP_TABLE TABLE_BACKUP    P_MAX                           5     1202
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
