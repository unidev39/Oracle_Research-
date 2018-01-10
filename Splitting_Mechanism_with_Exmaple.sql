We create the actual PIPELINED function. This function will accept an input to limit the number of rows returned.
If no input is provided, this function will just keep generating rows for a very long time (so be careful and
make sure to use ROWNUM or some other limit in the query itself. The PIPELINED keyword on line 4 allows this
function to work as if it were a table:
;
CREATE OR REPLACE TYPE array AS TABLE OF NUMBER;
/

CREATE OR REPLACE FUNCTION fn_pipelined
(
 id NUMBER
)
RETURN array
PIPELINED
AS
BEGIN
    FOR i IN 1 .. id
    LOOP
       pipe ROW (i);
    END LOOP;
    RETURN;
END fn_pipelined;
/

SELECT * FROM TABLE(fn_pipelined(3));
/*
COLUMN_VALUE
------------
           1
           2
           3
*/

SELECT * FROM TABLE(fn_pipelined(3)) ORDER BY Dbms_Random.Random;
/*
COLUMN_VALUE
------------
           3
           2
           1
*/

-- OR --

CREATE OR REPLACE FUNCTION fn_pipelined_or
(
 id NUMBER
)
RETURN array
AS
    l_array array := array();
BEGIN
    FOR i IN 1 .. id
    LOOP
       l_array.extend();
       l_array(i) := i;
    END LOOP;
    RETURN l_array;
END fn_pipelined_or;
/

SELECT * FROM TABLE(fn_pipelined_or(3));
/*
COLUMN_VALUE
------------
           1
           2
           3
*/

DROP TABLE usr_id_levelinfo PURGE;
CREATE TABLE usr_id_levelinfo
(
 reportid  NUMBER,
 keylevel  VARCHAR2(30),
 lvlid     VARCHAR2(30),
 nlvlid    VARCHAR2(30)
);

BEGIN
    FOR I IN 1..5
    LOOP
       INSERT INTO usr_id_levelinfo
       SELECT 100 reportid,1 keylevel,'A' lvlid,1   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'B' lvlid,2   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'C' lvlid,3   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'A' lvlid,4   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'B' lvlid,5   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'C' lvlid,6   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'A' lvlid,7   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'B' lvlid,8   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'C' lvlid,9   nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'A' lvlid,10  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'B' lvlid,11  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'C' lvlid,12  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'A' lvlid,13  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'B' lvlid,14  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,1 keylevel,'C' lvlid,15  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'A' lvlid,16  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'B' lvlid,17  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'C' lvlid,18  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'A' lvlid,19  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'B' lvlid,20  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'C' lvlid,21  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'A' lvlid,22  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'B' lvlid,23  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'C' lvlid,24  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'A' lvlid,25  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'B' lvlid,26  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'C' lvlid,27  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'A' lvlid,28  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,2 keylevel,'B' lvlid,29  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'C' lvlid,30  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'A' lvlid,31  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'B' lvlid,32  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'C' lvlid,33  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'A' lvlid,34  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'B' lvlid,35  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'C' lvlid,36  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'A' lvlid,37  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'B' lvlid,38  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'C' lvlid,39  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'A' lvlid,40  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'B' lvlid,41  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'C' lvlid,42  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,3 keylevel,'A' lvlid,43  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'B' lvlid,44  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'C' lvlid,45  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'A' lvlid,46  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'B' lvlid,47  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'C' lvlid,48  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'A' lvlid,49  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'B' lvlid,50  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'C' lvlid,51  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'A' lvlid,52  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'B' lvlid,53  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'C' lvlid,54  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'A' lvlid,55  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'B' lvlid,56  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'C' lvlid,57  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,4 keylevel,'A' lvlid,58  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,59  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,60  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,61  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,62  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,63  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,64  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,65  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,66  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,67  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,68  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,69  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,70  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,71  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,72  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,73  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,74  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,75  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,76  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,77  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,78  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,79  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,80  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,81  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,82  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,83  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,84  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,85  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,86  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,87  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,88  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,89  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,90  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,91  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,92  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,93  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,94  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,95  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,96  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,97  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,98  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,99  nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,100 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,101 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,102 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,103 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,104 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,105 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,106 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'B' lvlid,107 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'C' lvlid,108 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,5 keylevel,'A' lvlid,109 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'B' lvlid,110 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'C' lvlid,111 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'A' lvlid,112 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'B' lvlid,113 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'C' lvlid,114 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'A' lvlid,115 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'B' lvlid,116 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'C' lvlid,117 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'A' lvlid,118 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'B' lvlid,119 nlvlid FROM dual UNION ALL
       SELECT 100 reportid,6 keylevel,'C' lvlid,120 nlvlid FROM dual;
    END LOOP;
    COMMIT;
END;
/
SELECT
     COUNT(nlvlid),
     keylevel
FROM usr_id_levelinfo
GROUP BY keylevel;
/*
COUNT(NLVLID) KEYLEVEL
------------- --------
           75 1       
           70 3       
           55 6       
          255 5       
           70 2       
           75 4       
*/

-- Using this mechanism we can overcome from Oracle IN operator limits i.e. (1000)

CREATE OR REPLACE TYPE nkeylvl_nt IS TABLE OF VARCHAR2(32767);
/

-- Relevant permissions --
GRANT EXECUTE ON nkeylvl_nt TO PUBLIC;

CREATE OR REPLACE FUNCTION fn_id_keylvlinfo
(
  p_repid            NUMBER,
  p_tablename        VARCHAR2
)
RETURN nkeylvl_nt
AS
  nkeylvl_aat        nkeylvl_nt;
  TYPE cursor_cur    IS REF CURSOR;
  keylevel_cur       cursor_cur;
  nlvlid_cur         cursor_cur;
  l_nkeylevel        VARCHAR2(30);
  l_nlvlid           VARCHAR2(32767);
  l_keylevel         VARCHAR2(32767);
  l_keylevel1        VARCHAR2(32767);
  l_thresholdtosplit NUMBER;
  l_rowcount         NUMBER;
  l_nlvllength       NUMBER;
  l_extendarrycount  NUMBER := 0;
  l_extendarrycount1 NUMBER := 0;
  l_splitedcount     NUMBER := 0;
  l_flagforkeylevel  NUMBER := 0;
  l_nlvlidcount      NUMBER := 0;
BEGIN
    -- Array to give the multiple values from function --
    nkeylvl_aat := nkeylvl_nt();

    -- To fetch the unique key levels --
    OPEN keylevel_cur FOR 'SELECT DISTINCT keylevel FROM '||p_tablename||' WHERE reportid = '||p_repid;
    LOOP
       FETCH  keylevel_cur into l_nkeylevel;
       EXIT WHEN keylevel_cur%notfound;
       l_keylevel:='';
       
       -- Splitting records for 100 value --
       l_thresholdtosplit := 10;
       EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT NVL(nlvlid,0)) FROM '||p_tablename||' WHERE reportid = '||p_repid||' AND keylevel IN ('||l_nkeylevel||')' INTO l_nlvlidcount;

       -- To fetch the multiple values for unique key level --
       OPEN nlvlid_cur FOR 'SELECT ROWNUM rowCOUNT, nlvlid FROM (SELECT DISTINCT NVL(nlvlid,0) nlvlid FROM '||p_tablename||' WHERE reportid = '||p_repid||' AND keylevel IN ('||l_nkeylevel||'))';
       LOOP
          FETCH nlvlid_cur INTO l_rowcount,l_nlvlid;
          EXIT WHEN nlvlid_cur%NOTFOUND;
          l_keylevel := l_keylevel||l_nlvlid||',';
          l_keylevel := l_keylevel;

          -- Splitting values and store here --
          IF ((Mod(l_rowcount,l_thresholdtosplit)=0)) THEN
              l_nlvllength   := Length(l_keylevel);
              l_keylevel1    := SubStr(l_keylevel,0,l_nlvllength-1);
              l_keylevel     := '';

              l_splitedcount := l_splitedcount+1;
              IF l_splitedcount = 1 THEN
                 l_keylevel1 := '(a.NLVL'||l_nkeylevel||'ID'||' IN ('||l_keylevel1||') OR';
                 l_flagforkeylevel := l_nkeylevel;
              ELSE
                 l_keylevel1 := ' a.NLVL'||l_nkeylevel||'ID'||' IN ('||l_keylevel1||') OR';
              END IF;

              l_extendarrycount := l_extendarrycount + 1;
              IF (l_nlvlidcount <> 0) THEN
                  nkeylvl_aat.EXTEND();
                  nkeylvl_aat(l_extendarrycount) := l_keylevel1;
                  l_keylevel1 := '';
              END IF;
          END IF;
       END LOOP;

       l_splitedcount := 0;
       l_nlvllength   := Length(l_keylevel);

       IF ((l_rowcount = l_nlvlidcount) AND l_nlvllength IS NULL) THEN
           nkeylvl_aat(l_extendarrycount) := REPLACE(nkeylvl_aat(l_extendarrycount),' OR',') AND');
       END IF;

       -- While splitting the remaining values are stored here --
       IF l_nlvllength > 0 THEN
          l_keylevel := SubStr(l_keylevel,0,l_nlvllength-1);
          IF l_flagforkeylevel = l_nkeylevel THEN
             l_keylevel  := ' a.NLVL'||l_nkeylevel||'ID'||' IN ('||l_keylevel||')) AND';
             l_flagforkeylevel := 0;
          ELSE
             l_keylevel  := '(a.NLVL'||l_nkeylevel||'ID'||' IN ('||l_keylevel||')) AND';
          END IF;

          l_extendarrycount := l_extendarrycount + 1;
          IF (l_nlvlidcount <> 0) THEN
             nkeylvl_aat.EXTEND();
             nkeylvl_aat(l_extendarrycount) :=  l_keylevel;
          END IF;
       END IF;
       l_splitedcount := 0;

       CLOSE nlvlid_cur;
  END LOOP;
  CLOSE keylevel_cur;

  -- Replace the last row value of 'AND' with ')' in array --
  IF (l_nlvlidcount <> 0) THEN
     nkeylvl_aat(l_extendarrycount) := REPLACE(nkeylvl_aat(l_extendarrycount),') AND',')');
     nkeylvl_aat(l_extendarrycount) := REPLACE(nkeylvl_aat(l_extendarrycount),') OR',')');
  ELSIF (l_nlvlidcount = 0) THEN
     l_extendarrycount := l_extendarrycount + 1;
     nkeylvl_aat.EXTEND();
     nkeylvl_aat(l_extendarrycount) :=  '(1=1)';
  END IF;

  -- The return clause extract the over all values from array --
  RETURN nkeylvl_aat;

