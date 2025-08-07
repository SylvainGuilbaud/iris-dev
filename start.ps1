# start.ps1
# This script initializes the IRIS environment and starts the IRIS service on Windows PowerShell.


# Generate random API client credentials
# $API_CLIENT_ID = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | % {[char]$_})
# $API_CLIENT_SECRET = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 128 | % {[char]$_})

$API_CLIENT_ID = & openssl rand -hex 8
$API_CLIENT_SECRET = & openssl rand -hex 64

$env:API_CLIENT_ID = $API_CLIENT_ID
$env:API_CLIENT_SECRET = $API_CLIENT_SECRET

# Set the container name from the .env file or use a default value
$CONTAINER_NAME = $null
if (Test-Path ".env") {
    $envContent = Get-Content ".env" | Where-Object { $_ -match "^CONTAINER_NAME=" }
    if ($envContent) {
        $CONTAINER_NAME = $envContent -replace "^CONTAINER_NAME=", ""
    }
} else {
    Write-Host ".env file not found. Using default container name."
    $CONTAINER_NAME = "IRIS-dev-test"
}
Write-Host "CONTAINER_NAME is set to '$CONTAINER_NAME'."

if (-not $CONTAINER_NAME) {
    Write-Host "No container name provided. Using default name from .env settings."
    if (Test-Path ".env") {
        $envContent = Get-Content ".env" | Where-Object { $_ -match "^CONTAINER_NAME=" }
        if ($envContent) {
            $CONTAINER_NAME = $envContent -replace "^CONTAINER_NAME=", ""
        }
    }
    if (-not $CONTAINER_NAME) {
        $CONTAINER_NAME = "IRIS-dev-test"
    }
}

# Check if the container is running
$containerRunning = docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | Select-String "$CONTAINER_NAME"
if (-not $containerRunning) {
    Write-Host "Container '$CONTAINER_NAME' is not running. Starting the container..."
    try {
        docker compose up -d
        Write-Host "Container '$CONTAINER_NAME' started successfully."
    } catch {
        Write-Host "Failed to start the container. Please check the Docker logs for more details."
        exit 1
    }
} else {
    Write-Host "Container '$CONTAINER_NAME' is already running."
}