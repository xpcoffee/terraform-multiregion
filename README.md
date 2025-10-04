# Terraform Multi-Region Infrastructure

A multi-region, multi-stage Kubernetes infrastructure using KIND clusters with a stamp-based architecture. Each stamp (cluster, postgres, service) can be deployed independently with separate state management per region-stage-service combination.

## Architecture

```
├── deployments/              # Deployment configurations (one per region-stage-service)
│   └── us-east-1-dev-cluster.tfvars
├── modules/                  # Reusable Terraform modules
│   ├── kind-cluster/
│   ├── postgres/
│   ├── service-1/
│   └── service-2/
├── stamps/                   # Infrastructure stamps
│   ├── cluster/
│   ├── postgres/
│   ├── service-1/
│   └── service-2/
└── scripts/                  # Deployment orchestration
    ├── deploy-stack.sh
    ├── destroy-stack.sh
    ├── deploy-component.sh
    └── destroy-component.sh
```

**Key Concepts:**
- **Stamps**: Independent infrastructure components that can be deployed separately
- **Modules**: Reusable Terraform code defining resources
- **Deployments**: Configuration files per region-stage-service combination
- **State Management**: Each region-stage-service gets its own state file (e.g., `cluster-us-east-1-dev.tfstate`)

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)

## Quick Start

### Deploy Full Stack

```bash
# Deploy complete stack for us-east-1 dev
./scripts/deploy-stack.sh us-east-1 dev
```

This deploys in order:
1. Cluster (KIND cluster + namespace)
2. PostgreSQL database
3. Service-1 (nginx)
4. Service-2 (httpd)

### Destroy Full Stack

```bash
./scripts/destroy-stack.sh us-east-1 dev
```

### Deploy Individual Stamps

```bash
# Deploy just the cluster
./scripts/deploy-component.sh cluster us-east-1 dev dev

# Deploy just postgres (requires cluster)
./scripts/deploy-component.sh postgres us-east-1 dev dev

# Deploy just service-1 (requires cluster and postgres)
./scripts/deploy-component.sh service-1 us-east-1 dev dev
```

## Adding New Regions or Services

1. **Create tfvars file** in `deployments/`:
   ```bash
   cp deployments/us-east-1-dev-cluster.tfvars deployments/us-west-2-dev-cluster.tfvars
   # Edit with new region values
   ```

2. **Deploy**:
   ```bash
   ./scripts/deploy-stack.sh us-west-2 dev
   ```

State files are automatically created per region-stage-service combination.

## Benefits

- **Independent Deployment**: Each stamp deploys independently with its own state
- **Multi-Region**: Same code deploys to multiple regions with different configs
- **Team Ownership**: Different teams can own different stamps
- **No Backend Config Files Needed**: State paths are computed dynamically from deployment parameters

## Verification

```bash
# List all KIND clusters
docker ps

# View deployed resources
export KUBECONFIG=stamps/cluster/cluster-us-east-1-dev-config
kubectl get all -n app-dev
```
