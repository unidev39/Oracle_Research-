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

Hash Partitioning Tables

Hash partitioning is useful when there is no obvious range key, or range partitioning will cause uneven distribution of data. 
The number of partitions must be a power of 2 (2, 4, 8, 16...) and can be specified by the PARTITIONS...STORE IN clause.
The nature of hash partitioning depend on The values returned by a hash function are called hash values, hash codes, digests, or simply hashes.

-- To drop permanently from database (If the object exists)
DROP TABLE hash_partitioning_no_name PURGE;

-- To Creating a Hash Partitioning table without partitions name
CREATE TABLE hash_partitioning_no_name
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
INSERT INTO HASH_PARTITIONING_NO_NAME VALUES (1,SYSDATE,'A');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM HASH_PARTITIONING_NO_NAME;
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

SELECT * FROM HASH_PARTITIONING_NO_NAME PARTITION(sys_p97832);
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/
-----

-- To drop permanently from database (If the object exists)
DROP TABLE hash_partitioning_with_name PURGE;

-- To Creating a Hash Partitioning table with partitions name/tablespace name
CREATE TABLE hash_partitioning_with_name
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
INSERT INTO hash_partitioning_with_name VALUES (1,SYSDATE,'A');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM hash_partitioning_with_name;
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

SELECT * FROM hash_partitioning_with_name PARTITION(p2);
/*
HASH_NO HASH_DATE           COMMENTS
------- ------------------- --------
      1 24.04.2018 09:38:30 A       
*/


-- To drop permanently from database (If the object exists)
DROP TABLE hash_partitioning_compress PURGE;

-- To Creating a Hash Partitioning table with compressed
CREATE TABLE hash_partitioning_compress
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
DROP TABLE hash_partitioning_enablerowmv PURGE;

-- To Creating a Hash Partitioning table with enable row movment/logging/parallel
CREATE TABLE hash_partitioning_enablerowmv
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

List-Partitioned Tables - Example

The semantics for creating list partitions are very similar to those for creating range partitions. 
However, to create list partitions, you specify a PARTITION BY LIST clause in the 
CREATE TABLE statement, and the PARTITION clauses specify lists of literal values, 
which are the discrete values of the partitioning columns that qualify rows to be included in the partition. 
For list partitioning, the partitioning key can only be a single column name from the table.

Available only with list partitioning, you can use the keyword DEFAULT to describe the value list for a partition. 
This identifies a partition that accommodates rows that do not map into any of the other partitions.

List-Partitioned Tables - Example


-- To drop permanently from database (If the object exists)
DROP TABLE list_partitioned PURGE;

-- To Creating a List Partitioning table
CREATE TABLE list_partitioned
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
TABLESPACE TABLE_BACKUP;

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
INSERT INTO list_partitioned VALUES (2,'dpt_2','B');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM list_partitioned PARTITION(list_p2);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     2 dpt_2    B        
*/

-- Insert the data
INSERT INTO list_partitioned VALUES (3,'dpt_3','E');
-- ORA-14400: inserted partition key does not map to any partition

Creating a List-Partitioned Table With a Default Partition

Unlike range partitioning, with list partitioning, there is no apparent sense of order between partitions.
You can also specify a default partition into which rows that do not map to any other partition are mapped.
If a default partition were specified in the preceding example, the state CA would map to that partition.

-- To drop permanently from database (If the object exists)
DROP TABLE list_partitioned_default PURGE;

-- To Creating a List Partitioning table
CREATE TABLE list_partitioned_default
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
TABLESPACE TABLE_BACKUP;

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
INSERT INTO list_partitioned_default VALUES (3,'dpt_3','E');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM list_partitioned_default PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     3 dpt_3    E        
*/

-- Insert the data => i.e Wrong approach 
INSERT INTO list_partitioned_default VALUES (4,'dpt_4',NULL);
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM list_partitioned_default PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
     3 dpt_3    E        
     4 dpt_4             
*/

Creating a List-Partitioned Table With a DEFAULT/NULL Partition 

-- To drop permanently from database (If the object exists)
DROP TABLE list_partitioned_default_null PURGE;

-- To Creating a List Partitioning table
CREATE TABLE list_partitioned_default_null
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
TABLESPACE TABLE_BACKUP;

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
INSERT INTO list_partitioned_default_null VALUES (4,'dpt_',NULL);
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM list_partitioned_default_null PARTITION(list_p_nulls);
/*
DEPTNO DEPTNAME ALPHABETS
------ -------- ---------
     3 dpt_            
*/

