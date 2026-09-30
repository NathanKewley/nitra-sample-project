#!/bin/bash
# Runs after services-prod/rg-application-01/app deploys. az already targets that configuration's
# subscription, and the NITRA_* variables describe the deployment. Read only, it changes nothing
set -euo pipefail

echo "Storage accounts in $NITRA_RESOURCE_GROUP ($NITRA_SUBSCRIPTION):"
az storage account list --resource-group "$NITRA_RESOURCE_GROUP" \
  --query "[].{name:name, publicNetworkAccess:publicNetworkAccess, minimumTlsVersion:minimumTlsVersion}" \
  --output table
