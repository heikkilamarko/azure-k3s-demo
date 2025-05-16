#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

image_tag="$1"

docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/web-api:$image_tag src
docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/web-api-migrations:$image_tag migrations

az acr login -n crk3sdemo

docker push --platform linux/amd64 crk3sdemo.azurecr.io/web-api:$image_tag
docker push --platform linux/amd64 crk3sdemo.azurecr.io/web-api-migrations:$image_tag
