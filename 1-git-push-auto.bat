@echo off
setlocal enabledelayedexpansion
REM ===== 强制设置 UTF-8 编码 =====
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
set LANG=zh_CN.UTF-8
cd /d "%~dp0"
title Git Push - 万能推送脚本
for %%d in ("%cd%") do set "CURRENT_FOLDER_NAME=%%~nxd"

REM ========================================
REM   默认配置区（可根据需要修改）
REM ========================================
set "DEFAULT_GITHUB_OWNER=LPK3215"
set "DEFAULT_REPO_OVERRIDE="
if "%DEFAULT_REPO_OVERRIDE%"=="" (
    set "DEFAULT_REPO=https://github.com/%DEFAULT_GITHUB_OWNER%/%CURRENT_FOLDER_NAME%.git"
) else (
    set "DEFAULT_REPO=%DEFAULT_REPO_OVERRIDE%"
)
set "DEFAULT_EMAIL=17538703215@163.com"
set "DEFAULT_NAME=LPK3215"
set "DEFAULT_BRANCH=main"
set "DEFAULT_COMMIT_MSG=update"
set "PROXY_ADDR=127.0.0.1:7897"
set "GITHUB_NEW_REPO=https://github.com/new"
set "GITEE_NEW_REPO=https://gitee.com/projects/new"
set "GITLAB_NEW_REPO=https://gitlab.com/projects/new"
set "BITBUCKET_NEW_REPO=https://bitbucket.org/repo/create"
set "CODING_NEW_REPO=https://coding.net/user/projects/create"
set "CNB_NEW_REPO=https://cnb.cool/new/repos"
set "CODEBERG_NEW_REPO=https://codeberg.org/repo/create"
set "JIHULAB_NEW_REPO=https://jihulab.com/projects/new"
set "GITCODE_NEW_REPO=https://gitcode.com/projects/new"
set "CODEUP_NEW_REPO=https://codeup.aliyun.com"
REM ========================================

set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
set "HAS_NEW_COMMIT=0"
set "REMOTE_COUNT=0"
set "CURRENT_BRANCH="

echo ========================================
echo   Git 万能推送脚本
echo ========================================
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到 Git，请先安装 Git for Windows
    pause
    exit /b 1
)

REM ========================================
REM   显示当前绑定的所有远程仓库
REM ========================================
call :EnsureDefaultRemote
call :LoadRemotes
call :ShowRepoInfo

REM ========================================
REM   第一步：配置网络代理和Git设置
REM ========================================
echo [1/6] 配置网络代理...
if not exist ".git" goto ProxyNoRepo
git config --local http.proxy http://%PROXY_ADDR% 2>nul
git config --local https.proxy http://%PROXY_ADDR% 2>nul
goto ProxyDone

:ProxyNoRepo
echo 当前目录尚未初始化Git，本地代理将在初始化后写入

:ProxyDone
git config --global core.quotepath false
echo 已设置代理: %PROXY_ADDR%
echo.

REM ========================================
REM   第二步：检查/初始化 Git 仓库
REM ========================================
echo [2/6] 检查Git仓库...
if exist ".git" goto RepoExists

echo [提示] 当前目录不是Git仓库
set /p "DO_INIT=是否要初始化为Git仓库？（输入 yes 或直接回车取消）: "
if /i "!DO_INIT!"=="yes" goto InitRepo
echo 已取消操作
pause
exit /b

:InitRepo
echo 正在初始化Git仓库...
git init -b %DEFAULT_BRANCH%
if errorlevel 1 (
    REM 旧版本 Git 不支持 -b 参数，使用传统方式
    git init
    git checkout -b %DEFAULT_BRANCH% 2>nul
)
git config --local http.proxy http://%PROXY_ADDR% 2>nul
git config --local https.proxy http://%PROXY_ADDR% 2>nul
echo 初始化完成
echo.
goto RepoReady

:RepoExists
echo Git仓库已存在
echo.

:RepoReady
call :EnsureDefaultRemote

REM ========================================
REM   第三步：配置远程仓库地址
REM ========================================
echo [3/6] 检查远程仓库...
call :LoadRemotes
if !REMOTE_COUNT! equ 0 goto RemoteNone
if !REMOTE_COUNT! equ 1 goto RemoteSingle
goto RemoteMany

