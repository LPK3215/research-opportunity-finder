@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"
title GitHub Push - Research Innovation Scout

for %%d in ("%cd%") do set "CURRENT_FOLDER_NAME=%%~nxd"

REM ========================================
REM   GitHub configuration
REM ========================================
set "GITHUB_OWNER=LPK3215"
set "GITHUB_REPO_URL=https://github.com/%GITHUB_OWNER%/%CURRENT_FOLDER_NAME%.git"
set "GIT_NAME=LPK3215"
set "GIT_EMAIL=LPK3215@users.noreply.github.com"
set "DEFAULT_BRANCH=main"
set "DEFAULT_COMMIT_MSG=update"
REM ========================================

echo ========================================
echo   GitHub Push Helper
echo ========================================
echo   Repository: %GITHUB_REPO_URL%
echo   Branch:     %DEFAULT_BRANCH%
echo ========================================
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git for Windows was not found.
    echo Please install Git first: https://git-scm.com/download/win
    pause
    exit /b 1
)

if exist ".git" goto RepoReady

echo [INFO] This folder is not a Git repository yet.
set /p "INIT_REPO=Initialize it now? Type yes to continue: "
if /i not "!INIT_REPO!"=="yes" (
    echo [INFO] Cancelled.
    pause
    exit /b 0
)

git init -b %DEFAULT_BRANCH% 2>nul
if errorlevel 1 (
    git init
    git checkout -b %DEFAULT_BRANCH% 2>nul
)

:RepoReady
echo [1/5] Configuring repository identity...
git config user.name "%GIT_NAME%"
git config user.email "%GIT_EMAIL%"
git config core.quotepath false
echo       user.name  = %GIT_NAME%
echo       user.email = %GIT_EMAIL%
echo.

echo [2/5] Ensuring GitHub origin...
set "CURRENT_ORIGIN="
for /f "delims=" %%u in ('git remote get-url origin 2^>nul') do set "CURRENT_ORIGIN=%%u"

if "!CURRENT_ORIGIN!"=="" (
    git remote add origin "%GITHUB_REPO_URL%"
    if errorlevel 1 (
        echo [ERROR] Failed to add GitHub origin.
        pause
        exit /b 1
    )
    echo       origin = %GITHUB_REPO_URL%
) else (
    if /i not "!CURRENT_ORIGIN!"=="%GITHUB_REPO_URL%" (
        echo       Current origin: !CURRENT_ORIGIN!
        echo       GitHub origin:  %GITHUB_REPO_URL%
        set /p "SET_ORIGIN=Set origin to the GitHub repository above? Type yes to continue: "
        if /i "!SET_ORIGIN!"=="yes" (
            git remote set-url origin "%GITHUB_REPO_URL%"
            if errorlevel 1 (
                echo [ERROR] Failed to update origin.
                pause
                exit /b 1
            )
            echo       origin = %GITHUB_REPO_URL%
        ) else (
            echo [INFO] GitHub origin is required. Cancelled.
            pause
            exit /b 1
        )
    ) else (
        echo       origin = %GITHUB_REPO_URL%
    )
)
echo.

echo [3/5] Current changes:
echo ----------------------------------------
git status --short
echo ----------------------------------------
echo.

set /p "ADD_FILES=Press Enter to add all files, or type specific paths: "
if "!ADD_FILES!"=="" (
    git add .
) else (
    git add !ADD_FILES!
)
if errorlevel 1 (
    echo [ERROR] git add failed. Please check the paths above.
    pause
    exit /b 1
)

git diff --cached --quiet
if not errorlevel 1 (
    echo [INFO] No staged changes. Skipping commit.
    goto PushStep
)

echo.
set /p "COMMIT_MSG=Commit message (Enter for '%DEFAULT_COMMIT_MSG%'): "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=%DEFAULT_COMMIT_MSG%"

echo [4/5] Creating commit...
git commit -m "!COMMIT_MSG!"
if errorlevel 1 (
    echo [ERROR] Commit failed.
    pause
    exit /b 1
)
echo.

:PushStep
echo [5/5] Pushing to GitHub...
set "CURRENT_BRANCH="
for /f "delims=" %%b in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%b"
if "!CURRENT_BRANCH!"=="" set "CURRENT_BRANCH=%DEFAULT_BRANCH%"

set /p "TARGET_BRANCH=Target branch (Enter for '!CURRENT_BRANCH!'): "
if "!TARGET_BRANCH!"=="" set "TARGET_BRANCH=!CURRENT_BRANCH!"

git push -u origin "HEAD:!TARGET_BRANCH!"
if not errorlevel 1 goto PushDone

echo.
echo [WARN] Normal push failed.
echo If the GitHub repository is empty or must be aligned with this local branch,
echo you can use --force-with-lease.
set /p "FORCE_PUSH=Type force to run git push --force-with-lease, or press Enter to stop: "
if /i not "!FORCE_PUSH!"=="force" (
    echo [INFO] Push stopped.
    pause
    exit /b 1
)

git push --force-with-lease -u origin "HEAD:!TARGET_BRANCH!"
if errorlevel 1 (
    echo [ERROR] Force-with-lease push failed.
    pause
    exit /b 1
)

:PushDone
echo.
echo ========================================
echo   Done
echo ========================================
echo   Repository: %GITHUB_REPO_URL%
echo   Branch:     !TARGET_BRANCH!
echo   User:       %GIT_NAME% ^<%GIT_EMAIL%^>
echo ========================================
pause
exit /b 0
