-- Oracle Partitioned Tables and Indexes --

Maintenance of large tables and indexes can become very time and resource consuming. 
At the same time, data access performance can reduce drastically for these objects. 
Partitioning of tables and indexes can benefit the performance and maintenance in several ways.

    1. Partition independance means backup and recovery operations can be performed on individual partitions,
       whilst leaving the other partitons available.
    2. Query performance can be improved as access can be limited to relevant partitons only.
    3. There is a greater ability for parallelism with more partitions.

-- Types of Oracle Partitione Tables and Indexs
In a real situation it is likely that these partitions would be assigned to different tablespaces to reduce device contention.

    1. Range Partitioning Tables
    2. Hash Partitioning Tables
    3. Composite Partitioning Tables
    4. Partitioning Indexes
    5. Local Prefixed Indexes
    6. Local Non-Prefixed Indexes
    7. Global Prefixed Indexes
    8. Global Non-Prefixed Indexes
    9. Partitioning Existing Tables
	
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
