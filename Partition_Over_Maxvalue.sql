CREATE OR REPLACE PACKAGE pk_partition_over_maxvalue
AS
  -- To identify the exiting partition name and max value 
  PROCEDURE sp_identify_partition_name
  (
    p_table_name             VARCHAR2,
    p_table_owner            VARCHAR2,
    identify_name_cur_o      OUT sys_refcursor
  );
  -- To identify the nature of partition type 
  PROCEDURE sp_identify_partition_type
  (
    p_table_name              VARCHAR2,
    p_table_owner             VARCHAR2,
    flag_o                OUT VARCHAR2,
    high_value_final_o    OUT VARCHAR2,
    old_partition_name_o  OUT VARCHAR2
  );
  -- To Split the Partition Over Max Value  
  PROCEDURE sp_partition_over_maxvalue    
  (
    p_table_owner            VARCHAR2,
    p_table_name             VARCHAR2,
    p_year              VARCHAR2
  );
END pk_partition_over_maxvalue;
/

CREATE OR REPLACE PACKAGE BODY pk_partition_over_maxvalue
AS
  -- To identify the exiting partition name and max value
  PROCEDURE sp_identify_partition_name  
  (
    p_table_name             VARCHAR2,
    p_table_owner            VARCHAR2,
    identify_name_cur_o      OUT sys_refcursor
  )
  AS
    l_sql                    VARCHAR2(32767);
    l_sql_ddl                VARCHAR2(32767);
    l_table_name             VARCHAR2(30) :=  UPPER(p_table_name);
    l_table_owner            VARCHAR2(30) :=  UPPER(p_table_owner);
  BEGIN
      l_sql := 'CREATE TABLE all_tab_partition
                AS
                SELECT
                     table_owner         table_owner,
                     table_name          table_name,
                     partition_name      partition_name,
                     TO_LOB(high_value)  high_value,
                     partition_position  partition_position
                FROM
                     all_tab_partitions
                WHERE
                    (table_name = '''||l_table_name||''' AND table_owner = '''||l_table_owner||''')';
      BEGIN
          l_sql_ddl := 'DROP TABLE all_tab_partition PURGE';
          EXECUTE IMMEDIATE l_sql_ddl;
          EXECUTE IMMEDIATE l_sql;
      EXCEPTION WHEN OTHERS THEN
          IF (SQLCODE = -00942) THEN
              EXECUTE IMMEDIATE l_sql;
          END IF;
      END;
  
      l_sql := 'SELECT
                     CASE WHEN c.rank_by_partition_position  = 1 THEN c.old_partition_name END old_partition_name,
                     CASE WHEN c.rank_by_partition_position <> 1 THEN c.high_value END         high_value,
                     c.rank_by_partition_position                                              flag
                FROM (
                      SELECT
                        -- To identify the exiting partition name
                        b.old_partition_name    old_partition_name,
                        b.high_value            high_value,
                        -- To Identify the exiting partition nature
                        DENSE_RANK() OVER (ORDER BY b.partition_position_old desc) rank_by_partition_position
                   FROM (
                         SELECT
                              a.table_name                      table_name,
                              a.partition_position              partition_position_old,
                              a.partition_position+1            partition_position_new,
                              a.partition_name                  partition_name,
                              CASE
                                 WHEN TO_CHAR(a.high_value) = ''MAXVALUE'' THEN a.partition_name
                              END                               old_partition_name,
                              TO_CHAR(a.high_value)             high_value
                         FROM
                              all_tab_partition a
                         ORDER BY
                              a.partition_position DESC
                        ) b
                   ) c
                WHERE
                     c.rank_by_partition_position IN (1,2,3,4)';
      OPEN identify_name_cur_o FOR l_sql;
  EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
  END sp_identify_partition_name;

  -- To identify the nature of partition type
  PROCEDURE sp_identify_partition_type
  (
    p_table_name              VARCHAR2,
    p_table_owner             VARCHAR2,
    flag_o                OUT VARCHAR2,
    high_value_final_o    OUT VARCHAR2,
    old_partition_name_o  OUT VARCHAR2
  )
  AS
    l_identify_name_cur    sys_refcursor;
    l_old_partition_name   VARCHAR2(50);
    l_high_value           VARCHAR2(30);
    l_flag                 VARCHAR2(10);
    l_high_value_1         VARCHAR2(50);
    l_high_value_2         VARCHAR2(50);
    l_high_value_3         VARCHAR2(50);
  BEGIN
      -- To segregate the partition value in three parts
      pk_partition_over_maxvalue.sp_identify_partition_name(p_table_name,p_table_owner,l_identify_name_cur);
      LOOP
        FETCH l_identify_name_cur INTO l_old_partition_name,l_high_value,l_flag;
        EXIT WHEN l_identify_name_cur%NOTFOUND;
        IF (l_old_partition_name IS NOT NULL) THEN
           old_partition_name_o := l_old_partition_name;
        ELSIF (l_high_value IS NOT NULL) THEN
            IF l_flag = 2 THEN
               high_value_final_o := l_high_value;
               l_high_value_1 := SUBSTR(l_high_value,2,8);
            ELSIF l_flag = 3 THEN
               l_high_value_2 := SUBSTR(l_high_value,2,8);
            ELSIF l_flag = 4 THEN
               l_high_value_3 := SUBSTR(l_high_value,2,8);
            END IF;
        END IF;
      END LOOP;
      CLOSE l_identify_name_cur;
  
      -- To identify the nature of partition
      BEGIN
          l_high_value_1 := TO_DATE(l_high_value_1,'YYYYMMDD');
          IF (SUBSTR(l_high_value_1,2,4) = SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) = SUBSTR(l_high_value_3,2,4)) THEN
             l_flag := TO_DATE(l_high_value_1,'YYYYMMDD')-TO_DATE(l_high_value_2,'YYYYMMDD');
          ELSIF (SUBSTR(l_high_value_1,2,4) = SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) <> SUBSTR(l_high_value_3,2,4)) THEN
             l_flag := TO_DATE(l_high_value_1,'YYYYMMDD')-TO_DATE(l_high_value_2,'YYYYMMDD');
          ELSIF (SUBSTR(l_high_value_1,2,4) <> SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) = SUBSTR(l_high_value_3,2,4)) THEN
             l_flag := TO_DATE(l_high_value_2,'YYYYMMDD')-TO_DATE(l_high_value_3,'YYYYMMDD');
          END IF;
          flag_o := l_flag;
      EXCEPTION WHEN OTHERS THEN
         IF (LENGTH(l_high_value_1) >=9) THEN
            IF (SUBSTR(l_high_value_1,2,4) = SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) = SUBSTR(l_high_value_3,2,4)) THEN
               l_flag := l_high_value_1-l_high_value_2;
            ELSIF (SUBSTR(l_high_value_1,2,4) = SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) <> SUBSTR(l_high_value_3,2,4)) THEN
               l_flag := l_high_value_1-l_high_value_2;
            ELSIF (SUBSTR(l_high_value_1,2,4) <> SUBSTR(l_high_value_2,2,4)) AND (SUBSTR(l_high_value_2,2,4) = SUBSTR(l_high_value_3,2,4)) THEN
               l_flag := l_high_value_2-l_high_value_3;
            END IF;
            flag_o := l_flag;
        ELSE
           flag_o := '~';
           old_partition_name_o := '';
           high_value_final_o := '';
        END IF;
      END;
  END sp_identify_partition_type;

  -- To Split the Partition Over Max Value
  PROCEDURE sp_partition_over_maxvalue
  (
    p_table_owner            VARCHAR2,
    p_table_name             VARCHAR2,
    p_year                   VARCHAR2
  )
  AS  
     l_table_name           VARCHAR2(30) := UPPER(p_table_name);
     l_year                 VARCHAR2(10) := p_year;
     l_table_owner          VARCHAR2(30) := UPPER(p_table_owner);
     l_old_partition_name   VARCHAR2(50);
     l_new_partition_name   VARCHAR2(50);
     l_high_value           VARCHAR2(30);
     l_flag                 VARCHAR2(10);
     l_sql                  VARCHAR2(32767);
     l_column               VARCHAR2(100);
     l_group_by             VARCHAR2(100) := '';
     l_operator               VARCHAR2(10) := 'AND ';
     TYPE l_sql_curr        IS REF CURSOR;
     l_curr                 l_sql_curr;
     l_new_partition_value  VARCHAR2(100);
     l_table_name_lookup    VARCHAR2(30) := '';
  BEGIN
      pk_partition_over_maxvalue.sp_identify_partition_type(l_table_name,l_table_owner,l_flag,l_high_value,l_old_partition_name);
  
      BEGIN
           IF (l_flag <> '~') THEN 
              -- To find existing type of partition in Our Database
              IF l_flag >= <<Provide The Logic 1>> THEN 
                 l_column := 'TO_CHAR(''<<Provide The Column for Logic 1>>'') ';
                 l_table_name_lookup := '<<Provide The Lookup Table Name for Logic 1>>';
              ELSIF l_flag = <<Provide The Logic 2>> THEN 
                 l_column := 'TO_CHAR(''<<Provide The Column for Logic 2>>'') ';
                 l_table_name_lookup := '<<Provide The Lookup Table Name for Logic 2>>';
              ELSIF l_flag IN <<Provide The Logic 3>> THEN
                 l_column := 'TO_CHAR(''MIN(<<Provide The Column for Logic 3>>)'') ';
                 l_table_name_lookup := '<<Provide The Lookup Table Name for Logic 3>>';
                 l_having := 'HAVING ';
                 l_group_by := 'GROUP BY <<Provide The Column for Logic 3>> ';
              ELSIF l_flag = <<Provide The Logic 4>> THEN
                 l_column := 'TRIM(TO_CHAR(''<<Provide The Column for Logic 4>>'')) ';
                 l_table_name_lookup := '<<Provide The Lookup Table Name for Logic 4>>';
              END IF;

              -- To Identified the Prifix for Partition Name as per as requirements Like P
              l_sql := 'SELECT
                             c.new_partition_value,
                             CASE
                                WHEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',- 1)-1) = ''P'' THEN 
                                CASE 
                                   WHEN LENGTH(c.new_partition_name) = 1 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_00''||c.new_partition_name
                                   WHEN LENGTH(c.new_partition_name) = 2 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_0''||c.new_partition_name
                                   WHEN LENGTH(c.new_partition_name) = 3 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_''||c.new_partition_name
                                END
                             ELSE 
                                CASE
                                   WHEN LENGTH(c.new_partition_name) = 1 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_P00''||c.new_partition_name
                                   WHEN LENGTH(c.new_partition_name) = 2 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_P0''||c.new_partition_name
                                   WHEN LENGTH(c.new_partition_name) = 3 THEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1)||''_P''||c.new_partition_name
                                END
                             END new_partition_name
                         FROM (
                               SELECT
                                    b.new_partition_value         new_partition_value,
                                    b.new_partition_name + ROWNUM new_partition_name
                               FROM (
                                     SELECT DISTINCT
                                          '||l_column||' new_partition_value,
                                          CASE 
                                             WHEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',-1)-1) = ''P'' THEN SUBSTR('''||l_old_partition_name||''',INSTR('''||l_old_partition_name||''',''_'',-1)+1)
                                             WHEN SUBSTR('''||l_old_partition_name||''',1,INSTR('''||l_old_partition_name||''',''_'',- 1)+1) LIKE ''%/_P'' ESCAPE ''/'' THEN SUBSTR('''||l_old_partition_name||''',INSTR('''||l_old_partition_name||''',''_'',-1)+2)
                                          END new_partition_name
                                     FROM 
                                          '||l_table_name_lookup||' a
                                     WHERE 
                                          TRIM(<<Provide The Column for Year>>) = '''||l_year||'''
                                     '||l_operator||' '||l_column||' > '''||l_high_value||'''
                                     AND NOT EXISTS (
                                                     SELECT
                                                          1
                                                     FROM 
                                                          all_tab_partition b
                                                     WHERE
                                                         ('||l_column||' = TRIM(TO_CHAR(<<Provide The Column for Logic>>)))
                                                    )
                                     '||l_group_by||'
                                     ORDER BY new_partition_value ASC
                                   ) b
                             ) c';
              
              OPEN l_curr FOR l_sql;
              LOOP
                 FETCH l_curr INTO l_new_partition_value,l_new_partition_name;
                 EXIT WHEN l_curr%NOTFOUND;
                 BEGIN
                     IF (l_new_partition_value IS NOT NULL AND l_new_partition_name IS NOT NULL) THEN
                         l_flag := 1;
                         IF (l_flag = 1) THEN 
                            dbms_output.put_line('ALTER TABLE '||l_table_owner||'.'||l_table_name||' SPLIT PARTITION '||l_old_partition_name||' AT ('||l_new_partition_value||')
                                                  INTO 
                                                  (
                                                   PARTITION '||l_new_partition_name||', 
                                                   PARTITION '||l_old_partition_name||'
                                                  );');
                            l_old_partition_name := l_new_partition_name;
                         ELSE
                            dbms_output.put_line('ALTER TABLE '||l_table_owner||'.'||l_table_name||' SPLIT PARTITION '||l_new_partition_name||' AT ('||l_new_partition_value||')
                                                  INTO 
                                                  (
                                                   PARTITION '||l_new_partition_name||', 
                                                   PARTITION '||l_old_partition_name||'
                                                  );');
                            l_old_partition_name := l_new_partition_name;
                         END IF;
                      ELSE
                         dbms_output.put_line('Please update the Lookup Table !!!!!');
                      END IF;
                 EXCEPTION WHEN OTHERS THEN 
                    dbms_output.put_line(SQLERRM);
                 END;
              END LOOP;
              CLOSE l_curr;
          ELSE 
             dbms_output.put_line('Please Provide the Valied Partition Table Name Or Owner Name');
          END IF;
      END;
  END sp_partition_over_maxvalue;
END pk_partition_over_maxvalue;
/

EXECUTE pk_partition_over_maxvalue.sp_partition_over_maxvalue ('<<Provide The Owner Name>>','<<Provide The Partition Table Name>>','<<Provide The Year>>');
