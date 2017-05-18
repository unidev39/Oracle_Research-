-- Create a package with record data type
CREATE OR REPLACE PACKAGE PKG_TEST 
AS
   -- Declaration of record data type in package specification part
   TYPE addrec IS RECORD
   (
      wardno          NUMBER(2),
      houseno         VARCHAR2(20),
      streetname      VARCHAR2(120),
      vdctown         VARCHAR2(60),
      location_type   VARCHAR2(2),
      district_code   VARCHAR2(2),
      area_code       VARCHAR2(2),
      telephone       VARCHAR2(30),
      fax             VARCHAR2(30),
      email           VARCHAR2(60),
      pobox           VARCHAR2(20)
   );
   -- Declaration a function with record data type in return part
   FUNCTION fn_test
   (  
     a_user_id         NUMBER,
     a_business_sno    NUMBER,
     a_master_sno      NUMBER,
     a_add_of          VARCHAR2,
     a_add_type        VARCHAR2
   ) 
   RETURN addrec;
   PRAGMA RESTRICT_REFERENCES (fn_test, WNDS);

END PKG_TEST;
/
-- Create a package with use of record data type
CREATE OR REPLACE PACKAGE BODY PKG_TEST
AS
  FUNCTION fn_test
  (  
    a_user_id         NUMBER,
    a_business_sno    NUMBER,
    a_master_sno      NUMBER,
    a_add_of          VARCHAR2,
    a_add_type        VARCHAR2
  ) 
  RETURN addrec
  IS
      -- Declaration a variable as record data type
      tpadd             addrec;
  BEGIN
        BEGIN
           SELECT /*+ INDEX(a) INDEX(b) */
                NVL(a.ward_no,0),
                NVL(a.house_no,' '),
                NVL(a.street_name,' '),
                NVL(a.vdc_town,' '),
                NVL(a.location_type,' '),
                NVL(a.district_code,' '),
                NVL(a.area_code,' '),
                NVL(a.telephone,' '),
                NVL(a.fax,' '),
                NVL(a.email,' '),
                NVL(a.pobox,' ')
                INTO tpadd		  
           FROM 
                addresses a, bus_per_addresses b
           WHERE     
                a.address_no = b.address_no
	   AND a.user_id = a_user_id
           AND b.business_sno = a_business_sno
           AND b.bus_per_sno = a_master_sno
           AND b.bus_per_type = a_add_of
           AND b.address_type = a_add_type
           AND TRIM(a.expiry_date) IS NULL;
		   
        EXCEPTION WHEN NO_DATA_FOUND THEN
              tpadd.wardno := 0;
              tpadd.houseno := ' ';
              tpadd.streetname := ' ';
              tpadd.vdctown := ' ';
              tpadd.location_type := ' ';
              tpadd.district_code := ' ';
              tpadd.area_code := ' ';
              tpadd.telephone := ' ';
              tpadd.fax := ' ';
              tpadd.email := ' ';
              tpadd.pobox := ' ';
           WHEN TOO_MANY_ROWS THEN
              tpadd.wardno := 0;
              tpadd.houseno := ' ';
              tpadd.streetname := ' ';
              tpadd.vdctown := ' ';
              tpadd.location_type := ' ';
              tpadd.district_code := ' ';
              tpadd.area_code := ' ';
              tpadd.telephone := ' ';
              tpadd.fax := ' ';
              tpadd.email := ' ';
              tpadd.pobox := ' ';
        END;
        RETURN tpadd;      
  END FN_TEST;
END PKG_TEST;
/
-- To execute the package 
DECLARE
    x  pkg_test.addrec;
BEGIN
    x := pkg_test.fn_test(2000,1000,1,'A','B');
    dbms_output.put_line(x.wardno||','||x.houseno||','||x.streetname||','||x.vdctown||','||x.location_type||','||x.district_code||','||x.area_code||','||x.telephone||','||x.fax||','||x.email||','||x.pobox);
END;
/
		 
