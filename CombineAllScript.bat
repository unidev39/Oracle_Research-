@ECHO OFF

:: To perform operations on a variable within the loop then you will need to enable Delayed Expansion.
setlocal EnableDelayedExpansion

:: Variable declaration 
SET isOS=0

:: Remove the files if previously exists
DEL CombinedODIScripts.sql
DEL ListOfAllODISqlFiles.~tmp

:: Put the file contents in a temporary file
dir *.sql /o/b/s > ListOfAllODISqlFiles.~tmp

:: Print the message to user
echo Combining All Scripts...

:: Loop statement 
FOR /F "tokens=* delims=;" %%i IN (ListOfAllODISqlFiles.~tmp) DO (
 :: Control structure
 IF %%i EQU ODIScripts_nsl.sql GOTO SkipFile 
   IF "!isOS!"=="0" (
       TYPE "%%i" >> CombinedODIScripts.sql
       TYPE insertNewLineChar.~tmpx >> CombinedODIScripts.sql
       ECHO PROMPT '----------------------------------------------------------------' >> CombinedODIScripts.sql
       ECHO PROMPT 'processing of %%i file completed....' >> CombinedODIScripts.sql
       ECHO PROMPT '----------------------------------------------------------------' >> CombinedODIScripts.sql
       TYPE insertNewLineChar.~tmpx >> CombinedODIScripts.sql
   )
 :SkipFile
 set isOS=0
)

SET isOS=

:: Remove the temporary file 
DEL ListOfAllODISqlFiles.~tmp
:: Close the windows operation
endlocal