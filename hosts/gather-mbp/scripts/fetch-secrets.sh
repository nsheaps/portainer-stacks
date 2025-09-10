#!/bin/bash
set -e

START_TIME=$(date +%s)

echo "Starting 1Password secrets extraction..."

# Check if OP_SERVICE_ACCOUNT_TOKEN is set
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "ERROR: OP_SERVICE_ACCOUNT_TOKEN environment variable is not set"
    echo "Please set this in Portainer as a stack environment variable"
    exit 1
fi

# Create secrets directory if it doesn't exist
mkdir -p /run/secrets

# for permissions debugging
echo "Running as $(whoami), group: $(id -g), uid: $(id -u)"
ls -lha /run/secrets/

# Example 1Password vault and item references
# Replace these with your actual 1Password references
# Format: op://vault-name/item-name/field-name
# item names cannot contain slashes when using this reference format

function fetch() {
    local ref="$1"
    local dest="$2"
    op read --no-newline "$ref" > "$dest"
    echo " got '$ref' => '$dest'"
}

echo "Fetching all secrets in parallel..."

# Start all op reads in the background
fetch "op://heapsinfra/portainer--gather-mbp--postgres--root-user/username" "/run/secrets/postgres_root_user" &
fetch "op://heapsinfra/portainer--gather-mbp--postgres--root-user/password" "/run/secrets/postgres_root_password" &
fetch "op://heapsinfra/portainer--gather-mbp--n8n--db/db" "/run/secrets/postgres_db" &
fetch "op://heapsinfra/portainer--gather-mbp--n8n--db/username" "/run/secrets/postgres_user" &
fetch "op://heapsinfra/portainer--gather-mbp--n8n--db/password" "/run/secrets/postgres_password" &
fetch "op://heapsinfra/portainer--gather-mbp--n8n/encryption_key" "/run/secrets/n8n_encryption_key" &

# Wait for all background jobs to complete
wait

echo "All secrets fetched successfully!"

# Set appropriate permissions so everyone that has access to this volume
# can read the secrets, but not write to them.
chmod 444 /run/secrets/*

echo "Secrets extraction completed successfully!"

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo "took: ${ELAPSED_TIME} seconds"

# List extracted secrets (without showing content)
echo "Extracted secrets:"
ls -lha /run/secrets/
