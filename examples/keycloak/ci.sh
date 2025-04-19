#!/bin/bash
set -euo pipefail

keycloak_version="$1"

docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/keycloak:$keycloak_version $keycloak_version

az acr login -n crk3sdemo

docker push --platform linux/amd64 crk3sdemo.azurecr.io/keycloak:$keycloak_version
