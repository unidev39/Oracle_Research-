/*
UTL_FILE: Reading and Writing Server-side Files
UTL_FILE is a package that has been welcomed warmly by PL/SQL developers. It allows PL/SQL programs to both read from and write to any 
operating system files that are accessible from the server on which your database instance is running. File l_i/O was a feature long 
desired IN PL/SQL. You can now read IN files and interact with the operating system a little more easily than has been possible IN the 
past. You can load data from files directly into database tables while applying the full power and flexibility of PL/SQL programming. 
You can generate reports directly from within PL/SQL without worrying about the maximum buffer restrictions of DBMS_OUTPUT

Getting Started with UTL_FILE :
The UTL_FILE package is created when the Oracle database is installed. The utlfile.sql script (found IN the built-IN packages source code 
directory) contains the source code FOR this package's specification. This script is called by catproc.sql , which is normally run 
immediately after database creation. The script creates the public synonym UTL_FILE FOR the package and grants EXECUTE privilege on the 
package to public. All Oracle users can reference and make use of this package.

UTL_FILE Programs Description Use IN PL\SQL :

FCLOSE         : Closes the specified files
FCLOSE_ALL     : Closes all open files
FFLUSH         : Flushes all the data from the UTL_FILE buffer
FOPEN          : Opens the specified file
GET_LINE       : Gets the next line from the file
IS_OPEN        : Returns TRUE if the file is already open
NEW_LINE       : Inserts a newline mark IN the file at the END of the current line
PUT            : Puts text into the buffer
PUT_LINE       : Puts a line of text into the file
PUTF           : Puts formatted text into the buffer
FCOPY          : Copies a contiguous portion of a file to a newly created file
FGETATTR       : Reads and returns the attributes of a disk file
FGETPOS        : Returns the current relative offset position within a file, IN bytes
FOPEN_NCHAR    : Open a file FOR multibyte characters
                 Note: since NCHAR contains mutibyte character, 
                 it is recommended that the max_linesize be less than 6400.
FREMOVE        : Delete An Operating System File
FRENAME        : Rename An Operating System File
FSEEK          : Adjusts the file pointer forward or backward within the file by the number of bytes specified 
GETLINE        : Read a Line from a file
GETLINE_NCHAR  : Read a line from a file containing multi-byte characters
GET_RAW        : Reads a RAW string value from a file and adjusts the file pointer ahead by the number of bytes read
PUT_NCHAR      : Writes a Unicode string to a file
PUT_RAW        : Accepts as input a RAW data value and writes the value to the output buffer
PUT_LINE_NCHAR : Writes a Unicode line to a file
PUTF_NCHAR     : Writes a Unicode string to a file

Open Modes :    
A    : Append Text / add new to the existing
R    : Read Text
W    : Write Text / overwrite /create new file
RB  : read binary data
WB  : write binary data

UTL_FILE exceptions :
The package specification of UTL_FILE defines seven exceptions. The cause behind a UTL_FILE exception can often be difficult to understand. 
Here are the explanations Oracle provides FOR each of the exceptions:

INVALID_PATH         : The file location or the filename is invalid. Perhaps the directory is not listed as a utl_file_dir parameter IN the 
                       INIT.ORA file (or doesn't exist as all), or you are trying to read a file and it does not exist.
INVALID_MODE         : The value you provided FOR the open_mode parameter IN utl_file.fopen was invalid. It must be 'A' ,'R' ,'W' , 'RB' 'WB'
INVALID_FILEHANDLE   : The file handle you passed to a UTL_FILE program was invalid. You must call utl_file.fopen to obtain a valid file 
                       handle.
INVALID_OPERATION    : UTL_FILE could not open or operate on the file as requested. FOR example, if you try to write to a read-only file, 
                       you will raise this exception.
READ_ERROR           : The operating system returned an error when you tried to read from the file. (This does not occur very often.)
WRITE_ERROR          : The operating system returned an error when you tried to write to the file. (This does not occur very often.)
INTERNAL_ERROR       : Something went wrong and the PL/SQL runtime engine couldn't assign blame to any of the previous exceptions. 
                       Better call Oracle Support!
NO_DATA_FOUND        : Raised when you read past the END of the file with utl_file.get_line.
VALUE_ERROR          : Raised when you try to read or write lines IN the file which are too long. The current implementation of 
                       UTL_FILE limits the size of a line read by utl_file.get_line to 1022 bytes.
INVALID_MAXLINESIZE  : Raised when you try to open a file with a maximum linesize outside of the valid range (between 1 through 999999999).
Note                 : IN the following descriptions of the UTL_FILE programs, l_i list the exceptions that can be raised by each individual 
                       program.

*/

