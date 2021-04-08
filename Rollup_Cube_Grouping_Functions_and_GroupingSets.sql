--To Drop And Create a Table
DROP TABLE devesh.tbl_dimension PURGE;
CREATE TABLE devesh.tbl_dimension 
(
  column_fact_1_id   NUMBER       NOT NULL,
  column_fact_2_id   NUMBER       NOT NULL,
  column_fact_3_id   NUMBER       NOT NULL,
  column_fact_4_id   NUMBER       NOT NULL,
  sales_value        NUMBER(10,2) NOT NULL
) 
TABLESPACE tbs_devesh;

--To Populate The Random values for the Relevant Table
INSERT INTO devesh.tbl_dimension
SELECT 
     TRUNC(DBMS_RANDOM.VALUE(low => 1, high => 3))      AS column_fact_1_id,
     TRUNC(DBMS_RANDOM.VALUE(low => 1, high => 6))      AS column_fact_2_id,
     TRUNC(DBMS_RANDOM.VALUE(low => 1, high => 11))     AS column_fact_3_id,
     TRUNC(DBMS_RANDOM.VALUE(low => 1, high => 11))     AS column_fact_4_id,
     ROUND(DBMS_RANDOM.VALUE(low => 1, high => 100), 2) AS sales_value
FROM 
     dual
CONNECT BY level <= 1000;
COMMIT;

--To keep the queries and their output simple I am going to ignore the fact tables and also limit the number of distinct values in the 
--columns of the dimension table.

--GROUP BY
--Now start be reminding ourselves how the GROUP BY clause works. An aggregate function takes multiple rows of data returned by a query 
--and aggregates them into a single result row.

SELECT
     SUM(sales_value) AS sales_value
FROM 
     devesh.tbl_dimension;

/*
SALES_VALUE
-----------
   50528.39
*/

--Including the GROUP BY clause limits the window of data processed by the aggregate function. 
--This way we get an aggregated value for each distinct combination of values present in the columns listed in the GROUP BY clause. 
--The number of rows we expect can be calculated by multiplying the number of distinct values of each column listed in the GROUP BY 
--clause. In this case, if the rows were loaded randomly we would expect the number of distinct values for the first three columns 
--in the table to be 2, 5 and 10 respectively. So using the column_fact_1_id column in the GROUP BY clause should give us 2 rows.

SELECT 
     column_fact_1_id  column_fact_1_id,
     COUNT(*)          num_rows,
     SUM(sales_value)  sales_value
FROM 
     devesh.tbl_dimension
GROUP BY column_fact_1_id
ORDER BY column_fact_1_id;

/*
COLUMN_FACT_1_ID NUM_ROWS SALES_VALUE
---------------- -------- -----------
               1      478    24291.35
               2      522    26237.04
*/

--Including the first two columns in the GROUP BY clause should give us 10 rows (2*5), each with its aggregated values.

SELECT 
     column_fact_1_id  column_fact_1_id,
     column_fact_2_id  column_fact_2_id,
     COUNT(*)          num_rows,
     SUM(sales_value)  sales_value
FROM 
     devesh.tbl_dimension
GROUP BY column_fact_1_id, column_fact_2_id
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID NUM_ROWS  SALES_VALUE
----------------  ---------------- --------  -----------
               1                 1       83      4363.55
               1                 2       96      4794.76
               1                 3       93      4718.25
               1                 4      105      5387.45
               1                 5      101      5027.34
               2                 1      109      5652.84
               2                 2       96      4583.02
               2                 3      110      5555.77
               2                 4      113      5936.67
               2                 5       94      4508.74
*/

--Including the first three columns in the GROUP BY clause should give us 100 rows (2*5*10).

SELECT 
     column_fact_1_id  column_fact_1_id,
     column_fact_2_id  column_fact_2_id,
     column_fact_3_id  column_fact_3_id,
     COUNT(*)          num_rows,
     SUM(sales_value)  sales_value
FROM
     devesh.tbl_dimension
GROUP BY column_fact_1_id, column_fact_2_id, column_fact_3_id
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID   NUM_ROWS   SALES_VALUE
----------------  ----------------  ----------------   ---------- -----------
               1                 1                 1           10      381.61
               1                 1                 2            6      235.29
               1                 1                 3            7       270.7
               1                 1                 4           13      634.05
               1                 1                 5           10      602.36
               1                 1                 6            7      538.41
               1                 1                 7            5      245.87
               1                 1                 8            8      435.54
               1                 1                 9            8      506.59
               1                 1                10            9      513.13
               2                 5                 1           14      714.84
               2                 5                 2           13      686.56
               2                 5                 3           13       579.5
               2                 5                 4           10      336.87
               2                 5                 5            5      215.17
               2                 5                 6            4      268.72
               2                 5                 7           14      667.22
               2                 5                 8            7      451.29
               2                 5                 9            8      365.24
               2                 5                10            6      223.33
*/

--ROLLUP
--In addition to the regular aggregation results we expect from the GROUP BY clause, the ROLLUP extension produces group subtotals 
--from right to left and a grand total. If "n" is the number of columns listed in the ROLLUP, there will be n+1 levels of subtotals.

SELECT 
     column_fact_1_id  column_fact_1_id,
     column_fact_2_id  column_fact_2_id,
     SUM(sales_value)  sales_value
FROM
     devesh.tbl_dimension
GROUP BY ROLLUP (column_fact_1_id, column_fact_2_id)
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE
----------------  ---------------- -----------
               1                 1     4363.55
               1                 2     4794.76
               1                 3     4718.25
               1                 4     5387.45
               1                 5     5027.34
               1                      24291.35
               2                 1     5652.84
               2                 2     4583.02
               2                 3     5555.77
               2                 4     5936.67
               2                 5     4508.74
               2                      26237.04
                                      50528.39
*/

--Looking at the output in a SQL*Plus or a grid output, you can visually identify the rows containing subtotals as they have null values in the 
--ROLLUP columns. It may be easier to spot when scanning down the output. Obviously, if the raw data contains 
--null values, using this visual identification is not an accurate approach.

SELECT 
     column_fact_1_id  column_fact_1_id,
     column_fact_2_id  column_fact_2_id,
     column_fact_3_id  column_fact_3_id,
     SUM(sales_value)  sales_value
FROM
     devesh.tbl_dimension
