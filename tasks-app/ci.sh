#!/bin/bash
set -euo pipefail

docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/tasks-app:latest src
docker build --platform linux/amd64 -t crk3sdemo.azurecr.io/tasks-app-migrations:latest migrations

az acr login -n crk3sdemo

docker push --platform linux/amd64 crk3sdemo.azurecr.io/tasks-app:latest
docker push --platform linux/amd64 crk3sdemo.azurecr.io/tasks-app-migrations:latest
