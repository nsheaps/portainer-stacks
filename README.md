# portainer-stacks

Portainer-stacks is a project used for syncing with a Portainer instance to update containers remotely.

## Prettier Job in Check Workflow

A new job named `prettier` has been added to the check workflow. This job uses `prettier/prettier-action@v1.0.0` to check and format YAML files in the repository. The job is configured to run on `ubuntu-latest`.

## Running Prettier Locally

To run Prettier locally, you can use the following command:

```sh
yarn run prettier --check "**/*.yaml"
```

## Installation and Usage

To install and use the tools in this project, you can use the following steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/nsheaps/portainer-stacks.git
   cd portainer-stacks
   ```

2. Install the dependencies:
   ```sh
   yarn install
   ```

3. Run the package scripts using the following commands:

| Script       | Description                                      |
|--------------|--------------------------------------------------|
| `yarn run check` | Run the check workflow                           |
| `yarn run prettier` | Run Prettier locally                           |
| `yarn run sync`  | Sync with Portainer instance                     |
