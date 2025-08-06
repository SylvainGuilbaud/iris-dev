# Define API client credentials
# These credentials are used for API authentication and should be kept secret.
# They can be generated using OpenSSL or any other secure method.
# The following lines generate random credentials for the API client.
# Uncomment the lines below to generate new credentials.
# Note: These credentials should be stored securely and not hard-coded in the source code.
# You can use environment variables or a secure vault to manage these secrets.
export API_CLIENT_ID=$(openssl rand -hex 16)
export API_CLIENT_SECRET=$(openssl rand -hex 32)
docker compose -f docker-compose.yml up -d 