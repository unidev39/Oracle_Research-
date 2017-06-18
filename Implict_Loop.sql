1.LOOP Statements :Loop statements run the same statements with a series of different values. The loop statements are:
	*Basic LOOP
	*FOR LOOP
	*WHILE LOOP

2.The statements that exit a loop are:
	*EXIT
	*EXIT WHEN

3.The statements that exit the current iteration of a loop are:
	*CONTINUE
	*CONTINUE WHEN

EXIT, EXIT WHEN, CONTINUE, and CONTINUE WHEN and can appear anywhere inside a loop, but not outside a loop.
Oracle recommends using these statements instead of the "GOTO Statement", which can exit a loop or the current iteration of a loop by transferring
control to a statement outside the loop. (A raised exception also exits a loop.

LOOP statements can be labeled, and LOOP statements can be nested. Labels are recommended for nested loops to improve readability.
You must ensure that the label in the END LOOP statement matches the label at the beginning of the same loop statement (the compiler does not check).

4.Topics:
	*Basic LOOP Statement
	*EXIT Statement
	*EXIT WHEN Statement
	*CONTINUE Statement
	*CONTINUE WHEN Statement
	*FOR LOOP Statement
	*WHILE LOOP Statement

4.1.Basic LOOP Statement
The basic LOOP statement has this structure:
Syntax :
[ label ] LOOP
statements
END LOOP [ label ];
With each iteration of the loop, the statements run and control returns to the top of the loop. To prevent an infinite loop,
a statement or raised exception must exit the loop.

With each iteration of the basic LOOP statement, its statements run and control returns to the top of the loop. The LOOP statement
ends when a statement inside the loop transfers control outside the loop or when PL/SQL raises an exception.

To prevent an infinite loop, at least one statement must transfer control outside the loop. The statements that can transfer control
outside the loop are:
	*"CONTINUE Statement" (when it transfers control to the next iteration of an enclosing labeled loop)
	*"EXIT Statement"
	*"GOTO Statement"
	*"RAISE Statement"
4.1.1.Processing a Query Result Set One Row at a Time
PL/SQL lets you issue a SQL query and process the rows of the result set one at a time. You can use a basic loop,
as in Example 1-2, or you can control the process precisely by using individual statements to run the query, retrieve the results,
and finish processing.

Example 1-2 Processing Query Result Rows One at a Time
BEGIN
    FOR someone IN (SELECT * FROM employees WHERE employee_id < 120 ORDER BY employee_id)
    LOOP
    	dbms_output.put_line('First name = '||someone.first_name||', Last name = '||someone.last_name);
    END LOOP;
END;
/
/*
First name = Steven,      Last name = King
First name = Neena,       Last name = Kochhar
First name = Lex,         Last name = De Haan
First name = Alexander,   Last name = Hunold
First name = Bruce,       Last name = Ernst
First name = David,       Last name = Austin
First name = Valli,       Last name = Pataballa
First name = Diana,       Last name = Lorentz
First name = Nancy,       Last name = Greenberg
First name = Daniel,      Last name = Faviet
First name = John,        Last name = Chen
First name = Ismael,      Last name = Sciarra
First name = Jose Manuel, Last name = Urman
First name = Luis,        Last name = Popp
First name = Den,         Last name = Raphaely
First name = Alexander,   Last name = Khoo
First name = Shelli,      Last name = Baida
First name = Sigal,       Last name = Tobias
First name = Guy,         Last name = Himuro
First name = Karen,       Last name = Colmenares
*/

4.1.2.CONTINUE Statement
The CONTINUE statement exits the current iteration of a loop unconditionally and transfers control to the next iteration of either the current loop
or an enclosing labeled loop.
In Example 4-12, the CONTINUE statement inside the basic LOOP statement transfers control unconditionally to the next iteration of the current loop.

Example 4-12 CONTINUE Statement in Basic LOOP Statement

DECLARE
	l_x NUMBER := 0;
BEGIN
    LOOP -- After CONTINUE statement, control resumes here
    	dbms_output.put_line ('Inside loop:  l_x = ' || TO_CHAR(l_x));
    	l_x := l_x + 1;
    	IF l_x < 3 THEN
    	   CONTINUE;
    	END IF;
    	dbms_output.put_line('Inside loop, after CONTINUE:  l_x = ' ||TO_CHAR(l_x));
    	EXIT WHEN l_x = 5;
    END LOOP;
dbms_output.put_line (' After loop:  l_x = ' || TO_CHAR(l_x));
END;
/
      
/*
Inside loop:  l_x = 0
Inside loop:  l_x = 1
Inside loop:  l_x = 2
Inside loop,  after CONTINUE:  l_x = 3
Inside loop:  l_x = 3
Inside loop,  after CONTINUE:  l_x = 4
Inside loop:  l_x = 4
Inside loop,  after CONTINUE:  l_x = 5
After loop:   l_x = 5
*/

4.1.3.CONTINUE WHEN Statement
The CONTINUE WHEN statement exits the current iteration of a loop when the condition in its WHEN clause is true, and transfers control to
the next iteration of either the current loop or an enclosing labeled loop.
Each time control reaches the CONTINUE WHEN statement, the condition in its WHEN clause is evaluated. If the condition is not true,
the CONTINUE WHEN statement does nothing.
In Example 4-13, the CONTINUE WHEN statement inside the basic LOOP statement transfers control to the next iteration of the current loop when
l_x is less than 3.

Example 4-13 CONTINUE WHEN Statement in Basic LOOP Statement

DECLARE
	l_x NUMBER := 0;
BEGIN
	LOOP -- After CONTINUE statement, control resumes here
	   dbms_output.put_line ('Inside loop:  l_x = '||TO_CHAR(l_x));
	   l_x := l_x + 1;
	   CONTINUE WHEN l_x < 3;
	   dbms_output.put_line('Inside loop, after CONTINUE:  l_x = '||TO_CHAR(l_x));
	   EXIT WHEN l_x = 5;
	END LOOP;
	dbms_output.put_line (' After loop:  l_x = '||TO_CHAR(l_x));
END;
/
      
/*
Inside loop:  l_x = 0
Inside loop:  l_x = 1
Inside loop:  l_x = 2
Inside loop,  after CONTINUE:  l_x = 3
Inside loop:  l_x = 3
Inside loop,  after CONTINUE:  l_x = 4
Inside loop:  l_x = 4
Inside loop,  after CONTINUE:  l_x = 5
After loop:   l_x = 5
*/

4.1.4.EXIT Statement
The EXIT statement exits the current iteration of a loop unconditionally and transfers control to the end of either the current loop
or an enclosing labeled loop.
In Example 4-9, the EXIT statement inside the basic LOOP statement transfers control unconditionally to the end of the current loop.

Example 4-9 Basic LOOP Statement with EXIT Statement

DECLARE
    l_x NUMBER := 0;
BEGIN
    LOOP
    	dbms_output.put_line ('Inside loop:  l_x = '||TO_CHAR(l_x));
    	l_x := l_x + 1;
    	IF l_x > 3 THEN
    	   EXIT;
    	END IF;
    END LOOP;
    -- After EXIT, control resumes here
    dbms_output.put_line(' After loop:  l_x = '||TO_CHAR(l_x));
END;
/
      
/*
Inside loop:  l_x = 0
Inside loop:  l_x = 1
Inside loop:  l_x = 2
Inside loop:  l_x = 3
After loop:   l_x = 4
*/

4.1.5.EXIT WHEN Statement
The EXIT WHEN statement exits the current iteration of a loop when the condition in its WHEN clause is true, and transfers control to the end of
either the current loop or an enclosing labeled loop.
Each time control reaches the EXIT WHEN statement, the condition in its WHEN clause is evaluated. If the condition is not true, the EXIT WHEN
statement does nothing. To prevent an infinite loop, a statement inside the loop must make the condition true, as in Example 4-10.
In Example 4-10, the EXIT WHEN statement inside the basic LOOP statement transfers control to the end of the current loop when l_x is greater than 3.

Example 4-10 Basic LOOP Statement with EXIT WHEN Statement

DECLARE
	l_x NUMBER := 0;
BEGIN
	LOOP
		dbms_output.put_line('Inside loop:  l_x = ' || TO_CHAR(l_x));
		l_x := l_x + 1;  -- prevents infinite loop
		EXIT WHEN l_x > 3;
	END LOOP;
	-- After EXIT statement, control resumes here
	dbms_output.put_line('After loop:  l_x = ' || TO_CHAR(l_x));
END;
/
      
/*
Inside loop:  l_x = 0
Inside loop:  l_x = 1
Inside loop:  l_x = 2
Inside loop:  l_x = 3
After loop:   l_x = 4
*/

4.1.6.One basic LOOP statement is nested inside the other, and both have labels. The inner loop has two EXIT WHEN statements;
one that exits the inner loop and one that exits the outer loop.

Example 4-11 Nested, Labeled Basic LOOP Statements with EXIT WHEN Statements
DECLARE
	l_s  PLS_INTEGER := 0;
	l_i  PLS_INTEGER := 0;
	l_j  PLS_INTEGER;
BEGIN
	<<outer_loop>>
	LOOP
	   l_i := l_i + 1;
	   l_j := 0;
	   <<inner_loop>>
	   LOOP
	      l_j := l_j + 1;
	      l_s := l_s + l_i * l_j; -- Sum several products
	      EXIT inner_loop WHEN (l_j > 5);
	      EXIT outer_loop WHEN ((l_i * l_j) > 15);
	   END LOOP inner_loop;
	END LOOP outer_loop;
	dbms_output.put_line('The sum of products equals: '||TO_CHAR(l_s));
END;
/

/*
The sum of products equals: 166
*/

4.1.7.GOTO Statement
The GOTO statement transfers control to a label unconditionally. The label must be unique in its scope and must precede an executable statement
or a PL/SQL block. When run, the GOTO statement transfers control to the labeled statement or block. For GOTO statement restrictions,
see "GOTO Statement".
Use GOTO statements sparingly—overusing them results in code that is hard to understand and maintain. Do not use a GOTO statement to transfer
control from a deeply nested structure to an exception handler. Instead, raise an exception. For information about the
PL/SQL exception-handling mechanism, see Chapter 11, "PL/SQL Error Handling."

Example 4-28 GOTO STATEMENT

DECLARE
	l_p  VARCHAR2(30);
	l_n  PLS_INTEGER := 37;
BEGIN
	FOR l_j in 2..ROUND(SQRT(l_n)) LOOP
		IF l_n MOD l_j = 0 THEN
		   l_p := ' is not a prime number';
		GOTO print_now;
		END IF;
	END LOOP;
	l_p := ' is a prime number';
	<<print_now>>
	dbms_output.put_line(TO_CHAR(l_n) || l_p);
END;
/

/*
37 is a prime number
*/

4.1.7.1.A label can appear only before a block or before a statement (as in Example 4-28), not in a statement,
as in Example 4-29.

Example 4-29 Incorrect Label Placement

DECLARE
	l_condition  BOOLEAN;
BEGIN
	FOR l_i IN 1..50 LOOP
		IF l_condition THEN
		   GOTO end_loop;
		END IF;
		<<end_loop>>
	END LOOP;
END;
/

/*
END LOOP;
*
ERROR at line 9:
ORA-06550: line 9, column 3:
PLS-00103: Encountered the symbol "END" when expecting one of the following:
( begin case declare exit for goto if loop mod null raise
return select update while with <an identifier>
<a double-quoted delimited-identifier> <a bind variable> <<
continue close current delete fetch lock insert open rollback
savepoint set sql run commit forall merge pipe purge
To correct Example 4-29, add a NULL statement, as in Example 4-30.
*/

Example 4-30 NULL Statement Allows GOTO to Label

DECLARE
	l_condition  BOOLEAN;
BEGIN
	FOR l_i IN 1..50 LOOP
		IF l_condition THEN
		   GOTO end_loop;
		END IF;
		<<end_loop>>
		NULL;
	END LOOP;
END;
/

4.1.7.2.A GOTO statement can transfer control to an enclosing block from the current block, as in Example 4-31.

Example 4-31 GOTO Statement Transfers Control to Enclosing Block

DECLARE
	l_last_name  VARCHAR2(25);
	l_emp_id     NUMBER(6) := 120;
BEGIN
	<<get_name>>
	SELECT
	     last_name
    INTO
	     l_last_name
	FROM
	     employees
	WHERE
	     employee_id = l_emp_id;
    BEGIN
		dbms_output.put_line (l_last_name);
		l_emp_id := l_emp_id + 5;
		IF l_emp_id < 120 THEN
		   GOTO get_name;
		END IF;
	END;
END;
/

/*
Weiss
*/

4.1.7.3.The GOTO statement transfers control to the first enclosing block in which the referenced label appears.
The GOTO statement in Example 4-32 transfers control into an IF statement, causing an error.

Example 4-32 GOTO Statement Cannot Transfer Control into IF Statement

DECLARE
	l_valid BOOLEAN := TRUE;
BEGIN
	GOTO update_row;
	IF l_valid THEN
             <<update_row>>
	   NULL;
	END IF;
END;
/

/*
GOTO update_row;
*
ERROR at line 4:
ORA-06550: line 4, column 3:
PLS-00375: illegal GOTO statement; this GOTO cannot transfer control to label
'UPDATE_ROW'
ORA-06550: line 6, column 12:
PL/SQL: Statement ignored
NULL Statement
*/

--Correct Result
DECLARE
    l_valid BOOLEAN := TRUE;
BEGIN
	GOTO update_row;
    <<update_row>>
	IF l_valid THEN
       dbms_output.put_line(1);
	END IF;
END;
/

5.WHILE LOOP Statement
The WHILE LOOP statement runs one or more statements while a condition is true. It has this structure:
[ label ] WHILE condition LOOP
  statements
END LOOP [ label ];

If the condition is true, the statements run and control returns to the top of the loop, where condition is evaluated again. 
If the condition is not true, control transfers to the statement after the WHILE LOOP statement. To prevent an infinite loop, a statement 
inside the loop must make the condition false or null. For complete syntax, see "WHILE LOOP Statement".
An EXIT, EXIT WHEN, CONTINUE, or CONTINUE WHEN in the statements can cause the loop or the current iteration of the loop to end early.
In Example 4-27, the statements in the first WHILE LOOP statement never run, and the statements in the second WHILE LOOP statement run once.

Example 4-27 WHILE LOOP Statements

DECLARE
    l_condition  BOOLEAN := FALSE;
BEGIN
    WHILE l_condition LOOP
      DBMS_OUTPUT.PUT_LINE ('This line does not print.');
      l_condition := TRUE;  -- This assignment is not made.
    END LOOP;
    
    WHILE NOT l_condition LOOP
      DBMS_OUTPUT.PUT_LINE ('Hello, world!');
      l_condition := TRUE;
    END LOOP;
END;
/
      
/*
Hello, world!
*/
		
--Exit
DECLARE
   l_i  NUMBER := 0;
BEGIN
   <<i_l>>
   LOOP
      l_i := l_i + 1;
      Dbms_Output.Put_Line('B'||l_i);
      IF l_i > 3 THEN
         EXIT;
      END IF;
   END LOOP;
   Dbms_Output.Put_Line('A'||l_i);
END;
/

--Exit when
DECLARE
    l_i  NUMBER := 0;
BEGIN
    LOOP
       l_i := l_i + 1;
       Dbms_Output.Put_Line('inside loop : '||l_i);
       EXIT WHEN (l_i > 3 );
    END LOOP;
    Dbms_Output.Put_Line('after loop : '||l_i);
END;
/

--CONTINUE
DECLARE
    l_i  NUMBER := 0;
BEGIN
    LOOP
       l_i := l_i + 1;
       Dbms_Output.Put_Line('inside loop: '||l_i);
       IF l_i < 3 THEN
          CONTINUE;
       END IF;
       Dbms_Output.Put_Line('inside loop after continue: '||l_i);
       EXIT WHEN l_i = 5;
    END LOOP;
    Dbms_Output.Put_Line('outside loop: '||l_i);
END;
/

--CONTINUE WHEN
DECLARE
    l_i    NUMBER := 0;
BEGIN
    LOOP
       l_i := l_i +1;
       Dbms_Output.Put_Line('inside loop: '||l_i);
       CONTINUE WHEN l_i < 3;
       Dbms_Output.Put_Line('inside loop after CONTINUE: '||l_i);
       EXIT WHEN l_i = 5;
       Dbms_Output.Put_Line('after loop: '||l_i);
    END LOOP;
END;
/

--GO TO
--to find odd and even number
BEGIN
     FOR l_j IN 1..200
     LOOP
        IF( Mod(l_j,2) = 0 ) THEN
          Dbms_Output.Put_Line(l_j);
        END IF;
        EXIT WHEN l_j = 99;
     END LOOP;
      Dbms_Output.Put_Line('odd begins from here ');
      FOR l_i IN 1..200
      LOOP
         IF (Mod(l_i,2) <> 0) THEN
            Dbms_Output.Put_Line(l_i);
         END IF;
         EXIT WHEN l_i = 99;
      END LOOP;
END;
/

--GOTO
BEGIN
    FOR l_i IN 1..100
    LOOP
    Dbms_Output.Put_Line(l_i);
       IF( l_i > 50) THEN
          GOTO out_loop;
       END IF;
    <<out_loop>>
    EXIT WHEN l_i =  80;
    END LOOP;
END;
/

DECLARE
    l_employeeid NUMBER;
    l_salary     NUMBER;
BEGIN
    SELECT
        employee_id,
        salary
    INTO
        l_employeeid,
        l_salary
    FROM
        employees
    WHERE
        ROWNUM<=1;
    
	Dbms_Output.Put_Line(l_employeeid);
    Dbms_Output.Put_Line(l_salary);
    Dbms_Output.Put_Line(l_employeeid||'+'||l_salary);

    FOR l_i IN 1..10 -- l_i - is defind or not defind in declare part (Choise is yours)
    LOOP
        Dbms_Output.Put_Line(l_employeeid||'   '||l_salary);
    END LOOP;

END;
/

DECLARE
    l_message   VARCHAR2(100);
    l_message2  VARCHAR2(100);
BEGIN
    FOR l_i IN (SELECT salary FROM employees)
    LOOP
       Dbms_Output.Put_Line(l_i.salary);
    END LOOP;
END;
/

DECLARE
    l_message   VARCHAR2(100);
    l_message2  VARCHAR2(100);
BEGIN
    FOR l_i IN (SELECT salary FROM employees)
    LOOP
       Dbms_Output.Put_Line(l_i.salary*10);
    END LOOP;
END;
/

DECLARE
    l_message     VARCHAR2(100);
    l_message2    VARCHAR2(100);
BEGIN
    FOR l_i IN (SELECT 10*salary AS sal FROM employees)
    LOOP
       Dbms_Output.Put_Line(l_i.sal);
    END LOOP;
END;
/

BEGIN
    FOR l_i IN 1..5    -- to print 5 times the same value
    LOOP
       Dbms_Output.Put_Line(l_i);
    END LOOP;
END;
/

BEGIN
    FOR l_i IN REVERSE 1..5
    LOOP
       Dbms_Output.Put_Line(l_i);
    END LOOP;
END;
/


-- Nested loop
DECLARE
    l_message    VARCHAR2(100);
    l_message2   VARCHAR2(100);
BEGIN
    FOR l_j IN 1..5    -- to print 5 times the same value
    LOOP
       FOR l_i IN (SELECT salary FROM employees)
       LOOP
          Dbms_Output.Put_Line(l_i.salary);
       END LOOP;
    END LOOP;
END;
/

-- Asici code conversion
BEGIN
    FOR l_i IN 1..1000
    LOOP
       Dbms_Output.Put_Line(l_i||' = '||Chr(l_i)); -- Asici code conversion
    END LOOP;
END;
/

-- Sys privilege
BEGIN
    FOR l_i in (SELECT privilege FROM dba_sys_privs)
    LOOP
       BEGIN
           EXECUTE IMMEDIATE 'GRANT '||l_i.privilege||' TO HR';
           Dbms_Output.Put_Line('GRANT '||l_i.privilege||' TO HR');
       EXCEPTION WHEN OTHERS THEN
           NULL;
       END;
   END LOOP;
END;
/

--Seperate the character and number from the given string( Ora3cle1Ro2cker9 ) and store in the table character_number with s_character and s_number columns
--Ora3cle1Ro2cker9

DECLARE
    g_string_i        VARCHAR2(200) := 'Ora3cle1Ro2cker9';
    g_string_length   NUMBER;
    l_sub_value             VARCHAR2(20);
    l_total_no        NUMBER ;
    l_total_sum       NUMBER := 0;
    l_exc_char        VARCHAR2(200);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE character_number PURGE';
    EXCEPTION WHEN OTHERS THEN
        Dbms_Output.Put_Line(SQLERRM);
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE character_number
                      (
                        s_character  VARCHAR2(20),
                        s_number     NUMBER
                       )NOLOGGING';
    Dbms_Output.Put_Line('character_number table created');
    g_string_length := Length(g_string_i);
    FOR len IN 1..g_string_length
    LOOP
       BEGIN
           l_sub_value := SubStr(g_string_i,len,1);
           EXECUTE IMMEDIATE 'SELECT To_Number('||l_sub_value||') FROM dual' INTO l_total_no;
           EXECUTE IMMEDIATE 'INSERT INTO character_number(s_number) VALUES ('||l_total_no||')';
           l_total_sum := l_total_sum + l_total_no;
       EXCEPTION WHEN OTHERS THEN
           l_exc_char := l_exc_char||l_sub_value;
           EXECUTE IMMEDIATE 'INSERT INTO character_number (s_character) VALUES ('''||l_sub_value||''')';
       END;
    END LOOP;
    Dbms_Output.Put_Line('String :'||l_exc_char);
    Dbms_Output.Put_Line('Total no :'||l_total_sum);
    EXECUTE IMMEDIATE 'INSERT INTO character_number(s_character,s_number) VALUES ('''||l_exc_char||''','||l_total_sum||')';
END;
/

--Extract number, character, and wildcard character and concate then seperately and the number digit should be apper in the whole number not the seperate value of number.
DECLARE
    l_string_i      VARCHAR2(200) := '1234_O.201.ra300000#cle1@Ro$cker92^';
    l_length        NUMBER;
    l_sub_value     VARCHAR2(20);
    l_total_no      NUMBER ;
    l_total_sum     NUMBER := 0;
    l_string_o      VARCHAR2(200);
    l_wildcard      VARCHAR2(200);
    l_flag          VARCHAR2(200):=0;
BEGIN
    l_length := Length(l_string_i);
    FOR l_i IN 1..l_length
    LOOP
       BEGIN
           l_sub_value := SubStr(l_string_i,l_i,1);
           IF (regexp_like(l_sub_value,'[[:digit:]]' ))THEN
               IF ( l_flag = 0) THEN
                  l_total_no := regexp_substr(l_string_i,'[[:digit:]]+',l_i);
                      Dbms_Output.Put_Line(l_total_no);
                  l_total_sum := l_total_sum + l_total_no;
                  l_flag := 1;
               END IF;
            ELSIF (regexp_like(l_sub_value,'^[A-Z]$','l_i')) THEN
                l_flag := 0;
                l_string_o := l_string_o ||l_sub_value;
             ELSE
                l_wildcard := l_wildcard || l_sub_value;
             END IF;
       END;
    END LOOP;
    Dbms_Output.Put_Line('String    : '||l_string_o);
    Dbms_Output.Put_Line('Wild card : '||l_wildcard);
    Dbms_Output.Put_Line('Total no  : '||l_total_sum);
END;
/

DECLARE
    p_string       VARCHAR2(32767) := 'A@a3h,klssss3t1!452#a1452g45g$';
    l_sumofnumbers NUMBER;
    l_string       VARCHAR2(32767);
    l_wildcard     VARCHAR2(32767);
BEGIN
    SELECT
         SUM(col1),
         listagg(col2, '') WITHIN GROUP(ORDER BY 1) col2,
         listagg(col3, '') WITHIN GROUP(ORDER BY 1) col3
    INTO
         l_sumofnumbers,
         l_string,
         l_wildcard
    FROM (
          SELECT
               regexp_substr(col, '[[:digit:]]+',1,LEVEL) col1,
               regexp_substr(col, '[[:alpha:]]+',1,LEVEL) col2,
               regexp_substr(col, '(\W)',1,LEVEL)         col3
          from
               (SELECT p_string col FROM dual)
          connect by level <= regexp_count(col, '[[:digit:]]')
         );
    dbms_output.put_line(l_sumofnumbers);
    dbms_output.put_line(l_string);
    dbms_output.put_line(l_wildcard);
END;
/

BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE external_student_list';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE external_student_list
                           (
                            beit    VARCHAR2(20),
                            civil   VARCHAR2(20),
                            elex    VARCHAR2(20),
                            comp    VARCHAR2(20)
                           )
                           ORGANIZATION EXTERNAL
                           (
                            TYPE ORACLE_LOADER
                            DEFAULT DIRECTORY DIR_NAME
                            ACCESS PARAMETERS
                            (
                             RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
                             SKIP 1
                             READSIZE 1048576
                             FIELDS TERMINATED BY '',''
                             OPTIONALLY ENCLOSED BY ''"'' LDRTRIM
                             REJECT ROWS WITH ALL NULL FIELDS
                            )
                            LOCATION (''STUDENT.csv'')
                           )REJECT LIMIT UNLIMITED';
    EXCEPTION WHEN OTHERS THEN
       NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE student_list';
	EXCEPTION WHEN OTHERS THEN
	    NULL;
    END;
    EXECUTE IMMEDIATE 'CREATE TABLE student_list
                       AS
                       SELECT * FROM external_student_list';

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE seat_plan';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE seat_plan
                       (
                        col1    VARCHAR2(20),
                        col2    VARCHAR2(20),
                        col3    VARCHAR2(20),
                        col4    VARCHAR2(20)
                       )';

    FOR l_i IN (SELECT ROWNUM rn,beit, civil, elex, comp  FROM student_list)
    LOOP
       IF (Mod(l_i.rn,2) = 0) THEN
           EXECUTE IMMEDIATE 'INSERT INTO seat_plan VALUES ('''||l_i.beit||''', '''||l_i.civil||''','''|| l_i.comp||''','''|| l_i.elex||''')';
		   COMMIT;
       ELSE
           EXECUTE IMMEDIATE 'INSERT INTO seat_plan VALUES ('''||l_i.civil||''', '''||l_i.beit||''','''|| l_i.elex||''','''|| l_i.comp||''')';
		   COMMIT;
       END IF;
    END LOOP;
END;
/

BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE student_list';
	EXCEPTION WHEN OTHERS THEN
	    NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE student_list
                       (
                         beit,
                         civil,
                         elex,
                         comp
                       )
                       AS
                       SELECT ''BEIT10/101'', ''CIVIL10/101'', ''ELX10/101'', ''COMP10/101'' FROM dual UNION ALL
                       SELECT ''BEIT10/102'', ''CIVIL10/102'', ''ELX10/102'', ''COMP10/102'' FROM dual UNION ALL
                       SELECT ''BEIT10/103'', ''CIVIL10/103'', ''ELX10/103'', ''COMP10/103'' FROM dual UNION ALL
                       SELECT ''BEIT10/104'', ''CIVIL10/104'', ''ELX10/104'', ''COMP10/104'' FROM dual UNION ALL
                       SELECT ''BEIT10/105'', ''CIVIL10/105'', ''ELX10/105'', ''COMP10/105'' FROM dual UNION ALL
                       SELECT ''BEIT10/106'', ''CIVIL10/106'', ''ELX10/106'', ''COMP10/106'' FROM dual UNION ALL
                       SELECT ''BEIT10/107'', ''CIVIL10/107'', ''ELX10/107'', ''COMP10/107'' FROM dual UNION ALL
                       SELECT ''BEIT10/108'', ''CIVIL10/108'', ''ELX10/108'', ''COMP10/108'' FROM dual UNION ALL
                       SELECT ''BEIT10/109'', ''CIVIL10/109'', ''ELX10/109'', ''COMP10/109'' FROM dual UNION ALL
                       SELECT ''BEIT10/110'', ''CIVIL10/110'', ''ELX10/110'', ''COMP10/110'' FROM dual UNION ALL
                       SELECT ''BEIT10/111'', ''CIVIL10/111'', ''ELX10/111'', ''COMP10/111'' FROM dual UNION ALL
                       SELECT ''BEIT10/112'', ''CIVIL10/112'', ''ELX10/112'', ''COMP10/112'' FROM dual UNION ALL
                       SELECT ''BEIT10/113'', ''CIVIL10/113'', ''ELX10/113'', ''COMP10/113'' FROM dual UNION ALL
                       SELECT ''BEIT10/114'', ''CIVIL10/114'', ''ELX10/114'', ''COMP10/114'' FROM dual UNION ALL
                       SELECT ''BEIT10/115'', ''CIVIL10/115'', ''ELX10/115'', ''COMP10/115'' FROM dual UNION ALL
                       SELECT ''BEIT10/116'', ''CIVIL10/116'', ''ELX10/116'', ''COMP10/116'' FROM dual UNION ALL
                       SELECT ''BEIT10/117'', ''CIVIL10/117'', ''ELX10/117'', ''COMP10/117'' FROM dual UNION ALL
                       SELECT ''BEIT10/118'', ''CIVIL10/118'', ''ELX10/118'', ''COMP10/118'' FROM dual UNION ALL
                       SELECT ''BEIT10/119'', ''CIVIL10/119'', ''ELX10/119'', ''COMP10/119'' FROM dual UNION ALL
                       SELECT ''BEIT10/120'', ''CIVIL10/120'', ''ELX10/120'', ''COMP10/120'' FROM dual UNION ALL
                       SELECT ''BEIT10/121'', NULL,NULL,NULL FROM dual';

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE seat_plan';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE seat_plan
                       (
                         col1    VARCHAR2(20),
                         col2    VARCHAR2(20),
                         col3    VARCHAR2(20),
                         col4    VARCHAR2(20)
                       )';

     FOR l_i IN (SELECT ROWNUM rn,beit, civil, elex, comp  FROM student_list)
     LOOP
        IF (Mod(l_i.rn,2) = 0) THEN
            EXECUTE IMMEDIATE 'INSERT INTO seat_plan VALUES ('''||l_i.beit||''', '''||l_i.civil||''','''|| l_i.comp||''','''|| l_i.elex||''')';
			COMMIT;
        ELSE
            EXECUTE IMMEDIATE 'INSERT INTO seat_plan VALUES ('''||l_i.civil||''', '''||l_i.beit||''','''|| l_i.elex||''','''|| l_i.comp||''')';
			COMMIT;
        END IF;
     END LOOP;
END;
/
