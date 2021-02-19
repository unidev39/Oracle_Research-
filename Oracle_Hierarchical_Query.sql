SELECT LEVEL+ROWNUM sn1, LEVEL+ROWNUM sn2,
       ADD_MONTHS(SYSDATE,ROWNUM) v_date
FROM dual
CONNECT BY LEVEL <6;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 80 dpt_id, 1000 salary FROM dual   
)
SELECT l_name, empid_col, mgrid_col, LEVEL
   FROM data
   CONNECT BY PRIOR empid_col = mgrid_col;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 80 dpt_id, 1000 salary FROM dual   
)
SELECT l_name, empid_col, mgrid_col, LEVEL
      FROM data
      START WITH empid_col = 100
      CONNECT BY PRIOR empid_col = mgrid_col
      ORDER SIBLINGS BY l_name;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 80 dpt_id, 1000 salary FROM dual   
)
SELECT l_name "Employee", 
   LEVEL, SYS_CONNECT_BY_PATH(l_name, '/') "Path"
   FROM data
   WHERE level <= 3 AND dpt_id = 80
   START WITH l_name = 'King'
   CONNECT BY PRIOR empid_col = mgrid_col AND LEVEL <= 4;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 80 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 80 dpt_id, 1000 salary FROM dual   
)
SELECT l_name "Employee", CONNECT_BY_ISCYCLE "Cycle",
   LEVEL, SYS_CONNECT_BY_PATH(l_name, '/') "Path"
   FROM data
   WHERE level <= 3 AND dpt_id = 80
   START WITH l_name = 'King'
   CONNECT BY NOCYCLE PRIOR empid_col = mgrid_col AND LEVEL <= 4;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 110 dpt_id, 1000 salary FROM dual   
)
SELECT l_name "Employee", CONNECT_BY_ROOT l_name "Manager",
   LEVEL-1 "Pathlen", SYS_CONNECT_BY_PATH(l_name, '/') "Path"
   FROM data
   WHERE LEVEL > 1 and dpt_id = 110
   CONNECT BY PRIOR empid_col = mgrid_col;

WITH data 
as
(                                                                      
  SELECT 100 empid_col, 'King'      l_name,  0  mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL        
  SELECT 101 empid_col, 'Kochhar'   l_name, 100 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 102 empid_col, 'De Haan'   l_name, 100 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 103 empid_col, 'Hunold'    l_name, 102 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 104 empid_col, 'Ernst'     l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL    
  SELECT 105 empid_col, 'Austin'    l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL   
  SELECT 106 empid_col, 'Pataballa' l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 107 empid_col, 'Lorentz'   l_name, 103 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL  
  SELECT 108 empid_col, 'Greenberg' l_name, 101 mgrid_col, 110 dpt_id, 1000 salary FROM dual UNION ALL
  SELECT 109 empid_col, 'Faviet'    l_name, 108 mgrid_col, 110 dpt_id, 1000 salary FROM dual   
)
SELECT name, SUM(salary) "Total_Salary" FROM (
   SELECT CONNECT_BY_ROOT l_name as name, Salary
      FROM data
      WHERE dpt_id = 110
      CONNECT BY PRIOR empid_col = mgrid_col)
      GROUP BY name;

