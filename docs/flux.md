# Flux

## Install the CLI tool

```sh
# if you're feeling adventurous
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
```

Install flux completion by appending the following line to `.zshrc`:
```sh
command -v flux >/dev/null && . <(flux completion zsh) && compdef _flux flux
```

## Install the cluster components

### Dependencies
Two secrets are needed to be configured to the cluster before bootstrapping Flux:

```
azkv-credentials: used by external secrets operator
```

sops-secret: use by sops

```bash
kubectl create secret generic sops-secret -n flux-system \
    --from-literal AZURE_TENANT_ID=tenant_id \
    --from-literal AZURE_CLIENT_ID=client_id \
    --from-literal AZURE_CLIENT_SECRET=secret
```

Both secrets should have the following data:

```
AZURE_TENANT_ID
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
```

_For full installation guide visit the [Flux installation guide](https://toolkit.fluxcd.io/guides/installation/)_

Set the `GITHUB_TOKEN` environment variable to a personal access token you created in Github.
To generate a personal access token follow the [official guide here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
```sh
export GITHUB_TOKEN=<gh-token>
```

Check if you cluster is ready for Flux

```sh
flux check --pre
```

Install Flux into your cluster

```sh
flux bootstrap github \
  --version=0.13.1 \
  --owner=luander \
  --repository=k3s-cluster \
  --path=cluster/base \
  --personal \
  --private=false \
  --network-policy=false
```

**Note**: When using k3s I found that the network-policy flag has to be set to false, or Flux will not work

## Node label
For each worker node, make sure you label them as worker:
```
kubectl label node nodeX node-role.kubernetes.io/worker="true"
```
This is necessary so that node-feature-discovery correctly configures labels on nodes, think Plex support with intel GPUs.

## Useful commands

Force flux to sync your repository:

```sh
flux reconcile source git flux-system
```

Force flux to sync a helm release:

```sh
flux reconcile helmrelease sonarr -n default
```

Force flux to sync a helm repository:

```sh
flux reconcile source helm ingress-nginx-charts -n flux-system
```
