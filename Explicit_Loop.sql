1.
Oracle/PLSQL: CURSOR FOR Loop
This Oracle tutorial explains how to use the CURSOR FOR LOOP in Oracle with syntax and examples.

Description
You would use a CURSOR FOR LOOP when you want to fetch and process every record in a cursor. The CURSOR FOR LOOP will terminate when all 
of the records in the cursor have been fetched.

Syntax
The syntax for the CURSOR FOR LOOP in Oracle/PLSQL is:

FOR record_index in cursor_name
LOOP
   {...statements...}
END LOOP;

Parameters or Arguments
	*record_index
		**The index of the record.
	*cursor_name
		**The l_name of the cursor that you wish to fetch records from.
	*statements
		**The statements of code to execute each pass through the CURSOR FOR LOOP.
Example:
In this example, we have created a cursor called cursor_c. The CURSOR FOR Loop will terminate after all records have been fetched from the cursor cursor_c.

DECLARE
    CURSOR cursor_c IS SELECT employee_id FROM employees;
BEGIN
    FOR cur_rec IN cursor_c
    LOOP
       NULL;
    END LOOP;
END;
/

DECLARE 
   l_total_val number(6);
   CURSOR cursor_c IS SELECT salary FROM employees ;
BEGIN
   l_total_val := 0;
   FOR employee_rec in cursor_c
   LOOP
      l_total_val := l_total_val + employee_rec.salary;
   END LOOP;
   dbms_output.put_line(l_total_val);
END;
/

Passing Parameters to a Cursor FOR Loop
displays the wages paid to employees earning over a specified wage in a specified department.
Example:

DECLARE
    CURSOR cursor_c (job VARCHAR2, max_wage NUMBER) IS SELECT * FROM employees WHERE job_id = job AND salary = max_wage;
BEGIN
  FOR person IN cursor_c('IT_PROG',4200)
  LOOP
     -- process data record
    dbms_output.put_line('l_name = '||person.last_name||', salary = '||person.salary||', Job Id = '||person.job_id);
  END LOOP;
END;
/

DECLARE
    CURSOR cursor_c (job VARCHAR2,sal NUMBER) IS SELECT job_id,salary FROM employees WHERE job_id = job;
    l_job employees.job_id%TYPE;
    l_sal employees.salary%TYPE;
BEGIN
  OPEN cursor_c('IT_PROG',555);
  LOOP
     FETCH cursor_c INTO l_job,l_sal;
     EXIT WHEN cursor_c%NOTFOUND;
     Dbms_Output.Put_Line(l_job||' , '||l_sal);
  END LOOP;
END;
/

DECLARE
    CURSOR cursor_c (job VARCHAR2 := 'IT_PROG',sal NUMBER := 9000) IS SELECT job_id,salary FROM employees WHERE job_id = job AND salary = sal;
    l_job employees.job_id%TYPE;
    l_sal employees.salary%TYPE;
BEGIN
  OPEN cursor_c;
  LOOP
     FETCH cursor_c INTO l_job,l_sal;
     EXIT WHEN cursor_c%NOTFOUND;
     Dbms_Output.Put_Line(l_job||' , '||l_sal);
  END LOOP;
  CLOSE cursor_c;
END;
/

DECLARE
    CURSOR cursor_c (hire_date_1 DATE ) IS SELECT * FROM employees WHERE hire_date = hire_date_1;
BEGIN
  FOR person IN cursor_c(To_Date('21.06.2007','dd.mm.yyyy'))
  LOOP
     -- process data record
    dbms_output.put_line('l_name = '||person.last_name||', salary = '||person.salary||', Job Id = '||person.job_id);
  END LOOP;
END;
/

SELECT * FROM employees WHERE hire_date =  To_Date('21.06.2007','dd.mm.yyyy');


2.
Oracle/PLSQL: Cursors
In Oracle, a cursor is a mechanism by which you can assign a l_name to a SELECT statement and manipulate the information within that SQL statement.
The following is a list of topics that explain how to use Cursors in Oracle/PLSQL:

Create Cursor
	*Declare a Cursor
	*OPEN Statement
	*FETCH Statement
	*CLOSE Statement
	*Cursor Attributes (%FOUND, %NOTFOUND, etc)
	*SELECT FOR UPDATE Statement
	*WHERE CURRENT OF Statement

2.1	
Oracle/PLSQL: Declare a Cursor
This Oracle tutorial explains how to declare a cursor in Oracle/PLSQL with syntax and examples.

Description
A cursor is a SELECT statement that is defined within the declaration section of your PLSQL code. We will take a look at three different syntaxes to 
declare a cursor.

Cursor without parameters (simplest)
Declaring a cursor without any parameters is the simplest cursor. Let''s take a closer look.

Syntax
The syntax for a cursor without parameters in Oracle/PLSQL is:

CURSOR cursor_name
IS
  SELECT_statement;

Example:
For example, you could define a cursor called cursor_c as below.

CURSOR cursor_c IS SELECT course_number FROM courses_tbl WHERE course_name = l_name_in;

The result set of this cursor is all course_numbers whose course_name matches the variable called l_name_in.

Below is a function that uses this cursor.

DECLARE
    l_name_in   VARCHAR2(30) := 50;
    l_cnumber   NUMBER;
    CURSOR cursor_c IS SELECT salary FROM employees WHERE department_id = l_name_in;
BEGIN
	OPEN cursor_c;
	FETCH cursor_c INTO l_cnumber;
    dbms_output.put_line('Input Data : '||l_cnumber);	
	IF cursor_c%notfound THEN
		l_cnumber := 9999;
	end IF;
	CLOSE cursor_c;
  dbms_output.put_line('Out Put Data : '||l_cnumber);
