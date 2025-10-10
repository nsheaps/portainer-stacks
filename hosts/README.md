Proposed host setup (one site can have multiple h

- [optional] One stack to initialize a volume with the contents of this repository
  - Used to share scripts into containers
  - **CONSIDER THIS ALTERNATIVE:** Inline the script using a heredoc into the docker-compose file to prevent needing an additional volume to hold the details of the script (and if they're separate it might not trigger a reload if the file contents changes)
- One stack for each data backend needed for that site
  - Don't use the default init options, make the init part of the apps, so the app stack is totally independent of the data backend
- One stack for each app
  - Include a secrets fetching job that fetches ONLY the needed secrets
    - NOTE: App does not redeploy when secrets change.
