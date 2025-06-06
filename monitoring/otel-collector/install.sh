#!/bin/bash
set -euo pipefail

export APPLICATIONINSIGHTS_CONNECTION_STRING="$(terraform -chdir=../../infra output -raw application_insights_connection_string)"

envsubst < secret.yaml | kubectl apply -f -

helm install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --namespace opentelemetry-collector \
  --values values.yaml
