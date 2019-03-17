--The PIVOT operator takes data in separate rows, aggregates it and converts it into columns. To see the PIVOT operator in action we need to create a test table.

WITH pivot_test
as
(
 SELECT 1 customer_id, 'A' product_code, 10  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 20  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 30  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 40  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 50  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 60  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 70  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 80  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 90  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 100 quantity FROM dual
)
SELECT
     *
FROM
    pivot_test;
/*
CUSTOMER_ID PRODUCT_CODE QUANTITY
----------- ------------ --------
          1 A                  10
          1 A                  20
          1 A                  30
          2 B                  40
          2 B                  50
          2 B                  60
          3 C                  70
          3 C                  80
          3 D                  90
          3 D                 100
*/

WITH pivot_test
as
(
 SELECT 1 customer_id, 'A' product_code, 10  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 20  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 30  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 40  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 50  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 60  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 70  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 80  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 90  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 100 quantity FROM dual
)
SELECT
     customer_id           customer_id,
     NVL(a_sum_quantity,0) a_sum_quantity,
     NVL(b_sum_quantity,0) b_sum_quantity,
     NVL(c_sum_quantity,0) c_sum_quantity,
     NVL(d_sum_quantity,0) d_sum_quantity
FROM
    pivot_test
PIVOT
(
 SUM(quantity) AS sum_quantity
 FOR(product_code)
 IN (
     'A' AS a,
     'B' AS b,
     'C' AS c,
     'D' AS d
     )
)
ORDER BY 1;

/*
CUSTOMER_ID A_SUM_QUANTITY B_SUM_QUANTITY C_SUM_QUANTITY D_SUM_QUANTITY
----------- -------------- -------------- -------------- --------------
          1             60              0              0              0
          2              0            150              0              0
          3              0              0            150            190
*/

-- Prior to 11g we could accomplish a similar result using the DECODE function combined with aggregate functions.
WITH pivot_test
as
(
 SELECT 1 customer_id, 'A' product_code, 10  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 20  quantity FROM dual UNION ALL
 SELECT 1 customer_id, 'A' product_code, 30  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 40  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 50  quantity FROM dual UNION ALL
 SELECT 2 customer_id, 'B' product_code, 60  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 70  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'C' product_code, 80  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 90  quantity FROM dual UNION ALL
 SELECT 3 customer_id, 'D' product_code, 100 quantity FROM dual
)
SELECT
     customer_id, 
     SUM(DECODE(product_code, 'A', quantity, 0)) AS a_sum_quantity,
     SUM(DECODE(product_code, 'B', quantity, 0)) AS b_sum_quantity,
     SUM(DECODE(product_code, 'C', quantity, 0)) AS c_sum_quantity,
     SUM(DECODE(product_code, 'D', quantity, 0)) AS d_sum_quantity
FROM 
     pivot_test
GROUP BY 
     customer_id
ORDER BY 1;
/*
CUSTOMER_ID A_SUM_QUANTITY B_SUM_QUANTITY C_SUM_QUANTITY D_SUM_QUANTITY
----------- -------------- -------------- -------------- --------------
          1             60              0              0              0
          2              0            150              0              0
          3              0              0            150            190
*/

-- The UNPIVOT operator converts this column-based data into individual rows.
WITH unpivot_test_1
AS
(
 SELECT 1 id, 101 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 2 id, 102 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 3 id, 103 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 4 id, 104 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual 
)
SELECT 
     *
FROM
     unpivot_test_1 ;

/*
ID CUSTOMER_ID PROD_CODE_A PROD_CODE_B PROD_CODE_C PROD_CODE_D
-- ----------- ----------- ----------- ----------- -----------
 1         101          10          20          30          40
 2         102          10          20          30          40
 3         103          10          20          30          40
 4         104          10          20          30          40
*/

WITH unpivot_test_1
AS
(
 SELECT 1 id, 101 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 2 id, 102 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 3 id, 103 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 4 id, 104 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual 
)
SELECT 
     *
FROM
     unpivot_test_1
UNPIVOT (quantity FOR product_code IN (prod_code_a AS 'A',
                                       prod_code_b AS 'B',
                                       prod_code_c AS 'C',
                                       prod_code_d AS 'D'))
ORDER BY 1,2,3;

/*
ID CUSTOMER_ID PRODUCT_CODE QUANTITY
-- ----------- ------------ --------
 1         101 A                  10
 1         101 B                  20
 1         101 C                  30
 1         101 D                  40
 2         102 A                  10
 2         102 B                  20
 2         102 C                  30
 2         102 D                  40
 3         103 A                  10
 3         103 B                  20
 3         103 C                  30
 3         103 D                  40
 4         104 A                  10
 4         104 B                  20
 4         104 C                  30
 4         104 D                  40
*/

