#!/bin/bash
set -euo pipefail

export IMAGE_TAG="$1"

envsubst < keycloak.yaml | kubectl apply -f -

sudo sed -i '' '/keycloak.local/d' /etc/hosts
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) keycloak.local" >> /etc/hosts'