GROUP BY ROLLUP (column_fact_1_id, column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE
----------------  ----------------  ---------------- -----------
               1                 1                 1      381.61
               1                 1                 2      235.29
               1                 1                 3       270.7
               1                 1                 4      634.05
               1                 1                 5      602.36
               1                 1                 6      538.41
               1                 1                 7      245.87
               1                 1                 8      435.54
               1                 1                 9      506.59
               1                 1                10      513.13
               1                 1                       4363.55
               1                 2                 1      370.97
               1                 2                 2      259.31
               1                 2                 3      509.68
               1                 2                 4      668.64
               1                 2                 5      614.99
               1                 2                 6      298.12
               1                 2                 7      466.98
               1                 2                 8      479.95
               1                 2                 9      575.89
               1                 2                10      550.23
               1                 2                       4794.76
               1                 3                 1      607.06
               1                 3                 2      470.61
               1                 3                 3      514.79
               1                 3                 4      367.72
               1                 3                 5      415.19
               1                 3                 6      390.99
               1                 3                 7      440.98
               1                 3                 8      642.67
               1                 3                 9      461.13
               1                 3                10      407.11
               1                 3                       4718.25
               1                 4                 1      834.37
               1                 4                 2      471.72
               1                 4                 3      339.45
               1                 4                 4       337.9
               1                 4                 5      409.88
               1                 4                 6      719.47
               1                 4                 7      390.67
               1                 4                 8      595.08
               1                 4                 9      890.73
               1                 4                10      398.18
               1                 4                       5387.45
               1                 5                 1      543.39
               1                 5                 2      417.36
               1                 5                 3      456.34
               1                 5                 4      596.86
               1                 5                 5      548.51
               1                 5                 6      559.91
               1                 5                 7      295.35
               1                 5                 8       799.8
               1                 5                 9      344.41
               1                 5                10      465.41
               1                 5                       5027.34
               1                                        24291.35
               2                 1                 1      838.08
               2                 1                 2      252.93
               2                 1                 3      989.74
               2                 1                 4      736.87
               2                 1                 5      895.58
               2                 1                 6      559.87
               2                 1                 7      334.42
               2                 1                 8       346.8
               2                 1                 9      379.27
               2                 1                10      319.28
               2                 1                       5652.84
               2                 2                 1      466.31
               2                 2                 2      648.44
               2                 2                 3      262.44
               2                 2                 4      343.78
               2                 2                 5      331.71
               2                 2                 6      594.96
               2                 2                 7      707.46
               2                 2                 8      512.56
               2                 2                 9      170.11
               2                 2                10      545.25
               2                 2                       4583.02
               2                 3                 1      812.17
               2                 3                 2      488.23
               2                 3                 3      840.21
               2                 3                 4      447.27
               2                 3                 5       759.4
               2                 3                 6      646.82
               2                 3                 7      202.86
               2                 3                 8      489.98
               2                 3                 9      351.16
               2                 3                10      517.67
               2                 3                       5555.77
               2                 4                 1      681.29
               2                 4                 2      771.78
               2                 4                 3      300.61
               2                 4                 4      669.27
               2                 4                 5      914.13
               2                 4                 6      705.48
               2                 4                 7      296.23
               2                 4                 8      557.92
               2                 4                 9      618.33
               2                 4                10      421.63
               2                 4                       5936.67
               2                 5                 1      714.84
               2                 5                 2      686.56
               2                 5                 3       579.5
               2                 5                 4      336.87
               2                 5                 5      215.17
               2                 5                 6      268.72
               2                 5                 7      667.22
               2                 5                 8      451.29
               2                 5                 9      365.24
               2                 5                10      223.33
               2                 5                       4508.74
               2                                        26237.04
                                                        50528.39
*/

--It is possible to do a partial rollup to reduce the number of subtotals calculated.

SELECT 
     column_fact_1_id   column_fact_1_id,
     column_fact_2_id   column_fact_2_id,
     column_fact_3_id   column_fact_3_id,
     SUM(sales_value)   sales_value
FROM 
     devesh.tbl_dimension
GROUP BY column_fact_1_id, ROLLUP (column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE
----------------  ----------------  ---------------- -----------
               1                 1                 1      381.61
               1                 1                 2      235.29
               1                 1                 3       270.7
               1                 1                 4      634.05
               1                 1                 5      602.36
               1                 1                 6      538.41
               1                 1                 7      245.87
               1                 1                 8      435.54
               1                 1                 9      506.59
               1                 1                10      513.13
               1                 1                       4363.55
               1                 2                 1      370.97
               1                 2                 2      259.31
               1                 2                 3      509.68
               1                 2                 4      668.64
               1                 2                 5      614.99
               1                 2                 6      298.12
               1                 2                 7      466.98
               1                 2                 8      479.95
               1                 2                 9      575.89
               1                 2                10      550.23
               1                 2                       4794.76
               1                 3                 1      607.06
               1                 3                 2      470.61
               1                 3                 3      514.79
               1                 3                 4      367.72
               1                 3                 5      415.19
               1                 3                 6      390.99
               1                 3                 7      440.98
               1                 3                 8      642.67
               1                 3                 9      461.13
               1                 3                10      407.11
               1                 3                       4718.25
               1                 4                 1      834.37
               1                 4                 2      471.72
               1                 4                 3      339.45
               1                 4                 4       337.9
               1                 4                 5      409.88
               1                 4                 6      719.47
               1                 4                 7      390.67
               1                 4                 8      595.08
               1                 4                 9      890.73
               1                 4                10      398.18
               1                 4                       5387.45
               1                 5                 1      543.39
               1                 5                 2      417.36
               1                 5                 3      456.34
               1                 5                 4      596.86
               1                 5                 5      548.51
               1                 5                 6      559.91
               1                 5                 7      295.35
               1                 5                 8       799.8
               1                 5                 9      344.41
               1                 5                10      465.41
               1                 5                       5027.34
               1                                        24291.35
               2                 1                 1      838.08
               2                 1                 2      252.93
               2                 1                 3      989.74
               2                 1                 4      736.87
               2                 1                 5      895.58
               2                 1                 6      559.87
               2                 1                 7      334.42
               2                 1                 8       346.8
               2                 1                 9      379.27
               2                 1                10      319.28
               2                 1                       5652.84
               2                 2                 1      466.31
               2                 2                 2      648.44
               2                 2                 3      262.44
               2                 2                 4      343.78
               2                 2                 5      331.71
               2                 2                 6      594.96
               2                 2                 7      707.46
               2                 2                 8      512.56
               2                 2                 9      170.11
               2                 2                10      545.25
               2                 2                       4583.02
               2                 3                 1      812.17
               2                 3                 2      488.23
               2                 3                 3      840.21
               2                 3                 4      447.27
               2                 3                 5       759.4
               2                 3                 6      646.82
               2                 3                 7      202.86
               2                 3                 8      489.98
               2                 3                 9      351.16
               2                 3                10      517.67
               2                 3                       5555.77
               2                 4                 1      681.29
               2                 4                 2      771.78
               2                 4                 3      300.61
               2                 4                 4      669.27
               2                 4                 5      914.13
               2                 4                 6      705.48
               2                 4                 7      296.23
               2                 4                 8      557.92
               2                 4                 9      618.33
               2                 4                10      421.63
               2                 4                       5936.67
               2                 5                 1      714.84
               2                 5                 2      686.56
               2                 5                 3       579.5
               2                 5                 4      336.87
               2                 5                 5      215.17
               2                 5                 6      268.72
               2                 5                 7      667.22
               2                 5                 8      451.29
               2                 5                 9      365.24
               2                 5                10      223.33
               2                 5                       4508.74
               2                                        26237.04
*/

--CUBE
--In addition to the subtotals generated by the ROLLUP extension, the CUBE extension will generate subtotals for all combinations of the 
--dimensions specified. If "n" is the number of columns listed in the CUBE, there will be 2n subtotal combinations.

SELECT 
     column_fact_1_id   column_fact_1_id,
     column_fact_2_id   column_fact_2_id,
     SUM(sales_value)   sales_value
FROM
     devesh.tbl_dimension
GROUP BY CUBE (column_fact_1_id, column_fact_2_id)
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE
----------------  ---------------- -----------
               1                 1     4363.55
               1                 2     4794.76
               1                 3     4718.25
               1                 4     5387.45
               1                 5     5027.34
               1                      24291.35
               2                 1     5652.84
               2                 2     4583.02
               2                 3     5555.77
               2                 4     5936.67
               2                 5     4508.74
               2                      26237.04
                                 1    10016.39
                                 2     9377.78
                                 3    10274.02
                                 4    11324.12
                                 5     9536.08
                                      50528.39
*/

--As the number of dimensions increase, so do the combinations of subtotals that need to be calculated.

SELECT 
     column_fact_1_id   column_fact_1_id,
     column_fact_2_id   column_fact_2_id,
     column_fact_3_id   column_fact_3_id,
     SUM(sales_value)   sales_value
FROM
     devesh.tbl_dimension
GROUP BY CUBE (column_fact_1_id, column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE
----------------  ----------------  ---------------- -----------
               1                 1                 1      381.61
               1                 1                 2      235.29
               1                 1                 3       270.7
               1                 1                 4      634.05
               1                 1                 5      602.36
               1                 1                 6      538.41
               1                 1                 7      245.87
               1                 1                 8      435.54
               1                 1                 9      506.59
               1                 1                10      513.13
               1                 1                       4363.55
               1                 2                 1      370.97
               1                 2                 2      259.31
               1                 2                 3      509.68
               1                 2                 4      668.64
               1                 2                 5      614.99
               1                 2                 6      298.12
               1                 2                 7      466.98
               1                 2                 8      479.95
               1                 2                 9      575.89
               1                 2                10      550.23
               1                 2                       4794.76
               1                 3                 1      607.06
               1                 3                 2      470.61
               1                 3                 3      514.79
               1                 3                 4      367.72
               1                 3                 5      415.19
               1                 3                 6      390.99
               1                 3                 7      440.98
               1                 3                 8      642.67
               1                 3                 9      461.13
               1                 3                10      407.11
               1                 3                       4718.25
               1                 4                 1      834.37
               1                 4                 2      471.72
               1                 4                 3      339.45
               1                 4                 4       337.9
               1                 4                 5      409.88
               1                 4                 6      719.47
               1                 4                 7      390.67
               1                 4                 8      595.08
               1                 4                 9      890.73
               1                 4                10      398.18
               1                 4                       5387.45
               1                 5                 1      543.39
               1                 5                 2      417.36
               1                 5                 3      456.34
               1                 5                 4      596.86
               1                 5                 5      548.51
               1                 5                 6      559.91
               1                 5                 7      295.35
               1                 5                 8       799.8
               1                 5                 9      344.41
               1                 5                10      465.41
               1                 5                       5027.34
               1                                   1      2737.4
               1                                   2     1854.29
               1                                   3     2090.96
               1                                   4     2605.17
               1                                   5     2590.93
               1                                   6      2506.9
               1                                   7     1839.85
               1                                   8     2953.04
               1                                   9     2778.75
               1                                  10     2334.06
               1                                        24291.35
               2                 1                 1      838.08
               2                 1                 2      252.93
               2                 1                 3      989.74
               2                 1                 4      736.87
               2                 1                 5      895.58
               2                 1                 6      559.87
               2                 1                 7      334.42
               2                 1                 8       346.8
               2                 1                 9      379.27
               2                 1                10      319.28
               2                 1                       5652.84
               2                 2                 1      466.31
               2                 2                 2      648.44
               2                 2                 3      262.44
               2                 2                 4      343.78
               2                 2                 5      331.71
               2                 2                 6      594.96
               2                 2                 7      707.46
               2                 2                 8      512.56
               2                 2                 9      170.11
               2                 2                10      545.25
               2                 2                       4583.02
               2                 3                 1      812.17
               2                 3                 2      488.23
               2                 3                 3      840.21
               2                 3                 4      447.27
               2                 3                 5       759.4
               2                 3                 6      646.82
               2                 3                 7      202.86
               2                 3                 8      489.98
               2                 3                 9      351.16
               2                 3                10      517.67
               2                 3                       5555.77
               2                 4                 1      681.29
               2                 4                 2      771.78
               2                 4                 3      300.61
               2                 4                 4      669.27
               2                 4                 5      914.13
               2                 4                 6      705.48
               2                 4                 7      296.23
               2                 4                 8      557.92
               2                 4                 9      618.33
               2                 4                10      421.63
               2                 4                       5936.67
               2                 5                 1      714.84
               2                 5                 2      686.56
               2                 5                 3       579.5
               2                 5                 4      336.87
               2                 5                 5      215.17
               2                 5                 6      268.72
               2                 5                 7      667.22
               2                 5                 8      451.29
               2                 5                 9      365.24
               2                 5                10      223.33
               2                 5                       4508.74
               2                                   1     3512.69
               2                                   2     2847.94
               2                                   3      2972.5
               2                                   4     2534.06
               2                                   5     3115.99
               2                                   6     2775.85
               2                                   7     2208.19
               2                                   8     2358.55
               2                                   9     1884.11
               2                                  10     2027.16
               2                                        26237.04
                                 1                 1     1219.69
                                 1                 2      488.22
                                 1                 3     1260.44
                                 1                 4     1370.92
                                 1                 5     1497.94
                                 1                 6     1098.28
                                 1                 7      580.29
                                 1                 8      782.34
                                 1                 9      885.86
                                 1                10      832.41
                                 1                      10016.39
                                 2                 1      837.28
                                 2                 2      907.75
                                 2                 3      772.12
                                 2                 4     1012.42
                                 2                 5       946.7
                                 2                 6      893.08
                                 2                 7     1174.44
                                 2                 8      992.51
                                 2                 9         746
                                 2                10     1095.48
                                 2                       9377.78
                                 3                 1     1419.23
                                 3                 2      958.84
                                 3                 3        1355
                                 3                 4      814.99
                                 3                 5     1174.59
                                 3                 6     1037.81
                                 3                 7      643.84
                                 3                 8     1132.65
                                 3                 9      812.29
                                 3                10      924.78
                                 3                      10274.02
                                 4                 1     1515.66
                                 4                 2      1243.5
                                 4                 3      640.06
                                 4                 4     1007.17
                                 4                 5     1324.01
                                 4                 6     1424.95
                                 4                 7       686.9
                                 4                 8        1153
                                 4                 9     1509.06
                                 4                10      819.81
                                 4                      11324.12
                                 5                 1     1258.23
                                 5                 2     1103.92
                                 5                 3     1035.84
                                 5                 4      933.73
                                 5                 5      763.68
                                 5                 6      828.63
                                 5                 7      962.57
                                 5                 8     1251.09
                                 5                 9      709.65
                                 5                10      688.74
                                 5                       9536.08
                                                   1     6250.09
                                                   2     4702.23
                                                   3     5063.46
                                                   4     5139.23
                                                   5     5706.92
                                                   6     5282.75
                                                   7     4048.04
                                                   8     5311.59
                                                   9     4662.86
                                                  10     4361.22
                                                        50528.39
*/

--It is possible to do a partial cube to reduce the number of subtotals calculated.

SELECT 
     column_fact_1_id   column_fact_1_id,
     column_fact_2_id   column_fact_2_id,
     column_fact_3_id   column_fact_3_id,
     SUM(sales_value)   sales_value
FROM
     devesh.tbl_dimension
GROUP BY column_fact_1_id, CUBE (column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE
----------------  ----------------  ---------------- -----------
               1                 1                 1      381.61
               1                 1                 2      235.29
               1                 1                 3       270.7
               1                 1                 4      634.05
               1                 1                 5      602.36
               1                 1                 6      538.41
               1                 1                 7      245.87
               1                 1                 8      435.54
               1                 1                 9      506.59
               1                 1                10      513.13
               1                 1                       4363.55
               1                 2                 1      370.97
               1                 2                 2      259.31
               1                 2                 3      509.68
               1                 2                 4      668.64
               1                 2                 5      614.99
               1                 2                 6      298.12
               1                 2                 7      466.98
               1                 2                 8      479.95
               1                 2                 9      575.89
               1                 2                10      550.23
               1                 2                       4794.76
               1                 3                 1      607.06
               1                 3                 2      470.61
               1                 3                 3      514.79
               1                 3                 4      367.72
               1                 3                 5      415.19
               1                 3                 6      390.99
               1                 3                 7      440.98
               1                 3                 8      642.67
               1                 3                 9      461.13
               1                 3                10      407.11
               1                 3                       4718.25
               1                 4                 1      834.37
               1                 4                 2      471.72
               1                 4                 3      339.45
               1                 4                 4       337.9
               1                 4                 5      409.88
               1                 4                 6      719.47
               1                 4                 7      390.67
               1                 4                 8      595.08
               1                 4                 9      890.73
               1                 4                10      398.18
               1                 4                       5387.45
               1                 5                 1      543.39
               1                 5                 2      417.36
               1                 5                 3      456.34
               1                 5                 4      596.86
               1                 5                 5      548.51
               1                 5                 6      559.91
               1                 5                 7      295.35
               1                 5                 8       799.8
               1                 5                 9      344.41
               1                 5                10      465.41
               1                 5                       5027.34
               1                                   1      2737.4
               1                                   2     1854.29
               1                                   3     2090.96
               1                                   4     2605.17
               1                                   5     2590.93
               1                                   6      2506.9
               1                                   7     1839.85
               1                                   8     2953.04
               1                                   9     2778.75
               1                                  10     2334.06
               1                                        24291.35
               2                 1                 1      838.08
               2                 1                 2      252.93
               2                 1                 3      989.74
               2                 1                 4      736.87
               2                 1                 5      895.58
               2                 1                 6      559.87
               2                 1                 7      334.42
               2                 1                 8       346.8
               2                 1                 9      379.27
               2                 1                10      319.28
               2                 1                       5652.84
               2                 2                 1      466.31
               2                 2                 2      648.44
               2                 2                 3      262.44
               2                 2                 4      343.78
               2                 2                 5      331.71
               2                 2                 6      594.96
               2                 2                 7      707.46
               2                 2                 8      512.56
               2                 2                 9      170.11
               2                 2                10      545.25
               2                 2                       4583.02
               2                 3                 1      812.17
               2                 3                 2      488.23
               2                 3                 3      840.21
               2                 3                 4      447.27
               2                 3                 5       759.4
               2                 3                 6      646.82
               2                 3                 7      202.86
               2                 3                 8      489.98
               2                 3                 9      351.16
               2                 3                10      517.67
               2                 3                       5555.77
               2                 4                 1      681.29
               2                 4                 2      771.78
               2                 4                 3      300.61
               2                 4                 4      669.27
               2                 4                 5      914.13
               2                 4                 6      705.48
               2                 4                 7      296.23
               2                 4                 8      557.92
               2                 4                 9      618.33
               2                 4                10      421.63
               2                 4                       5936.67
               2                 5                 1      714.84
               2                 5                 2      686.56
               2                 5                 3       579.5
               2                 5                 4      336.87
               2                 5                 5      215.17
               2                 5                 6      268.72
               2                 5                 7      667.22
               2                 5                 8      451.29
               2                 5                 9      365.24
               2                 5                10      223.33
               2                 5                       4508.74
               2                                   1     3512.69
               2                                   2     2847.94
               2                                   3      2972.5
               2                                   4     2534.06
               2                                   5     3115.99
               2                                   6     2775.85
               2                                   7     2208.19
               2                                   8     2358.55
               2                                   9     1884.11
               2                                  10     2027.16
               2                                        26237.04
*/

--GROUPING Functions
--GROUPING
--It can be quite easy to visually identify subtotals generated by rollups and cubes, but to do it programatically you really need something 
--more accurate than the presence of null values in the grouping columns. This is where the GROUPING function comes in. It accepts a single 
--column as a parameter and returns "1" if the column contains a null value generated as part of a subtotal by a ROLLUP or CUBE operation 
--or "0" for any other value, including stored null values.

--The following query is a repeat of a previous cube, but the GROUPING function has been added for each of the dimensions in the cube.

SELECT 
     column_fact_1_id            column_fact_1_id,
     column_fact_2_id            column_fact_2_id,
     SUM(sales_value)            sales_value,
     GROUPING(column_fact_1_id)  f1g, 
     GROUPING(column_fact_2_id)  f2g
FROM
     devesh.tbl_dimension
GROUP BY CUBE (column_fact_1_id, column_fact_2_id)
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE F1G F2G
----------------  ---------------- ----------- --- ---
               1                 1     4363.55   0   0
               1                 2     4794.76   0   0
               1                 3     4718.25   0   0
               1                 4     5387.45   0   0
               1                 5     5027.34   0   0
               1                      24291.35   0   1
               2                 1     5652.84   0   0
               2                 2     4583.02   0   0
               2                 3     5555.77   0   0
               2                 4     5936.67   0   0
               2                 5     4508.74   0   0
               2                      26237.04   0   1
                                 1    10016.39   1   0
                                 2     9377.78   1   0
                                 3    10274.02   1   0
                                 4    11324.12   1   0
                                 5     9536.08   1   0
                                      50528.39   1   1
*/

--From this we can see:
/*
F1G=0,F2G=0 : Represents a row containing regular subtotal we would expect from a GROUP BY operation.
F1G=0,F2G=1 : Represents a row containing a subtotal for a distinct value of the column_fact_1_ID column, as generated by ROLLUP and CUBE operations.
F1G=1,F2G=0 : Represents a row containing a subtotal for a distinct value of the column_fact_2_ID column, which we would only see in a CUBE operation.
F1G=1,F2G=1 : Represents a row containing a grand total for the query, as generated by ROLLUP and CUBE operations.

It would now be easy to write a program to accurately process the data.
*/

--The GROUPING columns can used for ordering or filtering results.

SELECT 
     column_fact_1_id             column_fact_1_id,
     column_fact_2_id             column_fact_2_id,
     SUM(sales_value)             sales_value,
     GROUPING(column_fact_1_id)   f1g, 
     GROUPING(column_fact_2_id)   f2g
FROM
     devesh.tbl_dimension
GROUP BY CUBE (column_fact_1_id, column_fact_2_id)
HAVING GROUPING(column_fact_1_id) = 1 OR GROUPING(column_fact_2_id) = 1
ORDER BY GROUPING(column_fact_1_id), GROUPING(column_fact_2_id);

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE F1G F2G
----------------  ---------------- ----------- --- ---
               1                      24291.35   0   1
               2                      26237.04   0   1
                                 4    11324.12   1   0
                                 3    10274.02   1   0
                                 2     9377.78   1   0
                                 1    10016.39   1   0
                                 5     9536.08   1   0
                                      50528.39   1   1
*/

--GROUPING_ID
--The GROUPING_ID function provides an alternate and more compact way to identify subtotal rows. Passing the dimension columns as arguments, 
--it returns a number indicating the GROUP BY level.

SELECT 
     column_fact_1_id                                 column_fact_1_id,
     column_fact_2_id                                 column_fact_2_id,
     SUM(sales_value)                                 sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY CUBE (column_fact_1_id, column_fact_2_id)
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE GROUPING_ID
----------------  ---------------- ----------- -----------
               1                 1     4363.55           0
               1                 2     4794.76           0
               1                 3     4718.25           0
               1                 4     5387.45           0
               1                 5     5027.34           0
               1                      24291.35           1
               2                 1     5652.84           0
               2                 2     4583.02           0
               2                 3     5555.77           0
               2                 4     5936.67           0
               2                 5     4508.74           0
               2                      26237.04           1
                                 1    10016.39           2
                                 2     9377.78           2
                                 3    10274.02           2
                                 4    11324.12           2
                                 5     9536.08           2
                                      50528.39           3
*/

--GROUP_ID
--This is possible to write queries that return the duplicate subtotals, which can be a little confusing. The GROUP_ID function assigns the 
--value "0" to the first set, and all subsequent sets get assigned a higher number. The following query forces duplicates to show the 
--GROUP_ID function in action.

SELECT 
     column_fact_1_id                                 column_fact_1_id,
     column_fact_2_id                                 column_fact_2_id,
     SUM(sales_value)                                 sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id)  grouping_id,
     GROUP_ID()                                       group_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS(column_fact_1_id, CUBE (column_fact_1_id, column_fact_2_id))
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE GROUPING_ID   GROUP_ID
----------------  ---------------- ----------- ----------- ----------
               1                 1     4363.55           0          0
               1                 2     4794.76           0          0
               1                 3     4718.25           0          0
               1                 4     5387.45           0          0
               1                 5     5027.34           0          0
               1                      24291.35           1          1
               1                      24291.35           1          0
               2                 1     5652.84           0          0
               2                 2     4583.02           0          0
               2                 3     5555.77           0          0
               2                 4     5936.67           0          0
               2                 5     4508.74           0          0
               2                      26237.04           1          1
               2                      26237.04           1          0
                                 1    10016.39           2          0
                                 2     9377.78           2          0
                                 3    10274.02           2          0
                                 4    11324.12           2          0
                                 5     9536.08           2          0
                                      50528.39           3          0
*/

--If necessary, you could then filter the results using the group.

SELECT 
     column_fact_1_id                                 column_fact_1_id,
     column_fact_2_id                                 column_fact_2_id,
     SUM(sales_value)                                 sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id)  grouping_id,
     GROUP_ID()                                       group_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS(column_fact_1_id, CUBE (column_fact_1_id, column_fact_2_id))
HAVING GROUP_ID() = 0
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE GROUPING_ID   GROUP_ID
----------------  ---------------- ----------- ----------- ----------
               1                 1     4363.55           0          0
               1                 2     4794.76           0          0
               1                 3     4718.25           0          0
               1                 4     5387.45           0          0
               1                 5     5027.34           0          0
               1                      24291.35           1          0
               2                 1     5652.84           0          0
               2                 2     4583.02           0          0
               2                 3     5555.77           0          0
               2                 4     5936.67           0          0
               2                 5     4508.74           0          0
               2                      26237.04           1          0
                                 1    10016.39           2          0
                                 2     9377.78           2          0
                                 3    10274.02           2          0
                                 4    11324.12           2          0
                                 5     9536.08           2          0
                                      50528.39           3          0
*/

--GROUPING SETS
--Calculating all possible subtotals in a cube, especially those with many dimensions, can be quite an intensive process. If you don't need 
--all the subtotals, this can represent a considerable amount of wasted effort. The following cube with three dimensions gives 8 levels of 
--subtotals (GROUPING_ID: 0-7).

SELECT 
     column_fact_1_id                                                   column_fact_1_id,
     column_fact_2_id                                                   column_fact_2_id,
     column_fact_3_id                                                   column_fact_3_id,
     SUM(sales_value)                                                   sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id, column_fact_3_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY CUBE(column_fact_1_id, column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE GROUPING_ID
----------------  ----------------  ---------------- ----------- -----------
               1                 1                 1      381.61           0
               1                 1                 2      235.29           0
               1                 1                 3       270.7           0
               1                 1                 4      634.05           0
               1                 1                 5      602.36           0
               1                 1                 6      538.41           0
               1                 1                 7      245.87           0
               1                 1                 8      435.54           0
               1                 1                 9      506.59           0
               1                 1                10      513.13           0
               1                 1                       4363.55           1
               1                 2                 1      370.97           0
               1                 2                 2      259.31           0
               1                 2                 3      509.68           0
               1                 2                 4      668.64           0
               1                 2                 5      614.99           0
               1                 2                 6      298.12           0
               1                 2                 7      466.98           0
               1                 2                 8      479.95           0
               1                 2                 9      575.89           0
               1                 2                10      550.23           0
               1                 2                       4794.76           1
               1                 3                 1      607.06           0
               1                 3                 2      470.61           0
               1                 3                 3      514.79           0
               1                 3                 4      367.72           0
               1                 3                 5      415.19           0
               1                 3                 6      390.99           0
               1                 3                 7      440.98           0
               1                 3                 8      642.67           0
               1                 3                 9      461.13           0
               1                 3                10      407.11           0
               1                 3                       4718.25           1
               1                 4                 1      834.37           0
               1                 4                 2      471.72           0
               1                 4                 3      339.45           0
               1                 4                 4       337.9           0
               1                 4                 5      409.88           0
               1                 4                 6      719.47           0
               1                 4                 7      390.67           0
               1                 4                 8      595.08           0
               1                 4                 9      890.73           0
               1                 4                10      398.18           0
               1                 4                       5387.45           1
               1                 5                 1      543.39           0
               1                 5                 2      417.36           0
               1                 5                 3      456.34           0
               1                 5                 4      596.86           0
               1                 5                 5      548.51           0
               1                 5                 6      559.91           0
               1                 5                 7      295.35           0
               1                 5                 8       799.8           0
               1                 5                 9      344.41           0
               1                 5                10      465.41           0
               1                 5                       5027.34           1
               1                                   1      2737.4           2
               1                                   2     1854.29           2
               1                                   3     2090.96           2
               1                                   4     2605.17           2
               1                                   5     2590.93           2
               1                                   6      2506.9           2
               1                                   7     1839.85           2
               1                                   8     2953.04           2
               1                                   9     2778.75           2
               1                                  10     2334.06           2
               1                                        24291.35           3
               2                 1                 1      838.08           0
               2                 1                 2      252.93           0
               2                 1                 3      989.74           0
               2                 1                 4      736.87           0
               2                 1                 5      895.58           0
               2                 1                 6      559.87           0
               2                 1                 7      334.42           0
               2                 1                 8       346.8           0
               2                 1                 9      379.27           0
               2                 1                10      319.28           0
               2                 1                       5652.84           1
               2                 2                 1      466.31           0
               2                 2                 2      648.44           0
               2                 2                 3      262.44           0
               2                 2                 4      343.78           0
               2                 2                 5      331.71           0
               2                 2                 6      594.96           0
               2                 2                 7      707.46           0
               2                 2                 8      512.56           0
               2                 2                 9      170.11           0
               2                 2                10      545.25           0
               2                 2                       4583.02           1
               2                 3                 1      812.17           0
               2                 3                 2      488.23           0
               2                 3                 3      840.21           0
               2                 3                 4      447.27           0
               2                 3                 5       759.4           0
               2                 3                 6      646.82           0
               2                 3                 7      202.86           0
               2                 3                 8      489.98           0
               2                 3                 9      351.16           0
               2                 3                10      517.67           0
               2                 3                       5555.77           1
               2                 4                 1      681.29           0
               2                 4                 2      771.78           0
               2                 4                 3      300.61           0
               2                 4                 4      669.27           0
               2                 4                 5      914.13           0
               2                 4                 6      705.48           0
               2                 4                 7      296.23           0
               2                 4                 8      557.92           0
               2                 4                 9      618.33           0
               2                 4                10      421.63           0
               2                 4                       5936.67           1
               2                 5                 1      714.84           0
               2                 5                 2      686.56           0
               2                 5                 3       579.5           0
               2                 5                 4      336.87           0
               2                 5                 5      215.17           0
               2                 5                 6      268.72           0
               2                 5                 7      667.22           0
               2                 5                 8      451.29           0
               2                 5                 9      365.24           0
               2                 5                10      223.33           0
               2                 5                       4508.74           1
               2                                   1     3512.69           2
               2                                   2     2847.94           2
               2                                   3      2972.5           2
               2                                   4     2534.06           2
               2                                   5     3115.99           2
               2                                   6     2775.85           2
               2                                   7     2208.19           2
               2                                   8     2358.55           2
               2                                   9     1884.11           2
               2                                  10     2027.16           2
               2                                        26237.04           3
                                 1                 1     1219.69           4
                                 1                 2      488.22           4
                                 1                 3     1260.44           4
                                 1                 4     1370.92           4
                                 1                 5     1497.94           4
                                 1                 6     1098.28           4
                                 1                 7      580.29           4
                                 1                 8      782.34           4
                                 1                 9      885.86           4
                                 1                10      832.41           4
                                 1                      10016.39           5
                                 2                 1      837.28           4
                                 2                 2      907.75           4
                                 2                 3      772.12           4
                                 2                 4     1012.42           4
                                 2                 5       946.7           4
                                 2                 6      893.08           4
                                 2                 7     1174.44           4
                                 2                 8      992.51           4
                                 2                 9         746           4
                                 2                10     1095.48           4
                                 2                       9377.78           5
                                 3                 1     1419.23           4
                                 3                 2      958.84           4
                                 3                 3        1355           4
                                 3                 4      814.99           4
                                 3                 5     1174.59           4
                                 3                 6     1037.81           4
                                 3                 7      643.84           4
                                 3                 8     1132.65           4
                                 3                 9      812.29           4
                                 3                10      924.78           4
                                 3                      10274.02           5
                                 4                 1     1515.66           4
                                 4                 2      1243.5           4
                                 4                 3      640.06           4
                                 4                 4     1007.17           4
                                 4                 5     1324.01           4
                                 4                 6     1424.95           4
                                 4                 7       686.9           4
                                 4                 8        1153           4
                                 4                 9     1509.06           4
                                 4                10      819.81           4
                                 4                      11324.12           5
                                 5                 1     1258.23           4
                                 5                 2     1103.92           4
                                 5                 3     1035.84           4
                                 5                 4      933.73           4
                                 5                 5      763.68           4
                                 5                 6      828.63           4
                                 5                 7      962.57           4
                                 5                 8     1251.09           4
                                 5                 9      709.65           4
                                 5                10      688.74           4
                                 5                       9536.08           5
                                                   1     6250.09           6
                                                   2     4702.23           6
                                                   3     5063.46           6
                                                   4     5139.23           6
                                                   5     5706.92           6
                                                   6     5282.75           6
                                                   7     4048.04           6
                                                   8     5311.59           6
                                                   9     4662.86           6
                                                  10     4361.22           6
                                                        50528.39           7
*/

--If we only need a few of these levels of subtotaling we can use the GROUPING SETS expression and specify exactly which ones we need, 
--saving us having to calculate the whole cube. In the following query we are only interested in subtotals for the "column_fact_1_id, column_fact_2_id" 
--and "column_fact_1_id, column_fact_3_id" groups.

SELECT 
     column_fact_1_id                                                   column_fact_1_id,
     column_fact_2_id                                                   column_fact_2_id,
     column_fact_3_id                                                   column_fact_3_id,
     SUM(sales_value)                                                   sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id, column_fact_3_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS((column_fact_1_id, column_fact_2_id), (column_fact_1_id, column_fact_3_id))
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE GROUPING_ID
----------------  ----------------  ---------------- ----------- -----------
                1                1                       4363.55           1
                1                2                       4794.76           1
                1                3                       4718.25           1
                1                4                       5387.45           1
                1                5                       5027.34           1
                1                                  1      2737.4           2
                1                                  2     1854.29           2
                1                                  3     2090.96           2
                1                                  4     2605.17           2
                1                                  5     2590.93           2
                1                                  6      2506.9           2
                1                                  7     1839.85           2
                1                                  8     2953.04           2
                1                                  9     2778.75           2
                1                                 10     2334.06           2
                2                1                       5652.84           1
                2                2                       4583.02           1
                2                3                       5555.77           1
                2                4                       5936.67           1
                2                5                       4508.74           1
                2                                  1     3512.69           2
                2                                  2     2847.94           2
                2                                  3      2972.5           2
                2                                  4     2534.06           2
                2                                  5     3115.99           2
                2                                  6     2775.85           2
                2                                  7     2208.19           2
                2                                  8     2358.55           2
                2                                  9     1884.11           2
                2                                 10     2027.16           2
*/

--Note, how we have gone from returning 198 rows with 8 subtotal levels in the cube, to just 30 rows with 2 subtotal levels.

--Composite Columns
--ROLLUP and CUBE consider each column independently when deciding which subtotals must be calculated. For ROLLUP this means stepping 
--back through the list to determine the groupings.

ROLLUP (a, b, c)
(a, b, c)
(a, b)
(a)
()

--CUBE creates a grouping for every possible combination of columns.

CUBE (a, b, c)
(a, b, c)
(a, b)
(a, c)
(a)
(b, c)
(b)
(c)
()

--Composite columns allow columns to be grouped together with braces so they are treated as a single unit when determining the necessary 
--groupings. In the following ROLLUP columns "a" and "b" have been turned into a composite column by the additional braces. As a result 
--the group of "a" is not longer calculated as the column "a" is only present as part of the composite column in the statement.

ROLLUP ((a, b), c)
(a, b, c)
(a, b)
()

--Not considered:
--(a)

--In a similar way, the possible combinations of the following CUBE are reduced because references to "a" or "b" individually are not 
--considered as they are treated as a single column when the groupings are determined.

CUBE ((a, b), c)
(a, b, c)
(a, b)
(c)
()

--Not considered:
--(a, c)
--(a)
--(b, c)
--(b)

--The impact of this is shown clearly in the follow two statements. The regular cube returns 198 rows 
--and 8 groups (0-7), while the cube with the composite column returns only 121 rows with 4 groups (0, 1, 6, 7)

-- Regular Cube.
SELECT 
     column_fact_1_id                                                  column_fact_1_id,
     column_fact_2_id                                                  column_fact_2_id,
     column_fact_3_id                                                  column_fact_3_id,
     SUM(sales_value)                                                  sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id, column_fact_3_id) grouping_id
FROM
     devesh.tbl_dimension
GROUP BY CUBE(column_fact_1_id, column_fact_2_id, column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE GROUPING_ID
----------------  ----------------  ---------------- ----------- -----------
               1                 1                 1      381.61           0
               1                 1                 2      235.29           0
               1                 1                 3       270.7           0
               1                 1                 4      634.05           0
               1                 1                 5      602.36           0
               1                 1                 6      538.41           0
               1                 1                 7      245.87           0
               1                 1                 8      435.54           0
               1                 1                 9      506.59           0
               1                 1                10      513.13           0
               1                 1                       4363.55           1
               1                 2                 1      370.97           0
               1                 2                 2      259.31           0
               1                 2                 3      509.68           0
               1                 2                 4      668.64           0
               1                 2                 5      614.99           0
               1                 2                 6      298.12           0
               1                 2                 7      466.98           0
               1                 2                 8      479.95           0
               1                 2                 9      575.89           0
               1                 2                10      550.23           0
               1                 2                       4794.76           1
               1                 3                 1      607.06           0
               1                 3                 2      470.61           0
               1                 3                 3      514.79           0
               1                 3                 4      367.72           0
               1                 3                 5      415.19           0
               1                 3                 6      390.99           0
               1                 3                 7      440.98           0
               1                 3                 8      642.67           0
               1                 3                 9      461.13           0
               1                 3                10      407.11           0
               1                 3                       4718.25           1
               1                 4                 1      834.37           0
               1                 4                 2      471.72           0
               1                 4                 3      339.45           0
               1                 4                 4       337.9           0
               1                 4                 5      409.88           0
               1                 4                 6      719.47           0
               1                 4                 7      390.67           0
               1                 4                 8      595.08           0
               1                 4                 9      890.73           0
               1                 4                10      398.18           0
               1                 4                       5387.45           1
               1                 5                 1      543.39           0
               1                 5                 2      417.36           0
               1                 5                 3      456.34           0
               1                 5                 4      596.86           0
               1                 5                 5      548.51           0
               1                 5                 6      559.91           0
               1                 5                 7      295.35           0
               1                 5                 8       799.8           0
               1                 5                 9      344.41           0
               1                 5                10      465.41           0
               1                 5                       5027.34           1
               1                                   1      2737.4           2
               1                                   2     1854.29           2
               1                                   3     2090.96           2
               1                                   4     2605.17           2
               1                                   5     2590.93           2
               1                                   6      2506.9           2
               1                                   7     1839.85           2
               1                                   8     2953.04           2
               1                                   9     2778.75           2
               1                                  10     2334.06           2
               1                                        24291.35           3
               2                 1                 1      838.08           0
               2                 1                 2      252.93           0
               2                 1                 3      989.74           0
               2                 1                 4      736.87           0
               2                 1                 5      895.58           0
               2                 1                 6      559.87           0
               2                 1                 7      334.42           0
               2                 1                 8       346.8           0
               2                 1                 9      379.27           0
               2                 1                10      319.28           0
               2                 1                       5652.84           1
               2                 2                 1      466.31           0
               2                 2                 2      648.44           0
               2                 2                 3      262.44           0
               2                 2                 4      343.78           0
               2                 2                 5      331.71           0
               2                 2                 6      594.96           0
               2                 2                 7      707.46           0
               2                 2                 8      512.56           0
               2                 2                 9      170.11           0
               2                 2                10      545.25           0
               2                 2                       4583.02           1
               2                 3                 1      812.17           0
               2                 3                 2      488.23           0
               2                 3                 3      840.21           0
               2                 3                 4      447.27           0
               2                 3                 5       759.4           0
               2                 3                 6      646.82           0
               2                 3                 7      202.86           0
               2                 3                 8      489.98           0
               2                 3                 9      351.16           0
               2                 3                10      517.67           0
               2                 3                       5555.77           1
               2                 4                 1      681.29           0
               2                 4                 2      771.78           0
               2                 4                 3      300.61           0
               2                 4                 4      669.27           0
               2                 4                 5      914.13           0
               2                 4                 6      705.48           0
               2                 4                 7      296.23           0
               2                 4                 8      557.92           0
               2                 4                 9      618.33           0
               2                 4                10      421.63           0
               2                 4                       5936.67           1
               2                 5                 1      714.84           0
               2                 5                 2      686.56           0
               2                 5                 3       579.5           0
               2                 5                 4      336.87           0
               2                 5                 5      215.17           0
               2                 5                 6      268.72           0
               2                 5                 7      667.22           0
               2                 5                 8      451.29           0
               2                 5                 9      365.24           0
               2                 5                10      223.33           0
               2                 5                       4508.74           1
               2                                   1     3512.69           2
               2                                   2     2847.94           2
               2                                   3      2972.5           2
               2                                   4     2534.06           2
               2                                   5     3115.99           2
               2                                   6     2775.85           2
               2                                   7     2208.19           2
               2                                   8     2358.55           2
               2                                   9     1884.11           2
               2                                  10     2027.16           2
               2                                        26237.04           3
                                 1                 1     1219.69           4
                                 1                 2      488.22           4
                                 1                 3     1260.44           4
                                 1                 4     1370.92           4
                                 1                 5     1497.94           4
                                 1                 6     1098.28           4
                                 1                 7      580.29           4
                                 1                 8      782.34           4
                                 1                 9      885.86           4
                                 1                10      832.41           4
                                 1                      10016.39           5
                                 2                 1      837.28           4
                                 2                 2      907.75           4
                                 2                 3      772.12           4
                                 2                 4     1012.42           4
                                 2                 5       946.7           4
                                 2                 6      893.08           4
                                 2                 7     1174.44           4
                                 2                 8      992.51           4
                                 2                 9         746           4
                                 2                10     1095.48           4
                                 2                       9377.78           5
                                 3                 1     1419.23           4
                                 3                 2      958.84           4
                                 3                 3        1355           4
                                 3                 4      814.99           4
                                 3                 5     1174.59           4
                                 3                 6     1037.81           4
                                 3                 7      643.84           4
                                 3                 8     1132.65           4
                                 3                 9      812.29           4
                                 3                10      924.78           4
                                 3                      10274.02           5
                                 4                 1     1515.66           4
                                 4                 2      1243.5           4
                                 4                 3      640.06           4
                                 4                 4     1007.17           4
                                 4                 5     1324.01           4
                                 4                 6     1424.95           4
                                 4                 7       686.9           4
                                 4                 8        1153           4
                                 4                 9     1509.06           4
                                 4                10      819.81           4
                                 4                      11324.12           5
                                 5                 1     1258.23           4
                                 5                 2     1103.92           4
                                 5                 3     1035.84           4
                                 5                 4      933.73           4
                                 5                 5      763.68           4
                                 5                 6      828.63           4
                                 5                 7      962.57           4
                                 5                 8     1251.09           4
                                 5                 9      709.65           4
                                 5                10      688.74           4
                                 5                       9536.08           5
                                                   1     6250.09           6
                                                   2     4702.23           6
                                                   3     5063.46           6
                                                   4     5139.23           6
                                                   5     5706.92           6
                                                   6     5282.75           6
                                                   7     4048.04           6
                                                   8     5311.59           6
                                                   9     4662.86           6
                                                  10     4361.22           6
                                                        50528.39           7
*/

-- Cube with composite column.
SELECT 
     column_fact_1_id                                                  column_fact_1_id,
     column_fact_2_id                                                  column_fact_2_id,
     column_fact_3_id                                                  column_fact_3_id,
     SUM(sales_value)                                                  sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id, column_fact_3_id) grouping_id
FROM
     devesh.tbl_dimension
GROUP BY CUBE((column_fact_1_id, column_fact_2_id), column_fact_3_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID SALES_VALUE GROUPING_ID
----------------  ----------------  ---------------- ----------- -----------
               1                 1                 1      381.61           0
               1                 1                 2      235.29           0
               1                 1                 3       270.7           0
               1                 1                 4      634.05           0
               1                 1                 5      602.36           0
               1                 1                 6      538.41           0
               1                 1                 7      245.87           0
               1                 1                 8      435.54           0
               1                 1                 9      506.59           0
               1                 1                10      513.13           0
               1                 1                       4363.55           1
               1                 2                 1      370.97           0
               1                 2                 2      259.31           0
               1                 2                 3      509.68           0
               1                 2                 4      668.64           0
               1                 2                 5      614.99           0
               1                 2                 6      298.12           0
               1                 2                 7      466.98           0
               1                 2                 8      479.95           0
               1                 2                 9      575.89           0
               1                 2                10      550.23           0
               1                 2                       4794.76           1
               1                 3                 1      607.06           0
               1                 3                 2      470.61           0
               1                 3                 3      514.79           0
               1                 3                 4      367.72           0
               1                 3                 5      415.19           0
               1                 3                 6      390.99           0
               1                 3                 7      440.98           0
               1                 3                 8      642.67           0
               1                 3                 9      461.13           0
               1                 3                10      407.11           0
               1                 3                       4718.25           1
               1                 4                 1      834.37           0
               1                 4                 2      471.72           0
               1                 4                 3      339.45           0
               1                 4                 4       337.9           0
               1                 4                 5      409.88           0
               1                 4                 6      719.47           0
               1                 4                 7      390.67           0
               1                 4                 8      595.08           0
               1                 4                 9      890.73           0
               1                 4                10      398.18           0
               1                 4                       5387.45           1
               1                 5                 1      543.39           0
               1                 5                 2      417.36           0
               1                 5                 3      456.34           0
               1                 5                 4      596.86           0
               1                 5                 5      548.51           0
               1                 5                 6      559.91           0
               1                 5                 7      295.35           0
               1                 5                 8       799.8           0
               1                 5                 9      344.41           0
               1                 5                10      465.41           0
               1                 5                       5027.34           1
               2                 1                 1      838.08           0
               2                 1                 2      252.93           0
               2                 1                 3      989.74           0
               2                 1                 4      736.87           0
               2                 1                 5      895.58           0
               2                 1                 6      559.87           0
               2                 1                 7      334.42           0
               2                 1                 8       346.8           0
               2                 1                 9      379.27           0
               2                 1                10      319.28           0
               2                 1                       5652.84           1
               2                 2                 1      466.31           0
               2                 2                 2      648.44           0
               2                 2                 3      262.44           0
               2                 2                 4      343.78           0
               2                 2                 5      331.71           0
               2                 2                 6      594.96           0
               2                 2                 7      707.46           0
               2                 2                 8      512.56           0
               2                 2                 9      170.11           0
               2                 2                10      545.25           0
               2                 2                       4583.02           1
               2                 3                 1      812.17           0
               2                 3                 2      488.23           0
               2                 3                 3      840.21           0
               2                 3                 4      447.27           0
               2                 3                 5       759.4           0
               2                 3                 6      646.82           0
               2                 3                 7      202.86           0
               2                 3                 8      489.98           0
               2                 3                 9      351.16           0
               2                 3                10      517.67           0
               2                 3                       5555.77           1
               2                 4                 1      681.29           0
               2                 4                 2      771.78           0
               2                 4                 3      300.61           0
               2                 4                 4      669.27           0
               2                 4                 5      914.13           0
               2                 4                 6      705.48           0
               2                 4                 7      296.23           0
               2                 4                 8      557.92           0
               2                 4                 9      618.33           0
               2                 4                10      421.63           0
               2                 4                       5936.67           1
               2                 5                 1      714.84           0
               2                 5                 2      686.56           0
               2                 5                 3       579.5           0
               2                 5                 4      336.87           0
               2                 5                 5      215.17           0
               2                 5                 6      268.72           0
               2                 5                 7      667.22           0
               2                 5                 8      451.29           0
               2                 5                 9      365.24           0
               2                 5                10      223.33           0
               2                 5                       4508.74           1
                                                   1     6250.09           6
                                                   2     4702.23           6
                                                   3     5063.46           6
                                                   4     5139.23           6
                                                   5     5706.92           6
                                                   6     5282.75           6
                                                   7     4048.04           6
                                                   8     5311.59           6
                                                   9     4662.86           6
                                                  10     4361.22           6
                                                        50528.39           7
*/

--Concatenated Groupings
--Concatenated groupings are defined by putting together multiple GROUPING SETS, CUBEs or ROLLUPs separated by commas. 
--The resulting groupings are the cross-product of all the groups produced by the individual grouping sets. It might be a little easier 
--to understand what this means, The following GROUPING SET results in 2 groups of subtotals, 
--one for the column_fact_1_id column and one for the column_fact_id_2 column.

SELECT 
     column_fact_1_id                                 column_fact_1_id,
     column_fact_2_id                                 column_fact_2_id,
     SUM(sales_value)                                 sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS(column_fact_1_id, column_fact_2_id)
ORDER BY column_fact_1_id, column_fact_2_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID SALES_VALUE GROUPING_ID
----------------  ---------------- ----------- -----------
               1                      24291.35           1
               2                      26237.04           1
                                 1    10016.39           2
                                 2     9377.78           2
                                 3    10274.02           2
                                 4    11324.12           2
                                 5     9536.08           2
*/

--The next GROUPING SET results in another 2 groups of subtotals, one for the column_fact_3_id column and one for the column_fact_4_id column.

SELECT 
     column_fact_3_id                                 column_fact_3_id,
     column_fact_4_id                                 column_fact_4_id,
     SUM(sales_value)                                 sales_value,
     GROUPING_ID(column_fact_3_id, column_fact_4_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS(column_fact_3_id, column_fact_4_id)
ORDER BY column_fact_3_id, column_fact_4_id;

/*
COLUMN_FACT_3_ID  COLUMN_FACT_4_ID SALES_VALUE GROUPING_ID
----------------  ---------------- ----------- -----------
               1                       6250.09           1
               2                       4702.23           1
               3                       5063.46           1
               4                       5139.23           1
               5                       5706.92           1
               6                       5282.75           1
               7                       4048.04           1
               8                       5311.59           1
               9                       4662.86           1
              10                       4361.22           1
                                 1     4718.55           2
                                 2      5439.1           2
                                 3      4643.4           2
                                 4      4515.3           2
                                 5     5110.27           2
                                 6     5910.78           2
                                 7     4987.22           2
                                 8     4846.25           2
                                 9     5458.82           2
                                10      4898.7           2
*/

--If we combine them together into a concatenated grouping we get 4 groups of subtotals.
SELECT 
     column_fact_1_id                                                                     column_fact_1_id,
     column_fact_2_id                                                                     column_fact_2_id,
     column_fact_3_id                                                                     column_fact_3_id,
     column_fact_4_id                                                                     column_fact_4_id,
     SUM(sales_value)                                                                     sales_value,
     GROUPING_ID(column_fact_1_id, column_fact_2_id, column_fact_3_id, column_fact_4_id)  grouping_id
FROM
     devesh.tbl_dimension
GROUP BY GROUPING SETS(column_fact_1_id, column_fact_2_id), GROUPING SETS(column_fact_3_id, column_fact_4_id)
ORDER BY column_fact_1_id, column_fact_2_id, column_fact_3_id, column_fact_4_id;

/*
COLUMN_FACT_1_ID  COLUMN_FACT_2_ID  COLUMN_FACT_3_ID  COLUMN_FACT_4_ID SALES_VALUE GROUPING_ID
----------------  ----------------  ----------------  ---------------- ----------- -----------
               1                                   1                        2737.4           5
               1                                   2                       1854.29           5
               1                                   3                       2090.96           5
               1                                   4                       2605.17           5
               1                                   5                       2590.93           5
               1                                   6                        2506.9           5
               1                                   7                       1839.85           5
               1                                   8                       2953.04           5
               1                                   9                       2778.75           5
               1                                  10                       2334.06           5
               1                                                     1     2241.01           6
               1                                                     2     3155.39           6
               1                                                     3      2061.7           6
               1                                                     4        2125           6
               1                                                     5     2555.41           6
               1                                                     6      3088.2           6
               1                                                     7     2231.46           6
               1                                                     8     1919.89           6
               1                                                     9     2426.51           6
               1                                                    10     2486.78           6
               2                                   1                       3512.69           5
               2                                   2                       2847.94           5
               2                                   3                        2972.5           5
               2                                   4                       2534.06           5
               2                                   5                       3115.99           5
               2                                   6                       2775.85           5
               2                                   7                       2208.19           5
               2                                   8                       2358.55           5
               2                                   9                       1884.11           5
               2                                  10                       2027.16           5
               2                                                     1     2477.54           6
               2                                                     2     2283.71           6
               2                                                     3      2581.7           6
               2                                                     4      2390.3           6
               2                                                     5     2554.86           6
               2                                                     6     2822.58           6
               2                                                     7     2755.76           6
               2                                                     8     2926.36           6
               2                                                     9     3032.31           6
               2                                                    10     2411.92           6
                                 1                 1                       1219.69           9
                                 1                 2                        488.22           9
                                 1                 3                       1260.44           9
                                 1                 4                       1370.92           9
                                 1                 5                       1497.94           9
                                 1                 6                       1098.28           9
                                 1                 7                        580.29           9
                                 1                 8                        782.34           9
                                 1                 9                        885.86           9
                                 1                10                        832.41           9
                                 1                                   1      894.62          10
                                 1                                   2       984.7          10
                                 1                                   3      739.83          10
                                 1                                   4     1228.08          10
                                 1                                   5     1049.75          10
                                 1                                   6     1443.91          10
                                 1                                   7      947.72          10
                                 1                                   8      995.02          10
                                 1                                   9       790.4          10
                                 1                                  10      942.36          10
                                 2                 1                        837.28           9
                                 2                 2                        907.75           9
                                 2                 3                        772.12           9
                                 2                 4                       1012.42           9
                                 2                 5                         946.7           9
                                 2                 6                        893.08           9
                                 2                 7                       1174.44           9
                                 2                 8                        992.51           9
                                 2                 9                           746           9
                                 2                10                       1095.48           9
                                 2                                   1     1084.54          10
                                 2                                   2     1083.33          10
                                 2                                   3      645.13          10
                                 2                                   4      465.48          10
                                 2                                   5      624.32          10
                                 2                                   6     1346.18          10
                                 2                                   7      998.45          10
                                 2                                   8     1053.82          10
                                 2                                   9     1140.75          10
                                 2                                  10      935.78          10
                                 3                 1                       1419.23           9
                                 3                 2                        958.84           9
                                 3                 3                          1355           9
                                 3                 4                        814.99           9
                                 3                 5                       1174.59           9
                                 3                 6                       1037.81           9
                                 3                 7                        643.84           9
                                 3                 8                       1132.65           9
                                 3                 9                        812.29           9
                                 3                10                        924.78           9
                                 3                                   1     1003.24          10
                                 3                                   2      964.76          10
                                 3                                   3     1167.03          10
                                 3                                   4     1077.64          10
                                 3                                   5     1005.02          10
                                 3                                   6      1114.5          10
                                 3                                   7      643.47          10
                                 3                                   8     1067.79          10
                                 3                                   9     1115.66          10
                                 3                                  10     1114.91          10
                                 4                 1                       1515.66           9
                                 4                 2                        1243.5           9
                                 4                 3                        640.06           9
                                 4                 4                       1007.17           9
                                 4                 5                       1324.01           9
                                 4                 6                       1424.95           9
                                 4                 7                         686.9           9
                                 4                 8                          1153           9
                                 4                 9                       1509.06           9
                                 4                10                        819.81           9
                                 4                                   1     1037.52          10
                                 4                                   2     1648.92          10
                                 4                                   3       890.2          10
                                 4                                   4      858.48          10
                                 4                                   5     1166.91          10
                                 4                                   6     1106.11          10
                                 4                                   7     1233.89          10
                                 4                                   8     1277.33          10
                                 4                                   9     1260.96          10
                                 4                                  10       843.8          10
                                 5                 1                       1258.23           9
                                 5                 2                       1103.92           9
                                 5                 3                       1035.84           9
                                 5                 4                        933.73           9
                                 5                 5                        763.68           9
                                 5                 6                        828.63           9
                                 5                 7                        962.57           9
                                 5                 8                       1251.09           9
                                 5                 9                        709.65           9
                                 5                10                        688.74           9
                                 5                                   1      698.63          10
                                 5                                   2      757.39          10
                                 5                                   3     1201.21          10
                                 5                                   4      885.62          10
                                 5                                   5     1264.27          10
                                 5                                   6      900.08          10
                                 5                                   7     1163.69          10
                                 5                                   8      452.29          10
                                 5                                   9     1151.05          10
                                 5                                  10     1061.85          10
*/
--The output from the previous three queries produce the following groupings.

GROUPING SETS(column_fact_1_id, column_fact_2_id) 
(column_fact_1_id)
(column_fact_2_id)

GROUPING SETS(column_fact_3_id, column_fact_4_id) 
(column_fact_3_id)
(column_fact_4_id)

GROUPING SETS(column_fact_1_id, column_fact_2_id), GROUPING SETS(column_fact_3_id, column_fact_4_id) 
(column_fact_1_id, column_fact_3_id)
(column_fact_1_id, column_fact_4_id)
(column_fact_2_id, column_fact_3_id)
(column_fact_2_id, column_fact_4_id)

--So we can see the final cross-product of the two GROUPING SETS that make up the concatenated grouping. A generic summary would be as follows.

GROUPING SETS(a, b), GROUPING SETS(c, d) 
(a, c)
(a, d)
(b, c)
(b, d)