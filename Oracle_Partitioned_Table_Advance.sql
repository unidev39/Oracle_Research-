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


Using Virtual Column-Based Partitioning

With partitioning, a virtual column can be used as any regular column. All partition methods are supported when using 
virtual columns, including interval partitioning and all different combinations of composite partitioning. A virtual 
column used as the partitioning column cannot use calls to a PL/SQL function.

The following example shows the sales_partitioning table partitioned by range-range using a virtual column for the subpartitioning key.
The virtual column calculates the total value of a sale by multiplying amount_sold and quantity_sold.

Creating a table with a virtual column for the subpartitioning key

-- To drop permanently from database (If the object exists)
DROP TABLE sales_partitioning PURGE;
-- To Creating a multicolumn range-partitioned table with max values
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
 SUBPARTITION p_small VALUES LESS THAN (1000),
 SUBPARTITION p_medium VALUES LESS THAN (5000),
 SUBPARTITION p_large VALUES LESS THAN (10000),
 SUBPARTITION p_extreme VALUES LESS THAN (MAXVALUE)
)
(PARTITION sales_before_2018 VALUES LESS THAN (TO_DATE('01-JAN-2018','DD-MON-YYYY'))
)
ENABLE ROW MOVEMENT
PARALLEL NOLOGGING;

INSERT INTO sales_partitioning 
(
 prod_id,cust_id,time_id,channel_id,promo_id,quantity_sold,amount_sold,total_amount
) 
VALUES
(
 1,100,SYSDATE,'A',10,50,50,2500
);
--ORA-54013: INSERT operation disallowed on virtual columns 
 
INSERT INTO sales_partitioning 
(
 prod_id,cust_id,time_id,channel_id,promo_id,quantity_sold,amount_sold
) 
VALUES
(
 1,100,SYSDATE,'A',10,50,50
);
COMMIT;

SELECT * FROM sales_partitioning;
/*
PROD_ID CUST_ID TIME_ID             CHANNEL_ID PROMO_ID QUANTITY_SOLD AMOUNT_SOLD TOTAL_AMOUNT
------- ------- ------------------- ---------- -------- ------------- ----------- ------------
      1     100 05.02.2018 13:35:38 A                10            50          50         2500
*/


Using Table Compression with Partitioned Tables

For range-organized partitioned tables, you can compress some or all partitions using table compression.
The compression attribute can be declared for a tablespace, a table, or a partition of a table. Whenever 
the compress attribute is not specified, it is inherited like any other storage attribute.

The following example creates a range-partitioned table with one compressed partition costs_old.
The compression attribute for the table and all other partitions is inherited from the tablespace level.

Creating a range-partitioned table with a compressed partition

-- To drop permanently from database (If the object exists)
DROP TABLE compress_partitioning PURGE;
-- To Creating a compress range-partitioned table
CREATE TABLE compress_partitioning 
(
   prod_id     NUMBER(6),
   time_id     DATE, 
   unit_cost   NUMBER(10,2),
   unit_price  NUMBER(10,2)
)
PARTITION BY RANGE (time_id)
(
 PARTITION costs_old     VALUES LESS THAN (TO_DATE('01-JAN-2003', 'DD-MON-YYYY')) COMPRESS,
 PARTITION costs_q1_2003 VALUES LESS THAN (TO_DATE('01-APR-2003', 'DD-MON-YYYY')) COMPRESS,
 PARTITION costs_q2_2003 VALUES LESS THAN (TO_DATE('01-JUN-2003', 'DD-MON-YYYY')) COMPRESS,
 PARTITION costs_recent VALUES LESS THAN (MAXVALUE) COMPRESS
);

INSERT INTO compress_partitioning VALUES(1,SYSDATE,10,10);
COMMIT;

SELECT * FROM compress_partitioning PARTITION (costs_recent);
/*
PROD_ID TIME_ID             UNIT_COST UNIT_PRICE
------- ------------------- --------- ----------
      1 05.02.2018 15:26:09        10         10
*/

