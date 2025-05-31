#!/bin/bash
set -euo pipefail

keycloak_version="$1"

kubectl delete -f "$keycloak_version/keycloak.yaml"

sudo sed -i '' '/keycloak.test/d' /etc/hosts
