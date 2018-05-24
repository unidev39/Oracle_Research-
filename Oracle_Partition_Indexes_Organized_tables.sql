Partition Indexes Organized tables

There are two basic types of partitioned index.

Local -  All index entries in a single partition will correspond to a single table partition (equipartitioned). 
         They are created with the LOCAL keyword and support partition independance. Equipartioning allows 
         oracle to be more efficient whilst devising query plans.

Global - Index in a single partition may correspond to multiple table partitions. They are created with the GLOBAL 
         keyword and do not support partition independance. Global indexes can only be range partitioned and may be 
         partitioned in such a fashion that they look equipartitioned, but Oracle will not take advantage of this 
         structure.

Local and Global types of indexes can be subdivided further.

Prefixed -     The partition key is the leftmost column(s) of the index. Probing this type of index is less costly. 
               If a query specifies the partition key in the where clause partition pruning is possible, that is, 
               not all partitions will be searched.

Non-Prefixed - Does not support partition pruning, but is effective in accessing data that spans multiple partitions. 
               Often used for indexing a column that is not the tables partition key, when you would like the index to 
               be partitioned on the same key as the underlying table.

Assuming the Range partition table is range_partitioning and the partitioned key created on column col_date.
The following are examples of Local Prefixed/Non-Prefixed indexes.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_partitioning PURGE;

-- To Creating a Range Partitioned Tables Table.
CREATE TABLE dshrivastav.range_partitioning    
( 
  col_date  DATE,
  col_num   NUMBER,
  col_char  VARCHAR2(5)
)
PARTITION BY RANGE (col_date)
(
 PARTITION part_1   VALUES LESS THAN(TO_DATE('23/01/2018', 'DD/MM/YYYY')),
 PARTITION part_max VALUES LESS THAN(MAXVALUE)
)TABLESPACE WAREHOUSE_DATABASE;

-- To drop Indexes from database (If the object exists)
DROP INDEX dshrivastav.local_prefixed;
DROP INDEX dshrivastav.local_nonprefixed;

-- To Create Local Indexes (PREFIXED/NON_PREFIXED)
CREATE INDEX local_prefixed ON dshrivastav.range_partitioning (col_date,col_num) 
LOCAL
TABLESPACE TABLE_BACKUP;

CREATE INDEX local_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
LOCAL
TABLESPACE TABLE_BACKUP;

-- To Verify the Indexes
SELECT 
     index_name,
     table_name,
     partitioning_type,
     locality,
     alignment,
     def_tablespace_name
FROM 
     all_part_indexes
WHERE 
     table_name ='RANGE_PARTITIONING'
AND  owner = 'DSHRIVASTAV';

/*
INDEX_NAME        TABLE_NAME         PARTITIONING_TYPE LOCALITY ALIGNMENT    DEF_TABLESPACE_NAME
----------------- ------------------ ----------------- -------- ------------ -------------------
LOCAL_NONPREFIXED RANGE_PARTITIONING RANGE             LOCAL    NON_PREFIXED TABLE_BACKUP       
LOCAL_PREFIXED    RANGE_PARTITIONING RANGE             LOCAL    PREFIXED     TABLE_BACKUP       
*/

-- Insert the data for Range Partitioned Tables
INSERT INTO dshrivastav.range_partitioning
SELECT 
     SYSDATE-(30*LEVEL)                       col_date,
     CEIL(dbms_random.VALUE(1,LEVEL))         col_num,
     Chr(TRUNC(dbms_random.Value(100,LEVEL))) col_char 
