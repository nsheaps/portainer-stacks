# portainer-stacks

Portainer-stacks is a project used for syncing with a Portainer instance to update containers remotely.

## Development quickstart

To install and use the tools in this project, you can use the following steps:

```bash
gh repo clone nsheaps/portainer-stacks ~/src/portainer-stacks || true
cd ~/src/portainer-stacks
corepack enable && corepack install
yarn install
```

## Command reference

| Script       | Description                                      |
|--------------|--------------------------------------------------|
| `yarn run check` | Checks linting, formatting, types (if applicable) |
| `yarn run check:fix` | Runs checks, autofixing where possible |
