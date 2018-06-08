DROP TABLE dshrivastav.c_arch_prg_tbl PURGE;
CREATE TABLE dshrivastav.c_arch_prg_tbl
(
  table_name            VARCHAR2(50 BYTE),
  table_schema_name     VARCHAR2(50 BYTE),
  table_type            VARCHAR2(50 BYTE),
  column_name           VARCHAR2(30 BYTE),
  retention_period      VARCHAR2(50 BYTE),
  last_prg_day          VARCHAR2(50 BYTE),
  time_level            VARCHAR2(10 BYTE),
  archive_flag          VARCHAR2(50 BYTE),
  purge_flag            VARCHAR2(50 BYTE),
  archive_table_name    VARCHAR2(50 BYTE),
  archive_database_name VARCHAR2(50 BYTE)
);

BEGIN
    FOR i in 1..10
    LOOP
       EXECUTE IMMEDIATE 'INSERT INTO dshrivastav.c_arch_prg_tbl
                          (
                           table_name,
                           table_schema_name,
                           table_type,
                           column_name,
                           retention_period,
                           last_prg_day,
                           time_level,
                           archive_flag,
                           purge_flag,
                           archive_table_name,
                           archive_database_name
                          )
                          VALUES(''W_RTL_SLS_TRX_IT_LC_DY_F'',''RA_DATA_MART'',''TABLE PARTITION'',''DT_WID'',''1'',''22-MAY-17'',''DAY'',''Y'',''Y'',''W_RTL_SLS_TRX_IT_LC_DY_F_ARCH'',''ARCH_UAT'')';
    END LOOP;
    COMMIT;
END;
/
-- First approch
DECLARE
    -- Local variable associated with table data type
    l_table_name            dshrivastav.c_arch_prg_tbl.table_name%TYPE;          
    l_table_schema_name     dshrivastav.c_arch_prg_tbl.table_schema_name%TYPE;  
    l_table_type            dshrivastav.c_arch_prg_tbl.table_type%TYPE;          
    l_column_name           dshrivastav.c_arch_prg_tbl.column_name%TYPE;         
    l_retention_period      dshrivastav.c_arch_prg_tbl.retention_period%TYPE;    
    l_last_prg_day          dshrivastav.c_arch_prg_tbl.last_prg_day%TYPE;        
    l_time_level            dshrivastav.c_arch_prg_tbl.time_level%TYPE;          
    l_archive_flag          dshrivastav.c_arch_prg_tbl.archive_flag%TYPE;        
    l_purge_flag            dshrivastav.c_arch_prg_tbl.purge_flag%TYPE;          
    l_archive_table_name    dshrivastav.c_arch_prg_tbl.archive_table_name%TYPE;
    l_archive_database_name dshrivastav.c_arch_prg_tbl.archive_database_name%TYPE;
    -- Defining Reference cursor 
    TYPE cursor_rc  IS REF cursor;
    l_cursor        cursor_rc;
    l_sql           VARCHAR2(32767);
BEGIN
    l_sql := 'SELECT * FROM dshrivastav.c_arch_prg_tbl' ;
    OPEN l_cursor FOR l_sql;
    LOOP
      -- Fetches entire row into the Local variable
      FETCH l_cursor INTO l_table_name,l_table_schema_name,l_table_type,l_column_name,l_retention_period,l_last_prg_day,l_time_level,l_archive_flag,l_purge_flag,l_archive_table_name,l_archive_database_name;
      EXIT WHEN l_cursor%NOTFOUND;
       dbms_output.put_line(l_table_name||','||l_table_schema_name||','||l_table_type||','||l_column_name||','||l_retention_period||','||l_last_prg_day||','||l_time_level||','||l_archive_flag||','||l_purge_flag||','||l_archive_table_name||','||l_archive_database_name);
       Dbms_Output.Put_Line(l_table_name);
       IF l_table_name ='W_RTL_SLS_TRX_IT_LC_DY_F' THEN 
          Dbms_Output.Put_Line('pass');
       END IF;
    END LOOP;
    CLOSE l_cursor;
END;
/

-- Second Approch
DECLARE 
   CURSOR cursor_c
   IS 
   SELECT 
       * 
   FROM dshrivastav.c_arch_prg_tbl;
       
   TYPE data IS            VARRAY(999999999) of VARCHAR2(4000); 
   c_arch_prg_tbl_var data := data(); 
   l_counter               NUMBER :=0;
   l_limit_counter         NUMBER;  
BEGIN
   EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM dshrivastav.c_arch_prg_tbl' INTO l_limit_counter;
    
   FOR i IN cursor_c
   LOOP
      l_counter := l_counter + 1; 
      c_arch_prg_tbl_var.extend;
      BEGIN 
          -- table_name 
          c_arch_prg_tbl_var(l_counter)  := i.table_name;
          dbms_output.put_line(l_counter||' => List of table_name => '||c_arch_prg_tbl_var(l_counter));
          -- table_schema_name 
          c_arch_prg_tbl_var(l_counter)  := i.table_schema_name; 
          dbms_output.put_line(l_counter||' => List of table_schema_name => '||c_arch_prg_tbl_var(l_counter));
          -- table_type
          c_arch_prg_tbl_var(l_counter)  := i.table_type;
          dbms_output.put_line(l_counter||' => List of table_type => '||c_arch_prg_tbl_var(l_counter));
          -- column_name
          c_arch_prg_tbl_var(l_counter)  := i.column_name;
          dbms_output.put_line(l_counter||' => List of column_name => '||c_arch_prg_tbl_var(l_counter));
          -- retention_period
          c_arch_prg_tbl_var(l_counter)  := i.retention_period;
          dbms_output.put_line(l_counter||' => List of retention_period => '||c_arch_prg_tbl_var(l_counter));
          -- last_prg_day
          c_arch_prg_tbl_var(l_counter)  := i.last_prg_day;
          dbms_output.put_line(l_counter||' => List of last_prg_day => '||c_arch_prg_tbl_var(l_counter));
          -- time_level
          c_arch_prg_tbl_var(l_counter)  := i.time_level;
          dbms_output.put_line(l_counter||' => List of time_level => '||c_arch_prg_tbl_var(l_counter));
          -- archive_flag
          c_arch_prg_tbl_var(l_counter)  := i.archive_flag;
          dbms_output.put_line(l_counter||' => List of archive_flag => '||c_arch_prg_tbl_var(l_counter));
          -- purge_flag
          c_arch_prg_tbl_var(l_counter)  := i.purge_flag;
          dbms_output.put_line(l_counter||' => List of purge_flag => '||c_arch_prg_tbl_var(l_counter));
          -- archive_table_name
          c_arch_prg_tbl_var(l_counter)  := i.archive_table_name;
          dbms_output.put_line(l_counter||' => List of archive_table_name => '||c_arch_prg_tbl_var(l_counter));
          -- archive_database_name
          c_arch_prg_tbl_var(l_counter)  := i.archive_database_name;
          dbms_output.put_line(l_counter||' => List of archive_database_name => '||c_arch_prg_tbl_var(l_counter));
      END;
      -- Loop termination Condiation
      EXIT WHEN l_counter = l_limit_counter;
   END LOOP;
END; 
/