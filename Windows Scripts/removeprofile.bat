@ECHO OFF

:: --------------------------------------
::
:: Windows 7 User Profile Cleaning Script
:: Version 3.1
::
:: Written by Mike Stone
:: mikestone@gmail.com
:: https://mstoneblog.wordpress.com
::
:: --------------------------------------
::
:: Welcome!  This script is designed to automate the process of flushing
:: user profiles within Windows 7, while at the same time preserving
:: profiles of your choosing, including domain users.
::
:: This script is written as an example of wanting all domain users wiped
:: except for the one called "pctest".
::
:: Portions of the script that will require manual edits will be preceded
:: by instructions with these "double colon" comment marks.
::
:: Please let me know how well (or not well) this works for you or any
:: features you can think of that could be added.
::
:: --------------------------------------

title Windows 7 User Profile Cleaning

:: ----------
:: Add any users you wish to exclude from the wipe to the "userpreserve"
:: line below and separate them by commas.  Be careful - these are
:: case-sensitive.
:: ----------

:USERPRESERVE
set userpreserve="Administrator,All Users,UpdatusUser,Default,Default User,Public,pctest"

FOR /f "tokens=*" %%a IN ('reg query "hklm\software\microsoft\windows nt\currentversion\profilelist"^|find /i "s-1-5-21"') DO CALL :REGCHECK "%%a"
GOTO VERIFY

:REGCHECK
set SPACECHECK=
FOR /f "tokens=3,4" %%b in ('reg query %1 /v ProfileImagePath') DO SET USERREGPATH=%%b %%c
FOR /f "tokens=2" %%d in ('echo %USERREGPATH%') DO SET SPACECHECK=%%d
IF ["%SPACECHECK%"]==[""] GOTO REGCHECK2
GOTO USERCHECK

:REGCHECK2
FOR /f "tokens=3" %%g in ('reg query %1 /v ProfileImagePath') DO SET USERREGPATH=%%g
GOTO USERCHECK

:USERCHECK
FOR /f "tokens=3 delims=\" %%e in ('echo %USERREGPATH%') DO SET USERREG=%%e
FOR /f "tokens=1 delims=." %%f IN ('echo %USERREG%') DO SET USERREGPARSE=%%f
ECHO %USERPRESERVE%|find /I "%USERREGPARSE%" > NUL
IF ERRORLEVEL=1 GOTO CLEAN
IF ERRORLEVEL=0 GOTO SKIP

:SKIP
ECHO Skipping user clean for %USERREG%
GOTO :EOF

:CLEAN
ECHO Cleaning user profile for %USERREG%
rmdir "C:\Users\%USERREG%" /s /q > NUL
ECHO Cleaning user registry for %USERREG%
reg delete %1 /f
IF EXIST "C:\Users\%USERREG%" GOTO RETRYCLEAN1
GOTO :EOF

:RETRYCLEAN1
ECHO Retrying clean of user profile %USERREG%
rmdir "C:\Users\%USERREG%" /s /q > NUL
IF EXIST "C:\Users\%USERREG%" GOTO RETRYCLEAN2
GOTO :EOF

:RETRYCLEAN2
ECHO Retrying clean of user profile %USERREG%
rmdir "C:\Users\%USERREG%" /s /q > NUL
GOTO :EOF

:VERIFY
FOR /f "tokens=*" %%g IN ('reg query "hklm\software\microsoft\windows nt\currentversion\profilelist"^|find /i "s-1-5-21"') DO CALL :REGCHECKV "%%g"
GOTO REPORT

:REGCHECKV
set SPACECHECKV=
FOR /f "tokens=3,4" %%h in ('reg query %1 /v ProfileImagePath') DO SET USERREGPATHV=%%h %%i
FOR /f "tokens=2" %%j in ('echo %USERREGPATHV%') DO SET SPACECHECKV=%%j
IF ["%SPACECHECKV%"]==[""] GOTO REGCHECKV2
GOTO USERCHECKV

:REGCHECKV2
FOR /f "tokens=3" %%k in ('reg query %1 /v ProfileImagePath') DO SET USERREGPATHV=%%k
GOTO USERCHECKV

:USERCHECKV
FOR /f "tokens=3 delims=\" %%l in ('echo %USERREGPATHV%') DO SET USERREGV=%%l
FOR /f "tokens=1 delims=." %%m IN ('echo %USERREGV%') DO SET USERREGPARSEV=%%m
ECHO %USERPRESERVE%|find /I "%USERREGPARSEV%" > NUL
IF ERRORLEVEL=1 GOTO VERIFYERROR
IF ERRORLEVEL=0 GOTO :EOF

:VERIFYERROR
SET USERERROR=YES
GOTO :EOF

:REPORT
IF [%USERERROR%]==[YES] (
		set RESULT=FAILURE
)		ELSE (
		set RESULT=SUCCESS
)

:: ----------
:: This is fairly optional - it's just something I added so
:: that I could keep an eye on the labs remotely to make
:: sure there weren't masses of critical errors with the
:: script failing.
::
:: If you don't want it, just comment-out or remove the
:: "net use" line.
::
:: If you do want it, then make the necessary modifications
:: to the net use to map an appropriate sharepoint.
:: ----------

net use t: \\server\share

IF EXIST "t:\labreport.txt" (
	GOTO REPORTGEN
) ELSE (
	GOTO EXIT
)

:REPORTGEN
FOR /F "tokens=*" %%n in ('echo %date:~10,4%-%date:~4,2%-%date:~7,2% %time:~0,2%-%time:~3,2%-%time:~6,2%') DO SET TDATETIME=%%n
FOR /F "tokens=14" %%o in ('ipconfig^|find "IPv4 Address"') DO SET IPNUMBER=%%o
ECHO. %RESULT%	%COMPUTERNAME%	%IPNUMBER%	%TDATETIME%>>"t:\labreport.txt"
net use t: /delete
GOTO EXIT