WITH unpivot_test_2
AS
(
 SELECT 1 id, 100 modelid,SYSDATE-365 model_effddate, SYSDATE model_enddate,1 col_a_1,1 col_a_2, 1 col_b_1, 1 col_b_2 FROM dual UNION ALL
 SELECT 2 id, 100 modelid,SYSDATE-360 model_effddate, SYSDATE model_enddate,2 col_a_1,2 col_a_2, 2 col_b_1, 2 col_b_2 FROM dual 
)
SELECT 
     *
FROM
     unpivot_test_2 ;

/*
ID MODELID MODEL_EFFDDATE      MODEL_ENDDATE       COL_A_1 COL_A_2 COL_B_1 COL_B_2
-- ------- ------------------- ------------------- ------- ------- ------- -------
 1     100 16.05.2017 23:20:52 16.05.2018 23:20:52       1       1       1       1
 2     100 21.05.2017 23:20:52 16.05.2018 23:20:52       2       2       2       2
*/

WITH unpivot_test_2
AS
(
 SELECT 1 id, 100 modelid,SYSDATE-365 model_effddate, SYSDATE model_enddate,1 col_a_1,1 col_a_2, 1 col_b_1, 1 col_b_2 FROM dual UNION ALL
 SELECT 2 id, 100 modelid,SYSDATE-360 model_effddate, SYSDATE model_enddate,2 col_a_1,2 col_a_2, 2 col_b_1, 2 col_b_2 FROM dual 
)
SELECT
     id                       id,
     modelid                  modelid,
     model_effddate           model_effddate,
     model_effddate           model_enddate,
     col_a                    col_a,
     col_b                    col_b
FROM
    (SELECT
          id,
          model_effddate,
          model_enddate,
          col_a_1,
          col_a_2,
          col_b_1,
          col_b_2
     FROM
          unpivot_test_2
    )
    UNPIVOT INCLUDE NULLS
    (
     (model_effdate,model_enddate,col_a,col_b)
      FOR MODELID IN
        (
         (model_enddate,model_enddate,col_a_1, col_b_1)       AS '100',
         (model_enddate,model_enddate,col_a_2, col_b_2)       AS '200'
        )
    ) 
ORDER BY 3;
/*
ID MODELID MODEL_EFFDDATE      MODEL_ENDDATE       COL_A COL_B
-- ------- ------------------- ------------------- ----- -----
 1 100     16.05.2017 23:21:14 16.05.2017 23:21:14     1     1
 1 200     16.05.2017 23:21:14 16.05.2017 23:21:14     1     1
 2 100     21.05.2017 23:21:14 21.05.2017 23:21:14     2     2
 2 200     21.05.2017 23:21:14 21.05.2017 23:21:14     2     2
*/

--Prior to 11g, we can get the same result using the DECODE function and a pivot table with the correct number of rows. 
--In the following example we use the CONNECT BY clause in a query from dual to generate the correct number of rows for the unpivot operation.

WITH unpivot_test_1
AS
(
 SELECT 1 id, 101 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 2 id, 102 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 3 id, 103 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual UNION ALL
 SELECT 4 id, 104 customer_id, 10 prod_code_a, 20 prod_code_b, 30 prod_code_c, 40 prod_code_d FROM dual 
)
SELECT 
     id,
     customer_id,
     DECODE(unpivot_row, 1, 'A',
                         2, 'B',
                         3, 'C',
                         4, 'D',
                         'N/A') AS prod_code,
     DECODE(unpivot_row, 1, prod_code_a,
                         2, prod_code_b,
                         3, prod_code_c,
                         4, prod_code_d,
                         'N/A') AS quantity
FROM
     unpivot_test_1,
    (SELECT LEVEL AS unpivot_row FROM dual CONNECT BY LEVEL <= 4)
ORDER BY 1,2,3;

/*
ID CUSTOMER_ID PROD_CODE QUANTITY
-- ----------- --------- --------
 1         101 A               10
 1         101 B               20
 1         101 C               30
 1         101 D               40
 2         102 A               10
 2         102 B               20
 2         102 C               30
 2         102 D               40
 3         103 A               10
 3         103 B               20
 3         103 C               30
 3         103 D               40
 4         104 A               10
 4         104 B               20
 4         104 C               30
 4         104 D               40
*/
                                      
