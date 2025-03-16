#!/bin/bash
set -euo pipefail

customer_id="$(terraform -chdir=../../infra output -raw log_analytics_workspace_id)"
shared_key="$(terraform -chdir=../../infra output -raw log_analytics_workspace_shared_key)"

export CUSTOMER_ID="$customer_id"
export SHARED_KEY="$shared_key"

envsubst < values.template.yaml > values.yaml

helm uninstall vector --namespace vector || true

helm install vector vector/vector \
  --namespace vector \
  --create-namespace \
  --values values.yaml