FROM dual
CONNECT BY LEVEL <= 10000;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RANGE_PARTITIONING', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- Pick one Record
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('23.01.2018 22:41:16', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;
/*
COL_DATE            COL_NUM COL_CHAR
------------------- ------- --------
23.01.2018 22:41:16       3        
*/

-- To Verify the use of Local Index as PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('23.01.2018 22:41:16', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;
SELECT * FROM TABLE(dbms_xplan.display);
/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    13 |     2   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE SINGLE            |                    |     1 |    13 |     2   (0)| 00:00:01 |     2 |     2 |
|   2 |   TABLE ACCESS BY LOCAL INDEX ROWID| RANGE_PARTITIONING |     1 |    13 |     2   (0)| 00:00:01 |     2 |     2 |
|*  3 |    INDEX RANGE SCAN                | LOCAL_PREFIXED     |     1 |       |     1   (0)| 00:00:01 |     2 |     2 |
-------------------------------------------------------------------------------------------------------------------------
*/
-- To Verify the use of Local Index as NON_PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_num  = 3 
AND col_char = '';
SELECT * FROM TABLE(dbms_xplan.display);
/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    15 |     4   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE ALL               |                    |     1 |    15 |     4   (0)| 00:00:01 |     1 |     2 |
|   2 |   TABLE ACCESS BY LOCAL INDEX ROWID| RANGE_PARTITIONING |     1 |    15 |     4   (0)| 00:00:01 |     1 |     2 |
|*  3 |    INDEX RANGE SCAN                | LOCAL_NONPREFIXED  |     1 |       |     3   (0)| 00:00:01 |     1 |     2 |
-------------------------------------------------------------------------------------------------------------------------
*/

The following are examples of Local Prefixed/Non-Prefixed indexes using STORE IN clause.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_hash_partitioning PURGE;

-- To Creating a Range Partitioned Tables Table.
CREATE TABLE dshrivastav.range_hash_partitioning
(
  col_date  DATE,
  col_num   NUMBER,
  col_char  VARCHAR2(5)
)
PARTITION BY RANGE (col_date)
SUBPARTITION BY HASH (col_num) SUBPARTITIONS 3 STORE IN (TABLE_BACKUP,WAREHOUSE_DATABASE,WAREHOUSE_BIGFILE_DATABASE)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','dd-MON-yyyy')),
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','dd-MON-yyyy')),
 PARTITION sales_p3_2018 VALUES LESS THAN (TO_DATE('01-OCT-2018','dd-MON-yyyy')),
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE)
) ;

-- To drop Indexes from database (If the object exists)
DROP INDEX dshrivastav.ix_prefix;
DROP INDEX dshrivastav.ix_non_prefix;

-- To Create Local Indexes - PREFIXED
CREATE INDEX ix_prefix ON dshrivastav.range_hash_partitioning(col_date,col_num)
LOCAL
STORE IN (TABLE_BACKUP,WAREHOUSE_DATABASE, WAREHOUSE_BIGFILE_DATABASE);

-- To Create Local Indexes - NON_PREFIXED
CREATE INDEX ix_non_prefix ON dshrivastav.range_hash_partitioning(col_char)
LOCAL
STORE IN (TABLE_BACKUP,WAREHOUSE_DATABASE, WAREHOUSE_BIGFILE_DATABASE);


EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_hash_partitioning
WHERE 
    col_date = TO_DATE('22.08.2018 01:33:56', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;
SELECT * FROM TABLE(dbms_xplan.display);
/*                                                                                                                      
-------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name                    | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                         |     1 |    26 |     1   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE SINGLE             |                         |     1 |    26 |     1   (0)| 00:00:01 |     3 |     3 |
|   2 |   PARTITION HASH SINGLE             |                         |     1 |    26 |     1   (0)| 00:00:01 |     2 |     2 |
|   3 |    TABLE ACCESS BY LOCAL INDEX ROWID| RANGE_HASH_PARTITIONING |     1 |    26 |     1   (0)| 00:00:01 |     8 |     8 |
|*  4 |     INDEX RANGE SCAN                | IX_PREFIX               |     1 |       |     1   (0)| 00:00:01 |     8 |     8 |
-------------------------------------------------------------------------------------------------------------------------------
*/
-- To Verify the use of Local Index as NON_PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_hash_partitioning
WHERE 
    col_num  = 3 
AND col_char = '';
SELECT * FROM TABLE(dbms_xplan.display);
/*
-------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name                    | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                         |     1 |    26 |     1   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE ALL                |                         |     1 |    26 |     1   (0)| 00:00:01 |     1 |     4 |
|   2 |   PARTITION HASH SINGLE             |                         |     1 |    26 |     1   (0)| 00:00:01 |     2 |     2 |
|*  3 |    TABLE ACCESS BY LOCAL INDEX ROWID| RANGE_HASH_PARTITIONING |     1 |    26 |     1   (0)| 00:00:01 |       |       |
|*  4 |     INDEX RANGE SCAN                | IX_NON_PREFIX           |     1 |       |     1   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------------                                                                     
*/

Assuming the Range partition table is range_partitioning and the partitioned key created on column col_date.
The following are examples of Global Prefixed/Non-Prefixed indexes.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_partitioning PURGE;

-- To Creating a Range Partitioned Tables Table.
CREATE TABLE dshrivastav.range_partitioning    
( 
  col_date  DATE,
  col_num   NUMBER,
  col_char  VARCHAR2(5)
)
PARTITION BY RANGE (col_date)
(
 PARTITION part_1   VALUES LESS THAN(TO_DATE('23/01/2018', 'DD/MM/YYYY')),
 PARTITION part_max VALUES LESS THAN(MAXVALUE)
)TABLESPACE WAREHOUSE_DATABASE;

-- To drop Indexes from database (If the object exists)
DROP INDEX dshrivastav.global_prefixed;
DROP INDEX dshrivastav.global_nonprefixed;

-- To Create Global Indexes (PREFIXED/NON_PREFIXED)
CREATE INDEX global_prefixed ON dshrivastav.range_partitioning (col_date)
GLOBAL 
TABLESPACE TABLE_BACKUP;

CREATE INDEX global_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL
TABLESPACE TABLE_BACKUP;

-- Insert the data for Range Partitioned Tables
INSERT INTO dshrivastav.range_partitioning
SELECT 
     SYSDATE+(30*LEVEL)                       col_date,
     CEIL(dbms_random.VALUE(1,LEVEL))         col_num,
     Chr(TRUNC(dbms_random.Value(100,LEVEL))) col_char 
FROM dual
CONNECT BY LEVEL <= 10000;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'RANGE_PARTITIONING', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- Pick one Record
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('22.08.2018 01:33:56', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;
/*
COL_DATE            COL_NUM COL_CHAR
------------------- ------- --------
22.08.2018 01:33:56       3        
*/

-- To Verify the use of Global Index as PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('22.08.2018 01:33:56', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;

SELECT * FROM TABLE(dbms_xplan.display);

/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    15 |     2   (0)| 00:00:01 |       |       |
|*  1 |  TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    15 |     2   (0)| 00:00:01 |     2 |     2 |
|*  2 |   INDEX RANGE SCAN                 | GLOBAL_PREFIXED    |     1 |       |     1   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------
*/

-- To Verify the use of Global Index as NON_PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_num  = 3 
AND col_char = '';

SELECT * FROM TABLE(dbms_xplan.display);

/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    15 |     2   (0)| 00:00:01 |       |       |
|   1 |  TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    15 |     2   (0)| 00:00:01 | ROWID | ROWID |
|*  2 |   INDEX RANGE SCAN                 | GLOBAL_NONPREFIXED |     1 |       |     1   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------
*/

The following are examples of Global Prefixed/Non-Prefixed indexes using UNIQUE clause.

-- To drop Indexes from database (If the object exists)
DROP INDEX dshrivastav.ix_prefixed;
DROP INDEX dshrivastav.ix_nonprefixed;

-- To Create Unike Global Indexes (PREFIXED/NON_PREFIXED)
CREATE UNIQUE INDEX ix_prefixed ON dshrivastav.range_partitioning (col_date)
GLOBAL 
TABLESPACE TABLE_BACKUP;

CREATE UNIQUE INDEX ix_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL
TABLESPACE TABLE_BACKUP;

-- To Verify the use of Local Index as PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('22.08.2018 01:33:56', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;

SELECT * FROM TABLE(dbms_xplan.display);
/*                                                                                                                      
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    15 |     0   (0)| 00:00:01 |       |       |
|*  1 |  TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    15 |     0   (0)| 00:00:01 |     2 |     2 |
|*  2 |   INDEX UNIQUE SCAN                | IX_PREFIXED        |     1 |       |     0   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------
*/

-- To Verify the use of Local Index as NON_PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_num  = 3 
AND col_char = '';

SELECT * FROM TABLE(dbms_xplan.display);
/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                    |     1 |    15 |     0   (0)| 00:00:01 |       |       |
|   1 |  TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    15 |     0   (0)| 00:00:01 | ROWID | ROWID |
|*  2 |   INDEX UNIQUE SCAN                | IX_NONPREFIXED     |     1 |       |     0   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------
*/

The following are examples of Global Prefixed/Non-Prefixed indexes using alternative way for STORE IN clause.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_partitioning PURGE;

-- To Creating a Range Partitioned Tables Table.
CREATE TABLE dshrivastav.range_partitioning
(
  col_date  DATE,
  col_num   NUMBER,
  col_char  VARCHAR2(5)
)
PARTITION BY RANGE (col_date)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','dd-MON-yyyy')) TABLESPACE WAREHOUSE_DATABASE,
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','dd-MON-yyyy')) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE)                             TABLESPACE TABLE_BACKUP
) ;
                                                                                             
-- To drop Global Indexes from database (If the object exists)
DROP INDEX dshrivastav.ix_prefixed;
DROP INDEX dshrivastav.ix_nonprefixed;

-- To Create Global Indexes - PREFIXED
CREATE INDEX ix_prefixed ON dshrivastav.range_partitioning (col_date)
GLOBAL PARTITION BY RANGE (col_date)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','dd-MON-yyyy')) TABLESPACE WAREHOUSE_DATABASE,
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','dd-MON-yyyy')) TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE)                             TABLESPACE TABLE_BACKUP
);

-- To Create Global Indexes - NON_PREFIXED
CREATE INDEX ix_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL PARTITION BY RANGE (col_num)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (100)      TABLESPACE WAREHOUSE_DATABASE,
 PARTITION sales_p2_2018 VALUES LESS THAN (1000)     TABLESPACE WAREHOUSE_BIGFILE_DATABASE,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE) TABLESPACE TABLE_BACKUP
);

EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_date = TO_DATE('22.08.2018 01:33:56', 'DD.MM.YYYY HH24:MI:SS')
AND 
    col_num = 3;

SELECT * FROM TABLE(dbms_xplan.display);
/*                                                                                                                      
--------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
--------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                    |     1 |    26 |     1   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE SINGLE             |                    |     1 |    26 |     1   (0)| 00:00:01 |     3 |     3 |
|*  2 |   TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    26 |     1   (0)| 00:00:01 |     3 |     3 |
|*  3 |    INDEX RANGE SCAN                 | IX_PREFIXED        |     1 |       |     1   (0)| 00:00:01 |     3 |     3 |
--------------------------------------------------------------------------------------------------------------------------
*/

-- To Verify the use of Local Index as NON_PREFIXED 
EXPLAIN PLAN FOR
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning
WHERE 
    col_num  = 3 
AND col_char = '';

SELECT * FROM TABLE(dbms_xplan.display);
/*
--------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name               | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
--------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                    |     1 |    26 |     1   (0)| 00:00:01 |       |       |
|   1 |  PARTITION RANGE SINGLE             |                    |     1 |    26 |     1   (0)| 00:00:01 |     1 |     1 |
|   2 |   TABLE ACCESS BY GLOBAL INDEX ROWID| RANGE_PARTITIONING |     1 |    26 |     1   (0)| 00:00:01 | ROWID | ROWID |
|*  3 |    INDEX RANGE SCAN                 | IX_NONPREFIXED     |     1 |       |     1   (0)| 00:00:01 |     1 |     1 |
--------------------------------------------------------------------------------------------------------------------------
*/