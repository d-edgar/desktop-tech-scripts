@echo off
REM ##################################################
REM Windows User Profile backup script
REM version="2.1.0"
REM ##################################################
REM HISTORY:
REM v.1.1.0 - Added option to automatically move past file errors
REM v.1.1.1 - Added logging
REM v.1.1.2 - Moved log to Desktop due to permissions issue
REM v.2.0.0 - Modified to copy everything in the User's folder except the AppData directory and the NTUSER files
REM           Added the /XJ flag to exclude junction points. Without this, the backup gets stuck in a loop with hidden items in the user_source folder since we are getting everyting in there with the above exceptions
REM           Added the /MT flag to enable multi-threading to increase backup speed
REM v.2.0.1 - Fixed logging. It will now successfully copy the backup log to the root of the user's profile folder
REM v.2.1.0 - Added a check to see if the user profile folder exists before moving on. Else it prompts again for a valid user ID number
REM           
REM Last modified:
REM 12/6/19
REM ##################################################

SET /p user=Enter User ID:
SET user_source=C:\Users\%user%
SET dest_path="E:\User Profile Backups\Profiles\%user%"

echo Starting Profile Backup...
timeout /t 1 /nobreak>nul
robocopy /MT /E /R:0 /V /COPY:DAT /LOG:"%user_source%\profile_backup_log.txt" /TEE "%user_source%" %dest_path% /XJ

xcopy /y "%user_source%\profile_backup_log.txt" %dest_path%

echo Getting Current Hostname...
timeout /t 1 /nobreak>nul
hostname >> "E:\User Profile Backups\Profiles\%user%\OldComputerName.txt"
echo Done!
timeout /t 1 /nobreak>nul
echo Profile Backup Complete!
timeout /t 1 /nobreak>nul
)