END;
/

SELECT salary,first_name FROM employees WHERE department_id =50

2.2
Oracle/PLSQL: OPEN Statement
This Oracle tutorial explains how to use the Oracle/PLSQL OPEN statement with syntax and examples.

Description
Once you have declared your cursor, the next step is to use the OPEN statement to open the cursor.

Syntax
The syntax to open a cursor using the OPEN statement in Oracle/PLSQL is:

OPEN cursor_name;

2.3
Oracle/PLSQL: FETCH Statement
This Oracle tutorial explains how to use the Oracle/PLSQL FETCH statement with syntax and examples.

Description
The purpose of using a cursor, in most cases, is to retrieve the rows from your cursor so that some type of operation can be performed on the data. After declaring and opening your cursor, the next step is to use the FETCH statement to fetch rows from your cursor.

Syntax
The syntax for the FETCH statement in Oracle/PLSQL is:

FETCH cursor_name INTO variable_list;

2.4
Oracle/PLSQL: CLOSE Statement
This Oracle tutorial explains how to use the Oracle/PLSQL CLOSE statement with syntax and examples.

Description
The final step of working with cursors is to close the cursor once you have finished using it.

Syntax
The syntax to close a cursor in Oracle/PLSQL using the CLOSE statement is:

CLOSE cursor_name;

2.5
Oracle/PLSQL: Cursor Attributes
While dealing with cursors, you may need to determine the status of your cursor. The following is a list of the cursor attributes that you can use.
Attribute   => %ISOPEN
Explanation => Returns TRUE if the cursor is open, FALSE if the cursor is closed.

Attribute   => %FOUND
Explanation => *Returns INVALID_CURSOR if cursor is declared, but not open; or if cursor has been closed.
			   *Returns NULL if cursor is open, but fetch has not been executed.
			   *Returns TRUE if a successful fetch has been executed.
			   *Returns FALSE if no row was returned.

Attribute   => %NOTFOUND
Explanation => *Returns INVALID_CURSOR if cursor is declared, but not open; or if cursor has been closed.
			   *Return NULL if cursor is open, but fetch has not been executed.
			   *Returns FALSE if a successful fetch has been executed.
			   *Returns TRUE if no row was returned.

Attribute   => %ROWCOUNT
Explanation => *Returns INVALID_CURSOR if cursor is declared, but not open; or if cursor has been closed.
			   *Returns the number of rows fetched.
			   *The ROWCOUNT attribute does not give the real row count until you have iterated through the entire cursor. In other words, 
			    you should not rely on this attribute to tell you how many rows are in a cursor after it is opened.

2.6
Oracle/PLSQL: SELECT FOR UPDATE Statement
This Oracle tutorial explains how to use the Oracle/PLSQL SELECT FOR UPDATE statement with syntax and examples.

Description
The SELECT FOR UPDATE statement allows you to lock the records in the cursor result set. You are not required to make changes to the records in order to use this statement. The record locks are released when the next commit or rollback statement is issued.

Syntax
The syntax for the SELECT FOR UPDATE statement in Oracle/PLSQL is:

CURSOR cursor_name
IS
   select_statement
   FOR UPDATE [OF column_list] [NOWAIT];

Parameters or Arguments
*cursor_name : The l_name of the cursor.
*select_statement : A SELECT statement that will populate your cursor result set.
*column_list : The columns in the cursor result set that you wish to update.
*NOWAIT : Optional. The cursor does not wait for resources.

Example
For example, you could use the SELECT FOR UPDATE statement as follows:

CURSOR cursor_c
IS
SELECT course_number, instructor
FROM courses_tbl
FOR UPDATE OF instructor;

2.7
Oracle/PLSQL: WHERE CURRENT OF Statement
This Oracle tutorial explains how to use the Oracle/PLSQL WHERE CURRENT OF statement with syntax and examples.

Description
If you plan on updating or deleting records that have been referenced by a SELECT FOR UPDATE statement, you can use the WHERE CURRENT OF statement.

Syntax
The syntax for the WHERE CURRENT OF statement in Oracle/PLSQL is either:

UPDATE table_name
SET set_clause
WHERE CURRENT OF cursor_name;
OR
DELETE FROM table_name
WHERE CURRENT OF cursor_name;

Note : The WHERE CURRENT OF statement allows you to update or delete the record that was last fetched by the cursor.
Example
Updating using the WHERE CURRENT OF Statement

Here is an example where we are updating records using the WHERE CURRENT OF Statement:

SELECT salary,first_name FROM employees WHERE department_id =50 FOR UPDATE of first_name;

DECLARE
    l_name_in   VARCHAR2(30) := 50;
    l_cnumber   NUMBER;
    CURSOR cursor_c IS SELECT salary FROM employees WHERE department_id = l_name_in FOR UPDATE of first_name;
BEGIN
   OPEN cursor_c;
   FETCH cursor_c INTO l_cnumber;
   IF cursor_c%notfound THEN
      l_cnumber := 9999;
   ELSE
      UPDATE employees
      SET first_name = 'Do'
      WHERE CURRENT OF cursor_c;
      --COMMIT;
   END IF;
   CLOSE cursor_c;
   dbms_output.put_line('Out Put Data : '||l_cnumber);
END;
/

Deleting using the WHERE CURRENT OF Statement
Here is an example where we are deleting records using the WHERE CURRENT OF Statement:

DECLARE
    l_name_in   VARCHAR2(30) := 50;
    l_cnumber   NUMBER;
    CURSOR cursor_c IS SELECT salary FROM employees WHERE department_id = l_name_in FOR UPDATE of first_name;
