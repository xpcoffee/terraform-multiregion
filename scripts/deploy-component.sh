#!/bin/bash

# Deploy a single stamp with tfvars file
# Usage: deploy-component.sh <stamp> <region> <stage>

set -e

STAMP=$1
REGION=$2
STAGE=$3

if [ -z "$STAMP" ] || [ -z "$REGION" ] || [ -z "$STAGE" ]; then
    echo "Usage: $0 <stamp> <region> <stage>"
    echo "Example: $0 cluster us-east-1 dev"
    exit 1
fi

STAMP_DIR="stamps/${STAMP}"
TFVARS_FILE="deployments/${REGION}-${STAGE}-${STAMP}.tfvars"
STATE_PATH="states/${STAMP}-${REGION}-${STAGE}.tfstate"

if [ ! -d "$STAMP_DIR" ]; then
    echo "Error: Stamp directory $STAMP_DIR not found"
    exit 1
fi

if [ ! -f "$TFVARS_FILE" ]; then
    echo "Error: tfvars file $TFVARS_FILE not found"
    exit 1
fi

cd "$STAMP_DIR"

echo "Initializing ${STAMP}..."
terraform init -reconfigure -backend-config="path=${STATE_PATH}"

echo "Applying ${STAMP}..."
terraform apply -var-file="../../deployments/${REGION}-${STAGE}-${STAMP}.tfvars" -auto-approve

cd - > /dev/null

echo "✓ ${STAMP} deployed"
