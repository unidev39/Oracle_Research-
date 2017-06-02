WITH sticter_req_new
AS
  (
   SELECT 'IRO1' location_id, 143 request_no, 1 request_serial_no FROM dual UNION ALL
   SELECT 'IRO2' location_id, 143 request_no, 2 request_serial_no FROM dual UNION ALL
   SELECT 'IRO3' location_id, 143 request_no, 3 request_serial_no FROM dual UNION ALL
   SELECT 'IRO4' location_id, 143 request_no, 4 request_serial_no FROM dual
  )
SELECT 
     location_id 
FROM 
     sticter_req_new 
WHERE 
     request_no = 143 
AND  request_serial_no = (SELECT 
                                MAX(request_serial_no) -1  
                           FROM 
                                sticter_req_new 
                           WHERE 
                                request_no=143);
