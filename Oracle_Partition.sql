                                    Oracle Partitioned Tables                                      
                                      Deveh Kumar Shrivastav                                       

1.Benefits of Partitioning
2.Partitioning Concepts
3.Basics of Partitioning
4.Partitioning Key
5.When to Partition a Table
6.Partitioning for Performance
7.Partition Pruning
8.Oracle Consistent gets
9.Partition-Wise Joins
10.Partitioning Strategies
11.Single-Level Partitioning (DEFAULT/TABLESPACE/STORE IN)
   • Range Partitioning
       Using Table Compression with Partitioned Tables
       Using Multicolumn Partitioning Keys
       Using ENABLE ROW MOVEMENT
       Using Interval-Partitioned
       Using Virtual Column
       Using reference-partitioned tables
   • Hash Partitioning
       Using Table Compression with Partitioned Tables
       Using Multicolumn Partitioning Keys
       Using ENABLE ROW MOVEMENT
       Using Interval-Partitioned
       Using Virtual Column
       Using reference-partitioned tables
   • List Partitioning
       Using Table Compression with Partitioned Tables
       Using Multicolumn Partitioning Keys
       Using Default Partition
       Using NULL Partition
       Using ENABLE ROW MOVEMENT 
12.Composite Partitioning (DEFAULT/TABLESPACE/STORE IN)
   • Composite Range-Range Partitioning.
   • Composite Range-Hash Partitioning.
   • Composite Range-List Partitioning.
   • Composite Hash-Hash Partitioning.
   • Composite Hash-Range Partitioning.
   • Composite Hash-List Partitioning.
   • Composite List-List Partitioning.
   • Composite List-Range Partitioning.
   • Composite List-Hash Partitioning.
13.Partition Indexes Organized tables (DEFAULT/TABLESPACE/STORE IN)
   • Local Index
       Prefixed Local Index
       Non_Prefixed Local Index
   • Global Index
       Prefixed Global Index
       Non_Prefixed Global Index
14.Maintaining Partitions
   • Maintenance Operations on Partitions That Can Be Performed
       ALTER TABLE Maintenance Operations for Table Partitions
       ALTER TABLE Maintenance Operations for Table Subpartitions
       ALTER INDEX Maintenance Operations for Index Partitions
   • Adding Partitions
       Adding a Partition to a Range-Partitioned Table
       Adding a Partition to a Hash-Partitioned Table
       Adding a Partition to a List-Partitioned Table
       Adding a Partition to an Interval-Partitioned Table
       Adding Partitions to a Composite *-Hash Partitioned Table
       Adding a Partition to a *-Hash Partitioned Table
       Adding a Subpartition to a *-Hash Partitioned Table
       Adding Partitions to a Composite *-List Partitioned Table
       Adding a Partition to a *-List Partitioned Table
       Adding a Subpartition to a *-List Partitioned Table
       Adding Partitions to a Composite *-Range Partitioned Table
       Adding a Partition to a *-Range Partitioned Table
       Adding a Subpartition to a *-Range Partitioned Table
       Adding Index Partitions
   • Coalescing Partitions
       Coalescing a Partition in a Hash-Partitioned Table
       Coalescing a Subpartition in a *-Hash Partitioned Table
       Coalescing Hash-Partitioned Global Indexes
   • Dropping Partitions
       Exchanging Partitions
       Exchanging a Range, Hash, or List Partition
       Exchanging a Partition of an Interval Partitioned Table
       Exchanging a Partition of a Reference-Partitioned Table
       Exchanging a Hash-Partitioned Table with a *-Hash Partition
       Exchanging a Subpartition of a *-Hash Partitioned Table
       Exchanging a List-Partitioned Table with a *-List Partition
       Exchanging a Range-Partitioned Table with a *-Range Partition
   • Merging Partitions
       Merging Range Partitions
       Merging Interval Partitions
       Merging List Partitions
       Merging *-Hash Partitions
       Merging *-List Partitions
       Merging Partitions in a *-List Partitioned Table
       Merging Subpartitions in a *-List Partitioned Table
       Merging *-Range Partitions
   • Modifying Default Attributes
   • Modifying Real Attributes of Partitions
       Modifying Real Attributes for a Range or List Partition
       Modifying Real Attributes of a Subpartition
   • Modifying List Partitions: Adding Values
       Adding Values for a List Partition
       Adding Values for a List Subpartition
   • Modifying List Partitions: Dropping Values
       Dropping Values from a List Partition
       Dropping Values from a List Subpartition
   • Modifying a Subpartition Template
   • Moving Partitions
       Moving Table Partitions
       Moving Subpartitions
   • Rebuilding Index Partitions
   • Renaming Partitions
   • Truncating Partitions
   • Splitting Partitions
       Splitting a Partition of a Range-Partitioned Table
       Splitting a Partition of a List-Partitioned Table
       Splitting a Partition of an Interval-Partitioned Table
       Splitting a *-Hash Partition
       Splitting Partitions in a *-List Partitioned Table
       Splitting a *-List Partition
       Splitting a *-List Subpartition
       Splitting Partitions in a *-Range Partition
       Splitting a *-Range Partition
       Splitting a *-Range Subpartition
15.Customized Oracle PL/SQL Units to Fulfill the naming conventions
16.DML Operations with Oracle Partition Table
17.Non-Partitioned table to a Partitioned table
18.Partitioned table to a Non-Partitioned table
19.Conversion of improper Partition to proper partition

Benefits of Partitioning:
Partitioning can provide tremendous benefit to a wide variety of applications by improving
performance, manageability, and availability. It is not unusual for partitioning to improve
the performance of certain queries or maintenance operations by an order of magnitude.
Moreover, partitioning can greatly simplify common administration tasks.

Partitioning also enables database designers and administrators to tackle some of the
toughest problems posed by cutting-edge applications. Partitioning is a key tool for building
multi-terabyte systems or systems with extremely high availability requirements.

Partitioning Concepts:
Partitioning enhances the performance, manageability, and availability of a wide variety of
applications and helps reduce the total cost of ownership for storing large amounts of data.
Partitioning allows tables, indexes, and index-organized tables to be subdivided into smaller
pieces, enabling these database objects to be managed and accessed at a finer level of granularity.
Oracle provides a rich variety of partitioning strategies and extensions to address every business
requirement.

Basics of Partitioning:
Partitioning allows a table, index, or index-organized table to be subdivided into smaller pieces,
where each piece of such a database object is called a partition. Each partition has its own name,
and may optionally have its own storage characteristics.

From the perspective of a database administrator, a partitioned object has multiple pieces that can
be managed either collectively or individually. This gives the administrator considerable flexibility
in managing partitioned objects.

However, from the perspective of the application, a partitioned table is identical to a non-partitioned
table, no modifications are necessary when accessing a partitioned table using SQL queries
and DML statements.

Partitioning Key:
Each row in a partitioned table is unambiguously assigned to a single partition. The partitioning key
is comprised of one or more columns that determine the partition where each row will be stored. Oracle
automatically directs insert, update, and delete operations to the appropriate partition through the
use of the partitioning key.

When to Partition a Table:
Here are some suggestions for when to partition a table
Tables greater than 2 GB should always be considered as candidates for partitioning.
Tables containing historical data, in which new data is added into the newest partition. A typical
example is a historical table where only the current months data is updatable and the other 11 months
are read only.
When the contents of a table need to be distributed across different types of storage devices.

Partitioning for Performance:
By limiting the amount of data to be examined or operated on, and by providing data distribution for
parallel execution, partitioning provides a number of performance benefits. These features include:
*Partition Pruning
*Partition-Wise Joins

Partition Pruning
Partition pruning is the simplest and also the most substantial means to improve performance using partitioning.
Partition pruning can often improve query performance by several orders of magnitude.
For example, suppose an application contains an Sales table containing a historical record of sales, and that
this table has been partitioned by week. A query requesting sales for a single week would only access a single
partition of the Sales table. If the Sales table had 2 years of historical data, then this query would access
one partition instead of 104 partitions. This query could potentially execute 100 times faster simply because of
partition pruning. Partition pruning works with all of Oracle other performance features. Oracle will utilize
partition pruning in conjunction with any indexing technique, join technique, or parallel access method.

Partition Pruning example:

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.big_album_sales PURGE;

-- First, Create a partitioned table, partitioned on a release_date column
CREATE TABLE dshrivastav.big_album_sales
(
 id           NUMBER,
 album_id     NUMBER,
 country_id   NUMBER,
 release_date DATE,
 total_sales  NUMBER
)
PARTITION BY RANGE (release_date)
(
 PARTITION album_2001 VALUES LESS THAN (TO_DATE('01-JAN-2002', 'DD-MON-YYYY')),
 PARTITION album_2002 VALUES LESS THAN (TO_DATE('01-JAN-2003', 'DD-MON-YYYY')),
 PARTITION album_2003 VALUES LESS THAN (TO_DATE('01-JAN-2004', 'DD-MON-YYYY')),
 PARTITION album_2004 VALUES LESS THAN (TO_DATE('01-JAN-2005', 'DD-MON-YYYY')),
 PARTITION album_2005 VALUES LESS THAN (TO_DATE('01-JAN-2006', 'DD-MON-YYYY')),
 PARTITION album_2006 VALUES LESS THAN (TO_DATE('01-JAN-2007', 'DD-MON-YYYY')),
 PARTITION album_2007 VALUES LESS THAN (TO_DATE('01-JAN-2008', 'DD-MON-YYYY')),
 PARTITION album_2008 VALUES LESS THAN (MAXVALUE)
);

-- Next populate the table with approximately 8 years worth of data
INSERT INTO dshrivastav.big_album_sales
SELECT
     ROWNUM                             id,
     MOD(ROWNUM,5000)+1                 album_id,
     MOD(ROWNUM,100)+1                  country_id,
     SYSDATE-MOD(ROWNUM,2785)           release_date,
     CEIL(dbms_random.value(1,500000))  total_sales
FROM dual
CONNECT BY LEVEL <= 2000000;
--2000000 rows inserted.
COMMIT;

-- Create an index on the release_date column (Local Index)
CREATE INDEX big_album_sales_i ON dshrivastav.big_album_sales(release_date)
LOCAL;

-- GatherStats
BEGIN
    dbms_stats.gather_table_stats(ownname=> 'DSHRIVASTAV',
                                  tabname=> 'BIG_ALBUM_SALES',
                                  estimate_percent=> 10,
                                  method_opt=> 'FOR ALL COLUMNS SIZE 1');
END;
/

-- Second, Create another equivalent table, this time non-partitioned
CREATE TABLE dshrivastav.big_album_sales2
(
 id           NUMBER,
 album_id     NUMBER,
 country_id   NUMBER,
 release_date DATE,
 total_sales  NUMBER
);

INSERT INTO dshrivastav.big_album_sales2
SELECT
     ROWNUM                             id,
     MOD(ROWNUM,5000)+1                 album_id,
     MOD(ROWNUM,100)+1                  country_id,
     SYSDATE-MOD(ROWNUM,2785)           release_date,
     CEIL(dbms_random.value(1,500000))  total_sales
FROM dual
CONNECT BY LEVEL <= 2000000;
--2000000 rows created.
COMMIT;

-- Create an index on the release_date column (B-Tree Index)
CREATE INDEX big_album_sales2_i
ON dshrivastav.big_album_sales2(release_date);

-- GatherStats
BEGIN
    dbms_stats.gather_table_stats(ownname=> 'DSHRIVASTAV',
                                  tabname=> 'BIG_ALBUM_SALES2',
                                  estimate_percent=> 10,
                                  method_opt=> 'FOR ALL COLUMNS SIZE 1');
END;
/
-- Step 1 (non-partitioned table) 
-- Selecting 1 of the 8 years worth of data in the non-partitioned table will result in a full table scan
-- as it's the most efficient method in selecting such a relatively high percentage of rows
EXPLAIN PLAN FOR
SELECT
     *
FROM
     dshrivastav.big_album_sales2
WHERE
     release_date BETWEEN '01-JAN-2003' and '31-DEC-2003';
--261352 rows selected.

SELECT * FROM TABLE(dbms_xplan.display);
/*
Elapsed: 00:00:05.43
Execution Plan
----------------------------------------------------------
Plan hash value: 4100370891
--------------------------------------------------------------------------------------
| Id | Operation | Name | Rows | Bytes | Cost (%CPU)| Time |
--------------------------------------------------------------------------------------
| 0 | SELECT STATEMENT | | 262K| 6419K| 2304 (2)| 00:00:28 |
|* 1 | TABLE ACCESS FULL| BIG_ALBUM_SALES2 | 262K| 6419K| 2304 (2)| 00:00:28 |
--------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
 1 - filter("RELEASE_DATE"<=TO_DATE(' 2003-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss')
 AND "RELEASE_DATE">=TO_DATE(' 2003-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
Statistics
----------------------------------------------------------
 1       recursive calls
 0       db block gets
 8664    consistent gets
 8399    physical reads
 0 redo  size
 6945261 bytes sent via SQL*Net to client
 3267    bytes received via SQL*Net from client
 263     SQL*Net roundtrips to/from client
 0 sorts (memory)
 0 sorts (disk)
 261352  rows processed
*/

/*
==> So that's 8664 consistent gets ...
==> Forcing the use of an index clearly shows is a more expensive option both in elapsed times
    and the increased consistent gets
*/

-- Using Oracle Hint (Index) 
EXPLAIN PLAN FOR
SELECT
     /*+ INDEX (t) */ *
FROM
     dshrivastav.big_album_sales2 t
WHERE
     release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';
--261352 rows selected.

SELECT * FROM TABLE(dbms_xplan.display);
/*
Elapsed: 00:00:15.50
Execution Plan
----------------------------------------------------------
Plan hash value: 1720219014
--------------------------------------------------------------------------------------------------
| Id | Operation | Name | Rows | Bytes | Cost(%CPU) | Time |
--------------------------------------------------------------------------------------------------
| 0 | SELECT STATEMENT | | 262K| 6419K| 263K (1)| 00:52:45 |
| 1 | TABLE ACCESS BY INDEX ROWID| BIG_ALBUM_SALES2 | 262K| 6419K| 263K (1)| 00:52:45 |
|* 2 | INDEX RANGE SCAN | BIG_ALBUM_SALES2_I | 262K| | 701 (1)| 00:00:09 |
--------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
 2 - access("RELEASE_DATE">=TO_DATE(' 2003-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss')
 AND "RELEASE_DATE"<=TO_DATE(' 2003-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
Statistics
----------------------------------------------------------
 1       recursive calls
 0       db block gets
 262309  consistent gets
 2302    physical reads
 0       redo size
 5897978 bytes sent via SQL*Net to client
 3267    bytes received via SQL*Net from client
 263     SQL*Net roundtrips to/from client
 0 sorts (memory)
 0 sorts (disk)
 261352  rows processed
*/

/*
==> Consistent gets have increased significantly from 8664 to 262309 ...
*/

-- Step 2 (partitioned table) --
-- Performing the same select on the partitioned table however is by far a cheaper option as the full
-- table scan can take advantage of partition pruning, only having the visit partition 3

EXPLAIN PLAN FOR
SELECT
     *
FROM
     dshrivastav.big_album_sales
WHERE
     release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';
--261352 rows selected.

SELECT * FROM TABLE(dbms_xplan.display);
/*
Elapsed: 00:00:02.34
Execution Plan
----------------------------------------------------------
Plan hash value: 3245858454
----------------------------------------------------------------------------------------------------------
| Id | Operation | Name | Rows | Bytes | Cost (%CPU)|Time | Pstart| Pstop |
----------------------------------------------------------------------------------------------------------
| 0 | SELECT STATEMENT | | 262K| 6398K| 304 (2)|00:00:04 | | |
| 1 | PARTITION RANGE SINGLE| | 262K| 6398K| 304 (2)|00:00:04 | 3 | 3 |
|* 2 | TABLE ACCESS FULL | BIG_ALBUM_SALES | 262K| 6398K| 304 (2)|00:00:04 | 3 | 3 |
----------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
 2 - access("RELEASE_DATE">=TO_DATE(' 2003-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss')
 AND "RELEASE_DATE"<=TO_DATE(' 2003-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
Statistics
----------------------------------------------------------
 1       recursive calls
 0       db block gets
 1366    consistent gets
 1008    physical reads
 0 redo  size
 6945107 bytes sent via SQL*Net to client
 3267    bytes received via SQL*Net from client
 263     SQL*Net roundtrips to/from client
 0 sorts (memory)
 0 sorts (disk)
 261352  rows processed
*/

==> Consistent gets have now dropped significantly from 8664 to just 1366 ...

Note: The consistent gets Oracle metric is the number of times a consistent read (a logical RAM buffer I/O)
      was requested to get data from a data block. Part of Oracle tuning is to increase logical I/O by
      reducing the expensive disk I/O (physical reads), but high consistent gets presents it is own tuning
      challenges, especially when we see super high CPU consumption (i.e. the top 5 timed events in an AWR report).

Oracle Consistent gets:
The consistent gets Oracle metric is the number of times a consistent read (a logical RAM buffer I/O) was
requested to get data from a data block. Part of Oracle tuning is to increase logical I/O by reducing the
expensive disk I/O (physical reads), but high consistent gets presents it is own tuning challenges,
especially when we see super high CPU consumption (i.e. the "top 5 timed events" in an AWR report).

