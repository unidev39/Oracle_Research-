SELECT OPNAME,TIME_REMAINING FROM v$session_longops;  

DESC v$session; 
SELECT * FROM v$session WHERE SQL_ID IN (
SELECT SQL_ID FROM v$sqlAREA  WHERE SQL_TEXT LIKE '%INSERT%TEST%');


select SQL_TEXT,ELAPSED_TIME,EXECUTIONS,ELAPSED_TIME/EXECUTIONS from v$sql WHERE SQL_ID IN (
SELECT SQL_ID FROM v$sqlAREA  WHERE SQL_TEXT LIKE 'INSERT%TEST%') ;


SELECT Count(*) FROM test;

SELECT 
opname,
target,
ROUND( ( sofar / totalwork ), 4 ) * 100 Percentage_Complete,
start_time,
CEIL( time_remaining / 60 ) Max_Time_Remaining_In_Min,
FLOOR( elapsed_seconds / 60 ) Time_Spent_In_Min,
AR.sql_fulltext,
AR.parsing_schema_name,
AR.module Client_Tool
FROM v$session_longops L, v$sqlarea AR
WHERE L.sql_id = AR.sql_id
AND totalwork > 0
AND AR.users_executing > 0
AND sofar != totalwork;


SELECT 
opname,
target,
ROUND( ( sofar / totalwork ), 4 ) * 100 Percentage_Complete,
start_time,
CEIL( time_remaining / 60 ) Max_Time_Remaining_In_Min,
FLOOR( elapsed_seconds / 60 ) Time_Spent_In_Min
FROM v$session_longops L
WHERE 
 totalwork > 0
AND sofar != totalwork;

