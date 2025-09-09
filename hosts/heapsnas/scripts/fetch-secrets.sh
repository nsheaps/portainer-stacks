#!/bin/bash
set -e

echo "Starting 1Password secrets extraction..."

# Check if OP_SERVICE_ACCOUNT_TOKEN is set
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "ERROR: OP_SERVICE_ACCOUNT_TOKEN environment variable is not set"
    echo "Please set this in Portainer as a stack environment variable"
    exit 1
fi

# Create secrets directory if it doesn't exist
mkdir -p /var/run/secrets

# Example 1Password vault and item references
# Replace these with your actual 1Password references
# Format: op://vault-name/item-name/field-name

echo "Fetching PostgreSQL root credentials..."
op read "op://heapsinfra/heapsnas/postgres/root_user" > /var/run/secrets/postgres_root_user
op read "op://heapsinfra/heapsnas/postgres/root_password" > /var/run/secrets/postgres_root_password

echo "Fetching PostgreSQL database configuration..."
op read "op://heapsinfra/heapsnas/n8n/postgres_db" > /var/run/secrets/postgres_db
op read "op://heapsinfra/heapsnas/n8n/postgres_user" > /var/run/secrets/postgres_user
op read "op://heapsinfra/heapsnas/n8n/postgres_password" > /var/run/secrets/postgres_password

echo "Fetching n8n encryption key..."
op read "op://heapsinfra/heapsnas/n8n/n8n_encryption_key" > /var/run/secrets/n8n_encryption_key

# Set appropriate permissions
chmod 600 /var/run/secrets/*

echo "Secrets extraction completed successfully!"

# List extracted secrets (without showing content)
echo "Extracted secrets:"
ls -la /var/run/secrets/
