#!/bin/bash

set -e

# Usage: ./scripts/deploy-stack.sh us-east-1 dev

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <stage>"
    echo "Example: $0 us-east-1 dev"
    exit 1
fi

REGION=$1
STAGE=$2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Deploying full stack for ${REGION}-${STAGE}"
echo "==========================================="
echo ""

# Deploy cluster (Platform team)
echo "Step 1/4: Deploying cluster stamp..."
"${SCRIPT_DIR}/deploy-component.sh" cluster "${REGION}" "${STAGE}"
echo ""

# Deploy postgres (Database team)
echo "Step 2/4: Deploying PostgreSQL stamp..."
"${SCRIPT_DIR}/deploy-component.sh" postgres "${REGION}" "${STAGE}"
echo ""

# Deploy service-1 (Service team 1)
echo "Step 3/4: Deploying service-1 stamp..."
"${SCRIPT_DIR}/deploy-component.sh" service-1 "${REGION}" "${STAGE}"
echo ""

# Deploy service-2 (Service team 2)
echo "Step 4/4: Deploying service-2 stamp..."
"${SCRIPT_DIR}/deploy-component.sh" service-2 "${REGION}" "${STAGE}"
echo ""

echo "==========================================="
echo "Deployment complete for ${REGION}-${STAGE}!"
echo ""
echo "Each stamp uses the same code with different state files:"
echo "  - Cluster: stamps/cluster/states/cluster-${STAGE}.tfstate"
echo "  - Postgres: stamps/postgres/states/postgres-${STAGE}.tfstate"
echo "  - Service-1: stamps/service-1/states/service-1-${STAGE}.tfstate"
echo "  - Service-2: stamps/service-2/states/service-2-${STAGE}.tfstate"
