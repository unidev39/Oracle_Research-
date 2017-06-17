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
    Dbms_Output.Put_Line('Block 1');
    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        Dbms_Output.Put_Line('Block 2');
    END;
    
    BEGIN
        l_message  :=  To_number('abc');         
        dbms_output.put_line(l_message);    
    --EXCEPTION WHEN OTHERS THEN
        --Dbms_Output.Put_Line('Block 3');
    END;

    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        Dbms_Output.Put_Line('Block 4');
    END;

    l_message  :=  To_char('abc');
    Dbms_Output.Put_Line(l_message);
EXCEPTION WHEN OTHERS THEN
    Dbms_Output.Put_Line('Block 1');
END;
/

DECLARE
    l_message      VARCHAR2(100);
BEGIN
    Dbms_Output.Put_Line('Block 1');
    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        Dbms_Output.Put_Line('Block 2');
    END;
    
    BEGIN
        l_message  :=  To_number('abc');         
        dbms_output.put_line(l_message);    
    --EXCEPTION WHEN OTHERS THEN
        --Dbms_Output.Put_Line('Block 3');
    END;

    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        Dbms_Output.Put_Line('Block 4');
    END;

    l_message  :=  To_char('abc');
    Dbms_Output.Put_Line(l_message);
--EXCEPTION WHEN OTHERS THEN
    --Dbms_Output.Put_Line('Block 1');
END;
/

DECLARE
    l_message      VARCHAR2(100) := 'a' ;
BEGIN
    Dbms_Output.Put_Line(l_message);
    l_message := 'b'; 
    Dbms_Output.Put_Line(l_message);
END;
/

/*
a
b
*/

DECLARE
    l_message      VARCHAR2(100) := 'a' ;
BEGIN
    Dbms_Output.Put_Line(l_message);
    DECLARE 
       l_message VARCHAR2(100) := 'b'; 
    BEGIN
        Dbms_Output.Put_Line(l_message);
    END;
    
    Dbms_Output.Put_Line(l_message);
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

-- To convert and check the data in proper formate
--To check weather the given value is number OR not and to use the value for the arihematic operation.
DECLARE
    l_message VARCHAR2(1) := '1';
BEGIN
    l_message  :=  TO_NUMBER(l_message);
    dbms_output.Put_Line(l_message);
END;
/

-- To convert and check the data in proper formate with EXCEPTION handeling
DECLARE
    l_message VARCHAR2(1) := 'A';
BEGIN
    l_message  :=  TO_NUMBER(l_message);
    dbms_output.Put_Line(l_message);
EXCEPTION WHEN OTHERS THEN
    Dbms_Output.Put_Line(SQLERRM);
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
       Dbms_Output.Put_Line('Pass: '||l_message);
    END IF;
END;
/

DECLARE
    l_message   VARCHAR2(1) := 'A';
BEGIN
    IF (l_message = 'A'  OR l_message = 'B') THEN
       Dbms_Output.Put_Line('Pass: '||l_message);
    ELSE
       Dbms_Output.Put_Line('Fail: '||l_message);
    END IF;
END;
/

-- If Condition using operators
DECLARE
    l_message   VARCHAR2(1) := 'A';
BEGIN
    IF (l_message = 'A'  AND  l_message = 'B') THEN
       Dbms_Output.Put_Line('Pass: '||l_message);
    ELSIF (l_message = 'B') THEN
       Dbms_Output.Put_Line('Pass: '||l_message);
    ELSE
       Dbms_Output.Put_Line('Fail: '||l_message);
    END IF;
END;
/

-- If Condition using operators uder nested blocks
DECLARE
    p_number_1      NUMBER := 1;
    p_number_2      NUMBER := 3;
BEGIN
    IF ( p_number_1 = 1  AND  p_number_2 = 2 ) THEN
       dbms_output.put_line('Pass :'||p_number_1||','||p_number_2);
    ELSE
       BEGIN
           p_number_1:=10;
           dbms_output.put_line(p_number_1);
       END;
    END IF;
END;
/

-- USER is a function, which show where you as in
DECLARE
    l_user      VARCHAR2(10);
BEGIN
    SELECT USER INTO l_user FROM dual;
    dbms_output.put_line('l_user: '||l_user);
END;
/

-- Dynamic Operation
DECLARE
    g_sql    VARCHAR2(2000);
    l_col_1  NUMBER (20) := 10;
