--Anonomus BLOCK : An anonymous block is an unnamed sequence of actions. Since they are unnamed, 
--anonymous blocks cannot be referenced by other program units.

-- Simplest Anonymous Block
BEGIN
    <valid statement>;
END;
/

-- Examples to diplay nothing
BEGIN
    NULL;
END;
/

-- The classic “Print PL/SQL” block contains an executable section that calls the dbms_output.put_line procedure to display text on the screen:
BEGIN
    dbms_output.put_line ('Print PL/SQL');
END;
/

-- Anonymous Block With Error Exception Handler
BEGIN
    <valid statement>;
EXCEPTION
    <exception handler>;
END;
/

-- Examples to diplay nothing with exception handeling
BEGIN
    NULL;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

-- Nested Anonymous Blocks With Exception Handlers
BEGIN
    <valid statement>;
    BEGIN
        <valid statement>;
    EXCEPTION
        <exception handler>;
    END;
EXCEPTION
    <exception handler>;
END;
/

-- Nested Anonymous Blocks With Exception Handlers to display nothing
BEGIN
    NULL;
    BEGIN
        NULL;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

-- Nested Anonymous Blocks WITH Variable Declaration
DECLARE
     <variable name> <data type><(LENGTH PRECISION)>;
BEGIN
     <valid statement>;
END;
/

-- To display the output as in upper case
DECLARE
    l_message      VARCHAR2(1);
BEGIN
    l_message  :=  UPPER('a');
    dbms_output.put_line(l_message);
END;
/

--Anonymous block has not defined under a name.
DECLARE
    (decleration statememt)
-- Main block
BEGIN
    --1st block
    BEGIN
        (executation statement)
    (EXCEPTION handling)
    END; -- End of 1st block
    
	--2nd block
    BEGIN
        (executation statement)
    (EXCEPTION handling)
    END; -- End of 2nd block

END;
/ -- End of Main block

DECLARE
    l_message      VARCHAR2(100);
BEGIN
    dbms_output.put_line('Block 1');
    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 2');
    END;
    
    BEGIN
        l_message  :=  To_number('abc');         
        dbms_output.put_line(l_message);    
    --EXCEPTION WHEN OTHERS THEN
        --dbms_output.put_line('Block 3');
    END;

    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 4');
    END;

    l_message  :=  To_char('abc');
    dbms_output.put_line(l_message);
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('Block 1');
END;
/

DECLARE
    l_message      VARCHAR2(100);
BEGIN
    dbms_output.put_line('Block 1');
    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 2');
    END;
    
    BEGIN
        l_message  :=  To_number('abc');         
        dbms_output.put_line(l_message);    
    --EXCEPTION WHEN OTHERS THEN
        --dbms_output.put_line('Block 3');
    END;

    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 4');
    END;

    l_message  :=  To_char('abc');
    dbms_output.put_line(l_message);
--EXCEPTION WHEN OTHERS THEN
    --dbms_output.put_line('Block 1');
END;
/

-- Overwrite Case
DECLARE
    l_message      VARCHAR2(100) := 'a' ;
BEGIN
    dbms_output.put_line(l_message);
    l_message := 'b'; 
    dbms_output.put_line(l_message);
END;
/

/*
a
b
*/

DECLARE
    l_message      VARCHAR2(100) := 'a' ; -- Public Variable Declaration
BEGIN
    dbms_output.put_line(l_message);
	
    DECLARE 
       l_message VARCHAR2(100) := 'b'; -- Private Variable Declaration
    BEGIN
        dbms_output.put_line(l_message);
    END;
    
    dbms_output.put_line(l_message);
END;
/

/*
a                             
b                             
a                               
*/

DECLARE
	  l_message  CONSTANT VARCHAR2(5) := 'PASS';
BEGIN
    l_message  :=  'FAIL';
    dbms_output.put_line(l_message);
END;
/
/*
ORA-06550: line 4, column 5:
PLS-00363: expression 'L_MESSAGE' cannot be used as an assignment target
ORA-06550: line 4, column 5:
PL/SQL: Statement ignored
*/

DECLARE
	  l_message  CONSTANT VARCHAR2(5);
BEGIN
    l_message  :=  'FAIL';
    dbms_output.put_line(l_message);
END;
/
/*
ORA-06550: line 2, column 2:
PLS-00322: declaration of a constant 'L_MESSAGE' must contain an initialization assignment
ORA-06550: line 2, column 13:
PL/SQL: Item ignored
ORA-06550: line 4, column 5:
PLS-00363: expression 'L_MESSAGE' cannot be used as an assignment target
ORA-06550: line 4, column 5:
PL/SQL: Statement ignored
*/

