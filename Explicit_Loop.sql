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
		**The name of the cursor that you wish to fetch records from.
	*statements
		**The statements of code to execute each pass through the CURSOR FOR LOOP.
Example:
In this example, we have created a cursor called c1. The CURSOR FOR Loop will terminate after all records have been fetched from the cursor c1.

DECLARE
    CURSOR a_cur IS SELECT employee_id FROM employees;
BEGIN
    FOR cur_rec IN a_cur
    LOOP
       NULL;
    END LOOP;
END;
/

DECLARE 
   total_val number(6);
   CURSOR c1 IS SELECT salary FROM employees ;
BEGIN
   total_val := 0;
   FOR employee_rec in c1
   LOOP
      total_val := total_val + employee_rec.salary;
   END LOOP;
   dbms_output.put_line(total_val);
END;
/

Passing Parameters to a Cursor FOR Loop
displays the wages paid to employees earning over a specified wage in a specified department.
Example:

DECLARE
    CURSOR c1 (job VARCHAR2, max_wage NUMBER) IS SELECT * FROM employees WHERE job_id = job AND salary = max_wage;
BEGIN
  FOR person IN c1('IT_PROG',4200)
  LOOP
     -- process data record
    dbms_output.put_line('Name = '||person.last_name||', salary = '||person.salary||', Job Id = '||person.job_id);
  END LOOP;
END;
/

DECLARE
    CURSOR c1 (job VARCHAR2,sal NUMBER) IS SELECT job_id,salary FROM employees WHERE job_id = job;
    l_job employees.job_id%TYPE;
    l_sal employees.salary%TYPE;
BEGIN
  OPEN c1('IT_PROG',555);
  LOOP
     FETCH c1 INTO l_job,l_sal;
     EXIT WHEN c1%NOTFOUND;
     Dbms_Output.Put_Line(l_job||' , '||l_sal);
  END LOOP;
END;
/

DECLARE
    CURSOR c1 (job VARCHAR2 := 'IT_PROG',sal NUMBER := 9000) IS SELECT job_id,salary FROM employees WHERE job_id = job AND salary = sal;
    l_job employees.job_id%TYPE;
    l_sal employees.salary%TYPE;
BEGIN
  OPEN c1;
  LOOP
     FETCH c1 INTO l_job,l_sal;
     EXIT WHEN c1%NOTFOUND;
     Dbms_Output.Put_Line(l_job||' , '||l_sal);
  END LOOP;
  CLOSE c1;
END;
/

DECLARE
    CURSOR c1 (hire_date_1 DATE ) IS SELECT * FROM employees WHERE hire_date = hire_date_1;
BEGIN
  FOR person IN c1(To_Date('21.06.2007','dd.mm.yyyy'))
  LOOP
     -- process data record
    dbms_output.put_line('Name = '||person.last_name||', salary = '||person.salary||', Job Id = '||person.job_id);
  END LOOP;
END;
/

SELECT * FROM employees WHERE hire_date =  To_Date('21.06.2007','dd.mm.yyyy');


2.
Oracle/PLSQL: Cursors
In Oracle, a cursor is a mechanism by which you can assign a name to a SELECT statement and manipulate the information within that SQL statement.
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
For example, you could define a cursor called c1 as below.

CURSOR c1 IS SELECT course_number FROM courses_tbl WHERE course_name = name_in;

The result set of this cursor is all course_numbers whose course_name matches the variable called name_in.

Below is a function that uses this cursor.

DECLARE
    name_in   VARCHAR2(30) := 50;
    cnumber   NUMBER;
    CURSOR c1 IS SELECT salary FROM employees WHERE department_id = name_in;
BEGIN
	OPEN c1;
	FETCH c1 INTO cnumber;
    dbms_output.put_line('Input Data : '||cnumber);	
	IF c1%notfound THEN
		cnumber := 9999;
	end IF;
	CLOSE c1;
  dbms_output.put_line('Out Put Data : '||cnumber);
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
*cursor_name : The name of the cursor.
*select_statement : A SELECT statement that will populate your cursor result set.
*column_list : The columns in the cursor result set that you wish to update.
*NOWAIT : Optional. The cursor does not wait for resources.

