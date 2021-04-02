# External Secrets

!!! note "Work in progress"
    This document is a work in progress.

## Create secret for External Secrets using AWS Secrets Manager

```sh
kubectl create secret generic azkv-credentials \
    --from-literal=tenant_id="tenant-id" \
    --from-literal=client_id="client-id" \
    --from-literal=client_secret="client-secret" \
    --namespace kube-system
```

kubectl create secret generic openvpn \
    --from-literal=username="WovDo4ZZLmZr9ABKPmqUmrU5" \
    --from-literal=password="ft16ky3FX3HHodGBvTWR7civ" \
    --namespace media

## Create a secret using aws-cli

```sh
az keyvault secret set --vault-name "keyvaultname" \
    --name "secret-name" \
    --value "secret-data"
```