:RemoteNone
echo [提示] 未检测到任何远程仓库
echo.
echo 如果还没有创建远程仓库，请先去创建：
echo   [1] GitHub:    %GITHUB_NEW_REPO%
echo   [2] Gitee:     %GITEE_NEW_REPO%
echo   [3] GitLab:    %GITLAB_NEW_REPO%
echo   [4] Bitbucket: %BITBUCKET_NEW_REPO%
echo   [5] Coding:    %CODING_NEW_REPO%
echo   [6] CNB:       %CNB_NEW_REPO%
echo   [7] Codeberg:  %CODEBERG_NEW_REPO%
echo   [8] JihuLab:   %JIHULAB_NEW_REPO%
echo   [9] GitCode:   %GITCODE_NEW_REPO%
echo  [10] Codeup:    %CODEUP_NEW_REPO%
echo.
echo 创建完成后，复制仓库地址粘贴到下方
echo 默认地址: %DEFAULT_REPO%
echo.
set /p "INPUT_REPO=请输入远程仓库地址（直接回车使用默认，或输入 add:地址 自动命名）: "
if /i "!INPUT_REPO:~0,4!"=="add:" goto RemoteNoneAdd
if "!INPUT_REPO!"=="" set "INPUT_REPO=%DEFAULT_REPO%"
if "!INPUT_REPO!"=="" goto RemoteMissingUrl

set "FINAL_REPO=!INPUT_REPO!"
git remote add origin "!FINAL_REPO!" 2>nul
if errorlevel 1 (
    echo [警告] 添加远程仓库失败，可能已存在，尝试更新...
    git remote set-url origin "!FINAL_REPO!"
)
echo 已设置远程仓库: origin = !FINAL_REPO!
set "PUSH_MODE=ALL"
goto RemoteDone

:RemoteNoneAdd
call :AddRemoteFromInput
goto RemoteDone

:RemoteMissingUrl
echo [错误] 没有可用的远程仓库地址，已取消操作
pause
exit /b

:RemoteSingle
set "CURRENT_REMOTE_NAME=!REMOTE_1_NAME!"
set "CURRENT_REMOTE_URL=!REMOTE_1_URL!"
echo [当前远程仓库] !CURRENT_REMOTE_NAME! = !CURRENT_REMOTE_URL!
echo.
set /p "INPUT_REPO=输入新仓库地址: 回车默认使用当前仓库 "
if "!INPUT_REPO!"=="" goto RemoteSingleDefault
if /i "!INPUT_REPO:~0,4!"=="add:" goto RemoteSingleAdd

git remote set-url "!CURRENT_REMOTE_NAME!" "!INPUT_REPO!"
if errorlevel 1 (
    echo [错误] 更新远程仓库失败: !CURRENT_REMOTE_NAME!
) else (
    echo [成功] 已更新 !CURRENT_REMOTE_NAME! = !INPUT_REPO!
)
set "PUSH_MODE=ALL"
goto RemoteDone

:RemoteSingleDefault
set "PUSH_MODE=ALL"
goto RemoteDone

:RemoteSingleAdd
call :AddRemoteFromInput
goto RemoteDone

:RemoteMany
echo [提示] 检测到多个远程仓库
echo.
echo   [0] 全部远程仓库（默认）
call :ListRemoteChoices
echo.
set /p "REMOTE_CHOICE=直接回车推送全部，输入编号只推一个，或粘贴新仓库地址追加: "
if "!REMOTE_CHOICE!"=="" goto RemoteManyAll
if /i "!REMOTE_CHOICE:~0,4!"=="add:" goto RemoteManyAdd
if "!REMOTE_CHOICE!"=="0" goto RemoteManyAll
if /i "!REMOTE_CHOICE:~0,8!"=="https://" goto RemoteManyAddUrl
if /i "!REMOTE_CHOICE:~0,7!"=="http://" goto RemoteManyAddUrl
if /i "!REMOTE_CHOICE:~0,4!"=="git@" goto RemoteManyAddUrl

