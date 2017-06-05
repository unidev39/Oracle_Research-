-- Oracle Partitioned Tables and Indexes --

Maintenance of large tables and indexes can become very time and resource consuming. 
At the same time, data access performance can reduce drastically for these objects. 
Partitioning of tables and indexes can benefit the performance and maintenance in several ways.

    1. Partition independance means backup and recovery operations can be performed on individual partitions,
       whilst leaving the other partitons available.
    2. Query performance can be improved as access can be limited to relevant partitons only.
    3. There is a greater ability for parallelism with more partitions.

-- Types of Oracle Partitione Tables and Indexs
    1. Range Partitioning Tables
    2. Hash Partitioning Tables
    3. Creating List-Partitioned Tables
    4. Composite Partitioning Tables
    5. Partitioning Indexes
    6. Local Prefixed Indexes
    7. Local Non-Prefixed Indexes
    8. Global Prefixed Indexes
    9. Global Non-Prefixed Indexes
    10. Partitioning Existing Tables

Note: In a real situation it is likely that these partitions would be assigned to different tablespaces to reduce device contention.

1. Range Partitioning Tables

Range Partitioning is a table using date ranges allows all data of a similar age to be stored in same partition. 
Range partitioning is useful when you have distinct ranges of data you want to store together.
Once historical data is no longer needed the whole partition can be removed. 


DROP TABLE range_partitioning PURGE;
CREATE TABLE range_partitioning
(
 range_no      NUMBER NOT NULL,
 range_date    DATE   NOT NULL,
 comments      VARCHAR2(500)
)
PARTITION BY RANGE (range_date)
(
 PARTITION ranges_q1 VALUES LESS THAN (TO_DATE('01/02/2017', 'DD/MM/YYYY')),
 PARTITION ranges_q2 VALUES LESS THAN (TO_DATE('01/03/2017', 'DD/MM/YYYY')),
 PARTITION ranges_q3 VALUES LESS THAN (TO_DATE('01/04/2017', 'DD/MM/YYYY')),
 PARTITION ranges_q4 VALUES LESS THAN (TO_DATE('01/05/2017', 'DD/MM/YYYY'))
);

DROP TABLE range_partitioning PURGE;
CREATE TABLE range_partitioning
(
 range_no      NUMBER NOT NULL,
 range_date    DATE   NOT NULL,
 comments      VARCHAR2(500)
)
PARTITION BY RANGE (range_date)
(
 PARTITION ranges_q1 VALUES LESS THAN (TO_DATE('01/02/2017', 'DD/MM/YYYY')) TABLESPACE users,
 PARTITION ranges_q2 VALUES LESS THAN (TO_DATE('01/03/2017', 'DD/MM/YYYY')) TABLESPACE users,
 PARTITION ranges_q3 VALUES LESS THAN (TO_DATE('01/04/2017', 'DD/MM/YYYY')) TABLESPACE users,
 PARTITION ranges_q4 VALUES LESS THAN (TO_DATE('01/05/2017', 'DD/MM/YYYY')) TABLESPACE users
);

INSERT INTO range_partitioning VALUES (5,TO_DATE('01/06/2017', 'DD/MM/YYYY'),'OutOfRange');
-- ORA-14400: inserted partition key does not map to any partition

INSERT INTO range_partitioning VALUES (4,TO_DATE('01/05/2017', 'DD/MM/YYYY'),'OutOfRange');
-- ORA-14400: inserted partition key does not map to any partition

