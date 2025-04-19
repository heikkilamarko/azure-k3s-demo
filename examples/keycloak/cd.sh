#!/bin/bash
set -euo pipefail

keycloak_version="$1"

export IMAGE_TAG="$keycloak_version"

envsubst < "$keycloak_version/keycloak.yaml" | kubectl apply -f -

sudo sed -i '' '/keycloak.local/d' /etc/hosts
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) keycloak.local" >> /etc/hosts'
