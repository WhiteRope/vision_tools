@echo off
set "scriptDir=%~dp0"
set "scriptFolder=Albaraka"
set script1=%scriptDir%%scriptFolder%\step1.bat
set script2=%scriptDir%%scriptFolder%\step2.ps1
set script3=%scriptDir%%scriptFolder%\step3.bat

if exist %script1% (
    echo Running %script1%...
    start "" %script1%
) else (
    echo %script1% not found.
)

if exist %script2% (
    echo Running %script2%...
    @REM powershell.exe -ExecutionPolicy RemoteSigned -Command "Start-Process -File %script2% -Verb RunAs"
    @REM powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%script2%""' -Verb RunAs}"
    powershell -Command "Start-Process powershell -Verb runAs -ArgumentList '-noexit','-ExecutionPolicy','bypass','-File','%script2%'"
) else (
    echo %script3% not found.
)

if exist %script3% (
    echo Running %script3%...
    start "" %script3%
) else (
    echo %script3% not found.
)

pause