END fn_id_keylvlinfo;
/

-- Relevant permissions --
GRANT EXECUTE ON fn_id_keylvlinfo TO PUBLIC;

SELECT * FROM TABLE(fn_id_keylvlinfo(100,'USR_ID_LEVELINFO'));
/*
COLUMN_VALUE
------------------------------------------------------------                                                                                                                                                                           
COLUMN_VALUE                                              
(
 a.NLVL1ID IN (1,3,13,6,11,12,8,10,5,7)
 OR a.NLVL1ID IN (14,15,9,2,4)
) 
AND                          
(
 a.NLVL3ID IN (31,33,32,36,39,42,43,37,38,40) 
 OR a.NLVL3ID IN (41,30,34,35)
) 
AND                          
(
 a.NLVL6ID IN (118,110,113,115,117,112,116,119,120,111) 
 OR a.NLVL6ID IN (114)
) 
AND                                  
(
 a.NLVL5ID IN (61,73,86,99,101,71,72,75,87,93) 
 OR a.NLVL5ID IN (97,100,102,59,66,78,81,82,88,89) 
 OR a.NLVL5ID IN (94,95,105,109,63,67,69,76,77,83) 
 OR a.NLVL5ID IN (103,108,74,92,98,80,84,85,90,91) 
 OR a.NLVL5ID IN (106,60,64,65,70,79,62,68,96,104) 
 OR a.NLVL5ID IN (107)
) 
AND                                  
(
 a.NLVL2ID IN (26,17,28,18,21,16,19,20,22,29) 
 OR a.NLVL2ID IN (25,24,27,23)
) 
AND                          
(
 a.NLVL4ID IN (45,47,55,58,48,50,44,49,51,54) 
 OR a.NLVL4ID IN (56,46,52,53,57)
)                           
*/