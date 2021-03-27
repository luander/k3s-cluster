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

_For full installation guide visit the [Flux installation guide](https://toolkit.fluxcd.io/guides/installation/)_

Set the `GITHUB_TOKEN` environment variable to a personal access token you created in Github.
To generate a personal access token follow the [official guide here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
```sh
export GITHUB_TOKEN=47241b5a1f9cc45cc7388cf787fc6abacf99eb70
```

Check if you cluster is ready for Flux

```sh
flux check --pre
```

Install Flux into your cluster

```sh
flux bootstrap github \
  --owner=luander \
  --repository=k3s-cluster \
  --path=cluster \
  --personal \
  --network-policy=false
```

**Note**: When using k3s I found that the network-policy flag has to be set to false, or Flux will not work

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