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

-- To add an integrity constants
ALTER TABLE heap_table ADD CONSTRAINT heap_table_pk PRIMARY KEY (user_id);

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
           
SELECT Count(*) row_count FROM ALL_ind_partitions WHERE index_name ='HEAP_TABLE_PK'; 
/*
ROW_COUNT
---------
        0
*/

-- To get the number of rows in data dictionary view
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

-- To fetch the records for the heap table
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

-- To fetch the records for the partition table
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

-- To Creating a partition table
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

EXEC dbms_redefinition.can_redef_table('DSHRIVASTAV', 'HEAP_TABLE');

EXEC dbms_redefinition.start_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

EXEC dbms_redefinition.finish_redef_table('DSHRIVASTAV', 'HEAP_TABLE', 'HEAP_TABLE_TEMP');

-- To drop the partition table permanently from database
DROP TABLE heap_table_temp PURGE;

-- To get the number of rows in data dictionary view
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

-- To fetch the records for the heap table
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

-- To fetch the records for the partition table
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
*/
       
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
*/
           
SELECT COUNT(*) row_count FROM ALL_ind_partitions WHERE index_name ='HEAP_TABLE_PK'; 
/*
ROW_COUNT
---------
        0
*/

INSERT INTO HEAP_TABLE
SELECT
     LEVEL user_id
FROM
     dual
CONNECT BY LEVEL <= 1000;
COMMIT;

-- To get the number of rows in data dictionary view
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

-- To fetch the records for the heap table
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

-- To fetch the records for the partition table
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

SELECT 'P_1' partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_1) UNION ALL
SELECT 'P_2' partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_3) UNION ALL
SELECT 'P_3' partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_3) UNION ALL
SELECT 'P_4' partition_name, COUNT(*) row_count FROM heap_table PARTITION (p_4) UNION ALL
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