#!/bin/bash
set -euo pipefail

export APPLICATIONINSIGHTS_CONNECTION_STRING="$(terraform -chdir=../../infra output -raw application_insights_connection_string)"

helm uninstall opentelemetry-collector --namespace opentelemetry-collector

envsubst < secret.yaml | kubectl delete -f -