echo(!REMOTE_CHOICE!| findstr /r "^[0-9][0-9]*$" >nul 2>&1
if errorlevel 1 goto RemoteManyInvalid
set /a CHOICE_IDX=!REMOTE_CHOICE!
if !CHOICE_IDX! lss 1 goto RemoteManyInvalid
if !CHOICE_IDX! gtr !REMOTE_COUNT! goto RemoteManyInvalid

call :SelectRemoteByIndex !CHOICE_IDX!
echo [选择] 本次只推送到: !PUSH_REMOTE!
goto RemoteDone

:RemoteManyAll
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
echo [选择] 本次将推送到全部远程仓库
goto RemoteDone

:RemoteManyAdd
set "INPUT_REPO=!REMOTE_CHOICE!"
call :AddRemoteFromInput
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
goto RemoteDone

:RemoteManyAddUrl
set "INPUT_REPO=add:!REMOTE_CHOICE!"
call :AddRemoteFromInput
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
goto RemoteDone

:RemoteManyInvalid
echo [警告] 输入无效，本次默认推送到全部远程仓库
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
goto RemoteDone

:RemoteDone
call :LoadRemotes
echo.

REM ========================================
REM   第四步：检查用户身份配置
REM ========================================
echo [4/6] 检查用户身份...
set "GIT_EMAIL="
set "GIT_NAME="
for /f "delims=" %%i in ('git config --global user.email 2^>nul') do set "GIT_EMAIL=%%i"
for /f "delims=" %%i in ('git config --global user.name 2^>nul') do set "GIT_NAME=%%i"

if "!GIT_EMAIL!"=="" (
    echo [提示] 检测到未配置Git用户邮箱
    echo 默认邮箱: %DEFAULT_EMAIL%
    set /p "INPUT_EMAIL=请输入邮箱（直接回车使用默认）: "
    if "!INPUT_EMAIL!"=="" (
        set "GIT_EMAIL=%DEFAULT_EMAIL%"
    ) else (
        set "GIT_EMAIL=!INPUT_EMAIL!"
    )
    git config --global user.email "!GIT_EMAIL!"
    echo 已设置邮箱: !GIT_EMAIL!
) else (
    echo 当前邮箱: !GIT_EMAIL!
)

if "!GIT_NAME!"=="" (
    echo [提示] 检测到未配置Git用户名
    echo 默认用户名: %DEFAULT_NAME%
    set /p "INPUT_NAME=请输入用户名（直接回车使用默认）: "
    if "!INPUT_NAME!"=="" (
        set "GIT_NAME=%DEFAULT_NAME%"
    ) else (
        set "GIT_NAME=!INPUT_NAME!"
    )
    git config --global user.name "!GIT_NAME!"
    echo 已设置用户名: !GIT_NAME!
) else (
    echo 当前用户名: !GIT_NAME!
)
echo.

REM ========================================
REM   第五步：检查 .gitignore 变化并清理
REM ========================================
echo [5/6] 检查 .gitignore 变化...
echo.

git status --porcelain -- .gitignore 2>nul | findstr /i "gitignore" >nul 2>&1
if errorlevel 1 goto GitignoreUnchanged

echo [检测到] .gitignore 文件有改动
echo.
echo 是否要从远程仓库中删除新添加到 .gitignore 的文件？
echo （这会删除远程仓库中的文件，但保留本地文件）
echo.
set /p "CLEAN_IGNORED=输入 yes 清理远程仓库，直接回车跳过: "
if /i "!CLEAN_IGNORED!"=="yes" goto CleanIgnoredFiles
echo 已跳过清理步骤
echo.
goto GitignoreDone

:CleanIgnoredFiles
echo.
echo 正在分析 .gitignore 中新增的规则...
echo.
for /f "delims=" %%f in ('git ls-files -i --exclude-standard 2^>nul') do call :RemoveIgnoredFromIndex "%%f"
echo.
echo [完成] 已从 Git 追踪中移除这些文件
echo [提示] 本地文件仍然保留，只是不会再推送到远程
echo.
goto GitignoreDone

:GitignoreUnchanged
echo .gitignore 无改动，跳过清理检查
echo.

:GitignoreDone

REM ========================================
REM   第六步：添加、提交、推送
REM ========================================
echo [6/6] 准备推送...
echo.
echo ----------------------------------------
echo   当前改动的文件:
echo ----------------------------------------
git status --short
echo ----------------------------------------
echo.

set /p "ADD_FILES=直接回车添加所有文件，或输入指定文件路径（多个用空格分开）: "
if "!ADD_FILES!"=="" (
    echo 正在添加所有文件...
    git add .
) else (
    echo 正在添加指定文件...
    git add !ADD_FILES!
)
if errorlevel 1 echo [警告] git add 可能失败，请检查上面的错误信息

git diff --cached --quiet
if errorlevel 1 goto CommitChanges

echo.
echo [提示] 暂存区没有改动，跳过提交步骤
echo.
goto AfterCommit

:CommitChanges
echo.
set /p "COMMIT_MSG=请输入提交信息（直接回车默认为 %DEFAULT_COMMIT_MSG%）: "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=%DEFAULT_COMMIT_MSG%"
echo 正在提交...
git commit -m "!COMMIT_MSG!"
if errorlevel 1 (
    echo [警告] 提交失败或被取消，将继续检查是否有旧提交需要推送
) else (
    set "HAS_NEW_COMMIT=1"
)
echo.

:AfterCommit
git rev-parse HEAD >nul 2>&1
if errorlevel 1 goto NothingToPush
if !REMOTE_COUNT! equ 0 goto NoRemoteToPush

set "CURRENT_BRANCH="
for /f "delims=" %%i in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%i"
if "!CURRENT_BRANCH!"=="" set "CURRENT_BRANCH=%DEFAULT_BRANCH%"
set /p "TARGET_BRANCH=推送到哪个远程分支？（直接回车默认为 !CURRENT_BRANCH!）: "
if "!TARGET_BRANCH!"=="" set "TARGET_BRANCH=!CURRENT_BRANCH!"

set "PUSH_SUCCESS=0"
set "PUSH_FAILED=0"
if /i "!PUSH_MODE!"=="SINGLE" goto PushSingleSelected
goto PushAllSelected

:PushSingleSelected
if "!PUSH_REMOTE!"=="" goto PushAllSelected
call :PushOneRemote "!PUSH_REMOTE!"
goto PushSummary

:PushAllSelected
echo.
set /a PUSH_INDEX=1

:PushAllLoop
if !PUSH_INDEX! gtr !REMOTE_COUNT! goto PushSummary
call :PushRemoteByIndex !PUSH_INDEX!
set /a PUSH_INDEX+=1
goto PushAllLoop

goto PushSummary

:PushSummary
echo.
echo ========================================
if !PUSH_FAILED! gtr 0 goto PushSummaryFailed
echo   [完成] 推送成功
goto PushSummaryTitleDone

:PushSummaryFailed
echo   [完成] 推送已结束，存在失败项

:PushSummaryTitleDone
echo ========================================
echo   本地目录: %cd%
if /i "!PUSH_MODE!"=="SINGLE" goto PushSummarySingleRemote
echo   远程仓库: 全部 !REMOTE_COUNT! 个
goto PushSummaryRemoteDone

:PushSummarySingleRemote
echo   远程仓库: !PUSH_REMOTE!

:PushSummaryRemoteDone
echo   推送分支: !TARGET_BRANCH!
if not "!HAS_NEW_COMMIT!"=="1" goto PushSummaryCommitDone
echo   提交信息: !COMMIT_MSG!

:PushSummaryCommitDone
echo   用户: !GIT_NAME! ^<!GIT_EMAIL!^>
if !PUSH_FAILED! leq 0 goto PushSummaryFailureDone
echo   失败数量: !PUSH_FAILED!

:PushSummaryFailureDone
echo ========================================
goto EndScript

:NoRemoteToPush
echo.
echo ========================================
echo   [提示] 当前没有远程仓库，无法推送
echo ========================================
goto EndScript

:NothingToPush
echo.
echo ========================================
echo   [提示] 当前仓库还没有任何提交，无法推送
echo ========================================

:EndScript
call :RefreshDefaultGitSettings
echo.
pause
exit /b

REM ========================================
REM   工具函数
REM ========================================

:RefreshDefaultGitSettings
if not exist ".git" exit /b 0
call :EnsureDefaultRemote
set "FINAL_BRANCH="
for /f "delims=" %%b in ('git branch --show-current 2^>nul') do set "FINAL_BRANCH=%%b"
if "!FINAL_BRANCH!"=="" exit /b 0
set "FINAL_UPSTREAM_BRANCH=!TARGET_BRANCH!"
if "!FINAL_UPSTREAM_BRANCH!"=="" set "FINAL_UPSTREAM_BRANCH=!FINAL_BRANCH!"
if "!FINAL_UPSTREAM_BRANCH!"=="" set "FINAL_UPSTREAM_BRANCH=%DEFAULT_BRANCH%"
git config "branch.!FINAL_BRANCH!.remote" origin
git config "branch.!FINAL_BRANCH!.merge" refs/heads/!FINAL_UPSTREAM_BRANCH!
echo [默认] 当前分支默认上游已恢复为 origin/!FINAL_UPSTREAM_BRANCH!
exit /b 0

:EnsureDefaultRemote
if not exist ".git" exit /b 0
if "%DEFAULT_REPO%"=="" exit /b 0
set "DEFAULT_ORIGIN_URL="
for /f "delims=" %%u in ('git config --get remote.origin.url 2^>nul') do set "DEFAULT_ORIGIN_URL=%%u"
if "!DEFAULT_ORIGIN_URL!"=="" goto EnsureDefaultAddOrigin
if /i "!DEFAULT_ORIGIN_URL!"=="%DEFAULT_REPO%" exit /b 0
goto EnsureDefaultRestoreOrigin

:EnsureDefaultAddOrigin
git remote add origin "%DEFAULT_REPO%" 2>nul
if errorlevel 1 exit /b 0
echo [默认] 已设置 origin = %DEFAULT_REPO%
exit /b 0

:EnsureDefaultRestoreOrigin
call :PreserveRemoteUrl "!DEFAULT_ORIGIN_URL!"
git remote set-url origin "%DEFAULT_REPO%"
if errorlevel 1 goto EnsureDefaultRestoreFailed
echo [默认] origin 已恢复为 GitHub: %DEFAULT_REPO%
exit /b 0

:EnsureDefaultRestoreFailed
echo [警告] 无法把 origin 恢复为默认 GitHub 仓库
exit /b 0

:PreserveRemoteUrl
set "URL_TO_PRESERVE=%~1"
if "!URL_TO_PRESERVE!"=="" exit /b 0
if /i "!URL_TO_PRESERVE!"=="%DEFAULT_REPO%" exit /b 0
set "PRESERVED_REMOTE_NAME="
for /f "delims=" %%r in ('git remote 2^>nul') do call :CheckRemoteUrlForPreserve "%%r"
if not "!PRESERVED_REMOTE_NAME!"=="" exit /b 0
set "NEW_REMOTE_URL=!URL_TO_PRESERVE!"
set "NEW_REMOTE_NAME="
call :GuessRemoteName
if "!NEW_REMOTE_NAME!"=="" set "NEW_REMOTE_NAME=backup"
call :MakeRemoteNameFree
git remote add "!NEW_REMOTE_NAME!" "!URL_TO_PRESERVE!" 2>nul
if errorlevel 1 exit /b 0
echo [默认] 已保留原 origin 为 !NEW_REMOTE_NAME! = !URL_TO_PRESERVE!
exit /b 0

:CheckRemoteUrlForPreserve
set "CHECK_REMOTE_NAME=%~1"
if /i "!CHECK_REMOTE_NAME!"=="origin" exit /b 0
set "CHECK_REMOTE_URL="
for /f "delims=" %%u in ('git config --get "remote.!CHECK_REMOTE_NAME!.url" 2^>nul') do set "CHECK_REMOTE_URL=%%u"
if /i "!CHECK_REMOTE_URL!"=="!URL_TO_PRESERVE!" set "PRESERVED_REMOTE_NAME=!CHECK_REMOTE_NAME!"
exit /b 0

:LoadRemotes
set "REMOTE_COUNT=0"
set "REMOTE_NAMES="
set "CURRENT_BRANCH="
if not exist ".git" exit /b 0
for /f "delims=" %%r in ('git remote 2^>nul') do call :RememberRemote "%%r"
for /f "delims=" %%b in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%b"
exit /b 0

:RememberRemote
set /a REMOTE_COUNT+=1
set "ONE_REMOTE_NAME=%~1"
set "ONE_REMOTE_URL="
for /f "delims=" %%u in ('git config --get "remote.!ONE_REMOTE_NAME!.url" 2^>nul') do set "ONE_REMOTE_URL=%%u"
set "REMOTE_!REMOTE_COUNT!_NAME=!ONE_REMOTE_NAME!"
set "REMOTE_!REMOTE_COUNT!_URL=!ONE_REMOTE_URL!"
set "REMOTE_NAMES=!REMOTE_NAMES! !ONE_REMOTE_NAME!"
exit /b 0

:ShowRepoInfo
echo [仓库信息]
if exist ".git" goto ShowRepoGit
echo   当前远程仓库: 未初始化Git
echo   默认远程仓库: %DEFAULT_REPO%
echo   默认分支: %DEFAULT_BRANCH% (GitHub新仓库默认为main)
echo ========================================
echo.
exit /b 0

:ShowRepoGit
echo   已绑定的远程仓库:
if !REMOTE_COUNT! equ 0 goto ShowNoRemotes
call :ListRemoteChoices
goto ShowRepoBranch

:ShowNoRemotes
echo     (无)

:ShowRepoBranch
if not "!CURRENT_BRANCH!"=="" echo   当前分支: !CURRENT_BRANCH!
echo   默认远程仓库: %DEFAULT_REPO%
echo   默认分支: %DEFAULT_BRANCH% (GitHub新仓库默认为main)
echo ========================================
echo.
exit /b 0

:ListRemoteChoices
if !REMOTE_COUNT! equ 0 exit /b 0
for /l %%i in (1,1,!REMOTE_COUNT!) do call :EchoRemoteByIndex %%i
exit /b 0

:EchoRemoteByIndex
set "IDX=%~1"
set "LINE_REMOTE_NAME=!REMOTE_%IDX%_NAME!"
set "LINE_REMOTE_URL=!REMOTE_%IDX%_URL!"
echo     [%IDX%] !LINE_REMOTE_NAME! = !LINE_REMOTE_URL!
exit /b 0

:SelectRemoteByIndex
set "IDX=%~1"
set "PUSH_MODE=SINGLE"
set "PUSH_REMOTE=!REMOTE_%IDX%_NAME!"
exit /b 0

:FindRemoteByUrl
set "FIND_REMOTE_URL=%~1"
set "FOUND_REMOTE_NAME="
if "!FIND_REMOTE_URL!"=="" exit /b 0
for /f "delims=" %%r in ('git remote 2^>nul') do call :CheckRemoteUrlMatch "%%r"
exit /b 0

:CheckRemoteUrlMatch
set "CHECK_REMOTE_NAME=%~1"
set "CHECK_REMOTE_URL="
for /f "delims=" %%u in ('git config --get "remote.!CHECK_REMOTE_NAME!.url" 2^>nul') do set "CHECK_REMOTE_URL=%%u"
if /i "!CHECK_REMOTE_URL!"=="!FIND_REMOTE_URL!" set "FOUND_REMOTE_NAME=!CHECK_REMOTE_NAME!"
exit /b 0

:AddRemoteFromInput
set "NEW_REMOTE_URL=!INPUT_REPO:~4!"
if "!NEW_REMOTE_URL!"=="" (
    echo [错误] add: 后面没有远程仓库地址
    exit /b 1
)
call :FindRemoteByUrl "!NEW_REMOTE_URL!"
if not "!FOUND_REMOTE_NAME!"=="" goto AddRemoteAlreadyExists
set "NEW_REMOTE_NAME="
call :GuessRemoteName
if "!NEW_REMOTE_NAME!"=="" (
    call :PromptRemoteName
    if errorlevel 1 exit /b 1
) else (
    call :MakeRemoteNameFree
)
git remote add "!NEW_REMOTE_NAME!" "!NEW_REMOTE_URL!" 2>nul
if errorlevel 1 (
    echo [错误] 添加失败，请检查名称或地址: !NEW_REMOTE_NAME!
    exit /b 1
)
echo [成功] 已添加远程仓库: !NEW_REMOTE_NAME! = !NEW_REMOTE_URL!
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
call :LoadRemotes
exit /b 0

:AddRemoteAlreadyExists
echo [提示] 该远程地址已存在: !FOUND_REMOTE_NAME! = !NEW_REMOTE_URL!
set "PUSH_MODE=ALL"
set "PUSH_REMOTE="
call :LoadRemotes
exit /b 0

:GuessRemoteName
set "URL_CHECK=!NEW_REMOTE_URL!"
if not "!URL_CHECK:gitee.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=gitee"
if not "!URL_CHECK:gitlab.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=gitlab"
if not "!URL_CHECK:bitbucket.org=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=bitbucket"
if not "!URL_CHECK:coding.net=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=coding"
if not "!URL_CHECK:cnb.cool=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=cnb"
if not "!URL_CHECK:codeberg.org=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=codeberg"
if not "!URL_CHECK:jihulab.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=jihulab"
if not "!URL_CHECK:gitcode.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=gitcode"
if not "!URL_CHECK:codeup.aliyun.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=codeup"
if not "!URL_CHECK:github.com=!"=="!URL_CHECK!" set "NEW_REMOTE_NAME=github"
exit /b 0

:PromptRemoteName
set /p "NEW_REMOTE_NAME=无法自动识别平台，请输入远程仓库名称（如 gitee）: "
if "!NEW_REMOTE_NAME!"=="" (
    echo [错误] 远程仓库名称不能为空
    exit /b 1
)
call :RemoteNameExists "!NEW_REMOTE_NAME!"
if "!REMOTE_NAME_EXISTS!"=="0" exit /b 0
echo [警告] 名称 !NEW_REMOTE_NAME! 已存在，请换一个名称
goto PromptRemoteName

:MakeRemoteNameFree
set "BASE_REMOTE_NAME=!NEW_REMOTE_NAME!"
set "CANDIDATE_REMOTE_NAME=!BASE_REMOTE_NAME!"
set /a REMOTE_NAME_SUFFIX=2

:MakeRemoteNameFreeLoop
call :RemoteNameExists "!CANDIDATE_REMOTE_NAME!"
if "!REMOTE_NAME_EXISTS!"=="0" (
    set "NEW_REMOTE_NAME=!CANDIDATE_REMOTE_NAME!"
    exit /b 0
)
set "CANDIDATE_REMOTE_NAME=!BASE_REMOTE_NAME!!REMOTE_NAME_SUFFIX!"
set /a REMOTE_NAME_SUFFIX+=1
goto MakeRemoteNameFreeLoop

:RemoteNameExists
set "REMOTE_NAME_EXISTS=0"
git remote get-url "%~1" >nul 2>&1
if errorlevel 1 exit /b 0
set "REMOTE_NAME_EXISTS=1"
exit /b 0

:RemoveIgnoredFromIndex
echo   发现: %~1
git rm -r --cached "%~1" >nul 2>&1
exit /b 0

:PushRemoteByIndex
set "IDX=%~1"
set "ONE_PUSH_REMOTE=!REMOTE_%IDX%_NAME!"
call :PushOneRemote "!ONE_PUSH_REMOTE!"
exit /b 0

:PushOneRemote
set "ONE_PUSH_REMOTE=%~1"
echo.
echo ----------------------------------------
echo 正在推送到 !ONE_PUSH_REMOTE! / !TARGET_BRANCH! ...
git push "!ONE_PUSH_REMOTE!" "HEAD:!TARGET_BRANCH!"
if errorlevel 1 goto PushOneFailed
set /a PUSH_SUCCESS+=1
echo   [成功] 已推送到 !ONE_PUSH_REMOTE!
exit /b 0

:PushOneFailed
echo   [警告] 普通推送到 !ONE_PUSH_REMOTE! 失败
echo   如果这是新远程仓库且需要用本地 !TARGET_BRANCH! 覆盖远程 !TARGET_BRANCH!，可输入 force
set "FORCE_PUSH_CHOICE="
set /p "FORCE_PUSH_CHOICE=输入 force 执行安全强推，直接回车跳过: "
if /i "!FORCE_PUSH_CHOICE!"=="force" goto PushOneForce
set /a PUSH_FAILED+=1
echo   [失败] 推送到 !ONE_PUSH_REMOTE! 出错
exit /b 0

:PushOneForce
echo   正在使用 --force-with-lease 推送到 !ONE_PUSH_REMOTE! / !TARGET_BRANCH! ...
set "REMOTE_BRANCH_SHA="
for /f "tokens=1" %%s in ('git ls-remote "!ONE_PUSH_REMOTE!" "refs/heads/!TARGET_BRANCH!" 2^>nul') do set "REMOTE_BRANCH_SHA=%%s"
if "!REMOTE_BRANCH_SHA!"=="" goto PushOneForceNoRemoteSha
git push --force-with-lease=refs/heads/!TARGET_BRANCH!:!REMOTE_BRANCH_SHA! "!ONE_PUSH_REMOTE!" "HEAD:!TARGET_BRANCH!"

:PushOneForceCheck
if errorlevel 1 goto PushOneForceFailed
set /a PUSH_SUCCESS+=1
echo   [成功] 已强制同步到 !ONE_PUSH_REMOTE!
exit /b 0

:PushOneForceFailed
set /a PUSH_FAILED+=1
echo   [失败] 强制同步到 !ONE_PUSH_REMOTE! 仍然出错
exit /b 0

:PushOneForceNoRemoteSha
set /a PUSH_FAILED+=1
echo   [失败] 无法读取远程分支当前状态，已取消强推
exit /b 0