DECLARE
    l_message  CONSTANT VARCHAR2(5);
BEGIN
    dbms_output.put_line(l_message);
END;
/
/*
ORA-06550: line 2, column 4:
PLS-00322: declaration of a constant 'L_MESSAGE' must contain an initialization assignment
ORA-06550: line 2, column 15:
PL/SQL: Item ignored
*/

DECLARE
    l_message  CONSTANT VARCHAR2(5) := 'PASS';
BEGIN
    dbms_output.put_line(l_message);
END;
/
/*
PASS
*/

-- The following example block demonstrates the PL/SQL ability to nest blocks within blocks as well as the use of the 
-- concatenation operator (||) to join together multiple strings.
DECLARE
    l_message_1  VARCHAR2(100) := 'Print';
BEGIN
    DECLARE
        l_message_2  VARCHAR2 (100) := l_message_1||' PL/SQL!';
    BEGIN
        dbms_output.put_line (l_message_2);
    END;
END;
/

-- To convert and check the data in proper formate
--To check weather the given value is number OR not and to use the value for the arihematic operation.
DECLARE
    l_message VARCHAR2(1) := '1';
BEGIN
    l_message  :=  TO_NUMBER(l_message);
    dbms_output.put_line(l_message);
END;
/

-- To convert and check the data in proper formate with EXCEPTION handeling
DECLARE
    l_message VARCHAR2(1) := 'A';
BEGIN
    l_message  :=  TO_NUMBER(l_message);
    dbms_output.put_line(l_message);
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/

-- Play with character manipulation function using variables
DECLARE
    l_string    VARCHAR2 (100) :='ss6ss';
    l_char      NUMBER;
    l_data      NUMBER := 5;
BEGIN
    dbms_output.put_line('l_string: '||l_string);
    dbms_output.put_line('l_data: '||l_data);
    l_char := SUBSTR(l_string,INSTR(l_string,6,1),1);
    dbms_output.put_line('l_char: '||l_char);
    dbms_output.put_line('l_char + l_data: '||l_char||'+'||l_data);
END;
/

-- If Condition using operators
DECLARE
    l_message   VARCHAR2(1) := 'A';
BEGIN
    IF (l_message = 'A'  OR l_message = 'B') THEN
       dbms_output.put_line('Pass: '||l_message);
    END IF;
END;
/

DECLARE
    l_message   VARCHAR2(1) := 'A';
BEGIN
    IF (l_message = 'A'  OR l_message = 'B') THEN
       dbms_output.put_line('Pass: '||l_message);
    ELSE
       dbms_output.put_line('Fail: '||l_message);
    END IF;
END;
/

-- If Condition using operators
DECLARE
    l_message   VARCHAR2(1) := 'A';
BEGIN
    IF (l_message = 'A'  AND  l_message = 'B') THEN
       dbms_output.put_line('Pass: '||l_message);
    ELSIF (l_message = 'B') THEN
       dbms_output.put_line('Pass: '||l_message);
    ELSE
       dbms_output.put_line('Fail: '||l_message);
    END IF;
END;
/

-- If Condition using operators uder nested blocks
DECLARE
    l_number_1      NUMBER := 1;
    l_number_2      NUMBER := 3;
BEGIN
    IF ( l_number_1 = 1  AND  l_number_2 = 2 ) THEN
       dbms_output.put_line('Pass :'||l_number_1||','||l_number_2);
    ELSE
       BEGIN
           l_number_1:=10;
           dbms_output.put_line(l_number_1);
       END;
    END IF;
END;
/

-- USER is a function, which show where you as in
DECLARE
    l_user      VARCHAR2(10);
BEGIN
    SELECT USER INTO l_user FROM dual;
    dbms_output.put_line('Current user: '||l_user);
END;
/

-- Dynamic Operation
DECLARE
    g_sql    VARCHAR2(2000);  -- used as global variable (Note: Globle variable used with named block)
    l_col_1  NUMBER (20) := 10;
BEGIN
    g_sql := 'INSERT INTO test_table (Col_1) VALUES('||l_col_1||')';
    BEGIN
        EXECUTE IMMEDIATE (g_sql);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;
    COMMIT;
	
    BEGIN
        EXECUTE IMMEDIATE (g_sql);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;
    COMMIT;
END;
/