BEGIN
   OPEN cursor_c;
   FETCH cursor_c INTO l_cnumber;
   IF cursor_c%notfound THEN
      l_cnumber := 9999;
   ELSE
      DELETE FROM employees 
      WHERE CURRENT OF cursor_c;
      --COMMIT;
   END IF;
   CLOSE cursor_c;
   dbms_output.put_line('Out Put Data : '||l_cnumber);
END;
/

3.1
%FOUND Attribute: Has a Row Been Fetched?
After a cursor or cursor variable is opened but before the first fetch, %FOUND returns NULL. After any fetches, it returns TRUE if the last fetch returned a row, or FALSE if the last fetch did not return a row. Example 6-14 uses %FOUND to select an action.

Example:

DECLARE
    CURSOR cursor_c IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    l_my_ename  employees.last_name%TYPE;
    l_my_salary employees.salary%TYPE;
BEGIN
    OPEN cursor_c;
    LOOP
      FETCH cursor_c INTO l_my_ename, l_my_salary;
      IF cursor_c%FOUND THEN  -- fetch succeeded
        dbms_output.put_line('l_name = ' || l_my_ename || ', salary = ' || l_my_salary);
      ELSE  -- fetch failed, so exit loop
        EXIT;
      END IF;
    END LOOP;
END;
/

4.1
%ISOPEN Attribute: Is the Cursor Open?
%ISOPEN returns TRUE if its cursor or cursor variable is open; otherwise, %ISOPEN returns FALSE. Example 6-15 uses %ISOPEN to select an action.

Example:

DECLARE
    CURSOR cursor_c  IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    l_the_name   employees.last_name%TYPE;
    l_the_salary employees.salary%TYPE;
BEGIN
   IF cursor_c%ISOPEN = FALSE THEN  -- cursor was not already open
      OPEN cursor_c;
   END IF;
   FETCH cursor_c INTO l_the_name, l_the_salary;
   CLOSE cursor_c;
END;
/

5.1
%NOTFOUND Attribute: Has a Fetch Failed?
%NOTFOUND is the logical opposite of %FOUND. %NOTFOUND yields FALSE if the last fetch returned a row, or TRUE if the last fetch failed to return a row. In Example 6-16, you use %NOTFOUND to exit a loop when FETCH fails to return a row.

Example:

DECLARE
    CURSOR cursor_c IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    l_my_ename  employees.last_name%TYPE;
    l_my_salary employees.salary%TYPE;
BEGIN
    OPEN cursor_c;
    LOOP
       FETCH cursor_c INTO l_my_ename, l_my_salary;
       IF cursor_c%NOTFOUND THEN -- fetch failed, so exit loop
       -- Another form of this test is
       -- "EXIT WHEN cursor_c%NOTFOUND OR cursor_c%NOTFOUND IS NULL;"
         EXIT;
      ELSE   -- fetch succeeded
         dbms_output.put_line('l_name = ' || l_my_ename || ', salary = ' || l_my_salary);
      END IF;
     END LOOP;
END;
/

6.1
%ROWCOUNT Attribute: How Many Rows Fetched So Far?
When its cursor or cursor variable is opened, %ROWCOUNT is zeroed. Before the first fetch, %ROWCOUNT yields zero. Thereafter, it yields the number of rows fetched so far. The number is incremented if the last fetch returned a row. Example 6-17 uses %ROWCOUNT to test if more than ten rows were fetched.

Example:

DECLARE
    CURSOR cursor_c IS SELECT last_name FROM employees WHERE ROWNUM < 11;
    l_name employees.last_name%TYPE;
BEGIN
    OPEN cursor_c;
    LOOP
       FETCH cursor_c INTO l_name;
       EXIT WHEN cursor_c%NOTFOUND OR cursor_c%NOTFOUND IS NULL;
       dbms_output.put_line(cursor_c%ROWCOUNT || '. ' || l_name);
       IF cursor_c%ROWCOUNT = 5 THEN
          dbms_output.put_line('--- Fetched 5th record ---');
       END IF;
    END LOOP;
    CLOSE cursor_c;
END;
/

7.1
Cursor with other cursor
DECLARE
    l_jobid     employees.job_id%TYPE;     -- variable for job_id
    l_lastname  employees.last_name%TYPE;  -- variable for last_name
    CURSOR cursor_c IS SELECT last_name, job_id FROM employees WHERE REGEXP_LIKE (job_id, 'S[HT]_CLERK');
    l_employees employees%ROWTYPE;         -- record variable for row
    CURSOR cursor_c2 is SELECT * FROM employees WHERE REGEXP_LIKE (job_id, '[ACADFIMKSA]_M[ANGR]');
BEGIN
    OPEN cursor_c; -- open the cursor before fetching
    LOOP
      -- Fetches 2 columns into variables
      FETCH cursor_c INTO l_lastname, l_jobid;
      EXIT WHEN cursor_c%NOTFOUND;
      dbms_output.put_line( RPAD(l_lastname, 25, ' ') || l_jobid );
    END LOOP;
    CLOSE cursor_c;
    dbms_output.put_line( '-------------------------------------' );
    OPEN cursor_c2;
    LOOP
      -- Fetches entire row into the l_employees record
      FETCH cursor_c2 INTO l_employees;
      EXIT WHEN cursor_c2%NOTFOUND;
      dbms_output.put_line( RPAD(l_employees.last_name, 25, ' ') || l_employees.job_id );
    END LOOP;
    CLOSE cursor_c2;
END;
/

8.1
Referencing PL/SQL Variables Within Its Scope
The query can reference PL/SQL variables within its scope. Any variables in the query are evaluated only when the cursor is opened. 
In Example, each retrieved salary is multiplied by 2, even though l_factor is incremented after every fetch.
Example:

