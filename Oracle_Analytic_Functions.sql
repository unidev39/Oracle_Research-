SELECT 
     employee_id,
     department_id,
     salary,
     RANK() OVER (PARTITION BY department_id ORDER BY salary)       rank_part_dpt_order_sal,
     DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary) dense_rank_part_dpt_order_sal
FROM   
     employees
WHERE 
     department_id = 50;
     
/*
employee_id department_id salary rank_part_dpt_order_sal dense_rank_part_dpt_order_sal
----------- ------------- ------ ----------------------- -----------------------------
132         50            2100   1                       1
128         50            2200   2                       2
136         50            2200   2                       2
135         50            2400   4                       3
127         50            2400   4                       3
*/

SELECT 
     employee_id,
     department_id,
     salary,
     RANK() OVER (ORDER BY salary)        rank_order_salary,
     DENSE_RANK() OVER (ORDER BY salary)  dense_rank_order_salary
FROM   
     employees
WHERE 
     department_id = 50;
/*
employee_id department_id salary rank_order_salary dense_rank_order_salary
----------- ------------- ------ ----------------- -----------------------     
132         50            2100   1                 1
128         50            2200   2                 2
136         50            2200   2                 2
135         50            2400   4                 3
127         50            2400   4                 3
131         50            2500   6                 4
*/

SELECT 
     employee_id,
     department_id,
     salary,
     MIN(salary) KEEP (DENSE_RANK FIRST ORDER BY salary) OVER (PARTITION BY department_id) lowest_salary,
     MAX(salary) KEEP (DENSE_RANK LAST ORDER BY salary) OVER (PARTITION BY department_id)  highest_salary
FROM   
     employees
WHERE 
     department_id = 30
ORDER BY 
     department_id,salary;
     
/*
employee_id department_id salary lowest_salary highest_salary
----------- ------------- ------ ------------- --------------
119         30            2500   2500          11000
118         30            2600   2500          11000
117         30            2800   2500          11000
116         30            2900   2500          11000
115         30            3100   2500          11000
114         30            11000  2500          11000
*/

SELECT 
     employee_id,
     department_id,
     salary,
     FIRST_VALUE(salary) IGNORE NULLS OVER (PARTITION BY department_id ORDER BY salary)                                                          lowest_salary_in_dept,
     LAST_VALUE(salary) IGNORE NULLS OVER (PARTITION BY department_id ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) highest_in_salary_dept
FROM   
     employees
WHERE 
     department_id in (30,20)
ORDER BY 
     department_id,salary;
     
/*
employee_id department_id salary lowest_salary_in_dept highest_in_salary_dept
----------- ------------- ------ --------------------- ----------------------
202         20            6000   6000                  13000
201         20            13000  6000                  13000
119         30            2500   2500                  11000
118         30            2600   2500                  11000
117         30            2800   2500                  11000
116         30            2900   2500                  11000
115         30            3100   2500                  11000
114         30            11000  2500                  11000
*/

SELECT 
     employee_id,
     department_id,
     salary,
     LAG(salary, 1, 0) OVER (ORDER BY salary)           salary_previous,
     salary - LAG(salary, 1, 0) OVER (ORDER BY salary)  salary_difference
FROM   
     employees
WHERE 
     department_id in (30,20);

     
/*
employee_id department_id salary salary_previous salary_difference
----------- ------------- ------ --------------- -----------------
119         30            2500   0               2500
118         30            2600   2500            100
117         30            2800   2600            200
116         30            2900   2800            100
115         30            3100   2900            200
202         20            6000   3100            2900
114         30            11000  6000            5000
201         20            13000  11000           2000
*/

SELECT 
     employee_id,
     department_id,
     salary,
     LEAD(salary, 1, 0) OVER (ORDER BY salary)           salary_next,
     LEAD(salary, 1, 0) OVER (ORDER BY salary) - salary  salary_difference
FROM   
     employees
WHERE 
     department_id in (30,20);

     
/*
employee_id department_id salary salary_next salary_difference
----------- ------------- ------ ----------- -----------------
119         30            2500   2600        100
118         30            2600   2800        200
117         30            2800   2900        100
116         30            2900   3100        200
115         30            3100   6000        2900
202         20            6000   11000       5000
114         30            11000  13000       2000
201         20            13000  0           -13000
*/

SELECT
      queryname,
      curtime,
      LEAD(curtime,1) OVER (ORDER BY curtime)             AS curtime_next,
      LEAD(curtime,1) OVER (ORDER BY curtime) - curtime   AS curtime_diff
FROM
    (SELECT 'SQL_01' queryname, SYSDATE   curtime FROM dual UNION ALL
     SELECT 'SQL_02' queryname, SYSDATE+1 curtime FROM dual UNION ALL
     SELECT 'SQL_03' queryname, SYSDATE+2 curtime FROM dual UNION ALL
     SELECT 'SQL_04' queryname, SYSDATE+3 curtime FROM dual UNION ALL
     SELECT 'SQL_05' queryname, SYSDATE+4 curtime FROM dual
    );

/*
QUERYNAME CURTIME             CURTIME_NEXT        CURTIME_DIFF
--------- ------------------- ------------------- ------------
SQL_01    02.06.2017 17:21:52 03.06.2017 17:21:52            1
SQL_02    03.06.2017 17:21:52 04.06.2017 17:21:52            1
SQL_03    04.06.2017 17:21:52 05.06.2017 17:21:52            1
SQL_04    05.06.2017 17:21:52 06.06.2017 17:21:52            1
SQL_05    06.06.2017 17:21:52                                 
*/

