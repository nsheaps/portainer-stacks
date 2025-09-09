# n8n on heapsnas with 1Password Integration

This configuration deploys n8n with PostgreSQL and Redis, using 1Password CLI to securely manage secrets without storing them in plaintext.

## Architecture

- **1Password CLI Init Container**: Fetches secrets at startup
- **PostgreSQL**: Database backend for n8n
- **Redis**: Queue backend for n8n workers
- **n8n**: Main workflow automation service
- **n8n-worker**: Background job processor

## Prerequisites

1. 1Password Service Account with access to the required secrets
2. Portainer installed and configured
3. Docker and Docker Compose

## Setup Instructions

### 1. Create 1Password Items

Create the following items in your 1Password vault (e.g., "Infrastructure" vault):

- `n8n-heapsnas` item with fields:
  - `postgres_root_user`: Root PostgreSQL username (e.g., `postgres`)
  - `postgres_root_password`: Strong password for root user
  - `postgres_db`: Database name (e.g., `n8n`)
  - `postgres_user`: n8n database user (e.g., `n8n_user`)
  - `postgres_password`: Strong password for n8n user
  - `n8n_encryption_key`: Random 32-character string for encrypting credentials

### 2. Create 1Password Service Account

1. Go to 1Password.com → Developer Tools → Service Accounts
2. Create a new service account
3. Grant read access to the vault containing your n8n secrets
4. Copy the service account token (starts with `ops_`)

### 3. Configure in Portainer

#### Method 1: Stack Environment Variables (Recommended)

1. In Portainer, go to Stacks → Add Stack
2. Name: `heapsnas-n8n`
3. Repository URL: Point to this repository
4. Compose path: `hosts/heapsnas/docker-compose.yaml`
5. Environment variables:
   ```
   OP_SERVICE_ACCOUNT_TOKEN=ops_YOUR_TOKEN_HERE
   N8N_PORT=5678
   ```

#### Method 2: Portainer Secrets

1. Go to Secrets in Portainer
2. Create a new secret named `op_service_account_token`
3. Paste your 1Password service account token
4. Update `docker-compose.yaml` to use the secret:
   ```yaml
   services:
     secrets-init:
       secrets:
         - op_service_account_token
       environment:
         - OP_SERVICE_ACCOUNT_TOKEN_FILE=/run/secrets/op_service_account_token
   ```

### 4. Update 1Password References

Edit `scripts/fetch-secrets.sh` and update the 1Password references to match your vault structure:

```bash
# Example format: op://vault-name/item-name/field-name
op read "op://Infrastructure/n8n-heapsnas/postgres_root_user" > /secrets/postgres_root_user
```

### 5. Deploy the Stack

1. In Portainer, deploy the stack
2. The init container will run first to fetch secrets
3. PostgreSQL and Redis will start
4. n8n and n8n-worker will start once dependencies are healthy

## Security Considerations

1. **Service Account Token**: 
   - Never commit the token to git
   - Rotate tokens regularly
   - Use least-privilege access (read-only to specific vaults)

2. **Secrets Volume**:
   - Uses tmpfs (RAM-based) storage
   - Automatically cleared on container restart
   - Not persisted to disk

3. **Network Isolation**:
   - Services communicate via Docker internal network
   - Only n8n port is exposed externally

## Troubleshooting

### Init Container Fails

Check logs: `docker logs heapsnas-n8n-secrets-init-1`

Common issues:
- Missing or invalid `OP_SERVICE_ACCOUNT_TOKEN`
- Incorrect 1Password references in `fetch-secrets.sh`
- Network connectivity to 1Password.com

### PostgreSQL Connection Issues

- Ensure secrets are correctly extracted
- Check PostgreSQL logs for authentication errors
- Verify database initialization script ran successfully

### n8n Cannot Start

- Check encryption key is exactly 32 characters
- Verify all required environment variables are set
- Check n8n logs: `docker logs heapsnas-n8n-n8n-1`

## Maintenance

### Updating Secrets

1. Update the secret in 1Password
2. Restart the stack in Portainer
3. The init container will fetch the new secrets

### Backup

Important data locations:
- PostgreSQL data: `/var/lib/docker/volumes/heapsnas-n8n_db_storage`
- n8n workflows: `/var/lib/docker/volumes/heapsnas-n8n_n8n_storage`
- Redis data: `/var/lib/docker/volumes/heapsnas-n8n_redis_storage`

### Monitoring

- Health checks are configured for all services
- View status in Portainer dashboard
- n8n provides metrics at `http://heapsnas:5678/healthz`

## Additional Configuration

For advanced n8n configuration, you can add more environment variables to the `x-shared` section. See [n8n documentation](https://docs.n8n.io/hosting/configuration/environment-variables/) for available options.