#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <deployment>"
    echo ""
    echo "Available deployments:"
    echo "  us-east-1-dev"
    echo "  us-east-1-prod"
    echo "  us-west-2-dev"
    echo "  us-west-2-prod"
    echo "  eu-west-1-dev"
    echo "  eu-west-1-prod"
    echo ""
    echo "Example: $0 us-east-1-dev"
    exit 1
fi

DEPLOYMENT=$1

valid_deployments=("us-east-1-dev" "us-east-1-prod" "us-west-2-dev" "us-west-2-prod" "eu-west-1-dev" "eu-west-1-prod")

if [[ ! " ${valid_deployments[@]} " =~ " ${DEPLOYMENT} " ]]; then
    echo "Error: Invalid deployment. Valid deployments are: ${valid_deployments[*]}"
    exit 1
fi

TFVARS_FILE="deployments/${DEPLOYMENT}.tfvars"

if [ ! -f "$TFVARS_FILE" ]; then
    echo "Error: Deployment configuration file $TFVARS_FILE not found."
    exit 1
fi

echo "Deploying Terraform Stack: ${DEPLOYMENT}"
echo "Using configuration: ${TFVARS_FILE}"

echo "Initializing Terraform..."
terraform init

echo "Planning deployment..."
terraform plan -var-file="$TFVARS_FILE"

echo "Applying deployment..."
terraform apply -var-file="$TFVARS_FILE" -auto-approve

echo ""
echo "Deployment ${DEPLOYMENT} completed successfully!"

# Extract cluster info from tfvars
CLUSTER_NAME=$(grep 'cluster_name' "$TFVARS_FILE" | cut -d'"' -f2)
REGION=$(grep 'region' "$TFVARS_FILE" | cut -d'"' -f2)
STAGE=$(grep 'stage' "$TFVARS_FILE" | cut -d'"' -f2)

echo "Cluster: ${CLUSTER_NAME}"
echo "Region: ${REGION}"
echo "Stage: ${STAGE}"
echo ""
echo "To access this cluster:"
echo "  kind get kubeconfig --name=${CLUSTER_NAME} > /tmp/kubeconfig-${CLUSTER_NAME}"
echo "  export KUBECONFIG=/tmp/kubeconfig-${CLUSTER_NAME}"
echo "  kubectl get all -n app-${STAGE}"