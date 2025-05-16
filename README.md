# portainer-stacks

Portainer-stacks is a project used for syncing with a Portainer instance to update containers remotely.

## How-to

In `hosts/`, each folder relates to a specific host. Within that is one or more docker-compose files for containers deployed to those hosts via [portainer](github.com/portainer/portainer).

For validation purposes, each compose file must end in `-compose.yaml` or `-compose.yml`, otherwise docker will not be able to properly parse that yaml file.

### Setting up portainer

If needed, run through this to install: https://docs.portainer.io/start/install-ce/server/docker/linux#deployment

> [!NOTE]
> Portainer by default runs the web UI on port 9000. That may be in use, I suggest using 10201

Set up a stack to poll using authenticated requests from this repo: https://docs.portainer.io/user/docker/stacks

## Examples

Find example stacks here: https://github.com/portainer/templates/tree/master/stacks

A super basic example can be found in hosts/\_example/docker-compose.yaml

## Development quickstart

To install and use the tools in this project, you can use the following steps:

```bash
gh repo clone nsheaps/portainer-stacks ~/src/portainer-stacks || true
cd ~/src/portainer-stacks
corepack enable && corepack install
yarn install
```

## Command reference

| Script               | Description                                       |
| -------------------- | ------------------------------------------------- |
| `yarn run check`     | Checks linting, formatting, types (if applicable) |
| `yarn run check:fix` | Runs checks, autofixing where possible            |
