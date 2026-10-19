@echo off
title Graphic & Video Apps Suite
color 0B

:MENU
cls
echo ============================================================
echo                 Graphic ^& Video Apps Suite
echo ============================================================
echo.
echo   [1] Install GIMP (Photo Editor)
echo   [2] Install Inkscape (Vector Design)
echo   [3] Install Krita (Digital Painting)
echo   [4] Install Blender (3D ^& Animation)
echo   [5] Install DaVinci Resolve (Video Editor)
echo   [6] Install Kdenlive (Video Editor)
echo   [7] Install OBS Studio (Screen Record)
echo   [8] Install HandBrake (Video Converter)
echo.
echo   [F] Install All
echo   [X] Exit
echo.
echo ============================================================
set /p CHOICE="Enter your choice (1-8, F, X): "

if "%CHOICE%"=="1" goto IGIMP
if "%CHOICE%"=="2" goto IINKSCAPE
if "%CHOICE%"=="3" goto IKRITA
if "%CHOICE%"=="4" goto IBLENDER
if "%CHOICE%"=="5" goto IDAVINCI
if "%CHOICE%"=="6" goto IKDENLIVE
if "%CHOICE%"=="7" goto IOBS
if "%CHOICE%"=="8" goto IHANDBRAKE
if /I "%CHOICE%"=="f" goto FULL
if /I "%CHOICE%"=="x" exit

echo.
echo Invalid choice.
timeout /t 2 >nul
goto MENU

:: ============================================================
::             Install GIMP
:: ============================================================
:IGIMP
echo [1] Installing GIMP...
winget install -e --id GIMP.GIMP --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install Inkscape
:: ============================================================
:IINKSCAPE
echo [2] Installing Inkscape...
winget install -e --id Inkscape.Inkscape --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install Krita
:: ============================================================
:IKRITA
echo [3] Installing Krita...
winget install -e --id KDE.Krita --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install Blender
:: ============================================================
:IBLENDER
echo [4] Installing Blender...
winget install -e --id BlenderFoundation.Blender --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install DaVinci Resolve
:: ============================================================
:IDAVINCI
echo [5] Installing DaVinci Resolve...
winget install -e --id BlackmagicDesign.DaVinciResolve --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install Kdenlive
:: ============================================================
:IKDENLIVE
echo [6] Installing Kdenlive...
winget install -e --id KDE.Kdenlive --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install OBS Studio
:: ============================================================
:IOBS
echo [7] Installing OBS Studio...
winget install -e --id OBSProject.OBSStudio --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::             Install HandBrake
:: ============================================================
:IHANDBRAKE
echo [8] Installing HandBrake...
winget install -e --id HandBrake.HandBrake --accept-package-agreements --accept-source-agreements
pause
goto MENU

:: ============================================================
::                     FULL INSTALL
:: ============================================================
:FULL
call :IGIMP
call :IINKSCAPE
call :IKRITA
call :IBLENDER
call :IDAVINCI
call :IKDENLIVE
call :IOBS
call :IHANDBRAKE

echo.
echo ============================================================
echo          All Applications Installed Successfully!
echo ============================================================
echo.
pause
goto MENU