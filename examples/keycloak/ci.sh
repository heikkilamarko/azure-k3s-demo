#!/bin/bash
set -euo pipefail

image_tag="$1"

docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/keycloak:$image_tag .

az acr login -n crk3sdemo

docker push --platform linux/amd64 crk3sdemo.azurecr.io/keycloak:$image_tag
