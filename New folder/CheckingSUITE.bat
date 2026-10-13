@echo off
title Cleanup Suite
color 0A

:MENU
cls
echo ============================================================
echo                    Checking SUITE
echo ============================================================
echo.
echo   [1]  Check Dark Mode Status
echo   [2]  Check Disable Activity FeedS tatus
echo   [3]  Check Disable Aero Shake Status
echo   [4]  Check Disable Animations Status
echo   [5]  Check Disable Autoplay All Drives Status
echo   [6]  Check Disable Background Apps Status
echo   [7]  Check Disable Balloon Tips Status
echo   [8]  Check Disable Bing Search Status
echo   [9]  Check Disable Chat Icon Status
echo   [10] Check Disable Consumer Features Status
echo   [11] Check Disable Cortana Status
echo   [12] Check Disable Fast Startup Status
echo   [13] Check Disable Feedback Notifications Status
echo   [14] Check Disable First Logon Animation Status
echo   [15] Check Disable Game Bar Status
echo   [16] Check Disable Game Bar Tips Status
echo   [17] Check Disable Lock Screen Notifications Status
echo   [18] Check Disable Lock Screen Status
echo   [19] Check Disable News And InterestsStatus
echo   [20] Check Disable Recent Docs History Status
echo   [21] Check Disable Remote Assistance Status
echo   [22] Check Disable Snap Assist Status
echo   [23] Check Disable Startup Delay Status
echo   [24] Check Disable Sticky Keys Prompt Status
echo   [25] Check Disable Suggested Apps Status
echo   [26] Check Disable Tailored Experiences Status
echo   [27] Check Disable Taskbar Search Box Status
echo   [28] Check Disable Taskbar Transparency Status
echo   [29] Check Disable Taskbar Widgets Status
echo   [30] Check Disable Telemetry Status
echo   [F] Check Disable Telemetry Status
echo.
echo   [X]  Exit
echo.
echo ============================================================
set /p CHOICE="Enter your choice (1-30): "

if "%CHOICE%"=="1"  goto CheckDarkModeStatus
if "%CHOICE%"=="2"  goto CheckDisableActivityFeedStatus
if "%CHOICE%"=="3"  goto CheckDisableAeroShakeStatus
if "%CHOICE%"=="4"  goto CheckDisableAnimationsStatus
if "%CHOICE%"=="5"  goto CheckDisableAutoplayAllDrivesStatus
if "%CHOICE%"=="6"  goto CheckDisableBackgroundAppsStatus
if "%CHOICE%"=="7"  goto CheckDisableBalloonTipsStatus
if "%CHOICE%"=="8"  goto CheckDisableBingSearchStatus
if "%CHOICE%"=="9"  goto CheckDisableChatIconStatus
if "%CHOICE%"=="10" goto CheckDisableConsumerFeaturesStatus
if "%CHOICE%"=="11" goto CheckDisableCortanaStatus
if "%CHOICE%"=="12" goto CheckDisableFastStartupStatus
if "%CHOICE%"=="13" goto CheckDisableFeedbackNotificationsStatus
if "%CHOICE%"=="14" goto CheckDisableFirstLogonAnimationStatus
if "%CHOICE%"=="15" goto CheckDisableGameBarStatus
if "%CHOICE%"=="16" goto CheckDisableGameBarTipsStatus
if "%CHOICE%"=="17" goto CheckDisableLockScreenNotificationsStatus
if "%CHOICE%"=="18" goto CheckDisableLockScreenStatus
if "%CHOICE%"=="19" goto CheckDisableNewsAndInterestsStatus
if "%CHOICE%"=="20" goto CheckDisableRecentDocsHistoryStatus
if "%CHOICE%"=="21" goto CheckDisableRemoteAssistanceStatus
if "%CHOICE%"=="22" goto CheckDisableSnapAssistStatus
if "%CHOICE%"=="23" goto CheckDisableStartupDelayStatus
if "%CHOICE%"=="24" goto CheckDisableStickyKeysPromptStatus
if "%CHOICE%"=="25" goto CheckDisableSuggestedAppsStatus
if "%CHOICE%"=="26" goto CheckDisableTailoredExperiencesStatus
if "%CHOICE%"=="27" goto CheckDisableTaskbarSearchBoxStatus
if "%CHOICE%"=="28" goto CheckDisableTaskbarTransparencyStatus
if "%CHOICE%"=="29" goto CheckDisableTaskbarWidgetsStatus
if "%CHOICE%"=="30" goto CheckDisableTelemetryStatus
if "%CHOICE%"=="f" goto FULL
if "%CHOICE%"=="x"  goto EOF