-- Insert the data
INSERT INTO list_partitioned_default_null VALUES (4,'dpt_4','E');
-- Insert - 1 row(s), executed in 148 ms 
COMMIT;

SELECT * FROM list_partitioned_default_null PARTITION(list_p_others);
/*
DEPTNO DEPTNAME ALPHABETS
     4 dpt_4    E                   
*/

-- To drop permanently from database (If the object exists)
DROP TABLE list_partitioned PURGE;

-- To Creating a List Partitioning table
CREATE TABLE list_partitioned
(
 deptno          NUMBER, 
 deptname        VARCHAR2(20),
 alphabets       VARCHAR2(20)
)
STORAGE(INITIAL 100K NEXT 10K) TABLESPACE TABLE_BACKUP
PARTITION BY LIST (alphabets)
(
 PARTITION list_p1        VALUES ('A')      COMPRESS,
 PARTITION list_p2        VALUES ('B','C')  STORAGE(INITIAL 1K NEXT 20K) TABLESPACE SHRIVASTAV,
 PARTITION list_p_nulls   VALUES (NULL),
 PARTITION list_p_others  VALUES (DEFAULT)
)
ENABLE ROW MOVEMENT
PARALLEL LOGGING;

SELECT
     table_owner,
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
TABLE_OWNER TABLE_NAME       PARTITION_NAME HIGH_VALUE PARTITION_POSITION TABLESPACE_NAME INITIAL_EXTENT NEXT_EXTENT LOGGING COMPRESSION
----------- ---------------- -------------- ---------- ------------------ --------------- -------------- ----------- ------- -----------
DSHRIVASTAV LIST_PARTITIONED LIST_P1        'A'                         1 TABLE_BACKUP            106496       16384 YES     ENABLED    
DSHRIVASTAV LIST_PARTITIONED LIST_P2        'B', 'C'                    2 SHRIVASTAV               16384       24576 YES     DISABLED   
DSHRIVASTAV LIST_PARTITIONED LIST_P_NULLS   NULL                        3 TABLE_BACKUP            106496       16384 YES     DISABLED   
DSHRIVASTAV LIST_PARTITIONED LIST_P_OTHERS  DEFAULT                     4 TABLE_BACKUP            106496       16384 YES     DISABLED   
*/

Creating Composite Range-Range Partitioned Tables

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
DROP TABLE shipment_composite_partition PURGE;

-- To Creating a Composite Range-Range Partitioned Tables table with subpartition name
CREATE TABLE shipment_composite_partition
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
) TABLESPACE TABLE_BACKUP;