DECLARE
    l_message        VARCHAR2(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE t1 PURGE';
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE t1
                       (
                         col_1 VARCHAR2(10)
                       )';

    EXECUTE IMMEDIATE 'SELECT col_1 FROM t1' INTO l_message;
EXCEPTION WHEN No_Data_Found THEN
    dbms_output.put_line(SQLERRM);
END;
/

-- to handel the syntax error or table or view does not exit.
DECLARE
      vblTableName    VARCHAR2(30):='aaa';
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE '||vblTableName||'';
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942) THEN
      dbms_output.put_line('Table or view does not exit');
    ELSIF(SQLCODE<>-00942) THEN
      dbms_output.put_line(SQLERRM);
    ELSE
      dbms_output.put_line('Table Droped');
    END IF;
END;
/

-- to handel the syntax error or table or view does not exit.(Alternative)
DECLARE
    l_tablename    VARCHAR2(30):='aaa';
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE '||l_tablename||'';
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942 OR SQLCODE<>-00942) THEN
       IF(SQLCODE=-00942) THEN
          dbms_output.put_line('Table or view does not exit');
       ELSIF(SQLCODE<>-00942) THEN
          dbms_output.put_line(SQLERRM);
       END IF;
    ELSE
      dbms_output.put_line('Table Droped');
    END IF;
END;
/
-- to handel the syntax error or table or view does not exit.(Alternative)
DECLARE
      l_tablename    VARCHAR2(30):='aaa';
      l_drop         VARCHAR2(32767);
BEGIN
    l_drop:='DROP TABLE '||l_tablename||'';
    EXECUTE IMMEDIATE l_drop;
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942 OR SQLCODE<>-00942) THEN
       IF(SQLCODE=-00942) THEN
          dbms_output.put_line('Table or view does not exit');
       ELSIF(SQLCODE<>-00942) THEN
          dbms_output.put_line(SQLERRM);
       END IF;
    ELSE
      dbms_output.put_line('Table Droped');
    END IF;
END;
/

--if no data found in table  result:should not return any row.
DECLARE
    l_employee_id        NUMBER:=999;
    l_empid              NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id = '||l_employee_id||'' INTO l_empid;
EXCEPTION WHEN no_data_found THEN       --if there is no data on the table then we can replace the others by no_data_found.
    --dbms_output.put_line(SQLERRM);
    dbms_output.put_line('no data found');
END;
/
SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=999;

DECLARE
    l_employee_id  NUMBER := 9999;
    l_empid        NUMBER;
    l_sql          VARCHAR2(32767);

BEGIN
    --SELECT employee_id INTO l_empid FROM EMPLOYEES where employee_id =l_empid;
    --dbms_output.put_line(l_empid);

    --EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id ='||l_employee_id||''  INTO l_empid;
    --dbms_output.put_line(l_empid);

    l_sql := 'SELECT employee_id FROM EMPLOYEES where employee_id ='||l_employee_id||'';
    EXECUTE IMMEDIATE l_sql INTO l_empid;
    dbms_output.put_line('l_empid:'||l_empid);
EXCEPTION WHEN  No_Data_Found THEN
    dbms_output.put_line(SQLERRM);
END;
/

DECLARE
    l_employee_id  NUMBER := 9999;
    l_empid        NUMBER;
    l_sql          VARCHAR2(32767);
BEGIN
--    SELECT employee_id INTO l_empid FROM EMPLOYEES where employee_id =l_empid;
--    dbms_output.put_line(l_empid);

--    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id ='||l_employee_id||''  INTO l_empid;
--    dbms_output.put_line(l_empid);

    l_sql := 'SELECT employee_id FROM EMPLOYEES where employee_id ='||l_employee_id||'';
    EXECUTE IMMEDIATE l_sql INTO l_empid;
    dbms_output.put_line(l_empid);
EXCEPTION WHEN  No_Data_Found THEN
--    dbms_output.put_line(SQLERRM);
    IF(SQLCODE=-01403)THEN
      dbms_output.put_line('no data found');
    ELSE
      dbms_output.put_line(SQLERRM);
    END IF;

END;
/


DECLARE
    l_1      VARCHAR2(32767); -- Maximum range (1 to 32767)
BEGIN
    l_1  :=  Upper('a');      -- l_1 variable with data.
    dbms_output.put_line(l_1);
END;
/

DECLARE
    l_1      NUMBER; -- Maximum range (1 to 38) no need to give range
BEGIN
    l_1  :=  1;
    dbms_output.put_line(l_1);
END;
/

DECLARE
    l_1 NUMBER(38,2); -- Float data type declaration
BEGIN
    l_1  :=  1.14;
    dbms_output.put_line(l_1);
END;
/

DECLARE
    l_1        VARCHAR2(100);
BEGIN
    l_1 := '1';
    dbms_output.put_line(l_1);
END;
/

DECLARE
    l_1      VARCHAR2 (100) :='ss6ss'; -- Variable declare with default value.
    l_2      NUMBER := 5;
