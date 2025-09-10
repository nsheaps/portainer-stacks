#!/bin/bash
set -e

trap "sleep 5" exit

echo "Starting 1Password secrets extraction..."

# Check if OP_SERVICE_ACCOUNT_TOKEN is set
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "ERROR: OP_SERVICE_ACCOUNT_TOKEN environment variable is not set"
    echo "Please set this in Portainer as a stack environment variable"
    exit 1
fi

# Create secrets directory if it doesn't exist
mkdir -p /run/secrets

# Example 1Password vault and item references
# Replace these with your actual 1Password references
# Format: op://vault-name/item-name/field-name
echo "Running as $(whoami), group: $(id -g), uid: $(id -u)"
ls -lha /run/secrets/

echo "Fetching PostgreSQL root credentials..."
op read "op://heapsinfra/portainer--gather-mbp--postgres--root-user/username" > /run/secrets/postgres_root_user
op read "op://heapsinfra/portainer--gather-mbp--postgres--root-user/password" > /run/secrets/postgres_root_password

echo "Fetching PostgreSQL database configuration..."
op read "op://heapsinfra/portainer--gather-mbp--n8n--db/db" > /run/secrets/postgres_db
op read "op://heapsinfra/portainer--gather-mbp--n8n--db/username" > /run/secrets/postgres_user
op read "op://heapsinfra/portainer--gather-mbp--n8n--db/password" > /run/secrets/postgres_password

echo "Fetching n8n encryption key..."
op read "op://heapsinfra/portainer--gather-mbp--n8n/encryption_key" > /run/secrets/n8n_encryption_key

# Set appropriate permissions so everyone that has access to this volume
# can read the secrets, but not write to them.
chmod 444 /run/secrets/*

echo "Secrets extraction completed successfully!"

# List extracted secrets (without showing content)
echo "Extracted secrets:"
ls -lha /run/secrets/
