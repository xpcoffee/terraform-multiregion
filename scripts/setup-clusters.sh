#!/bin/bash

set -e

echo "Setting up all clusters and deploying infrastructure..."

echo "Initializing Terraform..."
terraform init

echo ""
echo "Deploying all region-stage environments:"
echo "  - us-east-1-dev (port 30000)"
echo "  - us-east-1-prod (port 30001)"
echo "  - us-west-2-dev (port 30100)"
echo "  - us-west-2-prod (port 30101)"
echo "  - eu-west-1-dev (port 30200)"
echo "  - eu-west-1-prod (port 30201)"

echo ""
for deployment in us-east-1-dev us-east-1-prod us-west-2-dev us-west-2-prod eu-west-1-dev eu-west-1-prod; do
    echo "Applying deployment: ${deployment}"
    terraform apply -var-file="deployments/${deployment}.tfvars" -auto-approve
    echo "Deployment ${deployment} completed!"
    echo ""
done

echo "Listing all created KIND clusters:"
kind get clusters

echo ""
echo "Setup complete! All region-stage clusters have been deployed."
echo ""
echo "Each cluster contains:"
echo "  - Kubernetes namespace (app-<stage>)"
echo "  - PostgreSQL database"
echo "  - Service-1 (nginx)"
echo "  - Service-2 (httpd)"
