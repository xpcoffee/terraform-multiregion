#!/bin/bash

set -e

echo "Cleaning up all Terraform Stack resources..."

echo "Destroying all Stack deployments..."
for deployment in us-east-1-dev us-east-1-prod us-west-2-dev us-west-2-prod eu-west-1-dev eu-west-1-prod; do
    echo "Destroying deployment: ${deployment}"
    terraform destroy -var-file="deployments/${deployment}.tfvars" -auto-approve
    echo "Deployment ${deployment} destroyed successfully!"
    echo ""
done

echo "Removing any remaining KIND clusters..."
for region in us-east-1 us-west-2 eu-west-1; do
    for stage in dev prod; do
        cluster_name="cluster-${region}-${stage}"
        if kind get clusters | grep -q "^${cluster_name}$"; then
            echo "Deleting cluster: ${cluster_name}"
            kind delete cluster --name="${cluster_name}"
        fi
    done
done

echo "Cleanup completed!"