Example
For example, you could use the SELECT FOR UPDATE statement as follows:

CURSOR c1
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
    name_in   VARCHAR2(30) := 50;
    cnumber   NUMBER;
    CURSOR c1 IS SELECT salary FROM employees WHERE department_id = name_in FOR UPDATE of first_name;
BEGIN
   OPEN c1;
   FETCH c1 INTO cnumber;
   IF c1%notfound THEN
      cnumber := 9999;
   ELSE
      UPDATE employees
      SET first_name = 'Do'
      WHERE CURRENT OF c1;
      --COMMIT;
   END IF;
   CLOSE c1;
   dbms_output.put_line('Out Put Data : '||cnumber);
END;
/

Deleting using the WHERE CURRENT OF Statement
Here is an example where we are deleting records using the WHERE CURRENT OF Statement:

DECLARE
    name_in   VARCHAR2(30) := 50;
    cnumber   NUMBER;
    CURSOR c1 IS SELECT salary FROM employees WHERE department_id = name_in FOR UPDATE of first_name;
BEGIN
   OPEN c1;
   FETCH c1 INTO cnumber;
   IF c1%notfound THEN
      cnumber := 9999;
   ELSE
      DELETE FROM employees 
      WHERE CURRENT OF c1;
      --COMMIT;
   END IF;
   CLOSE C1;
   dbms_output.put_line('Out Put Data : '||cnumber);
END;
/

3.1
%FOUND Attribute: Has a Row Been Fetched?
After a cursor or cursor variable is opened but before the first fetch, %FOUND returns NULL. After any fetches, it returns TRUE if the last fetch returned a row, or FALSE if the last fetch did not return a row. Example 6-14 uses %FOUND to select an action.

Example:

DECLARE
    CURSOR c1 IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    my_ename  employees.last_name%TYPE;
    my_salary employees.salary%TYPE;
BEGIN
    OPEN c1;
    LOOP
      FETCH c1 INTO my_ename, my_salary;
      IF c1%FOUND THEN  -- fetch succeeded
        dbms_output.put_line('Name = ' || my_ename || ', salary = ' || my_salary);
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
    CURSOR c1  IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    the_name   employees.last_name%TYPE;
    the_salary employees.salary%TYPE;
BEGIN
   IF c1%ISOPEN = FALSE THEN  -- cursor was not already open
      OPEN c1;
   END IF;
   FETCH c1 INTO the_name, the_salary;
   CLOSE c1;
END;
/

5.1
%NOTFOUND Attribute: Has a Fetch Failed?
%NOTFOUND is the logical opposite of %FOUND. %NOTFOUND yields FALSE if the last fetch returned a row, or TRUE if the last fetch failed to return a row. In Example 6-16, you use %NOTFOUND to exit a loop when FETCH fails to return a row.

Example:

DECLARE
    CURSOR c1 IS SELECT last_name, salary FROM employees WHERE ROWNUM < 11;
    my_ename  employees.last_name%TYPE;
    my_salary employees.salary%TYPE;
BEGIN
    OPEN c1;
    LOOP
       FETCH c1 INTO my_ename, my_salary;
       IF c1%NOTFOUND THEN -- fetch failed, so exit loop
       -- Another form of this test is
       -- "EXIT WHEN c1%NOTFOUND OR c1%NOTFOUND IS NULL;"
         EXIT;
      ELSE   -- fetch succeeded
         dbms_output.put_line('Name = ' || my_ename || ', salary = ' || my_salary);
      END IF;
     END LOOP;
END;
/

6.1
%ROWCOUNT Attribute: How Many Rows Fetched So Far?
When its cursor or cursor variable is opened, %ROWCOUNT is zeroed. Before the first fetch, %ROWCOUNT yields zero. Thereafter, it yields the number of rows fetched so far. The number is incremented if the last fetch returned a row. Example 6-17 uses %ROWCOUNT to test if more than ten rows were fetched.

