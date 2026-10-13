@echo off
title نسخ احتياطي
color 0A
set "source=%userprofile%\Desktop"
set "destination=%userprofile%\Desktop\Backup_%date:/=-%"

echo جاري إنشاء نسخة احتياطية...
mkdir "%destination%" >nul 2>&1
xcopy "%source%\*.txt" "%destination%\" /i /y >nul 2>&1
xcopy "%source%\*.docx" "%destination%\" /i /y >nul 2>&1
xcopy "%source%\*.xlsx" "%destination%\" /i /y >nul 2>&1

echo تم النسخ إلى: %destination%
pause