BEGIN
    g_sql := 'INSERT INTO test_table (Col_1) VALUES('||l_col_1||')';
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
        Dbms_Output.Put_Line(SQLERRM);
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE t1
                       (
                         col_1 VARCHAR2(10)
                       )';

    EXECUTE IMMEDIATE 'SELECT col_1 FROM t1' INTO l_message;
EXCEPTION WHEN No_Data_Found THEN
    Dbms_Output.Put_Line(SQLERRM);
END;
/

-- to handel the syntax error or table or view does not exit.
DECLARE
      vblTableName    VARCHAR2(30):='aaa';
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE '||vblTableName||'';
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942) THEN
      Dbms_Output.Put_Line('Table or view does not exit');
    ELSIF(SQLCODE<>-00942) THEN
      Dbms_Output.Put_Line(SQLERRM);
    ELSE
      Dbms_Output.Put_Line('Table Droped');
    END IF;
END;
/

-- to handel the syntax error or table or view does not exit.(Alternative)
DECLARE
      vblTableName    VARCHAR2(30):='aaa';
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE '||vblTableName||'';
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942 OR SQLCODE<>-00942) THEN
       IF(SQLCODE=-00942) THEN
          Dbms_Output.Put_Line('Table or view does not exit');
       ELSIF(SQLCODE<>-00942) THEN
          Dbms_Output.Put_Line(SQLERRM);
       END IF;
    ELSE
      Dbms_Output.Put_Line('Table Droped');
    END IF;
END;
/
-- to handel the syntax error or table or view does not exit.(Alternative)
DECLARE
      vblTableName    VARCHAR2(30):='aaa';
      vblDrop         VARCHAR2(32767);
BEGIN
    vblDrop:='DROP TABLE '||vblTableName||'';
    EXECUTE IMMEDIATE vblDrop;
EXCEPTION WHEN OTHERS THEN
    IF(SQLCODE=-00942 OR SQLCODE<>-00942) THEN
       IF(SQLCODE=-00942) THEN
          Dbms_Output.Put_Line('Table or view does not exit');
       ELSIF(SQLCODE<>-00942) THEN
          Dbms_Output.Put_Line(SQLERRM);
       END IF;
    ELSE
      Dbms_Output.Put_Line('Table Droped');
    END IF;
END;
/

--if no data found in table  result:should not return any row.
DECLARE
    vblemployee_id        NUMBER:=999;
    vblempid              NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id = '||vblemployee_id||'' INTO vblempid;
EXCEPTION WHEN no_data_found THEN       --if there is no data on the table then we can replace the others by no_data_found.
    --Dbms_Output.Put_Line(SQLERRM);
    Dbms_Output.Put_Line('no data found');
END;
/
SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=999;

DECLARE
    vblemployee_id        NUMBER:=999;
    vblempid              NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id = '||vblemployee_id||'' INTO vblempid;
EXCEPTION WHEN no_data_found THEN       --if there is no data on the table then we can replace the others by no_data_found.
    --Dbms_Output.Put_Line(SQLERRM);
    Dbms_Output.Put_Line('no data found');
END;
/

DECLARE
    vblemployee_id  NUMBER := 9999;
    vblempid        NUMBER;
    vblsql          VARCHAR2(32767);

BEGIN
--    SELECT employee_id INTO vblempid FROM EMPLOYEES where employee_id =vblempid;
--    Dbms_Output.Put_Line(vblempid);

--    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id ='||vblemployee_id||''  INTO vblempid;
--    Dbms_Output.Put_Line(vblempid);

    vblsql := 'SELECT employee_id FROM EMPLOYEES where employee_id ='||vblemployee_id||'';
    EXECUTE IMMEDIATE vblsql INTO vblempid;
    Dbms_Output.Put_Line('VBLEMPID:'||vblempid);
EXCEPTION WHEN  No_Data_Found THEN
    Dbms_Output.Put_Line(SQLERRM);
END;
/

DECLARE
    vblemployee_id  NUMBER := 9999;
    vblempid        NUMBER;
    vblsql          VARCHAR2(32767);

BEGIN
--    SELECT employee_id INTO vblempid FROM EMPLOYEES where employee_id =vblempid;
--    Dbms_Output.Put_Line(vblempid);

--    EXECUTE IMMEDIATE 'SELECT employee_id FROM EMPLOYEES where employee_id ='||vblemployee_id||''  INTO vblempid;
--    Dbms_Output.Put_Line(vblempid);

    vblsql := 'SELECT employee_id FROM EMPLOYEES where employee_id ='||vblemployee_id||'';
    EXECUTE IMMEDIATE vblsql INTO vblempid;
    Dbms_Output.Put_Line(vblempid);
