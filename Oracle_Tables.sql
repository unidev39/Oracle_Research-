-- Using With clause
WITH with_table
AS
  (
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL
  )
SELECT
     col_1,
	 col_2,
	 col_3
FROM 
     with_table
WHERE
     1 = 1;

-- Normal table structure 
CREATE TABLE normal_structure
(
 col_1 NUMBER
);	 
   
-- Using no logging mechanism
CREATE TABLE using_nologing
(
 col_1 NUMBER
) NOLOGGING;

-- Destination table structure as per as source table
-- With all the data
CREATE TABLE employees_bk AS SELECT * FROM employees;
-- Only source structure
CREATE TABLE employees_bk AS SELECT * FROM employees WHERE ROWNUM < 1;
CREATE TABLE employees_bk AS SELECT * FROM employees WHERE 1=2;
-- Using compressed data
CREATE TABLE employees_bk COMPRESS AS SELECT * FROM HR.employees;

-- Table column data type change and create structure as per as client required 
CREATE TABLE client_request
(
 col_1,
 col_2,
 col_3
)
AS
SELECT 1111111 col_1, 'aaaaaaa' col_2, sysdate col_3 FROM dual;

-- External Table 
-- Create a Directories where we place the *.* files that are needed to load in oracle table
CREATE OR REPLACE DIRECTORY DIR_NAME AS 'C:\Users\Unidev\Desktop\Deliminated\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

-- Verification Script
/*
SELECT * FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'DIR_NAME';
*/

-- Connect user (as you wish to create external table) 
-- 1. Comma Delimited
DROP TABLE ZZZ_COMMA_1 PURGE;
CREATE TABLE ZZZ_COMMA_1
(
  COL_1     VARCHAR2(255),
  COL_2     VARCHAR2(255)
)
ORGANIZATION EXTERNAL
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('COMMA.csv')
) REJECT LIMIT UNLIMITED;

-- Verification Script
/*
SELECT * FROM ZZZ_COMMA_1;
*/

-- 2. Pipe Delimited
DROP TABLE ZZZ_PIPE_1 PURGE;
CREATE TABLE ZZZ_PIPE_1
(
  COL_1            VARCHAR2(10)  NULL,
  COL_2            VARCHAR2(10)  NULL
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    READSIZE 1048576
    FIELDS TERMINATED BY '|' 
	OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('PIPE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
/*
SELECT * FROM ZZZ_PIPE_1;
*/
  
-- 3. Tab Delimited
DROP TABLE ZZZ_TAB_1 PURGE;
CREATE TABLE ZZZ_TAB_1
(
    COL_1          VARCHAR2(20),
    COL_2          VARCHAR2(20)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY '\t'
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    MISSING FIELD VALUES ARE NULL
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('TAB.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
/*
SELECT * FROM ZZZ_TAB_1;
*/

-- 4. Size Delimited
DROP TABLE ZZZ_SIZE_1 PURGE;
CREATE TABLE ZZZ_SIZE_1
(
  COL_1        char(5),
  COL_2        char(5),
  COL_3        char(5)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS
    (
      COL_1     position(1:5)   char(5),
      COL_2     position(6:11)  char(5),
      COL_3     position(12:17) char(5)
    )

  )
  LOCATION ('SIZE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
/*
SELECT * FROM ZZZ_SIZE_1;
*/

-- 5. New line Delimited
DROP TABLE ZZZ_NEWLINE_1 PURGE;
CREATE TABLE ZZZ_NEWLINE_1
(
  COL_1 VARCHAR2(4000)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY '\n' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('NEWLINE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
/*
SELECT * FROM ZZZ_NEWLINE_1;
*/
CREATE OR REPLACE DIRECTORY LOG_DIRECTORY_NAME AS 'C:\Users\Unidev\Desktop\Deliminated\logfile\';
GRANT READ,WRITE ON DIRECTORY LOG_DIRECTORY_NAME TO PUBLIC;
CREATE OR REPLACE DIRECTORY BAD_DIRECTORY_NAME AS 'C:\Users\Unidev\Desktop\Deliminated\badfile\';
GRANT READ,WRITE ON DIRECTORY BAD_DIRECTORY_NAME TO PUBLIC;

DROP TABLE zzz_comma_1 PURGE;
CREATE TABLE zzz_comma_1
(
  col_1      VARCHAR2(255),
  col_2      VARCHAR2(255)
)
ORGANIZATION EXTERNAL             --defination of external table.
(
  TYPE ORACLE_LOADER              --type of oracle loader to load the data from csv in external table.
  DEFAULT DIRECTORY DIR_NAME      --defined directory.
  ACCESS PARAMETERS               -- defined parameters.
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    logfile LOG_DIRECTORY_NAME :'Log_File.Log'
    badfile BAD_DIRECTORY_NAME :'Bad_File.bad'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION('COMMA.csv')
)REJECT LIMIT UNLIMITED;


-- Global Temporary Table transaction specific
CREATE GLOBAL TEMPORARY TABLE gtb_table_name_transactional
( 
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) ON COMMIT DELETE ROWS;

INSERT INTO gtb_table_name_transactional
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM gtb_table_name_transactional;

COMMIT;
-- Global Temporary Table session specific

CREATE GLOBAL TEMPORARY TABLE gtb_table_name_session
(  
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) ON COMMIT PRESERVE ROWS;

INSERT INTO gtb_table_name_session
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM gtb_table_name_session;

COMMIT;