DROP TABLE log_time purge;
CREATE TABLE log_time
(
  queryname VARCHAR2(50),
  curtime   TIMESTAMP 
);
-- To insert data
DECLARE
   l_v VARCHAR2(32767) := 0;
BEGIN
   INSERT INTO log_time VALUES('block_1',systimestamp);
   BEGIN 
       FOR i IN 1 .. 5000000
       LOOP
          l_v := l_v + i;
       END LOOP;
   END;

   INSERT INTO log_time VALUES('block_2',systimestamp);
   BEGIN 
       FOR i IN 1 .. 500000
       LOOP
          l_v := l_v + i;
       END LOOP;
   END;

   INSERT INTO log_time VALUES('block_3',systimestamp);
   BEGIN 
       FOR i IN 1 .. 5000
       LOOP
          l_v := l_v + i;
       END LOOP;
   END;

   INSERT INTO log_time VALUES('block_4',systimestamp);
   BEGIN 
       FOR i IN 1 .. 500000
       LOOP
          l_v := l_v + i;
       END LOOP;
   END;
   COMMIT;
END;
/

SELECT
     queryname,
     curtime,
     LEAD(curtime,1) OVER (ORDER BY curtime)             AS curtime_next,
     LEAD(curtime,1) OVER (ORDER BY curtime) - curtime   AS curtime_diff
FROM 
     log_time;

/*
QUERYNAME CURTIME               CURTIME_NEXT          CURTIME_DIFF
--------- --------------------- --------------------- --------------
block_1   02.06.17 08:10:25.281 02.06.17 08:10:26.668 +0 00:00:01.38
block_2   02.06.17 08:10:26.668 02.06.17 08:10:26.803 +0 00:00:00.13
block_3   02.06.17 08:10:26.803 02.06.17 08:10:26.804 +0 00:00:00.00
block_4   02.06.17 08:10:26.804                                     
*/

-- Used in Pagination
SELECT 
      *
FROM (
      SELECT 
           b.*, 
           ROW_NUMBER () OVER (ORDER BY b.sno) sno1
      FROM 
           (
            SELECT /*+ PARALLEL(a,8) */
                 ROWNUM sno,
                 a.employee_id,
                 a.first_name,
                 a.last_name,
                 a.email,
                 a.phone_number,
                 a.hire_date,
                 a.job_id,
                 a.salary,
                 a.commission_pct,
                 a.manager_id,
                 a.department_id                 
            FROM 
                 hr.employees a
            WHERE 
                 a.department_id = 50
            ) b
     )
 WHERE sno1 BETWEEN 11 AND 15;

/*
SNO EMPLOYEE_ID FIRST_NAME LAST_NAME EMAIL    PHONE_NUMBER HIRE_DATE           JOB_ID   SALARY COMMISSION_PCT MANAGER_ID DEPARTMENT_ID SNO1
--- ----------- ---------- --------- -------  ------------ ------------------- -------- ------ -------------- ---------- ------------- ----
 11         128 Steven     Markle    SMARKLE  650.124.1434 08.03.2008 00:00:00 ST_CLERK   2200                       120            50   11
 12         129 Laura      Bissot    LBISSOT  650.124.5234 20.08.2005 00:00:00 ST_CLERK   3300                       121            50   12
 13         130 Mozhe      Atkinson  MATKINSO 650.124.6234 30.10.2005 00:00:00 ST_CLERK   2800                       121            50   13
 14         131 James      Marlow    JAMRLOW  650.124.7234 16.02.2005 00:00:00 ST_CLERK   2500                       121            50   14
 15         132 TJ         Olson     TJOLSON  650.124.8234 10.04.2007 00:00:00 ST_CLERK   2100                       121            50   15
*/
 
WITH data AS
(
  SELECT 
       'a,a,a,b,z,z,x,y,y,c'||','  col
  FROM 
       dual
)
SELECT 
     wm_concat(col) col
FROM (
      SELECT DISTINCT 
           regexp_substr(col, '[^,]+',1,level) col
      FROM 
          data
      CONNECT BY LEVEL <= (LENGTH (col) - LENGTH (REPLACE (col, ',')))
      ORDER BY col
     );

/*
COL
-----------        
a,b,c,x,y,z
*/

SELECT
     SUM(number_data)                                    number_data,
     listagg(string_data,'') WITHIN GROUP(ORDER BY sn)   string_data,
     listagg(wildcard_data,'') WITHIN GROUP(ORDER BY sn) wildcard_data
FROM (
      SELECT
           ROWNUM sn,
           regexp_substr(string,'[[:digit:]]+',1,LEVEL) number_data,
           regexp_substr(string,'[[:alpha:]]+',1,LEVEL) string_data,
           regexp_substr(string,'(\W)',1,LEVEL)         wildcard_data
      FROM (
            WITH tbl_string 
            AS
             (
              SELECT 
                   'a24iu5e1hg1uo9@^$(5dhjf$^%|5g!1g#e1' string 
              FROM 
                  dual
             )
            SELECT 
                 string 
            FROM 
             tbl_string
           )
      CONNECT BY LEVEL <= LENGTH(string)-LENGTH(regexp_replace(string,'[[:digit:]]'))+1
     ); 
/*
NUMBER_DATA STRING_DATA     WILDCARD_DATA
----------- --------------- -------------
         52 aiuehguodhjfgge @^$($^%|!#   
*/