-- CREATE A DIRECTORY and Grant on DIRECTORY
CREATE DIRECTORY DIR_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';

-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250);
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','R');
     utl_file.get_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler utl_file.file_type;
    l_newLine   VARCHAR2(250);
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'R');
    LOOP
       BEGIN
           utl_file.get_line(l_inhandler, l_newLine);
           dbms_output.put_line(l_newLine);
       EXCEPTION WHEN OTHERS THEN
           EXIT;
       END;
    END LOOP;
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     utl_file.put_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     FOR l_i IN 1 .. 10
     LOOP
        utl_file.put_line(l_inhandler,l_newLine);
     END LOOP;
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     utl_file.put_line(l_inhandler,l_newLine||' \n');
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler  utl_file.file_type;
    l_outhandle  VARCHAR2(250) := 'ASDF'; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'W');
    utl_file.put_line(l_inhandler,l_outhandle);
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler   utl_file.file_type;
    l_outhandle   VARCHAR2(250) := 'ASDF'; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'W');
    FOR l_i IN 1 .. 10
    LOOP
       utl_file.put_line(l_inhandler,l_outhandle);
    END LOOP;
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler  utl_file.file_type;
    l_outhandle  utl_file.file_type; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'SIZE.txt', 'R');
    l_outhandle := utl_file.fopen('DIR_NAME', 'TAB.txt', 'W');

    IF utl_file.is_open(l_inhandler) THEN
       utl_file.fcopy('DIR_NAME', 'SIZE.txt', 'DIR_NAME', 'TAB.txt');
       utl_file.fclose(l_inhandler);
       dbms_output.put_line('Closed l_inhandler');
    END IF;
    
    utl_file.fclose_all;
    dbms_output.put_line('Closed l_inhandler,l_outhandle');

END;
/


DECLARE
    l_inhandler utl_file.file_type;
    l_outhandle VARCHAR2(200) := '';
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','W');
    FOR l_i IN (SELECT 
                   table_name||'  =  '||owner AS tablename_with_owner 
              FROM 
                   ALL_TAB_COLS 
              ORDER BY owner)
    LOOP
        l_outhandle := l_i.tablename_with_owner;
        utl_file.put_line(l_inhandler,l_outhandle);
    END LOOP;
    utl_file.fclose(l_inhandler);
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_ex    BOOLEAN;
    l_flen  NUMBER;
    l_bsize NUMBER; 
BEGIN
    utl_file.fgetattr('DIR_NAME', 'PIPE.txt', l_ex, l_flen, l_bsize);
    
    IF l_ex THEN
      dbms_output.put_line('File Exists');
    ELSE
      dbms_output.put_line('File Does Not Exist');
    END IF;
    dbms_output.put_line('File Length: ' || TO_CHAR(l_flen));
    dbms_output.put_line('Block Size: ' || TO_CHAR(l_bsize));
END;
/

BEGIN
    utl_file.fremove('DIR_NAME', 'PIPE.txt');
END;
/

BEGIN
    utl_file.frename('DIR_NAME','TAB.txt','DIR_NAME','TAB1111.txt',TRUE);
END;
/

DECLARE
    l_infile   utl_file.file_type;
    l_outfile  utl_file.file_type;
    l_newLine  VARCHAR2(4000);
    l_i        PLS_INTEGER;
    l_j        PLS_INTEGER := 0;
    l_seekflag BOOLEAN := TRUE;
