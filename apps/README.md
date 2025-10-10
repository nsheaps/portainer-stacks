This folder contains docker compose stacks for re-use between hosts.

To use, [include](https://docs.docker.com/compose/how-tos/multiple-compose-files/include/) the app file by adding this to the host-specific compose file:

```yaml
# hosts/HOSTNAME/STACKNAME/docker-compose.yaml
include:
 - ../../../apps/APPNAME/docker-compose.yaml
```

They can ONLY be re-used if ALL values are the same.
