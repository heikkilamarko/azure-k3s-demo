#!/bin/bash
set -euo pipefail

helm uninstall opentelemetry-collector --namespace opentelemetry-collector || true

applicationinsights_connection_string="$(terraform -chdir=../../infra output -raw application_insights_connection_string)"

export APPLICATIONINSIGHTS_CONNECTION_STRING="$applicationinsights_connection_string"

envsubst < secret.yaml | kubectl apply -f -

helm install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --namespace opentelemetry-collector \
  --create-namespace \
  --values values.yaml
