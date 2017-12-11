-- Step 1 --
CREATE OR REPLACE PACKAGE ra_data_mart.pk_partition_over_maxvalue
AS
  -- To identify the exiting partition name and max value 
  PROCEDURE sp_identify_partition_name
  (
    p_table_name             VARCHAR2,
    p_table_owner            VARCHAR2
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
  -- To Split the Partition Over Max Value - Single Table
  PROCEDURE sp_partition_over_maxvalue    
  (
    p_table_owner            VARCHAR2,
    p_table_name             VARCHAR2,
    p_mcal_year              VARCHAR2
  );
  -- To Split the Partition Over Max Value - Multiple Tables
  PROCEDURE sp_partition_over_maxvalues
  (
    p_table_owner            VARCHAR2,
    p_mcal_year              VARCHAR2
  );
END pk_partition_over_maxvalue;
/

-- Step 2 --
CREATE OR REPLACE PACKAGE BODY ra_data_mart.pk_partition_over_maxvalue
AS
  -- To identify the exiting partition name and max value
  PROCEDURE sp_identify_partition_name  
  (
    p_table_name             VARCHAR2,
    p_table_owner            VARCHAR2
  )
  AS
    l_sql                    VARCHAR2(32767);
    l_sql_ddl                VARCHAR2(32767);
    l_table_name             VARCHAR2(30) :=  UPPER(p_table_name);
    l_table_owner            VARCHAR2(30) :=  UPPER(p_table_owner);
  BEGIN
      l_sql := 'CREATE TABLE '||l_table_owner||'.all_tab_partition
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
          l_sql_ddl := 'DROP TABLE '||l_table_owner||'.all_tab_partition PURGE';
          EXECUTE IMMEDIATE l_sql_ddl;
          EXECUTE IMMEDIATE l_sql;
      EXCEPTION WHEN OTHERS THEN
          IF (SQLCODE = -00942) THEN
              EXECUTE IMMEDIATE l_sql;
          END IF;
      END;
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
    TYPE l_sql_curr        IS REF CURSOR;
    l_curr                 l_sql_curr;
    l_old_partition_name   VARCHAR2(50);
    l_high_value           VARCHAR2(30);
    l_flag                 VARCHAR2(10);
    l_high_value_1         VARCHAR2(50);
    l_high_value_2         VARCHAR2(50);
    l_high_value_3         VARCHAR2(50);
    l_table_owner          VARCHAR2(30) :=  UPPER(p_table_owner);
    l_sql                  VARCHAR2(32767);
  BEGIN
      -- To Create a table with partition name --
      ra_data_mart.pk_partition_over_maxvalue.sp_identify_partition_name(p_table_name,p_table_owner);
      -- To find the old name of exiting partitions --
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
                              '||l_table_owner||'.all_tab_partition a
                         ORDER BY
                              a.partition_position DESC
                        ) b
                   ) c
                WHERE
                     c.rank_by_partition_position IN (1,2,3,4)';
      -- To segregate the partition value in three parts
      OPEN l_curr FOR l_sql;
      LOOP
        FETCH l_curr INTO l_old_partition_name,l_high_value,l_flag;
        EXIT WHEN l_curr%NOTFOUND;
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
           ELSE
              old_partition_name_o := '~';
              EXIT;
           END IF;
      END LOOP;
      CLOSE l_curr;
  
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
         IF (LENGTH(l_high_value_1) >=8) THEN
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

  -- To Split the Partition Over Max Value - Single Table
  PROCEDURE sp_partition_over_maxvalue
  (
    p_table_owner            VARCHAR2,
    p_table_name             VARCHAR2,
    p_mcal_year              VARCHAR2
  )
  AS  
     l_table_name           VARCHAR2(30) := UPPER(p_table_name);
     l_mcal_year            VARCHAR2(10) := p_mcal_year;
     l_table_owner          VARCHAR2(30) := UPPER(p_table_owner);
     l_old_partition_name   VARCHAR2(50);
     l_new_partition_name   VARCHAR2(50);
     l_high_value           VARCHAR2(30);
     l_flag                 VARCHAR2(10);
     l_sql                  VARCHAR2(32767);
     l_column               VARCHAR2(100);
     l_group_by             VARCHAR2(100) := '';
     l_having               VARCHAR2(10) := 'AND ';
     TYPE l_sql_curr        IS REF CURSOR;
     l_curr                 l_sql_curr;
     l_new_partition_value  VARCHAR2(100);
     l_table_name_lookup    VARCHAR2(30) := '';
     l_table_owner_lookup_1 VARCHAR2(30) := '';
     l_table_owner_lookup_2 VARCHAR2(30) := '';
     l_row_count            PLS_INTEGER;
     l_validate_user        NUMBER;
  BEGIN
      l_sql := 'SELECT 
                     COUNT(table_owner) 
                FROM 
                     all_tab_partitions 
                WHERE 
                    table_owner = '''||l_table_owner||''' ';
      EXECUTE IMMEDIATE l_sql INTO l_validate_user;

      IF (l_validate_user = 0) THEN 
          dbms_output.put_line('Please Provide the Valied Owner Name '||l_table_owner||'  for Year '''||l_mcal_year||''' !!!!!');
      ELSE
          ra_data_mart.pk_partition_over_maxvalue.sp_identify_partition_type(l_table_name,l_table_owner,l_flag,l_high_value,l_old_partition_name);
          
          IF (l_old_partition_name = '~') THEN
              dbms_output.put_line('The table '||l_table_name||' has not been partition over MAXVALUE  for Year '''||l_mcal_year||''' ');
          ELSE
              BEGIN
                   IF (l_flag <> '~') THEN

                      -- To fiend the Lookup Table --
                      IF l_flag >= 28 THEN
                         l_sql := 'SELECT
                                        owner,
                                        table_name
                                   FROM 
                                        all_tables
                                   WHERE 
                                       table_name = UPPER(''w_mcal_day_d'') ';
                         EXECUTE IMMEDIATE l_sql INTO l_table_owner_lookup_1,l_table_name_lookup;
                      ELSE
                         l_sql := 'SELECT
                                        owner,
                                        table_name
                                   FROM
                                        all_tables
                                   WHERE 
                                       table_name = UPPER(''w_mcal_week_d'') ';
                         EXECUTE IMMEDIATE l_sql INTO l_table_owner_lookup_2,l_table_name_lookup;
                      END IF;

                      -- To find existing type of partition in Our Database --
                      IF l_flag >= 28 THEN 
                         l_column := 'TO_CHAR(''1''||a.mcal_period_start_dt_wid||''000'') ';
                         l_table_name_lookup := l_table_owner_lookup_1||'.'||l_table_name_lookup;
                      ELSIF l_flag = 7 THEN 
                         l_column := 'TO_CHAR(''1''||a.mcal_week_start_dt_wid||''000'') ';
                         l_table_name_lookup := l_table_owner_lookup_2||'.'||l_table_name_lookup;
                      ELSIF l_flag IN (4,5) THEN
                         l_column := 'TO_CHAR(MIN(a.row_wid)) ';
                         l_table_name_lookup := l_table_owner_lookup_2||'.'||l_table_name_lookup;
                         l_having := 'HAVING ';
                         l_group_by := 'GROUP BY a.mcal_period_wid ';
                      ELSIF l_flag = 1 THEN
                         l_column := 'TRIM(TO_CHAR(a.row_wid)) ';
                         l_table_name_lookup := l_table_owner_lookup_2||'.'||l_table_name_lookup;
                      END IF;
              
                      l_sql := 'SELECT
                                     c.new_partition_value,
                                     CASE
                                        WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 1
                                        THEN CASE
                                                WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 1
                                                THEN regexp_replace('''||l_old_partition_name||''',''[0-9]'')||''00''||REGEXP_SUBSTR(new_partition_name,''[0-9]+'')
                                                ELSE regexp_replace('''||l_old_partition_name||''',''[0-9]'')||''0''||REGEXP_SUBSTR(new_partition_name,''[0-9]+'') END
                                        WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 2
                                        THEN CASE
                                                WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 2
                                                THEN regexp_replace('''||l_old_partition_name||''',''[0-9]'')||''0''||REGEXP_SUBSTR(new_partition_name,''[0-9]+'')
                                                ELSE regexp_replace('''||l_old_partition_name||''',''[0-9]'')||REGEXP_SUBSTR(new_partition_name,''[0-9]+'') END
                                        WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 3
                                        THEN CASE
                                                WHEN Length(REGEXP_SUBSTR(new_partition_name,''[0-9]+'')) = 3
                                                THEN regexp_replace('''||l_old_partition_name||''',''[0-9]'')||REGEXP_SUBSTR(new_partition_name,''[0-9]+'')
                                                ELSE regexp_replace('''||l_old_partition_name||''',''[0-9]'')||''0''||REGEXP_SUBSTR(new_partition_name,''[0-9]+'') END
                                     END new_partition_name 
                                 FROM (
                                       SELECT
                                            b.new_partition_value         new_partition_value,
                                            b.new_partition_name + ROWNUM new_partition_name
                                       FROM (
                                             SELECT DISTINCT
                                                  '||l_column||'                                                               new_partition_value,
                                                  To_Char(TO_NUMBER(REGEXP_SUBSTR('''||l_old_partition_name||''',''[0-9]+''))) new_partition_name
                                             FROM 
                                                  '||l_table_name_lookup||' a
                                             WHERE 
                                                  TRIM(a.mcal_year) <= '''||l_mcal_year||'''
                                             '||l_having||' '||l_column||' > '''||l_high_value||'''
                                             AND NOT EXISTS (
                                                             SELECT
                                                                  1
                                                             FROM 
                                                                  '||l_table_owner||'.all_tab_partition b
                                                             WHERE
                                                                 ('||l_column||' = TRIM(TO_CHAR(b.high_value)))
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
                               dbms_output.put_line('ALTER TABLE '||l_table_owner||'.'||l_table_name||' SPLIT PARTITION '||l_old_partition_name||'AT ('||l_new_partition_value||')
                                                     INTO
                                                     (
                                                      PARTITION '||l_new_partition_name||',
                                                      PARTITION '||l_old_partition_name||'
                                                     );');
                               l_row_count := l_curr%ROWCOUNT;
                           EXCEPTION WHEN OTHERS THEN
                                dbms_output.put_line(SQLERRM);
                           END;
                      END LOOP;
                      CLOSE l_curr;
                      
                      IF l_row_count IS NULL THEN
                         IF l_flag >= 28 THEN
                            dbms_output.put_line('Please Update the Lookup Table '||l_table_name_lookup||' for Year '''||l_mcal_year||''' !!!!!');
                         ELSE
                            dbms_output.put_line('Please Update the Lookup Table '||l_table_name_lookup||' for Year '''||l_mcal_year||''' !!!!!');
                         END IF;
                      ELSE
                         BEGIN
                             l_sql := 'SELECT
                                            table_owner        table_owner,
                                            table_name         table_name,
                                            partition_name     old_partition_name,
                                            CASE 
                                               WHEN Length(To_Number(REGEXP_SUBSTR(partition_name,''[0-9]+''))) = 1 
                                               THEN CASE 
                                                       WHEN Length(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) = 1 
                                                       THEN regexp_replace(partition_name,''[0-9]'')||''00''||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1)
                                                       ELSE regexp_replace(partition_name,''[0-9]'')||''0''||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) END
                                               WHEN Length(To_Number(REGEXP_SUBSTR(partition_name,''[0-9]+''))) = 2 
                                               THEN CASE 
                                                       WHEN Length(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) = 2 
                                                       THEN regexp_replace(partition_name,''[0-9]'')||''0''||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1)
                                                       ELSE regexp_replace(partition_name,''[0-9]'')||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) END
                                               WHEN Length(To_Number(REGEXP_SUBSTR(partition_name,''[0-9]+''))) = 3 
                                               THEN CASE 
                                                       WHEN Length(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) = 3 
                                                       THEN regexp_replace(partition_name,''[0-9]'')||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) 
                                                       ELSE regexp_replace(partition_name,''[0-9]'')||''0''||To_Char(TO_NUMBER(REGEXP_SUBSTR(partition_name,''[0-9]+''))+1) END
                                            END new_partition_name
                             FROM
                                  all_tab_partitions a
                             WHERE
                                  1 = (
                                       SELECT 
                                           COUNT(DISTINCT partition_position)
                                       FROM 
                                           all_tab_partitions b
                                       WHERE 
                                           a.partition_position <= b.partition_position
                                       AND  a.table_name = b.table_name
                                       AND  a.table_name = UPPER('''||l_table_name||''')
                                      )';
                             EXECUTE IMMEDIATE (l_sql) INTO l_table_owner,l_table_name,l_old_partition_name,l_new_partition_name;
                             BEGIN 
                                 dbms_output.put_line('ALTER TABLE '||l_table_owner||'.'||l_table_name||' RENAME PARTITION '||l_old_partition_name||' TO '||l_new_partition_name||' ;');
                                 dbms_output.put_line('The Table '||l_table_owner||'.'||l_table_name||' has been Successfully Split Over MAXVALUE for Year '''||l_mcal_year||''' !!!!!');
                                 EXCEPTION WHEN OTHERS THEN
                                 dbms_output.put_line(SQLERRM);
                             END;
                         END;
                      END IF;
                  ELSE 
                     dbms_output.put_line('Please Provide the Valied Partition Table Name '||l_table_name||' for Year '''||l_mcal_year||''' !!!!!');
                  END IF;
              END;
          END IF;
      END IF;
  END sp_partition_over_maxvalue;
  
  -- To Split the Partition Over Max Value - Multiple Tables
  PROCEDURE sp_partition_over_maxvalues
  (
    p_table_owner            VARCHAR2,
    p_mcal_year              VARCHAR2
  )
  AS
     l_table_owner            VARCHAR2(30);
     l_table_name             VARCHAR2(30);
     l_sql                    VARCHAR2(32767); 
     TYPE l_sql_curr          IS REF CURSOR;
     l_curr                   l_sql_curr;
  BEGIN
      l_sql := 'SELECT DISTINCT
                     table_owner         table_owner,
                     table_name          table_name
                FROM
                     all_tab_partitions
                WHERE
                    table_owner = '''||p_table_owner||'''
                AND regexp_like(table_name,''(^W_)'')
                AND NOT regexp_like(table_name,''(^W_RTL_ITEM_GRP1_D|^W_RTL_ITEM_GRP2_D)'')';

        -- To List of the Multiple Tables 
        OPEN l_curr FOR l_sql;
        LOOP       
          FETCH l_curr INTO l_table_owner,l_table_name;
          EXIT WHEN l_curr%NOTFOUND;
             BEGIN
                 ra_data_mart.pk_partition_over_maxvalue.sp_partition_over_maxvalue(l_table_owner,l_table_name,p_mcal_year);
             EXCEPTION WHEN OTHERS THEN 
                 Dbms_Output.Put_Line(SQLERRM);
             END; 
        END LOOP;
        CLOSE l_curr;
  END sp_partition_over_maxvalues;
END pk_partition_over_maxvalue;
/

-- Step 3 --
SET SERVEROUTPUT ON;
SET SERVEROUTPUT ON SIZE UNLIMITED; 
BEGIN
    dbms_output.enable(buffer_size => NULL);
END;
/

-- Step 4 --
-- To Split the Partition Over Max Value - Single Table
EXECUTE ra_data_mart.pk_partition_over_maxvalue.sp_partition_over_maxvalue('RA_DATA_MART','W_RTL_INV_IT_LC_DY_F','2018');
-- To Split the Partition Over Max Value - Multiple Tables
EXECUTE ra_data_mart.pk_partition_over_maxvalue.sp_partition_over_maxvalues('RA_DATA_MART','2018');

-- Lookup Tables --
-- >= 28
SELECT * FROM all_tab_partitions WHERE table_name in  ('W_RTL_INV_IT_LC_DY_F','W_RTL_PRICE_IT_LC_DY_F') order by partition_name desc;
-- W_RTL_PRICE_IT_LC_DY_F_P097
-- 120170604000
-- 120170430000
-- 120170402000
select DISTINCT '1'||mcal_period_START_dt_wid||'000' mcal_period_START_dt_wid  from ra_data_mart.w_mcal_day_d
where mcal_year <='2018' and '1'||mcal_period_START_dt_wid||'000' > '120170604000'
order by mcal_period_START_dt_wid asc ;
-- 120170604000
-- 120170430000
-- 120170402000

-- 7-7
SELECT * FROM all_tab_partitions WHERE table_name in ('W_RTL_SLS_TRX_IT_LC_DY_F','W_RTL_NPROF_IT_LC_DY_F') order by partition_name desc;
-- W_RTL_SLS_TRX_IT_LC_DY_F_P418
-- 120170625000
-- 120170618000
-- 120170611000
select DISTINCT
     '1'||mcal_week_start_dt_wid||'000' mcal_week_start_dt_wid
from ra_data_mart.w_mcal_week_d where  mcal_year <= '2018' and '1'||mcal_week_start_dt_wid||'000' > '120170625000' order by 1 asc;
-- 120170625000
-- 120170618000
-- 120170611000

-- 1-1
SELECT * FROM all_tab_partitions WHERE table_name  in  ('W_RTL_INVRC_IT_LC_WK_A') order by partition_name desc;
-- W_RTL_INVRC_IT_LC_WK_A_P418
-- 120170052
-- 120170051
-- 120170050
select row_wid from ra_data_mart.w_mcal_week_d where  mcal_year <= '2018' and row_wid > '120170052' order by 1 asc;
-- 120170052
-- 120170051
-- 120170050

-- 4-5-4
SELECT * FROM all_tab_partitions WHERE table_name IN  ('W_RTL_SLS_SC_WK_A','W_RTL_SLS_SC_LC_WK_CUR_A') order by partition_name desc;
-- W_RTL_SLS_SC_WK_A_P001
-- 120170049
-- 120170044
-- 120170040
select min(row_wid) row_wid from ra_data_mart.w_mcal_week_d b where mcal_year <= '2018'
group by mcal_period_wid having min(row_wid) > '120170049' order by row_wid asc;
-- 120170049
-- 120170044
-- 120170040

-- No needed to add partition
SELECT * FROM all_tab_partitions WHERE table_name in  ('W_RTL_BCOST_IT_LC_DY_TMP','W_RTL_INV_IT_LC_G') 
order by TABLE_NAME,partition_name desc;