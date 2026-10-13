@echo off

:: التحقق من صلاحيات المسؤول
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /B
)

:: الانتقال لمجلد السكريبت
cd /D "%~dp0"

:: تنفيذ الأمر مرة واحدة
echo Clearing...
EmptyStandbyList.exe standbylist
echo Done.
timeout 3
exit