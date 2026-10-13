@echo off
title Cleanup Suite
color 0A

:MENU
cls
echo ============================================================
echo                    CLEANUP SUITE
echo ============================================================
echo.
echo   [1]  Clean User Temp
echo   [2]  Clean Windows Temp
echo   [3]  Empty Recycle Bin
echo   [4]  Clean Browser Caches
echo   [5]  Clean User Profiles Temp
echo   [6]  Clean System Files (DISM)
echo   [7]  Clean Memory Cache
echo   [8]  Clean Registry Backups
echo   [9]  Extra Cleaning (DNS + Old Updates)
echo   [10] Find Big Files
echo   [11] Clean VS Code Cache
echo   [12] Clean Windows Update Cache
echo   [13] Clean Thumbnail Cache
echo   [14] Clean Prefetch
echo   [15] Clean Recent Documents
echo   [16] Clean Font Cache
echo   [17] FULL CLEAN (all of the above)
echo.
echo   [x]  Exit
echo.
echo ============================================================
set /p CHOICE="Enter your choice (0-17): "

if "%CHOICE%"=="1"  goto TEMP
if "%CHOICE%"=="2"  goto WTEMP
if "%CHOICE%"=="3"  goto RECYCLE
if "%CHOICE%"=="4"  goto BROWSERS
if "%CHOICE%"=="5"  goto USERS
if "%CHOICE%"=="6"  goto SYSTEM
if "%CHOICE%"=="7"  goto MEMORY
if "%CHOICE%"=="8"  goto REGISTRY
if "%CHOICE%"=="9"  goto EXTRA
if "%CHOICE%"=="10" goto BIGFILES
if "%CHOICE%"=="11" goto VSCODE
if "%CHOICE%"=="12" goto WINUPDATE
if "%CHOICE%"=="13" goto THUMBS
if "%CHOICE%"=="14" goto PREFETCH
if "%CHOICE%"=="15" goto RECENT
if "%CHOICE%"=="16" goto FONTCACHE
if "%CHOICE%"=="17" goto FULL
if "%CHOICE%"=="x"  goto EOF

echo Invalid choice.
timeout /t 2 >nul
goto MENU


:TEMP
echo [1] Cleaning User Temp...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
echo User Temp cleaned.
pause
goto MENU


:WTEMP
echo [2] Cleaning Windows Temp...
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" >nul 2>&1
echo Windows Temp cleaned.
pause
goto MENU


:RECYCLE
echo [3] Emptying Recycle Bin...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo Recycle Bin emptied.
pause
goto MENU


:BROWSERS
echo [4] Cleaning Browser Caches...
echo - Chrome...
del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*.*" >nul 2>&1
echo - Edge...
del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*.*" >nul 2>&1
echo - Firefox...
for /d %%P in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" rd /s /q "%%P\cache2" >nul 2>&1
)
echo Browser caches cleaned.
pause
goto MENU


:USERS
echo [5] Cleaning all user profiles Temp folders...
for /d %%U in ("C:\Users\*") do (
    if exist "%%U\AppData\Local\Temp" (
        echo - %%U
        del /f /s /q "%%U\AppData\Local\Temp\*.*" >nul 2>&1
        for /d %%D in ("%%U\AppData\Local\Temp\*") do rd /s /q "%%D" >nul 2>&1
    )
)
echo All user profiles cleaned.
pause
goto MENU


:SYSTEM
echo [6] Cleaning System Files via DISM...
dism /online /cleanup-image /startcomponentcleanup
echo System files cleaned.
pause
goto MENU


:MEMORY
echo [7] Cleaning Memory Cache...
ipconfig /flushdns
echo Clearing memory...
powershell -NoProfile -Command "[System.GC]::Collect()" >nul 2>&1
echo Memory cache cleaned.
pause
goto MENU


:REGISTRY
echo [8] Cleaning old Registry backups...
del /f /q "C:\Windows\System32\config\RegBack\*.*" >nul 2>&1
echo Registry backups cleaned.
pause
goto MENU


:EXTRA
echo [9] Extra cleaning...
echo - Flushing DNS Cache...
ipconfig /flushdns
echo - Cleaning old Windows updates...
dism /online /cleanup-image /startcomponentcleanup
echo Extra cleaning done.
pause
goto MENU


:BIGFILES
echo [10] Finding big files (over 100MB) in your user folder...
echo This may take a moment...
forfiles /P "%USERPROFILE%" /S /M *.* /C "cmd /c if @fsize GTR 104857600 echo @path" 2>nul
echo Big files report done.
pause
goto MENU
:VSCODE
echo [11] Cleaning VS Code Cache...
del /f /s /q "%APPDATA%\Code\Cache\*.*" >nul 2>&1
for /d %%D in ("%APPDATA%\Code\Cache\*") do rd /s /q "%%D" >nul 2>&1
del /f /s /q "%APPDATA%\Code\CachedData\*.*" >nul 2>&1
for /d %%D in ("%APPDATA%\Code\CachedData\*") do rd /s /q "%%D" >nul 2>&1
echo VS Code Cache cleaned.
pause
goto MENU


:WINUPDATE
echo [12] Cleaning Windows Update Cache...
net stop wuauserv >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
net start wuauserv >nul 2>&1
echo Windows Update Cache cleaned.
pause
goto MENU


:THUMBS
echo [13] Cleaning Thumbnail Cache...
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db"  >nul 2>&1
echo Thumbnail cache cleaned.
pause
goto MENU


:PREFETCH
echo [14] Cleaning Prefetch...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo Prefetch cleaned.
pause
goto MENU


:RECENT
echo [15] Cleaning Recent Documents...
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
for /d %%D in ("%APPDATA%\Microsoft\Windows\Recent\*") do rd /s /q "%%D" >nul 2>&1
echo Recent Documents cleaned.
pause
goto MENU


:FONTCACHE
echo [16] Cleaning Font Cache...
net stop FontCache >nul 2>&1
del /f /q "%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\FontCache\*" >nul 2>&1
net start FontCache >nul 2>&1
echo Font cache cleaned.
pause
goto MENU


:FULL
call :TEMP
call :WTEMP
call :RECYCLE
call :BROWSERS
call :USERS
call :SYSTEM
call :MEMORY
call :REGISTRY
call :EXTRA
call :VSCODE
call :WINUPDATE
call :THUMBS
call :PREFETCH
call :RECENT
call :FONTCACHE
echo.
echo ============================================================
echo   Full cleaning completed successfully!
echo ============================================================
echo.
pause
goto MENU