Example:

DECLARE
    CURSOR c1 IS SELECT last_name FROM employees WHERE ROWNUM < 11;
    name employees.last_name%TYPE;
BEGIN
    OPEN c1;
    LOOP
       FETCH c1 INTO name;
       EXIT WHEN c1%NOTFOUND OR c1%NOTFOUND IS NULL;
       dbms_output.put_line(c1%ROWCOUNT || '. ' || name);
       IF c1%ROWCOUNT = 5 THEN
          dbms_output.put_line('--- Fetched 5th record ---');
       END IF;
    END LOOP;
    CLOSE c1;
END;
/

7.1
Cursor with other cursor
DECLARE
    v_jobid     employees.job_id%TYPE;     -- variable for job_id
    v_lastname  employees.last_name%TYPE;  -- variable for last_name
    CURSOR c1 IS SELECT last_name, job_id FROM employees WHERE REGEXP_LIKE (job_id, 'S[HT]_CLERK');
    v_employees employees%ROWTYPE;         -- record variable for row
    CURSOR c2 is SELECT * FROM employees WHERE REGEXP_LIKE (job_id, '[ACADFIMKSA]_M[ANGR]');
BEGIN
    OPEN c1; -- open the cursor before fetching
    LOOP
      -- Fetches 2 columns into variables
      FETCH c1 INTO v_lastname, v_jobid;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line( RPAD(v_lastname, 25, ' ') || v_jobid );
    END LOOP;
    CLOSE c1;
    dbms_output.put_line( '-------------------------------------' );
    OPEN c2;
    LOOP
      -- Fetches entire row into the v_employees record
      FETCH c2 INTO v_employees;
      EXIT WHEN c2%NOTFOUND;
      dbms_output.put_line( RPAD(v_employees.last_name, 25, ' ') || v_employees.job_id );
    END LOOP;
    CLOSE c2;
END;
/

8.1
Referencing PL/SQL Variables Within Its Scope
The query can reference PL/SQL variables within its scope. Any variables in the query are evaluated only when the cursor is opened. 
In Example, each retrieved salary is multiplied by 2, even though factor is incremented after every fetch.
Example:

DECLARE
    my_sal employees.salary%TYPE;
    my_job employees.job_id%TYPE;
    factor INTEGER := 2;
    CURSOR c1 IS SELECT factor*salary FROM employees WHERE job_id = my_job;
BEGIN
   OPEN c1;  -- factor initially equals 2
   LOOP
      FETCH c1 INTO my_sal;
      EXIT WHEN c1%NOTFOUND;
      factor := factor + 1;  -- does not affect FETCH
   END LOOP;
   CLOSE c1;
END;
/

9.1
Fetching the Same Cursor Into Different Variables.
To change the result set or the values of variables in the query, you must close and reopen the cursor with the input variables set to their new values. 
However, you can use a different INTO list on separate fetches with the same cursor. Each fetch retrieves another row and assigns values to the target 
variables, as shown in Example
Example:

DECLARE
    CURSOR c1 IS SELECT last_name FROM employees ORDER BY last_name;
    name1 employees.last_name%TYPE;
    name2 employees.last_name%TYPE;
    name3 employees.last_name%TYPE;
BEGIN
    OPEN c1;
    FETCH c1 INTO name1;  -- this fetches first row
    FETCH c1 INTO name2;  -- this fetches second row
    FETCH c1 INTO name3;  -- this fetches third row
    CLOSE c1;
END;
/

10.1
Passing Parameters to Explicit Cursors
In Example several ways are shown to open a cursor.
Example:

DECLARE
    emp_job      employees.job_id%TYPE := 'ST_CLERK';
    emp_salary   employees.salary%TYPE := 3000;
    my_record    employees%ROWTYPE;
    CURSOR c1 (job VARCHAR2, max_wage NUMBER) IS SELECT * FROM employees WHERE job_id = job AND salary > max_wage;
