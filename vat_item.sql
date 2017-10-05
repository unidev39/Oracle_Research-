WITH vat_item
AS 
(
  SELECT to_date('19-Sep-17', 'dd-mon-yy') dates, 6  vat, 1 region FROM dual UNION ALL
  SELECT to_date('19-Sep-17', 'dd-mon-yy') dates, 8  vat, 2 region FROM dual UNION ALL
  SELECT to_date('16-Sep-17', 'dd-mon-yy') dates, 17 vat, 1 region FROM dual UNION ALL
  SELECT to_date('15-Sep-17', 'dd-mon-yy') dates, 5  vat, 1 region FROM dual UNION ALL
  SELECT to_date('15-Sep-17', 'dd-mon-yy') dates, 6  vat, 2 region FROM dual UNION ALL
  SELECT to_date('14-Sep-17', 'dd-mon-yy') dates, 5  vat, 1 region FROM dual UNION ALL
  SELECT to_date('14-Sep-17', 'dd-mon-yy') dates, 6  vat, 2 region FROM dual UNION ALL
  SELECT to_date('14-Sep-17', 'dd-mon-yy') dates, 17 vat, 3 region FROM dual UNION ALL
  SELECT to_date('13-Sep-17', 'dd-mon-yy') dates, 5  vat, 1 region FROM dual UNION ALL
  SELECT to_date('11-Sep-17', 'dd-mon-yy') dates, 6  vat, 1 region FROM dual
)
SELECT
     dates  from_dates
    ,CASE 
        WHEN MOD(rank_val, 2) = 0 THEN CASE
                                          WHEN (ADD_MONTHS(new_dates, 0) + Nvl(dates_diff,0) <> new_dates) THEN ADD_MONTHS(new_dates, 0) + Nvl(dates_diff,0)
                                       ELSE
                                          dates
                                       END
     ELSE
        CASE 
           WHEN rank_val = 1 THEN dates
        ELSE
           CASE
              WHEN ADD_MONTHS(new_dates, 0) + Nvl(dates_diff,0) <> new_dates THEN ADD_MONTHS(new_dates, 0) + Nvl(dates_diff,0)
           ELSE
              dates
           END   
        END
     END to_dates
    ,vat
    ,region
FROM (
      SELECT
           DENSE_RANK() OVER (ORDER BY dates DESC) rank_val
          ,dates
          ,ADD_MONTHS(dates, 0) - 1 new_dates
          ,Lag(dates, 1) OVER (ORDER BY dates DESC) - dates AS dates_diff
          ,vat
          ,region
      FROM
          vat_item
    );
-- Table Data of vat_item --
/*
DATES               VAT REGION
------------------- --- ------
19.09.2017 00:00:00   6      1
19.09.2017 00:00:00   8      2
16.09.2017 00:00:00  17      1
15.09.2017 00:00:00   5      1
15.09.2017 00:00:00   6      2
14.09.2017 00:00:00   5      1
14.09.2017 00:00:00   6      2
14.09.2017 00:00:00  17      3
13.09.2017 00:00:00   5      1
11.09.2017 00:00:00   6      1
*/

-- Output --
/*
FROM_DATES          TO_DATES            VAT REGION
------------------- ------------------- --- ------
19.09.2017 00:00:00 19.09.2017 00:00:00   6      1
19.09.2017 00:00:00 19.09.2017 00:00:00   8      2
16.09.2017 00:00:00 18.09.2017 00:00:00  17      1
15.09.2017 00:00:00 15.09.2017 00:00:00   5      1
15.09.2017 00:00:00 15.09.2017 00:00:00   6      2
14.09.2017 00:00:00 14.09.2017 00:00:00   5      1
14.09.2017 00:00:00 14.09.2017 00:00:00   6      2
14.09.2017 00:00:00 14.09.2017 00:00:00  17      3
13.09.2017 00:00:00 13.09.2017 00:00:00   5      1
11.09.2017 00:00:00 12.09.2017 00:00:00   6      1
*/
