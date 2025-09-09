#!/bin/bash
set -e

# This script runs inside the postgres container during initialization
# It creates the non-root user for n8n using secrets mounted in the container

echo "Creating n8n database user..."

# Read the secrets
N8N_USER=$(cat /run/secrets/postgres_user)
N8N_PASSWORD=$(cat /run/secrets/postgres_password)
N8N_DB=$(cat /run/secrets/postgres_db)

# Create the user and grant privileges
psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    CREATE USER ${N8N_USER} WITH PASSWORD '${N8N_PASSWORD}';
    CREATE DATABASE ${N8N_DB};
    GRANT ALL PRIVILEGES ON DATABASE ${N8N_DB} TO ${N8N_USER};
    ALTER DATABASE ${N8N_DB} OWNER TO ${N8N_USER};
EOSQL

echo "n8n database user created successfully!"