Partition-Wise Joins:
Partitioning can also improve the performance of multi-table joins by using a technique known as
partition-wise joins. Partition-wise joins can be applied when two tables are being joined together
and both tables are partitioned on the join key, or when a reference partitioned table is joined with
its parent table. Partition-wise joins break a large join into smaller joins that occur between each of
the partitions, completing the overall join in less time. This offers significant performance benefits both
for serial and parallel execution.

Partitioning Strategies:
Oracle Partitioning offers three fundamental data distribution methods as basic partitioning strategies that
control how data is placed into individual partitions:
 1.Range
 2.Hash
 3.List
Using these data distribution methods, a table can either be partitioned as a single list or as a composite partitioned table:
 * Single-Level Partitioning
 * Composite Partitioning
Each partitioning strategy has different advantages and design considerations. Thus, each strategy is more appropriate
for a particular situation.

Single-Level Partitioning (DEFAULT/TABLESPACE/STORE IN):

Range Partitioning:
Range partitioning maps data to partitions based on ranges of values of the partitioning key that you establish for
each partition. It is the most common type of partitioning and is often used with dates. For a table with a date
column as the partitioning key, the January-2005 partition would contain rows with partitioning key values
from 01-Jan-2005 to 31-Jan-2005.

Each partition has a VALUES LESS THAN clause, which specifies a non-inclusive upper bound for the partitions.
Any values of the partitioning key equal to or higher than this literal are added to the next higher partition.
All partitions, except the first, have an implicit lower bound specified by the VALUES LESS THAN clause of
the previous partition.
A MAXVALUE literal can be defined for the highest partition. MAXVALUE represents a virtual infinite value
that sorts higher than any other possible value for the partitioning key, including the NULL value.

Range Partitioning-Example.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_partitioning PURGE;

-- Create object based on the range with defalut tablespace--
CREATE TABLE dshrivastav.range_partitioning
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

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.range_partitioning PURGE;

-- Create object based on the range with user defind tablespace
CREATE TABLE dshrivastav.range_partitioning
(
 range_no      NUMBER NOT NULL,
 range_date    DATE   NOT NULL,
 comments      VARCHAR2(500)
)
PARTITION BY RANGE (range_date)
(
 PARTITION ranges_q1 VALUES LESS THAN (TO_DATE('01/02/2017', 'DD/MM/YYYY')) TABLESPACE tablespace_1,
 PARTITION ranges_q2 VALUES LESS THAN (TO_DATE('01/03/2017', 'DD/MM/YYYY')) TABLESPACE tablespace_2,
 PARTITION ranges_q3 VALUES LESS THAN (TO_DATE('01/04/2017', 'DD/MM/YYYY')) TABLESPACE tablespace_3,
 PARTITION ranges_q4 VALUES LESS THAN (TO_DATE('01/05/2017', 'DD/MM/YYYY')) TABLESPACE tablespace_4
) TABLESPACE tablespace_5;

INSERT INTO dshrivastav.range_partitioning VALUES (5,TO_DATE('01/06/2017', 'DD/MM/YYYY'),'OutOfRange');
-- ORA-14400: inserted partition key does not map to any partition

INSERT INTO dshrivastav.range_partitioning VALUES (4,TO_DATE('01/05/2017', 'DD/MM/YYYY'),'OutOfRange');
-- ORA-14400: inserted partition key does not map to any partition

