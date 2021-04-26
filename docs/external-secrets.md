# External Secrets

!!! note "Work in progress"
    This document is a work in progress.

## Create secret for External Secrets using AWS Secrets Manager

```sh
kubectl create secret generic azkv-credentials \
    --from-literal=AZURE_TENANT_ID="tenant-id" \
    --from-literal=AZURE_CLIENT_ID="client-id" \
    --from-literal=AZURE_CLIENT_SECRET="client-secret" \
    --namespace kube-system
```

## Create a secret using aws-cli

```sh
az keyvault secret set --vault-name "keyvaultname" \
    --name "secret-name" \
    --value "secret-data"
```
