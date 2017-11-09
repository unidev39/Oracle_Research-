--To fetch ALTERNATE records FROM a table. (EVEN NUMBERED)
SELECT 
     *
FROM 
     employees
WHERE 
     ROWID IN (
		       SELECT 
                    CASE 
                       WHEN MOD(ROWNUM, 2) = 0 THEN ROWID 
                    ELSE 
                       NULL 
                    END data
		       FROM 
                    employees
		      );

--To SELECT ALTERNATE records FROM a table. (ODD NUMBERED)
SELECT 
     *
FROM 
     employees
WHERE 
     ROWID IN (
		       SELECT 
                    CASE 
                       WHEN MOD(ROWNUM, 2) = 0 THEN NULL 
                    ELSE 
                       ROWID 
                    END data
		       FROM 
                    employees
		          );

--Find the 3rd MAX salary in the employees table.
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 = (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary <= e2.salary
         );

SELECT DISTINCT
     salary 
FROM 
     (
      SELECT 
           salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) salaryrank 
      FROM 
           employees
     ) 
WHERE 
     salaryrank = 3;

--Find the 3rd MIN salary in the employees table.
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 = (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary >= e2.salary
         );

SELECT DISTINCT
     salary 
FROM 
     (
      SELECT 
           salary,
           DENSE_RANK() OVER (ORDER BY salary ASC) salaryrank 
      FROM 
           employees
     ) 
WHERE 
     salaryrank = 3;

--SELECT FIRST n records FROM a table.
SELECT 
     * 
FROM 
     employees 
WHERE 
     ROWNUM <= &n;

--SELECT LAST n records FROM a table
SELECT * FROM employees 
MINUS 
SELECT 
     * 
FROM 
     employees 
WHERE 
     ROWNUM <= (
                SELECT 
                     COUNT(*) - &n 
                FROM 
                     employees
               );

--List dept no., Dept name for all the departments in which there are no employeesloyees in the department.
SELECT 
     * 
FROM 
     departments 
WHERE 
     department_id NOT IN (
                           SELECT 
                                NVL(department_id,0) department_id 
                           FROM 
                                employees
                          );    
SELECT 
     * 
FROM 
     departments a 
WHERE NOT EXISTS (
                  SELECT 
                       * 
                  FROM 
                       employees b 
                  WHERE 
                       a.department_id = b.department_id
                 );                                                                 
SELECT 
     b.department_id,
     b.department_name 
FROM 
     employees a, departments b 
WHERE 
     a.department_id(+) = b.department_id 
AND 
     employee_id IS NULL;

--How to get 3 Max salaryaries ?
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 >= (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary <= e2.salary
         )
ORDER BY e1.salary DESC;

--How to get 3 Min salaryaries ?
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 >= (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary >= e2.salary
         )
ORDER BY e1.salary ASC;

--How to get nth max salaryaries ?
SELECT DISTINCT 
     salary 
FROM 
     employees a 
WHERE &n = (
            SELECT 
                 COUNT(DISTINCT salary) 
            FROM 
                 employees b 
            WHERE 
                 a.salary >= b.salary
           );

--SELECT DISTINCT RECORDS FROM employees table.
SELECT 
     * 
FROM 
     employees a 
WHERE  
     ROWID = (
              SELECT 
                   MAX(ROWID) 
              FROM 
                   employees b 
              WHERE  
                   a.employee_id=b.employee_id
             );

--How to delete duplicate rows in a table?
DELETE FROM employees a 
WHERE 
    ROWID != (
              SELECT 
                   MAX(ROWID) 
              FROM 
                   employees b 
              WHERE  
                   a.employee_id=b.employee_id
             );

DELETE FROM employees a 
WHERE 
    ROWID > ANY (
                 SELECT 
                      ROWID 
                 FROM 
                      employees b 
                 WHERE  
                      a.employee_id=b.employee_id
                );

--COUNT of number of employeesloyees in  department  wise.
SELECT 
     COUNT(employee_id), 
     b.department_id, 
     department_name 
FROM 
     employees a, departments b  
WHERE 
     a.department_id(+)=b.department_id  
GROUP BY 
     b.department_id,department_name;

--Suppose there is annual salary information provided by employees table. How to fetch monthly salary of each and every employeesloyee?
SELECT 
     first_name,
     salary/12 as monthlysalary 
FROM 
     employees;

--SELECT all record FROM employees table WHERE department_id =10 or 40.
SELECT 
     * 
FROM 
     employees 
WHERE 
     department_id=30 OR department_id=10;

--SELECT all record FROM employees table WHERE department_id=30 and salary>1500.
SELECT 
     * 
FROM 
     employees 
WHERE 
     department_id=30 AND salary>1500;

--SELECT  all record  FROM employees WHERE job not in salaryESMAN  or CLERK.
SELECT 
     * 
FROM 
     employees 
WHERE 
     job_id NOT IN ('salaryESMAN','CLERK');

--SELECT all record FROM employees WHERE first_name in 'BLAKE','SCOTT','KING'and'FORD'.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name IN ('JONES','BLAKE','SCOTT','KING','FORD');

--SELECT all records WHERE first_name starts with ‘S’ and its lenth is 6 char.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name like'S____';

--SELECT all records WHERE first_name may be any no of  character but it should end with ‘R’.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name LIKE '%R';

--COUNT  MGR and their salary in employees table.
SELECT 
     COUNT(manager_id),
     COUNT(salary) 
FROM 
     employees;

--In employees table add comm+salary as total salary  .
SELECT 
     first_name,
     (salary+NVL(commission_pct,0)) AS totalsalary 
FROM 
     employees;

--SELECT  any salary <3000 FROM employees table. 
SELECT 
     * 
FROM 
     employees 
WHERE 
     salary > ANY (
                   SELECT 
                        salary 
                   FROM 
                        employees 
                   WHERE salary<3000
                  );

--SELECT  all salary <3000 FROM employees table. 
SELECT 
     * 
FROM 
     employees  
WHERE 
     salary > ALL (
                   SELECT 
                        salary 
                   FROM 
                        employees 
                   WHERE 
                        salary < 3000
                  );

--SELECT all the employeesloyee  group by department_id and salary in descending order.
SELECT 
     first_name,
     department_id,
     salary 
FROM 
     employees 
ORDER BY 
     department_id,salary DESC;

--How can I create an employeesty table employees1 with same structure as employees?
CREATE TABLE employees1 
AS 
SELECT * FROM employees WHERE 1=2;

--How to retrive record WHERE salary between 1000 to 2000?
SELECT 
     * 
FROM 
     employees 
WHERE 
     salary >= 1000 AND salary < 2000;

--SELECT all records WHERE dept no of both employees and dept table matches.
SELECT 
     * 
FROM 
     employees e
WHERE 
     EXISTS ( 
             SELECT 
                  * 
             FROM 
                  departments d
             WHERE 
                  e.department_id=d.department_id
            );

--If there are two tables employees1 and employees2, and both have common record. How can I fetch all the recods but common records only once?
(SELECT * FROM employees) 
 UNION 
(SELECT * FROM employees1);

--How to fetch only common records FROM two tables employees and employees1?
(SELECT * FROM employees) 
 INTERSECT 
(SELECT * FROM employees1);

--How can I retrive all records of employees1 those should not present in employees2?
(SELECT * FROM employees) 
 MINUS 
(SELECT * FROM employees1);

--COUNT the totalsa  department_id wise WHERE more than 2 employeesloyees exist.
SELECT  
     department_id, 
     SUM(salary) AS totalsalary
FROM 
     employees
GROUP BY 
     department_id
HAVING COUNT(employee_id) > 2;