-- To create a directory (Must have login with the user that have privilege to do as DBA --
CREATE DIRECTORY RI16_XML AS '/home/oracle/mmhome/mmhome/data/dyncamic_xml/';
GRANT READ, WRITE ON DIRECTORY RI16_XML TO PUBLIC;

-- To provide the privilege --
GRANT EXECUTE ON sys.dbms_xmlgen TO rabe01user;
GRANT EXECUTE ON sys.dbms_xmlgen TO ri16_odi_repo;
GRANT EXECUTE ON sys.utl_file to rabe01user;
GRANT EXECUTE ON sys.utl_file to ri16_odi_repo;

-- The oracle writer mechanism --
DECLARE
   l_username            VARCHAR2(30) := 'radm01';
   l_tag_table_name      VARCHAR2(30) := 'dynamic_tag';
   l_target_table_name   VARCHAR2(30) := 'test';
   l_xml_table_name      VARCHAR2(30) := 'xml_stg';
   l_xml_hed_table_name  VARCHAR2(30) := 'EMPLOYEES';
   l_xml_body_table_name VARCHAR2(30) := 'EMPLOYEE';
   l_directory_name      VARCHAR2(30) := 'RI16_XML';
   l_xml_file_name       VARCHAR2(30) := 'dyncamic_xml_test.xml';
   l_sql                 VARCHAR2(32767);
   l_column_name         VARCHAR2(32767);
   l_flag                NUMBER;
   l_xmltype             XMLTYPE;
   l_ctx                 dbms_xmlgen.ctxhandle;
   l_inhandler           utl_file.file_type;
   l_outhandle           VARCHAR2(32767);
   TYPE cursor_cur       IS REF CURSOR;
   tag_cur               cursor_cur;
   l_targ_tag            VARCHAR2(32767);
   l_rowid               VARCHAR2(32767);
BEGIN
    -- To fetch column name --
    l_sql := 'SELECT DISTINCT ROWID, targ_tag||'','' targ_tag FROM '||l_username||'.'||l_tag_table_name||' ORDER BY 1';
    OPEN tag_cur FOR l_sql;
    LOOP
       FETCH  tag_cur INTO l_rowid, l_targ_tag;
       EXIT WHEN tag_cur%NOTFOUND;
       l_column_name := l_column_name||l_targ_tag;
       l_flag := 1;
    END LOOP;
    CLOSE tag_cur;

    -- To create an object structure as per as data --
    IF (l_flag = 1) THEN 
       l_column_name := SUBSTR(l_column_name,1,INSTR(l_column_name,',',-1)-1);
       l_sql := 'CREATE TABLE '||l_username||'.'||l_target_table_name||'
                 (
                  '||TRIM(l_column_name)||'
                 ) COMPRESS 
                 AS
                 SELECT * FROM '||l_username||'.'||l_xml_table_name||' 
                 NOLOGGING';
       BEGIN 
           EXECUTE IMMEDIATE l_sql;
       EXCEPTION WHEN OTHERS THEN 
           IF (SQLCODE = -955) THEN
               EXECUTE IMMEDIATE 'DROP TABLE '||l_username||'.'||l_target_table_name||' PURGE';
               EXECUTE IMMEDIATE l_sql;
           ELSE
              dbms_output.put_line(SQLERRM);
           END IF;
       END;
       l_flag := 2;
    ELSE
       -- To identify the column names  --
       dbms_output.put_line('No row retured');
    END IF;

    IF (l_flag = 2) THEN
        -- To generate an xml data --
        BEGIN
            l_ctx := dbms_xmlgen.newcontext('SELECT * FROM '||l_username||'.'||l_target_table_name||'');
            dbms_xmlgen.setrowsettag(l_ctx,l_xml_hed_table_name);
            dbms_xmlgen.setrowtag(l_ctx,l_xml_body_table_name);
            l_xmltype := dbms_xmlgen.getxmltype(l_ctx);
            dbms_xmlgen.closecontext(l_ctx);
            l_outhandle := l_xmltype.getclobval;
        END;

        -- To write the xml data into a file --
        BEGIN
            l_inhandler := utl_file.fopen(l_directory_name,l_xml_file_name, 'W');
            utl_file.put_line(l_inhandler,l_outhandle);
            utl_file.fclose(l_inhandler);
        EXCEPTION WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
        END;
    END IF;
END;
/


-- Verification Script for data and object structure
SELECT CASE 
          WHEN COUNT(*)= 0 THEN 'Pass'
       ELSE 
          'Fail'
       END result
FROM (
      (SELECT * from xml_stg
       MINUS
       SELECT * FROM test)
       UNION ALL
      (SELECT * from test
       MINUS
       SELECT * FROM xml_stg)
     );
-- Result should be 'Pass'

SELECT CASE 
          WHEN COUNT(*)= 0 THEN 'Pass'
       ELSE 
          'Fail'
       END result
FROM (
      (SELECT data_type, data_length, data_precision, data_scale, global_stats, user_stats, avg_col_len, char_length, char_used FROM user_tab_cols WHERE table_name = 'XML_STG'
       MINUS
       SELECT data_type, data_length, data_precision, data_scale, global_stats, user_stats, avg_col_len, char_length, char_used FROM user_tab_cols WHERE table_name = 'TEST')
       UNION ALL
      (SELECT data_type, data_length, data_precision, data_scale, global_stats, user_stats, avg_col_len, char_length, char_used FROM user_tab_cols WHERE table_name = 'TEST'
       MINUS
       SELECT data_type, data_length, data_precision, data_scale, global_stats, user_stats, avg_col_len, char_length, char_used FROM user_tab_cols WHERE table_name = 'XML_STG')
     );
-- Result should be 'Pass'