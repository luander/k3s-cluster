# Mozilla SOPS
sops is an editor of encrypted files that supports YAML, JSON, ENV, INI and BINARY formats and encrypts with AWS KMS, GCP KMS, Azure Key Vault, age, and PGP.

## Install sops
```bash
brew install sops
```

## Azure Key Vault Setup

### Create a service principal:
```
az ad sp create-for-rbac -n home-kubernetes-sops --skip-assignment
{
        "appId": "<some-uuid>",
        "displayName": "home-kubernetes-sops",
        "name": "http://home-kubernetes-sops",
        "password": "<some-uuid>",
        "tenant": "<tenant-id>"
}
```
The `--skip-assignment` is important here as we don't want the service principal to be assigned the default contributor role to the subscription.

### Create the Key Vault
```
keyvault_name=sops-$(uuidgen | tr -d - | head -c 16)
rg=kubernetes-rg
az keyvault create --name $keyvault_name --resource-group $rg --location westeurope
az keyvault key create --name sops-key --vault-name $keyvault_name --protection software --ops encrypt decrypt
az keyvault set-policy --name $keyvault_name --resource-group $rg --spn $AZURE_CLIENT_ID \
        --key-permissions encrypt decrypt

az keyvault key show --name sops-key --vault-name $keyvault_name --query key.kid
```

### Encrypt a file with SOPS
```
export key_url=`az keyvault key show --name sops-key --vault-name $keyvault_name --query key.kid`
sops --encrypt --azure-kv $key_url test.yaml > test.enc.yaml
```