DECLARE
    l_my_sal employees.salary%TYPE;
    l_my_job employees.job_id%TYPE;
    l_factor INTEGER := 2;
    CURSOR cursor_c IS SELECT l_factor*salary FROM employees WHERE job_id = l_my_job;
BEGIN
   OPEN cursor_c;  -- l_factor initially equals 2
   LOOP
      FETCH cursor_c INTO l_my_sal;
      EXIT WHEN cursor_c%NOTFOUND;
      l_factor := l_factor + 1;  -- does not affect FETCH
   END LOOP;
   CLOSE cursor_c;
END;
/

9.1
Fetching the Same Cursor Into Different Variables.
To change the result set or the values of variables in the query, you must close and reopen the cursor with the input variables set to their new values. 
However, you can use a different INTO list on separate fetches with the same cursor. Each fetch retrieves another row and assigns values to the target 
variables, as shown in Example
Example:

DECLARE
    CURSOR cursor_c IS SELECT last_name FROM employees ORDER BY last_name;
    l_name1 employees.last_name%TYPE;
    l_name2 employees.last_name%TYPE;
    l_name3 employees.last_name%TYPE;
BEGIN
    OPEN cursor_c;
    FETCH cursor_c INTO l_name1;  -- this fetches first row
    FETCH cursor_c INTO l_name2;  -- this fetches second row
    FETCH cursor_c INTO l_name3;  -- this fetches third row
    CLOSE cursor_c;
    Dbms_Output.Put_Line(l_name1);
    Dbms_Output.Put_Line(l_name2);
    Dbms_Output.Put_Line(l_name3);
END;
/

10.1
Passing Parameters to Explicit Cursors
In Example several ways are shown to open a cursor.
Example:

DECLARE
    l_emp_job      employees.job_id%TYPE := 'ST_CLERK';
    l_emp_salary   employees.salary%TYPE := 3000;
    l_my_record    employees%ROWTYPE;
    CURSOR cursor_c (job VARCHAR2, max_wage NUMBER) IS SELECT * FROM employees WHERE job_id = job AND salary > max_wage;
BEGIN
    -- Any of the following statements opens the cursor:
    -- OPEN cursor_c('ST_CLERK', 3000); OPEN cursor_c('ST_CLERK', l_emp_salary);
    -- OPEN cursor_c(l_emp_job, 3000); OPEN cursor_c(l_emp_job, l_emp_salary);
    OPEN cursor_c(l_emp_job, l_emp_salary);
    LOOP
       FETCH cursor_c INTO l_my_record;
       EXIT WHEN cursor_c%NOTFOUND;
       -- process data record
       dbms_output.put_line('l_name = '||l_my_record.last_name||', salary = '||l_my_record.salary||', Job Id = '||l_my_record.job_id);
    END LOOP;
END;
/

11.1
The REF CURSOR examples:
Example:
DECLARE 
    l_t_name        VARCHAR2(20) := 'Test';
    l_data1         VARCHAR2(20) := 'sdfs111';
    l_data2         VARCHAR2(20) := 'sddfs11';
    TYPE cursor_rc  IS REF cursor;
    l_cursor        cursor_rc;
    l_sql           VARCHAR2(200);
    l_col           VARCHAR2(50);
    l_summ          NUMBER;
    l_i             NUMBER(30);
    l_j             NUMBER(30);
    l_num           NUMBER(30);
    l_sumall        NUMBER(30) := 0;
    l_comp          VARCHAR2(20);
