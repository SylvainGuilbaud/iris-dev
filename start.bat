@echo off
REM start.bat
REM This script initializes the IRIS environment and starts the IRIS service on Windows CMD.

REM Generate random API client credentials (simple random using %RANDOM%)
setlocal enabledelayedexpansion

set "API_CLIENT_ID="
for /l %%i in (1,1,16) do (
    set /a "idx=!random! %% 62"
    for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9) do (
        set /a "count+=1"
        if !count! equ !idx! (
            set "API_CLIENT_ID=!API_CLIENT_ID!%%A"
        )
    )
    set "count=0"
)
set "API_CLIENT_SECRET="
for /l %%i in (1,1,128) do (
    set /a "idx=!random! %% 62"
    for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9) do (
        set /a "count+=1"
        if !count! equ !idx! (
            set "API_CLIENT_SECRET=!API_CLIENT_SECRET!%%A"
        )
    )
    set "count=0"
)
set "API_CLIENT_ID=%API_CLIENT_ID%"
set "API_CLIENT_SECRET=%API_CLIENT_SECRET%"

REM Set the container name from the .env file or use a default value
set "CONTAINER_NAME="
if exist ".env" (
    for /f "tokens=2 delims==" %%A in ('findstr /b /c:"CONTAINER_NAME=" ".env"') do (
        set "CONTAINER_NAME=%%A"
    )
) else (
    echo .env file not found. Using default container name.
    set "CONTAINER_NAME=IRIS-dev-test"
)
echo CONTAINER_NAME is set to '%CONTAINER_NAME%'.

if "%CONTAINER_NAME%"=="" (
    echo No container name provided. Using default name from .env settings.
    if exist ".env" (
        for /f "tokens=2 delims==" %%A in ('findstr /b /c:"CONTAINER_NAME=" ".env"') do (
            set "CONTAINER_NAME=%%A"
        )
    )
    if "%CONTAINER_NAME%"=="" (
        set "CONTAINER_NAME=IRIS-dev-test"
    )
)

REM Check if the container is running
for /f "delims=" %%C in ('docker ps --filter "name=%CONTAINER_NAME%" --filter "status=running" ^| findstr /i "%CONTAINER_NAME%"') do (
    set "containerRunning=%%C"
)
if not defined containerRunning (
    echo Container '%CONTAINER_NAME%' is not running. Starting the container...
    docker compose up -d
    if errorlevel 1 (
        echo Failed to start the container. Please check the Docker logs for more details.
        exit /b 1
    ) else (
        echo Container '%CONTAINER_NAME%' started successfully.
    )
) else (
    echo Container '%CONTAINER_NAME%' is already running.
)
endlocal
