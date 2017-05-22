-- Load image
CREATE Directory DIRECTORY_NAME AS '/home/oracle/Devesh/';
GRANT READ,WRITE ON DIRECTORY DIRECTORY_NAME TO PUBLIC;

-- Create table with blob data type
CREATE TABLE blobs
(
  id        varchar2(255),
  blob_col  blob
);

-- To Create Procedure Insert_Image to Load the *.* into oracle table
CREATE OR REPLACE PROCEDURE sp_insert_img
AS
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    INSERT INTO blobs VALUES ( 'MY_Image', empty_blob() )
    RETURN blob_col INTO l_b_lob;

    l_f_lob := bfilename( 'DIRECTORY_NAME', 'sonu.jpg' );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END sp_insert_img;
/

-- Execute the Insert_Img Procedure
EXEC sp_insert_img;

-- Verification Script
SELECT * FROM  blobs;

-- To Get the *.* File from Oracle Table
CREATE OR REPLACE PROCEDURE sp_fetch_image
as
     l_t_blob         BLOB;
     l_t_len          NUMBER;
     l_t_file_name    VARCHAR2(32767);
     l_t_output       utl_file.file_type;
     l_t_totalsize    NUMBER;
     l_t_l_position     NUMBER := 1;
     l_l_t_chucklen   NUMBER := 4096;
     l_t_chuck        RAW(4096);
     l_t_remain       NUMBER;
BEGIN
     SELECT 
	      dbms_lob.getlength (blob_col), 
		  id||'sonu.jpg' 
		  INTO l_t_totalsize, l_t_file_name 
	 FROM 
	      blobs 
	 WHERE 
	      id = 'MY_Image';
     l_t_remain := l_t_totalsize;
     l_t_output := utl_file.fopen ('DIRECTORY_NAME', l_t_file_name, 'wb', 32760);
	 
     SELECT 
	      blob_col INTO l_t_blob 
	 FROM 
	      blobs 
	 WHERE 
	      id = 'MY_Image';
		  
     WHILE l_t_l_position < l_t_totalsize
     LOOP
         dbms_lob.read (l_t_blob, l_l_t_chucklen, l_t_l_position, l_t_chuck);
         utl_file.put_raw (l_t_output, l_t_chuck);
         utl_file.fflush (l_t_output);
         l_t_l_position := l_t_l_position + l_l_t_chucklen;
         l_t_remain := l_t_remain - l_l_t_chucklen;

         IF l_t_remain < 4096 THEN
            l_l_t_chucklen := l_t_remain;
         END IF;

     END LOOP;
END sp_fetch_image;
/

EXEC sp_fetch_image;

-- Create table with bfile data type
CREATE TABLE graphics_table 
(
  bfile_id      NUMBER,
  bfile_desc    VARCHAR2(30),
  bl_file_loc   bfile,
  bfile_type    VARCHAR2(4))
  storage (INITIAL 1M NEXT 1M PCTINCREASE 0
);

-- Insert *.* into oracle table --
INSERT INTO graphics_table
VALUES(1,'My brother photo',bfilename('DIRECTORY_NAME','sonu.jpg'),'jpeg');

commit;

SELECT * FROM graphics_table;
-- Create a Procedure To Get the *.* File from Oracle Table
CREATE OR REPLACE PROCEDURE sp_displaybfile
AS
  l_file_loc      bfile;
  l_buffer        RAW(1024);
  l_amount        BINARY_INTEGER := 1024;
  l_position      INTEGER        := 1;
  l_t_file_name   VARCHAR2(100);
  l_t_output      utl_file.file_type;

BEGIN
   SELECT 
        bl_file_loc INTO l_file_loc
   FROM 
        graphics_table;
		
   l_t_output := utl_file.fopen ('DIRECTORY_NAME', '02.jpg', 'wb', 32760);

   dbms_lob.open (l_file_loc, dbms_lob.LOB_READONLY);
   LOOP
      dbms_lob.read (l_file_loc, l_amount, l_position, l_buffer);
      utl_file.put_raw (l_t_output, l_buffer);
      utl_file.fflush (l_t_output);
      l_position := l_position + l_amount;
   END LOOP;

   dbms_lob.close (l_file_loc);
EXCEPTION WHEN NO_DATA_FOUND THEN
   NULL;
END sp_displaybfile;
/

-- Execute the sp_displaybfile Procedure
EXEC sp_displaybfile;
