@echo off
REM Define API client credentials
REM These credentials are used for API authentication and should be kept secret.
REM They can be generated using OpenSSL or any other secure method.
REM The following lines generate random credentials for the API client.
REM Uncomment the lines below to generate new credentials.
REM Note: These credentials should be stored securely and not hard-coded in the source code.
REM You can use environment variables or a secure vault to manage these secrets.
FOR /F "delims=" %%i IN ('openssl rand -hex 8') DO set "API_CLIENT_ID=%%i"
FOR /F "delims=" %%i IN ('openssl rand -hex 64') DO set "API_CLIENT_SECRET=%%i"
docker compose -f docker-compose.yml up -d