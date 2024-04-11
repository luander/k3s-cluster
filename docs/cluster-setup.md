## 1Password and bootstrap
Secrets needed to bootstrap the cluster are stored in 1Password. Therefore first step is to install 1Password for Desktop and the CLI:

```
brew install --cask 1password-cli
```

And then authenticate to the accout and trigger the bootstrap process:

```
op run --env-file="./.env" -- just
```

## Project structure
I've added some scripts to install a K3s cluster and provision it from scratch.
Some important directories/files on this project are:

- `.env`: contains definitions of variables that instructs 1Password to load.
- `ansible`: mainly cluster bootstraping
- `cluster`: GitOps to deploy applications in the cluster
- `justfile` and `.justfiles`: I'm testing [just](https://just.systems/man/en/chapter_1.html) as a task executor. Runs all the steps needed to fully bootstrap a cluster.