INSERT INTO dshrivastav.range_partitioning VALUES (4,TO_DATE('30/04/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q4 partition');
-- 1 Row inserted

SELECT * FROM dshrivastav.range_partitioning;
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
4       4/30/2017  1 Row Inserted into ranges_q4 partition
*/


INSERT INTO dshrivastav.range_partitioning VALUES (3,TO_DATE('31/03/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q3 partition');
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
     dshrivastav.range_partitioning PARTITION (ranges_q3);
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/31/2017   1 Row Inserted into ranges_q3 partition
*/

INSERT INTO dshrivastav.range_partitioning 
VALUES (3,TO_DATE('30/03/2017', 'DD/MM/YYYY'),'1 Row Inserted into ranges_q3 partition');
-- 1 Row inserted

SELECT 
     * 
FROM dshrivastav.range_partitioning PARTITION (ranges_q3);
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/31/2017   1 Row Inserted into ranges_q3 partition
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/
   
SELECT 
     * 
FROM 
     dshrivastav.range_partitioning b PARTITION (ranges_q3)
WHERE 
     b.range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
-- ORA-00924: missing BY keyword

SELECT 
     * 
FROM 
     dshrivastav.range_partitioning  PARTITION (ranges_q3)
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
     dshrivastav.range_partitioning  PARTITION (ranges_q3) a
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
     dshrivastav.range_partitioning  PARTITION (ranges_q3) a
WHERE 
     a.range_date = TO_DATE('30/03/2017', 'DD/MM/YYYY');
/*
RANGE_NO RANGE_DATE COMMENTS
------- ---------- ------------------------------------------
3      3/30/2017   1 Row Inserted into ranges_q3 partition
*/

Using Table Compression with Partitioned Tables:
For range-organized partitioned tables, you can compress some or all partitions using table compression.
The compression attribute can be declared for a tablespace, a table, or a partition of a table. Whenever
the compress attribute is not specified, it is inherited like any other storage attribute.

The following example creates a range-partitioned table with one compressed partition costs_old.
The compression attribute for the table and all other partitions is inherited from the tablespace level.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.compress_partitioning PURGE;

-- Create object based on the range with user defind tablespace--
CREATE TABLE dshrivastav.compress_partitioning
(
 prod_id  NUMBER(6),
 time_id  DATE,
 unit_cost NUMBER(10,2),
 unit_cost NUMBER(10,2)
)
PARTITION BY RANGE (time_id)
(
 PARTITION costs_old     VALUES LESS THAN (TO_DATE('01/01/2003', 'DD/MM/YYYY')) COMPRESS,
 PARTITION costs_q1_2003 VALUES LESS THAN (TO_DATE('01/04/2003', 'DD/MM/YYYY')) COMPRESS,
 PARTITION costs_q2_2003 VALUES LESS THAN (TO_DATE('01/06/2003', 'DD/MM/YYYY')) COMPRESS,
 PARTITION costs_recent  VALUES LESS THAN (MAXVALUE) COMPRESS
);

Using Multicolumn Partitioning Keys:
For range-partitioned and hash-partitioned tables, you can specify up to 16 partitioning key columns.
Use multicolumn partitioning when the partitioning key is composed of several columns and subsequent 
columns define a higher granularity than the preceding ones. The most common scenario is a decomposed 
DATE or TIMESTAMP key, consisting of separated columns, for year, month, and day.

In evaluating multicolumn partitioning keys, the database uses the second value only if the first value
cannot uniquely identify a single target partition, and uses the third value only if the first and second
do not determine the correct partition, and so forth. A value cannot determine the correct partition only
when a partition bound exactly matches that value and the same bound is defined for the next partition.
The nth column is investigated only when all previous (n-1) values of the multicolumn key exactly match
the (n-1) bounds of a partition. A second column, for example, is evaluated only if the first column
exactly matches the partition boundary value. If all column values exactly match all of the bound values
for a partition, then the database determines that the row does not fit in this partition and considers the
next partition for a match.

For nondeterministic boundary definitions (successive partitions with identical values for at least one column),
the partition boundary value becomes an inclusive value, representing a "less than or equal to" boundary.
This is in contrast to deterministic boundaries, where the values are always regarded as "less than" boundaries.

The following example illustrates the column evaluation for a multicolumn range-partitioned table, storing the
actual DATE information in three separate columns: year, month, and day. The partitioning granularity is a
calendar quarter. The partitioned table being evaluated is created as follows:

Creating a multicolumn range-partitioned table

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.mul_range_partitioning PURGE;
-- To Creating a multicolumn range-partitioned table
CREATE TABLE dshrivastav.mul_range_partitioning
(
   year          NUMBER, 
   month         NUMBER,
   day           NUMBER,
   amount_sold   NUMBER
) 
PARTITION BY RANGE (year,month) 
(
 PARTITION before_2001 VALUES LESS THAN (2001,1),
 PARTITION q1_2001     VALUES LESS THAN (2001,4),
 PARTITION q2_2001     VALUES LESS THAN (2001,7),
 PARTITION q3_2001     VALUES LESS THAN (2001,10),
 PARTITION q4_2001     VALUES LESS THAN (2002,1),
 PARTITION future_yyyy VALUES LESS THAN (MAXVALUE,0)
);

-- 12-DEC-2000
INSERT INTO dshrivastav.mul_range_partitioning VALUES(2000,12,12,1000);
-- 17-MAR-2001
INSERT INTO dshrivastav.mul_range_partitioning VALUES(2001,3,17,2000);
-- 1-NOV-2001
INSERT INTO dshrivastav.mul_range_partitioning VALUES(2001,11,1,5000);
-- 1-JAN-2002
INSERT INTO dshrivastav.mul_range_partitioning VALUES(2002,1,1,4000);
COMMIT;

SELECT * FROM dshrivastav.mul_range_partitioning;
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2000    12  12        1000
2001     3  17        2000
2001    11   1        5000
2002     1   1        4000
*/

-- To get the number of rows in data dictionary view
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'MUL_RANGE_PARTITIONING', 
     estimate_percent => 10,
     cascade          => TRUE,
     degree           => 4, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

SELECT
     table_name,
     partition_name,
     high_value,
     high_value_length,
     partition_position,
     num_rows
FROM 
     all_tab_partitions 
WHERE table_name = 'MUL_RANGE_PARTITIONING'; 
/*
TABLE_NAME             PARTITION_NAME HIGH_VALUE  HIGH_VALUE_LENGTH PARTITION_POSITION NUM_ROWS
---------------------- -------------- ----------- ----------------- ------------------ --------
MUL_RANGE_PARTITIONING BEFORE_2001    2001, 1                     7                  1        1
MUL_RANGE_PARTITIONING Q1_2001        2001, 4                     7                  2        1
MUL_RANGE_PARTITIONING Q2_2001        2001, 7                     7                  3        0
MUL_RANGE_PARTITIONING Q3_2001        2001, 10                    8                  4        0
MUL_RANGE_PARTITIONING Q4_2001        2002, 1                     7                  5        1
MUL_RANGE_PARTITIONING FUTURE_YYYY    MAXVALUE, 0                11                  6        1
*/

--The year value for 12-DEC-2000 satisfied the first partition, before_2001, so no further evaluation 
--is needed:
SELECT * FROM dshrivastav.mul_range_partitioning PARTITION(before_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2000    12  12        1000
*/

--The information for 17-MAR-2001 is stored in partition q1_2001. The first partitioning key column,
--year, does not by itself determine the correct partition, so the second partitioning key column, month,
--must be evaluated.
SELECT * FROM dshrivastav.mul_range_partitioning PARTITION(q1_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2001     3  17        2000
*/

--Following the same determination rule as for the previous record, the second column, month,
--determines partition q4_2001 as correct partition for 1-NOV-2001:
SELECT * FROM dshrivastav.mul_range_partitioning PARTITION(q4_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2001    11   1        5000
*/

--The partition for 01-JAN-2002 is determined by evaluating only the year column, which indicates the future
--partition:
SELECT * FROM dshrivastav.mul_range_partitioning PARTITION(future_yyyy);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2002     1   1        4000
*/


If the database encounters MAXVALUE in one of the partitioning key columns, then all other values of
subsequent columns become irrelevant. That is, a definition of partition future in the preceding example,
having a bound of (MAXVALUE,0) is equivalent to a bound of (MAXVALUE,100) or a bound of (MAXVALUE,MAXVALUE).

The following example illustrates the use of a multicolumn partitioned approach for table supplier_partitioning,
storing the information about which suppliers deliver which parts. To distribute the data in equal-sized
partitions, it is not sufficient to partition the table based on the supplier_id, because some suppliers
might provide hundreds of thousands of parts, while others provide only a few specialty parts. Instead,
you partition the table on (supplier_id, partnum) to manually enforce equal-sized partitions.


-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.supplier_partitioning PURGE;
-- To Creating a multicolumn range-partitioned table with max values
CREATE TABLE dshrivastav.supplier_partitioning
(
   supplier_id      NUMBER, 
   partnum          NUMBER,
   price            NUMBER
)
PARTITION BY RANGE (supplier_id, partnum)
(
 PARTITION p1 VALUES LESS THAN  (10,100),
 PARTITION p2 VALUES LESS THAN (10,200),
 PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE)
);

INSERT INTO dshrivastav.supplier_partitioning VALUES (5,5, 1000);
INSERT INTO dshrivastav.supplier_partitioning VALUES (5,150, 1000);
INSERT INTO dshrivastav.supplier_partitioning VALUES (10,100, 1000);
COMMIT;

SELECT * FROM dshrivastav.supplier_partitioning PARTITION (p1);
/*
SUPPLIER_ID PARTNUM PRICE
----------- ------- -----
          5       5  1000
          5     150  1000
*/
SELECT * FROM dshrivastav.supplier_partitioning PARTITION (p2);
/*
SUPPLIER_ID PARTNUM PRICE
----------- ------- -----
         10     100  1000
*/

Creating a range-partitioned table with ENABLE ROW MOVEMENT:

In the following example, more complexity is added to the example presented earlier for a range-partitioned table.
Storage parameters and a LOGGING attribute are specified at the table level. These replace the corresponding defaults
inherited from the table space level for the table itself, and are inherited by the range partitions.
However, because there was little business in the first quarter, the storage attributes for partition sales_q1_2006 
are made smaller. The ENABLE ROW MOVEMENT clause is specified to allow the automatic migration of a row to a new 
storage for that partition if an update to a key value is made that would place the with new row in a storage.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_enable_row_movement PURGE;

-- To Create a range-partitioned table with enable row movement
CREATE TABLE dshrivastav.sales_enable_row_movement
(
 prod_id        NUMBER,
 cust_id        NUMBER,
 time_id        DATE,
 channel_id     CHAR(1),
 promo_id       NUMBER
)
STORAGE (INITIAL 100K NEXT 50K) LOGGING
PARTITION BY RANGE (time_id)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY'))
 TABLESPACE table_backup STORAGE (INITIAL 20K NEXT 10K),
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-FEB-2018','DD-MON-YYYY'))
 TABLESPACE table_backup,
 PARTITION sales_p3_2018 VALUES LESS THAN (TO_DATE('01-MAR-2018','DD-MON-YYYY'))
 TABLESPACE table_backup,
 PARTITION sales_p4_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','DD-MON-YYYY'))
 TABLESPACE table_backup
)
ENABLE ROW MOVEMENT
;

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows,
     initial_extent
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';

/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT 
------------------------- -------------- ------------------------------------ ------------------ -------- -------------- 
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                  1                   24576
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                  2                  106496
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                  3                  106496
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                  4                  106496
*/

-- To insert the data for partition (SALES_P1_2018)
INSERT INTO dshrivastav.sales_enable_row_movement
SELECT
     ROWNUM                               prod_id,
     MOD(ROWNUM,5000)+1                   cust_id,
     TO_DATE('31-DEC-2017','DD-MON-YYYY') time_id,
     'C'                                  channel_id,
     LEVEL                                promo_id
FROM dual
CONNECT BY LEVEL <= 200000;
--Insert - 200000 row(s), executed in 820 ms
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_ENABLE_ROW_MOVEMENT', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows,
     initial_extent
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';
/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT
------------------------- -------------- ------------------------------------ ------------------ -------- --------------
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                 1   200000          24576
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                 2                  106496
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                 3                  106496
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                 4                  106496
*/


-- To insert the data for partition (SALES_P2_2018)
INSERT INTO dshrivastav.sales_enable_row_movement
SELECT
     ROWNUM                               prod_id,
     MOD(ROWNUM,5000)+1                   cust_id,
     TO_DATE('30-JAN-2018','DD-MON-YYYY') time_id,
     'C'                                  channel_id,
     LEVEL                                promo_id
FROM dual
CONNECT BY LEVEL <= 200000;
--Insert - 200000 row(s), executed in 820 ms
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_ENABLE_ROW_MOVEMENT', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows,
     initial_extent
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';

/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT
------------------------- -------------- ------------------------------------ ------------------ -------- --------------
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                 1   200000          24576
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                 2   200000         106496
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                 3                  106496
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                 4                  106496
*/

Creating range-partitioned (Interval-Partitioned) Tables:

The INTERVAL clause of the CREATE TABLE statement establishes interval partitioning for the table.
You must specify at least one range partition using the PARTITION clause. The range partitioning
key value determines the high value of the range partitions, which is called the transition point,
and the database automatically creates interval partitions for data beyond that transition point.
The lower boundary of every interval partition is the non-inclusive upper boundary of the previous 
range or interval partition.

For example, if you create an interval partitioned table with monthly intervals and the transition point 
at January 1, 2010, then the lower boundary for the January 2010 interval is January 1, 2010. The lower boundary
for the July 2010 interval is July 1, 2010, regardless of whether the June 2010 partition was previously created.
Note, however, that using a date where the high or low bound of the partition would be out of the range set for
storage causes an error. For example, TO_DATE('9999-12-01', 'YYYY-MM-DD') causes the high bound to be 10000-01-01,
which would not be storable if 10000 is out of the legal range.

For interval partitioning, the partitioning key can only be a single column name from the table and it must be of
NUMBER or DATE type. The optional STORE IN clause lets you specify one or more tablespaces into which the database
stores interval partition data using a round-robin algorithm for subsequently created interval partitions.
The following example specifies four partitions with varying widths. It also specifies that above the transition
point of January 1, 2010, partitions are created with a width of one month. The high bound of partition p3 represents
the transition point. p3 and all partitions below it (p0, p1, and p2 in this example) are in the range section while
all partitions above it fall into the interval section.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.interval_sales_partition PURGE;

-- To Create a range-partitioned table with (Interval-Partitioned)
CREATE TABLE dshrivastav.interval_sales_partition
(
 prod_id        NUMBER(6),
 cust_id        NUMBER,
 time_id        DATE,
 channel_id     CHAR(1),
 promo_id       NUMBER(6),
 quantity_sold  NUMBER(3),
 amount_sold    NUMBER(10,2)
)
PARTITION BY RANGE (time_id) 
INTERVAL(NUMTOYMINTERVAL(1,'MONTH'))
(
 PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2007', 'DD-MM-YYYY')),
 PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2008', 'DD-MM-YYYY')),
 PARTITION p2 VALUES LESS THAN (TO_DATE('1-7-2009', 'DD-MM-YYYY')),
 PARTITION p3 VALUES LESS THAN (TO_DATE('1-1-2010', 'DD-MM-YYYY')) 
);

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'INTERVAL_SALES_PARTITION';
/*
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
------------------------ -------------- --------------------------------------------------------- ------------------ --------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1         
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  2         
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  3         
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  4         
*/

-- To insert the data into object
INSERT INTO dshrivastav.interval_sales_partition VALUES (1,1,TO_DATE('1-1-2009', 'DD-MM-YYYY'),'A',1,1,1);
COMMIT;

-- To show the object data
SELECT * FROM dshrivastav.interval_sales_partition PARTITION(p2);
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD
------- ------- ------------------- ---------- -------- ------------- -----------
      1       1 01.01.2009 00:00:00 A                 1             1           1
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'INTERVAL_SALES_PARTITION', 
     estimate_percent => 10,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'INTERVAL_SALES_PARTITION';

/*
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
------------------------ -------------- --------------------------------------------------------- ------------------ --------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1        0
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  2        0
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  3        1
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  4        0
*/

-- To insert the data into object
INSERT INTO dshrivastav.interval_sales_partition VALUES (1,1,TO_DATE('30-12-2030', 'DD-MM-YYYY'),'A',1,1,1);
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'INTERVAL_SALES_PARTITION', 
     estimate_percent => 10,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'INTERVAL_SALES_PARTITION';
/*
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
------------------------ -------------- --------------------------------------------------------- ------------------ ---------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1        0
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  2        0
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  3        1
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  4        0
INTERVAL_SALES_PARTITION SYS_P97763     TO_DATE(' 2031-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  5        1
*/

-- To show the object data
SELECT * FROM dshrivastav.interval_sales_partition PARTITION(SYS_P97763);
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD
------- ------- ------------------- ---------- -------- ------------- -----------
      1       1 30.12.2030 00:00:00 A                 1             1           1
*/

Using Virtual Column-Based Range-Partitioning:

With partitioning, a virtual column can be used as any regular column. All partition methods are supported when using virtual columns.
A virtual column used as the partitioning column cannot use calls to a PL/SQL function.
The following example shows the sales_partitioning table partitioned by range-range using 
a virtual  column with enable row movements and in no loging mode.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_partitioning PURGE;

-- To Creating a Virtual column for the range-partitioned table with max values
CREATE TABLE dshrivastav.sales_partitioning
( 
  prod_id       NUMBER(6) NOT NULL,
  cust_id       NUMBER NOT NULL,
  time_id       DATE NOT NULL,
  channel_id    CHAR(1) NOT NULL,
  promo_id      NUMBER(6) NOT NULL,
  quantity_sold NUMBER(3) NOT NULL,
  amount_sold   NUMBER(10,2) NOT NULL,
  total_amount  AS (quantity_sold * amount_sold)
)
PARTITION BY RANGE (time_id) 
(
 PARTITION sales_before_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY')) TABLESPACE TABLE_BACKUP,
 PARTITION sales_after_2018 VALUES LESS THAN (MAXVALUE) TABLESPACE TABLE_BACKUP
)
ENABLE ROW MOVEMENT
PARALLEL NOLOGGING;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_OWNER TABLE_NAME         PARTITION_NAME    HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- --------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1         
DSHRIVASTAV SALES_PARTITIONING SALES_AFTER_2018  MAXVALUE                                                                   2         
*/

-- Insert the data for virtual columns
INSERT INTO dshrivastav.sales_partitioning 
(
 prod_id,
 cust_id,
 time_id,
 channel_id,
 promo_id,
 quantity_sold,
 amount_sold,
 total_amount
) 
SELECT                       
     1         prod_id,      
     100       cust_id,      
     SYSDATE   time_id,      
     'A'       channel_id,   
     10        promo_id,     
     50        quantity_sold,
     50        amount_sold,
     2500      total_amount
FROM 
     dual;
--ORA-54013: INSERT operation disallowed on virtual columns 
 
-- Insert the data into table (sales_partitioning)
INSERT INTO dshrivastav.sales_partitioning 
(
 prod_id,
 cust_id,
 time_id,
 channel_id,
 promo_id,
 quantity_sold,
 amount_sold
) 
SELECT 
     1         prod_id,      
     100       cust_id,      
     SYSDATE   time_id,      
     'A'       channel_id,   
     10        promo_id,     
     50        quantity_sold,
     50        amount_sold
FROM 
     dual;
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.sales_partitioning;
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD TOTAL_AMOUNT
------- ------- ------------------- ---------- -------- ------------- ----------- ------------
      1     100 23.04.2018 11:24:32 A                10            50          50         2500
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_PARTITIONING', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_OWNER TABLE_NAME         PARTITION_NAME    HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- --------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1        0
DSHRIVASTAV SALES_PARTITIONING SALES_AFTER_2018  MAXVALUE                                                                   2        1
*/

Creating reference-partitioned tables:

To create a reference-partitioned table, you specify a PARTITION BY REFERENCE clause in the CREATE TABLE statement.
This clause specifies the name of a referential constraint and this constraint becomes the partitioning referential
constraint that is used as the basis for reference partitioning in the table.
The referential constraint must be enabled and enforced.

As with other partitioned tables, you can specify object-level default attributes, and you can optionally specify
partition descriptors that override the object-level defaults on a per-partition basis.

The following example creates a parent table parent_orders_partitioned which is range-partitioned on order_date.
The reference-partitioned child table child_order_items_partitioned is created with four partitions, Q1_2018, Q2_2018, Q3_2018,
and Q4_2018, where each PARTITION contains the child_order_items_partitioned rows corresponding to parent_orders_partitioned
in the respective parent partition.

Creating reference-partitioned tables - Example

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.parent_orders_partitioned PURGE;

-- To Creating a range reference-partitioning, Parent-table
CREATE TABLE dshrivastav.parent_orders_partitioned
(
 order_id           NUMBER(12),
 order_date         DATE,
 order_mode         VARCHAR2(8),
 customer_id        NUMBER(6),
 order_status       NUMBER(2),
 order_total        NUMBER(8,2),
 sales_rep_id       NUMBER(6),
 promotion_id       NUMBER(6),
 CONSTRAINT orders_pk PRIMARY KEY(order_id)
)
PARTITION BY RANGE(order_date)
( 
 PARTITION Q1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','DD-MON-YYYY')),
 PARTITION Q2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','DD-MON-YYYY')),
 PARTITION Q3_2018 VALUES LESS THAN (TO_DATE('01-OCT-2018','DD-MON-YYYY')),
 PARTITION Q4_2018 VALUES LESS THAN (TO_DATE('01-DEC-2018','DD-MON-YYYY'))
);

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.child_order_items_partitioned PURGE;

-- To Creating a range reference-partitioning, Child-table
CREATE TABLE dshrivastav.child_order_items_partitioned
( 
 order_id           NUMBER(12) NOT NULL,
 line_item_id       NUMBER(3)  NOT NULL,
 product_id         NUMBER(6)  NOT NULL,
 unit_price         NUMBER(8,2),
 quantity           NUMBER(8),
 CONSTRAINT fk_child_order_items_partition
 FOREIGN KEY(order_id)
 REFERENCES parent_orders_partitioned(order_id)
)
PARTITION BY REFERENCE(fk_child_order_items_partition);

-- To show the object structure(partitions)
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name IN ('PARENT_ORDERS_PARTITIONED','CHILD_ORDER_ITEMS_PARTITIONED');
/*
TABLE_NAME                    PARTITION_NAME HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
----------------------------- -------------- --------------------------------------------------------- ------------------ --------
CHILD_ORDER_ITEMS_PARTITIONED Q1_2018                                                                                   1         
CHILD_ORDER_ITEMS_PARTITIONED Q2_2018                                                                                   2         
CHILD_ORDER_ITEMS_PARTITIONED Q3_2018                                                                                   3         
CHILD_ORDER_ITEMS_PARTITIONED Q4_2018                                                                                   4         
PARENT_ORDERS_PARTITIONED     Q1_2018        TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1         
PARENT_ORDERS_PARTITIONED     Q2_2018        TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  2         
PARENT_ORDERS_PARTITIONED     Q3_2018        TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  3         
PARENT_ORDERS_PARTITIONED     Q4_2018        TO_DATE(' 2018-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  4         
*/
SELECT 
     owner,
     table_name,
     constraint_name,
     status,validated
FROM 
     user_constraints
WHERE table_name IN ('PARENT_ORDERS_PARTITIONED','CHILD_ORDER_ITEMS_PARTITIONED');
/*
OWNER       TABLE_NAME                    CONSTRAINT_NAME                STATUS  VALIDATED
----------- ----------------------------- ------------------------------ ------- ---------
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED SYS_C00104903                  ENABLED VALIDATED
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED SYS_C00104904                  ENABLED VALIDATED
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED SYS_C00104905                  ENABLED VALIDATED
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED FK_CHILD_ORDER_ITEMS_PARTITION ENABLED VALIDATED
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     ORDERS_PK                      ENABLED VALIDATED
*/

INSERT INTO dshrivastav.parent_orders_partitioned
(
 order_id,
 order_date,
 order_mode,
 customer_id,
 order_status,
 order_total,
 sales_rep_id,
 promotion_id
)
SELECT
     1       order_id,
     SYSDATE order_date,
     'Y'     order_mode,
     100     customer_id,
     1       order_status,
     5000    order_total,
     5       sales_rep_id,
     2       promotion_id 
FROM dual;
--Insert - 1 row(s), executed in 28 ms
COMMIT;

INSERT INTO dshrivastav.child_order_items_partitioned
( 
 order_id,
 line_item_id,
 product_id,
 unit_price,
 quantity
)
SELECT
     1       order_id,
     1       line_item_id,
     5       product_id,
     5       unit_price,
     5000    quantity 
FROM dual;
--Insert - 1 row(s), executed in 80 ms
COMMIT;
  
-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'PARENT_ORDERS_PARTITIONED', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'CHILD_ORDER_ITEMS_PARTITIONED', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/


-- To show the object structure(partitions)
SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name IN ('PARENT_ORDERS_PARTITIONED','CHILD_ORDER_ITEMS_PARTITIONED');
/*
TABLE_NAME                    PARTITION_NAME HIGH_VALUE                                                PARTITION_POSITION NUM_ROWS
----------------------------- -------------- --------------------------------------------------------- ------------------ --------
CHILD_ORDER_ITEMS_PARTITIONED Q1_2018                                                                                   1        0
CHILD_ORDER_ITEMS_PARTITIONED Q2_2018                                                                                   2        1
CHILD_ORDER_ITEMS_PARTITIONED Q3_2018                                                                                   3        0
CHILD_ORDER_ITEMS_PARTITIONED Q4_2018                                                                                   4        0
PARENT_ORDERS_PARTITIONED     Q1_2018        TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  1        0
PARENT_ORDERS_PARTITIONED     Q2_2018        TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  2        1
PARENT_ORDERS_PARTITIONED     Q3_2018        TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  3        0
PARENT_ORDERS_PARTITIONED     Q4_2018        TO_DATE(' 2018-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')                  4        0
*/

Hash Partitioning Tables:

Hash partitioning maps data to partitions based on a hashing algorithm that Oracle applies to the partitioning key that you identify.
The hashing algorithm evenly distributes rows among partitions, giving partitions approximately the same size.

Hash partitioning is useful when there is no obvious range key, or range partitioning will cause uneven distribution of data. 
The number of partitions must be a power of 2 (2, 4, 8, 16...) and can be specified by the PARTITIONS...STORE IN clause.
The nature of hash partitioning depend on The values returned by a hash function are called hash values, hash codes, digests,
or simply hashes.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.hash_partitioning_no_name PURGE;

-- To Creating a Hash Partitioning table without partitions name
CREATE TABLE dshrivastav.hash_partitioning_no_name
(
 hash_no    NUMBER NOT NULL,
 hash_date  DATE   NOT NULL,
 comments          VARCHAR2(500)
)
PARTITION BY HASH (hash_no)
PARTITIONS 2
STORE IN (table_backup, retail_data)
;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'HASH_PARTITIONING_NO_NAME';

/*
TABLE_OWNER TABLE_NAME                PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME NUM_ROWS
----------- ------------------------- -------------- ---------- ------------------ --------------- --------
DSHRIVASTAV HASH_PARTITIONING_NO_NAME SYS_P97833                                 1 TABLE_BACKUP            
DSHRIVASTAV HASH_PARTITIONING_NO_NAME SYS_P97834                                 2 RETAIL_DATA             
*/

-- Insert the data
INSERT INTO dshrivastav.hash_partitioning_no_name VALUES (1,SYSDATE,'A');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.hash_partitioning_no_name;
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'HASH_PARTITIONING_NO_NAME', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'HASH_PARTITIONING_NO_NAME';

/*
TABLE_OWNER TABLE_NAME                PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME NUM_ROWS
----------- ------------------------- -------------- ---------- ------------------ --------------- --------
DSHRIVASTAV HASH_PARTITIONING_NO_NAME SYS_P97833                                 1 TABLE_BACKUP           0
DSHRIVASTAV HASH_PARTITIONING_NO_NAME SYS_P97834                                 2 RETAIL_DATA            1
*/

SELECT * FROM dshrivastav.hash_partitioning_no_name PARTITION(sys_p97832);
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/
-----

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.hash_partitioning_with_name PURGE;

-- To Creating a Hash Partitioning table with partitions name/tablespace name
CREATE TABLE dshrivastav.hash_partitioning_with_name
(
 hash_no    NUMBER NOT NULL,
 hash_date  DATE   NOT NULL,
 comments          VARCHAR2(500)
)
PARTITION BY HASH (hash_no)
(
 PARTITION p1 TABLESPACE table_backup,
 PARTITION p2 TABLESPACE retail_data
);

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'HASH_PARTITIONING_WITH_NAME';

/*
TABLE_OWNER TABLE_NAME                  PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME NUM_ROWS
----------- --------------------------- -------------- ---------- ------------------ --------------- --------
DSHRIVASTAV HASH_PARTITIONING_WITH_NAME P1                                         1 TABLE_BACKUP            
DSHRIVASTAV HASH_PARTITIONING_WITH_NAME P2                                         2 RETAIL_DATA             
*/

-- Insert the data
INSERT INTO dshrivastav.hash_partitioning_with_name VALUES (1,SYSDATE,'A');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.hash_partitioning_with_name;
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'HASH_PARTITIONING_WITH_NAME', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'HASH_PARTITIONING_WITH_NAME';

/*
TABLE_OWNER TABLE_NAME                  PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME NUM_ROWS
----------- --------------------------- -------------- ---------- ------------------ --------------- --------
DSHRIVASTAV HASH_PARTITIONING_WITH_NAME P1                                         1 TABLE_BACKUP           0
DSHRIVASTAV HASH_PARTITIONING_WITH_NAME P2                                         2 RETAIL_DATA            1
*/

SELECT * FROM dshrivastav.hash_partitioning_with_name PARTITION(p2);
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/


-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.hash_partitioning_compress PURGE;

-- To Creating a Hash Partitioning table with compressed
CREATE TABLE dshrivastav.hash_partitioning_compress
(
 hash_no    NUMBER NOT NULL,
 hash_date  DATE   NOT NULL,
 comments          VARCHAR2(500)
)
PARTITION BY HASH (hash_no)
(
 PARTITION p1 TABLESPACE table_backup COMPRESS,
 PARTITION p2 TABLESPACE retail_data  COMPRESS
);

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.hash_partitioning_enablerowmv PURGE;

-- To Creating a Hash Partitioning table with enable row movment/logging/parallel
CREATE TABLE dshrivastav.hash_partitioning_enablerowmv
(
 hash_no    NUMBER NOT NULL,
 hash_date  DATE   NOT NULL,
 comments          VARCHAR2(500)
)
STORAGE (INITIAL 100K NEXT 50K) LOGGING
PARTITION BY HASH (hash_no)
(
 PARTITION p1 TABLESPACE table_backup
)
ENABLE ROW MOVEMENT
PARALLEL;

List-Partitioned Tables:

The semantics for creating list partitions are very similar to those for creating range partitions. 
However, to create list partitions, you specify a PARTITION BY LIST clause in the 
CREATE TABLE statement, and the PARTITION clauses specify lists of literal values, 
which are the discrete values of the partitioning columns that qualify rows to be included in the partition. 
For list partitioning, the partitioning key can only be a single column name from the table.

Available only with list partitioning, you can use the keyword DEFAULT to describe the value list for a partition. 
This identifies a partition that accommodates rows that do not map into any of the other partitions.

List-Partitioned Tables - Example


-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.list_partitioned PURGE;

-- To Creating a List Partitioning table
CREATE TABLE dshrivastav.list_partitioned
(
 deptno          NUMBER, 
 deptname        VARCHAR2(20),
 alphabets       VARCHAR2(20)
)
PARTITION BY LIST (alphabets)
(
 PARTITION list_p1  VALUES ('A'),
 PARTITION list_p2  VALUES ('B','C')
)
TABLESPACE table_backup;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name
FROM 
     all_tab_partitions
WHERE table_name = 'LIST_PARTITIONED';

/*
TABLE_OWNER TABLE_NAME       PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME
----------- ---------------- -------------- ---------- ------------------ ---------------
DSHRIVASTAV LIST_PARTITIONED LIST_P1        'A'                         1 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED LIST_P2        'B', 'C'                    2 TABLE_BACKUP   
*/

-- Insert the data
INSERT INTO dshrivastav.list_partitioned VALUES (2,'dpt_2','B');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.list_partitioned PARTITION(list_p2);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     2 dpt_2    B        
*/

-- Insert the data
INSERT INTO dshrivastav.list_partitioned VALUES (3,'dpt_3','E');
-- ORA-14400: inserted partition key does not map to any partition

Creating a List-Partitioned Table With a Default Partition:

Unlike range partitioning, with list partitioning, there is no apparent sense of order between partitions.
You can also specify a default partition into which rows that do not map to any other partition are mapped.
If a default partition were specified in the preceding example, the state CA would map to that partition.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.list_partitioned_default PURGE;

-- To Creating a List Partitioning table
CREATE TABLE dshrivastav.list_partitioned_default
(
 deptno          NUMBER, 
 deptname        VARCHAR2(20),
 alphabets       VARCHAR2(20)
)
PARTITION BY LIST (alphabets)
(
 PARTITION list_p1        VALUES ('A'),
 PARTITION list_p2        VALUES ('B','C'),
 PARTITION list_p_others  VALUES (DEFAULT)
)
TABLESPACE table_backup;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name
FROM 
     all_tab_partitions
WHERE table_name = 'LIST_PARTITIONED_DEFAULT';

/*
TABLE_OWNER TABLE_NAME               PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME
----------- ------------------------ -------------- ---------- ------------------ ---------------
DSHRIVASTAV LIST_PARTITIONED_DEFAULT LIST_P1        'A'                         1 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED_DEFAULT LIST_P2        'B', 'C'                    2 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED_DEFAULT LIST_P_OTHERS  DEFAULT                     3 TABLE_BACKUP   
*/

-- Insert the data
INSERT INTO dshrivastav.list_partitioned_default VALUES (3,'dpt_3','E');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.list_partitioned_default PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     3 dpt_3    E        
*/

-- Insert the data => i.e Wrong approach 
INSERT INTO dshrivastav.list_partitioned_default VALUES (4,'dpt_4',NULL);
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.list_partitioned_default PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
     3 dpt_3    E        
     4 dpt_4             
*/

Creating a List-Partitioned Table With a DEFAULT/NULL Partition:

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.list_partitioned_default_null PURGE;

-- To Creating a List Partitioning table
CREATE TABLE dshrivastav.list_partitioned_default_null
(
 deptno          NUMBER, 
 deptname        VARCHAR2(20),
 alphabets       VARCHAR2(20)
)
PARTITION BY LIST (alphabets)
(
 PARTITION list_p1        VALUES ('A'),
 PARTITION list_p2        VALUES ('B','C'),
 PARTITION list_p_nulls   VALUES (NULL),
 PARTITION list_p_others  VALUES (DEFAULT)
)
TABLESPACE table_backup;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name
FROM 
     all_tab_partitions
WHERE table_name = 'LIST_PARTITIONED_DEFAULT_NULL';

/*
TABLE_OWNER TABLE_NAME                    PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME
----------- ----------------------------- -------------- ---------- ------------------ ---------------
DSHRIVASTAV LIST_PARTITIONED_DEFAULT_NULL LIST_P1        'A'                         1 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED_DEFAULT_NULL LIST_P2        'B', 'C'                    2 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED_DEFAULT_NULL LIST_P_NULLS   NULL                        3 TABLE_BACKUP   
DSHRIVASTAV LIST_PARTITIONED_DEFAULT_NULL LIST_P_OTHERS  DEFAULT                     4 TABLE_BACKUP   
*/

-- Insert the data
INSERT INTO dshrivastav.list_partitioned_default_null VALUES (4,'dpt_',NULL);
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.list_partitioned_default_null PARTITION(list_p_nulls);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     3 dpt_            
*/

-- Insert the data
INSERT INTO dshrivastav.list_partitioned_default_null VALUES (4,'dpt_4','E');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.list_partitioned_default_null PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
     4 dpt_4    E                   
*/

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.list_partitioned PURGE;

-- To Creating a List Partitioning table
CREATE TABLE dshrivastav.list_partitioned
(
 deptno          NUMBER, 
 deptname        VARCHAR2(20),
 alphabets       VARCHAR2(20)
)
STORAGE(INITIAL 100K NEXT 10K) TABLESPACE table_backup
PARTITION BY LIST (alphabets)
(
 PARTITION list_p1        VALUES ('A')      COMPRESS,
 PARTITION list_p2        VALUES ('B','C')  STORAGE(INITIAL 1K NEXT 20K) TABLESPACE shrivastav,
 PARTITION list_p_nulls   VALUES (NULL),
 PARTITION list_p_others  VALUES (DEFAULT)
)
ENABLE ROW MOVEMENT
PARALLEL LOGGING;

SELECT
     table_name,
     partition_name,
     high_value,
     partition_position,
     tablespace_name,
     initial_extent,
     next_extent,
     logging,
     compression
FROM 
     all_tab_partitions
WHERE table_name = 'LIST_PARTITIONED';

/*
TABLE_NAME       PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME INITIAL_EXTENT NEXT_EXTENT LOGGING COMPRESSION
---------------- -------------- ---------- ------------------ --------------- -------------- ----------- ------- -----------
LIST_PARTITIONED LIST_P1        'A'                         1 TABLE_BACKUP            106496       16384 YES     ENABLED    
LIST_PARTITIONED LIST_P2        'B', 'C'                    2 SHRIVASTAV               16384       24576 YES     DISABLED   
LIST_PARTITIONED LIST_P_NULLS   NULL                        3 TABLE_BACKUP            106496       16384 YES     DISABLED   
LIST_PARTITIONED LIST_P_OTHERS  DEFAULT                     4 TABLE_BACKUP            106496       16384 YES     DISABLED   
*/

Composite Partitioning:

Composite partitioning is a combination of the two partition method. Table is partitioned by one data distributed method. 
The types of Composite Partitioning are:
 * Composite Range-Range Partitioning.
 * Composite Range-Hash Partitioning.
 * Composite Range-List Partitioning.
 * Composite Hash-Hash Partitioning.
 * Composite Hash-Range Partitioning.
 * Composite Hash-List Partitioning.
 * Composite List-List Partitioning.
 * Composite List-Range Partitioning.
 * Composite List-Hash Partitioning.

Creating Composite Range-Range Partitioned Tables:

The range partitions of a range-range composite partitioned table are described as for non-composite range partitioned tables.
This allows that optional subclauses of a PARTITION clause can specify physical and other attributes, including tablespace,
specific to a partition segment. If not overridden at the partition level, partitions inherit the attributes of their underlying table.
The range subpartition descriptions, in the SUBPARTITION clauses, are described as for non-composite range partitions, except the only
physical attribute that can be specified is an optional tablespace. Subpartitions inherit all other physical attributes from
the partition description.

The following example illustrates how range-range partitioning might be used. The example tracks shipments.
The service level agreement with the customer states that every order is delivered in the calendar month after the order was placed.
The following types of orders are identified:

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.shipment_composite_partition PURGE;

-- To Creating a Composite Range-Range Partitioned Tables table with subpartition name
CREATE TABLE dshrivastav.shipment_composite_partition
(
 order_id      NUMBER NOT NULL,
 order_date    DATE NOT NULL,
 delivery_date DATE NOT NULL,
 customer_id   NUMBER NOT NULL,
 sales_amount  NUMBER NOT NULL
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY RANGE (delivery_date)
(
 PARTITION p_2018_jan VALUES LESS THAN (TO_DATE('30-JAN-2018','dd-MON-yyyy'))
  (SUBPARTITION sp_jan_1   VALUES LESS THAN (TO_DATE('01-JAN-2018','dd-MON-yyyy')),
   SUBPARTITION sp_jan_2   VALUES LESS THAN (TO_DATE('20-JAN-2018','dd-MON-yyyy')),
   SUBPARTITION sp_jan_max VALUES LESS THAN (MAXVALUE)),
 PARTITION p_2018_feb VALUES LESS THAN (TO_DATE('28-FEB-2018','dd-MON-yyyy'))
  (SUBPARTITION sp_feb_1   VALUES LESS THAN (TO_DATE('01-FEB-2018','dd-MON-yyyy')),
   SUBPARTITION sp_feb_2   VALUES LESS THAN (TO_DATE('20-FEB-2018','dd-MON-yyyy')),
   SUBPARTITION sp_feb_max VALUES LESS THAN (MAXVALUE)),
 PARTITION p_2018_max VALUES LESS THAN (MAXVALUE)
  (SUBPARTITION sp_mar_1 VALUES LESS THAN (TO_DATE('01-MAR-2018','dd-MON-yyyy')),
   SUBPARTITION sp_mar_2 VALUES LESS THAN (TO_DATE('20-MAR-2018','dd-MON-yyyy')),
   SUBPARTITION sp_max   VALUES LESS THAN (MAXVALUE))
) TABLESPACE table_backup;

-- Insert the data for Composite Range-Range Partitioned Tables
INSERT INTO dshrivastav.shipment_composite_partition
SELECT 
     LEVEL                               order_id,
     SYSDATE-((30*LEVEL))                order_date,
     SYSDATE-((30*LEVEL)+LEVEL)          delivery_date,
     CEIL(dbms_random.VALUE(1,LEVEL))    customer_id,
     CEIL(dbms_random.VALUE(1000,50000)) sales_amount 
FROM dual
CONNECT BY LEVEL <= 10;
COMMIT;

-- Inserted Data Varification --
/*
ORDER_ID ORDER_DATE          DELIVERY_DATE       CUSTOMER_ID SALES_AMOUNT
-------- ------------------- ------------------- ----------- ------------
       1 20.04.2018 23:08:17 19.04.2018 23:08:17           1        48541
       2 21.03.2018 23:08:17 19.03.2018 23:08:17           2        15635
       3 19.02.2018 23:08:17 16.02.2018 23:08:17           2        44930
       4 20.01.2018 23:08:17 16.01.2018 23:08:17           2        22128
       5 21.12.2017 23:08:17 16.12.2017 23:08:17           3        14398
       6 21.11.2017 23:08:17 15.11.2017 23:08:17           3         5830
       7 22.10.2017 23:08:17 15.10.2017 23:08:17           5        21165
       8 22.09.2017 23:08:17 14.09.2017 23:08:17           3         9254
       9 23.08.2017 23:08:17 14.08.2017 23:08:17           5        13961
      10 24.07.2017 23:08:17 14.07.2017 23:08:17           6        12635
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SHIPMENT_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/
-- To show the object structure(for - partitions)
SELECT
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SHIPMENT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
-------------- ------------------ ------------------ ------------------------------------------------------------------
P_2018_JAN                      3                  1        7 TO_DATE(' 2018-01-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_FEB                      3                  2        1 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_MAX                      3                  3        2 MAXVALUE                                                 
*/

-- To show the object structure(for - sub-partitions)
SELECT
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SHIPMENT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
-------------- ----------------- --------------------- ---------------------------------------------------------
P_2018_FEB     SP_FEB_1                              1 TO_DATE(' 2018-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_FEB     SP_FEB_2                              2 TO_DATE(' 2018-02-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_FEB     SP_FEB_MAX                            3 MAXVALUE                                                 
P_2018_JAN     SP_JAN_1                              1 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_JAN     SP_JAN_2                              2 TO_DATE(' 2018-01-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_JAN     SP_JAN_MAX                            3 MAXVALUE                                                 
P_2018_MAX     SP_MAR_1                              1 TO_DATE(' 2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_MAX     SP_MAR_2                              2 TO_DATE(' 2018-03-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2018_MAX     SP_MAX                                3 MAXVALUE                                                 
*/

-- To identified the data relevant with partition and subpartition
SELECT
     'PARTITION    => p_2018_jan' partition_and_sub_name,
     order_id,
     order_date,
     delivery_date,
     customer_id,
     sales_amount 
FROM
     dshrivastav.shipment_composite_partition PARTITION(p_2018_jan) 
WHERE
     order_id =4
UNION ALL 
SELECT
     'SUBPARTITION => sp_jan_2' partition_and_sub_name,
     order_id,
     order_date,
     delivery_date,
     customer_id,
     sales_amount 
FROM
     dshrivastav.shipment_composite_partition SUBPARTITION(sp_jan_2)
WHERE
     order_id =4;

/*
PARTITION_AND_SUB_NAME     ORDER_ID ORDER_DATE          DELIVERY_DATE       CUSTOMER_ID SALES_AMOUNT
-------------------------- -------- ------------------- ------------------- ----------- ------------
PARTITION    => p_2018_jan        4 20.01.2018 23:08:12 16.01.2018 23:08:12           2        14794
SUBPARTITION => sp_jan_2          4 20.01.2018 23:08:12 16.01.2018 23:08:12           2        14794
*/

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.shipment_composite_partition PURGE;

-- To Creating a Composite Range-Range Partitioned Tables table withiout subpartition name (Wrong practice)
CREATE TABLE dshrivastav.shipment_composite_partition
(
 order_id      NUMBER NOT NULL,
 order_date    DATE NOT NULL,
 delivery_date DATE NOT NULL,
 customer_id   NUMBER NOT NULL,
 sales_amount  NUMBER NOT NULL
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY RANGE (delivery_date) 
(
 PARTITION p_2018_jan VALUES LESS THAN (TO_DATE('30-JAN-2018','dd-MON-yyyy')) TABLESPACE TABLE_BACKUP,
 PARTITION p_2018_feb VALUES LESS THAN (TO_DATE('28-FEB-2018','dd-MON-yyyy')) TABLESPACE TABLE_BACKUP,
 PARTITION p_2018_max VALUES LESS THAN (MAXVALUE) TABLESPACE TABLE_BACKUP
)ENABLE ROW MOVEMENT;


-- To show the object structure(for - partitions)
SELECT
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SHIPMENT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLE_NAME                   PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION HIGH_VALUE
---------------------------- -------------- ------------------ ------------------ ---------------------------------------------------------
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN                      1                  1 TO_DATE(' 2018-01-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB                      1                  2 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX                      1                  3 MAXVALUE                                                 
*/


-- To show the object structure(for - sub-partitions)
SELECT
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SHIPMENT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLE_NAME                   PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
---------------------------- -------------- ----------------- --------------------- ----------
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB     SYS_SUBP103545                        1 MAXVALUE  
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN     SYS_SUBP103544                        1 MAXVALUE  
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX     SYS_SUBP103546                        1 MAXVALUE  
*/

Using Virtual Column-Based Range-Range-Sub-Partitioning:

With partitioning, a virtual column can be used as any regular column. All partition methods are supported when using virtual columns,
including interval partitioning and all different combinations of composite partitioning. A virtual column used as the partitioning column
cannot use calls to a PL/SQL function.
The following example shows the sales_partitioning table partitioned by range-range using a virtual column for the subpartitioning key.
The virtual column calculates the total value of a sale by multiplying amount_sold and quantity_sold.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_partitioning PURGE;

-- To Creating a Virtual column for the range-range-subpartitioning-partitioned table with max values
CREATE TABLE dshrivastav.sales_partitioning
( 
  prod_id       NUMBER(6) NOT NULL,
  cust_id       NUMBER NOT NULL,
  time_id       DATE NOT NULL,
  channel_id    CHAR(1) NOT NULL,
  promo_id      NUMBER(6) NOT NULL,
  quantity_sold NUMBER(3) NOT NULL,
  amount_sold   NUMBER(10,2) NOT NULL,
  total_amount  AS (quantity_sold * amount_sold)
)
PARTITION BY RANGE (time_id) 
INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
SUBPARTITION BY RANGE(total_amount)
SUBPARTITION TEMPLATE
( 
 SUBPARTITION p_small   VALUES LESS THAN (1000)     TABLESPACE table_backup,
 SUBPARTITION p_medium  VALUES LESS THAN (5000)     TABLESPACE table_backup,
 SUBPARTITION p_large   VALUES LESS THAN (10000)    TABLESPACE table_backup,
 SUBPARTITION p_extreme VALUES LESS THAN (MAXVALUE) TABLESPACE table_backup
)
(PARTITION sales_before_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY')) TABLESPACE table_backup
)
ENABLE ROW MOVEMENT
PARALLEL NOLOGGING;

-- To show the object structure(partitions)
SELECT
     table_name,
     partition_name,
     subpartition_count,
     high_value,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_COUNT HIGH_VALUE                                                NUM_ROWS
------------------ ----------------- ------------------ --------------------------------------------------------- --------
SALES_PARTITIONING SALES_BEFORE_2018                  4 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')         
*/

-- To show the object structure(sub-partitions)
SELECT 
     table_name,
     partition_name,
     subpartition_name,
     high_value,
     high_value_length,
     subpartition_position,
     tablespace_name
FROM 
     all_tab_subpartitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_NAME           HIGH_VALUE HIGH_VALUE_LENGTH SUBPARTITION_POSITION TABLESPACE_NAME
------------------ ----------------- --------------------------- ---------- ----------------- --------------------- ---------------
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_SMALL   1000                       4                     1 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_MEDIUM  5000                       4                     2 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_LARGE   10000                      5                     3 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_EXTREME MAXVALUE                   8                     4 TABLE_BACKUP   
*/

-- Insert the data for virtual columns
INSERT INTO dshrivastav.sales_partitioning 
(
 prod_id,
 cust_id,
 time_id,
 channel_id,
 promo_id,
 quantity_sold,
 amount_sold,
 total_amount
) 
SELECT                       
     1         prod_id,      
     100       cust_id,      
     SYSDATE   time_id,      
     'A'       channel_id,   
     10        promo_id,     
     50        quantity_sold,
     50        amount_sold,
     2500      total_amount
FROM 
     dual;
--ORA-54013: INSERT operation disallowed on virtual columns 
 
-- Insert the data into table (sales_partitioning)
INSERT INTO dshrivastav.sales_partitioning 
(
 prod_id,
 cust_id,
 time_id,
 channel_id,
 promo_id,
 quantity_sold,
 amount_sold
) 
SELECT 
     1         prod_id,      
     100       cust_id,      
     SYSDATE   time_id,      
     'A'       channel_id,   
     10        promo_id,     
     50        quantity_sold,
     50        amount_sold
FROM 
     dual;
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM dshrivastav.sales_partitioning;
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD TOTAL_AMOUNT
------- ------- ------------------- ---------- -------- ------------- ----------- ------------
      1     100 23.04.2018 13:35:38 A                10            50          50         2500
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_PARTITIONING', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(partitions)
SELECT
     table_name,
     partition_name,
     subpartition_count,
     high_value,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_COUNT HIGH_VALUE                                                NUM_ROWS
------------------ ----------------- ------------------ --------------------------------------------------------- --------
SALES_PARTITIONING SALES_BEFORE_2018                  4 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')        0
SALES_PARTITIONING SYS_P97805                         4 TO_DATE(' 2018-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')        1
*/

-- To show the object structure(sub-partitions)
SELECT 
     table_name,
     partition_name,
     subpartition_name,
     high_value,
     high_value_length,
     subpartition_position,
     tablespace_name
FROM 
     all_tab_subpartitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_NAME           HIGH_VALUE HIGH_VALUE_LENGTH SUBPARTITION_POSITION TABLESPACE_NAME
------------------ ----------------- --------------------------- ---------- ----------------- --------------------- ---------------
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_SMALL   1000                       4                     1 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_MEDIUM  5000                       4                     2 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_LARGE   10000                      5                     3 TABLE_BACKUP   
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_EXTREME MAXVALUE                   8                     4 TABLE_BACKUP   
SALES_PARTITIONING SYS_P97805        SYS_SUBP97801               1000                       4                     1 TABLE_BACKUP   
SALES_PARTITIONING SYS_P97805        SYS_SUBP97802               5000                       4                     2 TABLE_BACKUP   
SALES_PARTITIONING SYS_P97805        SYS_SUBP97803               10000                      5                     3 TABLE_BACKUP   
SALES_PARTITIONING SYS_P97805        SYS_SUBP97804               MAXVALUE                   8                     4 TABLE_BACKUP   
*/

Creating Composite Range-Hash Partitioned Tables:

The partitions of a range-hash partitioned table are logical structures only, as their data is stored in the segments of
their subpartitions. As with partitions, these subpartitions share the same logical attributes. Unlike range partitions 
in a range-partitioned table, the subpartitions cannot have different physical attributes from the owning partition, 
although they are not required to reside in the same tablespace.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_composite_partition PURGE;

-- To Creating a range-hash-partitioned table
CREATE TABLE dshrivastav.sales_composite_partition
(
 prod_id       NUMBER(6),
 cust_id       NUMBER,
 time_id       DATE
)
PARTITION BY RANGE (time_id)
SUBPARTITION BY HASH (cust_id)
(
 PARTITION p_2017_oct VALUES LESS THAN (TO_DATE('30-OCT-2017','dd-MON-yyyy'))
 (SUBPARTITION sp_2017_oct),
 PARTITION p_2017_dec VALUES LESS THAN (TO_DATE('30-DEC-2017','dd-MON-yyyy'))
 (SUBPARTITION sp_2017_dec),
 PARTITION p_max VALUES LESS THAN (MAXVALUE)
  (SUBPARTITION sp_max)
) TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite Range-Hash Partitioned Tables
INSERT INTO dshrivastav.sales_composite_partition
SELECT 
     LEVEL                              prod_id,
     TRUNC(dbms_random.Value(100,1000)) cust_id,
     SYSDATE-(30*LEVEL)                 time_date
FROM 
     dual
CONNECT BY LEVEL <= 10;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                               
-------------- ------------------ ------------------ -------- ---------------------------------------------------------
P_2017_OCT                      1                  1        4 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2017_DEC                      1                  2        2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_MAX                           1                  3        4 MAXVALUE                                                 
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------- -------------- ----------------- --------------------- ----------
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_2017_DEC     SP_2017_DEC                           1           
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_2017_OCT     SP_2017_OCT                           1           
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_MAX          SP_MAX                                1           
*/

-- To identified the data relevant with partition and subpartition
SELECT 'PARTITION    => p_2017_dec'  partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition PARTITION(p_2017_dec) 
UNION ALL 
SELECT 'SUBPARTITION => sp_2017_dec' partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition SUBPARTITION(sp_2017_dec)
UNION ALL
SELECT 'PARTITION    => p_2017_oct'  partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition PARTITION(p_2017_oct) 
UNION ALL 
SELECT 'SUBPARTITION => sp_2017_oct' partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition SUBPARTITION(sp_2017_oct)
UNION ALL
SELECT 'PARTITION    => p_max'       partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition PARTITION(p_max) 
UNION ALL 
SELECT 'SUBPARTITION => sp_max'      partition_and_sub_name, Count(*) row_count
FROM dshrivastav.sales_composite_partition SUBPARTITION(sp_max);

/*
PARTITION_AND_SUB_NAME      ROW_COUNT
--------------------------- ---------
PARTITION    => p_2017_dec          2
SUBPARTITION => sp_2017_dec         2
PARTITION    => p_2017_oct          4
SUBPARTITION => sp_2017_oct         4
PARTITION    => p_max               4
SUBPARTITION => sp_max              4
*/

Using STORE IN - Example

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_composite_partition PURGE;

-- To Creating a range-hash-partitioned table using STORE IN clause
CREATE TABLE dshrivastav.sales_composite_partition
(
 prod_id       NUMBER(6),
 cust_id       NUMBER,
 time_id       DATE
)
PARTITION BY RANGE (time_id)
SUBPARTITION BY HASH (cust_id) SUBPARTITIONS 2 STORE IN (WAREHOUSE_DATABASE,WAREHOUSE_BIGFILE_DATABASE)
(
 PARTITION p_2017_oct VALUES LESS THAN (TO_DATE('30-OCT-2017','dd-MON-yyyy')),
 PARTITION p_2017_dec VALUES LESS THAN (TO_DATE('30-DEC-2017','dd-MON-yyyy')),
 PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- Insert the data for Composite Range-Hash Partitioned Tables
INSERT INTO dshrivastav.sales_composite_partition
SELECT 
     LEVEL                              prod_id,
     TRUNC(dbms_random.Value(100,1000)) cust_id,
     SYSDATE-(30*LEVEL)                 time_date
FROM 
     dual
CONNECT BY LEVEL <= 10;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                               
-------------- ------------------ ------------------ -------- ---------------------------------------------------------
P_2017_OCT                      2                  1        4 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_2017_DEC                      2                  2        2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_MAX                           2                  3        4 MAXVALUE                                                 
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME            TABLE_NAME                PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
-------------------------- ------------------------- -------------- ----------------- --------------------- ----------
WAREHOUSE_DATABASE         SALES_COMPOSITE_PARTITION P_2017_DEC     SYS_SUBP103549                        1           
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_DEC     SYS_SUBP103550                        2           
WAREHOUSE_DATABASE         SALES_COMPOSITE_PARTITION P_2017_OCT     SYS_SUBP103547                        1           
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_OCT     SYS_SUBP103548                        2           
WAREHOUSE_DATABASE         SALES_COMPOSITE_PARTITION P_MAX          SYS_SUBP103551                        1           
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_MAX          SYS_SUBP103552                        2           
*/

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_composite_partition PURGE;

-- To Creating a range-hash-partitioned table using STORE IN clause
CREATE TABLE dshrivastav.sales_composite_partition
(
 prod_id       NUMBER(6),
 cust_id       NUMBER,
 time_id       DATE
)
PARTITION BY RANGE (time_id)
SUBPARTITION BY HASH (cust_id) SUBPARTITIONS 2 STORE IN (warehouse_database,warehouse_bigfile_database)
(
 PARTITION p_2017_oct VALUES LESS THAN (TO_DATE('30-OCT-2017','dd-MON-yyyy')),
 PARTITION p_2017_dec VALUES LESS THAN (TO_DATE('30-DEC-2017','dd-MON-yyyy')),
 PARTITION p_max VALUES LESS THAN (MAXVALUE) 
 STORE IN (TABLE_BACKUP)  
)
TABLESPACE retail_data;

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION HIGH_VALUE                                               
--------------- -------------- ------------------ ------------------ ---------------------------------------------------------
RETAIL_DATA     P_2017_OCT                      2                  1 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
RETAIL_DATA     P_2017_DEC                      2                  2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
RETAIL_DATA     P_MAX                           2                  3 MAXVALUE                                                 
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME            TABLE_NAME                PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
-------------------------- ------------------------- -------------- ----------------- --------------------- ----------
WAREHOUSE_DATABASE         SALES_COMPOSITE_PARTITION P_2017_DEC     SYS_SUBP103585                        1           
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_DEC     SYS_SUBP103586                        2           
WAREHOUSE_DATABASE         SALES_COMPOSITE_PARTITION P_2017_OCT     SYS_SUBP103583                        1           
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_OCT     SYS_SUBP103584                        2           
TABLE_BACKUP               SALES_COMPOSITE_PARTITION P_MAX          SYS_SUBP103587                        1           
TABLE_BACKUP               SALES_COMPOSITE_PARTITION P_MAX          SYS_SUBP103588                        2           
*/

Creating Composite Range-List Partitioned Tables:

The range partitions of a range-list composite partitioned table are described as for non-composite range partitioned tables.
This allows that optional subclauses of a PARTITION clause can specify physical and other attributes, including tablespace, specific
to a partition segment. If not overridden at the partition level, partitions inherit the attributes of their underlying table.

The list subpartition descriptions, in the SUBPARTITION clauses, are described as for non-composite list partitions, except the only
physical attribute that can be specified is a tablespace (optional). Subpartitions inherit all other physical attributes from the
partition description.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.sales_composite_partition PURGE;

-- To Creating a range-list-partitioned table
CREATE TABLE dshrivastav.sales_composite_partition
(
 deptno     NUMBER,
 item_no    VARCHAR2(30),
 txn_date   DATE,
 txn_amount NUMBER,
 state      VARCHAR2(5)
)
TABLESPACE WAREHOUSE_DATABASE
PARTITION BY RANGE (txn_date)
SUBPARTITION BY LIST (state)
(
 PARTITION p1_2018 VALUES LESS THAN (TO_DATE('31-JAN-2018','DD-MON-YYYY'))
 (SUBPARTITION sp1_2018_a_b VALUES ('A','B'),
  SUBPARTITION sp1_2018_null VALUES (NULL),
  SUBPARTITION sp1_2018_default VALUES (DEFAULT)),
 PARTITION p_max VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION sp1_2018_max_null VALUES (NULL),
  SUBPARTITION sp1_2018_max_default VALUES (DEFAULT))
);

-- Insert the data for Composite Range-List Partitioned Tables
INSERT INTO dshrivastav.sales_composite_partition
SELECT 
     CEIL(dbms_random.Value(100,LEVEL))          deptno,
     Trunc(dbms_random.Value(100,1000))          item_no,
     TO_DATE('25-JAN-2018','DD-MON-YYYY')+LEVEL  txn_date,
     50000                                       txn_amount,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A'                  
        WHEN LEVEL = 2 THEN 'B'                  
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         state
FROM dual
CONNECT BY LEVEL <=10
UNION ALL
SELECT 1 deptno, 1 item_no,TO_DATE('30-JAN-2018','DD-MON-YYYY') txn_date,5000 txn_amount,NULL state FROM dual;
COMMIT;

SELECT * FROM dshrivastav.sales_composite_partition ;
/*
DEPTNO ITEM_NO TXN_DATE            TXN_AMOUNT STATE
------ ------- ------------------- ---------- -----
    87     632 26.01.2018 00:00:00      50000 A    
    59     401 27.01.2018 00:00:00      50000 B    
    90     499 28.01.2018 00:00:00      50000 b    
    40     283 29.01.2018 00:00:00      50000 &    
    63     706 30.01.2018 00:00:00      50000 C    
    63     257 31.01.2018 00:00:00      50000 /    
    56     667 01.02.2018 00:00:00      50000    
    21     382 02.02.2018 00:00:00      50000 6    
    76     790 03.02.2018 00:00:00      50000 A    
    57     896 04.02.2018 00:00:00      50000 "    
     1       1 30.01.2018 00:00:00       5000      
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'SALES_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                               
-------------- ------------------ ------------------ -------- ---------------------------------------------------------
P1_2018                         3                  1        6 TO_DATE(' 2018-01-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
P_MAX                           2                  2        5 MAXVALUE                                                 
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_NAME    SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------- -------------- -------------------- --------------------- ----------
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P1_2018        SP1_2018_A_B                             1 'A', 'B'  
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P1_2018        SP1_2018_NULL                            2 NULL      
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P1_2018        SP1_2018_DEFAULT                         3 DEFAULT   
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_MAX          SP1_2018_MAX_NULL                        1 NULL      
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_MAX          SP1_2018_MAX_DEFAULT                     2 DEFAULT   
*/

SELECT * FROM dshrivastav.sales_composite_partition SUBPARTITION (sp1_2018_null);
/*
DEPTNO ITEM_NO TXN_DATE            TXN_AMOUNT STATE
------ ------- ------------------- ---------- ----- 
     1 1       30.01.2018 00:00:00       5000       
*/

Creating a Composite Hash-Hash Partitioned Table:

The table is created with composite hash-hash partitioning.
For this example, the table has 2 hash partitions for department_id and each of those 2 partitions has 2 subpartitions for course_id.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.dpt_composite_partition PURGE;

-- To Creating a Hash-Hash-partitioned table with name
CREATE TABLE dshrivastav.dpt_composite_partition
(
 department_id   NUMBER(4) NOT NULL,   
 department_name VARCHAR2(30),  
 course_id       NUMBER(4) NOT NULL
)  
PARTITION BY HASH(department_id)  
SUBPARTITION BY HASH (course_id) 
(
 PARTITION p1_dpt
 (SUBPARTITION sp1_dpt_1,
  SUBPARTITION sp1_dpt_2),
 PARTITION p2_dpt
 (SUBPARTITION sp2_dpt_1,
  SUBPARTITION sp2_dpt_2)
) TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite Hash-Hash Partitioned Tables
INSERT INTO dshrivastav.dpt_composite_partition
SELECT 
     CEIL(dbms_random.Value(100,LEVEL)) department_id,
     LEVEL||'LIS'                       department_name,
     Trunc(dbms_random.Value(10,555))   course_id
FROM dual
CONNECT BY LEVEL <=10 ;
COMMIT;

-- Inserted Data Varification --
SELECT * FROM dshrivastav.dpt_composite_partition;
/*
DEPARTMENT_ID DEPARTMENT_NAME COURSE_ID
------------- --------------- ---------
           20 1LIS                  505
           31 2LIS                  289
           85 3LIS                  398
           19 4LIS                  291
           84 5LIS                   34
           34 6LIS                  453
            8 7LIS                  271
           70 8LIS                  199
           66 9LIS                  310
           75 10LIS                 186
*/

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'DPT_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value

FROM 
     all_tab_partitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ------------------------- -------------- ------------------ ------------------ -------- ----------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT                          2                  1        4             
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P2_DPT                          2                  2        6             
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_NAME    SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------- -------------- -------------------- --------------------- ----------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT         SP1_DPT_1                             1           
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT         SP1_DPT_2                             2           
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P2_DPT         SP2_DPT_1                             1           
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P2_DPT         SP2_DPT_2                             2           
*/

Using STORE IN Clause

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.dpt_composite_partition PURGE;

-- To Creating a Hash-Hash-partitioned table without name
CREATE TABLE dshrivastav.dpt_composite_partition
(
 department_id   NUMBER(4) NOT NULL,   
 department_name VARCHAR2(30),  
 course_id       NUMBER(4) NOT NULL
)  
PARTITION BY HASH(department_id)  
SUBPARTITION BY HASH (course_id) SUBPARTITIONS 2 PARTITIONS 2
STORE IN (warehouse_database,warehouse_bigfile_database);

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME            TABLE_NAME              PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION
-------------------------- ----------------------- -------------- ------------------ ------------------
WAREHOUSE_BIGFILE_DATABASE DPT_COMPOSITE_PARTITION SYS_P103641                     2                  1
WAREHOUSE_BIGFILE_DATABASE DPT_COMPOSITE_PARTITION SYS_P103642                     2                  2
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME            TABLE_NAME              PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION
-------------------------- ----------------------- -------------- ----------------- ---------------------
WAREHOUSE_DATABASE         DPT_COMPOSITE_PARTITION SYS_P103641    SYS_SUBP103637                        1
WAREHOUSE_BIGFILE_DATABASE DPT_COMPOSITE_PARTITION SYS_P103641    SYS_SUBP103638                        2
WAREHOUSE_DATABASE         DPT_COMPOSITE_PARTITION SYS_P103642    SYS_SUBP103639                        1
WAREHOUSE_BIGFILE_DATABASE DPT_COMPOSITE_PARTITION SYS_P103642    SYS_SUBP103640                        2
*/

Creating a Composite Hash-Range Partitioned Table:

The table is created with composite hash-range partitioning.
For this example, the table has 1 hash partitions for department_id and has 4 range subpartitions for effactivedate.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.dpt_composite_partition PURGE;

-- To Creating a Hash-Range-partitioned table
CREATE TABLE dshrivastav.dpt_composite_partition
(
 department_id   NUMBER(4) NOT NULL,
 department_name VARCHAR2(30),  
 effactivedate   DATE
)  
PARTITION BY HASH(department_id)  
SUBPARTITION BY RANGE (effactivedate)
(
 PARTITION p1_dpt_2018
 (
  SUBPARTITION sp1_dpt_2018_1 VALUES LESS THAN (TO_DATE('31-JAN-2018','DD-MON-YYYY')),
  SUBPARTITION sp1_dpt_2018_2 VALUES LESS THAN (TO_DATE('28-FEB-2018','DD-MON-YYYY')),
  SUBPARTITION sp1_dpt_2018_3 VALUES LESS THAN (TO_DATE('31-MAR-2018','DD-MON-YYYY')),
  SUBPARTITION sp1_dpt_2018_4 VALUES LESS THAN (MAXVALUE)
 )
) TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite Hash-Range Partitioned Tables
INSERT INTO dshrivastav.dpt_composite_partition
SELECT 
     CEIL(dbms_random.Value(100,LEVEL)) department_id,
     LEVEL||'YCO'                       department_name,
     SYSDATE-(10*LEVEL)   effactivedate
FROM dual
CONNECT BY LEVEL <=10000 ;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'DPT_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME              PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ----------------------- -------------- ------------------ ------------------ -------- ----------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT_2018                     4                  1    10000           
*/

-- To show the object structure(for - sub-partitions)
SELECT
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLE_NAME              PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE                                               
----------------------- -------------- ----------------- --------------------- ---------------------------------------------------------
DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_1                        1 TO_DATE(' 2018-01-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_2                        2 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_3                        3 TO_DATE(' 2018-03-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_4                        4 MAXVALUE                                                 
*/

Creating a Composite Hash-List Partitioned Table:

The table is created with composite hash-list partitioning.
For this example, the table has 1 hash partitions for department_id and has 3 list subpartitions for state.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.dpt_composite_partition PURGE;

-- To Creating a Hash-List-partitioned table
CREATE TABLE dshrivastav.dpt_composite_partition
(
 department_id    NUMBER(4) NOT NULL,   
 department_name  VARCHAR2(30),
 state            VARCHAR2(5)
)  
PARTITION BY HASH(department_id)  
SUBPARTITION BY LIST (state)
(
 PARTITION p1_dpt
 (
  SUBPARTITION sp1         VALUES ('A','B'),
  SUBPARTITION sp1_null    VALUES (NULL),
  SUBPARTITION sp1_default VALUES (DEFAULT)
 )
) TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite Hash-List Partitioned Tables
INSERT INTO dshrivastav.dpt_composite_partition
SELECT 
     CEIL(dbms_random.Value(100,LEVEL)) department_id,
     LEVEL||'YCO'                       department_name,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A'                  
        WHEN LEVEL = 2 THEN 'B'                  
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         state
FROM dual
CONNECT BY LEVEL <=10000 ;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'DPT_COMPOSITE_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME              PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ----------------------- -------------- ------------------ ------------------ -------- ----------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT                          3                  1    10000           
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'DPT_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME              PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
------------------ ----------------------- -------------- ----------------- --------------------- ----------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT         SP1                                   1 'A', 'B'  
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT         SP1_NULL                              2 NULL      
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT         SP1_DEFAULT                           3 DEFAULT   
*/

Creating a Composite List-List Partitioned Table:

The table is created with composite List-List partitioning.
The following example shows an accounts table that is list partitioned by col_1 and subpartitioned using list by col_2.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.performance_composit_partition PURGE;

-- To Creating a List-List-partitioned table
CREATE TABLE dshrivastav.performance_composit_partition
( 
 id      NUMBER,
 col_1   VARCHAR(5),
 col_2   VARCHAR2(5)
)
PARTITION BY LIST (col_1)
SUBPARTITION BY LIST (col_2)
(
 PARTITION p1_performance VALUES ('A','B','C')
 (
   SUBPARTITION sp1_bad     VALUES ('A1'),
   SUBPARTITION sp1_average VALUES ('B2'),
   SUBPARTITION sp1_good    VALUES ('C3')
 ),
 PARTITION p2_null VALUES (NULL)
 (
  SUBPARTITION sp2_null VALUES (NULL)
 ),
 PARTITION p3_all VALUES (DEFAULT)
 (
  SUBPARTITION sp3_all VALUES (DEFAULT)
 )
)TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite List-List Partitioned Tables
INSERT INTO dshrivastav.performance_composit_partition
SELECT 
     LEVEL                                       id,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A'                  
        WHEN LEVEL = 2 THEN 'B'
        WHEN LEVEL = 3 THEN 'C'                  
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         col_1,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A1'                 
        WHEN LEVEL = 2 THEN 'B2'                 
        WHEN LEVEL = 3 THEN 'C3'                 
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         col_2
FROM dual
CONNECT BY LEVEL <=10 ;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'PERFORMANCE_COMPOSIT_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ------------------------------ -------------- ------------------ ------------------ -------- -------------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE                  3                  1        3 'A', 'B', 'C'
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_NULL                         1                  2        0 NULL         
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_ALL                          1                  3        7 DEFAULT      
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------------ -------------- ----------------- --------------------- ----------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE SP1_BAD                               1 'A1'      
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE SP1_AVERAGE                           2 'B2'      
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE SP1_GOOD                              3 'C3'      
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_NULL        SP2_NULL                              1 NULL      
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_ALL         SP3_ALL                               1 DEFAULT   
*/

Creating a Composite List-Range Partitioned Table:

The table is created with composite List-List partitioning.
The following example shows an accounts table that is list partitioned by col_1 and subpartitioned using range by percentage.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.performance_composit_partition PURGE;

-- To Creating a List-Range-partitioned table
CREATE TABLE dshrivastav.performance_composit_partition
( 
 id           NUMBER,
 col_1        VARCHAR(5),
 percentage   VARCHAR2(5)
)
PARTITION BY LIST (col_1)
SUBPARTITION BY RANGE (percentage)
(
 PARTITION p1_performance VALUES ('A','B','C')
 (
  SUBPARTITION sp1_percentage VALUES LESS THAN (80)
 ),
 PARTITION p2_percentage_null VALUES (NULL),
 PARTITION p3_max_percentage  VALUES (DEFAULT)
 (
  SUBPARTITION sp3_max_percentage VALUES LESS THAN (MAXVALUE)
 )
)TABLESPACE WAREHOUSE_DATABASE;

-- Insert the data for Composite List-Range Partitioned Tables
INSERT INTO dshrivastav.performance_composit_partition
SELECT 
     LEVEL                                       id,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A'                  
        WHEN LEVEL = 2 THEN 'B'
        WHEN LEVEL = 3 THEN 'C'                  
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         col_1,
     Trunc(dbms_random.Value(100,LEVEL))         percentage
FROM dual
CONNECT BY LEVEL <=10
UNION ALL
SELECT 11 id,NULL col_1,0 percentage FROM dual;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'PERFORMANCE_COMPOSIT_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME     SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ------------------------------ ------------------ ------------------ ------------------ -------- -------------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE                      1                  1        3 'A', 'B', 'C'
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_PERCENTAGE_NULL                  1                  2        1 NULL         
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_MAX_PERCENTAGE                   1                  3        7 DEFAULT      
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME     SUBPARTITION_NAME  SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------------ ------------------ ------------------ --------------------- ----------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE     SP1_PERCENTAGE                         1 '80'      
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_PERCENTAGE_NULL SYS_SUBP103643                         1 MAXVALUE  
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_MAX_PERCENTAGE  SP3_MAX_PERCENTAGE                     1 MAXVALUE  
*/
-- In PARTITION
SELECT * FROM dshrivastav.performance_composit_partition PARTITION (p2_percentage_null);
/*
ID COL_1  PERCENTAGE
-- ------ ----------
11        0         
*/

-- In SUBPARTITION (Auto Created)
SELECT * FROM dshrivastav.performance_composit_partition SUBPARTITION (SYS_SUBP103643);
/*
ID COL_1  PERCENTAGE
-- ------ ----------
11        0         
*/

Creating a Composite List-Hash Partitioned Table:

The table is created with composite List-Hash partitioning.
The following example shows an accounts table that is list partitioned by col_1 and subpartitioned using hash by percentage.

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.performance_composit_partition PURGE;

-- To Creating a List-Hash-partitioned table
CREATE TABLE dshrivastav.performance_composit_partition
( 
 id           NUMBER,
 col_1        VARCHAR(5),
 percentage   VARCHAR2(5)
)
PARTITION BY LIST (col_1)
SUBPARTITION BY HASH (percentage) SUBPARTITIONS 2
(
 PARTITION p1_performance     VALUES ('A','B','C'),
 PARTITION p2_percentage_null VALUES (NULL),
 PARTITION p3_max_percentage  VALUES (DEFAULT)
)TABLESPACE warehouse_database;

-- Insert the data for Composite List-hash Partitioned Tables
INSERT INTO dshrivastav.performance_composit_partition
SELECT 
     LEVEL                                       id,
     CASE                                        
        WHEN LEVEL = 1 THEN 'A'                  
        WHEN LEVEL = 2 THEN 'B'
        WHEN LEVEL = 3 THEN 'C'                  
     ELSE                                        
        Chr(Trunc(dbms_random.Value(100,LEVEL))) 
     END                                         col_1,
     Trunc(dbms_random.Value(100,LEVEL))         percentage
FROM dual
CONNECT BY LEVEL <=10
UNION ALL
SELECT 11 id,NULL col_1,0 percentage FROM dual;
COMMIT;

-- To gather the object
BEGIN
    dbms_stats.gather_table_stats
    (
     ownname          => 'DSHRIVASTAV',
     tabname          => 'PERFORMANCE_COMPOSIT_PARTITION', 
     estimate_percent => 100,
     cascade          => TRUE,
     degree           => 2, 
     method_opt       =>'FOR ALL COLUMNS SIZE AUTO'
    );
END;
/

-- To show the object structure(for - partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_count,
     partition_position,
     num_rows,
     high_value
FROM 
     all_tab_partitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME     SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
------------------ ------------------------------ ------------------ ------------------ ------------------ -------- -------------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE                      2                  1        3 'A', 'B', 'C'
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_PERCENTAGE_NULL                  2                  2        1 NULL         
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_MAX_PERCENTAGE                   2                  3        7 DEFAULT      
*/

-- To show the object structure(for - sub-partitions)
SELECT
     tablespace_name,
     table_name,
     partition_name,
     subpartition_name,
     subpartition_position,
     high_value
FROM 
     all_tab_subpartitions
WHERE 
    table_name  = 'PERFORMANCE_COMPOSIT_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                     PARTITION_NAME     SUBPARTITION_NAME SUBPARTITION_POSITION HIGH_VALUE
------------------ ------------------------------ ------------------ ----------------- --------------------- ----------
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE     SYS_SUBP103644                        1           
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P1_PERFORMANCE     SYS_SUBP103645                        2           
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_PERCENTAGE_NULL SYS_SUBP103646                        1           
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P2_PERCENTAGE_NULL SYS_SUBP103647                        2           
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_MAX_PERCENTAGE  SYS_SUBP103648                        1           
WAREHOUSE_DATABASE PERFORMANCE_COMPOSIT_PARTITION P3_MAX_PERCENTAGE  SYS_SUBP103649                        2           
*/

-- In PARTITION - for null
SELECT * FROM dshrivastav.performance_composit_partition PARTITION (p2_percentage_null);
/*
ID COL_1  PERCENTAGE
-- ------ ----------
11        0         
*/

-- In SUBPARTITION (Auto Created)
SELECT * FROM dshrivastav.performance_composit_partition SUBPARTITION (sys_subp103647);
/*
ID COL_1  PERCENTAGE
-- ------ ----------
11        0         
*/

-- For data
SELECT 'PARTITION      => p1_performance' partition_name, ID, COL_1, PERCENTAGE
FROM dshrivastav.performance_composit_partition PARTITION (p1_performance)
UNION ALL
SELECT 'SUBPARTITION   => sys_subp103644' partition_name, ID, COL_1, PERCENTAGE
FROM dshrivastav.performance_composit_partition SUBPARTITION (sys_subp103644)
UNION ALL
SELECT 'SUBPARTITION   => sys_subp103645' partition_name, ID, COL_1, PERCENTAGE
FROM dshrivastav.performance_composit_partition SUBPARTITION (sys_subp103645);

/*
PARTITION_NAME                   ID COL_1 PERCENTAGE
-------------------------------- -- ----- ----------
PARTITION      => p1_performance  1 A     27        
PARTITION      => p1_performance  3 C     62        
PARTITION      => p1_performance  2 B     94        
SUBPARTITION   => sys_subp103644  1 A     27        
SUBPARTITION   => sys_subp103644  3 C     62        
SUBPARTITION   => sys_subp103645  2 B     94        
*/

Partition Indexes Organized tables:

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

Partitioning Indexes Organized tables - Example

Local Prefixed/Non-Prefixed indexes

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
TABLESPACE table_backup;

CREATE INDEX local_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
LOCAL
TABLESPACE table_backup;

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
STORE IN (table_backup,warehouse_database, warehouse_bigfile_database);

-- To Create Local Indexes - NON_PREFIXED
CREATE INDEX ix_non_prefix ON dshrivastav.range_hash_partitioning(col_char)
LOCAL
STORE IN (table_backup,warehouse_database, warehouse_bigfile_database);


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

Global Prefixed/Non-Prefixed indexes:

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
TABLESPACE table_backup;

CREATE INDEX global_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL
TABLESPACE table_backup;

-- Insert the data for Range Partitioned Tables
INSERT INTO dshrivastav.range_partitioning
SELECT 
     SYSDATE+(30*LEVEL)                       col_date,
     CEIL(dbms_random.VALUE(1,LEVEL))         col_num,
     CHR(TRUNC(dbms_random.Value(100,LEVEL))) col_char 
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

The following are examples of Global Prefixed/Non-Prefixed indexes using UNIQUE clause:

-- To drop Indexes from database (If the object exists)
DROP INDEX dshrivastav.ix_prefixed;
DROP INDEX dshrivastav.ix_nonprefixed;

-- To Create Unike Global Indexes (PREFIXED/NON_PREFIXED)
CREATE UNIQUE INDEX ix_prefixed ON dshrivastav.range_partitioning (col_date)
GLOBAL 
TABLESPACE table_backup;

CREATE UNIQUE INDEX ix_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL
TABLESPACE table_backup;

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

The following are examples of Global Prefixed/Non-Prefixed indexes using alternative way for STORE IN clause:

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
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','dd-MON-yyyy')) TABLESPACE warehouse_database,
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','dd-MON-yyyy')) TABLESPACE warehouse_bigfile_database,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE)                             TABLESPACE table_backup
) ;
                                                                                             
-- To drop Global Indexes from database (If the object exists)
DROP INDEX dshrivastav.ix_prefixed;
DROP INDEX dshrivastav.ix_nonprefixed;

-- To Create Global Indexes - PREFIXED
CREATE INDEX ix_prefixed ON dshrivastav.range_partitioning (col_date)
GLOBAL PARTITION BY RANGE (col_date)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (TO_DATE('01-APR-2018','dd-MON-yyyy')) TABLESPACE warehouse_database,
 PARTITION sales_p2_2018 VALUES LESS THAN (TO_DATE('01-JUL-2018','dd-MON-yyyy')) TABLESPACE warehouse_bigfile_database,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE)                             TABLESPACE table_backup
);

-- To Create Global Indexes - NON_PREFIXED
CREATE INDEX ix_nonprefixed ON dshrivastav.range_partitioning (col_num,col_char)
GLOBAL PARTITION BY RANGE (col_num)
(
 PARTITION sales_p1_2018 VALUES LESS THAN (100)      TABLESPACE warehouse_database,
 PARTITION sales_p2_2018 VALUES LESS THAN (1000)     TABLESPACE warehouse_bigfile_database,
 PARTITION sales_p4_2018 VALUES LESS THAN (MAXVALUE) TABLESPACE table_backup
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

Maintaining Partitions:

This Big question how to perform partition and subpartition maintenance operations for both tables and indexes.

Now We can proferm contains as:

* Maintenance Operations on Partitions That Can Be Performed
* Adding Partitions
* Coalescing Partitions
* Dropping Partitions
* Exchanging Partitions
* Merging Partitions
* Modifying Default Attributes
* Modifying Real Attributes of Partitions
* Modifying List Partitions: Adding Values
* Modifying List Partitions: Dropping Values
* Modifying a Subpartition Template
* Moving Partitions
* Rebuilding Index Partitions
* Renaming Partitions
* Truncating Partitions
* Splitting Partitions

Maintenance Operations on Partitions That Can Be Performed
* ALTER TABLE Maintenance Operations for Table Partitions
* ALTER TABLE Maintenance Operations for Table Subpartitions
* ALTER INDEX Maintenance Operations for Index Partitions

Adding Partitions
This section describes how to manually add new partitions to a partitioned table and explains why partitions cannot be
specifically added to most partitioned indexes.

* Adding a Partition to a Range-Partitioned Table
* Adding a Partition to a Hash-Partitioned Table
* Adding a Partition to a List-Partitioned Table
* Adding a Partition to an Interval-Partitioned Table
* Adding Partitions to a Composite *-Hash Partitioned Table
** Adding a Partition to a *-Hash Partitioned Table
** Adding a Subpartition to a *-Hash Partitioned Table
* Adding Partitions to a Composite *-List Partitioned Table
** Adding a Partition to a *-List Partitioned Table
** Adding a Subpartition to a *-List Partitioned Table
* Adding Partitions to a Composite *-Range Partitioned Table
** Adding a Partition to a *-Range Partitioned Table
** Adding a Subpartition to a *-Range Partitioned Table
* Adding Index Partitions

* Adding a Partition to a Range-Partitioned Table
ALTER TABLE dshrivastav.sales_partition
ADD PARTITION p_jan_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY'))
TABLESPACE table_backup;

* Adding a Partition to a Hash-Partitioned Table
ALTER TABLE dshrivastav.sales_partition
ADD PARTITION;

ALTER TABLE dshrivastav.sales_partition
ADD PARTITION p_sales 
TABLESPACE table_backup;

* Adding a Partition to a List-Partitioned Table
ALTER TABLE dshrivastav.order_partition 
ADD PARTITION p_order VALUES ('X', 'Z')
STORAGE (INITIAL 20K NEXT 20K) TABLESPACE table_backup
NOLOGGING;

* Adding a Partition to an Interval-Partitioned Table
ALTER TABLE dshrivastav.interval_partition
SET INTERVAL (NUMTOYMINTERVAL(1,'MONTH');
-- ORA-14767: Cannot specify this interval with existing high bounds

-- You must create another daily partition with a high bound of February 1, 2007 to successfully change to a monthly interval:
LOCK TABLE dshrivastav.interval_partition PARTITION FOR(TO_DATE('31-JAN-2007','dd-MON-yyyy') IN SHARE MODE;

ALTER TABLE dshrivastav.interval_partition
SET INTERVAL (NUMTOYMINTERVAL(1,'MONTH');

-- To disable interval partitioning on the transactions table, use:
ALTER TABLE transactions SET INTERVAL ();

* Adding Partitions to a Composite *-Hash Partitioned Table
Partitions can be added at both the partition level and at the hash subpartition level.

** Adding a Partition to a *-Hash Partitioned Table
ALTER TABLE dshrivastav.sales_partition
ADD PARTITION q1_2020 VALUES LESS THAN (2020, 04, 01) COMPRESS
SUBPARTITIONS 8 STORE IN table_backup;

** Adding a Subpartition to a *-Hash Partitioned Table
ALTER TABLE dshrivastav.sales_partition MODIFY PARTITION locations_used
ADD SUBPARTITION p_sales_loc_5
TABLESPACE table_backup;

* Adding Partitions to a Composite *-List Partitioned Table
Partitions can be added at both the partition level and at the list subpartition level.

** Adding a Partition to a *-List Partitioned Table
ALTER TABLE dshrivastav.regional_sales_partition 
ADD PARTITION q1_2000 VALUES LESS THAN (TO_DATE('1-APR-2000','DD-MON-YYYY'))
STORAGE (INITIAL 20K NEXT 20K) TABLESPACE table_backup NOLOGGING
   (
    SUBPARTITION q1_2000_northwest VALUES ('OR', 'WA'),
    SUBPARTITION q1_2000_southwest VALUES ('AZ', 'UT', 'NM'),
    SUBPARTITION q1_2000_northeast VALUES ('NY', 'VM', 'NJ'),
    SUBPARTITION q1_2000_southeast VALUES ('FL', 'GA'),
    SUBPARTITION q1_2000_northcentral VALUES ('SD', 'WI'),
    SUBPARTITION q1_2000_southcentral VALUES ('OK', 'TX')
   );

** Adding a Subpartition to a *-List Partitioned Table
ALTER TABLE dshrivastav.regional_sales_partition
MODIFY PARTITION q1_1999 
ADD SUBPARTITION q1_1999_south VALUES ('AR','MS','AL')
TABLESPACE table_backup;

* Adding Partitions to a Composite *-Range Partitioned Table
Partitions can be added at both the partition level and at the range subpartition level.

** Adding a Partition to a *-Range Partitioned Table
ALTER TABLE dshrivastav.shipments_partition
ADD PARTITION p_2018_jan VALUES LESS THAN (TO_DATE('01-FEB-2007','dd-MON-yyyy')) COMPRESS
(
 SUBPARTITION p_2018_jan_a VALUES LESS THAN (TO_DATE('15-FEB-2007','dd-MON-yyyy')),
 SUBPARTITION p_2018_jan_b VALUES LESS THAN (TO_DATE('01-MAR-2007','dd-MON-yyyy')),
 SUBPARTITION p_2018_jan_c VALUES LESS THAN (TO_DATE('01-APR-2007','dd-MON-yyyy'))
) ;

** Adding a Subpartition to a *-Range Partitioned Table
ALTER TABLE dshrivastav.shipments_partition
MODIFY PARTITION p_2018_jan
ADD SUBPARTITION p_2018_jan_maxval VALUES LESS THAN (MAXVALUE);

* Adding Index Partitions
ALTER INDEX ix_sales_by_region_loc
MODIFY DEFAULT ATTRIBUTES TABLESPACE table_backup;

ALTER INDEX ix_sales_by_region_loc 
REBUILD PARTITION q1_1999 TABLESPACE table_backup;

ALTER INDEX ix_sales_by_region_loc ADD PARTITION table_backup;


Coalescing Partitions:
Coalescing partitions is a way of reducing the number of partitions in a hash-partitioned table or index, or the number of
subpartitions in a *-hash partitioned table. When a hash partition is coalesced, its contents are redistributed into 
one or more remaining partitions determined by the hash function. The specific partition that is coalesced is selected by the database,
and is dropped after its contents have been redistributed. If you coalesce a hash partition or subpartition in the parent table of
a reference-partitioned table definition, then the reference-partitioned table automatically inherits the new partitioning definition.
And Index partitions may be marked as UNUSABLE.

*Coalescing a Partition in a Hash-Partitioned Table
*Coalescing a Subpartition in a *-Hash Partitioned Table
*Coalescing Hash-Partitioned Global Indexes

*Coalescing a Partition in a Hash-Partitioned Table
ALTER TABLE dshrivastav.shipments_partition
COALESCE PARTITION;

*Coalescing a Subpartition in a *-Hash Partitioned Table
ALTER TABLE dshrivastav.sales_partition
MODIFY PARTITION locations_used
COALESCE SUBPARTITION;

*Coalescing Hash-Partitioned Global Indexes

Created in Creating a Hash-Partitioned Global Index:
CREATE INDEX ix_global ON ALTER TABLE dshrivastav.tab_partition (c1,c2,c3)
GLOBAL
PARTITION BY HASH (c1,c2)
(
 PARTITION p1  TABLESPACE table_backup_0,
 PARTITION p2  TABLESPACE table_backup_1,
 PARTITION p3  TABLESPACE table_backup_2,
 PARTITION p4  TABLESPACE table_backup_3
);

ALTER INDEX ix_global COALESCE PARTITION;

Dropping Partitions/Subpartitions
You can drop partitions from range, interval, list, or composite *-range/list partitioned tables. For interval partitioned tables,
you can only drop range or interval partitions that have been materialized. For hash-partitioned tables, or hash subpartitions of 
composite *-hash partitioned tables, you must perform a coalesce operation instead.

You cannot drop a partition from a reference-partitioned table. Instead, a drop operation on a parent table cascades
to all descendant tables.

Method 1:
ALTER TABLE dshrivastav.sales_partition DROP PARTITION dec98;

Method 2:
DELETE FROM dshrivastav.sales_partition partition (dec98);
ALTER TABLE dshrivastav.sales_partition DROP PARTITION dec98;

Method 3:
ALTER TABLE dshrivastav.sales_partition DROP PARTITION dec98
UPDATE INDEXES;

Method 4:
ALTER TABLE dshrivastav.sales_partition DROP PARTITION FOR(TO_DATE('01-SEP-2007','dd-MON-yyyy'));

Method 1:
ALTER TABLE dshrivastav.sales_partition DROP SUBPARTITION dec98;

Method 2:
DELETE FROM dshrivastav.sales_partition SUBPARTITION (dec98);
ALTER TABLE dshrivastav.sales_partition DROP SUBPARTITION dec98;

Method 3:
ALTER TABLE dshrivastav.sales_partition DROP SUBPARTITION dec98
UPDATE INDEXES;

Exchanging Partitions:
You can convert a partition (or subpartition) into a nonpartitioned table, and a nonpartitioned table into a 
partition (or subpartition) of a partitioned table by exchanging their data segments. You can also convert 
a hash-partitioned table into a partition of a composite *-hash partitioned table, or convert the partition of 
a composite *-hash partitioned table into a hash-partitioned table. Similarly, you can convert a [range | list]-partitioned 
table into a partition of a composite *-range/list partitioned table, or convert a partition of the 
composite *-range/list partitioned table into a range/list-partitioned table.

* Exchanging a Range, Hash, or List Partition
* Exchanging a Partition of an Interval Partitioned Table
* Exchanging a Partition of a Reference-Partitioned Table
* Exchanging a Hash-Partitioned Table with a *-Hash Partition
* Exchanging a Subpartition of a *-Hash Partitioned Table
* Exchanging a List-Partitioned Table with a *-List Partition
* Exchanging a Range-Partitioned Table with a *-Range Partition

* Exchanging a Range, Hash, or List Partition
ALTER TABLE dshrivastav.stocks_partition
EXCHANGE PARTITION p3 WITH TABLE stocks_partition_3;

* Exchanging a Partition of an Interval Partitioned Table
LOCK TABLE dshrivastav.interval_sales
PARTITION FOR (TO_DATE('01-JUN-2007','dd-MON-yyyy'))
IN SHARE MODE;

ALTER TABLE dshrivastav.interval_sales
EXCHANGE PARTITION FOR (TO_DATE('01-JUN-2007','dd-MON-yyyy'))
WITH TABLE dshrivastav.interval_sales_jun_2007
INCLUDING INDEXES;

*Exchanging a Partition of a Reference-Partitioned Table
ALTER TABLE dshrivastav.orders
EXCHANGE PARTITION p_2006_dec
WITH TABLE dshrivastav.orders_dec_2006
UPDATE GLOBAL INDEXES;

ALTER TABLE dshrivastav.order_items_dec_2006
ADD CONSTRAINT order_items_dec_2006_fk
FOREIGN KEY (order_id)
REFERENCES orders(order_id) ;

ALTER TABLE dshrivastav.order_items
EXCHANGE PARTITION p_2006_dec
WITH TABLE dshrivastav.order_items_dec_2006;

*Exchanging a Hash-Partitioned Table with a *-Hash Partition
ALTER TABLE dshrivastav.hash_partitioned
EXCHANGE PARTITION p1 WITH TABLE dshrivastav.range_hash_partitioned
WITH VALIDATION;

*Exchanging a Subpartition of a *-Hash Partitioned Table
ALTER TABLE dshrivastav.sales_partitioned 
EXCHANGE SUBPARTITION q3_1999_s1
WITH TABLE dshrivastav.q3_1999_partitioned INCLUDING INDEXES;

*Exchanging a List-Partitioned Table with a *-List Partition
ALTER TABLE dshrivastav.customers_partitioned
EXCHANGE PARTITION apac
WITH TABLE dshrivastav.customers_apac_partitioned
WITH VALIDATION;

*Exchanging a Range-Partitioned Table with a *-Range Partition
LOCK TABLE dshrivastav.orders PARTITION FOR (TO_DATE('01-MAR-2007','dd-MON-yyyy')) 
IN SHARE MODE;

ALTER TABLE dshrivastav.orders_partitioned
EXCHANGE PARTITION
FOR (TO_DATE('01-MAR-2007','dd-MON-yyyy'))
WITH TABLE dshrivastav.orders_mar_2007_partitioned
WITH VALIDATION;

Merging Partitions:
Use the ALTER TABLE ... MERGE PARTITION statement to merge the contents of two partitions into one partition.
The two original partitions are dropped, as are any corresponding local indexes. You cannot use this statement
for a hash-partitioned table or for hash subpartitions of a composite *-hash partitioned table.

You cannot merge partitions for a reference-partitioned table. Instead, a merge operation on a parent table cascades
to all descendant tables. However, you can use the DEPENDENT TABLES clause to set specific properties for dependent 
tables when you issue the merge operation on the master table to merge partitions or subpartitions.

* Merging Range Partitions
* Merging Interval Partitions
* Merging List Partitions
* Merging *-Hash Partitions
* Merging *-List Partitions
** Merging Partitions in a *-List Partitioned Table
** Merging Subpartitions in a *-List Partitioned Table
* Merging *-Range Partitions

*Merging Range Partitions
ALTER TABLE dshrivastav.four_seasons_partitioned
MERGE PARTITIONS quarter_one, quarter_two INTO PARTITION quarter_two
UPDATE INDEXES;

--If you omit the UPDATE INDEXES clause from the preceding statement, then you must rebuild the local 
--index for the affected partition.
ALTER TABLE dshrivastav.four_seasons_partitioned 
MODIFY PARTITION quarter_two REBUILD UNUSABLE LOCAL INDEXES;

*Merging Interval Partitions
ALTER TABLE dshrivastav.transactions_partitioned
MERGE PARTITIONS FOR(TO_DATE('15-JAN-2007','dd-MON-yyyy')) , FOR(TO_DATE('16-JAN-2007','dd-MON-yyyy'));

*Merging List Partitions
ALTER TABLE dshrivastav.sales_by_region_partitioned
MERGE PARTITIONS q1_northcentral, q1_southcentral INTO PARTITION q1_central 
STORAGE(MAXEXTENTS 20);

*Merging *-Hash Partitions
ALTER TABLE dshrivastav.all_seasons_partitioned
MERGE PARTITIONS quarter_1, quarter_2 INTO PARTITION quarter_2
SUBPARTITIONS 8;

*Merging *-List Partitions
Partitions can be merged at the partition level and subpartitions can be merged at the list subpartition level.

**Merging Partitions in a *-List Partitioned Table
ALTER TABLE dshrivastav.stripe_regional_sales
MERGE PARTITIONS q1_1999, q2_1999 INTO PARTITION q1_q2_1999
STORAGE(MAXEXTENTS 20);

**Merging Subpartitions in a *-List Partitioned Table
ALTER TABLE dshrivastav.quarterly_regional_sales
MERGE SUBPARTITIONS q1_1999_northwest, q1_1999_southwest INTO SUBPARTITION q1_1999_west
TABLESPACE table_backup;

*Merging *-Range Partitions
ALTER TABLE dshrivastav.orders_partitioned
MERGE PARTITIONS FOR(TO_DATE('01-MAR-2007','dd-MON-yyyy')), 
FOR(TO_DATE('01-APR-2007','dd-MON-yyyy'))
INTO PARTITION p_pre_may_2007;

Modifying Default Attributes
You can modify the default attributes that are inherited for range, hash, list, interval, or reference partitions
using the MODIFY DEFAULT ATTRIBUTES clause of ALTER TABLE.

ALTER TABLE dshrivastav.emp_partitioned
MODIFY DEFAULT ATTRIBUTES FOR PARTITION p1
TABLESPACE table_backup;

Modifying Real Attributes of Partitions
It is possible to modify attributes of an existing partition of a table or index.

You cannot change the TABLESPACE attribute. Use ALTER TABLE ... MOVE PARTITION/SUBPARTITION 
to move a partition or subpartition to a new tablespace.

* Modifying Real Attributes for a Range or List Partition
* Modifying Real Attributes of a Subpartition

*Modifying Real Attributes for a Range or List Partition
ALTER TABLE dshrivastav.sales_partitioned
MODIFY PARTITION sales_q1
REBUILD UNUSABLE LOCAL INDEXES;

*Modifying Real Attributes of a Subpartition
ALTER TABLE dshrivastav.emp_partitioned
MODIFY SUBPARTITION p3_s1
REBUILD UNUSABLE LOCAL INDEXES;

Modifying List Partitions: Adding Values:
List partitioning enables you to optionally add literal values from the defining value list.

* Adding Values for a List Partition
* Adding Values for a List Subpartition

*Adding Values for a List Partition
ALTER TABLE dshrivastav.sales_by_region_partitioned
MODIFY PARTITION region_south
ADD VALUES ('OK', 'KS');

*Adding Values for a List Subpartition
ALTER TABLE dshrivastav.quarterly_regional_sales
MODIFY SUBPARTITION q1_1999_southeast
ADD VALUES ('KS');

Modifying List Partitions: Dropping Values:
List partitioning enables you to optionally drop literal values from the defining value list.

* Dropping Values from a List Partition
* Dropping Values from a List Subpartition

*Dropping Values from a List Partition
ALTER TABLE dshrivastav.sales_by_region
MODIFY PARTITION region_south
DROP VALUES ('OK', 'KS');

*Dropping Values from a List Subpartition
ALTER TABLE dshrivastav.quarterly_regional_sales
MODIFY SUBPARTITION q1_1999_southeast
DROP VALUES ('KS');

Modifying a Subpartition Template:
You can modify a subpartition template of a composite partitioned table by replacing it with
a new subpartition template. Any subsequent operations that use the subpartition template
(such as ADD PARTITION or MERGE PARTITIONS) now use the new subpartition template. Existing subpartitions
remain unchanged.

ALTER TABLE dshrivastav.emp_sub_template
SET SUBPARTITION TEMPLATE
(
 SUBPARTITION sp_0 TABLESPACE table_backup_0,
 SUBPARTITION sp_1 TABLESPACE table_backup_1,
 SUBPARTITION sp_2 TABLESPACE table_backup_2,
 SUBPARTITION sp_3 TABLESPACE table_backup_3
);

-- You can drop a subpartition template by specifying an empty list:
ALTER TABLE dshrivastav.emp_sub_template
SET SUBPARTITION TEMPLATE ( );

Moving Partitions:
Use the MOVE PARTITION clause of the ALTER TABLE statement to:

* Moving Table Partitions
* Moving Subpartitions

*Moving Table Partitions
ALTER TABLE dshrivastav.parts_partitioned
MOVE PARTITION depot2
TABLESPACE table_backup NOLOGGING COMPRESS;

*Moving Subpartitions
ALTER TABLE dshrivastav.parts_partitioned
MOVE SUBPARTITION sp_types 
TABLESPACE table_backup PARALLEL (DEGREE 2);

Rebuilding Index Partitions:
Some reasons for rebuilding index partitions include:
 * To recover space and improve performance
 * To repair a damaged index partition caused by media failure
 * To rebuild a local index partition after loading the underlying table partition with SQL*Loader or an import utility
 * To rebuild index partitions that have been marked UNUSABLE
 * To enable key compression for indexes

ALTER TABLE dshrivastav.parts_partitioned
MODIFY PARTITION p_types REBUILD UNUSABLE LOCAL INDEXES;

ALTER INDEX dshrivastav.parts_partitioned
REBUILD SUBPARTITION sp_types
TABLESPACE table_backup PARALLEL (DEGREE 2);

Renaming Partitions:
It is possible to rename partitions and subpartitions of both tables and indexes.
One reason for renaming a partition might be to assign a meaningful name, as opposed
to a default system name that was assigned to the partition in another maintenance operation.

ALTER TABLE dshrivastav.parts_partitioned
RENAME PARTITION p_types TO p_types_max;

ALTER TABLE dshrivastav.parts_partitioned
RENAME SUBPARTITION  sp_types TO sp_types_max;

Truncating Partitions:
Use the ALTER TABLE ... TRUNCATE PARTITION/SUBPARTITION statement to remove all rows from a table partition.
Truncating a partition is similar to dropping a partition, except that the partition is emptied of
its data, but not physically dropped.


Method 1:
ALTER TABLE dshrivastav.sales_partitioned TRUNCATE PARTITION p_dec98;
ALTER INDEX ix_sales_area REBUILD;

Method 2:
DELETE FROM dshrivastav.sales_partitioned PARTITION (p_dec98);
ALTER TABLE dshrivastav.sales_partitioned TRUNCATE PARTITION p_dec98;

Method 3:
ALTER TABLE dshrivastav.sales_partitioned TRUNCATE PARTITION p_dec98
UPDATE INDEXES;

Method 4:
ALTER TABLE dshrivastav.sales_partitioned TRUNCATE SUBPARTITION sp_dec98
DROP STORAGE;

Splitting Partitions:
The SPLIT PARTITION clause of the ALTER TABLE or ALTER INDEX statement is used to redistribute the contents
of a partition into two new partitions. Consider doing this when a partition becomes too large and causes
backup, recovery, or maintenance operations to take a long time to complete or it is felt that there is simply
too much data in the partition.

Basic Syntax:
ALTER TABLE <<table_name>>
SPLIT PARTITION <<old_partition_name>> AT (<<new_partition_value>>)
INTO
(
 PARTITION <<new_partition_name>>,
 PARTITION <<old_partition_name>>
);

* Splitting a Partition of a Range-Partitioned Table
* Splitting a Partition of a List-Partitioned Table
* Splitting a Partition of an Interval-Partitioned Table
* Splitting a *-Hash Partition
* Splitting Partitions in a *-List Partitioned Table
** Splitting a *-List Partition
** Splitting a *-List Subpartition
* Splitting Partitions in a *-Range Partition
** Splitting a *-Range Partition
** Splitting a *-Range Subpartition

*Splitting a Partition of a Range-Partitioned Table
ALTER TABLE dshrivastav.sales_partitioned
SPLIT PARTITION p_sales_2017 AT (1000000)
INTO
(
 PARTITION p_sales_2018,
 PARTITION p_sales_2017
);

*Splitting a Partition of a List-Partitioned Table
-- PARTITION region_east VALUES ('A','B','C','D','E','F','G','H','I','J')
ALTER TABLE dshrivastav.sales_by_region
SPLIT PARTITION region_east VALUES ('A','B','C','D','E') 
INTO
(
 PARTITION region_east_1 TABLESPACE table_backup,
 PARTITION region_east_2 STORAGE (INITIAL 8M)
)
PARALLEL 5;

*Splitting a Partition of an Interval-Partitioned Table
ALTER TABLE dshrivastav.transactions_partitioned
SPLIT PARTITION FOR(TO_DATE('01-MAY-2007','DD-MON-YYYY'))
AT (TO_DATE('15-MAY-2007','DD-MON-YYYY'));

*Splitting a *-Hash Partition
ALTER TABLE dshrivastav.all_seasons_partitioned
SPLIT PARTITION quarter_1 
AT (TO_DATE('16-DEC-1997','DD-MON-YYYY'))
INTO
(
 PARTITION q1_1997_1 SUBPARTITIONS 4 STORE IN (table_backup_1,table_backup_2),
 PARTITION q1_1997_2
);

*Splitting Partitions in a *-List Partitioned Table
Partitions can be split at both the partition level and at the list subpartition level.

**Splitting a *-List Partition
ALTER TABLE dshrivastav.quarterly_regional_sales
SPLIT PARTITION q1_1999 AT (TO_DATE('15-FEB-1999','DD-MON-YYYY'))
INTO
(
 PARTITION q1_1999_jan_feb TABLESPACE table_backup_1,
 PARTITION q1_1999_feb_mar STORAGE (INITIAL 8M) TABLESPACE table_backup_2
)
PARALLEL 5;

**Splitting a *-List Subpartition
ALTER TABLE dshrivastav.quarterly_regional_sales
SPLIT SUBPARTITION q2_1999_southwest VALUES ('UT')
INTO
(
 SUBPARTITION q2_1999_utah      TABLESPACE ts2,
 SUBPARTITION q2_1999_southwest TABLESPACE ts3
)
PARALLEL;

*Splitting Partitions in a *-Range Partition
The new partitions inherit the subpartition descriptions from the original partition being split.

**Splitting a *-Range Partition
ALTER TABLE dshrivastav.orders_partitioned
SPLIT PARTITION FOR(TO_DATE('01-MAY-2007','dd-MON-yyyy')) AT (TO_DATE('15-MAY-2007','dd-MON-yyyy'))
INTO
(
 PARTITION p_fh_may07,
 PARTITION p_sh_may2007
);

**Splitting a *-Range Subpartition
ALTER TABLE dshrivastav.orders_partitioned
SPLIT SUBPARTITION p_pre_may_2007_p_large AT (50000)
INTO
(
 SUBPARTITION p_pre_may_2007_med_large   TABLESPACE table_backup_1,
 SUBPARTITION p_pre_may_2007_large_large TABLESPACE table_backup_2
);

DML Operations with Oracle Partition Table:

Oracle is capable of restricting queries to specific partitions using a feature named partition pruning
(sometimes termed partition elimination). What developers might not realise is that it’s possible to write
queries and DML statements that target individual partitions by specifying the partition name directly.

DML Operations with Oracle Partition Table examples:

-- To drop permanently from database (If the object exists)—
DROP TABLE dshrivastav.dml_operation_partition PURGE;

-- Create object based on the range over maxvalue --
CREATE TABLE dshrivastav.dml_operation_partition 
( 
  partition_name   VARCHAR2(100), 
  partition_nuber  NUMBER 
) 
PARTITION BY RANGE (partition_nuber) 
( 
 PARTITION partition_name_1 VALUES LESS THAN (10),
 PARTITION partition_name_2 VALUES LESS THAN (20),
 PARTITION partition_name_maxvalue VALUES LESS THAN (MAXVALUE)
);

-- Data for partition_name_1
INSERT INTO dshrivastav.dml_operation_partition VALUES ('partition_name_1',5);
INSERT INTO dshrivastav.dml_operation_partition VALUES ('partition_name_1',6);

-- Data for partition_name_2
INSERT INTO dshrivastav.dml_operation_partition VALUES ('partition_name_2',15);
INSERT INTO dshrivastav.dml_operation_partition VALUES ('partition_name_2',16);
COMMIT;

-- To fetch all the partitions data from table (dml_operation_partition)
SELECT * FROM dshrivastav.dml_operation_partition;
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      5
partition_name_1                      6
partition_name_2                     15
partition_name_2                     16
*/

-- To fetch the specific partition data (partition_name_1)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      5
partition_name_1                      6
*/

-- DML(Delete) operation with partition(partition_name_1) - Conditional
DELETE FROM dshrivastav.dml_operation_partition PARTITION (partition_name_1)
WHERE partition_nuber = 5;
COMMIT;
SELECT * FROM dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      6
*/

-- DML(Delete) operation with partition(partition_name_1) - Non conditional
DELETE FROM dshrivastav.dml_operation_partition PARTITION (partition_name_1);
COMMIT;
SELECT * FROM dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
*/

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_2                     15
partition_name_2                     16
*/

-- DML(Update) operation with partition(partition_name_2) - Conditional
UPDATE dshrivastav.dml_operation_partition PARTITION (partition_name_2)
SET partition_nuber = 18
WHERE partition_nuber = 15;
COMMIT;

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME   PARTITION_NUBER
---------------- ---------------
partition_name_2              18
partition_name_2              16
*/

-- DML(Update) operation with partition(partition_name_2) - Non conditional
UPDATE dshrivastav.dml_operation_partition PARTITION (partition_name_2)
SET partition_nuber = 18;
COMMIT;

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME   PARTITION_NUBER
---------------- ---------------
partition_name_2              18
partition_name_2              18
*/

-- To fetch the specific partition data (partition_name_maxvalue)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_maxvalue);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
*/

-- Data for partition_name_maxvalue
INSERT INTO dshrivastav.dml_operation_partition PARTITION (partition_name_maxvalue) VALUES ('partition_name_maxvalue',25);
INSERT INTO dshrivastav.dml_operation_partition PARTITION (partition_name_maxvalue) VALUES ('partition_name_maxvalue',26);
COMMIT;

-- To fetch the specific partition data (partition_name_maxvalue)
SELECT * FROM dshrivastav.dml_operation_partition PARTITION (partition_name_maxvalue);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_maxvalue              25
partition_name_maxvalue              26
*/

Converting a Non-Partitioned Table to a Partitioned Table along with data in Oracle:

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

ALTER USER dshrivastav DEFAULT TABLESPACE warehouse_bigfile_database;
ALTER USER dshrivastav TEMPORARY TABLESPACE temp_warehouse_database;


-- To drop the heap table permanently from database (If the object exists)
DROP TABLE dshrivastav.heap_table PURGE;

-- To Creating a heap table
CREATE TABLE dshrivastav.heap_table
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
          EXECUTE IMMEDIATE 'INSERT INTO dshrivastav.heap_table
                             SELECT 
                                  (SELECT Max(user_id) FROM dshrivastav.heap_table) + ROWNUM 
                             FROM dshrivastav.heap_table';
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
    dshrivastav.heap_table; 
/*
DISTINCT_USER_ID   USER_ID
---------------- --------- 
       128000000 128000000 
*/

-- To add an integrity constants (Required to pass the object status by dbms_redefinition.can_redef_table)
ALTER TABLE dshrivastav.heap_table ADD CONSTRAINT heap_table_pk PRIMARY KEY (user_id);
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

-- To identify the status of Index which is added on heap_table because the PK/UK integrity constants is responsible
-- to create same named index as well
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

-- To identify the status of integrity constants and Index which has been added on heap_table structure from partition
-- Data Dictionary view
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
DROP TABLE dshrivastav.heap_table_temp PURGE;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
CREATE TABLE dshrivastav.heap_table_temp
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
DROP TABLE dshrivastav.heap_table_temp PURGE;

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

-- To identify the status of Integrity constants/Index which has been added on heap_table (Must be removed because that
-- one is created for mapping process)
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
           
-- To identify the status of Index which has been added on heap_table structure (Not found because we don’t have create
-- an Index on Partition table)
SELECT COUNT(*) row_count FROM all_ind_partitions WHERE index_name ='HEAP_TABLE_PK' ;
/*
ROW_COUNT
---------
        0
*/

-- DML operation over newly mapped object structure (Non-Partitioned/Heap Table to a Partitioned Table)
INSERT INTO dshrivastav.heap_table
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

-- To fetch the records for the partition table from the data dictionary view 
-- (all_tab_partitions - successfully Conversion of partition table structure)
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
SELECT 'P_1'   partition_name, COUNT(*) row_count FROM dshrivastav.heap_table PARTITION (p_1) UNION ALL
SELECT 'P_2'   partition_name, COUNT(*) row_count FROM dshrivastav.heap_table PARTITION (p_3) UNION ALL
SELECT 'P_3'   partition_name, COUNT(*) row_count FROM dshrivastav.heap_table PARTITION (p_3) UNION ALL
SELECT 'P_4'   partition_name, COUNT(*) row_count FROM dshrivastav.heap_table PARTITION (p_4) UNION ALL
SELECT 'P_MAX' partition_name, COUNT(*) row_count FROM dshrivastav.heap_table PARTITION (p_max); 
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
    l_sql := 'CREATE TABLE dshrivastav.heap_table_temp
              (
               user_id  NUMBER
              )
              PARTITION BY RANGE (user_id)
              (';

    FOR i_data IN (SELECT 1000000 user_id FROM dual UNION
                   SELECT 2000000 user_id FROM dual UNION
                   SELECT 3000000 user_id FROM dual UNION
                   SELECT 4000000 user_id FROM dual UNION
                   SELECT 5000000 user_id FROM dual)
    LOOP
       BEGIN
           l_sql_partitons := CHR(10)||'PARTITION p_'||i_data.user_id||'
                               VALUES LESS THAN ('||i_data.user_id||')  TABLESPACE WAREHOUSE_DATABASE,'||CHR(10)||'';
           l_sql := l_sql||CHR(10)||l_sql_partitons;
       END;
    END LOOP;
    l_sql := l_sql||CHR(10)||'PARTITION p_max   VALUES LESS THAN (MAXVALUE) TABLESPACE WAREHOUSE_DATABASE'||CHR(10)||')';

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

Converting a Partitioned Table to a Non-Partitioned Table in Oracle:

-- To drop the partition table permanently from database (If the object exists)
DROP TABLE dshrivastav.ra_partition PURGE;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
CREATE TABLE dshrivastav.ra_partition
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

INSERT INTO dshrivastav.ra_partition
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
          EXECUTE IMMEDIATE 'INSERT INTO dshrivastav.ra_partition
                             SELECT 
                                  (SELECT Max(user_id) FROM dshrivastav.ra_partition) + ROWNUM 
                             FROM dshrivastav.ra_partition';
          COMMIT;
      END;
   END LOOP;
END;
/
COMMIT;

ALTER TABLE dshrivastav.ra_partition ADD CONSTRAINT pk_ra_partition PRIMARY KEY (user_id);

SELECT Count(DISTINCT user_id) user_id FROM dshrivastav.ra_partition;
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

-- To drop permanently from database (If the object exists)
DROP TABLE dshrivastav.ra_non_partition PURGE;

-- To Creating a heap table
CREATE TABLE dshrivastav.ra_non_partition
(
 user_id NUMBER 
)
TABLESPACE warehouse_bigfile_database;


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

                                                  Thank you                                                                    
                                           Devesh Kumar Shrivastav                                                             
