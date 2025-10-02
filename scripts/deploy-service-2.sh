#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <stage>"
    echo "Regions: us-east-1, us-west-2, eu-west-1"
    echo "Stages: dev, prod"
    exit 1
fi

REGION=$1
STAGE=$2
CLUSTER_NAME="cluster-${REGION}-${STAGE}"

valid_regions=("us-east-1" "us-west-2" "eu-west-1")
valid_stages=("dev" "prod")

if [[ ! " ${valid_regions[@]} " =~ " ${REGION} " ]]; then
    echo "Error: Invalid region. Valid regions are: ${valid_regions[*]}"
    exit 1
fi

if [[ ! " ${valid_stages[@]} " =~ " ${STAGE} " ]]; then
    echo "Error: Invalid stage. Valid stages are: ${valid_stages[*]}"
    exit 1
fi

echo "Deploying service-2 to region: ${REGION}, stage: ${STAGE}"
echo "Target cluster: ${CLUSTER_NAME}"

kind get kubeconfig --name="${CLUSTER_NAME}" > /tmp/kubeconfig-${CLUSTER_NAME}
export KUBECONFIG="/tmp/kubeconfig-${CLUSTER_NAME}"

kubectl config current-context

NAMESPACE="app-${STAGE}"

echo "Checking if namespace ${NAMESPACE} exists..."
if ! kubectl get namespace "${NAMESPACE}" &> /dev/null; then
    echo "Error: Namespace ${NAMESPACE} does not exist. Please run 'terraform apply' first."
    exit 1
fi

echo "Restarting service-2 deployment..."
kubectl rollout restart deployment/service-2 -n "${NAMESPACE}"

echo "Waiting for service-2 rollout to complete..."
kubectl rollout status deployment/service-2 -n "${NAMESPACE}" --timeout=300s

echo "Getting service-2 pods status..."
kubectl get pods -n "${NAMESPACE}" -l app=service-2

echo "Service-2 deployment completed successfully!"
echo "You can check the service with: kubectl get service service-2 -n ${NAMESPACE}"