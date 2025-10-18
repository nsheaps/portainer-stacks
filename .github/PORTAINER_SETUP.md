# Portainer Stack Automation Setup

This GitHub Actions workflow automatically manages Portainer stacks by:
1. **Creating stacks** when they don't exist (currently not implemented)
2. **Triggering redeploy** when stacks already exist and files change
3. **Sending webhooks** to notify of stack updates

## Required Secrets

Add these secrets to your GitHub repository:

### Required Secrets
- `PORTAINER_URL`: Your Portainer instance URL (e.g., `https://portainer.yourdomain.com`)
- `PORTAINER_API_TOKEN`: Portainer API token with sufficient permissions

### Optional Secrets
- `STACK_WEBHOOK_URL`: URL to receive webhook notifications when stacks are updated

## Setup Instructions

### 1. Generate Portainer API Token

1. Log in to your Portainer instance
2. Go to **User settings** (top-right menu)
3. Select **API** tab
4. Click **+ Add API token**
5. Give it a descriptive name (e.g., "GitHub Actions Stack Manager")
6. Select appropriate access rights:
   - **Stacks**: Read/Write access
   - **Endpoints**: Read/Write access (if managing multiple endpoints)
7. Copy the generated token (it will only be shown once!)

### 2. Add Repository Secrets

In your GitHub repository:
1. Go to **Settings** > **Secrets and variables** > **Actions**
2. Click **New repository secret**
3. Add the following secrets:
   - `PORTAINER_URL`
   - `PORTAINER_API_TOKEN`
   - `STACK_WEBHOOK_URL` (optional)

### 3. Configure Stack Detection

The workflow automatically detects stack files by:
- Looking for `docker-compose.yaml` files in the `hosts/` directory
- Using the directory name as the stack name
  - Example: `hosts/heapsnas/nextcloud/docker-compose.yaml` → stack name: `nextcloud`

### 4. Manual Testing

You can test the workflow manually:
1. Go to **Actions** tab in your repository
2. Select "Manage Portainer Stacks" workflow
3. Click **Run workflow** > **Run workflow**

## Current Limitations

- **Stack creation**: Currently only handles updating existing stacks
- **Error handling**: Basic error handling, may need enhancement for production
- **Rate limiting**: Consider adding delays for bulk operations
- **Security**: API tokens have broad access - consider creating restricted tokens

## Webhook Payload

When webhooks are enabled, they'll send JSON like:
```json
{
  "stack_name": "nextcloud",
  "stack_id": 123,
  "action": "redeploy",
  "status": "success"
}
```

## Security Notes

- Rotate your API tokens regularly
- Use the principle of least privilege for API token permissions
- Consider using environment-specific tokens if managing multiple environments
- Monitor webhook usage and security