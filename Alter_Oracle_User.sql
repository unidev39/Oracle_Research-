-- To repace the old password with new password
ALTER USER <<user_name>> IDENTIFIED BY <<New_Password>> REPLACE <<Old_Password>>;


-- To reset the user password for all database users (The password is stored in the SYS table "sys.user$" according to policy defined by Oracle.)
-- Step 1: Login from SYS privilege user, To Find the existing password in encrypted form
CONNECT <<sys_user>>/<<sys_password>> AS SYSDBA
 
SELECT name, password FROM sys.user$ WHERE name = 'HR';

/*
NAME PASSWORD
---- ----------------        
HR 5F6008F9ED270AD6
*/

--To assign the temp password for user - HR
ALTER USER HR IDENTIFIED BY <<temp_password>>;

--Step 2: Connect to the HR user with password
CONNECT hr/<<hr_temp_password>> 

SELECT USER FROM dual;
/*
USER
----
HR 
*/

-- Step 3: Disconnect from HR user

-- Step 4: Agian Login from SYS privilege user
CONNECT <<sys_user>>/<<sys_password>> AS SYSDBA

ALTER USER hr IDENTIFIED BY VALUES '5F6008F9ED270AD6';

-- Step 5: The password is now reset as it was.
-- Note: Please noted down the encrypted as it was.
