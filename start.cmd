@echo off
REM start.cmd
REM This script initializes the IRIS environment and starts the IRIS service on Windows CMD.

REM Generate random API client credentials (simple random using certutil)
FOR /F "delims=" %%A IN ('certutil -encodehex -f -length 16 nul 2^>nul ^| findstr /R "[0-9A-F][0-9A-F]"') DO (
    SET "API_CLIENT_ID=%%A"
    GOTO :break1
)
:break1
FOR /F "delims=" %%A IN ('certutil -encodehex -f -length 64 nul 2^>nul ^| findstr /R "[0-9A-F][0-9A-F]"') DO (
    SET "API_CLIENT_SECRET=%%A"
    GOTO :break2
)
:break2
SET "API_CLIENT_ID=%API_CLIENT_ID%"
SET "API_CLIENT_SECRET=%API_CLIENT_SECRET%"
SET API_CLIENT_ID=%API_CLIENT_ID%
SET API_CLIENT_SECRET=%API_CLIENT_SECRET%

REM Set the container name from the .env file or use a default value
SET "CONTAINER_NAME="
IF EXIST ".env" (
    FOR /F "tokens=2 delims==" %%A IN ('findstr /B /C:"CONTAINER_NAME=" .env') DO (
        SET "CONTAINER_NAME=%%A"
    )
) ELSE (
    ECHO .env file not found. Using default container name.
    SET "CONTAINER_NAME=IRIS-dev-test"
)
IF NOT DEFINED CONTAINER_NAME (
    ECHO No container name provided. Using default name from .env settings.
    IF EXIST ".env" (
        FOR /F "tokens=2 delims==" %%A IN ('findstr /B /C:"CONTAINER_NAME=" .env') DO (
            SET "CONTAINER_NAME=%%A"
        )
    )
    IF NOT DEFINED CONTAINER_NAME (
        SET "CONTAINER_NAME=IRIS-dev-test"
    )
)
ECHO CONTAINER_NAME is set to '%CONTAINER_NAME%'.

REM Check if the container is running
FOR /F "delims=" %%A IN ('docker ps --filter "name=%CONTAINER_NAME%" --filter "status=running" ^| findstr /C:"%CONTAINER_NAME%"') DO (
    SET "containerRunning=%%A"
)
IF NOT DEFINED containerRunning (
    ECHO Container '%CONTAINER_NAME%' is not running. Starting the container...
    docker compose up -d
    IF %ERRORLEVEL% EQU 0 (
        ECHO Container '%CONTAINER_NAME%' started successfully.
    ) ELSE (
        ECHO Failed to start the container. Please check the Docker logs for more details.
        EXIT /B 1
    )
) ELSE (
    ECHO Container '%CONTAINER_NAME%' is already running.
)