BEGIN
    --drop table if exits
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE '||l_t_name||' PURGE';
    EXCEPTION WHEN OTHERS THEN 
        NULL;
    END;
    --create procedure to create a table
    EXECUTE IMMEDIATE 'CREATE TABLE '||l_t_name||' ( column1 VARCHAR2(50), sum1 NUMBER)';
    EXECUTE IMMEDIATE 'INSERT INTO '||l_t_name||'  VALUES ('''||l_data1||''',0)';
    EXECUTE IMMEDIATE 'INSERT INTO '||l_t_name||'  VALUES ('''||l_data2||''',0)';
    COMMIT;
    --create cursor to sum of varchar data between varchar||number data
    l_sql := 'select column1, sum1 from '||l_t_name||'';
    OPEN l_cursor FOR l_sql;
    LOOP
        FETCH l_cursor INTO l_col, l_summ;
        EXIT WHEN l_cursor%NOTFOUND;
        --dbms_output.put_line (l_col ||' , '|| l_summ);
        BEGIN
              l_sumall := 0;
              EXECUTE IMMEDIATE 'SELECT LENGTH('''||l_col||''') FROM dual' INTO l_i;
              FOR l_j IN 1..l_i
              LOOP
                  BEGIN
                       EXECUTE IMMEDIATE 'SELECT SUBSTR('''||l_col||''','||l_j||',1) FROM dual' INTO l_comp;
                       l_num := TO_NUMBER(l_comp);
                       l_sumall := l_sumall + l_num;
                  EXCEPTION WHEN OTHERS THEN 
                       NULL;
                  END;
              END LOOP;
              EXECUTE IMMEDIATE 'UPDATE '||l_t_name||' SET sum1 = '||l_sumall||' WHERE column1 ='''||l_col||'''' ;
        END;
    END LOOP;
	close l_cursor;
END;
/

-- Ref Cursor
DECLARE
    l_departmentid   NUMBER := 50;
    l_output         VARCHAR2(32767);
    TYPE cursor_rc   IS REF CURSOR;         --TYPE CURSOR
    l_cursor         cursor_rc;
    l_fname          VARCHAR2(200);
    l_salary         VARCHAR2(200);
BEGIN
    l_output :='SELECT
                      first_name,
                      salary
                 FROM
                      employees
                 WHERE
                      department_id='||l_departmentid||'';

    OPEN l_cursor FOR l_output;
    LOOP
       FETCH l_cursor INTO l_fname,l_salary;
       EXIT WHEN l_cursor%NOTFOUND;             --if data is not found
       Dbms_Output.Put_Line('First l_name: '||l_fname||' ,  '||'Salary: '||l_salary);
    END LOOP;
    CLOSE l_cursor;
    Dbms_Output.Put_Line('First l_name: '||l_fname||' ,  '||'Salary: '||l_salary);
END;
/

DECLARE
    l_hiredate        DATE := To_Date('21.06.1999 00:00:00','DD.MM.YYYY HH24:MI:SS');
    l_output          VARCHAR2(32767);
    TYPE cursor_rc    IS REF CURSOR;
    l_cursor          cursor_rc;
    l_fname           VARCHAR2(200);
    l_salary          VARCHAR2(200);
BEGIN
    l_output :='SELECT
                      first_name,
                      salary
                 FROM
                      employees
                 WHERE
                     To_Date(HIRE_DATE,''DD-MM-YY HH24:MI:SS'')=TO_DATE('''||l_hiredate||''',''DD-MM-YY HH24:MI:SS'')';
    OPEN l_cursor FOR l_output;
    LOOP
       FETCH l_cursor INTO l_fname,l_salary;
       EXIT WHEN l_cursor%NOTFOUND;
       Dbms_Output.Put_Line('First l_name: '||l_fname||' ,  '||'Salary: '||l_salary);
    END LOOP;
    CLOSE l_cursor;
    Dbms_Output.Put_Line('First l_name: '||l_fname||' ,  '||'Salary: '||l_salary);
END;
/
SELECT * FROM test;

-- Type Cursor
DECLARE 
  l_ename employees.first_name%TYPE;
  l_empno employees.employee_id%TYPE;
  l_sal   employees.salary%TYPE;
  CURSOR l_cursor IS
            SELECT first_name,employee_id,salary FROM employees ORDER BY salary DESC;
  --l_ename VARCHAR2(10);
  --l_empno NUMBER;
  --l_sal NUMBER;
BEGIN
    OPEN l_cursor;
      FOR l_i IN 1..5 LOOP
        FETCH l_cursor INTO l_ename,l_empno,l_sal;
        EXIT WHEN l_cursor%NOTFOUND;

        INSERT INTO temp1 VALUES (l_sal,l_empno,l_ename);
        COMMIT;
      END LOOP;
    CLOSE l_cursor;
END;
/

CREATE TABLE t1
(
  e NUMBER,
  b NUMBER
);
------------------------------
--input data--
------------------------------
BEGIN
    INSERT INTO t1 VALUES(2,4);
    INSERT INTO t1 VALUES(2,5);
    INSERT INTO t1 VALUES(6,3);
    INSERT INTO t1 VALUES(7,5);
END;
/

SELECT * FROM t1;
/*
e b
- -
2 4
2 5
6 3
7 5
*/
DECLARE
    l_a t1.e%TYPE;
    l_d t1.b%TYPE;
    CURSOR cursor_rc 
    IS
    SELECT e,b FROM t1; 
BEGIN
    OPEN cursor_rc;
    LOOP
       FETCH cursor_rc INTO l_a, l_d;
       EXIT WHEN cursor_rc%NOTFOUND;
       IF l_a < l_d then
          DELETE FROM t1 WHERE e = l_a;
          INSERT INTO t1 VALUES(l_d,l_a);
       ELSE
          DELETE FROM t1 WHERE e = l_a;
       END IF;              
    END LOOP;
    COMMIT;
    CLOSE cursor_rc;
END;
/

-- Simple Cursor
DECLARE 
      CURSOR l_cursor 
      IS
      SELECT first_name,employee_id,salary FROM employees ORDER BY salary DESC;
      l_ename VARCHAR2(10);
      l_empno NUMBER;
      l_sal   NUMBER;
BEGIN
    OPEN l_cursor;
      FOR l_i IN 1..5 LOOP
        FETCH l_cursor INTO l_ename,l_empno,l_sal;
        EXIT WHEN l_cursor%NOTFOUND;

        INSERT INTO temp1 VALUES (l_sal,l_empno,l_ename);
        COMMIT;
      END LOOP;
    CLOSE l_cursor;
END;
/

DECLARE
   vbl_department_id VARCHAR2(100) := 50;
   l_total_val         NUMBER(6);
   cursor cursor_c         is SELECT salary FROM employees WHERE department_id = vbl_department_id ;

BEGIN

   l_total_val := 0;

   FOR l_i in cursor_c
   LOOP
      l_total_val := l_total_val + l_i.salary;
   END LOOP;

   Dbms_Output.Put_Line(l_total_val);

END;
/
SELECT salary FROM employees WHERE department_id = 50;
SELECT Sum(salary) FROM employees WHERE department_id = 50;
/*
156400
*/

SELECT * FROM employees_bk1;

DECLARE
    d_id        NUMBER := 50;
    CURSOR cursor_rc  IS SELECT first_name,salary FROM employees_bk1 WHERE department_id = d_id FOR UPDATE OF first_name;
    e_name      employees.first_name%TYPE;
    e_salary    employees.salary%TYPE;
BEGIN
    IF cursor_rc%ISOPEN = FALSE THEN
       OPEN cursor_rc;
       FETCH cursor_rc INTO e_name,e_salary;

    END IF;
       UPDATE employees_bk1
       SET first_name = 'Suman'
       WHERE CURRENT OF cursor_rc;

       Dbms_Output.Put_Line('l_name : '||e_name||'  '||'Salary : '||e_salary);
       CLOSE cursor_rc;
END;
/

ROLLBACK ;

DECLARE
    d_id        NUMBER := 50;
    CURSOR cursor_rc  IS SELECT first_name,salary FROM employees_bk1 WHERE department_id = d_id FOR UPDATE OF first_name;
    e_name      employees.first_name%TYPE;
    e_salary    employees.salary%TYPE;
BEGIN
    IF cursor_rc%ISOPEN = FALSE THEN
       OPEN cursor_rc;
       FETCH cursor_rc INTO e_name,e_salary;

    END IF;
       DELETE FROM employees_bk1
       WHERE CURRENT OF cursor_rc;

       Dbms_Output.Put_Line('l_name : '||e_name||'  '||'Salary : '||e_salary);
       CLOSE cursor_rc;
END;
/

ROLLBACK;

SELECT * FROM employees_bk1;

-- To fetch the list of the employees whose department_id =  50 using the cursor
DECLARE
    CURSOR c_list  IS SELECT first_name, salary, job_id FROM employees WHERE department_id = 50;
    e_name         employees.first_name%TYPE;
    e_salary       employees.salary%TYPE;
    e_job          employees.job_id%TYPE;
BEGIN
    OPEN c_list;
    LOOP
       FETCH c_list INTO e_name, e_salary, e_job;
       IF c_list%FOUND THEN
            Dbms_Output.Put_Line('l_name : '||e_name ||'  Salary : '|| e_salary ||'  Job : '|| e_job);
       ELSE
           EXIT;
       END IF;
    END LOOP;
    CLOSE c_list;
END;
/

SELECT * FROM employees;


DECLARE
     CURSOR cursor_c ( l_type_date DATE) IS SELECT * FROM employees WHERE hire_date = l_type_date;
BEGIN
    FOR l_i IN cursor_c(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
       Dbms_Output.Put_Line('job :'||l_i.job_id||' date :'||l_i.hire_date ||'Last l_name :'||l_i.last_name);
    END LOOP;
END;
/


SELECT * FROM employees WHERE hire_date = To_Date('21.06.2007' , 'dd.mm.yyyy');

DROP TABLE tbl_date;
CREATE TABLE tbl_date
(
 cycle_start,
 cycle_end
)
AS
SELECT To_Date('21.06.2007' , 'dd.mm.yyyy')-30 , To_Date('21.06.2007' , 'dd.mm.yyyy')+30   FROM dual;


SELECT * FROM tbl_date;

TRUNCATE TABLE tbl_date;

DECLARE
     c_start     VARCHAR2(200);
     c_end       VARCHAR2(200);
     CURSOR cursor_c ( l_type_date DATE) IS SELECT * FROM employees WHERE hire_date = l_type_date;
BEGIN
    FOR l_i IN cursor_c(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT cycle_start, cycle_end FROM tbl_date' INTO c_start,c_end;
            IF (l_i.hire_date BETWEEN c_start AND c_end ) THEN
                Dbms_Output.Put_Line('job :'||l_i.job_id||' date :'||l_i.hire_date ||'Last l_name :'||l_i.last_name);
            END IF;

        EXCEPTION WHEN No_Data_Found THEN
            Dbms_Output.Put_Line(l_i.last_name);
        END;
    END LOOP;
END;
/

DECLARE
     valieddate number := 0;
     CURSOR cursor_c ( l_type_date DATE) IS SELECT * FROM employees WHERE hire_date = l_type_date;
BEGIN
    FOR l_i IN cursor_c(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM tbl_date WHERE To_Date('''||l_i.hire_date||''',''yyyy/mm/dd'') BETWEEN cycle_start AND cycle_end' INTO valieddate;
            IF (valieddate <> 0) THEN
               Dbms_Output.Put_Line('job :'||l_i.job_id||' date :'||l_i.hire_date ||'Last l_name :'||l_i.last_name);
            ELSE
               Dbms_Output.Put_Line(l_i.last_name);
            END IF;
        END;
    END LOOP;
END;
/

--Different use of the cursor attributes --
DECLARE
      CURSOR cursor_c 
	  IS 
	  SELECT first_name FROM employees_bk1;
      l_first_name employees_bk1.first_name%TYPE;
BEGIN
    IF cursor_c%ISOPEN = FALSE THEN
    OPEN cursor_c;
        LOOP
            FETCH cursor_c INTO l_first_name;
            IF (cursor_c%FOUND = TRUE AND cursor_c%ROWCOUNT = 10 )THEN
                 Dbms_Output.Put_Line(l_first_name||' is 10th fetch');
            END IF;
            EXIT WHEN cursor_c%NOTFOUND;
        END LOOP;
    END IF;
    CLOSE cursor_c;
END;
/

DECLARE
     l_sql           VARCHAR2(32767);
     l_job           employees.job_id%TYPE;
     TYPE cursor_rc  IS REF CURSOR;
     l_cursor        cursor_rc;
     str             VARCHAR2(32767);
     l_i             VARCHAR2(32767);
     l_j             VARCHAR2(32767);
     l_str           VARCHAR2(32767);
     l_wild          VARCHAR2(32767);
     flag            NUMBER(1) := 0;
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE char_wildcard';
        EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE char_wildcard
                           (
                             string     VARCHAR2(10),
                             wildcard   VARCHAR2(10)
                           )';
    END;

    l_sql := 'SELECT job_id FROM employees_bk1';

    OPEN l_cursor FOR l_sql;
    LOOP
       FETCH l_cursor INTO l_job;
       EXIT WHEN l_cursor%NOTFOUND;

       BEGIN
           EXECUTE IMMEDIATE 'SELECT Length('''||l_job||''') FROM dual' INTO l_i;
           FOR l_j IN 1..l_i
           LOOP
              BEGIN
                  EXECUTE IMMEDIATE 'SELECT substr('''||l_job||''','||l_j||',1) FROM dual' INTO str;

                  IF(regexp_like(''||str||'','^[A-Z]$')) THEN
                     l_str  := l_str  || str;
                  ELSE
                     l_wild := l_wild || str;
                  END IF;
              END;
            END LOOP;
            BEGIN
                EXECUTE IMMEDIATE 'INSERT INTO char_wildcard VALUES ('''||l_str||''','''||l_wild||''')';
            END;
             Dbms_Output.Put_Line(l_str);
             Dbms_Output.Put_Line(l_wild);
             l_str  := '';
             l_wild := '';
       END;
    END LOOP;
END;
/

SELECT job_id  FROM employees
WHERE regexp_like(job_id,'[A-Z]');


SELECT * FROM char_wildcard;

SELECT * FROM employees_bk1;

UPDATE employees_bk1
SET job_id = 'SH_C%AB#CD'
WHERE
JOB_ID = 'SH_CLERK';

--BULK collection
DECLARE
    TYPE type_tt      IS TABLE OF employees.commission_pct%TYPE;
    TYPE type_1_tt    IS TABLE OF employees.hire_date%TYPE;
    l_type_comm       type_tt;
    l_type_date       type_1_tt;
    CURSOR cursor_rc  IS SELECT Nvl(commission_pct,0) commission_pct, hire_date FROM employees;
BEGIN
    OPEN cursor_rc;
       FETCH cursor_rc BULK COLLECT INTO l_type_comm,l_type_date;
    CLOSE cursor_rc;
    FOR l_i IN l_type_comm.FIRST .. l_type_comm.LAST
    LOOP
        IF l_type_comm(l_i) = .3 THEN
          Dbms_Output.Put_Line(l_type_comm(l_i));
        END IF;
    END LOOP;
    FOR l_i IN l_type_date.FIRST .. l_type_date.LAST
    LOOP
       IF (l_type_date(l_i) = '2005/11/11') THEN
          Dbms_Output.Put_Line(l_type_date(l_i));
       END IF;
    END LOOP;
END;
/


Fetching Bulk Data with a Cursor
The BULK COLLECT clause lets you fetch all rows from the result set at once. See Retrieving Query Results into Collections (BULK COLLECT Clause). 

Syntax:
BULK COLLECT Syntax	FETCH BULK COLLECT <cursor_name> BULK COLLECT INTO<collection_name>
LIMIT <numeric_expression>;
OR
FETCH BULK COLLECT <cursor_name> BULK COLLECT INTO <array_name>
LIMIT <numeric_expression>;

In Example, you bulk-fetch from a cursor into two collections.
Example:

DECLARE
    TYPE type_id_tt   IS TABLE OF employees.employee_id%TYPE;
    TYPE type_name_tt IS TABLE OF employees.last_name%TYPE;
    l_type_id         type_id_tt;
    l_type_name       type_name_tt;
    CURSOR cursor_c IS SELECT employee_id, last_name FROM employees WHERE job_id = 'ST_CLERK';
BEGIN
    OPEN cursor_c;
    FETCH cursor_c BULK COLLECT INTO l_type_id, l_type_name;
    CLOSE cursor_c;
    -- Here is where you process the elements in the collections
    FOR l_i IN l_type_id.FIRST .. l_type_id.LAST
    LOOP
       IF l_type_id(l_i) > 140 THEN
          dbms_output.put_line( l_type_id(l_i) );
       END IF;
    END LOOP;
    FOR l_i IN l_type_name.FIRST .. l_type_name.LAST
    LOOP
       IF l_type_name(l_i) LIKE '%Ma%' THEN
          dbms_output.put_line( l_type_name(l_i) );
       END IF;
    END LOOP;
END;
/

DECLARE
    CURSOR cursor_c IS SELECT employee_id FROM employees;
    TYPE array_at   IS TABLE OF cursor_c%ROWTYPE;
    l_array_at      array_at;
BEGIN
    OPEN cursor_c;
    LOOP
       FETCH cursor_c BULK COLLECT INTO l_array_at LIMIT 100;
       EXIT WHEN cursor_c%NOTFOUND;
    END LOOP;
    CLOSE cursor_c;
END;
/

DECLARE
    CURSOR cursor_c IS SELECT employee_id FROM employees;
    TYPE array_at   IS TABLE OF cursor_c%ROWTYPE;
    l_array_at      array_at;
BEGIN
    OPEN cursor_c;
    LOOP
      FETCH cursor_c BULK COLLECT INTO l_array_at LIMIT 500;
      EXIT WHEN cursor_c%NOTFOUND;
    END LOOP;
    CLOSE cursor_c;
END;
/

DECLARE
    CURSOR cursor_c IS SELECT employee_id FROM employees;
    TYPE array_at   IS TABLE OF cursor_c%ROWTYPE;
    l_array_at      array_at;
BEGIN
    OPEN cursor_c;
    LOOP
      FETCH cursor_c BULK COLLECT INTO l_array_at LIMIT 1000;
      EXIT WHEN cursor_c%NOTFOUND;
    END LOOP;
    CLOSE cursor_c;
END;
/

/*
-- try with a LIMIT clause of 2500, 5000, and 10000. What do you see?

FORALL

FORALL Syntax	FORALL <index_name> IN <lower_boundary> .. <upper_boundary>
<sql_statement>
SAVE EXCEPTIONS;

FORALL <index_name> IN INDICES OF <collection>
[BETWEEN <lower_boundary> AND <upper_boundary>]
<sql_statement>
SAVE EXCEPTIONS;

FORALL <index_name> IN INDICES OF <collection>
VALUES OF <index_collection>
<sql_statement>
SAVE EXCEPTIONS;
*/

CREATE TABLE test11 (cursor_c VARCHAR2(100));

DECLARE
    CURSOR cursor_c IS SELECT salary FROM employees;
    TYPE array_at   IS TABLE OF cursor_c %ROWTYPE;
    l_array_at      array_at;
BEGIN
    OPEN cursor_c;
    LOOP
       FETCH cursor_c BULK COLLECT INTO l_array_at LIMIT 10;
       FORALL l_i IN 1..l_array_at.COUNT
       INSERT INTO test11 VALUES l_array_at(l_i);
       EXIT WHEN cursor_c%NOTFOUND;
    END LOOP;
    CLOSE cursor_c;
    COMMIT;
END;
/

SELECT * FROM test11;
TRUNCATE TABLE test11;

CREATE TABLE employees_bk AS SELECT * FROM employees;

DECLARE
    TYPE array_at IS TABLE OF employees_bk.employee_id%TYPE
    INDEX BY BINARY_INTEGER;
    l_array array_at;
BEGIN
    l_array(1) := 198;
    l_array(2) := 199;
    l_array(3) := 200;

    FORALL l_i IN l_array.FIRST .. l_array.LAST
    UPDATE employees_bk
    SET salary = 2600
    WHERE employee_id = l_array(l_i);
END;
/

SELECT * FROM employees_bk;


DECLARE
    TYPE array_at IS TABLE OF employees_bk.employee_id%TYPE INDEX BY BINARY_INTEGER;
    l_array      array_at;
BEGIN
    l_array(1) := 198;
    l_array(2) := 199;
    l_array(3) := 200;

    FORALL l_i IN l_array.FIRST .. l_array.LAST
    DELETE employees_bk
    WHERE employee_id = l_array(l_i);
    COMMIT;

    FOR l_i IN l_array.FIRST .. l_array.LAST LOOP
      dbms_output.put_line('Iteration #' || l_i || ' deleted ' ||
      SQL%BULK_ROWCOUNT(l_i) || ' rows.');
    END LOOP;
END;
/

SELECT * FROM employees_bk;

DECLARE 
    l_a             INTEGER;
BEGIN
    l_a := dbms_utility.get_time; --1000SEC
    Dbms_Output.Put_Line(l_a);
END;
/

DROP TABLE t1 PURGE;
CREATE TABLE t1 (pnum INTEGER, pname VARCHAR2(15));
CREATE TABLE t2 AS SELECT * FROM t1;

DECLARE 
    l_iterations      PLS_INTEGER := 500;
    TYPE numtab_tty   IS TABLE OF t1.pnum%TYPE INDEX BY PLS_INTEGER;
    TYPE nametab_tty  IS TABLE OF t1.pname%TYPE INDEX BY PLS_INTEGER;
    l_pnums           numtab_tty;
    l_pnames          nametab_tty;
    l_a               INTEGER;
    l_b               INTEGER;
    l_c               INTEGER;
BEGIN
    FOR l_j IN 1..l_iterations
    LOOP -- load index-by tables
       l_pnums(l_j) := l_j;
       l_pnames(l_j) := 'Part No. ' || TO_CHAR(l_j);
    END LOOP;
    l_a := dbms_utility.get_time;
    FOR l_i IN 1..l_iterations
    LOOP -- use FOR loop
       INSERT INTO t1 VALUES (l_pnums(l_i), l_pnames(l_i));
    END LOOP;
    l_b := dbms_utility.get_time;
    FORALL l_i IN 1 .. l_iterations -- use FORALL statement
    INSERT INTO t2 VALUES (l_pnums(l_i), l_pnames(l_i));
    l_c := dbms_utility.get_time;
    dbms_output.put_line('Execution Time (secs)');
    dbms_output.put_line('---------------------');
    dbms_output.put_line('FOR loop: ' || TO_CHAR((l_b - l_a)/100));
    dbms_output.put_line('FORALL: ' || TO_CHAR((l_c - l_b)/100));
    COMMIT;
END;
/
--Bulk Collection Demo Table
CREATE TABLE parent
(
 part_num  NUMBER,
 part_name VARCHAR2(15)
);

CREATE TABLE child AS SELECT * FROM parent;

--Create And Load Demo Data
DECLARE
    l_j PLS_INTEGER := 1;
    k parent.part_name%TYPE := 'Transducer';
BEGIN
    FOR l_i IN 1 .. 200000
    LOOP
      SELECT DECODE(k, 'Transducer', 'Rectifier','Rectifier', 'Capacitor','Capacitor', 'Knob','Knob', 'Chassis','Chassis', 'Transducer') INTO k FROM DUAL;
      INSERT INTO parent VALUES (l_j+l_i, k);
    END LOOP;
    COMMIT;
END;
/

SELECT COUNT(*) FROM parent;
SELECT COUNT(*) FROM child;
SELECT * FROM parent;

--Slow Way	CREATE OR REPLACE PROCEDURE slow_way IS

BEGIN
    FOR r IN (SELECT * FROM parent)
    LOOP
      -- modify record values
      r.part_num := r.part_num * 10;
      -- store results
      INSERT INTO child VALUES (r.part_num, r.part_name);
    END LOOP;
    COMMIT;
END;
/

SELECT * FROM child;
