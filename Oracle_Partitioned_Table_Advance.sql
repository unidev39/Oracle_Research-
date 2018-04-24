-- Using Multicolumn Partitioning Keys
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
DROP TABLE mul_range_partitioning PURGE;
-- To Creating a multicolumn range-partitioned table
CREATE TABLE mul_range_partitioning
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
INSERT INTO mul_range_partitioning VALUES(2000,12,12,1000);
-- 17-MAR-2001
INSERT INTO mul_range_partitioning VALUES(2001,3,17,2000);
-- 1-NOV-2001
INSERT INTO mul_range_partitioning VALUES(2001,11,1,5000);
-- 1-JAN-2002
INSERT INTO mul_range_partitioning VALUES(2002,1,1,4000);
COMMIT;

SELECT * FROM mul_range_partitioning;
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
     ownname          => 'RADM',
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
SELECT * FROM mul_range_partitioning PARTITION(before_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2000    12  12        1000
*/

--The information for 17-MAR-2001 is stored in partition q1_2001. The first partitioning key column,
--year, does not by itself determine the correct partition, so the second partitioning key column, month,
--must be evaluated.
SELECT * FROM mul_range_partitioning PARTITION(q1_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2001     3  17        2000
*/

--Following the same determination rule as for the previous record, the second column, month,
--determines partition q4_2001 as correct partition for 1-NOV-2001:
SELECT * FROM mul_range_partitioning PARTITION(q4_2001);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2001    11   1        5000
*/

--The partition for 01-JAN-2002 is determined by evaluating only the year column, which indicates the future
--partition:
SELECT * FROM mul_range_partitioning PARTITION(future_yyyy);
/*
YEAR MONTH DAY AMOUNT_SOLD
---- ----- --- -----------
2002     1   1        4000
*/

/*
If the database encounters MAXVALUE in one of the partitioning key columns, then all other values of
subsequent columns become irrelevant. That is, a definition of partition future in the preceding example,
having a bound of (MAXVALUE,0) is equivalent to a bound of (MAXVALUE,100) or a bound of (MAXVALUE,MAXVALUE).

The following example illustrates the use of a multicolumn partitioned approach for table supplier_partitioning,
storing the information about which suppliers deliver which parts. To distribute the data in equal-sized
partitions, it is not sufficient to partition the table based on the supplier_id, because some suppliers
might provide hundreds of thousands of parts, while others provide only a few specialty parts. Instead,
you partition the table on (supplier_id, partnum) to manually enforce equal-sized partitions.
*/

-- To drop permanently from database (If the object exists)
DROP TABLE supplier_partitioning PURGE;
-- To Creating a multicolumn range-partitioned table with max values
CREATE TABLE supplier_partitioning
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

INSERT INTO supplier_partitioning VALUES (5,5, 1000);
INSERT INTO supplier_partitioning VALUES (5,150, 1000);
INSERT INTO supplier_partitioning VALUES (10,100, 1000);
COMMIT;

SELECT * FROM supplier_partitioning PARTITION (p1);
/*
SUPPLIER_ID PARTNUM PRICE
----------- ------- -----
          5       5  1000
          5     150  1000
*/
SELECT * FROM supplier_partitioning PARTITION (p2);
/*
SUPPLIER_ID PARTNUM PRICE
----------- ------- -----
         10     100  1000
*/

Creating a range-partitioned table with ENABLE ROW MOVEMENT

In the following example, more complexity is added to the example presented earlier for a range-partitioned table.
Storage parameters and a LOGGING attribute are specified at the table level. These replace the corresponding defaults
inherited from the table space level for the table itself, and are inherited by the range partitions.
However, because there was little business in the first quarter, the storage attributes for partition sales_q1_2006 
are made smaller. The ENABLE ROW MOVEMENT clause is specified to allow the automatic migration of a row to a new 
storage for that partition if an update to a key value is made that would place the with new row in a storage.

-- To drop permanently from database (If the object exists)
DROP TABLE sales_enable_row_movement PURGE;

-- To Create a range-partitioned table with enable row movement
CREATE TABLE sales_enable_row_movement
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
     initial_extent,
     next_extent,
     min_extent,
     max_extent,
     max_size
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';

/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT NEXT_EXTENT MIN_EXTENT MAX_EXTENT MAX_SIZE
------------------------- -------------- ------------------------------------ ------------------ -------- -------------- ----------- ---------- ---------- --------
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                  1                   24576       16384                               
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                  2                  106496       57344                               
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                  3                  106496       57344                               
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                  4                  106496       57344                               
*/

-- To insert the data for partition (SALES_P1_2018)
INSERT INTO sales_enable_row_movement
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
     initial_extent,
     next_extent,
     min_extent,
     max_extent,
     max_size
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';
/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT NEXT_EXTENT MIN_EXTENT MAX_EXTENT MAX_SIZE
------------------------- -------------- ------------------------------------ ------------------ -------- -------------- ----------- ---------- ---------- ----------
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                 1   200000          24576       16384          1 2147483645 2147483645                             
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                 2                  106496       57344                               
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                 3                  106496       57344                               
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                 4                  106496       57344                               
*/


-- To insert the data for partition (SALES_P2_2018)
INSERT INTO sales_enable_row_movement
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
     initial_extent,
     next_extent,
     min_extent,
     max_extent,
     max_size
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_ENABLE_ROW_MOVEMENT';

/*
TABLE_NAME                PARTITION_NAME HIGH_VALUE                           PARTITION_POSITION NUM_ROWS INITIAL_EXTENT NEXT_EXTENT MIN_EXTENT MAX_EXTENT MAX_SIZE
------------------------- -------------- ------------------------------------ ------------------ -------- -------------- ----------- ---------- ---------- ----------
SALES_ENABLE_ROW_MOVEMENT SALES_P1_2018  TO_DATE(' 2018-01-01', 'SYYYY-MM-DD')                 1   200000          24576       16384          1 2147483645 2147483645
SALES_ENABLE_ROW_MOVEMENT SALES_P2_2018  TO_DATE(' 2018-02-01', 'SYYYY-MM-DD')                 2   200000         106496       57344          1 2147483645 2147483645
SALES_ENABLE_ROW_MOVEMENT SALES_P3_2018  TO_DATE(' 2018-03-01', 'SYYYY-MM-DD')                 3                  106496       57344                               
SALES_ENABLE_ROW_MOVEMENT SALES_P4_2018  TO_DATE(' 2018-04-01', 'SYYYY-MM-DD')                 4                  106496       57344                               
*/

Creating range-partitioned (Interval-Partitioned) Tables.

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
DROP TABLE interval_sales_partition PURGE;

-- To Create a range-partitioned table with (Interval-Partitioned)
CREATE TABLE interval_sales_partition
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
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
------------------------ -------------- ----------------------------------------------------------------------------------- ------------------ ---------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1         
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2         
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  3         
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  4         
*/

-- To insert the data into object
INSERT INTO interval_sales_partition VALUES (1,1,TO_DATE('1-1-2009', 'DD-MM-YYYY'),'A',1,1,1);
COMMIT;

-- To show the object data
SELECT * FROM interval_sales_partition PARTITION(p2);
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
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
------------------------ -------------- ----------------------------------------------------------------------------------- ------------------ ---------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1        0
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2        0
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  3        1
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  4        0
*/

-- To insert the data into object
INSERT INTO interval_sales_partition VALUES (1,1,TO_DATE('30-12-2030', 'DD-MM-YYYY'),'A',1,1,1);
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
TABLE_NAME               PARTITION_NAME HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
------------------------ -------------- ----------------------------------------------------------------------------------- ------------------ ---------
INTERVAL_SALES_PARTITION P0             TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1        0
INTERVAL_SALES_PARTITION P1             TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2        0
INTERVAL_SALES_PARTITION P2             TO_DATE(' 2009-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  3        1
INTERVAL_SALES_PARTITION P3             TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  4        0
INTERVAL_SALES_PARTITION SYS_P97763     TO_DATE(' 2031-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  5        1
*/

-- To show the object data
SELECT * FROM interval_sales_partition PARTITION(SYS_P97763);
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD
------- ------- ------------------- ---------- -------- ------------- -----------
      1       1 30.12.2030 00:00:00 A                 1             1           1
*/

Using Virtual Column-Based Range-Partitioning

With partitioning, a virtual column can be used as any regular column. All partition methods are supported when using virtual columns.
A virtual column used as the partitioning column cannot use calls to a PL/SQL function.
The following example shows the sales_partitioning table partitioned by range-range using 
a virtual  column with enable row movements and in no loging mode.

-- To drop permanently from database (If the object exists)
DROP TABLE sales_partitioning PURGE;

-- To Creating a Virtual column for the range-partitioned table with max values
CREATE TABLE sales_partitioning
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
TABLE_OWNER TABLE_NAME         PARTITION_NAME    HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1         
DSHRIVASTAV SALES_PARTITIONING SALES_AFTER_2018  MAXVALUE                                                                                             2         
*/

-- Insert the data for virtual columns
INSERT INTO sales_partitioning 
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
INSERT INTO sales_partitioning 
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

SELECT * FROM sales_partitioning;
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
TABLE_OWNER TABLE_NAME         PARTITION_NAME    HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1        0
DSHRIVASTAV SALES_PARTITIONING SALES_AFTER_2018  MAXVALUE                                                                                             2        1
*/
-------------------------------------

Using Virtual Column-Based Range-Range-Sub-Partitioning

With partitioning, a virtual column can be used as any regular column. All partition methods are supported when using virtual columns,
including interval partitioning and all different combinations of composite partitioning. A virtual column used as the partitioning column
cannot use calls to a PL/SQL function.
The following example shows the sales_partitioning table partitioned by range-range using a virtual column for the subpartitioning key.
The virtual column calculates the total value of a sale by multiplying amount_sold and quantity_sold.

-- To drop permanently from database (If the object exists)
DROP TABLE sales_partitioning PURGE;

-- To Creating a Virtual column for the range-range-subpartitioning-partitioned table with max values
CREATE TABLE sales_partitioning
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
 SUBPARTITION p_small   VALUES LESS THAN (1000)     TABLESPACE TABLE_BACKUP,
 SUBPARTITION p_medium  VALUES LESS THAN (5000)     TABLESPACE TABLE_BACKUP,
 SUBPARTITION p_large   VALUES LESS THAN (10000)    TABLESPACE TABLE_BACKUP,
 SUBPARTITION p_extreme VALUES LESS THAN (MAXVALUE) TABLESPACE TABLE_BACKUP
)
(PARTITION sales_before_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY')) TABLESPACE TABLE_BACKUP
)
ENABLE ROW MOVEMENT
PARALLEL NOLOGGING;

-- To show the object structure(partitions)
SELECT
     table_owner,
     table_name,
     partition_name,
     subpartition_count,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_OWNER TABLE_NAME         PARTITION_NAME    SUBPARTITION_COUNT HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- ------------------ ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018                  4 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1         
*/

-- To show the object structure(sub-partitions)
SELECT 
     table_owner,
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
TABLE_OWNER TABLE_NAME         PARTITION_NAME    SUBPARTITION_NAME           HIGH_VALUE HIGH_VALUE_LENGTH SUBPARTITION_POSITION TABLESPACE_NAME
----------- ------------------ ----------------- --------------------------- ---------- ----------------- --------------------- ---------------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_SMALL   1000                       4                     1 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_MEDIUM  5000                       4                     2 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_LARGE   10000                      5                     3 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_EXTREME MAXVALUE                   8                     4 TABLE_BACKUP   
*/

-- Insert the data for virtual columns
INSERT INTO sales_partitioning 
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
INSERT INTO sales_partitioning 
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

SELECT * FROM sales_partitioning;
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
     table_owner,
     table_name,
     partition_name,
     subpartition_count,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name = 'SALES_PARTITIONING';

/*
TABLE_OWNER TABLE_NAME         PARTITION_NAME    SUBPARTITION_COUNT HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ------------------ ----------------- ------------------ ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018                  4 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1        0
DSHRIVASTAV SALES_PARTITIONING SYS_P97805                         4 TO_DATE(' 2018-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2        1
*/

-- To show the object structure(sub-partitions)
SELECT 
     table_owner,
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
TABLE_OWNER TABLE_NAME         PARTITION_NAME    SUBPARTITION_NAME           HIGH_VALUE HIGH_VALUE_LENGTH SUBPARTITION_POSITION TABLESPACE_NAME
----------- ------------------ ----------------- --------------------------- ---------- ----------------- --------------------- ---------------
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_SMALL   1000                       4                     1 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_MEDIUM  5000                       4                     2 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_LARGE   10000                      5                     3 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_EXTREME MAXVALUE                   8                     4 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SYS_P97805        SYS_SUBP97801               1000                       4                     1 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SYS_P97805        SYS_SUBP97802               5000                       4                     2 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SYS_P97805        SYS_SUBP97803               10000                      5                     3 TABLE_BACKUP   
DSHRIVASTAV SALES_PARTITIONING SYS_P97805        SYS_SUBP97804               MAXVALUE                   8                     4 TABLE_BACKUP   
*/

Creating reference-partitioned tables

To create a reference-partitioned table, you specify a PARTITION BY REFERENCE clause in the CREATE TABLE statement.
This clause specifies the name of a referential constraint and this constraint becomes the partitioning referential
constraint that is used as the basis for reference partitioning in the table.
The referential constraint must be enabled and enforced.

As with other partitioned tables, you can specify object-level default attributes, and you can optionally specify
partition descriptors that override the object-level defaults on a per-partition basis.

The following example creates a parent table parent_orders_partitioned which is range-partitioned on order_date. The reference-partitioned
child table child_order_items_partitioned is created with four partitions, Q1_2018, Q2_2018, Q3_2018, and Q4_2018, where each PARTITION
contains the child_order_items_partitioned rows corresponding to parent_orders_partitioned in the respective parent partition.

Creating reference-partitioned tables - Example


-- To drop permanently from database (If the object exists)
DROP TABLE parent_orders_partitioned PURGE;

-- To Creating a range reference-partitioning, Parent-table
CREATE TABLE parent_orders_partitioned
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
DROP TABLE parent_orders_partitioned PURGE;

-- To Creating a range reference-partitioning, Child-table
CREATE TABLE child_order_items_partitioned
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
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name IN ('PARENT_ORDERS_PARTITIONED','CHILD_ORDER_ITEMS_PARTITIONED');
/*
TABLE_OWNER TABLE_NAME                    PARTITION_NAME HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ----------------------------- -------------- ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q1_2018                                                                                                             1         
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q2_2018                                                                                                             2         
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q3_2018                                                                                                             3         
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q4_2018                                                                                                             4         
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q1_2018        TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1         
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q2_2018        TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2         
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q3_2018        TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  3         
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q4_2018        TO_DATE(' 2018-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  4         
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

INSERT INTO parent_orders_partitioned
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

INSERT INTO child_order_items_partitioned
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
     table_owner,
     table_name,
     partition_name,
     high_value,
     partition_position,
     num_rows
FROM 
     all_tab_partitions
WHERE table_name IN ('PARENT_ORDERS_PARTITIONED','CHILD_ORDER_ITEMS_PARTITIONED');
/*
TABLE_OWNER TABLE_NAME                    PARTITION_NAME HIGH_VALUE                                                                          PARTITION_POSITION NUM_ROWS
----------- ----------------------------- -------------- ----------------------------------------------------------------------------------- ------------------ --------
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q1_2018                                                                                                             1        0
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q2_2018                                                                                                             2        1
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q3_2018                                                                                                             3        0
DSHRIVASTAV CHILD_ORDER_ITEMS_PARTITIONED Q4_2018                                                                                                             4        0
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q1_2018        TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  1        0
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q2_2018        TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  2        1
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q3_2018        TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  3        0
DSHRIVASTAV PARENT_ORDERS_PARTITIONED     Q4_2018        TO_DATE(' 2018-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')                  4        0
*/
