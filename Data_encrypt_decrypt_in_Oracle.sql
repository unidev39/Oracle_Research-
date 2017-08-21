CREATE OR REPLACE PROCEDURE sp_padstring 
(
  p_text  IN OUT  VARCHAR2
)
AS
  l_units  NUMBER;
BEGIN
  IF MOD(LENGTH(p_text), 8) > 0 THEN
    l_units := TRUNC(LENGTH(p_text)/8) + 1;
    p_text  := RPAD(p_text, l_units * 8,'~');
  END IF;
END sp_padstring;
/

CREATE OR REPLACE FUNCTION fn_encrypt 
(
  p_text  IN  VARCHAR2
) RETURN RAW 
IS
    l_text       VARCHAR2(32767) := p_text;
    l_encrypted  RAW(32767);
BEGIN
    sp_padstring(l_text);
    dbms_obfuscation_toolkit.desencrypt(input => utl_raw.cast_to_raw(l_text),
                                        key => utl_raw.cast_to_raw('9841435006'),
                                        encrypted_data => l_encrypted);
    RETURN l_encrypted;
END fn_encrypt;
/

CREATE OR REPLACE FUNCTION fn_decrypt 
(
  p_raw  IN  RAW
) 
RETURN VARCHAR2 
AS
  l_decrypted  VARCHAR2(32767);
BEGIN
  dbms_obfuscation_toolkit.desdecrypt(input=> p_raw,
                                      key  => utl_raw.cast_to_raw('9841435006');,
                                      decrypted_data => l_decrypted);

  RETURN RTRIM(utl_raw.cast_to_varchar2(l_decrypted), '~');
END fn_decrypt;
/


-- To fetch the user creation ddl
SELECT 
   dbms_metadata.get_ddl('USER', username) || '/' usercreate ,username
FROM 
   dba_users WHERE username = 'HR';

-- To show the user password
SELECT NAME,PASSWORD FROM SYS.USER$ WHERE NAME='HR';

-- To reset the password
ALTER USER  hr IDENTIFIED BY VALUE '57B18BF5C73804C5';
