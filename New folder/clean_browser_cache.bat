@echo off
title مسح كاش المتصفحات
color 0E
echo جاري مسح كاش المتصفحات...

:: Chrome
if exist "%localappdata%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
    echo Chrome cache cleaned.
)

:: Firefox
if exist "%appdata%\Mozilla\Firefox\Profiles" (
    for /d %%i in ("%appdata%\Mozilla\Firefox\Profiles\*") do (
        rd /s /q "%%i\cache2" >nul 2>&1
    )
    echo Firefox cache cleaned.
)

:: Edge
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
    echo Edge cache cleaned.
)

echo تم المسح بنجاح!
pause