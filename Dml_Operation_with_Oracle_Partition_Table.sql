-- To drop permanently from database (If the object exists)—
DROP TABLE dml_operation_partition PURGE;

-- Create object based on the range over maxvalue --
CREATE TABLE dml_operation_partition 
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
INSERT INTO dml_operation_partition VALUES ('partition_name_1',5);
INSERT INTO dml_operation_partition VALUES ('partition_name_1',6);

-- Data for partition_name_2
INSERT INTO dml_operation_partition VALUES ('partition_name_2',15);
INSERT INTO dml_operation_partition VALUES ('partition_name_2',16);
COMMIT;

-- To fetch all the partitions data from table (dml_operation_partition)
SELECT * FROM dml_operation_partition;
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      5
partition_name_1                      6
partition_name_2                     15
partition_name_2                     16
*/

-- To fetch the specific partition data (partition_name_1)
SELECT * FROM dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      5
partition_name_1                      6
*/

-- DML(Delete) operation with partition(partition_name_1) - Conditional
DELETE FROM dml_operation_partition PARTITION (partition_name_1)
WHERE partition_nuber = 5;
COMMIT;
SELECT * FROM dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_1                      6
*/

-- DML(Delete) operation with partition(partition_name_1) - Non conditional
DELETE FROM dml_operation_partition PARTITION (partition_name_1);
COMMIT;
SELECT * FROM dml_operation_partition PARTITION (partition_name_1);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
*/

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_2                     15
partition_name_2                     16
*/

-- DML(Update) operation with partition(partition_name_2) - Conditional
UPDATE dml_operation_partition PARTITION (partition_name_2)
SET partition_nuber = 18
WHERE partition_nuber = 15;
COMMIT;

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME   PARTITION_NUBER
---------------- ---------------
partition_name_2              18
partition_name_2              16
*/

-- DML(Update) operation with partition(partition_name_2) - Non conditional
UPDATE dml_operation_partition PARTITION (partition_name_2)
SET partition_nuber = 18;
COMMIT;

-- To fetch the specific partition data (partition_name_2)
SELECT * FROM dml_operation_partition PARTITION (partition_name_2);
/*
PARTITION_NAME   PARTITION_NUBER
---------------- ---------------
partition_name_2              18
partition_name_2              18
*/

-- To fetch the specific partition data (partition_name_maxvalue)
SELECT * FROM dml_operation_partition PARTITION (partition_name_maxvalue);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
*/

-- Data for partition_name_maxvalue
INSERT INTO dml_operation_partition PARTITION (partition_name_maxvalue) VALUES ('partition_name_maxvalue',25);
INSERT INTO dml_operation_partition PARTITION (partition_name_maxvalue) VALUES ('partition_name_maxvalue',26);
COMMIT;

-- To fetch the specific partition data (partition_name_maxvalue)
SELECT * FROM dml_operation_partition PARTITION (partition_name_maxvalue);
/*
PARTITION_NAME          PARTITION_NUBER
----------------------- ---------------
partition_name_maxvalue              25
partition_name_maxvalue              26
*/