BEGIN
    -- Any of the following statements opens the cursor:
    -- OPEN c1('ST_CLERK', 3000); OPEN c1('ST_CLERK', emp_salary);
    -- OPEN c1(emp_job, 3000); OPEN c1(emp_job, emp_salary);
    OPEN c1(emp_job, emp_salary);
    LOOP
       FETCH c1 INTO my_record;
       EXIT WHEN c1%NOTFOUND;
       -- process data record
       dbms_output.put_line('Name = '||my_record.last_name||', salary = '||my_record.salary||', Job Id = '||my_record.job_id);
    END LOOP;
END;
/

11.1
The REF CURSOR examples:
Example:
DECLARE 
    t_name    VARCHAR2(20) := 'Test';
    data1     VARCHAR2(20) := 'sdfs111';
    data2     VARCHAR2(20) := 'sddfs11';
    TYPE crs  IS REF cursor;
    r_crs     crs;
    stmt      VARCHAR2(200);
    col       VARCHAR2(50);
    summ      NUMBER;
    i         NUMBER(30);
    j         NUMBER(30);
    num       NUMBER(30);
    sumall    NUMBER(30) := 0;
    comp      VARCHAR2(20);
BEGIN
    --drop table if exits
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE '||t_name||' PURGE';
    EXCEPTION WHEN OTHERS THEN 
        NULL;
    END;
    --create procedure to create a table
    EXECUTE IMMEDIATE 'CREATE TABLE '||t_name||' ( column1 VARCHAR2(50), sum1 NUMBER)';
    EXECUTE IMMEDIATE 'INSERT INTO '||t_name||'  VALUES ('''||data1||''',0)';
    EXECUTE IMMEDIATE 'INSERT INTO '||t_name||'  VALUES ('''||data2||''',0)';
    COMMIT;
    --create cursor to sum of varchar data between varchar||number data
    stmt := 'select column1, sum1 from '||t_name||'';
    OPEN r_crs FOR stmt;
    LOOP
        FETCH r_crs INTO col, summ;
        EXIT WHEN r_crs%NOTFOUND;
        --dbms_output.put_line (col ||' , '|| summ);
        BEGIN
              sumall := 0;
              EXECUTE IMMEDIATE 'SELECT LENGTH('''||col||''') FROM dual' INTO i;
              FOR j IN 1..i
              LOOP
                  BEGIN
                       EXECUTE IMMEDIATE 'SELECT SUBSTR('''||col||''','||j||',1) FROM dual' INTO comp;
                       num := TO_NUMBER(comp);
                       sumall := sumall + num;
                  EXCEPTION WHEN OTHERS THEN 
                       NULL;
                  END;
              END LOOP;
              EXECUTE IMMEDIATE 'UPDATE '||t_name||' SET sum1 = '||sumall||' WHERE column1 ='''||col||'''' ;
        END;
    END LOOP;
	close r_crs;
END;
/

SELECT * FROM test;

11.1
http://www.dba-oracle.com/t_oracle_bulk_collect.htm
http://www.getyourcontent.com/1/7101-0/10G-Bulk-Collect-and-FORA.aspx
http://www.oracle-developer.net/display.php?id=306
http://itknowledgeexchange.techtarget.com/itanswers/bulk-collect-vs-cursor/

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
    TYPE IdsTab IS TABLE OF employees.employee_id%TYPE;
    TYPE NameTab IS TABLE OF employees.last_name%TYPE;
    ids   IdsTab;
    names NameTab;
    CURSOR c1 IS SELECT employee_id, last_name FROM employees WHERE job_id = 'ST_CLERK';
BEGIN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO ids, names;
    CLOSE c1;
    -- Here is where you process the elements in the collections
    FOR i IN ids.FIRST .. ids.LAST
    LOOP
       IF ids(i) > 140 THEN
          dbms_output.put_line( ids(i) );
       END IF;
    END LOOP;
    FOR i IN names.FIRST .. names.LAST
    LOOP
       IF names(i) LIKE '%Ma%' THEN
          dbms_output.put_line( names(i) );
       END IF;
    END LOOP;
END;
/

DECLARE
    CURSOR a_cur IS SELECT employee_id FROM employees;
    TYPE myarray IS TABLE OF a_cur%ROWTYPE;
    cur_array myarray;
BEGIN
    OPEN a_cur;
    LOOP
       FETCH a_cur BULK COLLECT INTO cur_array LIMIT 100;
       EXIT WHEN a_cur%NOTFOUND;
    END LOOP;
    CLOSE a_cur;
END;
/

DECLARE
    CURSOR a_cur IS SELECT employee_id FROM employees;
    TYPE myarray IS TABLE OF a_cur%ROWTYPE;
    cur_array myarray;
BEGIN
    OPEN a_cur;
    LOOP
      FETCH a_cur BULK COLLECT INTO cur_array LIMIT 500;
      EXIT WHEN a_cur%NOTFOUND;
    END LOOP;
    CLOSE a_cur;
END;
/

DECLARE
    CURSOR a_cur IS SELECT employee_id FROM employees;
    TYPE myarray IS TABLE OF a_cur%ROWTYPE;
    cur_array myarray;
BEGIN
    OPEN a_cur;
    LOOP
      FETCH a_cur BULK COLLECT INTO cur_array LIMIT 1000;
      EXIT WHEN a_cur%NOTFOUND;
    END LOOP;
    CLOSE a_cur;
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

CREATE TABLE test11 (c1 VARCHAR2(100));

DECLARE
    CURSOR a_cur IS SELECT salary FROM employees;
    TYPE fetch_array IS TABLE OF a_cur %ROWTYPE;
    array fetch_array;
BEGIN
    OPEN a_cur;
    LOOP
       FETCH a_cur BULK COLLECT INTO array LIMIT 10;
       FORALL i IN 1..array.COUNT
       INSERT INTO test11 VALUES ARRAY(i);
       EXIT WHEN a_cur%NOTFOUND;
    END LOOP;
    CLOSE a_cur;
    COMMIT;
END;
/

SELECT * FROM test11;
TRUNCATE TABLE test11;

CREATE TABLE employees_bk AS SELECT * FROM employees;

DECLARE
    TYPE myarray IS TABLE OF employees_bk.employee_id%TYPE
    INDEX BY BINARY_INTEGER;
    d_array myarray;
BEGIN
    d_array(1) := 198;
    d_array(2) := 199;
    d_array(3) := 200;

    FORALL i IN d_array.FIRST .. d_array.LAST
    UPDATE employees_bk
    SET salary = 2600
    WHERE employee_id = d_array(i);
END;
/

SELECT * FROM employees_bk;


DECLARE
    TYPE myarray IS TABLE OF employees_bk.employee_id%TYPE INDEX BY BINARY_INTEGER;
    d_array      myarray;
BEGIN
    d_array(1) := 198;
    d_array(2) := 199;
    d_array(3) := 200;

    FORALL i IN d_array.FIRST .. d_array.LAST
    DELETE employees_bk
    WHERE employee_id = d_array(i);
    COMMIT;

    FOR i IN d_array.FIRST .. d_array.LAST LOOP
      dbms_output.put_line('Iteration #' || i || ' deleted ' ||
      SQL%BULK_ROWCOUNT(i) || ' rows.');
    END LOOP;
END;
/

SELECT * FROM employees_bk;


DROP TABLE t1;
CREATE TABLE t1 (pnum INTEGER, pname VARCHAR2(15));
CREATE TABLE t2 AS SELECT * FROM t1;

DECLARE 
    iterations    PLS_INTEGER := 500;
    TYPE NumTab   IS TABLE OF t1.pnum%TYPE INDEX BY PLS_INTEGER;
    TYPE NameTab  IS TABLE OF t1.pname%TYPE INDEX BY PLS_INTEGER;
    pnums         NumTab;
    pnames        NameTab;
    a             INTEGER;
    b             INTEGER;
    c             INTEGER;
BEGIN
    FOR j IN 1..iterations
    LOOP -- load index-by tables
       pnums(j) := j;
       pnames(j) := 'Part No. ' || TO_CHAR(j);
    END LOOP;
    a := dbms_utility.get_time;
    FOR i IN 1..iterations
    LOOP -- use FOR loop
       INSERT INTO t1 VALUES (pnums(i), pnames(i));
    END LOOP;
    b := dbms_utility.get_time;
    FORALL i IN 1 .. iterations -- use FORALL statement
    INSERT INTO t2 VALUES (pnums(i), pnames(i));
    c := dbms_utility.get_time;
    dbms_output.put_line('Execution Time (secs)');
    dbms_output.put_line('---------------------');
    dbms_output.put_line('FOR loop: ' || TO_CHAR((b - a)/100));
    dbms_output.put_line('FORALL: ' || TO_CHAR((c - b)/100));
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
    j PLS_INTEGER := 1;
    k parent.part_name%TYPE := 'Transducer';
BEGIN
    FOR i IN 1 .. 200000
    LOOP
      SELECT DECODE(k, 'Transducer', 'Rectifier','Rectifier', 'Capacitor','Capacitor', 'Knob','Knob', 'Chassis','Chassis', 'Transducer') INTO k FROM DUAL;
      INSERT INTO parent VALUES (j+i, k);
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

DECLARE
   vbl_department_id VARCHAR2(100) := 50;
   total_val         NUMBER(6);
   cursor c1         is SELECT salary FROM employees WHERE department_id = vbl_department_id ;

BEGIN

   total_val := 0;

   FOR i in c1
   LOOP
      total_val := total_val + i.salary;
   END LOOP;

   Dbms_Output.Put_Line(total_val);

END;
/
SELECT salary FROM employees WHERE department_id = 50;
SELECT Sum(salary) FROM employees WHERE department_id = 50;

156400

SELECT * FROM employees_bk1;

DECLARE
    d_id        NUMBER := 50;
    CURSOR cur  IS SELECT first_name,salary FROM employees_bk1 WHERE department_id = d_id FOR UPDATE OF first_name;
    e_name      employees.first_name%TYPE;
    e_salary    employees.salary%TYPE;
BEGIN
    IF cur%ISOPEN = FALSE THEN
       OPEN cur;
       FETCH cur INTO e_name,e_salary;

    END IF;
       UPDATE employees_bk1
       SET first_name = 'Suman'
       WHERE CURRENT OF cur;

       Dbms_Output.Put_Line('Name : '||e_name||'  '||'Salary : '||e_salary);
       CLOSE cur;
END;
/

ROLLBACK ;

DECLARE
    d_id        NUMBER := 50;
    CURSOR cur  IS SELECT first_name,salary FROM employees_bk1 WHERE department_id = d_id FOR UPDATE OF first_name;
    e_name      employees.first_name%TYPE;
    e_salary    employees.salary%TYPE;
BEGIN
    IF cur%ISOPEN = FALSE THEN
       OPEN cur;
       FETCH cur INTO e_name,e_salary;

    END IF;
       DELETE FROM employees_bk1
       WHERE CURRENT OF cur;

       Dbms_Output.Put_Line('Name : '||e_name||'  '||'Salary : '||e_salary);
       CLOSE cur;
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
            Dbms_Output.Put_Line('Name : '||e_name ||'  Salary : '|| e_salary ||'  Job : '|| e_job);
       ELSE
           EXIT;
       END IF;
    END LOOP;
    CLOSE c_list;
END;
/

SELECT * FROM employees;


DECLARE
     CURSOR c1 ( h_date DATE) IS SELECT * FROM employees WHERE hire_date = h_date;
BEGIN
    FOR i IN c1(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
       Dbms_Output.Put_Line('job :'||i.job_id||' date :'||i.hire_date ||'Last Name :'||i.last_name);
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
     CURSOR c1 ( h_date DATE) IS SELECT * FROM employees WHERE hire_date = h_date;
BEGIN
    FOR i IN c1(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT cycle_start, cycle_end FROM tbl_date' INTO c_start,c_end;
            IF (i.hire_date BETWEEN c_start AND c_end ) THEN
                Dbms_Output.Put_Line('job :'||i.job_id||' date :'||i.hire_date ||'Last Name :'||i.last_name);
            END IF;

        EXCEPTION WHEN No_Data_Found THEN
            Dbms_Output.Put_Line(i.last_name);
        END;
    END LOOP;
END;
/

DECLARE
     valieddate number := 0;
     CURSOR c1 ( h_date DATE) IS SELECT * FROM employees WHERE hire_date = h_date;
BEGIN
    FOR i IN c1(To_Date('21.06.2007' , 'dd.mm.yyyy'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM tbl_date WHERE To_Date('''||i.hire_date||''',''yyyy/mm/dd'') BETWEEN cycle_start AND cycle_end' INTO valieddate;
            IF (valieddate <> 0) THEN
               Dbms_Output.Put_Line('job :'||i.job_id||' date :'||i.hire_date ||'Last Name :'||i.last_name);
            ELSE
               Dbms_Output.Put_Line(i.last_name);
            END IF;
        END;
    END LOOP;
END;
/

--Different use of the cursor attributes --
DECLARE
      CURSOR c1 IS SELECT first_name FROM employees_bk1;

      cur_1 employees_bk1.first_name%TYPE;
BEGIN
    IF c1%ISOPEN = FALSE THEN
    OPEN c1;
        LOOP
            FETCH c1 INTO cur_1;
            IF (c1%FOUND = TRUE AND c1%ROWCOUNT = 10 )THEN
                 Dbms_Output.Put_Line(cur_1||' is 10th fetch');
            END IF;
            EXIT WHEN c1%NOTFOUND;
        END LOOP;
    END IF;
    CLOSE c1;
END;
/


--  http://docstore.mik.ua/orelly/oracle/prog2/ch06_01.htm
/*
Name	                               Description
%FOUND	                Returns TRUE if record was fetched successfully, FALSE otherwise.
%NOTFOUND             	Returns TRUE if record was not fetched successfully, FALSE otherwise.
%ROWCOUNT	              Returns number of records fetched from cursor at that point in time.
%ISOPEN	                Returns TRUE if cursor is open, FALSE otherwise.
*/

DECLARE
     stmt      VARCHAR2(32767);
     g_job     employees.job_id%TYPE;
     TYPE cur  IS REF CURSOR;
     c1        cur;
     str       VARCHAR2(32767);
     i         VARCHAR2(32767);
     j         VARCHAR2(32767);
     l_str     VARCHAR2(32767);
     l_wild    VARCHAR2(32767);
     flag      NUMBER(1) := 0;
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

    stmt := 'SELECT job_id FROM employees_bk1';

    OPEN c1 FOR stmt;
    LOOP
       FETCH c1 INTO g_job;
       EXIT WHEN c1%NOTFOUND;

       BEGIN
           EXECUTE IMMEDIATE 'SELECT Length('''||g_job||''') FROM dual' INTO i;
           FOR j IN 1..i
           LOOP
              BEGIN
                  EXECUTE IMMEDIATE 'SELECT substr('''||g_job||''','||j||',1) FROM dual' INTO str;

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
    TYPE c_type IS TABLE OF employees.commission_pct%TYPE;
    TYPE d_type IS TABLE OF employees.hire_date%TYPE;
    c_pct       c_type;
    h_date      d_type;
    CURSOR cur  IS SELECT Nvl(commission_pct,0) commission_pct, hire_date FROM employees;
BEGIN
    OPEN cur;
       FETCH cur BULK COLLECT INTO c_pct,h_date;
    CLOSE cur;
    FOR i IN c_pct.FIRST .. c_pct.LAST
    LOOP
        IF c_pct(i) = .3 THEN
          Dbms_Output.Put_Line(c_pct(i));
        END IF;
    END LOOP;
    FOR i IN h_date.FIRST .. h_date.LAST
    LOOP
       IF (h_date(i) = '2005/11/11') THEN
          Dbms_Output.Put_Line(h_date(i));
       END IF;
    END LOOP;
END;
/
