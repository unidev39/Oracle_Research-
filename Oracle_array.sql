DECLARE
    --p_data        VARCHAR2(4000) := 'B -> 15927 -> 2076-09-17 -> N -> Proprietor ~ B -> 24033 -> 2078-02-04 -> C -> Proprietor';
    p_data        VARCHAR2(4000) := 'R -> 7 -> 2078-12-07 -> C -> Guarantor';
    --p_data                     VARCHAR2(4000) :='009 -> Nepal SBI Bank';
    p_sn                       NUMBER := 1;
    l_data                     VARCHAR2(4000) := p_data;
    l_char_count               VARCHAR2(4000);
    l_till_count               VARCHAR2(4000);
    TYPE array IS              VARRAY(999999999) of VARCHAR2(4000);
    l_array array := array();
    inx pls_integer;
    l_words                    VARCHAR2(4000);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE tbl_array purge';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE TABLE tbl_array
                   (
                    sn NUMBER,
                    words VARCHAR2(4000),
                    seq NUMBER
                   )';

    l_data := p_data||' -> ~';
    l_char_count := regexp_count(l_data,'>')+1;
    l_till_count := regexp_count(l_data,'~');
    FOR j IN 1..l_till_count
    LOOP
       IF j=1 THEN
              l_data := SubStr(l_data,1,InStr(l_data,'~',1,j));
              l_data := RTrim(l_data,'~');
       ELSIF j>=2 THEN
             l_data := SubStr(l_data,InStr(l_data,'~',1,j-1)+2,InStr(l_data,'~',1,j)-InStr(l_data,'~',1,j-1));
             l_data := RTrim(l_data,'~');
       END IF;
    l_array.extend();
    l_array(1) :=SubStr(l_data,1,InStr(l_data,'>',1,1));
    l_array.extend();
    l_array(2) := SubStr(l_data,InStr(l_data,'>',1,1)+2,InStr(l_data,'>',1,2)-(InStr(l_data,'>',1,1)));

    FOR i IN 1..l_char_count
    LOOP
       l_array.extend();
       IF i =1 THEN
          l_array(i) := SubStr(l_data,1,InStr(l_data,'>',1,1));
          l_array.extend();
       ELSIF i=2 THEN
           l_array(i) := SubStr(l_data,InStr(l_data,'>',1,1)+2,InStr(l_data,'>',1,2)-(InStr(l_data,'>',1,1)));
           l_array.extend();
       ELSIF i=3 THEN
           l_array(i) := substr(l_data,InStr(l_data,'>',1,3-1)+2,InStr(l_data,'>',1,3-1)+1);
           l_array.extend();
       ELSIF i=4 THEN
           l_array(i) := substr(l_data,InStr(l_data,'>',1,4-1)+2,InStr(l_data,'>',1,4-1)+1);
           l_array.extend();
       ELSIF i=5 THEN
           l_array(i) := substr(l_data,InStr(l_data,'>',1,5-1)+2,InStr(l_data,'>',1,5-1)+1);
           l_array.extend();
       END IF;
       l_array(i) := CASE WHEN l_array(i) LIKE '%>%' THEN substr(l_array(i),1,InStr(l_array(i),'>',1,1)) ELSE l_array(i) END;
       EXECUTE IMMEDIATE 'INSERT INTO tbl_array (sn,words) VALUES ('||i||','''||TRIM(RTRIM(RTRIM(l_array(i),' ->'),' ~'))||''')';
       COMMIT;
       EXECUTE IMMEDIATE 'DELETE tbl_array WHERE words IS NULL';
       COMMIT;
       EXECUTE IMMEDIATE 'UPDATE tbl_array SET seq=ROWNUM';
       COMMIT;
    END LOOP;
     l_data := p_data||'~';
   END LOOP;

   EXECUTE IMMEDIATE 'SELECT words
                      FROM (
                            SELECT DISTINCT sn,
                                   listagg(words,'' ~ '') WITHIN GROUP (ORDER BY sn) OVER (PARTITION BY sn) words
                            FROM (SELECT * FROM tbl_array ORDER BY sn,seq) ORDER BY sn
                           ) WHERE sn='||p_sn||'' INTO l_words;
   Dbms_Output.Put_Line(l_words);
   Dbms_Output.Put_Line(chr(10));

   BEGIN 
       FOR i IN (SELECT sn,words FROM (
                                       SELECT DISTINCT sn,
                                              listagg(words,' ~ ') WITHIN GROUP (ORDER BY sn) OVER (PARTITION BY sn) words
                                       FROM (SELECT * FROM tbl_array ORDER BY sn,seq) ORDER BY sn))
       LOOP
          Dbms_Output.Put_Line(i.sn||' => '||i.words);
       END LOOP;
   END;

END;
/

--Output
/*
B ~ B                           

1 => B ~ B                      
2 => 15927 ~ 24033              
3 => 2076-09-17 ~ 2078-02-04    
4 => N ~ C                      
5 => Proprietor ~ Proprietor    
*/
