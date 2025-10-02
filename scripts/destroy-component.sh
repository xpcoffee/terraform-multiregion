#!/bin/bash

# Destroy a single stamp with tfvars file
# Usage: destroy-component.sh <stamp> <region> <stage> <backend-stage>

set -e

STAMP=$1
REGION=$2
STAGE=$3
BACKEND_STAGE=$4

if [ -z "$STAMP" ] || [ -z "$REGION" ] || [ -z "$STAGE" ] || [ -z "$BACKEND_STAGE" ]; then
    echo "Usage: $0 <stamp> <region> <stage> <backend-stage>"
    echo "Example: $0 cluster us-east-1 dev dev"
    exit 1
fi

STAMP_DIR="stamps/${STAMP}"
TFVARS_FILE="deployments/${REGION}-${STAGE}-${STAMP}.tfvars"
BACKEND_CONFIG="${STAMP_DIR}/backend-${BACKEND_STAGE}.hcl"

if [ ! -d "$STAMP_DIR" ]; then
    echo "Error: Stamp directory $STAMP_DIR not found"
    exit 1
fi

if [ ! -f "$TFVARS_FILE" ]; then
    echo "Error: tfvars file $TFVARS_FILE not found"
    exit 1
fi

if [ ! -f "$BACKEND_CONFIG" ]; then
    echo "Error: Backend config $BACKEND_CONFIG not found"
    exit 1
fi

cd "$STAMP_DIR"

echo "Initializing ${STAMP}..."
terraform init -reconfigure -backend-config="backend-${BACKEND_STAGE}.hcl"

echo "Destroying ${STAMP}..."
terraform destroy -var-file="../../deployments/${REGION}-${STAGE}-${STAMP}.tfvars" -auto-approve

cd - > /dev/null

echo "✓ ${STAMP} destroyed"
