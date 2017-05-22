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
