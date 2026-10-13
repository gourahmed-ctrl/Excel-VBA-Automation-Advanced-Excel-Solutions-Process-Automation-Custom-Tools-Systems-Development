@echo off
title System Performance Monitor & Heavy Process Killer
color 0A
echo ============================================================
echo       مراقبة الأداء وإنهاء العمليات الثقيلة
echo ============================================================
echo.
echo [تحذير] سيتم إنهاء أي عملية تستهلك أكثر من 50% من:
echo   - وحدة المعالجة المركزية (CPU)
echo   - أو الذاكرة (RAM)
echo.
echo سيتم التحديث كل 5 ثوانٍ. اضغط Ctrl+C للخروج.
echo ============================================================
echo.

:loop
cls
echo ============================================================
echo [%time%] جارٍ فحص العمليات...
echo ============================================================
echo.

:: ============================================================
:: 1. عرض العمليات الأكثر استهلاكاً للـ CPU (أعلى 5)
:: ============================================================
echo [*] العمليات الأكثر استهلاكاً للمعالج (CPU):
echo ------------------------------------------------------------
powershell -command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU, WorkingSet64 | Format-Table -AutoSize"
echo.

:: ============================================================
:: 2. عرض العمليات الأكثر استهلاكاً للـ RAM (أعلى 5)
:: ============================================================
echo [*] العمليات الأكثر استهلاكاً للذاكرة (RAM):
echo ------------------------------------------------------------
powershell -command "Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, WorkingSet64 | Format-Table -AutoSize"
echo.

:: ============================================================
:: 3. البحث عن العمليات التي تستهلك > 50% من CPU أو RAM وإنهاؤها
:: ============================================================
echo [*] البحث عن العمليات التي تستهلك أكثر من 50%% من الموارد...
echo ------------------------------------------------------------

:: إنشاء ملف مؤقت لتخزين العمليات المخالفة
set tempfile=%temp%\heavy_processes.txt

:: استخدام PowerShell لجلب العمليات التي تستهلك > 50% من CPU أو RAM
powershell -command "
$ErrorActionPreference = 'SilentlyContinue';

# الحصول على إجمالي الذاكرة المتاحة
$TotalRAM = (Get-CimInstance -Class Win32_ComputerSystem).TotalPhysicalMemory;

# جلب العمليات
$Processes = Get-Process;

foreach ($p in $Processes) {
    $CPUpercent = 0;
    $RAMpercent = 0;
    
    # حساب نسبة استخدام CPU (تقريبي)
    $CPUpercent = [math]::Round(($p.CPU / (Get-CimInstance -Class Win32_PerfFormattedData_PerfOS_Processor | Where-Object { $_.Name -eq '_Total' }).PercentProcessorTime) * 100, 2);
    
    # حساب نسبة استخدام RAM
    if ($TotalRAM -gt 0 -and $p.WorkingSet64 -gt 0) {
        $RAMpercent = [math]::Round(($p.WorkingSet64 / $TotalRAM) * 100, 2);
    }
    
    # إذا تجاوزت النسبة 50% في أي من المؤشرين
    if ($CPUpercent -gt 50 -or $RAMpercent -gt 50) {
        # استثناء العمليات النظامية الأساسية
        $ExcludeProcesses = @('Idle', 'System', 'csrss', 'winlogon', 'services', 'lsass', 'svchost', 'wininit', 'dwm', 'explorer', 'taskhost', 'conhost', 'cmd', 'powershell', 'SearchHost', 'RuntimeBroker');
        $IsExcluded = $false;
        foreach ($ex in $ExcludeProcesses) {
            if ($p.ProcessName -eq $ex) {
                $IsExcluded = $true;
                break;
            }
        }
        
        if (-not $IsExcluded) {
            Write-Output \"$($p.Id)|$($p.ProcessName)|$CPUpercent|$RAMpercent\";
        }
    }
}
" > "%tempfile%"

:: قراءة الملف المؤقت وإنهاء العمليات المخالفة
set count=0
for /f "usebackq tokens=1,2,3,4 delims=|" %%a in ("%tempfile%") do (
    set /a count+=1
    echo     [عملية %%b] - CPU: %%c%% - RAM: %%d%%
    echo     جارٍ إنهاء العملية (PID: %%a)...
    taskkill /PID %%a /F >nul 2>&1
    if %errorlevel% equ 0 (
        echo     [تم] إنهاء %%b بنجاح.
    ) else (
        echo     [فشل] تعذر إنهاء %%b. قد تكون عملية نظامية.
    )
    echo.
)

if %count% equ 0 (
    echo     [جيد] لا توجد عمليات تستهلك أكثر من 50%% من الموارد.
) else (
    echo     [ملخص] تم إنهاء %count% عملية/عمليات.
)

:: حذف الملف المؤقت
del "%tempfile%" >nul 2>&1

echo.
echo ============================================================
echo [متابعة] التحديث التالي بعد 5 ثوانٍ...
echo اضغط Ctrl+C للخروج من البرنامج.
echo ============================================================

:: انتظار 5 ثوانٍ قبل التحديث التلقائي
timeout /t 5 /nobreak >nul
goto loop