BEGIN
    -- open a file to read
    l_infile := utl_file.fopen('DIR_NAME', 'SIZE.txt','r');
    -- open a file to write
    l_outfile := utl_file.fopen('DIR_NAME', 'TAB.txt', 'w');
    
    -- if the file to read was successfully opened
    IF utl_file.is_open(l_infile) THEN
      -- LOOP through each line IN the file
      LOOP
         BEGIN
             utl_file.get_line(l_infile, l_newLine);
             
             l_i := utl_file.fgetpos(l_infile);
             dbms_output.put_line(TO_CHAR(l_i));
             
             utl_file.put_line(l_outfile, l_newLine, FALSE);
             utl_file.fflush(l_outfile);
             
             IF l_seekflag = TRUE THEN
                utl_file.fseek(l_infile, NULL, -30);
                l_seekflag := FALSE;
             END IF;
         EXCEPTION WHEN NO_DATA_FOUND THEN
             EXIT;
         END;
      END LOOP;
      COMMIT;
    END IF;
    utl_file.fclose(l_infile);
    utl_file.fclose(l_outfile);
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20099, 'Unknown UTL_FILE Error');
END;
/

DECLARE
    l_inhandler utl_file.file_type;
    l_outhandle VARCHAR2(32767);
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME','test.txt','W');
    l_outhandle := 'employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id';
    utl_file.put_line(l_inhandler,l_outhandle);
    FOR l_i IN (SELECT * FROM hr.employees ORDER BY 1)
    LOOP
        utl_file.put_line(l_inhandler,l_i.employee_id||',  '||l_i.first_name||',  '||l_i.last_name||',  '||l_i.email||',  '||l_i.phone_number||',  '||l_i.hire_date||',  '        ||l_i.job_id||',  '||l_i.salary||',  '||l_i.commission_pct||',  '||l_i.manager_id||',  '||l_i.department_id);
    END LOOP;
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler      utl_file.file_type;
    l_column_name    VARCHAR2(32767):= '';
    -- CREATING REFERENCE CURSOR --
    TYPE crs         IS REF cursor;
    r_crs            crs;
    l_sql            VARCHAR2(32767);
    l_column_data    VARCHAR2(32767);        
BEGIN
     -- LOOP TO FIND THE COLUMN_NAMES FROM TEST_TBL TABLE --
     FOR l_i IN(SELECT 
                     DISTINCT column_name 
                FROM 
                     all_tab_cols 
                WHERE 
                    upper(table_name) = 'EMPLOYEES' 
                AND 
                    UPPER(owner) = 'HR' 
                ORDER BY 
                    column_name)
     LOOP
         l_column_name := l_column_name||',  ''||'||l_i.column_name||'||''';
     END LOOP;
     -- SUBSTRING TO MANAGE THE column_name OF TEST_TBL TABLE -- 
     l_column_name := SUBSTR(SUBSTR(l_column_name,7),1,INSTR(SUBSTR(l_column_name,7),'||''',-1)-1);
     -- OPEN THE FILE OF GIVEN DIRECTORIES --      
     l_inhandler := utl_file.fopen('DIR_NAME','test.txt','W');
     -- REFERENCE LOOP TO COLLECT DATA FROM TEST_TBL TABLE --
     l_sql := 'SELECT '||l_column_name||' FROM HR.EMPLOYEES';
     OPEN r_crs FOR l_sql;
     LOOP
        FETCH r_crs INTO l_column_data;
        EXIT WHEN r_crs%NOTFOUND;
        -- WRITE THE DATA INTO LOCATED FILE TEST.TXT --
        BEGIN  
             utl_file.put_line(l_inhandler,l_column_data);
        END;
     END LOOP;
EXCEPTION WHEN NO_DATA_FOUND THEN
    -- CLOSE FILE TEST.TXT --
    utl_file.fclose(l_inhandler);
END;
/