EXCEPTION WHEN  No_Data_Found THEN
--    Dbms_Output.Put_Line(SQLERRM);
    IF(SQLCODE=-01403)THEN
      Dbms_Output.Put_Line('no data found');
    ELSE
      Dbms_Output.Put_Line(SQLERRM);
    END IF;

END;
/

DECLARE
    sys_date2 DATE;
    sys_date3 DATE;
    sys_date4 DATE;
    vblSql    VARCHAR2(32767);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE SysTime';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    vblSql := 'CREATE TABLE SysTime
               (
                 sys_time VARCHAR2(100)
               )NOLOGGING';
    EXECUTE IMMEDIATE(vblSql);

    BEGIN
        FOR i IN 0..12
        LOOP
           EXECUTE IMMEDIATE 'INSERT INTO SysTime (sys_time) VALUES('''||i||':'||i||':'||i||''')';
           COMMIT;
           BEGIN
               FOR j IN 0..60
               loop
                  EXECUTE IMMEDIATE 'INSERT INTO SysTime (sys_time) VALUES('''||i||':'||j||':'||j||''')';
                  COMMIT;
                  BEGIN
                      FOR k IN 0..60
                      LOOP
                         EXECUTE IMMEDIATE 'INSERT INTO SysTime (sys_time) VALUES('''||i||':'||j||':'||k||''')';
                         COMMIT;
                      END LOOP;
                  END;
               END LOOP;
           END;
           COMMIT;
        END LOOP;
    END;
END;
/


DECLARE
    v1      VARCHAR2(32767); -- Maximum range (1 to 32767)
BEGIN
    v1  :=  Upper('a');      -- V1 variable with data.
    Dbms_Output.Put_Line(v1);
END;
/

DECLARE
    v1      NUMBER; -- Maximum range (1 to 38) no need to give range
BEGIN
    v1  :=  1;
    Dbms_Output.Put_Line(v1);
END;
/

DECLARE
    v1 NUMBER(38,2); -- Float data type declaration
BEGIN
    v1  :=  1.14;
    Dbms_Output.Put_Line(v1);
END;
/

DECLARE
    v1        VARCHAR2(100);
BEGIN
    v1 := '1';
    Dbms_Output.Put_Line(v1);
END;
/

DECLARE
    v1      VARCHAR2 (100) :='ss6ss'; -- Variable declare with default value.
    v2      NUMBER := 5;
BEGIN
    Dbms_Output.Put_Line(v1);
    Dbms_Output.Put_Line(v2);
    v1 := SubStr(v1,InStr(v1,6,1),1);
    Dbms_Output.Put_Line('v1:'||v1);
    Dbms_Output.Put_Line('v1+v2:'||v1||'+'||v2);
END;
/

DECLARE
    v1      VARCHAR2(100) := '8ssss71';
    v2      NUMBER        := 7;
    v3      NUMBER;
    v4      NUMBER;
BEGIN
    Dbms_Output.Put_Line(v1);
    Dbms_Output.Put_Line(v2);
    Dbms_Output.Put_Line(v3);
    v3 := 22;
    Dbms_Output.Put_Line(v3);
    v4 := SubStr(v1,instr(v1,v2,1),1);
    Dbms_Output.Put_Line(v4);
    Dbms_Output.Put_Line(v4+v3);
    Dbms_Output.Put_Line(v4||'+'||v3);
END;
/

-- If Condition
DECLARE
    v1      NUMBER := 1;
BEGIN
    IF ( v1 = 1  OR v1 = 2) THEN
       Dbms_Output.Put_Line('pass');
    ELSE
       Dbms_Output.Put_Line('fail');
    END IF;
END;
/

DECLARE
    v1      NUMBER := 1;
BEGIN
    IF ( v1 = 1  AND  v1 = 2) THEN
       Dbms_Output.Put_Line('pass');
    ELSE
       Dbms_Output.Put_Line('fail');
    END IF;
END;
/

DECLARE
    v1      NUMBER := 1;
    v2      NUMBER := 3;
BEGIN
    IF ( v1 = 1  AND  v1 = 2) THEN
       Dbms_Output.Put_Line('pass');
    ELSIF (v1 = 1) THEN
       Dbms_Output.Put_Line('pass1');
    ELSE
       Dbms_Output.Put_Line('fail');
    END IF;
END;
/

DECLARE
    v1      NUMBER := 1;
    v2      NUMBER := 3;
BEGIN
    IF ( v1 = 1  AND  v2 = 2 ) THEN
       Dbms_Output.Put_Line('pass');
    ELSE
       BEGIN
           v1:=10;
           Dbms_Output.Put_Line(v1);
       END;
    END IF;

END;
/

DECLARE
    v1      VARCHAR2(10);
BEGIN
    SELECT USER INTO v1 FROM dual;   -- USER is a function, which show where you as in
    Dbms_Output.Put_Line(v1);
END;
/

DECLARE
    v1      VARCHAR2(10);
BEGIN
    SELECT USER INTO v1 FROM dual;   -- it shows how the data assign in a variable 
    Dbms_Output.Put_Line(v1);
END;
/

--not equal to sign are <> != ^=
DECLARE
    v1      VARCHAR2(10);
BEGIN
    SELECT USER INTO v1 FROM dual;
    Dbms_Output.Put_Line(v1);
    IF ( v1 <> 'A' ) THEN
       Dbms_Output.Put_Line('not valid user');
    END IF;
END;
/

DECLARE
    v1     VARCHAR2(10);
    v2     VARCHAR2 (10);
BEGIN
    SELECT USER INTO v1 FROM dual;
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2; -- it shows how the data assign in a variable - ( with EXECUTE IMMEDIATE). 
    Dbms_Output.Put_Line(v1||v2);
END;
/


DECLARE
    v1       VARCHAR2(10);
    v2       VARCHAR2 (10);
BEGIN
    SELECT USER INTO v1 FROM dual;
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2;
    Dbms_Output.Put_Line(v1||v2);
EXCEPTION WHEN OTHERS THEN  -- Exception handeling
    Dbms_Output.Put_Line('fail');
END;
/

DECLARE
    v1        VARCHAR2(10);
    v2        VARCHAR2 (10);
BEGIN
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2;
    Dbms_Output.Put_Line(v1||v2);
EXCEPTION WHEN OTHERS THEN
    NULL;               -- It shows that if error occured then does't display
END;
/

DECLARE
    v2        VARCHAR2 (10);
BEGIN
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2;
EXCEPTION WHEN OTHERS THEN
    -- It handels only for specific error code
	IF(SQLCODE = -00942) THEN
       Dbms_Output.Put_Line('table does not exit ');
    END IF;
END;
/

DECLARE
    v1        VARCHAR2(10);
    v2        VARCHAR2 (10);
BEGIN
    SELECT USER INTO v1 FROM dual;   --USER  is function
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2;
EXCEPTION WHEN OTHERS THEN
	IF(SQLCODE = -00942) THEN
      Dbms_Output.Put_Line('Table does not exit');
    ELSE
      Dbms_Output.Put_Line(SQLERRM); -- It handels all specific error message
    END IF;
END;
/

DECLARE
    v1        VARCHAR2(10);
    v2        VARCHAR2 (10);
BEGIN
    SELECT USER INTO v1 FROM dual;   --USER  is function
    EXECUTE IMMEDIATE 'SELECT EMPLOYEE_ID FROM EMP' INTO V2;
EXCEPTION WHEN no_data_found THEN
    Dbms_Output.Put_Line(SQLERRM); -- It handels specific error message, i.e. - no_data_found
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE T1 AS SELECT * FROM emp';
EXCEPTION WHEN OTHERS THEN
    IF ( SQLCODE = -00942 ) THEN
       Dbms_Output.Put_Line(' '); -- Only single space shows
    END IF;
END;
/

-- implict loop
DECLARE
    v1 VARCHAR2(100);
    v2 VARCHAR2(100);
BEGIN
    SELECT
        employee_id,
        salary
    INTO
        v1,
        v2
    FROM
        employees
    WHERE
        ROWNUM<=1;
    
	Dbms_Output.Put_Line(v1);
    Dbms_Output.Put_Line(v2);
    Dbms_Output.Put_Line(v1||'+'||v2);

    FOR i IN 1..10 -- i - is defind or not defind in declare part (Choise is yours)
    LOOP
        Dbms_Output.Put_Line(v1||'   '||v2);
    END LOOP;

END;
/

DECLARE
    v1          VARCHAR2(100);
    v2          VARCHAR2(100);
BEGIN
    FOR i IN (SELECT salary FROM employees)
    LOOP
       Dbms_Output.Put_Line(i.salary);
    END LOOP;
END;
/

DECLARE
    v1          VARCHAR2(100);
    v2          VARCHAR2(100);
BEGIN
    FOR i IN (SELECT salary FROM employees)
    LOOP
       Dbms_Output.Put_Line(i.salary*10);
    END LOOP;
END;
/

DECLARE
    v1          VARCHAR2(100);
    v2          VARCHAR2(100);
BEGIN
    FOR i IN (SELECT 10*salary AS sal FROM employees)
    LOOP
       Dbms_Output.Put_Line(i.sal);
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..5    -- to print 5 times the same value
    LOOP
       Dbms_Output.Put_Line(i);
    END LOOP;
END;
/

-- Nested loop
DECLARE
    v1          VARCHAR2(100);
    v2          VARCHAR2(100);
BEGIN
    FOR j IN 1..5    -- to print 5 times the same value
    LOOP
       FOR i IN (SELECT salary FROM employees)
       LOOP
          Dbms_Output.Put_Line(i.salary);
       END LOOP;
    END LOOP;
END;
/




-- Block declares a variable of type VARCHAR2(1..32767)
DECLARE
    l_message  VARCHAR2(20) := 'Print PL/SQL';
BEGIN
    dbms_output.put_line(l_message);
END;
/

-- Nested Anonymous Blocks WITH Variable Declaration And Exception Handler
DECLARE
     <variable name> <data type><(LENGTH PRECISION)>;
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

-- The following example block demonstrates the PL/SQL ability to nest blocks within blocks as well as the use of the concatenation operator (||) to join together multiple strings.
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

-- Declare Variable to Print Using PL/SQL without using EXECUTE IMMEDIATE
DECLARE
    l_message VARCHAR2(20);
BEGIN
    SELECT 'Print PL/SQL' INTO l_message FROM dual;
    Dbms_Output.put_line(l_message);
END;
/

-- Declare Variable to Print Using PL/SQL with using EXECUTE IMMEDIATE
DECLARE
    l_message VARCHAR2(20);
BEGIN
    EXECUTE IMMEDIATE 'SELECT ''Print PL/SQL'' FROM dual' INTO l_message;
    Dbms_Output.put_line(l_message);
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
        dbms_output.Put_Line(SQLERRM);
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

SELECT * FROM SysTime;

DECLARE
    sys_date2 DATE;
    sys_date3 DATE;
    sys_date4 DATE;
    vblSql    VARCHAR2(32767);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE SysDate1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    vblSql := 'CREATE TABLE SysDate1
               (
                 sys_date DATE
               )NOLOGGING';
    EXECUTE IMMEDIATE(vblSql);

    BEGIN
        EXECUTE IMMEDIATE 'INSERT INTO SysDate1(SYS_DATE) VALUES(to_date(sysdate,''dd-mon-yy''))';
        FOR i IN 1..12
        LOOP
           BEGIN
               sys_date2 := '';
               sys_date3 := '';
               FOR K IN 1..30
               LOOP
               BEGIN
                   IF (to_char(sysdate,'dd') <> 30) then
                         BEGIN
                             SELECT to_char(sysdate,'dd')+K||'-'||to_char(sysdate,'MON-yy') INTO sys_date3 FROM dual;
                             Dbms_Output.PUT_LINE(sys_date3);
                             EXECUTE IMMEDIATE 'INSERT INTO SysDate1(SYS_DATE) VALUES(to_date('''||sys_date3||''',''dd-mon-yy''))';
                         EXCEPTION WHEN OTHERS THEN
                             NULL;
                         END;
                      END IF;
               END;
               END LOOP;
               SELECT Add_Months(SYSDATE,i) INTO sys_date2 FROM dual;
               Dbms_Output.PUT_LINE(sys_date2);
               EXECUTE IMMEDIATE 'INSERT INTO SysDate1(SYS_DATE) VALUES(to_date('''||sys_date2||''',''dd-mon-yy''))';

               BEGIN
                   FOR j IN 1..30
                   LOOP
                         BEGIN
                             SELECT j||'-'||to_char(sys_date2,'MON-yy') INTO sys_date4 FROM dual;
                             Dbms_Output.PUT_LINE(sys_date4);
                             EXECUTE IMMEDIATE 'INSERT INTO SysDate1(SYS_DATE) VALUES(to_date('''||sys_date4||''',''dd-mon-yy''))';
                         EXCEPTION WHEN OTHERS THEN
                             NULL;
                         END;
                   END LOOP;
               END;
               COMMIT;
           END;
        END LOOP;
    END;
END;
/