INSERT INTO range_partitioning VALUES (4,TO_DATE('30/04/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q4 partition');
-- 1 Row inserted

SELECT * FROM range_partitioning;
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
4       4/30/2017  1 Row Inserted into ranges_q4 partition
*/


INSERT INTO range_partitioning VALUES (3,TO_DATE('31/03/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q3 partition');
-- 1 Row inserted

SELECT * FROM range_partitioning;
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/31/2017   1 Row Inserted into ranges_q3 partition
4      4/30/2017   1 Row Inserted into ranges_q4 partition
*/

-- Syntax --
/*
SELECT DISTINCT <column_name_list>
FROM <table_name> PARTITION (<partition_name>);
*/
 
SELECT 
     * 
FROM 
     range_partitioning PARTITION (ranges_q3);
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/31/2017   1 Row Inserted into ranges_q3 partition
*/

INSERT INTO range_partitioning 
VALUES (3,TO_DATE('30/03/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q3 partition');
-- 1 Row inserted

SELECT 
     * 
FROM range_partitioning PARTITION (ranges_q3);
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/31/2017   1 Row Inserted into ranges_q3 partition
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/
   
SELECT 
     * 
FROM 
     range_partitioning b PARTITION (ranges_q3)
WHERE 
     b.range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
-- ORA-00924: missing BY keyword

SELECT 
     * 
FROM 
     range_partitioning  PARTITION (ranges_q3)
WHERE 
     range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/

SELECT 
     * 
FROM 
     range_partitioning  PARTITION (ranges_q3) a
WHERE 
     a.range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/

SELECT 
     a.* 
FROM 
     range_partitioning  PARTITION (ranges_q3) a
WHERE 
     a.range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/


2. Hash Partitioning Tables

Hash partitioning is useful when there is no obvious range key, or range partitioning will cause uneven distribution of data. 
The number of partitions must be a power of 2 (2, 4, 8, 16...) and can be specified by the PARTITIONS...STORE IN clause.
The nature of hash partitioning depend on The values returned by a hash function are called hash values, hash codes, digests, or simply hashes.

DROP TABLE hash_partitioning PURGE;
CREATE TABLE hash_partitioning
(
 hash_no    NUMBER NOT NULL,
 hash_date  DATE   NOT NULL,
 comments          VARCHAR2(500)
)
PARTITION BY HASH (hash_no)
(
 PARTITION hashs_q1,
 PARTITION hashs_q2
);

INSERT INTO hash_partitioning VALUES (1,sysdate,'A');
INSERT INTO hash_partitioning VALUES (1,sysdate,'A');
INSERT INTO hash_partitioning VALUES (2,sysdate,'A');
INSERT INTO hash_partitioning VALUES (3,sysdate,'A');
INSERT INTO hash_partitioning VALUES (4,sysdate,'A');
INSERT INTO hash_partitioning VALUES (4,sysdate,'A');
INSERT INTO hash_partitioning VALUES (5,sysdate,'A');

SELECT * FROM hash_partitioning;
/*
HASH_NO HASH_DATE           COMMENTS
------ -------------------  --------
2      6/5/2017 2:39:46 AM  A
5      6/5/2017 2:40:44 AM  A
1      6/5/2017 2:39:25 AM  A
1      6/5/2017 2:39:52 AM  A
3      6/5/2017 2:40:06 AM  A
4      6/5/2017 2:40:14 AM  A
4      6/5/2017 2:40:22 AM  A
*/

SELECT * FROM hash_partitioning PARTITION (hashs_q1);
/*
HASH_NO HASH_DATE           COMMENTS
------ -------------------  --------
2      6/5/2017 2:39:46 AM  A
5      6/5/2017 2:40:44 AM  A
*/
SELECT * FROM hash_partitioning PARTITION (hashs_q2);
/*
HASH_NO HASH_DATE           COMMENTS
------ -------------------  --------
1      6/5/2017 2:39:25 AM  A
1      6/5/2017 2:39:52 AM  A
3      6/5/2017 2:40:06 AM  A
4      6/5/2017 2:40:14 AM  A
4      6/5/2017 2:40:22 AM  A
*/

3. Creating List-Partitioned Tables (Label)

The semantics for creating list partitions are very similar to those for creating range partitions. 
However, to create list partitions, you specify a PARTITION BY LIST clause in the 
CREATE TABLE statement, and the PARTITION clauses specify lists of literal values, 
which are the discrete values of the partitioning columns that qualify rows to be included in the partition. 
For list partitioning, the partitioning key can only be a single column name from the table.

Available only with list partitioning, you can use the keyword DEFAULT to describe the value list for a partition. 
This identifies a partition that accommodates rows that do not map into any of the other partitions.

DROP TABLE list_partitioned PURGE;
CREATE TABLE list_partitioned
(
 deptno           NUMBER, 
 deptname         VARCHAR2(20),
 zone            VARCHAR2(20)
)
PARTITION BY LIST (zone)
(
 PARTITION list_zone_l1  VALUES ('BAGMATI', 'NARAYNI'),
 PARTITION list_zone_l2  VALUES ('KOSHI', 'MECHI', 'SAGARMATHA')
);

INSERT INTO list_partitioned VALUES (10,'Nepal','BAGMATI');
INSERT INTO list_partitioned VALUES (10,'Nepal','KOSHI');
INSERT INTO list_partitioned VALUES (10,'Nepal','NARAYNI');
INSERT INTO list_partitioned VALUES (10,'Nepal','MECHI');
INSERT INTO list_partitioned VALUES (10,'Nepal','SAGARMATHA');

SELECT * FROM list_partitioned;
/*
DEPTNO DEPTNAME ZONE
------ -------- --------
10     Nepal    BAGMATI
10     Nepal    NARAYNI
10     Nepal    KOSHI
10     Nepal    MECHI
10     Nepal    SAGARMATHA
*/

SELECT * FROM list_partitioned PARTITION (list_zone_l1);
/*
DEPTNO DEPTNAME ZONE
------ -------- --------
10     Nepal    BAGMATI
10     Nepal    NARAYNI
*/
SELECT * FROM list_partitioned PARTITION (list_zone_l2);
/*
DEPTNO DEPTNAME ZONE
------ -------- --------
10     Nepal    KOSHI
10     Nepal    MECHI
10     Nepal    SAGARMATHA
*/