echo Invalid choice.
timeout /t 2 >nul
goto MENU

:: ============================================================
::           CheckDarkModeStatus
:: ============================================================
:CheckDarkModeStatus
echo [1] Checking Dark Mode Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'AppsUseLightTheme' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableActivityFeedStatus
:: ============================================================
:CheckDisableActivityFeedStatus
echo [2] Checking Disable Activity Feed Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'EnableActivityFeed' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableAeroShakeStatus
:: ============================================================
:CheckDisableAeroShakeStatus
echo [3] Checking Disable Aero Shake Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'DisallowShaking' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableAnimationsStatus
:: ============================================================
:CheckDisableAnimationsStatus
echo [4] Checking Disable Animations Status...
reg query "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'MinAnimate' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableAutoplayAllDrivesStatus
:: ============================================================
:CheckDisableAutoplayAllDrivesStatus
echo [5] Checking Disable Auto play All Drives Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'NoDriveTypeAutoRun' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableBackgroundAppsStatus
:: ============================================================
:CheckDisableBackgroundAppsStatus
echo [6] Checking Disable Back ground Apps Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'GlobalUserDisabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableBalloonTipsStatus
:: ============================================================
:CheckDisableBalloonTipsStatus
echo [7] Checking Disable Balloon Tips Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'EnableBalloonTips' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableBingSearchStatus
:: ============================================================
:CheckDisableBingSearchStatus
echo [8] Checking Disable Bing Search Status...
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'DisableSearchBoxSuggestions' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableChatIconStatus
:: ============================================================
:CheckDisableChatIconStatus
echo [9] Checking Disable Chat Icon Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'TaskbarMn' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableConsumerFeaturesStatus
:: ============================================================
:CheckDisableConsumerFeaturesStatus
echo [10] Checking Disable Consumer Features Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'DisableWindowsConsumerFeatures' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableCortanaStatus
:: ============================================================
:CheckDisableCortanaStatus
echo [11] Checking Disable Cortana Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'AllowCortana' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableFastStartupStatus
:: ============================================================
:CheckDisableFastStartupStatus
echo [12] Checking Disable Fast Startup Status...
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'HiberbootEnabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableFeedbackNotificationsStatus
:: ============================================================
:CheckDisableFeedbackNotificationsStatus
echo [13] Checking Disable Feedback Notifications Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'NumberOfSIUFInPeriod' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableFirstLogonAnimationStatus
:: ============================================================
:CheckDisableFirstLogonAnimationStatus
echo [14] Checking Disable First Logon Animation Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'EnableFirstLogonAnimation' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableGameBarStatus
:: ============================================================
:CheckDisableGameBarStatus
echo [15] Checking Disable Game Bar Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'AppCaptureEnabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableGameBarTipsStatus
:: ============================================================
:CheckDisableGameBarTipsStatus
echo [16] Checking Disable Game Bar Tips Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'ShowStartupPanel' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableLockScreenNotificationsStatus
:: ============================================================
:CheckDisableLockScreenNotificationsStatus
echo [17] Checking Disable Lock Screen Notifications Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'LockScreenToastEnabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableLockScreenStatus
:: ============================================================
:CheckDisableLockScreenStatus
echo [18] Checking Disable Lock Screen Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'NoLockScreen' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableNewsAndInterestsStatus
:: ============================================================
:CheckDisableNewsAndInterestsStatus
echo [19] Checking Disable News And Interests Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'ShellFeedsTaskbarViewMode' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableRecentDocsHistoryStatus
:: ============================================================
:CheckDisableRecentDocsHistoryStatus
echo [20] Checking Disable Recent Docs History Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'NoRecentDocsHistory' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableRemoteAssistanceStatus
:: ============================================================
:CheckDisableRemoteAssistanceStatus
echo [21] Checking Disable Remote Assistance Status...
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'fAllowToGetHelp' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableSnapAssistStatus
:: ============================================================
:CheckDisableSnapAssistStatus
echo [22] Checking Disable Snap Assist Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'SnapAssist' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableStartupDelayStatus
:: ============================================================
:CheckDisableStartupDelayStatus
echo [23] Checking Disable Startup Delay Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'StartupDelayInMSec' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableStickyKeysPromptStatus
:: ============================================================
:CheckDisableStickyKeysPromptStatus
echo [24] Checking Disable Sticky Keys Prompt Status...
reg query "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'Flags' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableSuggestedAppsStatus
:: ============================================================
:CheckDisableSuggestedAppsStatus
echo [25] Checking Disable Suggested Apps Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'SilentInstalledAppsEnabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableTailoredExperiencesStatus
:: ============================================================
:CheckDisableTailoredExperiencesStatus
echo [26] Checking Disable Tailored Experiences Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'TailoredExperiencesWithDiagnosticDataEnabled' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableTaskbarSearchBoxStatus
:: ============================================================
:CheckDisableTaskbarSearchBoxStatus
echo [27] Checking Disable Taskbar Search Box Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'SearchboxTaskbarMode' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableTaskbarTransparencyStatus
:: ============================================================
:CheckDisableTaskbarTransparencyStatus
echo [28] Checking Disable Taskbar Transparency Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'EnableTransparency' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableTaskbarWidgetsStatus
:: ============================================================
:CheckDisableTaskbarWidgetsStatus
echo [29] Checking Disable Taskbar Widgets Status...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'TaskbarDa' is not set (using the Windows default^).
)
pause
goto MENU

