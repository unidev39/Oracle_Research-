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

ALTER USER DSHRIVASTAV DEFAULT TABLESPACE WAREHOUSE_BIGFILE_DATABASE;
ALTER USER DSHRIVASTAV TEMPORARY TABLESPACE TEMP_WAREHOUSE_DATABASE;

-- To drop the partition table permanently from database (If the object exists)
DROP TABLE dshrivastav.ra_partition PURGE;

-- To Creating a temporary partition table to mapped the object structure with non-partition table
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

-- To Creating a temporary partition table to mapped the object structure with the current object structure
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
 PARTITION p_16   VALUES LESS THAN (MAXVALUE)  TABLESPACE WAREHOUSE_BIGFILE_DATABASE
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
DSHRIVASTAV RA_PARTITION WAREHOUSE_BIGFILE_DATABASE P_16           MAXVALUE                   16        0
*/

                                                                                                            
SELECT 'P_1'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_1)  UNION ALL   
SELECT 'P_2'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_2)  UNION ALL   
SELECT 'P_3'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_3)  UNION ALL   
SELECT 'P_4'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_4)  UNION ALL   
SELECT 'P_5'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_5)  UNION ALL   
SELECT 'P_6'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_6)  UNION ALL   
SELECT 'P_7'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_7)  UNION ALL   
SELECT 'P_8'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_8)  UNION ALL   
SELECT 'P_9'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_9)  UNION ALL   
SELECT 'P_10' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_10) UNION ALL 
SELECT 'P_11' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_11) UNION ALL 
SELECT 'P_12' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_12) UNION ALL 
SELECT 'P_13' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_13) UNION ALL 
SELECT 'P_14' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_14) UNION ALL 
SELECT 'P_15' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_15) UNION ALL 
SELECT 'P_16' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_16); 
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
P_16                    0
*/

SELECT 
     CASE 
        WHEN SUM(a.data_count) =  128000000 THEN 'PASS' 
     ELSE
        'FAIL'
     END data_validation
FROM (
      SELECT 'P_1'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_1)  UNION ALL   
      SELECT 'P_2'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_2)  UNION ALL   
      SELECT 'P_3'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_3)  UNION ALL   
      SELECT 'P_4'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_4)  UNION ALL   
      SELECT 'P_5'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_5)  UNION ALL   
      SELECT 'P_6'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_6)  UNION ALL   
      SELECT 'P_7'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_7)  UNION ALL   
      SELECT 'P_8'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_8)  UNION ALL   
      SELECT 'P_9'  partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_9)  UNION ALL   
      SELECT 'P_10' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_10) UNION ALL 
      SELECT 'P_11' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_11) UNION ALL 
      SELECT 'P_12' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_12) UNION ALL 
      SELECT 'P_13' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_13) UNION ALL 
      SELECT 'P_14' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_14) UNION ALL 
      SELECT 'P_15' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_15) UNION ALL 
      SELECT 'P_16' partition_name, COUNT(*) data_count FROM dshrivastav.ra_partition PARTITION (P_16)
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