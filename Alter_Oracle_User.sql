-- To repace the old password with new password
ALTER USER <<user_name>> IDENTIFIED BY <<New_Password>> REPLACE <<Old_Password>>;


-- To reset the user password for all database users (The password is stored in the SYS table "sys.user$" according to policy defined by Oracle.)
-- Step 1: Login from SYS privilege user, To Find the existing password in encrypted form
CONNECT <<sys_user>>/<<sys_password>> AS SYSDBA
 
SELECT name, password FROM sys.user$ WHERE name = '<<user_name>>';

/*
NAME          PASSWORD
------------- ----------------        
<<user_name>> 5F6008F9ED270AD6
*/

--To assign the temp password for user - <<user_name>>
ALTER USER <<user_name>> IDENTIFIED BY <<temp_password>>;

--Step 2: Connect to the HR user with password
CONNECT <<user_name>>/<<hr_temp_password>> 

SELECT USER FROM dual;
/*
USER
----
<<user_name>> 
*/

-- Step 3: Disconnect from <<user_name>> user

-- Step 4: Agian Login from SYS privilege user
CONNECT <<sys_user>>/<<sys_password>> AS SYSDBA

ALTER USER <<user_name>> IDENTIFIED BY VALUES '5F6008F9ED270AD6';

-- Step 5: The password is now reset as it was.
-- Note: Please noted down the encrypted as it was.
