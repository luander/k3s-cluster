# Gemini Project Context: k3s-cluster

This repository is a declarative GitOps management system for a home Kubernetes cluster (k3s), heavily inspired by the [home-ops](https://github.com/onedr0p/home-ops) community.

## Project Overview

- **Architecture:** Multi-architecture cluster consisting of Raspberry Pi 4 (ARM64) and Intel NUC (AMD64) nodes.
- **Provisioning:** [Ansible](./ansible/) is used for the initial OS preparation and k3s installation.
- **GitOps:** [FluxCD](./cluster/base/flux-system/) manages the cluster state by synchronizing manifests from the `cluster/` directory.
- **Secret Management:** [SOPS](https://github.com/mozilla/sops) with **Azure KeyVault** for encrypting sensitive data in the repository. [1Password CLI](https://developer.1password.com/docs/cli/) is used for initial bootstrap secrets.
- **Task Runner:** [just](https://github.com/casey/just) is used to automate common operations.

## Key Technologies

- **Kubernetes:** k3s (v1.25+)
- **GitOps:** FluxCD (Kustomize & Helm Controllers)
- **Infrastructure:** Ansible, Python 3
- **Automation:** Justfile
- **Secrets:** SOPS, Azure KeyVault, 1Password
- **Storage:** Longhorn, NFS Subdir External Provisioner
- **Networking**: Ingress-Nginx (migrating to Envoy Gateway), Cert-Manager, External-DNS

## Envoy Gateway Migration (In Progress)

The cluster is migrating from `ingress-nginx` to **Envoy Gateway v1.7.0**.

### Side-by-Side Strategy
Both controllers are running concurrently for zero-downtime testing:
- **Ingress-Nginx**: Standard ports (80/443).
- **Envoy Gateway**: Testing ports (**8080/8443**).

### Technical Specifications
- **Envoy Gateway**: v1.7.0
- **Gateway API CRDs**: v1.4.1
- **TLS**: Standardized on v1.2/1.3 with wildcard certificate re-use.
- **Real IP**: Cloudflare `CF-Connecting-IP` header detection enabled.

### Verification Checklist
- [ ] Test all services on port 8443 (e.g., `https://grafana.luander.net:8443`).
- [ ] Verify OIDC/AzureAD callbacks (Grafana `root_url` updated to port 8443).
- [ ] Monitor Envoy metrics via the new `ServiceMonitor` in `networking`.

## Building and Running


Common tasks are managed via `just`. It is recommended to run them through 1Password for secret injection:

```bash
op run --env-file="./.env" -- just <command>
```

### Core Commands

- `just`: Default task that runs `install`, `apply`, `kubeconfig`, and `flux-bootstrap`.
- `just apply`: Runs the Ansible playbook to install or update the k3s cluster.
- `just flux-bootstrap`: Bootstraps FluxCD onto the cluster and applies initial secrets.
- `just kubeconfig`: Configures the local `kubectl` context for the cluster.
- `just ping`: Uses Ansible to ping all nodes in the inventory.
- `just venv`: Sets up the local Python virtual environment and installs Ansible requirements.

## Directory Structure

- `ansible/`: Ansible playbooks, roles, and inventory for cluster lifecycle management.
- `cluster/`:
    - `base/`: Entry point for FluxCD, defines core Kustomizations (`apps`, `core`, `crds`).
    - `core/`: Infrastructure components (cert-manager, external-secrets, storage).
    - `apps/`: User applications (home-assistant, media stack, monitoring, networking).
    - `crds/`: Custom Resource Definitions managed as a separate stage.
- `docs/`: Supplemental documentation for specific components (Airflow, SOPS, etc.).
- `.justfiles/`: Modularized task definitions for `just`.

## Development Conventions

### Secret Management
- **Never** commit plain-text secrets.
- Use `sops` to encrypt files. The configuration is defined in `.sops.yaml`.
- Cluster-wide variables are stored in `cluster/cluster-secrets.yaml` and are available for substitution in Flux Kustomizations via `postBuild` specs.

### FluxCD Workflow
- Flux watches the `cluster/` directory.
- Changes pushed to `main` are automatically reconciled.
- The deployment order is generally: `crds` -> `core` -> `apps`.

### Ansible Usage
- Ansible is primarily for node-level configuration and k3s installation.
- Use the provided virtual environment: `source .venv/bin/activate`.
- Inventory is located at `ansible/inventory.yaml`.