-- Insert the data for Composite Range-Range Partitioned Tables
INSERT INTO shipment_composite_partition
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
     table_name,
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
TABLE_NAME                   PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE
---------------------------- -------------- ------------------ ------------------ --------------------------------------------------------------------------------------------                                                                         
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN                      3                  1        7 TO_DATE(' 2018-01-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB                      3                  2        1 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX                      3                  3        2 MAXVALUE                                                                           
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
---------------------------- -------------- ----------------- --------------------- -----------------------------------------------------------------------------------                                                                         
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB     SP_FEB_1                              1 TO_DATE(' 2018-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB     SP_FEB_2                              2 TO_DATE(' 2018-02-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB     SP_FEB_MAX                            3 MAXVALUE                                                                           
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN     SP_JAN_1                              1 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN     SP_JAN_2                              2 TO_DATE(' 2018-01-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN     SP_JAN_MAX                            3 MAXVALUE                                                                           
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX     SP_MAR_1                              1 TO_DATE(' 2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX     SP_MAR_2                              2 TO_DATE(' 2018-03-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_MAX     SP_MAX                                3 MAXVALUE                                                                           
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
DROP TABLE shipment_composite_partition PURGE;

-- To Creating a Composite Range-Range Partitioned Tables table withiout subpartition name (Wrong practice)
CREATE TABLE shipment_composite_partition
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
---------------------------- -------------- ------------------ ------------------ -----------------------------------------------------------------------------------                                                                         
SHIPMENT_COMPOSITE_PARTITION P_2018_JAN                      1                  1 TO_DATE(' 2018-01-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
SHIPMENT_COMPOSITE_PARTITION P_2018_FEB                      1                  2 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
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

-- To drop permanently from database (If the object exists)
DROP TABLE sales_partitioning PURGE;

-- To Creating a Virtual column for the range-range-partitioned table with max values
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
    table_name  = 'SALES_PARTITIONING'
AND table_owner = 'DSHRIVASTAV';
/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_COUNT PARTITION_POSITION HIGH_VALUE                                                                         
------------------ ----------------- ------------------ ------------------ -----------------------------------------------------------------------------------
SALES_PARTITIONING SALES_BEFORE_2018                  4                  1 TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
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
    table_name  = 'SALES_PARTITIONING'
AND table_owner = 'DSHRIVASTAV';
/*
TABLE_NAME         PARTITION_NAME    SUBPARTITION_NAME           SUBPARTITION_POSITION HIGH_VALUE
------------------ ----------------- --------------------------- --------------------- ----------
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_SMALL                       1 1000      
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_MEDIUM                      2 5000      
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_LARGE                       3 10000     
SALES_PARTITIONING SALES_BEFORE_2018 SALES_BEFORE_2018_P_EXTREME                     4 MAXVALUE  
*/

Creating Composite Range-Hash Partitioned Tables

The partitions of a range-hash partitioned table are logical structures only, as their data is stored in the segments of
their subpartitions. As with partitions, these subpartitions share the same logical attributes. Unlike range partitions 
in a range-partitioned table, the subpartitions cannot have different physical attributes from the owning partition, 
although they are not required to reside in the same tablespace.

-- To drop permanently from database (If the object exists)
DROP TABLE sales_composite_partition PURGE;

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
     Trunc(dbms_random.Value(100,1000)) cust_id,
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
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                                                         
------------------ ------------------------- -------------- ------------------ ------------------ -------- -----------------------------------------------------------------------------------
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_2017_OCT                      1                  1        4 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_2017_DEC                      1                  2        2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_MAX                           1                  3        4 MAXVALUE                                                                           
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

-- To drop permanently from database (If the object exists)
DROP TABLE sales_composite_partition PURGE;

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
     Trunc(dbms_random.Value(100,1000)) cust_id,
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
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';
/*
TABLESPACE_NAME            TABLE_NAME                PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                                                         
-------------------------- ------------------------- -------------- ------------------ ------------------ -------- -----------------------------------------------------------------------------------
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_OCT                      2                  1        4 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_2017_DEC                      2                  2        2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_BIGFILE_DATABASE SALES_COMPOSITE_PARTITION P_MAX                           2                  3        4 MAXVALUE                                                                           
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
DROP TABLE sales_composite_partition PURGE;

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
 STORE IN (TABLE_BACKUP)  
)
TABLESPACE RETAIL_DATA;

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
TABLESPACE_NAME TABLE_NAME                PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION HIGH_VALUE                                                                         
--------------- ------------------------- -------------- ------------------ ------------------ -----------------------------------------------------------------------------------
RETAIL_DATA     SALES_COMPOSITE_PARTITION P_2017_OCT                      2                  1 TO_DATE(' 2017-10-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
RETAIL_DATA     SALES_COMPOSITE_PARTITION P_2017_DEC                      2                  2 TO_DATE(' 2017-12-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
RETAIL_DATA     SALES_COMPOSITE_PARTITION P_MAX                           2                  3 MAXVALUE                                                                           
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

Creating Composite Range-List Partitioned Tables

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
    table_name  = 'SALES_COMPOSITE_PARTITION'
AND table_owner = 'DSHRIVASTAV';

/*
TABLESPACE_NAME    TABLE_NAME                PARTITION_NAME SUBPARTITION_COUNT PARTITION_POSITION NUM_ROWS HIGH_VALUE                                                                         
------------------ ------------------------- -------------- ------------------ ------------------ -------- -----------------------------------------------------------------------------------
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P1_2018                         3                  1        6 TO_DATE(' 2018-01-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE SALES_COMPOSITE_PARTITION P_MAX                           2                  2        5 MAXVALUE                                                                           
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

Creating a Composite Hash-Hash Partitioned Table

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
------------------ ------------------------- -------------- ------------------ ------------------ -------- -----------------------------------------------------------------------------------
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
STORE IN (WAREHOUSE_DATABASE,WAREHOUSE_BIGFILE_DATABASE);

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

Creating a Composite Hash-Range Partitioned Table

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
------------------ ----------------------- -------------- ----------------- --------------------- -----------------------------------------------------------------------------------
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_1                        1 TO_DATE(' 2018-01-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_2                        2 TO_DATE(' 2018-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_3                        3 TO_DATE(' 2018-03-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
WAREHOUSE_DATABASE DPT_COMPOSITE_PARTITION P1_DPT_2018    SP1_DPT_2018_4                        4 MAXVALUE                                                                           
*/

Creating a Composite Hash-List Partitioned Table

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

Creating a Composite List-List Partitioned Table

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

Creating a Composite List-Range Partitioned Table

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

Creating a Composite List-Hash Partitioned Table

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
)TABLESPACE WAREHOUSE_DATABASE;

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
