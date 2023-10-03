@echo off
setlocal enabledelayedexpansion

set "searchFile=NVDA\nvda.exe"
set "filePath="

for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "drive=%%d:"
    if exist "!drive!\%searchFile%" (
        set "filePath=!drive!\%searchFile%"
        echo path:!filePath!
    )
)

set "registryKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
set "sv_Name=nvda_auto_runner"
set "sv_Data=!filePath!"

>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system" && (
    goto :runAsAdmin
) || (
    echo You need to run this script as an administrator.
    echo Please right-click on the script and select "Run as administrator".
    goto :eof
)

:runAsAdmin
reg add "%registryKey%" /v "%sv_Name%" /t REG_SZ /d "%sv_Data%" /f
echo "%registryKey%" /v "%sv_Name%" /t REG_SZ /d "%sv_Data%" /f
if %errorlevel% equ 0 (
    echo The string value "%sv_Name%" with data "%sv_Data%" was successfully added/updated in the Registry.
) else (
    echo An error occurred while adding/updating the value in the Registry.
)
::check other scripts @https://github.com/WhiteRope/vision_tools

:end
pause