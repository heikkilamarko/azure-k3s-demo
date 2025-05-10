#!/bin/bash
set -euo pipefail

image="crk3sdemo.azurecr.io/postgresql:$1"

docker build --platform linux/amd64 -t $image .

az acr login -n crk3sdemo

docker push --platform linux/amd64 $image
