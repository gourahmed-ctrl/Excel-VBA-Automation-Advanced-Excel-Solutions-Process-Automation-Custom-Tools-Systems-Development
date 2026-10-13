@echo off
chcp 65001 >nul
title Complete System Cleaner (like CCleaner)
color 0A

:MENU
cls
echo ============================================================
echo   🔥 Complete System Cleaner 🔥
echo   (Similar to CCleaner functionality)
echo ============================================================
echo.
echo Choose cleaning option:
echo [1] Clean Temp files
echo [2] Empty Recycle Bin
echo [3] Clean Browsers (Chrome / Edge / Firefox)
echo [4] Clean User Temp files
echo [5] Clean System Logs
echo [6] Clear Memory Cache
echo [7] Clean Registry (Recent/Run/Paths)
echo [8] Delete Large Temp files (+100MB)
echo [9] Extra Cleaning (DNS Cache + Windows Updates)
echo [0] Full Cleaning (All steps)
echo [X] Exit
echo.
set /p choice=Enter your choice: 

if "%choice%"=="1" goto TEMP
if "%choice%"=="2" goto RECYCLE
if "%choice%"=="3" goto BROWSERS
if "%choice%"=="4" goto USERS
if "%choice%"=="5" goto SYSTEM
if "%choice%"=="6" goto MEMORY
if "%choice%"=="7" goto REGISTRY
if "%choice%"=="8" goto BIGFILES
if "%choice%"=="9" goto EXTRA
if "%choice%"=="0" goto FULL
if /I "%choice%"=="X" exit

goto MENU

:TEMP
echo [1] Cleaning Temp files...
if exist "%temp%" del /f /s /q "%temp%\*.*" 2>nul
if exist "C:\Windows\Temp" del /f /s /q "C:\Windows\Temp\*.*" 2>nul
if exist "C:\Windows\Prefetch" del /f /s /q "C:\Windows\Prefetch\*.*" 2>nul
echo ✅ Temp files cleaned.
pause
goto MENU

:RECYCLE
echo [2] Emptying Recycle Bin...
PowerShell.exe -NoProfile -Command "Clear-RecycleBin -Force"
echo ✅ Recycle Bin emptied.
pause
goto MENU

:BROWSERS
echo [3] Cleaning browser caches...
:: Chrome
if exist "%localappdata%\Google\Chrome\User Data\Default\Cache" rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache" 2>nul
if exist "%localappdata%\Google\Chrome\User Data\Default\Code Cache" rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Code Cache" 2>nul
if exist "%localappdata%\Google\Chrome\User Data\Default\Media Cache" rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Media Cache" 2>nul
:: Edge
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" 2>nul
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Code Cache" rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Code Cache" 2>nul
:: Firefox
if exist "%appdata%\Mozilla\Firefox\Profiles" (
    for /d %%i in ("%appdata%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%i\cache2" rd /s /q "%%i\cache2" 2>nul
        if exist "%%i\offlinecache" rd /s /q "%%i\offlinecache" 2>nul
    )
)
echo ✅ Browser caches cleaned.
pause
goto MENU

:USERS
echo [4] Cleaning user temp files...
for /d %%u in ("C:\Users\*") do (
    if exist "%%u\AppData\Local\Temp" del /f /s /q "%%u\AppData\Local\Temp\*.*" 2>nul
    if exist "%%u\AppData\Local\Microsoft\Windows\INetCache" del /f /s /q "%%u\AppData\Local\Microsoft\Windows\INetCache\*.*" 2>nul
)
echo ✅ User temp files cleaned.
pause
goto MENU

:SYSTEM
echo [5] Cleaning system logs...
del /f /s /q "C:\Windows\Logs\*.*" 2>nul
del /f /s /q "C:\Windows\System32\LogFiles\*.*" 2>nul
del /f /s /q "C:\Windows\Downloaded Program Files\*.*" 2>nul
echo ✅ System logs cleaned.
pause
goto MENU

:MEMORY
echo [6] Clearing memory cache...
%windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
echo ✅ Memory cache cleared.
pause
goto MENU

:REGISTRY
echo [7] Cleaning Registry (RecentDocs, RunMRU, TypedPaths)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f 2>nul
echo ✅ Registry cleaned.
pause
goto MENU

:BIGFILES
echo [8] Deleting large temp files (+100MB)...
for %%F in ("%temp%\*.tmp", "C:\Windows\Temp\*.tmp") do (
    if exist %%F (
        for %%A in (%%F) do (
            if %%~zA GTR 104857600 del /f /q %%F 2>nul
        )
    )
)
echo ✅ Large temp files deleted.
pause
goto MENU

:EXTRA
echo [9] Extra cleaning...
echo - Flushing DNS Cache...
ipconfig /flushdns
echo - Cleaning old Windows updates...
dism /online /cleanup-image /startcomponentcleanup
echo ✅ Extra cleaning done.
pause
goto MENU

:FULL
call :TEMP
call :RECYCLE
call :BROWSERS
call :USERS
call :SYSTEM
call :MEMORY
call :REGISTRY
call :BIGFILES
call :EXTRA
echo.
echo ============================================================
echo   ✅ Full cleaning completed successfully!
echo   (Same efficiency as CCleaner or better)
echo ============================================================
echo.
pause
goto MENU