BEGIN
    dbms_output.put_line(l_1);
    dbms_output.put_line(l_2);
    l_1 := SubStr(l_1,InStr(l_1,6,1),1);
    dbms_output.put_line('l_1:'||l_1);
    dbms_output.put_line('l_1+l_2:'||l_1||'+'||l_2);
END;
/

DECLARE
    l_1      VARCHAR2(100) := '8ssss71';
    l_2      NUMBER        := 7;
    l_3      NUMBER;
    l_4      NUMBER;
BEGIN
    dbms_output.put_line(l_1);
    dbms_output.put_line(l_2);
    dbms_output.put_line(l_3);
    l_3 := 22;
    dbms_output.put_line(l_3);
    l_4 := SubStr(l_1,instr(l_1,l_2,1),1);
    dbms_output.put_line(l_4);
    dbms_output.put_line(l_4+l_3);
    dbms_output.put_line(l_4||'+'||l_3);
END;
/

DECLARE
    l_1        VARCHAR2(10);
    l_2        VARCHAR2 (10);
BEGIN
    SELECT USER INTO l_1 FROM dual;   --USER  is function
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO l_2;
EXCEPTION WHEN OTHERS THEN
	IF(SQLCODE = -00942) THEN
      dbms_output.put_line('Table does not exit');
    ELSE
      dbms_output.put_line(SQLERRM); -- It handels all specific error message
    END IF;
END;
/

DECLARE
    l_1        VARCHAR2(10);
    l_2        VARCHAR2 (10);
BEGIN
    SELECT USER INTO l_1 FROM dual;   --USER  is function
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO l_2;
EXCEPTION WHEN no_data_found THEN
    dbms_output.put_line(SQLERRM); -- It handels specific error message, i.e. - no_data_found
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE T1 AS SELECT * FROM emp';
EXCEPTION WHEN OTHERS THEN
    IF ( SQLCODE = -00942 ) THEN
       dbms_output.put_line(' '); -- Only single space shows
    END IF;
END;
/

-- Nested Anonymous Blocks WITH Variable Declaration And Exception Handler to display arithmetical operation
DECLARE
    l_x NUMBER(4);
BEGIN
    l_x := 1000;
    BEGIN
        l_x := l_x + 100;
    EXCEPTION WHEN OTHERS THEN
        l_x := l_x + 2;
    END;
    l_x := l_x + 10;
    dbms_output.put_line(l_x);
EXCEPTION WHEN OTHERS THEN
    l_x := l_x + 3;
END;
/

-- Declare Variable to Print Using PL/SQL with using EXECUTE IMMEDIATE
DECLARE
    l_message VARCHAR2(20);
BEGIN
    EXECUTE IMMEDIATE 'SELECT ''Print PL/SQL'' FROM dual' INTO l_message;
    dbms_output.put_line(l_message);
END;
/

-- Declare Variable to Print Using PL/SQL with/without using EXECUTE IMMEDIATE
DECLARE
    l_message VARCHAR2(20);
BEGIN
    SELECT 'Print PL/SQL' INTO l_message FROM dual;
    dbms_output.put_line(l_message);
    EXECUTE IMMEDIATE 'SELECT ''Print PL/SQL'' FROM dual' INTO l_message;
    dbms_output.put_line(l_message);
END;
/

-- Display Error Message With Error Code --
DECLARE
    l_message VARCHAR2(20);
BEGIN
    EXECUTE IMMEDIATE 'SELECT col_1 FROM test_table' INTO l_message;
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/

-- Error Handeled using Oracle Error Code --
DECLARE
    l_message VARCHAR2(20);
BEGIN
    EXECUTE IMMEDIATE 'SELECT col_1 FROM test_table' INTO l_message;
EXCEPTION WHEN OTHERS THEN
    IF (SQLCODE = -942) THEN
        dbms_output.put_line('Table or view does not exist');
    END IF;
END;
/

-- Handel the Oracle error with nexted blocks
BEGIN
    BEGIN
        EXECUTE IMMEDIATE'DROP TABLE test_table PURGE';
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE test_table
                           (
                             Col_1 NUMBER(10)
                           )';
        dbms_output.put_line('Table Created');
    END;
END;
/

-- Backup Table Using PL/SQL --
BEGIN
    EXECUTE IMMEDIATE'CREATE TABLE hr.employees_bk AS SELECT * FROM hr.employees';
    dbms_output.put_line('Backup Created Successfully for hr.employees');
EXCEPTION WHEN OTHERS THEN
    IF (SQLCODE = -955) THEN
    dbms_output.put_line('Backup of hr.employees all ready exists');
    END IF;
END;
/
