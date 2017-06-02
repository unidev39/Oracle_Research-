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
 WHERE sno1 BETWEEN 11 AND 20;
 
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
     );
 
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
            WITH tbl_string AS
            (SELECT 'a24iu5e1hg1uo9@^$(5dhjf$^%|5g!1g#e1' string FROM dual)
            SELECT string FROM tbl_string

           )
      CONNECT BY LEVEL <= LENGTH(string)-LENGTH(regexp_replace(string,'[[:digit:]]'))+1
     );
     
 
