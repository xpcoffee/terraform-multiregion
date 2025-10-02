#!/bin/bash

set -e

# Usage: ./scripts/destroy-stack.sh us-east-1 dev

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <stage>"
    echo "Example: $0 us-east-1 dev"
    exit 1
fi

REGION=$1
STAGE=$2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Destroying full stack for ${REGION}-${STAGE}"
echo "==========================================="
echo ""

# Destroy in reverse order

# Destroy service-2 (Service team 2)
echo "Step 1/4: Destroying service-2 stamp..."
"${SCRIPT_DIR}/destroy-component.sh" service-2 "${REGION}" "${STAGE}" "${STAGE}" || true
echo ""

# Destroy service-1 (Service team 1)
echo "Step 2/4: Destroying service-1 stamp..."
"${SCRIPT_DIR}/destroy-component.sh" service-1 "${REGION}" "${STAGE}" "${STAGE}" || true
echo ""

# Destroy postgres (Database team)
echo "Step 3/4: Destroying PostgreSQL stamp..."
"${SCRIPT_DIR}/destroy-component.sh" postgres "${REGION}" "${STAGE}" "${STAGE}" || true
echo ""

# Destroy cluster (Platform team)
echo "Step 4/4: Destroying cluster stamp..."
"${SCRIPT_DIR}/destroy-component.sh" cluster "${REGION}" "${STAGE}" "${STAGE}" || true
echo ""

echo "==========================================="
echo "Destruction complete for ${REGION}-${STAGE}!"
