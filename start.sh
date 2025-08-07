#!/bin/bash
# start.sh
# This script initializes the IRIS environment and starts the IRIS service.
# remove .DS_Store files and iris.lck files
./cleanDS_Store.sh
# Define API client credentials
# These credentials are used for API authentication and should be kept secret.
# They can be generated using OpenSSL or any other secure method.
# The following lines generate random credentials for the API client.
# Uncomment the lines below to generate new credentials.
# Note: These credentials should be stored securely and not hard-coded in the source code.
# You can use environment variables or a secure vault to manage these secrets.
export API_CLIENT_ID=$(openssl rand -hex 8)
export API_CLIENT_SECRET=$(openssl rand -hex 64)
# Set the container name from the .env file or use a default value
# This script checks if the container name is provided as an argument.
# If not, it will read the default container name from the .env file.
# If the .env file does not exist or does not contain CONTAINER_NAME, it will use a default value.
# The container name is used to identify the Docker container running the IRIS service.
# Ensure that the .env file is present in the current directory and contains the CONTAINER_NAME variable.
# If the .env file is not present, the script will use a default container name.
if [ -f .env ]; then
    # Source the .env file to load environment variables
    source .env
else
    echo ".env file not found. Using default container name."
    # Default container name
    CONTAINER_NAME="IRIS-dev-test"
fi
echo "CONTAINER_NAME is set to '$CONTAINER_NAME'."
# check if the CONTAINER_NAME is running, if not, start it
if [ -z "$CONTAINER_NAME" ]; then
    echo "No container name provided. Using default name from .env settings."
    # Default container name
    # You can change this to your actual default container name
    # If you have a .env file, you can source it to get the default container name
    CONTAINER_NAME=$(grep -o '(?<=^CONTAINER_NAME=).*' .env | head -n 1)
    # If the .env file does not exist or does not contain CONTAINER_NAME, use a default value
    if [ -z "$CONTAINER_NAME" ]; then
        CONTAINER_NAME="IRIS-dev-test"
    fi
fi
# Check if the container is running
if ! docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' is not running. Starting the container..."
    docker compose up -d || {
        echo "Failed to start the container. Please check the Docker logs for more details."
        exit 1
    }
    echo "Container '$CONTAINER_NAME' started successfully."
else
    echo "Container '$CONTAINER_NAME' is already running."
fi