-- Preapre a Insert Scripts While Data Migaration From Oracle to Rest DB
BEGIN
    FOR i IN (SELECT 
                  table_name,
                  owner
              FROM all_tables
              WHERE owner='NSHPL'
              AND table_name IN ('ACCOUNT_BALANCE','BANK_PARAMETER')
              ORDER BY table_name)
    LOOP
       BEGIN 
           DECLARE
               p_woner        VARCHAR2(30) := i.owner;
               p_table_name   VARCHAR2(30) := i.table_name; 
               l_query        VARCHAR2(32767);
               l_table_name   VARCHAR2(32767);
           BEGIN 
               SELECT        
                    ''''||Lower(a.query1)||'''' query,
                    table_name
                    INTO l_query,l_table_name
               FROM (
               SELECT 
                   Count(*) sn,
                   TABLE_NAME,
                   listagg(CASE WHEN DATA_TYPE='DATE' THEN DATE_COLUMN_NAME ELSE NULL_COLUMN_NAME END,',') WITHIN GROUP(ORDER BY TABLE_NAME,COLUMN_ID) query1
               FROM (
                     SELECT 
                          TABLE_NAME,
                          COLUMN_NAME,
                          COLUMN_ID,
                          DATA_TYPE,                                                     
                          '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE ''to_date(''''''||TO_CHAR('||column_name||'~''YYYY-MM-DD'')||'''''',''''YYYY-MM-DD'''')' ||''' END'||'||''''''' date_column_name,
                          '''''''||CASE WHEN '||COLUMN_NAME||' IS NULL THEN ''NULL'' ELSE REPLACE(TO_CHAR('||COLUMN_NAME||'),'''''''','''''''''''') END'||'||'''''''    null_column_name
                     FROM all_tab_cols
                     WHERE owner = p_woner
                     AND table_name = p_table_name
                    )
               GROUP BY TABLE_NAME
               ORDER BY TABLE_NAME) a;
           
               l_query := REPLACE(Lower(l_query),'~',',');
               DECLARE
                    l_inhandler     utl_file.file_type;
                    l_outhandle     VARCHAR2(32767);
                    TYPE cursor_rc  IS REF cursor;
                    l_cursor        cursor_rc;
                    l_sql           VARCHAR2(32767);
                    l_column_date   VARCHAR2(32767);
               BEGIN
                    l_inhandler := utl_file.fopen('DIR_NAME',l_table_name||'.sql','W');
                    l_sql := 'SELECT REPLACE(REPLACE(REPLACE('||l_query||',''''''null'''''',''NULL''),''''''to_date'',''to_date''),'''''')'''''','''''')'') column_date FROM '||p_woner||'.'||l_table_name;
                    Dbms_Output.Put_Line(l_sql);
                    
                    OPEN l_cursor FOR l_sql;
                    LOOP
                       FETCH l_cursor INTO l_column_date;
                       EXIT WHEN l_cursor%NOTFOUND;
                       utl_file.put_line(l_inhandler,'INSERT INTO '||p_woner||'.'||l_table_name||' VALUES ('||l_column_date||')');
                    END LOOP;
                    close l_cursor;
                    
               EXCEPTION WHEN NO_DATA_FOUND THEN
                    utl_file.fclose(l_inhandler);
               END;
           END;
       EXCEPTION WHEN OTHERS THEN 
          Dbms_Output.Put_Line(i.table_name);
       END;
    END LOOP;
EXCEPTION WHEN OTHERS THEN 
    Dbms_Output.Put_Line(SQLERRM);
END;
/

---------
BEGIN
    FOR i IN (SELECT 
                  table_name,
                  owner
              FROM all_tables
              WHERE owner='NSHPL'
              AND table_name IN ('ACCOUNT_BALANCE','BANK_PARAMETER','BILL','BILL_DETAIL','BRANCH_PERMISSIONS','BROKER_PARAMETER','BUY_SETTLEMENT','CALENDAR_PARAMETER','CAPITAL_GAIN_DETAIL','CAPITAL_GAIN_PARA','CHART_OF_ACCOUNT','COMMISSION','COMMISSION_RATE','COMPANY_PARAMETER','COMPANY_PARAMETER_LIST','COST_CENTER','COUNTRY','COUNTRY_DETAIL','CUSTOMER_CHILD_INFO','CUSTOMER_LEDGER','CUSTOMER_REGISTRATION','CUSTOMER_REGISTRATION_DETAIL','DAILY_CERTIFICATE','DAILY_TRANSACTION','DAILY_TRANSACTION_NO','DISTRICT_PARA','FILE_LOCATION','FISCAL_YEAR_PARA','GROUP_PARAMETER','LEDGER','PAYOUT_UPLOAD','RECEIPT_PAYMENT_DETAIL','RECEIPT_PAYMENT_SLIP','REFERRED_CUSTOMER_INFO',	'SECTOR_PARAMETER','SHARE_PARAMETER','SYSTEM_PARA','TAX_PARA','VOUCHER','VOUCHER_DETAIL','VOUCHER_PARTICULARS','VOUCHER_TRANSACTION')
              ORDER BY table_name)
    LOOP
        DECLARE 
             l_max_column_id NUMBER;
        BEGIN 
            SELECT 
                 MAX(column_id) INTO l_max_column_id 
            FROM all_tab_cols
            WHERE owner = i.owner
            AND table_name = i.table_name;
            
            IF (l_max_column_id >30 AND l_max_column_id <=60) THEN 
               BEGIN 
                  DECLARE
                      p_woner        VARCHAR2(30) := i.owner;
                      p_table_name   VARCHAR2(30) := i.table_name; 
                      l_query        VARCHAR2(32767);
                      l_query_next   VARCHAR2(32767);
                      l_table_name   VARCHAR2(32767);
                  BEGIN
                      SELECT
                           query,query_next,table_name
                           INTO l_query,l_query_next,l_table_name
                      FROM 
                          (
                           SELECT 
                                query, 
                                LEAD(query,1) OVER (ORDER BY column_id) AS query_next,
                                table_name
                           FROM ( 
                                 SELECT
                                      column_id,        
                                      ''''||LOWER(a.query1)||'''' query,
                                      table_name                
                                 FROM (
                                       SELECT 
                                           Count(*) sn,
                                           table_name,
                                           30 column_id,
                                           LISTAGG(CASE WHEN data_type='DATE' THEN date_column_name ELSE null_column_name END,',') WITHIN GROUP(ORDER BY table_name,column_id) query1
                                       FROM (
                                             SELECT 
                                                  table_name,
                                                  column_name,
                                                  column_id,
                                                  data_type,
                                                  '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE ''to_date(''''''||TO_CHAR('||column_name||'~''YYYY-MM-DD'')||'''''',''''YYYY-MM-DD'''')' ||''' END'||'||''''''' date_column_name,
                                                  '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE REPLACE(TO_CHAR('||column_name||'),'''''''','''''''''''') END'||'||'''''''    null_column_name
                                             FROM all_tab_cols
                                             WHERE owner = p_woner
                                             AND table_name = p_table_name
                                             AND column_id <=30
                                             ORDER BY column_id
                                            )
                                       GROUP BY table_name
                                       UNION
                                       SELECT 
                                           Count(*) sn,
                                           table_name,
                                           31 column_id,
                                           LISTAGG(CASE WHEN data_type='DATE' THEN date_column_name ELSE null_column_name END,',') WITHIN GROUP(ORDER BY table_name,column_id) query1
                                       FROM (
                                             SELECT 
                                                  table_name,
                                                  column_name,
                                                  column_id,
                                                  data_type,
                                                  '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE ''to_date(''''''||TO_CHAR('||column_name||'~''YYYY-MM-DD'')||'''''',''''YYYY-MM-DD'''')' ||''' END'||'||''''''' date_column_name, 
                                                  '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE REPLACE(TO_CHAR('||column_name||'),'''''''','''''''''''') END'||'||'''''''    null_column_name
                                             FROM all_tab_cols
                                             WHERE owner = p_woner
                                             AND table_name = p_table_name
                                             AND column_id >31
                                             ORDER BY column_id
                                            )
                                       GROUP BY table_name
                                 ) a ORDER BY table_name
                              ) b 
                      ) c
                      WHERE query_next IS NOT NULL;

                      l_query := REPLACE(Lower(l_query),'~',',');
                      l_query_next := REPLACE(Lower(l_query_next),'~',',');
                      DECLARE
                           l_inhandler     utl_file.file_type;
                           l_outhandle     VARCHAR2(32767);
                           TYPE cursor_rc  IS REF cursor;
                           l_cursor        cursor_rc;
                           l_sql           VARCHAR2(32767);
                           l_column_date   VARCHAR2(32767);
                      BEGIN
                           l_inhandler := utl_file.fopen('DIR_NAME',l_table_name||'.sql','W');                                             
                           l_sql := 'SELECT REPLACE(REPLACE(REPLACE('||l_query||',''''''null'''''',''NULL''),''''''to_date'',''to_date''),'''''')'''''','''''')'')||'',''||REPLACE(REPLACE(REPLACE('||l_query_next||',''''''null'''''',''NULL''),''''''to_date'',''to_date''),'''''')'''''','''''')'') column_date FROM '||p_woner||'.'||l_table_name;
                           --Dbms_Output.Put_Line(l_sql); 
                                                     
                           OPEN l_cursor FOR l_sql;
                           LOOP
                              FETCH l_cursor INTO l_column_date;
                              EXIT WHEN l_cursor%NOTFOUND;
                              utl_file.put_line(l_inhandler,'INSERT INTO '||p_woner||'.'||l_table_name||' VALUES ('||l_column_date||')');
                           END LOOP;
                           close l_cursor;
                           
                      EXCEPTION WHEN NO_DATA_FOUND THEN
                           utl_file.fclose(l_inhandler);
                      END;
                END;
               EXCEPTION WHEN OTHERS THEN 
                  Dbms_Output.Put_Line(i.table_name);
               END;
            ELSE
               BEGIN 
                   DECLARE
                       p_woner        VARCHAR2(30) := i.owner;
                       p_table_name   VARCHAR2(30) := i.table_name; 
                       l_query        VARCHAR2(32767);
                       l_table_name   VARCHAR2(32767);
                   BEGIN 
                       SELECT        
                            ''''||Lower(a.query1)||'''' query,
                            table_name
                            INTO l_query,l_table_name
                       FROM (
                       SELECT 
                           Count(*) sn,
                           TABLE_NAME,
                           listagg(CASE WHEN DATA_TYPE='DATE' THEN DATE_COLUMN_NAME ELSE NULL_COLUMN_NAME END,',') WITHIN GROUP(ORDER BY TABLE_NAME,COLUMN_ID) query1
                       FROM (
                             SELECT 
                                  TABLE_NAME,
                                  COLUMN_NAME,
                                  COLUMN_ID,
                                  DATA_TYPE,                                                     
                                  '''''''||CASE WHEN '||column_name||' IS NULL THEN ''NULL'' ELSE ''to_date(''''''||TO_CHAR('||column_name||'~''YYYY-MM-DD'')||'''''',''''YYYY-MM-DD'''')' ||''' END'||'||''''''' date_column_name,
                                  '''''''||CASE WHEN '||COLUMN_NAME||' IS NULL THEN ''NULL'' ELSE REPLACE(TO_CHAR('||COLUMN_NAME||'),'''''''','''''''''''') END'||'||'''''''    null_column_name
                             FROM all_tab_cols
                             WHERE owner = p_woner
                             AND table_name = p_table_name
                            )
                       GROUP BY TABLE_NAME
                       ORDER BY TABLE_NAME) a;
                   
                       l_query := REPLACE(Lower(l_query),'~',',');
                       DECLARE
                            l_inhandler     utl_file.file_type;
                            l_outhandle     VARCHAR2(32767);
                            TYPE cursor_rc  IS REF cursor;
                            l_cursor        cursor_rc;
                            l_sql           VARCHAR2(32767);
                            l_column_date   VARCHAR2(32767);
                       BEGIN
                            l_inhandler := utl_file.fopen('DIR_NAME',l_table_name||'.sql','W');
                            l_sql := 'SELECT REPLACE(REPLACE(REPLACE('||l_query||',''''''null'''''',''NULL''),''''''to_date'',''to_date''),'''''')'''''','''''')'') column_date FROM '||p_woner||'.'||l_table_name;
                            Dbms_Output.Put_Line(l_sql);
                            
                            OPEN l_cursor FOR l_sql;
                            LOOP
                               FETCH l_cursor INTO l_column_date;
                               EXIT WHEN l_cursor%NOTFOUND;
                               utl_file.put_line(l_inhandler,'INSERT INTO '||p_woner||'.'||l_table_name||' VALUES ('||l_column_date||')');
                            END LOOP;
                            close l_cursor;
                            
                       EXCEPTION WHEN NO_DATA_FOUND THEN
                            utl_file.fclose(l_inhandler);
                       END;
                   END;
                EXCEPTION WHEN OTHERS THEN 
                   Dbms_Output.Put_Line(i.table_name);
                END;
           END IF;
        EXCEPTION WHEN OTHERS THEN 
           Dbms_Output.Put_Line(i.table_name);
        END;
    END LOOP;
EXCEPTION WHEN OTHERS THEN 
    Dbms_Output.Put_Line(SQLERRM);
END;
/