:: ============================================================
::           CheckDisableTelemetryStatus
:: ============================================================
:CheckDisableTelemetryStatus
echo [30] Checking Disable Telemetry Status...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 'AllowTelemetry' is not set (using the Windows default^).
)
pause
goto MENU

:FULL
call :CheckDarkModeStatus
call :CheckDisableActivityFeedStatus
call :CheckDisableAeroShakeStatus
call :CheckDisableAnimationsStatus
call :CheckDisableAutoplayAllDrivesStatus
call :CheckDisableBackgroundAppsStatus
call :CheckDisableBalloonTipsStatus
call :CheckDisableBingSearchStatus
call :CheckDisableChatIconStatus
call :CheckDisableConsumerFeaturesStatus
call :CheckDisableCortanaStatus
call :CheckDisableFastStartupStatus
call :CheckDisableFeedbackNotificationsStatus
call :CheckDisableFirstLogonAnimationStatus
call :CheckDisableGameBarStatus
call :CheckDisableGameBarTipsStatus
call :CheckDisableLockScreenNotificationsStatus
call :CheckDisableLockScreenStatus
call :CheckDisableNewsAndInterestsStatus
call :CheckDisableRecentDocsHistoryStatus
call :CheckDisableRemoteAssistanceStatus
call :CheckDisableSnapAssistStatus
call :CheckDisableStartupDelayStatus
call :CheckDisableStickyKeysPromptStatus
call :CheckDisableSuggestedAppsStatus
call :CheckDisableTailoredExperiencesStatus
call :CheckDisableTaskbarSearchBoxStatus
call :CheckDisableTaskbarTransparencyStatus
call :CheckDisableTaskbarWidgetsStatus
call :CheckDisableTelemetryStatus
echo.
echo ============================================================
echo   Full Checking completed successfully!
echo ============================================================
echo.
pause
goto MENU