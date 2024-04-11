keyvault_url := env('KEYVAULT_URL')

flux-check:
    flux check --pre

flux-bootstrap: flux-check
    sops --decrypt cluster/cluster-secrets.yaml | kubectl apply -f -
    flux bootstrap github \
        --owner=luander \
        --repository=k3s-cluster \
        --path=cluster/base \
        --personal \
        --private=false \
        --network-policy=false
