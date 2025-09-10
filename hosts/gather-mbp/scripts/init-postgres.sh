#!/bin/bash
set -e

# This script runs inside the postgres container during initialization
# It creates the non-root user for n8n using secrets mounted in the container

trap "sleep 5" exit

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

echo "Waiting for ${N8N_DB} db and ${N8N_USER} user to be ready (5s)..."
pg_isready -h localhost -U "${N8N_USER}" -d "${N8N_DB}" -t 5
echo "PostgreSQL is ready!"

echo "n8n database user created successfully!"
