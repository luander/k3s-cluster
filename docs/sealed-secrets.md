# Sealed Secrets

!!! note "Work in progress"
    This document is a work in progress.

## Install the CLI tool

```sh
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.15.0/kubeseal-linux-amd64 -O kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```

## Install the cluster components

```yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: sealed-secrets
  namespace: kube-system
spec:
  interval: 5m
  chart:
    spec:
      chart: sealed-secrets
      version: 1.13.2
      sourceRef:
        kind: HelmRepository
        name: sealed-secrets-charts
        namespace: flux-system
      interval: 5m
  values:
    ingress:
      enabled: false
```

## Fetch the Sealed Secrets public certificate

```sh
kubeseal \
    --controller-name sealed-secrets \
    --fetch-cert > ./sealed-secrets-public-cert.pem
```

## Creating the sealed secret

```sh
kubectl create secret generic prometheus-alertmanager-secret --dry-run=client --from-file=values.yml=projects/personal/k3s-cluster/cluster/monitoring/prometheus/helm-values-secret.txt -n monitoring -o yaml > unsealed-secret.yml
```
```sh
kubeseal --cert ./sealed-secrets-public-cert.pem -o yaml < unsealed-secret.yml > sealed-secret.yml
```
