-- First, Create a partitioned table, partitioned on a release_date column
CREATE TABLE big_album_sales
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
INSERT INTO big_album_sales
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
CREATE INDEX big_album_sales_i ON big_album_sales(release_date)
LOCAL;

-- GatherStats
BEGIN
    dbms_stats.gather_table_stats(ownname=> 'RADM', tabname=> 'BIG_ALBUM_SALES', estimate_percent=> 10, method_opt=> 'FOR ALL COLUMNS SIZE 1');
END;
/

-- Second, Create another equivalent table, this time non-partitioned
CREATE TABLE big_album_sales2
(
 id           NUMBER,
 album_id     NUMBER,
 country_id   NUMBER,
 release_date DATE,
 total_sales  NUMBER
);

INSERT INTO big_album_sales2
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
ON big_album_sales2(release_date);

BEGIN
    dbms_stats.gather_table_stats(ownname=> 'RADM', tabname=> 'BIG_ALBUM_SALES2', estimate_percent=> 10, method_opt=> 'FOR ALL COLUMNS SIZE 1');
END;
/

-- Step 1 (non-partitioned table) 
-- Selecting 1 of the 8 years worth of data in the non-partitioned table will result in a full table scan
-- as it's the most efficient method in selecting such a relatively high percentage of rows
EXPLAIN PLAN FOR
SELECT * 
FROM big_album_sales2
WHERE release_date BETWEEN '01-JAN-2003' and '31-DEC-2003';
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
==> Forcing the use of an index clearly shows is a more expensive option both in elapsed times and the increased consistent gets
*/

-- Using Oracle Hint (Index) 
EXPLAIN PLAN FOR
SELECT /*+ INDEX (t) */ * FROM big_album_sales2 t
WHERE release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';
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
SELECT * 
FROM big_album_sales
WHERE release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';
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

/*
==> Consistent gets have now dropped significantly from 8664 to just 1366 ...
*/

/*
Note: The consistent gets Oracle metric is the number of times a consistent read (a logical RAM buffer I/O)
      was requested to get data from a data block. Part of Oracle tuning is to increase logical I/O by
      reducing the expensive disk I/O (physical reads), but high consistent gets presents it's own tuning
      challenges, especially when we see super high CPU consumption (i.e. the "top 5 timed events" in an AWR report).
*/